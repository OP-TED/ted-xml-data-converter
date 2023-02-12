<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xlink="http://www.w3.org/1999/xlink"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:doc="http://www.pnp-software.com/XSLTdoc" 
xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:functx="http://www.functx.com" xmlns:opfun="http://data.europa.eu/p27/ted-xml-data-converter"
xmlns:ted="http://publications.europa.eu/resource/schema/ted/R2.0.8/publication" xmlns:n2016="http://publications.europa.eu/resource/schema/ted/2016/nuts" xmlns:n2021="http://publications.europa.eu/resource/schema/ted/2021/nuts"
xmlns:pin="urn:oasis:names:specification:ubl:schema:xsd:PriorInformationNotice-2" xmlns:cn="urn:oasis:names:specification:ubl:schema:xsd:ContractNotice-2" xmlns:can="urn:oasis:names:specification:ubl:schema:xsd:ContractAwardNotice-2"
xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"
xmlns:efbc="http://data.europa.eu/p27/eforms-ubl-extension-basic-components/1" xmlns:efac="http://data.europa.eu/p27/eforms-ubl-extension-aggregate-components/1" xmlns:efext="http://data.europa.eu/p27/eforms-ubl-extensions/1" 
xmlns:ccts="urn:un:unece:uncefact:documentation:2" xmlns:gc="http://docs.oasis-open.org/codelist/ns/genericode/1.0/"
exclude-result-prefixes="xlink xs xsi fn functx doc opfun ted gc n2016 n2021 pin cn can ccts ext" >
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

<!--<xsl:template match="ted:OBJECT_CONTRACT/ted:TITLE">
--><xsl:template match="ted:TITLE_CONTRACT">
	<xsl:variable name="text" select="fn:normalize-space(fn:string-join(ted:P, ' '))"/>
	<xsl:call-template name="multilingual">
		<xsl:with-param name="contexts" select="."/>
		<xsl:with-param name="local" select="'P'"/>
		<xsl:with-param name="element" select="'cbc:Name'"/>
	</xsl:call-template>
</xsl:template>

<!--<xsl:template match="ted:SHORT_DESCR">-->
<xsl:template match="ted:TOTAL_QUANTITY_OR_SCOPE">
	<xsl:variable name="text" select="fn:normalize-space(fn:string-join(ted:P, ' '))"/>
	<xsl:call-template name="multilingual">
		<xsl:with-param name="contexts" select="."/>
		<xsl:with-param name="local" select="'P'"/>
		<xsl:with-param name="element" select="'cbc:Description'"/>
	</xsl:call-template>
</xsl:template>

<!--<xsl:template match="ted:TYPE_CONTRACT"> kept it below-->
<xsl:template match="ted:FD_PRIOR_INFORMATION_DEFENCE">
	<xsl:variable name="ted-value" select="fn:normalize-space(@CTYPE)"/>
	<xsl:variable name="eforms-contract-nature-type" select="$mappings//contract-nature-types/mapping[ted-value eq $ted-value]/fn:string(eforms-value)"/>
	<cbc:ProcurementTypeCode listName="contract-nature"><xsl:value-of select="$eforms-contract-nature-type"/></cbc:ProcurementTypeCode>
</xsl:template>
<xsl:template match="ted:TYPE_CONTRACT">
	<xsl:variable name="ted-value" select="fn:normalize-space(@VALUE)"/>
	<xsl:variable name="eforms-contract-nature-type" select="$mappings//contract-nature-types/mapping[ted-value eq $ted-value]/fn:string(eforms-value)"/>
	<cbc:ProcurementTypeCode listName="contract-nature"><xsl:value-of select="$eforms-contract-nature-type"/></cbc:ProcurementTypeCode>
</xsl:template>
	
<xsl:template match="ted:CPV_MAIN">
	<xsl:variable name="ted-value" select="fn:normalize-space(ted:CPV_CODE/@CODE)"/>
	<cac:MainCommodityClassification>
		<cbc:ItemClassificationCode listName="cpv"><xsl:value-of select="$ted-value"/></cbc:ItemClassificationCode>
	</cac:MainCommodityClassification>
</xsl:template>

<xsl:template match="ted:CPV_ADDITIONAL">
	<xsl:variable name="ted-value" select="fn:normalize-space(ted:CPV_CODE/@CODE)"/>
	<cac:AdditionalCommodityClassification>
		<cbc:ItemClassificationCode listName="cpv"><xsl:value-of select="$ted-value"/></cbc:ItemClassificationCode>
	</cac:AdditionalCommodityClassification>
</xsl:template>

<xsl:template match="ted:SITE_OR_LOCATION[not(*:NUTS)]/ted:LABEL">
	<xsl:variable name="text" select="fn:normalize-space(fn:string-join(ted:P, ' '))"/>
	<cac:RealizedLocation>
		<xsl:call-template name="multilingual">
			<xsl:with-param name="contexts" select="."/>
			<xsl:with-param name="local" select="'P'"/>
			<xsl:with-param name="element" select="'cbc:Description'"/>
		</xsl:call-template>
	</cac:RealizedLocation>
</xsl:template>

<xsl:template match="ted:SITE_OR_LOCATION/*:NUTS">
	<xsl:variable name="text" select="fn:normalize-space(fn:string-join(./ted:LABEL/ted:P, ' '))"/>
	<cac:RealizedLocation>
		<xsl:call-template name="multilingual">
			<xsl:with-param name="contexts" select="../ted:LABEL"/>
			<xsl:with-param name="local" select="'P'"/>
			<xsl:with-param name="element" select="'cbc:Description'"/>
		</xsl:call-template>
		<cbc:CountrySubentityCode listName="nuts"><xsl:value-of select="@CODE"/></cbc:CountrySubentityCode>
	</cac:RealizedLocation>
</xsl:template>     
</xsl:stylesheet>
