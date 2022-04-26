<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xlink="http://www.w3.org/1999/xlink"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:functx="http://www.functx.com" 
xmlns:doc="http://www.pnp-software.com/XSLTdoc" xmlns:opfun="http://data.europa.eu/p27/ted-xml-data-converter"
xmlns:ted="http://publications.europa.eu/resource/schema/ted/R2.0.9/publication" xmlns:n2016="http://publications.europa.eu/resource/schema/ted/2016/nuts" 
xmlns:efbc="http://data.europa.eu/p27/eforms-ubl-extension-basic-components/1" xmlns:efac="http://data.europa.eu/p27/eforms-ubl-extension-aggregate-components/1" xmlns:efext="http://data.europa.eu/p27/eforms-ubl-extensions/1" xmlns:pin="urn:oasis:names:specification:ubl:schema:xsd:PriorInformationNotice-2" xmlns:cn="urn:oasis:names:specification:ubl:schema:xsd:ContractNotice-2" xmlns:can="urn:oasis:names:specification:ubl:schema:xsd:ContractAwardNotice-2"
xmlns:ccts="urn:un:unece:uncefact:documentation:2" xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
xmlns:gc="http://docs.oasis-open.org/codelist/ns/genericode/1.0/"
exclude-result-prefixes="xlink xs xsi fn functx doc opfun ted gc n2016 pin cn can ccts " 
>
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>


<!-- ADDRESSES -->

<!-- #### DEDUPLICATE AND ASSIGN ID TO EACH TED XML ADDRESS ELEMENTS #### -->

<!-- Create temporary XML structure to hold all the TED address elements, with the XPath for each -->
<xsl:variable name="ted-addresses" as="element()">
	<ted-orgs>
		<xsl:for-each select="$ted-form-main-element/(ted:CONTRACTING_BODY/(ted:ADDRESS_CONTRACTING_BODY | ted:ADDRESS_CONTRACTING_BODY_ADDITIONAL | ted:ADDRESS_FURTHER_INFO | ted:ADDRESS_PARTICIPATION) | ted:COMPLEMENTARY_INFO/(ted:ADDRESS_REVIEW_BODY | ted:ADDRESS_MEDIATION_BODY | ted:ADDRESS_REVIEW_INFO) | ted:AWARD_CONTRACT/ted:AWARDED_CONTRACT/ted:CONTRACTORS/ted:CONTRACTOR/(ted:ADDRESS_CONTRACTOR | ted:ADDRESS_PARTY))">
			<ted-org>
				<xsl:variable name="path" select="functx:path-to-node-with-pos(.)"/>
				<path><xsl:value-of select="$path"/></path>
				<ted-address>
					<xsl:for-each select="*">
						<xsl:copy-of select="." copy-namespaces="no"/>
					</xsl:for-each>
				</ted-address>
			</ted-org>
		</xsl:for-each>
	</ted-orgs>
</xsl:variable>

<!-- Create temporary XML structure to hold the UNIQUE (using deep-equal) addresses in TED XML. Each xml structure includes the XPATH of all source TED addresses that are the same address -->
<xsl:variable name="ted-addresses-unique" as="element()">
	<ted-orgs>
	<xsl:for-each select="$ted-addresses//ted-org">
		<xsl:variable name="pos" select="fn:position()"/>
		<xsl:variable name="this-address" as="element()" select="ted-address"/>
		<!-- find if any preceding addresses are deep-equal to this one -->
		<xsl:variable name="prevsame">
			<xsl:for-each select="./preceding-sibling::ted-org">
				<xsl:if test="fn:deep-equal(ted-address, $this-address)">
					<xsl:value-of select="'same'"/>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<data><xsl:value-of select="$pos"/><xsl:text>:</xsl:text><xsl:value-of select="$prevsame"/></data>
		<!-- if no preceding addresses are deep-equal to this one, then ... -->
		<xsl:if test="$prevsame = ''">
			<ted-org>
			<!-- get list of paths of addresses, this one and following, that are deep-equal to this one -->
			<path><xsl:sequence select="fn:string(path)"/></path>
			<xsl:for-each select="./following-sibling::ted-org">
				<xsl:if test="fn:deep-equal(ted-address, $this-address)">
					<path><xsl:sequence select="fn:string(path)"/></path>
				</xsl:if>
			</xsl:for-each>
			<!-- copy the address -->
			<xsl:copy-of select="ted-address"/>
			</ted-org>
		</xsl:if>
	</xsl:for-each>
	</ted-orgs>
</xsl:variable>

<!-- create temporary XML structure that is a copy of the UNIQUE addresses in TED XML, and assign a unique identifier to each (OPT-200, "Organization Technical Identifier") -->
<xsl:variable name="ted-addresses-unique-with-id" as="element()">
	<ted-orgs>
	<xsl:for-each select="$ted-addresses-unique//ted-org">
		<ted-org>
			<xsl:variable name="typepos" select="functx:pad-integer-to-length((fn:count(./preceding-sibling::ted-org) + 1), 3)"/>
			<orgid><xsl:text>ORG-</xsl:text><xsl:value-of select="$typepos"/></orgid>
			<xsl:copy-of select="type"/>
			<xsl:copy-of select="path"/>
			<xsl:copy-of select="ted-address"/>
		</ted-org>
	</xsl:for-each>
	</ted-orgs>
</xsl:variable>




<!-- Create efac:Organizations structure -->

<xsl:template name="organizations">
<xsl:comment> efac:Organizations here </xsl:comment>
<xsl:variable name="is-joint-procurement" select="fn:boolean(ted:CONTRACTING_BODY/ted:JOINT_PROCUREMENT_INVOLVED)"/>
<xsl:variable name="is-central-purchasing" select="fn:boolean(ted:CONTRACTING_BODY/ted:CENTRAL_PURCHASING)"/>
<efac:Organizations>
	<!-- there are no F##_2014 forms that do not have ADDRESS_CONTRACTING_BODY -->
	<xsl:for-each select="$ted-addresses-unique-with-id//ted-org/ted-address">
		<efac:Organization>
			<!-- Organization Subrole (BT-770) : Group leader (Buyer)-->
			<xsl:comment>Organization Subrole (BT-770) : Group leader (Buyer)</xsl:comment>
			<!-- efbc:GroupLeadIndicator, used for joint procurement, only on Contracting Body addresses -->
			<xsl:if test="$is-joint-procurement and (../path[fn:contains(., 'ADDRESS_CONTRACTING_BODY')])">
				<efbc:GroupLeadIndicator>
					<xsl:choose>
						<xsl:when test="../path[fn:contains(., 'ADDRESS_CONTRACTING_BODY_ADDITIONAL')]">false</xsl:when>
						<xsl:otherwise>true</xsl:otherwise>
					</xsl:choose>
				</efbc:GroupLeadIndicator>
			</xsl:if>
			<!-- Organization Role : Acquiring CPB -->
			<xsl:comment>Organization Role : Acquiring CPB</xsl:comment>
			<!-- efbc:AcquiringCPBIndicator, used for central purchasing, only on Contracting Body addresses -->
			<!-- For Acquiring CPB, the element "efbc:AcquiringCPBIndicator" must either be omitted for all Buyers, or included for all Buyers, at least one of which should have the value "true". -->
			<xsl:if test="$is-central-purchasing and (../path[fn:contains(., 'ADDRESS_CONTRACTING_BODY')])">
				<efbc:AcquiringCPBIndicator>
					<xsl:choose>
						<xsl:when test="../path[fn:contains(., 'ADDRESS_CONTRACTING_BODY_ADDITIONAL')]">false</xsl:when>
						<xsl:otherwise>true</xsl:otherwise>
					</xsl:choose>
				</efbc:AcquiringCPBIndicator>
			</xsl:if>
			<xsl:call-template name="org-address"/>
		</efac:Organization>
	</xsl:for-each>
</efac:Organizations>
<!--
These instructions can be un-commented to show the variables holding the organization addresses at intermediate stages
<xsl:copy-of select="$ted-addresses"/>
<xsl:copy-of select="$ted-addresses-unique"/>
<xsl:copy-of select="$ted-addresses-unique-with-id"/>
-->

</xsl:template>


<!-- Create efac:Company structure -->

<xsl:template name="org-address">
	<efac:Company>
		<!-- Organization Internet Address (BT-505) cardinality ? Optional for ALL subtypes -->
		<xsl:comment>Organization Internet Address (BT-505)</xsl:comment>
		<xsl:apply-templates select="ted:URL_GENERAL|ted:URL"/>
		<!-- Need to investigate purpose and meaning of element URL_BUYER in addresses not CONTRACTING_BODY -->
		<!-- Organization Technical Identifier (OPT-200) cardinality ? -->
		<xsl:comment>Organization Technical Identifier (OPT-200)</xsl:comment>
		<cac:PartyIdentification><cbc:ID schemeName="organization"><xsl:value-of select="../orgid"/></cbc:ID></cac:PartyIdentification>
		<!-- Organization Name (BT-500) cardinality ? Optional for ALL subtypes -->
		<xsl:comment>Organization Name (BT-500)</xsl:comment>
		<xsl:apply-templates select="ted:OFFICIALNAME"/>
		<xsl:call-template name="address"/>
		<!-- Organization Identifier (BT-501) Optional for ALL subtypes -->
		<xsl:comment>Organization Identifier (BT-501)</xsl:comment>
		<xsl:apply-templates select="ted:NATIONALID"/>
		<xsl:call-template name="contact"/>	
	</efac:Company>
</xsl:template>

<!-- Create cac:PostalAddress structure -->

<xsl:template name="address">
	<cac:PostalAddress>
		<!-- Organization Street (BT-510) cardinality ? Optional for ALL subtypes -->
		<xsl:comment>Organization Street (BT-510)</xsl:comment>
		<xsl:apply-templates select="ted:ADDRESS"/>
		<!-- Organization City (BT-513) cardinality ? Optional for ALL subtypes -->
		<xsl:comment>Organization City (BT-513)</xsl:comment>
		<xsl:apply-templates select="ted:TOWN"/>
		<!-- Organization Post Code (BT-512) cardinality ? Optional for ALL subtypes -->
		<xsl:comment>Organization Post Code (BT-512)</xsl:comment>
		<xsl:apply-templates select="ted:POSTAL_CODE"/>
		<!-- Organization Country Subdivision (BT-507) cardinality ? Optional for ALL subtypes -->
		<xsl:comment>Organization Country Subdivision (BT-507)</xsl:comment>
		<xsl:apply-templates select="n2016:NUTS"/>
		<!-- Organization Country Code (BT-514) cardinality ? Optional for ALL subtypes -->
		<xsl:comment>Organization Country Code (BT-514)</xsl:comment>
		<xsl:apply-templates select="ted:COUNTRY"/>
	</cac:PostalAddress>
</xsl:template>

<!-- Create cac:PostalAddress structure -->

<xsl:template name="contact">
	<xsl:if test="ted:PHONE|ted:FAX|ted:E_MAIL|ted:CONTACT_POINT">
		<cac:Contact>
			<!-- Organization Contact Point (BT-502) cardinality ? Optional for ALL subtypes -->
			<xsl:comment>Organization Contact Point (BT-502)</xsl:comment>
			<xsl:apply-templates select="ted:CONTACT_POINT"/>
			<!-- Organization Contact Telephone Number (BT-503) cardinality ? Optional for ALL subtypes -->
			<xsl:comment>Organization Contact Telephone Number (BT-503)</xsl:comment>
			<xsl:apply-templates select="ted:PHONE"/>
			<!-- Organization Contact Fax (BT-739) cardinality ? Optional for ALL subtypes -->
			<xsl:comment>Organization Contact Fax (BT-739)</xsl:comment>
			<xsl:apply-templates select="ted:FAX"/>
			<!-- Organization Contact Email Address (BT-506) cardinality ? Optional for ALL subtypes -->
			<xsl:comment>Organization Contact Email Address (BT-506)</xsl:comment>
			<xsl:apply-templates select="ted:E_MAIL"/>
		</cac:Contact>
	</xsl:if>
</xsl:template>





<!-- Create cac:ContractingParty structure -->

<xsl:template match="ted:ADDRESS_CONTRACTING_BODY|ted:ADDRESS_CONTRACTING_BODY_ADDITIONAL">
	<xsl:variable name="path" select="functx:path-to-node-with-pos(.)"/>
	<cac:ContractingParty>
		<!-- Buyer Profile URL (BT-508) -->
		<xsl:comment>Buyer Profile URL (BT-508)</xsl:comment>
		<xsl:apply-templates select="ted:URL_BUYER"/>
		<!-- Buyer Legal Type (BT-11) and Buyer Contracting Entity (BT-740) -->
		<xsl:comment>Buyer Legal Type (BT-11) and Buyer Contracting Entity (BT-740)</xsl:comment>
		<xsl:apply-templates select="../(ted:CA_TYPE|CA_TYPE_OTHER)"/>
		<!-- Activity Authority (BT-10) Mandatory for PIN subtypes 1, 4, and 7, CN subtypes 10, 16, and 23, CAN subtypes 29 and 36; Forbidden for CN subtype 22, CM subtypes 38-40; Optional for other subtypes -->
		<!-- Activity Entity (BT-610) Mandatory for PIN subtypes 2, 5, and 8, CN subtypes 11, 15, 17, and 24, CAN subtypes 30 and 37; Optional for PIN subtypes 3, 6, 9, E1, and E2, CN subtypes 13, 14, 18, 19, 21, and E3, CAN subtypes 26-28, 31, 32, 34, 35, and E4, CM subtype E5; Forbidden for other subtypes -->
		<!-- Activity Authority (BT-10) and Activity Entity (BT-610) both are implemented as code values from a codelist -->
		<!-- NOTE: TED elements CA_ACTIVITY_OTHER and CA_TYPE_OTHER contain text values in multiple languages. They cannot be converted to a codelist code value -->
		<!-- NOTE: CA_ACTIVITY_OTHER and CA_TYPE_OTHER cannot be converted -->
		<xsl:comment>Activity Authority (BT-10) and Activity Entity (BT-610)</xsl:comment>
		<xsl:apply-templates select="../ted:CA_ACTIVITY|../ted:CE_ACTIVITY"/>
		<cac:Party>
			<!-- Buyer Technical Identifier Reference (OPT-300) -->
			<xsl:comment>Buyer Technical Identifier Reference (OPT-300)</xsl:comment>
			<!-- Reference (Technical ID) to the legal organization acting as a Buyer. -->
			<cac:PartyIdentification>
				<cbc:ID schemeName="organization"><xsl:value-of select="$ted-addresses-unique-with-id//ted-org/path[.=$path]/../orgid"/></cbc:ID>
			</cac:PartyIdentification>
			<!-- The service provider is a Procurement Service Provider -->
			<!-- Reference (Technical ID) to the legal organization acting as a PSP. -->
			<xsl:comment>Reference (Technical ID) to the legal organization acting as a PSP.</xsl:comment>
			<!-- The service provider is an eSender -->
			<xsl:comment>The service provider is an eSender</xsl:comment>
			<!-- Reference (Tech. ID) to the legal organization acting as an eSender. -->
			<xsl:comment>Reference (Tech. ID) to the legal organization acting as an eSender.</xsl:comment>
			<xsl:comment>Service Provider Technical Identifier Reference (OPT-300)</xsl:comment>
			<!-- Reference (Technical ID) to the legal organization acting as a Buyer. -->
			<xsl:comment>Reference (Technical ID) to the legal organization acting as a Buyer.</xsl:comment>
			<!-- Service Provider Technical Identifier Reference (OPT-300) -->
			<xsl:comment>Service Provider Technical Identifier Reference (OPT-300)</xsl:comment>
			<!-- Reference (Technical ID) to the legal organization acting as a Buyer. -->
			<xsl:comment>Reference (Technical ID) to the legal organization acting as a Buyer.</xsl:comment>
		</cac:Party>
	</cac:ContractingParty>
</xsl:template>


<!-- Create cac:ContractingPartyType structures -->

<xsl:template match="ted:CA_TYPE">
	<xsl:variable name="ca-type" select="@VALUE"/>
	<xsl:variable name="buyer-legal-type" select="$mappings//ca-types/mapping[ted-value=$ca-type]/fn:string(eforms-value)"/>
	<!-- Buyer Legal Type (BT-11) Mandatory for PIN subtypes 1, 4, and 7, CN subtypes 10, 14, 16, 19, and 23, CAN subtypes 29, 32, 35, and 36; Forbidden for CM subtypes 38-40; Optional for other subtypes -->
	<xsl:comment>Buyer Legal Type (BT-11)</xsl:comment>
	<cac:ContractingPartyType>
		<cbc:PartyType listName="buyer-legal-type"><xsl:value-of select="$buyer-legal-type"/></cbc:PartyType>
	</cac:ContractingPartyType>
	<!-- Buyer Contracting Entity (BT-740) Optional for PIN subtypes 3, 6, 9, E1, and E2, CN subtypes 14, 18, 19, and E3, CAN subtypes 27, 28, 31, 32, 35, and E4, CM subtype E5; Forbidden for other subtypes -->
	<xsl:comment>Buyer Contracting Entity (BT-740)</xsl:comment>
	<!-- Buyer Contracting Entity (BT-740) Optional for PIN subtypes 3, 6, 9, E1, and E2, CN subtypes 14, 18, 19, and E3, CAN subtypes 27, 28, 31, 32, 35, and E4, CM subtype E5; Forbidden for other subtypes -->
	<xsl:variable name="message">WARNING: "Buyer contracting type" codelist not yet available. Value "not-cont-ent" used as a default</xsl:variable>
	<xsl:comment><xsl:value-of select="$message"/></xsl:comment>
	<xsl:message terminate="no"><xsl:value-of select="$message"/></xsl:message>
	<cac:ContractingPartyType>
		<cbc:PartyType listName="buyer-contracting-type"><xsl:value-of select="'not-cont-ent'"/></cbc:PartyType>
	</cac:ContractingPartyType>
</xsl:template>

<!-- Create cac:ContractingActivity structures -->

<xsl:template match="ted:CA_ACTIVITY">
	<xsl:variable name="ca-activity" select="@VALUE"/>
	<xsl:variable name="authority-activity-type" select="$mappings//authority-activity-types/mapping[ted-value=$ca-activity]/fn:string(eforms-value)"/>
	<!-- Activity Authority (BT-10) Mandatory for PIN subtypes 1, 4, and 7, CN subtypes 10, 16, and 23, CAN subtypes 29 and 36; Forbidden for CN subtype 22, CM subtypes 38-40; Optional for other subtypes -->
	<xsl:comment>Activity Authority (BT-10)</xsl:comment>
	<cac:ContractingActivity>
		<cbc:ActivityTypeCode listName="authority-activity"><xsl:value-of select="$authority-activity-type"/></cbc:ActivityTypeCode>
	</cac:ContractingActivity>
</xsl:template>

<xsl:template match="ted:CE_ACTIVITY">
	<xsl:variable name="ce-activity" select="@VALUE"/>
	<xsl:variable name="entity-activity-type" select="$mappings//entity-activity-types/mapping[ted-value=$ce-activity]/fn:string(eforms-value)"/>
	<!-- Activity Entity (BT-610) Mandatory for PIN subtypes 2, 5, and 8, CN subtypes 11, 15, 17, and 24, CAN subtypes 30 and 37; Optional for PIN subtypes 3, 6, 9, E1, and E2, CN subtypes 13, 14, 18, 19, 21, and E3, CAN subtypes 26-28, 31, 32, 34, 35, and E4, CM subtype E5; Forbidden for other subtypes -->
	<xsl:comment>Activity Entity (BT-610)</xsl:comment>
	<cac:ContractingActivity>
		<cbc:ActivityTypeCode listName="entity-activity"><xsl:value-of select="$entity-activity-type"/></cbc:ActivityTypeCode>
	</cac:ContractingActivity>
</xsl:template>


<!-- Create cac:AdditionalInformationParty structure -->

<xsl:template match="ted:ADDRESS_FURTHER_INFO">
	<xsl:variable name="orgid" select="$ted-addresses-unique-with-id//ted-org/path[fn:ends-with(., 'ADDRESS_FURTHER_INFO')]/../orgid"/>
	<cac:AdditionalInformationParty>
		<cac:PartyIdentification>
			<cbc:ID schemeName="organization"><xsl:value-of select="$orgid"/></cbc:ID>
		</cac:PartyIdentification>
	</cac:AdditionalInformationParty>
</xsl:template>

<!-- Create cac:AppealInformationParty structure -->
<xsl:template match="ted:ADDRESS_REVIEW_INFO">
	<xsl:variable name="orgid" select="$ted-addresses-unique-with-id//ted-org/path[fn:ends-with(., 'ADDRESS_REVIEW_INFO')]/../orgid"/>
	<cac:AppealInformationParty>
		<cac:PartyIdentification>
			<cbc:ID schemeName="organization"><xsl:value-of select="$orgid"/></cbc:ID>
		</cac:PartyIdentification>
	</cac:AppealInformationParty>
</xsl:template>

<!-- Create cac:AppealReceiverParty structure -->
<xsl:template match="ted:ADDRESS_REVIEW_BODY">
	<xsl:variable name="orgid" select="$ted-addresses-unique-with-id//ted-org/path[fn:ends-with(., 'ADDRESS_REVIEW_BODY')]/../orgid"/>
	<cac:AppealReceiverParty>
		<cac:PartyIdentification>
			<cbc:ID schemeName="organization"><xsl:value-of select="$orgid"/></cbc:ID>
		</cac:PartyIdentification>
	</cac:AppealReceiverParty>
</xsl:template>

<!-- Create cac:MediationParty structure -->
<xsl:template match="ted:ADDRESS_MEDIATION_BODY">
	<xsl:variable name="orgid" select="$ted-addresses-unique-with-id//ted-org/path[fn:ends-with(., 'ADDRESS_MEDIATION_BODY')]/../orgid"/>
	<cac:MediationParty>
		<cac:PartyIdentification>
			<cbc:ID schemeName="organization"><xsl:value-of select="$orgid"/></cbc:ID>
		</cac:PartyIdentification>
	</cac:MediationParty>
</xsl:template>

<!-- Create cac:PartyIdentification structure -->
<xsl:template match="ted:ADDRESS_PARTICIPATION">
	<xsl:variable name="orgid" select="$ted-addresses-unique-with-id//ted-org/path[fn:ends-with(., 'ADDRESS_PARTICIPATION')]/../orgid"/>
	<cac:PartyIdentification>
		<cbc:ID schemeName="organization"><xsl:value-of select="$orgid"/></cbc:ID>
	</cac:PartyIdentification>
</xsl:template>

<xsl:template match="ted:ADDRESS_PARTICIPATION_IDEM">
	<xsl:variable name="orgid" select="$ted-addresses-unique-with-id//ted-org/path[fn:ends-with(., 'ADDRESS_CONTRACTING_BODY')]/../orgid"/>
	<cac:PartyIdentification>
		<cbc:ID schemeName="organization"><xsl:value-of select="$orgid"/></cbc:ID>
	</cac:PartyIdentification>
</xsl:template>

</xsl:stylesheet>
