<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xlink="http://www.w3.org/1999/xlink"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:functx="http://www.functx.com" 
xmlns:doc="http://www.pnp-software.com/XSLTdoc" xmlns:opfun="http://publications.europa.eu/local/xslt-functions"
xmlns:ted="http://publications.europa.eu/resource/schema/ted/R2.0.9/publication" xmlns:n2016="http://publications.europa.eu/resource/schema/ted/2016/nuts" 
xmlns:efbc="http://eforms/v1.0/ExtensionBasicComponents" xmlns:efac="http://eforms/v1.0/ExtensionAggregateComponents" xmlns:efext="http://eforms/v1.0/Extensions" xmlns:pin="urn:oasis:names:specification:ubl:schema:xsd:PriorInformationNotice-2" xmlns:cn="urn:oasis:names:specification:ubl:schema:xsd:ContractNotice-2" xmlns:can="urn:oasis:names:specification:ubl:schema:xsd:ContractAwardNotice-2"
xmlns:ccts="urn:un:unece:uncefact:documentation:2" xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
xmlns:gc="http://docs.oasis-open.org/codelist/ns/genericode/1.0/"
exclude-result-prefixes="xlink xs xsi fn functx doc opfun ted gc n2016 pin cn can ccts " 
>
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>


<!-- ADDRESSES -->

	<xsl:variable name="tedaddresses" as="element()">
	<!--
	All TED XML address elements
	AWARD_CONTRACT/AWARDED_CONTRACT/CONTRACTORS/CONTRACTOR/ADDRESS_CONTRACTOR	Name and address of the contractor/concessionaire
	AWARD_CONTRACT/AWARDED_CONTRACT/CONTRACTORS/CONTRACTOR/ADDRESS_PARTY	Name and address of the party or parties exercising legal control over the selected operator
	COMPLEMENTARY_INFO/ADDRESS_MEDIATION_BODY	Body responsible for mediation procedures
	COMPLEMENTARY_INFO/ADDRESS_REVIEW_BODY	Review body Address
	COMPLEMENTARY_INFO/ADDRESS_REVIEW_INFO	Service from which information about the review procedure may be obtained
	CONTRACTING_BODY/ADDRESS_CONTRACTING_BODY	contracting authorities responsible for the procedure
	CONTRACTING_BODY/ADDRESS_CONTRACTING_BODY_ADDITIONAL	contracting authorities responsible for the procedure
	CONTRACTING_BODY/ADDRESS_FURTHER_INFO	Additional information can be obtained from
	CONTRACTING_BODY/ADDRESS_FURTHER_INFO_IDEM	Additional information can be obtained from the abovementioned address (ADDRESS_CONTRACTOR)
	CONTRACTING_BODY/ADDRESS_PARTICIPATION	Tenders or requests to participate must be submitted
	CONTRACTING_BODY/ADDRESS_PARTICIPATION_IDEM	Tenders or requests to participate must be submitted to the abovementioned address (ADDRESS_CONTRACTOR)
	-->
		<ted-orgs>
			<xsl:for-each select="$ted-form-main-element/(ted:CONTRACTING_BODY/(ted:ADDRESS_CONTRACTING_BODY | ted:ADDRESS_CONTRACTING_BODY_ADDITIONAL | ted:ADDRESS_FURTHER_INFO | ted:ADDRESS_PARTICIPATION) | ted:COMPLEMENTARY_INFO/(ted:ADDRESS_REVIEW_BODY | ted:ADDRESS_MEDIATION_BODY | ted:ADDRESS_REVIEW_INFO) | ted:AWARD_CONTRACT/ted:AWARDED_CONTRACT/ted:CONTRACTORS/ted:CONTRACTOR/(ted:ADDRESS_CONTRACTOR | ted:ADDRESS_PARTY))">
				<ted-org>
					<xsl:variable name="path" select="functx:path-to-node-with-pos(.)"/>
					<path><xsl:value-of select="$path"/></path>
					<tedaddress>
						<xsl:for-each select="*">
							<xsl:copy-of select="." copy-namespaces="no"/>
						</xsl:for-each>
					</tedaddress>
				</ted-org>
			</xsl:for-each>
		</ted-orgs>
	</xsl:variable>

	<xsl:variable name="tedaddressesunique" as="element()">
		<ted-orgs>
		<xsl:for-each select="$tedaddresses//ted-org">
			<xsl:variable name="pos" select="fn:position()"/>
			<xsl:variable name="address" as="element()" select="tedaddress"/>
			<!-- find if any preceding addresses are deep-equal to this one -->
			<xsl:variable name="prevsame">
				<xsl:for-each select="./preceding-sibling::ted-org">
					<xsl:if test="fn:deep-equal(tedaddress, $address)">
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
					<xsl:if test="fn:deep-equal(tedaddress, $address)">
						<path><xsl:sequence select="fn:string(path)"/></path>
					</xsl:if>
				</xsl:for-each>
				<!-- copy the address -->
				<xsl:copy-of select="tedaddress"/>
				</ted-org>
			</xsl:if>
		</xsl:for-each>
		</ted-orgs>
	</xsl:variable>
	
	<xsl:variable name="tedaddressesuniquewithid" as="element()">
		<ted-orgs>
		<xsl:for-each select="$tedaddressesunique//ted-org">
			<ted-org>
				<xsl:variable name="typepos" select="functx:pad-integer-to-length((fn:count(./preceding-sibling::ted-org) + 1), 3)"/>
				<orgid><xsl:text>ORG-</xsl:text><xsl:value-of select="$typepos"/></orgid>
				<xsl:copy-of select="type"/>
				<xsl:copy-of select="path"/>
				<xsl:copy-of select="tedaddress"/>
			</ted-org>
		</xsl:for-each>
		</ted-orgs>
	</xsl:variable>


	<xsl:template match="ted:CONTRACTING_BODY">
		<cac:ContractingParty>
			<xsl:apply-templates select="ted:ADDRESS_CONTRACTING_BODY/ted:URL_BUYER"/>
			<xsl:apply-templates select="ted:CA_TYPE|CA_TYPE_OTHER"/>
			<xsl:apply-templates select="ted:CA_ACTIVITY"/>
			<cac:Party>
				<cac:PartyIdentification>
					<cbc:ID schemeName="organization"><xsl:value-of select="$tedaddressesuniquewithid//ted-org/path[fn:ends-with(.,'ADDRESS_CONTRACTING_BODY')]/../orgid"/></cbc:ID>
				</cac:PartyIdentification>
			</cac:Party>
		</cac:ContractingParty>
	</xsl:template>

<!--
		<xsd:sequence>
			<xsd:element ref="ext:UBLExtensions" minOccurs="0" maxOccurs="1"/>
			<xsd:element ref="cbc:BuyerProfileURI" minOccurs="0" maxOccurs="1"/>
			<xsd:element ref="cac:ContractingPartyType" minOccurs="0" maxOccurs="unbounded"/>
			<xsd:element ref="cac:ContractingActivity" minOccurs="0" maxOccurs="unbounded"/>
			<xsd:element ref="cac:ContractingRepresentationType" minOccurs="0" maxOccurs="1"/>
			<xsd:element ref="cac:Party" minOccurs="1" maxOccurs="1"/>
		</xsd:sequence>

	<xsd:complexType name="PartyType">
		<xsd:sequence>
			<xsd:element ref="ext:UBLExtensions" minOccurs="0" maxOccurs="1"/>
			<xsd:element ref="cbc:MarkCareIndicator" minOccurs="0" maxOccurs="1"/>
			<xsd:element ref="cbc:MarkAttentionIndicator" minOccurs="0" maxOccurs="1"/>
			<xsd:element ref="cbc:WebsiteURI" minOccurs="0" maxOccurs="1"/>
			<xsd:element ref="cbc:LogoReferenceID" minOccurs="0" maxOccurs="1"/>
			<xsd:element ref="cbc:EndpointID" minOccurs="0" maxOccurs="1"/>
			<xsd:element ref="cbc:IndustryClassificationCode" minOccurs="0" maxOccurs="1"/>
			<xsd:element ref="cac:PartyIdentification" minOccurs="0" maxOccurs="unbounded"/>
			<xsd:element ref="cac:PartyName" minOccurs="0" maxOccurs="unbounded"/>
			<xsd:element ref="cac:Language" minOccurs="0" maxOccurs="1"/>
			<xsd:element ref="cac:PostalAddress" minOccurs="0" maxOccurs="1"/>
			<xsd:element ref="cac:PhysicalLocation" minOccurs="0" maxOccurs="1"/>
			<xsd:element ref="cac:PartyTaxScheme" minOccurs="0" maxOccurs="unbounded"/>
			<xsd:element ref="cac:PartyLegalEntity" minOccurs="0" maxOccurs="unbounded"/>
			<xsd:element ref="cac:Contact" minOccurs="0" maxOccurs="1"/>
			<xsd:element ref="cac:Person" minOccurs="0" maxOccurs="unbounded"/>
			<xsd:element ref="cac:AgentParty" minOccurs="0" maxOccurs="1"/>
			<xsd:element ref="cac:ServiceProviderParty" minOccurs="0" maxOccurs="unbounded"/>
			<xsd:element ref="cac:PowerOfAttorney" minOccurs="0" maxOccurs="unbounded"/>
			<xsd:element ref="cac:PartyAuthorization" minOccurs="0" maxOccurs="unbounded"/>
			<xsd:element ref="cac:FinancialAccount" minOccurs="0" maxOccurs="1"/>
			<xsd:element ref="cac:AdditionalWebSite" minOccurs="0" maxOccurs="unbounded"/>
			<xsd:element ref="cac:SocialMediaProfile" minOccurs="0" maxOccurs="unbounded"/>
		</xsd:sequence>
	</xsd:complexType>

-->	
	<xsl:template match="ted:ADDRESS_CONTRACTING_BODY">
		<cac:Party>
			<xsl:call-template name="org-address"/>
		</cac:Party>
	</xsl:template>
	
	<xsl:template name="org-address">
	<!--
		<xs:element ref="OFFICIALNAME"/>
		<xs:element ref="NATIONALID" minOccurs="0"/>
		<xs:element ref="ADDRESS" minOccurs="0"/>
		<xs:element ref="TOWN"/>
		<xs:element ref="POSTAL_CODE" minOccurs="0"/>
		<xs:element ref="COUNTRY"/>
		<xs:element ref="CONTACT_POINT" minOccurs="0"/>
		<xs:element ref="PHONE" minOccurs="0"/>
		<xs:element ref="E_MAIL" minOccurs="0"/>
		<xs:element ref="FAX" minOccurs="0"/>
		<xs:element ref="n2021:NUTS"/>
		<xs:element ref="URL_GENERAL" minOccurs="0"/>
		<xs:element ref="URL_BUYER" minOccurs="0"/>
	-->
		<xsl:apply-templates select="ted:URL_GENERAL"/>
		<!-- Need to investigate purpose and meaning of element URL_BUYER in addresses not CONTRACTING_BODY -->
		<!--<xsl:apply-templates select="ted:URL_BUYER"/>-->
		<cac:PartyIdentification><cbc:ID schemeName="organization"><xsl:value-of select="../orgid"/></cbc:ID></cac:PartyIdentification>
		<xsl:apply-templates select="ted:OFFICIALNAME"/>
		<xsl:call-template name="address"/>
	<!--
		<xs:element ref="NATIONALID" minOccurs="0"/>
		<xs:element ref="CONTACT_POINT" minOccurs="0"/>
		<xs:element ref="PHONE" minOccurs="0"/>
		<xs:element ref="E_MAIL" minOccurs="0"/>
		<xs:element ref="FAX" minOccurs="0"/>
		<xs:element ref="URL_GENERAL" minOccurs="0"/>
		<xs:element ref="URL_BUYER" minOccurs="0"/>
	-->
		
	</xsl:template>
	
	<xsl:template name="address">
		<cac:PostalAddress>
		<xsl:apply-templates select="ted:ADDRESS"/>
		<xsl:apply-templates select="ted:TOWN"/>
		<xsl:apply-templates select="ted:POSTAL_CODE"/>
		<xsl:apply-templates select="n2016:NUTS"/>
		<xsl:apply-templates select="ted:COUNTRY"/>
		</cac:PostalAddress>
	</xsl:template>
	
	<xsl:template match="ted:CA_TYPE">
<!--
buyer-legal-type codelist
cga Central government authority
ra Regional authority
la Local authority
body-pl Body governed by public law
body-pl-cga Body governed by public law, controlled by a central government authority
body-pl-ra Body governed by public law, controlled by a regional authority
body-pl-la Body governed by public law, controlled by a local authority
pub-undert Public undertaking
pub-undert-cga Public undertaking, controlled by a central government authority
pub-undert-ra Public undertaking, controlled by a regional authority
pub-undert-la Public undertaking, controlled by a local authority
spec-rights-entity Entity with special or exclusive rights
org-sub Organisation awarding a contract subsidised by a contracting authority
org-sub-cga Organisation awarding a contract subsidised by a central government authority
org-sub-ra Organisation awarding a contract subsidised by a regional authority
org-sub-la Organisation awarding a contract subsidised by a local authority
def-cont Defence contractor
int-org International organisation
eu-ins-bod-ag EU institution, body or agency
rl-aut Regional or local authority
eu-int-org European Institution/Agency or International Organisation


-->
		<xsl:variable name="ca-type" select="@VALUE"/>
		<xsl:variable name="buyer-legal-type" select="$mappings//ca-types/mapping[ted-value=$ca-type]/fn:string(eforms-value)"/>
		<cac:ContractingPartyType>
			<cbc:PartyType><xsl:value-of select="$buyer-legal-type"/></cbc:PartyType>
		</cac:ContractingPartyType>
	<!-- buyer-contracting-type codelist Not yet available -->
		<cac:ContractingPartyType>
			<cbc:PartyType><xsl:value-of select="'buyer-contracting-type'"/></cbc:PartyType>
		</cac:ContractingPartyType>
	</xsl:template>

	<xsl:template match="ted:CA_ACTIVITY">
	<!-- authority-activity codelist not yet available -->
		<cac:ContractingActivity>
			<cbc:ActivityTypeCode><xsl:value-of select="@VALUE"/></cbc:ActivityTypeCode>
		</cac:ContractingActivity>
	</xsl:template>
	
	<xsl:template match="ted:ADDRESS_FURTHER_INFO">
		<xsl:variable name="orgid" select="$tedaddressesuniquewithid//ted-org/path[fn:ends-with(., 'ADDRESS_FURTHER_INFO')]/../orgid"/>
		<cac:AdditionalInformationParty>
			<cac:PartyIdentification>
				<cbc:ID schemeName="organization"><xsl:value-of select="$orgid"/></cbc:ID>
			</cac:PartyIdentification>
		</cac:AdditionalInformationParty>
	</xsl:template>
	
		<xsl:template match="ted:ADDRESS_REVIEW_INFO">
		<xsl:variable name="orgid" select="$tedaddressesuniquewithid//ted-org/path[fn:ends-with(., 'ADDRESS_REVIEW_INFO')]/../orgid"/>
		<cac:AppealInformationParty>
			<cac:PartyIdentification>
				<cbc:ID schemeName="organization"><xsl:value-of select="$orgid"/></cbc:ID>
			</cac:PartyIdentification>
		</cac:AppealInformationParty>
	</xsl:template>

		<xsl:template match="ted:ADDRESS_REVIEW_BODY">
		<xsl:variable name="orgid" select="$tedaddressesuniquewithid//ted-org/path[fn:ends-with(., 'ADDRESS_REVIEW_BODY')]/../orgid"/>
		<cac:AppealReceiverParty>
			<cac:PartyIdentification>
				<cbc:ID schemeName="organization"><xsl:value-of select="$orgid"/></cbc:ID>
			</cac:PartyIdentification>
		</cac:AppealReceiverParty>
	</xsl:template>

		<xsl:template match="ted:ADDRESS_MEDIATION_BODY">
		<xsl:variable name="orgid" select="$tedaddressesuniquewithid//ted-org/path[fn:ends-with(., 'ADDRESS_MEDIATION_BODY')]/../orgid"/>
		<cac:MediationParty>
			<cac:PartyIdentification>
				<cbc:ID schemeName="organization"><xsl:value-of select="$orgid"/></cbc:ID>
			</cac:PartyIdentification>
		</cac:MediationParty>
	</xsl:template>

	
	<xsl:template match="ted:ADDRESS_PARTICIPATION">
		<xsl:variable name="orgid" select="$tedaddressesuniquewithid//ted-org/path[fn:ends-with(., 'ADDRESS_PARTICIPATION')]/../orgid"/>
		<cac:PartyIdentification>
			<cbc:ID schemeName="organization"><xsl:value-of select="$orgid"/></cbc:ID>
		</cac:PartyIdentification>
	</xsl:template>

	<xsl:template match="ted:ADDRESS_PARTICIPATION_IDEM">
		<xsl:variable name="orgid" select="$tedaddressesuniquewithid//ted-org/path[fn:ends-with(., 'ADDRESS_CONTRACTING_BODY')]/../orgid"/>
		<cac:PartyIdentification>
			<cbc:ID schemeName="organization"><xsl:value-of select="$orgid"/></cbc:ID>
		</cac:PartyIdentification>
	</xsl:template>

</xsl:stylesheet>
