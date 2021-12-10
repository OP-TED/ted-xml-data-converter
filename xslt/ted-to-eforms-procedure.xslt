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

	<xsl:template match="ted:PROCUREMENT_LAW">
		<xsl:variable name="text" select="fn:normalize-space(fn:string-join(ted:P, ' '))"/>
		<xsl:if test="$text ne ''">
			<cac:ProcurementLegislationDocumentReference>
				<cbc:ID>LocalLegalBasis</cbc:ID>
				<cbc:DocumentDescription languageID="{$eforms-first-language}"><xsl:value-of select="$text"/></cbc:DocumentDescription>
			</cac:ProcurementLegislationDocumentReference>
		</xsl:if>
	</xsl:template>

	<xsl:template match="ted:LOT_DIVISION[ted:LOT_MAX_ONE_TENDERER|ted:LOT_ALL|ted:LOT_MAX_NUMBER|ted:LOT_ONE_ONLY]">
		<!-- LOT_DIVISION is a child only of OBJECT_CONTRACT -->
		<!-- LOT_DIVISION has children: LOT_ALL LOT_COMBINING_CONTRACT_RIGHT LOT_MAX_NUMBER LOT_MAX_ONE_TENDERER LOT_ONE_ONLY -->
	
		<cac:LotDistribution>
			<!-- Lots Max Awarded (BT-33), Lots Max Allowed (BT-31)  -->
			<!-- F01_2014 F02_2014 F04_2014 F05_2014 F21_2014 F22_2014 F23_2014 F24_2014 -->
			<!-- Lots Max Awarded (BT-33) The maximum number of Lots that can be awarded to one economic operator -->
			<xsl:apply-templates select="ted:LOT_MAX_ONE_TENDERER"/>
			<!-- Lots Max Allowed (BT-31) The maximum number of Lots that one economic operator can submit a tender for -->
			<!-- Tenders may be submmitted for: LOT_ALL LOT_MAX_NUMBER LOT_ONE_ONLY -->
			<xsl:apply-templates select="ted:LOT_ALL|ted:LOT_MAX_NUMBER|ted:LOT_ONE_ONLY"/>
			
			<!--
		<xs:element name="LOT_ALL" type="empty"/>
		<xs:element name="LOT_ONE_ONLY" type="empty"/>
		<xs:element name="LOT_MAX_NUMBER" type="nb_lot"/>
	
	-->
		</cac:LotDistribution>
	</xsl:template>
	
	
	<xsl:template match="ted:PT_OPEN|ted:PT_RESTRICTED|ted:PT_COMPETITIVE_NEGOTIATION|ted:PT_COMPETITIVE_DIALOGUE|ted:PT_INNOVATION_PARTNERSHIP">
		<xsl:variable name="element-name" select="fn:local-name(.)"/>
		<xsl:variable name="eforms-procedure-type" select="$mappings//procedure-types/mapping[ted-element-name eq $element-name]/fn:string(procurement-procedure-type)"/>
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
		<xsl:variable name="eforms-contract-nature-type" select="$mappings//contract-nature-types/mapping[type-contract eq $ted-value]/fn:string(contract-nature)"/>
		<cbc:ProcurementTypeCode listName="contract-nature"><xsl:value-of select="$eforms-contract-nature-type"/></cbc:ProcurementTypeCode>
	</xsl:template>
	
	<xsl:template match="ted:VAL_ESTIMATED_TOTAL">
		<xsl:variable name="ted-value" select="fn:normalize-space(.)"/>
		<xsl:variable name="currency" select="fn:normalize-space(@CURRENCY)"/>
		<cac:RequestedTenderTotal>
			<cbc:EstimatedOverallContractAmount currencyID="{$currency}"><xsl:value-of select="$ted-value"/></cbc:EstimatedOverallContractAmount>
		</cac:RequestedTenderTotal>
	</xsl:template>


</xsl:stylesheet>
