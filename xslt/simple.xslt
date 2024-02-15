<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xlink="http://www.w3.org/1999/xlink"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:doc="http://www.pnp-software.com/XSLTdoc"
xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:functx="http://www.functx.com" xmlns:opfun="http://data.europa.eu/p27/ted-xml-data-converter"
xmlns:ted="http://publications.europa.eu/resource/schema/ted/R2.0.9/publication"
xmlns:ted-1="http://formex.publications.europa.eu/ted/schema/export/R2.0.9.S01.E01"
xmlns:ted-2="ted/R2.0.9.S02/publication"
xmlns:n2016-1="ted/2016/nuts"
xmlns:n2016="http://publications.europa.eu/resource/schema/ted/2016/nuts" xmlns:n2021="http://publications.europa.eu/resource/schema/ted/2021/nuts"
xmlns:pin="urn:oasis:names:specification:ubl:schema:xsd:PriorInformationNotice-2" xmlns:cn="urn:oasis:names:specification:ubl:schema:xsd:ContractNotice-2" xmlns:can="urn:oasis:names:specification:ubl:schema:xsd:ContractAwardNotice-2"
xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"
xmlns:efbc="http://data.europa.eu/p27/eforms-ubl-extension-basic-components/1" xmlns:efac="http://data.europa.eu/p27/eforms-ubl-extension-aggregate-components/1" xmlns:efext="http://data.europa.eu/p27/eforms-ubl-extensions/1"
xmlns:ccts="urn:un:unece:uncefact:documentation:2" xmlns:gc="http://docs.oasis-open.org/codelist/ns/genericode/1.0/"
exclude-result-prefixes="xlink xs xsi fn functx doc opfun ted ted-1 ted-2 gc n2016-1 n2016 n2021 pin cn can ccts ext" >
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

<xsl:template match="*:OFFICIALNAME">
	<cac:PartyName>
		<cbc:Name languageID="{$eforms-first-language}"><xsl:value-of select="fn:normalize-space(.)"/></cbc:Name>
	</cac:PartyName>
</xsl:template>

<xsl:template match="*:URL_GENERAL|*:URL">
	<cbc:WebsiteURI><xsl:value-of select="fn:normalize-space(.)"/></cbc:WebsiteURI>
</xsl:template>

<xsl:template match="*:ADDRESS">
	<cbc:StreetName><xsl:value-of select="fn:normalize-space(.)"/></cbc:StreetName>
</xsl:template>

<xsl:template match="*:TOWN">
	<cbc:CityName><xsl:value-of select="fn:normalize-space(.)"/></cbc:CityName>
</xsl:template>

<xsl:template match="*:POSTAL_CODE">
	<cbc:PostalZone><xsl:value-of select="fn:normalize-space(.)"/></cbc:PostalZone>
</xsl:template>

<xsl:template match="*:NUTS">
	<cbc:CountrySubentityCode listName="nuts"><xsl:value-of select="@CODE"/></cbc:CountrySubentityCode>
</xsl:template>

<xsl:template match="*:NATIONALID">
	<cac:PartyLegalEntity>
		<cbc:CompanyID><xsl:value-of select="fn:normalize-space(.)"/></cbc:CompanyID>
	</cac:PartyLegalEntity>
</xsl:template>

<xsl:template match="*:CONTACT_POINT">
	<cbc:Name><xsl:value-of select="fn:normalize-space(.)"/></cbc:Name>
</xsl:template>

<xsl:template match="*:PHONE">
	<cbc:Telephone><xsl:value-of select="fn:normalize-space(.)"/></cbc:Telephone>
</xsl:template>

<xsl:template match="*:FAX">
	<cbc:Telefax><xsl:value-of select="fn:normalize-space(.)"/></cbc:Telefax>
</xsl:template>

<xsl:template match="*:E_MAIL">
	<cbc:ElectronicMail><xsl:value-of select="fn:normalize-space(.)"/></cbc:ElectronicMail>
</xsl:template>

<xsl:template match="*:URL_BUYER">
	<cbc:BuyerProfileURI><xsl:value-of select="fn:normalize-space(.)"/></cbc:BuyerProfileURI>
</xsl:template>

<xsl:template match="*:REFERENCE_NUMBER">
	<cbc:ID schemeName="InternalID"><xsl:value-of select="fn:normalize-space(.)"/></cbc:ID>
</xsl:template>

<xsl:template match="*:LOT_MAX_ONE_TENDERER">
	<cbc:MaximumLotsAwardedNumeric><xsl:value-of select="fn:normalize-space(.)"/></cbc:MaximumLotsAwardedNumeric>
</xsl:template>

<xsl:template match="*:LOT_ALL">
	<cbc:MaximumLotsSubmittedNumeric><xsl:value-of select="$number-of-lots"/></cbc:MaximumLotsSubmittedNumeric>
</xsl:template>

<xsl:template match="*:LOT_MAX_NUMBER">
	<cbc:MaximumLotsSubmittedNumeric><xsl:value-of select="fn:normalize-space(.)"/></cbc:MaximumLotsSubmittedNumeric>
</xsl:template>

<xsl:template match="*:LOT_ONE_ONLY">
	<cbc:MaximumLotsSubmittedNumeric>1</cbc:MaximumLotsSubmittedNumeric>
</xsl:template>

<xsl:template match="*:ACCEPTED_VARIANTS">
	<cbc:VariantConstraintCode listName="permission">allowed</cbc:VariantConstraintCode>
</xsl:template>

<xsl:template match="*:NO_ACCEPTED_VARIANTS">
	<cbc:VariantConstraintCode listName="permission">not-allowed</cbc:VariantConstraintCode>
</xsl:template>

<xsl:template match="*:EU_PROGR_RELATED">
	<cbc:FundingProgramCode listName="eu-funded">eu-funds</cbc:FundingProgramCode>
</xsl:template>

<xsl:template match="*:NO_EU_PROGR_RELATED">
	<cbc:FundingProgramCode listName="eu-funded">no-eu-funds</cbc:FundingProgramCode>
</xsl:template>

<xsl:template match="*:PERFORMANCE_STAFF_QUALIFICATION">
	<cbc:RequiredCurriculaCode listName="requirement-stage"></cbc:RequiredCurriculaCode>
</xsl:template>

<xsl:template match="*:RECURRENT_PROCUREMENT">
	<cbc:RecurringProcurementIndicator>true</cbc:RecurringProcurementIndicator>
</xsl:template>

<xsl:template match="*:NO_RECURRENT_PROCUREMENT">
	<cbc:RecurringProcurementIndicator>false</cbc:RecurringProcurementIndicator>
</xsl:template>

<xsl:template match="*:ESTIMATED_TIMING">
	<xsl:variable name="text" select="fn:normalize-space(fn:string-join(*:P, ' '))"/>
	<xsl:if test="$text ne ''">
		<xsl:call-template name="multilingual">
			<xsl:with-param name="contexts" select="."/>
			<xsl:with-param name="local" select="'P'"/>
			<xsl:with-param name="element" select="'cbc:RecurringProcurementDescription'"/>
		</xsl:call-template>
	</xsl:if>
</xsl:template>

<xsl:template match="*:RIGHT_CONTRACT_INITIAL_TENDERS">
	<cbc:NoFurtherNegotiationIndicator>true</cbc:NoFurtherNegotiationIndicator>
</xsl:template>

<xsl:template match="*:URL_PARTICIPATION">
	<cbc:EndpointID><xsl:value-of select="fn:normalize-space(.)"/></cbc:EndpointID>
</xsl:template>

<xsl:template match="*:URL_TOOL">
	<cbc:AccessToolsURI><xsl:value-of select="fn:normalize-space(.)"/></cbc:AccessToolsURI>
</xsl:template>

</xsl:stylesheet>
