<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:functx="http://www.functx.com" 
xmlns:doc="http://www.pnp-software.com/XSLTdoc" xmlns:opfun="http://publications.europa.eu/local/xslt-functions"
xmlns:ted="http://publications.europa.eu/resource/schema/ted/R2.0.9/publication" xmlns:n2016="http://publications.europa.eu/resource/schema/ted/2016/nuts" 
xmlns:efbc="http://eforms/v1.0/ExtensionBasicComponents" xmlns:efac="http://eforms/v1.0/ExtensionAggregateComponents" xmlns:efext="http://eforms/v1.0/Extensions" xmlns:pin="urn:oasis:names:specification:ubl:schema:xsd:PriorInformationNotice-2" xmlns:cn="urn:oasis:names:specification:ubl:schema:xsd:ContractNotice-2" xmlns:can="urn:oasis:names:specification:ubl:schema:xsd:ContractAwardNotice-2"
xmlns:ccts="urn:un:unece:uncefact:documentation:2" xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
xmlns:gc="http://docs.oasis-open.org/codelist/ns/genericode/1.0/"
exclude-result-prefixes="xs xsi fn functx doc opfun ted gc n2016 pin cn can ccts ext" >
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

<xsl:template match="*:OFFICIALNAME">
	<cac:PartyName>
		<cbc:Name><xsl:apply-templates/></cbc:Name>
	</cac:PartyName>
</xsl:template>

<xsl:template match="*:URL_GENERAL">
	<cbc:WebsiteURI><xsl:apply-templates/></cbc:WebsiteURI>
</xsl:template>

<xsl:template match="*:URL_BUYER">
	<cbc:EndpointID><xsl:apply-templates/></cbc:EndpointID>
</xsl:template>

<xsl:template match="*:ADDRESS">
	<cbc:StreetName><xsl:apply-templates/></cbc:StreetName>
</xsl:template>

<xsl:template match="*:TOWN">
	<cbc:CityName><xsl:apply-templates/></cbc:CityName>
</xsl:template>

<xsl:template match="*:POSTAL_CODE">
	<cbc:PostalZone><xsl:apply-templates/></cbc:PostalZone>
</xsl:template>

<xsl:template match="*:NUTS">
	<cbc:CountrySubentityCode listName="nuts"><xsl:value-of select="@CODE"/></cbc:CountrySubentityCode>
</xsl:template>

<xsl:template match="*:COUNTRY">
	<cac:Country>
		<cbc:IdentificationCode><xsl:value-of select="@VALUE"/></cbc:IdentificationCode>
	</cac:Country>
</xsl:template>



<!-- 
					<OFFICIALNAME>European Commission, Directorate-General for Informatics, Directorate A: Startegy and Resources, Unit A3: ICT Procurement and Contracts</OFFICIALNAME>
					<ADDRESS>rue Montoyer 15, Office MO15 07/P001</ADDRESS>
					<TOWN>Brussels</TOWN>
					<POSTAL_CODE>1049</POSTAL_CODE>
					<COUNTRY VALUE="BE"/>
					<CONTACT_POINT>Digit Contracts Info Centre</CONTACT_POINT>
					<E_MAIL>digit-contracts-info-centre@ec.europa.eu</E_MAIL>
					<n2016:NUTS CODE="BE1"/>
					<URL_GENERAL>https://ec.europa.eu/info/departments/informatics_en#responsibilities</URL_GENERAL>
					<URL_BUYER>https://ec.europa.eu/info/funding-tenders/tenders/tender-opportunities-department/tender-opportunities-informatics_en</URL_BUYER>

-->
</xsl:stylesheet>
