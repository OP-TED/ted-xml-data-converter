<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:functx="http://www.functx.com" 
xmlns:doc="http://www.pnp-software.com/XSLTdoc" xmlns:opfun="http://publications.europa.eu/local/xslt-functions"
xmlns:ted="http://publications.europa.eu/resource/schema/ted/R2.0.9/publication" xmlns:n2016="http://publications.europa.eu/resource/schema/ted/2016/nuts" 
xmlns:efbc="http://eforms/v1.0/ExtensionBasicComponents" xmlns:efac="http://eforms/v1.0/ExtensionAggregateComponents" xmlns:efext="http://eforms/v1.0/Extensions" xmlns:pin="urn:oasis:names:specification:ubl:schema:xsd:PriorInformationNotice-2" xmlns:cn="urn:oasis:names:specification:ubl:schema:xsd:ContractNotice-2" xmlns:can="urn:oasis:names:specification:ubl:schema:xsd:ContractAwardNotice-2"
xmlns:ccts="urn:un:unece:uncefact:documentation:2" xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
xmlns:gc="http://docs.oasis-open.org/codelist/ns/genericode/1.0/"
exclude-result-prefixes="xs xsi fn functx doc opfun ted gc n2016 pin cn can ccts " >
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

	<xsl:template match="*:CONTRACTING_BODY">
		<cac:ContractingParty>
			<xsl:apply-templates select="*:CA_TYPE"/>
			<xsl:apply-templates select="*:CA_ACTIVITY"/>
			<xsl:apply-templates select="*:ADDRESS_CONTRACTING_BODY"/>
			<xsl:apply-templates select="*[not(fn:local-name(.) = ('CA_TYPE', 'CA_ACTIVITY', 'ADDRESS_CONTRACTING_BODY'))]"/>
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
	<xsl:template match="*:ADDRESS_CONTRACTING_BODY">
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
		<xsl:apply-templates select="*:URL_GENERAL"/>
		<xsl:apply-templates select="*:URL_BUYER"/>
		<xsl:apply-templates select="*:OFFICIALNAME"/>
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
		<xsl:apply-templates select="*:ADDRESS"/>
		<xsl:apply-templates select="*:TOWN"/>
		<xsl:apply-templates select="*:POSTAL_CODE"/>
		<xsl:apply-templates select="*:NUTS"/>
		<xsl:apply-templates select="*:COUNTRY"/>
		</cac:PostalAddress>
	</xsl:template>
	
<xsl:template match="*:CA_TYPE">
	<cac:ContractingPartyType>
		<cbc:PartyType><xsl:value-of select="@VALUE"/></cbc:PartyType>
	</cac:ContractingPartyType>
</xsl:template>

<xsl:template match="*:CA_ACTIVITY">
	<cac:ContractingActivity>
		<cbc:ActivityTypeCode><xsl:value-of select="@VALUE"/></cbc:ActivityTypeCode>
	</cac:ContractingActivity>
</xsl:template>

</xsl:stylesheet>
