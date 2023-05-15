<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xlink="http://www.w3.org/1999/xlink"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:doc="http://www.pnp-software.com/XSLTdoc"
xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:functx="http://www.functx.com" xmlns:opfun="http://data.europa.eu/p27/ted-xml-data-converter"
xmlns:ted="http://publications.europa.eu/resource/schema/ted/R2.0.8/publication" xmlns:ted-2="ted/R2.0.8.S03/publication"
xmlns:n2016="http://publications.europa.eu/resource/schema/ted/2016/nuts" xmlns:n2021="http://publications.europa.eu/resource/schema/ted/2021/nuts" xmlns:n2016-1="ted/2016/nuts"
xmlns:pin="urn:oasis:names:specification:ubl:schema:xsd:PriorInformationNotice-2" xmlns:cn="urn:oasis:names:specification:ubl:schema:xsd:ContractNotice-2" xmlns:can="urn:oasis:names:specification:ubl:schema:xsd:ContractAwardNotice-2"
xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"
xmlns:efbc="http://data.europa.eu/p27/eforms-ubl-extension-basic-components/1" xmlns:efac="http://data.europa.eu/p27/eforms-ubl-extension-aggregate-components/1" xmlns:efext="http://data.europa.eu/p27/eforms-ubl-extensions/1"
xmlns:ccts="urn:un:unece:uncefact:documentation:2" xmlns:gc="http://docs.oasis-open.org/codelist/ns/genericode/1.0/"
exclude-result-prefixes="xlink xs xsi fn functx doc opfun ted ted-2 gc n2016 n2016-1 n2021 pin cn can ccts ext" >
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>


<!-- ADDRESSES -->

<!-- #### DEDUPLICATE AND ASSIGN ID TO EACH TED XML ADDRESS ELEMENTS #### -->

<!-- Create temporary XML structure to hold all the TED address elements, with the XPath for each -->
<xsl:variable name="ted-addresses" as="element()">
	<ted-orgs>
		<xsl:for-each select="($ted-form-authority-element/(*/(*:CA_CE_CONCESSIONAIRE_PROFILE|*:FURTHER_INFORMATION/*:CONTACT_DATA[*])|*/*:PURCHASING_ON_BEHALF/*:PURCHASING_ON_BEHALF_YES/*:CONTACT_DATA_OTHER_BEHALF_CONTRACTING_AUTORITHY)|$ted-form-complementary-element/*:INFORMATION_REGULATORY_FRAMEWORK/(*:TAX_LEGISLATION|*:ENVIRONMENTAL_PROTECTION_LEGISLATION|*:EMPLOYMENT_PROTECTION_WORKING_CONDITIONS)/*:CONTACT_DATA[*])">
			<ted-org>
				<xsl:variable name="path" select="functx:path-to-node-with-pos(.)"/>
				<path><xsl:value-of select="$path"/></path>
				<ted-address>
					<xsl:for-each select="*">
						<xsl:copy-of select="." copy-namespaces="no"/>
					</xsl:for-each>
					<xsl:copy-of select="../*[fn:contains(fn:local-name(), 'INTERNET_ADDRESSES')]" copy-namespaces="no"/>
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
				<xsl:variable name="typepos" select="functx:pad-integer-to-length((fn:count(./preceding-sibling::ted-org) + 1), 4)"/>
				<orgid><xsl:text>ORG-</xsl:text><xsl:value-of select="$typepos"/></orgid>
				<xsl:copy-of select="path"/>
				<xsl:copy-of select="ted-address"/>
			</ted-org>
		</xsl:for-each>
	</ted-orgs>
</xsl:variable>

<!-- Create efac:Organizations structure -->
<xsl:template name="organizations">
<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="' efac:Organizations '"/></xsl:call-template>
<xsl:variable name="is-central-purchasing" select="fn:boolean(.//*:PURCHASING_ON_BEHALF_YES)"/>

<efac:Organizations>
	<!-- there are no F##_2014 forms that do not have ADDRESS_CONTRACTING_BODY -->
	<xsl:for-each select="$ted-addresses-unique-with-id//ted-org/ted-address">
		<efac:Organization>
			<!-- Organization Subrole (BT-770) : Group leader (Buyer)-->
			<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Organization Subrole (BT-770) : Group leader (Buyer)'"/></xsl:call-template>
			<!-- efbc:GroupLeadIndicator, used for joint procurement, only on Contracting Body addresses -->
			<!--<xsl:if test="$is-joint-procurement and (../path[fn:contains(., 'ADDRESS_CONTRACTING_BODY')])">
				<efbc:GroupLeadIndicator>
					<xsl:choose>
						<xsl:when test="../path[fn:contains(., 'ADDRESS_CONTRACTING_BODY_ADDITIONAL')]">false</xsl:when>
						<xsl:otherwise>true</xsl:otherwise>
					</xsl:choose>
				</efbc:GroupLeadIndicator>
			</xsl:if>-->
			<!-- Organization Role : Acquiring CPB -->
			<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Organization Role : Acquiring CPB'"/></xsl:call-template>
			<!-- efbc:AcquiringCPBIndicator, used for central purchasing, only on Contracting Body addresses -->
			<!-- For Acquiring CPB, the element "efbc:AcquiringCPBIndicator" must either be omitted for all Buyers, or included for all Buyers, at least one of which should have the value "true". -->
			<xsl:if test="$is-central-purchasing and (../path[fn:contains(., 'CA_CE_CONCESSIONAIRE_PROFILE') or fn:contains(., 'CONTACT_DATA_OTHER_BEHALF_CONTRACTING_AUTORITHY')])">
				<efbc:AcquiringCPBIndicator>
					<xsl:choose>
						<xsl:when test="../path[fn:contains(., 'CONTACT_DATA_OTHER_BEHALF_CONTRACTING_AUTORITHY')]">false</xsl:when>
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
		<!-- Organization Internet Address (BT-505): eForms documentation cardinality (Organization) = ? | Optional for ALL subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Organization Internet Address (BT-505)'"/></xsl:call-template>
		<xsl:apply-templates select="*:INTERNET_ADDRESSES_PRIOR_INFORMATION/*:URL_GENERAL|*:INTERNET_ADDRESSES_PRIOR_INFORMATION/*:URL_BUYER|*:URL"/>
		<!-- Winner Size (BT-165): eForms documentation cardinality (Organization) = ? | eForms Regulation Annex requirements = Mandatory (M) for CAN subtypes 29, 30, 32, 33-37; Optional (O or EM or CM) for CAN subtypes 25-28, 31 and E4, CM subtype E5; Forbidden (blank) for all other subtypes | Allowed only for Organisation type Winner or Tenderer -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Winner Size (BT-165)'"/></xsl:call-template>
		<xsl:call-template name="winner-size"/>
		<!-- Organization Technical Identifier (OPT-200) -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Organization Technical Identifier (OPT-200)'"/></xsl:call-template>
		<cac:PartyIdentification><cbc:ID schemeName="organization"><xsl:value-of select="../orgid"/></cbc:ID></cac:PartyIdentification>
		<!-- Organization Name (BT-500): eForms documentation cardinality (Organization) = ? | Optional for ALL subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Organization Name (BT-500)'"/></xsl:call-template>
		<xsl:apply-templates select="*:ORGANISATION/*:OFFICIALNAME"/>
		<xsl:call-template name="address"/>
		<!-- Organization Identifier (BT-501) Optional for ALL subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Organization Identifier (BT-501)'"/></xsl:call-template>
		<xsl:apply-templates select="*:ORGANISATION/*:NATIONALID"/>
		<xsl:call-template name="contact"/>
	</efac:Company>
</xsl:template>

<xsl:template name="winner-size">
		<!-- Winner Size (BT-165): eForms documentation cardinality (Organization) = ? | eForms Regulation Annex requirements = Mandatory (M) for CAN subtypes 29, 30, 32, 33-37; Optional (O or EM or CM) for CAN subtypes 25-28, 31 and E4, CM subtype E5; Forbidden (blank) for all other subtypes | Allowed only for Organisation type Winner or Tenderer -->
		<xsl:if test="../path[fn:ends-with(., 'ADDRESS_CONTRACTOR')]">
			<xsl:choose>
				<xsl:when test="*:SME">
					<efbc:CompanySizeCode listName="economic-operator-size">sme</efbc:CompanySizeCode>
				</xsl:when>
				<xsl:when test="$eforms-notice-subtype = ('29', '30', '32', '33', '34', '35', '36', '37')">
					<!-- WARNING: Winner Size (BT-165) is Mandatory for eForms subtypes 29, 30, 32, 33, 34, 35, 36 and 37 where the Organisation type is Winner or Tenderer, but no equivalent element was found in TED XML. -->
					<xsl:variable name="message">WARNING: Winner Size (BT-165) is Mandatory for eForms subtypes 29, 30, 32, 33, 34, 35, 36 and 37 where the Organisation type is Winner or Tenderer, but no equivalent element was found in TED XML.</xsl:variable>
					<xsl:call-template name="report-warning"><xsl:with-param name="message" select="$message"/></xsl:call-template>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
</xsl:template>

<!-- Create cac:PostalAddress structure -->
<xsl:template name="address">
	<cac:PostalAddress>
		<!-- Organization Street (BT-510): eForms documentation cardinality (Organization) = ? | Optional for ALL subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Organization Street (BT-510)'"/></xsl:call-template>
		<xsl:apply-templates select="*:ADDRESS"/>
		<!-- Organization City (BT-513): eForms documentation cardinality (Organization) = ? | Optional for ALL subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Organization City (BT-513)'"/></xsl:call-template>
		<xsl:apply-templates select="*:TOWN"/>
		<!-- Organization Post Code (BT-512): eForms documentation cardinality (Organization) = ? | Optional for ALL subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Organization Post Code (BT-512)'"/></xsl:call-template>
		<xsl:apply-templates select="*:POSTAL_CODE"/>
		<!-- Organization Country Subdivision (BT-507): eForms documentation cardinality (Organization) = ? | Optional for ALL subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Organization Country Subdivision (BT-507)'"/></xsl:call-template>
		<!-- Convert only NUTS level 3 codes -->
		<xsl:apply-templates select="*:NUTS[opfun:is-valid-nuts-code(@CODE)]"/>
		<!-- Organization Country Code (BT-514): eForms documentation cardinality (Organization) = ? | Optional for ALL subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Organization Country Code (BT-514)'"/></xsl:call-template>
		<xsl:apply-templates select="*:COUNTRY"/>
	</cac:PostalAddress>
</xsl:template>

<!-- Convert two-letter country code in *:COUNTRY to three-letter country code used in eForms -->
<xsl:template match="*:COUNTRY">
	<xsl:variable name="country" select="opfun:get-eforms-country(@VALUE)"/>
	<cac:Country>
		<cbc:IdentificationCode listName="country"><xsl:value-of select="$country"/></cbc:IdentificationCode>
	</cac:Country>
</xsl:template>

<!-- Create cac:PostalAddress structure -->
<xsl:template name="contact">
	<!-- Some ADDRESS_* elements (especially ADDRESS_CONTRACTOR) do not have any "contact" elements -->
	<xsl:choose>
		<xsl:when test="*:PHONE|*:FAX|*:E_MAIL|*:CONTACT_POINT|*:ATTENTION">
			<cac:Contact>
				<!-- Organization Contact Point (BT-502): eForms documentation cardinality (Organization) = ? | Optional for ALL subtypes -->
				<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Organization Contact Point (BT-502)'"/></xsl:call-template>
				<xsl:if test="*:CONTACT_POINT|*:ATTENTION">
					<xsl:call-template name="contact-point-attention"></xsl:call-template>
				</xsl:if>
				<!-- Organization Contact Telephone Number (BT-503): eForms documentation cardinality (Organization) = ? | Optional for ALL subtypes -->
				<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Organization Contact Telephone Number (BT-503)'"/></xsl:call-template>
				<xsl:apply-templates select="*:PHONE"/>
				<!-- Organization Contact Fax (BT-739): eForms documentation cardinality (Organization) = ? | Optional for ALL subtypes -->
				<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Organization Contact Fax (BT-739)'"/></xsl:call-template>
				<xsl:apply-templates select="*:FAX"/>
				<!-- Organization Contact Email Address (BT-506): eForms documentation cardinality (Organization) = ? | Optional for ALL subtypes -->
				<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Organization Contact Email Address (BT-506)'"/></xsl:call-template>
				<xsl:apply-templates select="*:E_MAILS/*:E_MAIL"/>
			</cac:Contact>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Organization Contact Point (BT-502)'"/></xsl:call-template>
			<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Organization Contact Telephone Number (BT-503)'"/></xsl:call-template>
			<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Organization Contact Fax (BT-739)'"/></xsl:call-template>
			<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Organization Contact Email Address (BT-506)'"/></xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Create cac:ContractingParty structure -->
<xsl:template match="*:CA_CE_CONCESSIONAIRE_PROFILE">
	<xsl:variable name="path" select="functx:path-to-node-with-pos(.)"/>
	<cac:ContractingParty>
		<!-- Buyer Profile URL (BT-508) Mandatory for PIN subtypes 1-3; Forbidden for CM subtypes 38-40; Optional for other subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Buyer Profile URL (BT-508)'"/></xsl:call-template>
		<xsl:apply-templates select="../*:INTERNET_ADDRESSES_PRIOR_INFORMATION/*:URL_BUYER"/>
		<!-- Buyer Legal Type (BT-11) Mandatory for PIN subtypes 1, 4, and 7, CN subtypes 10, 14, 16, 19, and 23, CAN subtypes 29, 32, 35, and 36; Forbidden for CM subtypes 38-40; Optional for other subtypes -->
		<xsl:call-template name="buyer-legal-type"/>
		<!-- Buyer Contracting Entity (BT-740) Optional for PIN subtypes 3, 6, 9, E1, and E2, CN subtypes 14, 18, 19, and E3, CAN subtypes 27, 28, 31, 32, 35, and E4, CM subtype E5; Forbidden for other subtypes -->
		<xsl:call-template name="buyer-contracting-entity"/>
		<!-- NOTE: TED elements CA_ACTIVITY_OTHER and CA_TYPE_OTHER contain text values in multiple languages. They cannot be converted to a codelist code value -->
		<!-- Activity Authority (BT-10) Mandatory for PIN subtypes 1, 4, and 7, CN subtypes 10, 16, and 23, CAN subtypes 29 and 36; Forbidden for CN subtype 22, CM subtypes 38-40; Optional for other subtypes -->
		<xsl:call-template name="activity-authority"/>
		
		<!-- Activity Entity (BT-610) Mandatory for PIN subtypes 2, 5, and 8, CN subtypes 11, 15, 17, and 24, CAN subtypes 30 and 37; Optional for PIN subtypes 3, 6, 9, E1, and E2, CN subtypes 13, 14, 18, 19, 21, and E3, CAN subtypes 26-28, 31, 32, 34, 35, and E4, CM subtype E5; Forbidden for other subtypes -->
		<xsl:call-template name="activity-entity"/>
		<cac:Party>
			<!-- Buyer Technical Identifier Reference (OPT-300) -->
			<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Buyer Technical Identifier Reference (OPT-300)'"/></xsl:call-template>
			<!-- Reference (Technical ID) to the legal organization acting as a Buyer. -->
			<cac:PartyIdentification>
				<cbc:ID schemeName="organization"><xsl:value-of select="$ted-addresses-unique-with-id//ted-org/path[.=$path]/../orgid"/></cbc:ID>
			</cac:PartyIdentification>
			<!-- The service provider is a Procurement Service Provider -->
			<!-- Reference (Technical ID) to the legal organization acting as a PSP. -->
			<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Reference (Technical ID) to the legal organization acting as a PSP.'"/></xsl:call-template>
			<!-- The service provider is an eSender -->
			<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'The service provider is an eSender'"/></xsl:call-template>
			<!-- Reference (Tech. ID) to the legal organization acting as an eSender. -->
			<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Reference (Tech. ID) to the legal organization acting as an eSender.'"/></xsl:call-template>
			<!-- Service Provider Technical Identifier Reference (OPT-300) -->
			<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Service Provider Technical Identifier Reference (OPT-300)'"/></xsl:call-template>
			<!-- Reference (Technical ID) to the legal organization acting as a Buyer. -->
			<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Reference (Technical ID) to the legal organization acting as a Buyer.'"/></xsl:call-template>
			<!-- Service Provider Technical Identifier Reference (OPT-300) -->
			<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Service Provider Technical Identifier Reference (OPT-300)'"/></xsl:call-template>
			<!-- Reference (Technical ID) to the legal organization acting as a Buyer. -->
			<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Reference (Technical ID) to the legal organization acting as a Buyer.'"/></xsl:call-template>
		</cac:Party>
	</cac:ContractingParty>
</xsl:template>

<xsl:template name="buyer-legal-type">
	<!-- Buyer Legal Type (BT-11) Mandatory for PIN subtypes 1, 4, and 7, CN subtypes 10, 14, 16, 19, and 23, CAN subtypes 29, 32, 35, and 36; Forbidden for CM subtypes 38-40; Optional for other subtypes -->
	<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Buyer Legal Type (BT-11)'"/></xsl:call-template>
	<xsl:choose>
		<xsl:when test="../../*/*:TYPE_AND_ACTIVITIES/*:TYPE_OF_CONTRACTING_AUTHORITY">
			<xsl:apply-templates select="../../*/*:TYPE_AND_ACTIVITIES/*:TYPE_OF_CONTRACTING_AUTHORITY"/>
		</xsl:when>
		<xsl:when test="../../*/*:TYPE_AND_ACTIVITIES/*:TYPE_OF_CONTRACTING_AUTHORITY_OTHER">
			<xsl:variable name="text" select="fn:normalize-space(../../*/*:TYPE_AND_ACTIVITIES/*:TYPE_OF_CONTRACTING_AUTHORITY_OTHER)"/>
			<!-- WARNING: Buyer Legal Type (BT-11) could not be identified from text content of TYPE_OF_CONTRACTING_AUTHORITY_OTHER in the TED XML. -->
			<xsl:variable name="message">WARNING: Buyer Legal Type (BT-11) could not be identified from text content of TYPE_OF_CONTRACTING_AUTHORITY_OTHER in the TED XML: <xsl:value-of select="$text"/></xsl:variable>
			<xsl:call-template name="report-warning"><xsl:with-param name="message" select="$message"/></xsl:call-template>
		</xsl:when>
		<xsl:when test="($eforms-notice-subtype = ('1','4','7','10','14','16','19','23','29','32','35','36'))">
			<!-- WARNING: Buyer Legal Type (BT-11) is Mandatory for eForms subtypes 1, 4, 7, 10, 14, 16, 19, 23, 29, 32, 35 and 36, but no TYPE_OF_CONTRACTING_AUTHORITY was found in TED XML. -->
			<xsl:variable name="message">WARNING: Buyer Legal Type (BT-11) is Mandatory for eForms subtypes 1, 4, 7, 10, 14, 16, 19, 23, 29, 32, 35 and 36, but no TYPE_OF_CONTRACTING_AUTHORITY was found in TED XML.</xsl:variable>
			<xsl:call-template name="report-warning"><xsl:with-param name="message" select="$message"/></xsl:call-template>
		</xsl:when>
	</xsl:choose>
</xsl:template>

<xsl:template name="buyer-contracting-entity">
	<!-- Buyer Contracting Entity (BT-740) Optional for PIN subtypes 3, 6, 9, E1, and E2, CN subtypes 14, 18, 19, and E3, CAN subtypes 27, 28, 31, 32, 35, and E4, CM subtype E5; Forbidden for other subtypes -->
	<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Buyer Contracting Entity (BT-740)'"/></xsl:call-template>
	<xsl:choose>
		<xsl:when test="../../(*:TYPE_AND_ACTIVITIES_AND_PURCHASING_ON_BEHALF|*:TYPE_AND_ACTIVITIES_OR_CONTRACTING_ENTITY_AND_PURCHASING_ON_BEHALF)/*:TYPE_AND_ACTIVITIES">
			<cac:ContractingPartyType>
				<cbc:PartyTypeCode listName="buyer-contracting-type"><xsl:value-of select="'not-cont-ent'"/></cbc:PartyTypeCode>
			</cac:ContractingPartyType>
		</xsl:when>
		<xsl:when test="../../*:TYPE_AND_ACTIVITIES_OR_CONTRACTING_ENTITY_AND_PURCHASING_ON_BEHALF/*:ACTIVITIES_OF_CONTRACTING_ENTITY">
			<cac:ContractingPartyType>
				<cbc:PartyTypeCode listName="buyer-contracting-type"><xsl:value-of select="'cont-ent'"/></cbc:PartyTypeCode>
			</cac:ContractingPartyType>
		</xsl:when>
	</xsl:choose>
</xsl:template>

<xsl:template name="activity-authority">
	<!-- Activity Authority (BT-10) Mandatory for PIN subtypes 1, 4, and 7, CN subtypes 10, 16, and 23, CAN subtypes 29 and 36; Forbidden for CN subtype 22, CM subtypes 38-40; Optional for other subtypes -->
	<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Activity Authority (BT-10)'"/></xsl:call-template>
	<xsl:choose>
		<xsl:when test="../../*/*:TYPE_AND_ACTIVITIES/*:TYPE_OF_ACTIVITY">
			<xsl:apply-templates select="../../*/*:TYPE_AND_ACTIVITIES/*:TYPE_OF_ACTIVITY"/>
		</xsl:when>
		<xsl:when test="../../*/*:TYPE_AND_ACTIVITIES/*:TYPE_OF_ACTIVITY_OTHER">
			<xsl:variable name="text" select="fn:normalize-space(../../*/*:TYPE_AND_ACTIVITIES/*:TYPE_OF_ACTIVITY_OTHER)"/>
			<!-- WARNING: Activity Authority (BT-10) could not be identified from text content of TYPE_OF_ACTIVITY_OTHER in the TED XML. -->
			<xsl:variable name="message">WARNING: Activity Authority (BT-10) could not be identified from text content of TYPE_OF_ACTIVITY_OTHER in the TED XML: <xsl:value-of select="$text"/></xsl:variable>
			<xsl:call-template name="report-warning"><xsl:with-param name="message" select="$message"/></xsl:call-template>
		</xsl:when>
		<xsl:when test="($eforms-notice-subtype = ('1','4','7','10','16','23','29','36'))">
			<!-- WARNING: Activity Authority (BT-10) is Mandatory for eForms subtypes 1, 4, 7, 10, 16, 23, 29 and 36, but no TYPE_OF_ACTIVITY was found in TED XML. -->
			<xsl:variable name="message">WARNING: Activity Authority (BT-10) is Mandatory for eForms subtypes 1, 4, 7, 10, 16, 23, 29 and 36, but no TYPE_OF_ACTIVITY was found in TED XML.</xsl:variable>
			<xsl:call-template name="report-warning"><xsl:with-param name="message" select="$message"/></xsl:call-template>
		</xsl:when>
	</xsl:choose>
</xsl:template>

<xsl:template name="activity-entity">
	<!-- Activity Entity (BT-610) Mandatory for PIN subtypes 2, 5, and 8, CN subtypes 11, 15, 17, and 24, CAN subtypes 30 and 37; Optional for PIN subtypes 3, 6, 9, E1, and E2, CN subtypes 13, 14, 18, 19, 21, and E3, CAN subtypes 26-28, 31, 32, 34, 35, and E4, CM subtype E5; Forbidden for other subtypes -->
	<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Activity Entity (BT-610)'"/></xsl:call-template>
	<xsl:choose>
		<xsl:when test="../../*/*:ACTIVITIES_OF_CONTRACTING_ENTITY/*:ACTIVITY_OF_CONTRACTING_ENTITY">
			<xsl:apply-templates select="../../*/*:ACTIVITIES_OF_CONTRACTING_ENTITY/*:ACTIVITY_OF_CONTRACTING_ENTITY"/>
		</xsl:when>
		<xsl:when test="../../*/*:ACTIVITIES_OF_CONTRACTING_ENTITY/*:ACTIVITY_OF_CONTRACTING_ENTITY_OTHER">
			<xsl:variable name="text" select="fn:normalize-space(../../*/*:ACTIVITIES_OF_CONTRACTING_ENTITY/*:ACTIVITY_OF_CONTRACTING_ENTITY_OTHER)"/>
			<!-- WARNING: Activity Entity (BT-610) could not be identified from text content of ACTIVITY_OF_CONTRACTING_ENTITY_OTHER in the TED XML. -->
			<xsl:variable name="message">WARNING: Activity Entity (BT-610) could not be identified from text content of ACTIVITY_OF_CONTRACTING_ENTITY_OTHER in the TED XML: <xsl:value-of select="$text"/></xsl:variable>
			<xsl:call-template name="report-warning"><xsl:with-param name="message" select="$message"/></xsl:call-template>
		</xsl:when>
		<xsl:when test="($eforms-notice-subtype = ('2','5','8','11','15','17','24','30','37'))">
			<!-- WARNING: Activity Entity (BT-610) is Mandatory for eForms subtypes 2, 5, 8, 11, 15, 17, 24, 30 and 37, but no ACTIVITY_OF_CONTRACTING_ENTITY was found in TED XML. -->
			<xsl:variable name="message">WARNING: Activity Entity (BT-610) is Mandatory for eForms subtypes 2, 5, 8, 11, 15, 17, 24, 30 and 37, but no ACTIVITY_OF_CONTRACTING_ENTITY was found in TED XML.</xsl:variable>
			<xsl:call-template name="report-warning"><xsl:with-param name="message" select="$message"/></xsl:call-template>
		</xsl:when>
	</xsl:choose>
</xsl:template>

<xsl:template match="*:TYPE_OF_CONTRACTING_AUTHORITY">
	<xsl:variable name="ca-type" select="@VALUE"/>
	<xsl:variable name="buyer-legal-type" select="$mappings//ca-types/mapping[ted-value=$ca-type]/fn:string(eforms-value)"/>
	<cac:ContractingPartyType>
		<cbc:PartyTypeCode listName="buyer-legal-type"><xsl:value-of select="$buyer-legal-type"/></cbc:PartyTypeCode>
	</cac:ContractingPartyType>
</xsl:template>

<xsl:template match="*:TYPE_OF_ACTIVITY">
	<xsl:variable name="ca-activity" select="@VALUE"/>
	<xsl:variable name="authority-activity-type" select="$mappings//authority-activity-types/mapping[ted-value=$ca-activity]/fn:string(eforms-value)"/>
	<cac:ContractingActivity>
		<cbc:ActivityTypeCode listName="authority-activity"><xsl:value-of select="$authority-activity-type"/></cbc:ActivityTypeCode>
	</cac:ContractingActivity>
</xsl:template>

<xsl:template match="*:ACTIVITY_OF_CONTRACTING_ENTITY">
	<xsl:variable name="ce-activity" select="@VALUE"/>
	<xsl:variable name="entity-activity-type" select="$mappings//entity-activity-types/mapping[ted-value=$ce-activity]/fn:string(eforms-value)"/>
	<cac:ContractingActivity>
		<cbc:ActivityTypeCode listName="entity-activity"><xsl:value-of select="$entity-activity-type"/></cbc:ActivityTypeCode>
	</cac:ContractingActivity>
</xsl:template>

<!-- Create cac:AdditionalInformationParty structure -->
<xsl:template match="*:ADDRESS_FURTHER_INFO">
	<xsl:variable name="orgid" select="$ted-addresses-unique-with-id//ted-org/path[fn:ends-with(., 'ADDRESS_FURTHER_INFO')]/../orgid"/>
	<cac:AdditionalInformationParty>
		<cac:PartyIdentification>
			<cbc:ID schemeName="organization"><xsl:value-of select="$orgid"/></cbc:ID>
		</cac:PartyIdentification>
	</cac:AdditionalInformationParty>
</xsl:template>

<xsl:template match="*:ADDRESS_FURTHER_INFO_IDEM">
	<xsl:variable name="orgid" select="$ted-addresses-unique-with-id//ted-org/path[fn:ends-with(., 'ADDRESS_CONTRACTING_BODY')]/../orgid"/>
	<cac:AdditionalInformationParty>
		<cac:PartyIdentification>
			<cbc:ID schemeName="organization"><xsl:value-of select="$orgid"/></cbc:ID>
		</cac:PartyIdentification>
	</cac:AdditionalInformationParty>
</xsl:template>

<!-- Create cac:AppealInformationParty structure -->
<xsl:template match="*:ADDRESS_REVIEW_INFO">
	<xsl:variable name="orgid" select="$ted-addresses-unique-with-id//ted-org/path[fn:ends-with(., 'ADDRESS_REVIEW_INFO')]/../orgid"/>
	<cac:AppealInformationParty>
		<cac:PartyIdentification>
			<cbc:ID schemeName="organization"><xsl:value-of select="$orgid"/></cbc:ID>
		</cac:PartyIdentification>
	</cac:AppealInformationParty>
</xsl:template>

<!-- Create cac:AppealReceiverParty structure -->
<xsl:template match="*:ADDRESS_REVIEW_BODY">
	<xsl:variable name="orgid" select="$ted-addresses-unique-with-id//ted-org/path[fn:ends-with(., 'ADDRESS_REVIEW_BODY')]/../orgid"/>
	<cac:AppealReceiverParty>
		<cac:PartyIdentification>
			<cbc:ID schemeName="organization"><xsl:value-of select="$orgid"/></cbc:ID>
		</cac:PartyIdentification>
	</cac:AppealReceiverParty>
</xsl:template>

<!-- Create cac:MediationParty structure -->
<xsl:template match="*:ADDRESS_MEDIATION_BODY">
	<xsl:variable name="orgid" select="$ted-addresses-unique-with-id//ted-org/path[fn:ends-with(., 'ADDRESS_MEDIATION_BODY')]/../orgid"/>
	<cac:MediationParty>
		<cac:PartyIdentification>
			<cbc:ID schemeName="organization"><xsl:value-of select="$orgid"/></cbc:ID>
		</cac:PartyIdentification>
	</cac:MediationParty>
</xsl:template>

<!-- Create cac:PartyIdentification structure -->
<xsl:template match="*:ADDRESS_PARTICIPATION">
	<xsl:variable name="orgid" select="$ted-addresses-unique-with-id//ted-org/path[fn:ends-with(., 'ADDRESS_PARTICIPATION')]/../orgid"/>
	<cac:PartyIdentification>
		<cbc:ID schemeName="organization"><xsl:value-of select="$orgid"/></cbc:ID>
	</cac:PartyIdentification>
</xsl:template>

<xsl:template match="*:ADDRESS_PARTICIPATION_IDEM">
	<xsl:variable name="orgid" select="$ted-addresses-unique-with-id//ted-org/path[fn:ends-with(., 'ADDRESS_CONTRACTING_BODY')]/../orgid"/>
	<cac:PartyIdentification>
		<cbc:ID schemeName="organization"><xsl:value-of select="$orgid"/></cbc:ID>
	</cac:PartyIdentification>
</xsl:template>


<xsl:template name="tax-legislation">
	<pmd-tax-legislation/>
	<xsl:variable name="tax-legislation-element" select="$ted-form-complementary-element/*:INFORMATION_REGULATORY_FRAMEWORK/*:TAX_LEGISLATION"/>
	<xsl:variable name="orgid" select="$ted-addresses-unique-with-id//ted-org/path[fn:contains(., 'TAX_LEGISLATION')]/../orgid"/>
	<xsl:variable name="text" select="fn:normalize-space(fn:string-join($tax-legislation-element/*:TAX_LEGISLATION_VALUE/(*:P|*:FT), ' '))"/>
	<xsl:choose>
		<xsl:when test="$orgid ne '' or $text ne ''">
		<cac:FiscalLegislationDocumentReference>
			<!-- ID mandated by schema, but unused in eForms -->
			<!-- Fiscal Legislation Document ID (OPT-111-Lot-FiscalLegis) -->
			<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Fiscal Legislation Document ID (OPT-111-Lot-FiscalLegis)'"/></xsl:call-template>
			<cbc:ID>Fiscal1</cbc:ID>
			<!-- URL to Fiscal Legislation (OPT-110-Lot-FiscalLegis) -->
			<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'URL to Fiscal Legislation (OPT-110-Lot-FiscalLegis)'"/></xsl:call-template>
			<xsl:choose>
				<xsl:when test="$text ne ''">
					<cac:Attachment>
						<cac:ExternalReference>
							<cbc:URI><xsl:value-of select="$text"/></cbc:URI>
						</cac:ExternalReference>
					</cac:Attachment>
				</xsl:when>
				<xsl:when test="($eforms-notice-subtype = ('6','9'))">
					<!-- WARNING: URL to Fiscal Legislation (OPT-110-Lot-FiscalLegis) is Mandatory for eForms subtype 6, 9, but no information was found in TAX_LEGISLATION_VALUE TED XML element. -->
					<xsl:variable name="message">WARNING: URL to Fiscal Legislation (OPT-110-Lot-FiscalLegis) is Mandatory for eForms subtype 6, 9, but no information was found in TAX_LEGISLATION_VALUE TED XML element.</xsl:variable>
					<xsl:call-template name="report-warning"><xsl:with-param name="message" select="$message"/></xsl:call-template>
				</xsl:when>
			</xsl:choose>
			<!-- Fiscal Legislation Organization Technical Identifier Reference (OPT-301-Lot-FiscalLegis) -->
			<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Fiscal Legislation Organization Technical Identifier Reference (OPT-301-Lot-FiscalLegis)'"/></xsl:call-template>
			<xsl:choose>
				<xsl:when test="$orgid ne ''">
					<cac:IssuerParty>
						<cac:PartyIdentification>
							<cbc:ID schemeName="organization"><xsl:value-of select="$orgid"/></cbc:ID>
						</cac:PartyIdentification>
					</cac:IssuerParty>
				</xsl:when>
				<xsl:otherwise>
					<!-- WARNING: Fiscal Legislation Organization Technical Identifier Reference (OPT-301-Lot-FiscalLegis) is Mandatory for eForms subtype 6, 9, but no contact data was found in CONTACT_DATA TED XML element. -->
					<xsl:variable name="message">WARNING: Fiscal Legislation Organization Technical Identifier Reference (OPT-301-Lot-FiscalLegis) is Mandatory for eForms subtype 6, 9, but no contact data was found in CONTACT_DATA TED XML element.</xsl:variable>
					<xsl:call-template name="report-warning"><xsl:with-param name="message" select="$message"/></xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</cac:FiscalLegislationDocumentReference>
		</xsl:when>
		<xsl:otherwise>
			<!-- URL to Fiscal Legislation (OPT-110-Lot-FiscalLegis) -->
			<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'URL to Fiscal Legislation (OPT-110-Lot-FiscalLegis)'"/></xsl:call-template>
			<xsl:if test="($eforms-notice-subtype = ('6','9'))">
					<!-- WARNING: URL to Fiscal Legislation (OPT-110-Lot-FiscalLegis) is Mandatory for eForms subtype 6, 9, but no information was found in TAX_LEGISLATION_VALUE TED XML element. -->
					<xsl:variable name="message">WARNING: URL to Fiscal Legislation (OPT-110-Lot-FiscalLegis) is Mandatory for eForms subtype 6, 9, but no information was found in TAX_LEGISLATION_VALUE TED XML element.</xsl:variable>
					<xsl:call-template name="report-warning"><xsl:with-param name="message" select="$message"/></xsl:call-template>
			</xsl:if>
			<!-- Fiscal Legislation Organization Technical Identifier Reference (OPT-301-Lot-FiscalLegis): eForms documentation cardinality (Lot) =  | Mandatory for PIN subtypes 6 and 9; Optional for other subtypes -->
			<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Fiscal Legislation Organization Technical Identifier Reference (OPT-301-Lot-FiscalLegis)'"/></xsl:call-template>
			<xsl:if test="($eforms-notice-subtype = ('6','9'))">
				<!-- WARNING: Fiscal Legislation Organization Technical Identifier Reference (OPT-301-Lot-FiscalLegis) is Mandatory for eForms subtype 6 and 9, but no TAX_LEGISLATION was found in TED XML. -->
				<xsl:variable name="message">WARNING: Fiscal Legislation Organization Technical Identifier Reference (OPT-301-Lot-FiscalLegis) is Mandatory for eForms subtype 6, 9, but no TAX_LEGISLATION was found in TED XML.</xsl:variable>
				<xsl:call-template name="report-warning"><xsl:with-param name="message" select="$message"/></xsl:call-template>
			</xsl:if>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="environmental-legislation">
	<xsl:variable name="environmental-legislation-element" select="$ted-form-complementary-element/*:INFORMATION_REGULATORY_FRAMEWORK/*:ENVIRONMENTAL_PROTECTION_LEGISLATION"/>
	<xsl:variable name="orgid" select="$ted-addresses-unique-with-id//ted-org/path[fn:contains(., 'ENVIRONMENTAL_PROTECTION_LEGISLATION')]/../orgid"/>
	<xsl:variable name="text" select="fn:normalize-space(fn:string-join($environmental-legislation-element/*:ENVIRONMENTAL_PROTECTION_LEGISLATION_VALUE/(*:P|*:FT), ' '))"/>
	<xsl:choose>
		<xsl:when test="$orgid ne '' or $text ne ''">
		<cac:EnvironmentalLegislationDocumentReference>
			<!-- ID mandated by schema, but unused in eForms -->
			<!-- Environmental Legislation Document ID (OPT-112-Lot-EnvironLegis) -->
			<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Environmental Legislation Document ID (OPT-112-Lot-EnvironLegis)'"/></xsl:call-template>
			<cbc:ID>Env1</cbc:ID>
			<!-- URL to Environmental Legislation (OPT-120-Lot-EnvironLegis) -->
			<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'URL to Environmental Legislation (OPT-120-Lot-EnvironLegis)'"/></xsl:call-template>
			<xsl:choose>
				<xsl:when test="$text ne ''">
					<cac:Attachment>
						<cac:ExternalReference>
							<cbc:URI><xsl:value-of select="$text"/></cbc:URI>
						</cac:ExternalReference>
					</cac:Attachment>
				</xsl:when>
				<xsl:when test="($eforms-notice-subtype = ('6','9'))">
					<!-- WARNING: URL to Environmental Legislation (OPT-120-Lot-EnvironLegis) is Mandatory for eForms subtype 6, 9, but no information was found in ENVIRONMENTAL_PROTECTION_LEGISLATION_VALUE TED XML element. -->
					<xsl:variable name="message">WARNING: URL to Environmental Legislation (OPT-120-Lot-EnvironLegis) is Mandatory for eForms subtype 6, 9, but no information was found in ENVIRONMENTAL_PROTECTION_LEGISLATION_VALUE TED XML element.</xsl:variable>
					<xsl:call-template name="report-warning"><xsl:with-param name="message" select="$message"/></xsl:call-template>
				</xsl:when>
			</xsl:choose>
			<!-- Environmental Legislation Organization Technical Identifier Reference (OPT-301-Lot-EnvironLegis) -->
			<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Environmental Legislation Organization Technical Identifier Reference (OPT-301-Lot-EnvironLegis)'"/></xsl:call-template>
			<xsl:choose>
				<xsl:when test="$orgid ne ''">
					<cac:IssuerParty>
						<cac:PartyIdentification>
							<cbc:ID schemeName="organization"><xsl:value-of select="$orgid"/></cbc:ID>
						</cac:PartyIdentification>
					</cac:IssuerParty>
				</xsl:when>
				<xsl:otherwise>
					<!-- WARNING: Environmental Legislation Organization Technical Identifier Reference (OPT-301-Lot-EnvironLegis) is Mandatory for eForms subtype 6, 9, but no contact data was found in CONTACT_DATA TED XML element. -->
					<xsl:variable name="message">WARNING: Environmental Legislation Organization Technical Identifier Reference (OPT-301-Lot-EnvironLegis) is Mandatory for eForms subtype 6, 9, but no contact data was found in CONTACT_DATA TED XML element.</xsl:variable>
					<xsl:call-template name="report-warning"><xsl:with-param name="message" select="$message"/></xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</cac:EnvironmentalLegislationDocumentReference>
		</xsl:when>
		<xsl:otherwise>
			<!-- URL to Environmental Legislation (OPT-120-Lot-EnvironLegis) -->
			<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'URL to Environmental Legislation (OPT-120-Lot-EnvironLegis)'"/></xsl:call-template>
			<xsl:if test="($eforms-notice-subtype = ('6','9'))">
					<!-- WARNING: URL to Environmental Legislation (OPT-120-Lot-EnvironLegis) is Mandatory for eForms subtype 6, 9, but no information was found in ENVIRONMENTAL_PROTECTION_LEGISLATION_VALUE TED XML element. -->
					<xsl:variable name="message">WARNING: URL to Environmental Legislation (OPT-120-Lot-EnvironLegis) is Mandatory for eForms subtype 6, 9, but no information was found in ENVIRONMENTAL_PROTECTION_LEGISLATION_VALUE TED XML element.</xsl:variable>
					<xsl:call-template name="report-warning"><xsl:with-param name="message" select="$message"/></xsl:call-template>
			</xsl:if>
			<!-- Environmental Legislation Organization Technical Identifier Reference (OPT-301-Lot-EnvironLegis): eForms documentation cardinality (Lot) =  | Mandatory for PIN subtypes 6 and 9; Optional for other subtypes -->
			<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Environmental Legislation Organization Technical Identifier Reference (OPT-301-Lot-EnvironLegis)'"/></xsl:call-template>
			<xsl:if test="($eforms-notice-subtype = ('6','9'))">
				<!-- WARNING: Environmental Legislation Organization Technical Identifier Reference (OPT-301-Lot-EnvironLegis) is Mandatory for eForms subtype 6 and 9, but no ENVIRONMENTAL_PROTECTION_LEGISLATION was found in TED XML. -->
				<xsl:variable name="message">WARNING: Environmental Legislation Organization Technical Identifier Reference (OPT-301-Lot-EnvironLegis) is Mandatory for eForms subtype 6, 9, but no ENVIRONMENTAL_PROTECTION_LEGISLATION was found in TED XML.</xsl:variable>
				<xsl:call-template name="report-warning"><xsl:with-param name="message" select="$message"/></xsl:call-template>
			</xsl:if>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="employment-legislation">
	<xsl:variable name="employment-legislation-element" select="$ted-form-complementary-element/*:INFORMATION_REGULATORY_FRAMEWORK/*:EMPLOYMENT_PROTECTION_WORKING_CONDITIONS"/>
	<xsl:variable name="orgid" select="$ted-addresses-unique-with-id//ted-org/path[fn:contains(., 'EMPLOYMENT_PROTECTION_WORKING_CONDITIONS')]/../orgid"/>
	<xsl:variable name="text" select="fn:normalize-space(fn:string-join($employment-legislation-element/*:EMPLOYMENT_PROTECTION_WORKING_CONDITIONS_VALUE/(*:P|*:FT), ' '))"/>
	<xsl:choose>
		<xsl:when test="$orgid ne '' or $text ne ''">
		<cac:EmploymentLegislationDocumentReference>
			<!-- ID mandated by schema, but unused in eForms -->
			<!-- Employment Legislation Document ID (OPT-113-Lot-EmployLegis) -->
			<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Employment Legislation Document ID (OPT-113-Lot-EmployLegis)'"/></xsl:call-template>
			<cbc:ID>Empl1</cbc:ID>
			<!-- URL to Employment Legislation (OPT-130-Lot-EmployLegis) -->
			<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'URL to Employment Legislation (OPT-130-Lot-EmployLegis)'"/></xsl:call-template>
			<xsl:choose>
				<xsl:when test="$text ne ''">
					<cac:Attachment>
						<cac:ExternalReference>
							<cbc:URI><xsl:value-of select="$text"/></cbc:URI>
						</cac:ExternalReference>
					</cac:Attachment>
				</xsl:when>
				<xsl:when test="($eforms-notice-subtype = ('6','9'))">
					<!-- WARNING: URL to Employment Legislation (OPT-130-Lot-EmployLegis) is Mandatory for eForms subtype 6, 9, but no information was found in EMPLOYMENT_PROTECTION_WORKING_CONDITIONS_VALUE TED XML element. -->
					<xsl:variable name="message">WARNING: URL to Employment Legislation (OPT-130-Lot-EmployLegis) is Mandatory for eForms subtype 6, 9, but no information was found in EMPLOYMENT_PROTECTION_WORKING_CONDITIONS_VALUE TED XML element.</xsl:variable>
					<xsl:call-template name="report-warning"><xsl:with-param name="message" select="$message"/></xsl:call-template>
				</xsl:when>
			</xsl:choose>
			<!-- Employment Legislation Organization Technical Identifier Reference (OPT-301-Lot-EmployLegis) -->
			<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Employment Legislation Organization Technical Identifier Reference (OPT-301-Lot-EmployLegis)'"/></xsl:call-template>
			<xsl:choose>
				<xsl:when test="$orgid ne ''">
					<cac:IssuerParty>
						<cac:PartyIdentification>
							<cbc:ID schemeName="organization"><xsl:value-of select="$orgid"/></cbc:ID>
						</cac:PartyIdentification>
					</cac:IssuerParty>
				</xsl:when>
				<xsl:otherwise>
					<!-- WARNING: Employment Legislation Organization Technical Identifier Reference (OPT-301-Lot-EmployLegis) is Mandatory for eForms subtype 6, 9, but no contact data was found in CONTACT_DATA TED XML element. -->
					<xsl:variable name="message">WARNING: Employment Legislation Organization Technical Identifier Reference (OPT-301-Lot-EmployLegis) is Mandatory for eForms subtype 6, 9, but no contact data was found in CONTACT_DATA TED XML element.</xsl:variable>
					<xsl:call-template name="report-warning"><xsl:with-param name="message" select="$message"/></xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</cac:EmploymentLegislationDocumentReference>
		</xsl:when>
		<xsl:otherwise>
			<!-- URL to Employment Legislation (OPT-130-Lot-EmployLegis) -->
			<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'URL to Employment Legislation (OPT-130-Lot-EmployLegis)'"/></xsl:call-template>
			<xsl:if test="($eforms-notice-subtype = ('6','9'))">
					<!-- WARNING: URL to Employment Legislation (OPT-130-Lot-EmployLegis) is Mandatory for eForms subtype 6, 9, but no information was found in EMPLOYMENT_PROTECTION_WORKING_CONDITIONS_VALUE TED XML element. -->
					<xsl:variable name="message">WARNING: URL to Employment Legislation (OPT-130-Lot-EmployLegis) is Mandatory for eForms subtype 6, 9, but no information was found in EMPLOYMENT_PROTECTION_WORKING_CONDITIONS_VALUE TED XML element.</xsl:variable>
					<xsl:call-template name="report-warning"><xsl:with-param name="message" select="$message"/></xsl:call-template>
			</xsl:if>
			<!-- Employment Legislation Organization Technical Identifier Reference (OPT-301-Lot-EmployLegis): eForms documentation cardinality (Lot) =  | Mandatory for PIN subtypes 6 and 9; Optional for other subtypes -->
			<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Employment Legislation Organization Technical Identifier Reference (OPT-301-Lot-EmployLegis)'"/></xsl:call-template>
			<xsl:if test="($eforms-notice-subtype = ('6','9'))">
				<!-- WARNING: Employment Legislation Organization Technical Identifier Reference (OPT-301-Lot-EmployLegis) is Mandatory for eForms subtype 6 and 9, but no EMPLOYMENT_PROTECTION_WORKING_CONDITIONS was found in TED XML. -->
				<xsl:variable name="message">WARNING: Employment Legislation Organization Technical Identifier Reference (OPT-301-Lot-EmployLegis) is Mandatory for eForms subtype 6, 9, but no EMPLOYMENT_PROTECTION_WORKING_CONDITIONS was found in TED XML.</xsl:variable>
				<xsl:call-template name="report-warning"><xsl:with-param name="message" select="$message"/></xsl:call-template>
			</xsl:if>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
