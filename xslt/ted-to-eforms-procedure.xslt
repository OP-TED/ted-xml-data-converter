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

	
	<xsl:template match="ted:PT_OPEN|ted:PT_RESTRICTED|ted:PT_COMPETITIVE_NEGOTIATION|ted:PT_COMPETITIVE_DIALOGUE|ted:PT_INNOVATION_PARTNERSHIP">
		<xsl:variable name="element-name" select="fn:local-name(.)"/>
		<xsl:variable name="eforms-procedure-type" select="$procedure-types//mapping[ted-element-name eq $element-name]/fn:string(procurement-procedure-type)"/>
		<cbc:ProcedureCode listName="procurement-procedure-type"><xsl:value-of select="$eforms-procedure-type"/></cbc:ProcedureCode>
	</xsl:template>

	<xsl:template match="ted:ACCELERATED_PROC">
		<xsl:variable name="text" select="fn:normalize-space(fn:string-join(ted:P, ' '))"/>
		<cac:ProcessJustification>
			<cbc:ProcessReasonCode listName="accelerated-procedure">true</cbc:ProcessReasonCode>
			<xsl:if test="$text ne ''">
				<cbc:ProcessReason languageID="{$eforms-first-language}"><xsl:value-of select="$text"/></cbc:ProcessReason>
			</xsl:if>
		</cac:ProcessJustification>
	</xsl:template>



</xsl:stylesheet>
