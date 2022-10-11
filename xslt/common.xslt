<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xlink="http://www.w3.org/1999/xlink"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:doc="http://www.pnp-software.com/XSLTdoc" 
xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:functx="http://www.functx.com" xmlns:opfun="http://data.europa.eu/p27/ted-xml-data-converter"
xmlns:ted="http://publications.europa.eu/resource/schema/ted/R2.0.9/publication" 
xmlns:ted-1="http://formex.publications.europa.eu/ted/schema/export/R2.0.9.S01.E01"
xmlns:n2016-1="ted/2016/nuts"
xmlns:n2016="http://publications.europa.eu/resource/schema/ted/2016/nuts" xmlns:n2021="http://publications.europa.eu/resource/schema/ted/2021/nuts"
xmlns:pin="urn:oasis:names:specification:ubl:schema:xsd:PriorInformationNotice-2" xmlns:cn="urn:oasis:names:specification:ubl:schema:xsd:ContractNotice-2" xmlns:can="urn:oasis:names:specification:ubl:schema:xsd:ContractAwardNotice-2"
xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"
xmlns:efbc="http://data.europa.eu/p27/eforms-ubl-extension-basic-components/1" xmlns:efac="http://data.europa.eu/p27/eforms-ubl-extension-aggregate-components/1" xmlns:efext="http://data.europa.eu/p27/eforms-ubl-extensions/1" 
xmlns:ccts="urn:un:unece:uncefact:documentation:2" xmlns:gc="http://docs.oasis-open.org/codelist/ns/genericode/1.0/"
exclude-result-prefixes="xlink xs xsi fn functx doc opfun ted ted-1 gc n2016-1 n2016 n2021 pin cn can ccts ext" >
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

<xsl:template match="*:OBJECT_CONTRACT/*:TITLE">
	<xsl:variable name="text" select="fn:normalize-space(fn:string-join(*:P, ' '))"/>
	<xsl:call-template name="multilingual">
		<xsl:with-param name="contexts" select="."/>
		<xsl:with-param name="local" select="'P'"/>
		<xsl:with-param name="element" select="'cbc:Name'"/>
	</xsl:call-template>
</xsl:template>

<xsl:template match="*:SHORT_DESCR">
	<xsl:variable name="text" select="fn:normalize-space(fn:string-join(*:P, ' '))"/>
	<xsl:call-template name="multilingual">
		<xsl:with-param name="contexts" select="."/>
		<xsl:with-param name="local" select="'P'"/>
		<xsl:with-param name="element" select="'cbc:Description'"/>
	</xsl:call-template>
</xsl:template>

<xsl:template match="*:TYPE_CONTRACT">
	<xsl:variable name="ted-value" select="fn:normalize-space(@CTYPE)"/>
	<xsl:variable name="eforms-contract-nature-type" select="$mappings//contract-nature-types/mapping[ted-value eq $ted-value]/fn:string(eforms-value)"/>
	<cbc:ProcurementTypeCode listName="contract-nature"><xsl:value-of select="$eforms-contract-nature-type"/></cbc:ProcurementTypeCode>
</xsl:template>
	
<xsl:template match="*:CPV_MAIN">
	<xsl:variable name="ted-value" select="fn:normalize-space(*:CPV_CODE/@CODE)"/>
	<cac:MainCommodityClassification>
		<cbc:ItemClassificationCode listName="cpv"><xsl:value-of select="$ted-value"/></cbc:ItemClassificationCode>
	</cac:MainCommodityClassification>
</xsl:template>

<xsl:template match="*:CPV_ADDITIONAL">
	<xsl:variable name="ted-value" select="fn:normalize-space(*:CPV_CODE/@CODE)"/>
	<cac:AdditionalCommodityClassification>
		<cbc:ItemClassificationCode listName="cpv"><xsl:value-of select="$ted-value"/></cbc:ItemClassificationCode>
	</cac:AdditionalCommodityClassification>
</xsl:template>

</xsl:stylesheet>
