<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xlink="http://www.w3.org/1999/xlink"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:functx="http://www.functx.com" 
xmlns:doc="http://www.pnp-software.com/XSLTdoc" xmlns:opfun="http://data.europa.eu/p27/ted-xml-data-converter"
xmlns:ted="http://publications.europa.eu/resource/schema/ted/R2.0.9/publication" xmlns:n2016="http://publications.europa.eu/resource/schema/ted/2016/nuts" 
xmlns:efbc="http://data.europa.eu/p27/eforms-ubl-extension-basic-components/1" xmlns:efac="http://data.europa.eu/p27/eforms-ubl-extension-aggregate-components/1" xmlns:efext="http://data.europa.eu/p27/eforms-ubl-extensions/1" xmlns:pin="urn:oasis:names:specification:ubl:schema:xsd:PriorInformationNotice-2" xmlns:cn="urn:oasis:names:specification:ubl:schema:xsd:ContractNotice-2" xmlns:can="urn:oasis:names:specification:ubl:schema:xsd:ContractAwardNotice-2"
xmlns:ccts="urn:un:unece:uncefact:documentation:2" xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
xmlns:gc="http://docs.oasis-open.org/codelist/ns/genericode/1.0/"
exclude-result-prefixes="xlink xs xsi fn functx doc opfun ted gc n2016 pin cn can ccts " 
>
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

<xsl:template match="ted:PROCUREMENT_LAW">
	<xsl:variable name="text" select="fn:normalize-space(fn:string-join(ted:P, ' '))"/>
	<xsl:if test="$text ne ''">
		<cac:ProcurementLegislationDocumentReference>
			<cbc:ID>LocalLegalBasis</cbc:ID>
			<cbc:DocumentDescription languageID="{$eforms-first-language}"><xsl:value-of select="$text"/></cbc:DocumentDescription>
		</cac:ProcurementLegislationDocumentReference>
	</xsl:if>
</xsl:template>

<!-- NO_LOT_DIVISION does not need to be converted, as it implies no need for cac:LotDistribution -->
<xsl:template match="ted:LOT_DIVISION[ted:LOT_MAX_ONE_TENDERER|ted:LOT_ALL|ted:LOT_MAX_NUMBER|ted:LOT_ONE_ONLY]">
	<!-- LOT_DIVISION is a child only of OBJECT_CONTRACT -->
	<!-- LOT_DIVISION has children: LOT_ALL LOT_COMBINING_CONTRACT_RIGHT LOT_MAX_NUMBER LOT_MAX_ONE_TENDERER LOT_ONE_ONLY -->

	<cac:LotDistribution>
		<!-- Lots Max Awarded (BT-33) cardinality ? Optional for PIN subtypes 7-9, CN subtypes 10-14, 16-24, and E3; Forbidden for other subtypes -->
		<xsl:comment>Lots Max Awarded (BT-33)</xsl:comment>
		<xsl:apply-templates select="ted:LOT_MAX_ONE_TENDERER"/>
		<!-- Lots Max Allowed (BT-31) cardinality ? Optional for PIN subtypes 7-9, CN subtypes 10-14, 16-24, and E3; Forbidden for other subtypes -->
		<xsl:comment>Lots Max Allowed (BT-31)</xsl:comment>
		<!-- Tenders may be submitted for: LOT_ALL LOT_MAX_NUMBER LOT_ONE_ONLY -->
		<xsl:apply-templates select="ted:LOT_ALL|ted:LOT_MAX_NUMBER|ted:LOT_ONE_ONLY"/>
	</cac:LotDistribution>
</xsl:template>

<xsl:template name="main-features-award">
	<!-- Procedure Features (BT-88) cardinality ? Mandatory for CN subtypes 12, 13, 20, and 21; Optional for PIN subtypes 7-9, CN subtypes 10, 11, 16-19, 22-24, and E3, CAN subtypes 29-37 and E4, CM subtype E5; Forbidden for other subtypes -->
	<xsl:comment>Procedure Features (BT-88)</xsl:comment>
	<xsl:variable name="text" select="fn:normalize-space(fn:string-join(ted:PROCEDURE/ted:MAIN_FEATURES_AWARD/ted:P, ' '))"/>
		<xsl:choose>
			<xsl:when test="$text ne ''">
					<cbc:Description languageID="{$eforms-first-language}"><xsl:value-of select="$text"/></cbc:Description>
			</xsl:when>
			<xsl:when test="$eforms-notice-subtype = ('12','13', '20', '21')">
					<cbc:Description languageID="{$eforms-first-language}"><xsl:comment>ERROR: Procedure Features (BT-88) is Mandatory for eForms subtypes 12, 13, 20 and 21, but no MAIN_FEATURES_AWARD was found in TED XML.</xsl:comment></cbc:Description>	
			</xsl:when>
		</xsl:choose>			
</xsl:template>	
			
<xsl:template match="ted:PT_OPEN|ted:PT_RESTRICTED|ted:PT_COMPETITIVE_NEGOTIATION|ted:PT_COMPETITIVE_DIALOGUE|ted:PT_INNOVATION_PARTNERSHIP|ted:PT_INVOLVING_NEGOTIATION|ted:PT_NEGOTIATED_WITH_PRIOR_CALL">
	<xsl:variable name="element-name" select="fn:local-name(.)"/>
	<xsl:variable name="eforms-procedure-type" select="$mappings//procedure-types/mapping[ted-value eq $element-name]/fn:string(eforms-value)"/>
	<cbc:ProcedureCode listName="procurement-procedure-type"><xsl:value-of select="$eforms-procedure-type"/></cbc:ProcedureCode>
</xsl:template>
	
<xsl:template match="ted:NOTICE_NUMBER_OJ">
	<xsl:variable name="text" select="fn:normalize-space(.)"/>
	<cac:NoticeDocumentReference>
		<cbc:ID schemeName="ojs-notice-id"><xsl:value-of select="$text"/></cbc:ID>
	</cac:NoticeDocumentReference>
</xsl:template>
	
<xsl:template match="ted:ACCELERATED_PROC">
	<xsl:variable name="text" select="fn:normalize-space(fn:string-join(ted:P, ' '))"/>
	<cac:ProcessJustification>
		<!-- Procedure Accelerated (BT-106) cardinality ? Optional for CN subtypes 16-18 and E3, CAN subtypes 29-31 and E4, CM subtype E5; Forbidden for other subtypes -->
		<xsl:comment>Procedure Accelerated (BT-106)</xsl:comment>
		<cbc:ProcessReasonCode listName="accelerated-procedure">true</cbc:ProcessReasonCode>
		<!-- Procedure Accelerated Justification (BT-1351) cardinality ? Optional for CN subtypes 16-18 and E3, CAN subtypes 29-31 and E4, CM subtype E5; Forbidden for other subtypes -->
		<xsl:comment>Procedure Accelerated Justification (BT-1351)</xsl:comment>
		<xsl:if test="$text ne ''">
			<cbc:ProcessReason languageID="{$eforms-first-language}"><xsl:value-of select="$text"/></cbc:ProcessReason>
		</xsl:if>
	</cac:ProcessJustification>
</xsl:template>

<xsl:template match="ted:TITLE">
	<xsl:variable name="text" select="fn:normalize-space(fn:string-join(ted:P, ' '))"/>
	<cbc:Name languageID="{$eforms-first-language}"><xsl:value-of select="$text"/></cbc:Name>
</xsl:template>

<xsl:template match="ted:SHORT_DESCR">
	<xsl:variable name="text" select="fn:normalize-space(fn:string-join(ted:P, ' '))"/>
	<cbc:Description languageID="{$eforms-first-language}"><xsl:value-of select="$text"/></cbc:Description>
</xsl:template>

<xsl:template match="ted:TYPE_CONTRACT">
	<xsl:variable name="ted-value" select="fn:normalize-space(@CTYPE)"/>
	<xsl:variable name="eforms-contract-nature-type" select="$mappings//contract-nature-types/mapping[ted-value eq $ted-value]/fn:string(eforms-value)"/>
	<cbc:ProcurementTypeCode listName="contract-nature"><xsl:value-of select="$eforms-contract-nature-type"/></cbc:ProcurementTypeCode>
</xsl:template>
	
<xsl:template match="ted:VAL_ESTIMATED_TOTAL|ted:VAL_OBJECT">
	<xsl:variable name="ted-value" select="fn:normalize-space(.)"/>
	<xsl:variable name="currency" select="fn:normalize-space(@CURRENCY)"/>
	<cac:RequestedTenderTotal>
		<cbc:EstimatedOverallContractAmount currencyID="{$currency}"><xsl:value-of select="$ted-value"/></cbc:EstimatedOverallContractAmount>
	</cac:RequestedTenderTotal>
</xsl:template>

<xsl:template match="ted:CPV_MAIN|ted:CPV_ADDITIONAL">
	<xsl:variable name="ted-value" select="fn:normalize-space(ted:CPV_CODE/@CODE)"/>
	<cac:MainCommodityClassification>
		<cbc:ItemClassificationCode listName="cpv"><xsl:value-of select="$ted-value"/></cbc:ItemClassificationCode>
	</cac:MainCommodityClassification>
	<!-- "Supplementary CPV" (CPV_MAIN/CPV_SUPPLEMENTARY_CODE) are not implemented for eForms -->
</xsl:template>

</xsl:stylesheet>
