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


<xsl:template match="ted:PROCUREMENT_LAW">
	<xsl:variable name="text" select="fn:normalize-space(fn:string-join(ted:P, ' '))"/>
	<xsl:if test="$text ne ''">
		<cac:ProcurementLegislationDocumentReference>
			<cbc:ID>LocalLegalBasis</cbc:ID>
			<xsl:call-template name="multilingual">
				<xsl:with-param name="contexts" select="."/>
				<xsl:with-param name="local" select="'P'"/>
				<xsl:with-param name="element" select="'cbc:DocumentDescription'"/>
			</xsl:call-template>
		</cac:ProcurementLegislationDocumentReference>
	</xsl:if>
</xsl:template>

<!-- NO_LOT_DIVISION does not need to be converted, as it implies no need for cac:LotDistribution -->
<xsl:template match="ted:LOT_DIVISION[ted:LOT_MAX_ONE_TENDERER|ted:LOT_ALL|ted:LOT_MAX_NUMBER|ted:LOT_ONE_ONLY]">
	<!-- LOT_DIVISION is a child only of OBJECT_CONTRACT -->
	<!-- LOT_DIVISION has children: LOT_ALL LOT_COMBINING_CONTRACT_RIGHT LOT_MAX_NUMBER LOT_MAX_ONE_TENDERER LOT_ONE_ONLY -->

	<cac:LotDistribution>
		<!-- Lots Max Awarded (BT-33): eForms documentation cardinality (Procedure) = ? | Optional for PIN subtypes 7-9, CN subtypes 10-14, 16-24, and E3; Forbidden for other subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Lots Max Awarded (BT-33)'"/></xsl:call-template>
		<xsl:apply-templates select="ted:LOT_MAX_ONE_TENDERER"/>
		<!-- Lots Max Allowed (BT-31): eForms documentation cardinality (Procedure) = ? | Optional for PIN subtypes 7-9, CN subtypes 10-14, 16-24, and E3; Forbidden for other subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Lots Max Allowed (BT-31)'"/></xsl:call-template>
		<!-- Tenders may be submitted for: LOT_ALL LOT_MAX_NUMBER LOT_ONE_ONLY -->
		<xsl:apply-templates select="ted:LOT_ALL|ted:LOT_MAX_NUMBER|ted:LOT_ONE_ONLY"/>
	</cac:LotDistribution>
</xsl:template>

<xsl:template name="main-features-award">
	<!-- Procedure Features (BT-88): eForms documentation cardinality (Procedure) = ? | Mandatory for CN subtypes 12, 13, 20, and 21; Optional for PIN subtypes 7-9, CN subtypes 10, 11, 16-19, 22-24, and E3, CAN subtypes 29-37 and E4, CM subtype E5; Forbidden for other subtypes -->
	<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Procedure Features (BT-88)'"/></xsl:call-template>
	<xsl:variable name="text" select="fn:normalize-space(fn:string-join(ted:PROCEDURE/ted:MAIN_FEATURES_AWARD/ted:P, ' '))"/>
		<xsl:choose>
			<xsl:when test="$text ne ''">
				<xsl:call-template name="multilingual">
					<xsl:with-param name="contexts" select="ted:PROCEDURE/ted:MAIN_FEATURES_AWARD"/>
					<xsl:with-param name="local" select="'P'"/>
					<xsl:with-param name="element" select="'cbc:Description'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$eforms-notice-subtype = ('12','13', '20', '21')">
				<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'WARNING: Procedure Features (BT-88) is Mandatory for eForms subtypes 12, 13, 20 and 21, but no MAIN_FEATURES_AWARD was found in TED XML.'"/></xsl:call-template>
				<cbc:Description languageID="{$eforms-first-language}"></cbc:Description>
			</xsl:when>
		</xsl:choose>
</xsl:template>

<xsl:template match="ted:PT_OPEN|ted:PT_RESTRICTED|ted:PT_COMPETITIVE_NEGOTIATION|ted:PT_COMPETITIVE_DIALOGUE|ted:PT_INNOVATION_PARTNERSHIP|ted:PT_INVOLVING_NEGOTIATION|ted:PT_NEGOTIATED_WITH_PRIOR_CALL|ted:PT_AWARD_CONTRACT_WITHOUT_CALL|ted:PT_AWARD_CONTRACT_WITH_PRIOR_PUBLICATION|ted:PT_AWARD_CONTRACT_WITHOUT_PUBLICATION|ted:PT_NEGOTIATED_WITHOUT_PUBLICATION">
	<xsl:variable name="element-name" select="fn:local-name(.)"/>
	<xsl:variable name="eforms-procedure-type" select="$mappings//procedure-types/mapping[ted-value eq $element-name]/fn:string(eforms-value)"/>
	<cbc:ProcedureCode listName="procurement-procedure-type"><xsl:value-of select="$eforms-procedure-type"/></cbc:ProcedureCode>
</xsl:template>

<xsl:template name="pin-competition-termination">
<!-- PIN Competition Termination (BT-756): eForms documentation cardinality (Procedure) = ? | Optional for CAN subtypes 29, 30, 33, and 34; Forbidden for other subtypes -->
<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'PIN Competition Termination (BT-756)'"/></xsl:call-template>
	<xsl:if test="ted:PROCEDURE/(ted:PT_NEGOTIATED_WITH_PRIOR_CALL|ted:PT_COMPETITIVE_NEGOTIATION)">
		<xsl:choose>
			<xsl:when test="ted:PROCEDURE/ted:TERMINATION_PIN">
				<cbc:TerminatedIndicator>true</cbc:TerminatedIndicator>
			</xsl:when>
			<xsl:otherwise>
				<cbc:TerminatedIndicator>false</cbc:TerminatedIndicator>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:if>
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
		<!-- Procedure Accelerated (BT-106): eForms documentation cardinality (Procedure) = ? | Optional for CN subtypes 16-18 and E3, CAN subtypes 29-31 and E4, CM subtype E5; Forbidden for other subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Procedure Accelerated (BT-106)'"/></xsl:call-template>
		<cbc:ProcessReasonCode listName="accelerated-procedure">true</cbc:ProcessReasonCode>
		<!-- Procedure Accelerated Justification (BT-1351): eForms documentation cardinality (Procedure) = ? | Optional for CN subtypes 16-18 and E3, CAN subtypes 29-31 and E4, CM subtype E5; Forbidden for other subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Procedure Accelerated Justification (BT-1351)'"/></xsl:call-template>
		<xsl:if test="$text ne ''">
			<xsl:call-template name="multilingual">
				<xsl:with-param name="contexts" select="."/>
				<xsl:with-param name="local" select="'P'"/>
				<xsl:with-param name="element" select="'cbc:ProcessReason'"/>
			</xsl:call-template>
		</xsl:if>
	</cac:ProcessJustification>
</xsl:template>

<xsl:template name="direct-award-justification">
	<!-- Direct Award Justification Previous Procedure Identifier (BT-1252): eForms documentation cardinality (Procedure) = ? | Optional for CAN subtypes 25-35 and E4, CM subtype E5; Forbidden for other subtypes. No equivalent element in TED XML-->
	<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Direct Award Justification Previous Procedure Identifier (BT-1252)'"/></xsl:call-template>
	<!-- Direct Award Justification (BT-136): eForms documentation cardinality (Procedure) = ? | Optional for CAN subtypes 25-35 and E4, CM subtype E5; Forbidden for other subtypes -->
	<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Direct Award Justification (BT-136)'"/></xsl:call-template>
	<!-- Direct Award Justification (BT-135): eForms documentation cardinality (Procedure) = ? | Optional for CAN subtypes 25-35 and E4, CM subtype E5; Forbidden for other subtypes -->
	<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Direct Award Justification (BT-135)'"/></xsl:call-template>

	<xsl:if test="ted:PROCEDURE/(ted:PT_AWARD_CONTRACT_WITHOUT_CALL|PT_AWARD_CONTRACT_WITHOUT_PUBLICATION)">
	<xsl:variable name="text" select="fn:normalize-space(fn:string-join(ted:PROCEDURE/(ted:PT_AWARD_CONTRACT_WITHOUT_CALL|PT_AWARD_CONTRACT_WITHOUT_PUBLICATION)/ted:D_JUSTIFICATION/ted:P, ' '))"/>
		<xsl:for-each select="ted:PROCEDURE/ted:PT_AWARD_CONTRACT_WITHOUT_CALL/(ted:D_ACCORDANCE_ARTICLE/*|ted:D_OUTSIDE_SCOPE)">
		<cac:ProcessJustification>
			<xsl:variable name="element-name" select="fn:local-name(.)"/>
			<xsl:variable name="justification" select="$mappings//direct-award-justifications/mapping[ted-value eq $element-name]/fn:string(eforms-value)"/>
			<cbc:ProcessReasonCode listName="direct-award-justification"><xsl:value-of select="$justification"/></cbc:ProcessReasonCode>
			<xsl:if test="$text ne ''">
				<xsl:call-template name="multilingual">
					<xsl:with-param name="contexts" select="ted:PROCEDURE/ted:PT_AWARD_CONTRACT_WITHOUT_CALL/ted:D_JUSTIFICATION"/>
					<xsl:with-param name="local" select="'P'"/>
					<xsl:with-param name="element" select="'cbc:ProcessReason'"/>
				</xsl:call-template>
			</xsl:if>
		</cac:ProcessJustification>
		</xsl:for-each>
	</xsl:if>
</xsl:template>

<xsl:template name="procedure-note">
	<xsl:variable name="info-add" select="fn:normalize-space(fn:string-join(ted:COMPLEMENTARY_INFO/ted:INFO_ADD/ted:P, ' '))"/>
	<xsl:variable name="url-national-procedure" select="fn:normalize-space(ted:PROCEDURE/ted:URL_NATIONAL_PROCEDURE)"/>
	<xsl:if test="($info-add ne '') or ($url-national-procedure ne '')">
		<xsl:choose>
			<xsl:when test="fn:false()">
				<xsl:for-each select="($ted-form-main-element, $ted-form-additional-elements)">
					<xsl:variable name="form-element" select="."/>
					<xsl:variable name="ted-language" select="fn:string(@LG)"/>
						<xsl:variable name="language" select="opfun:get-eforms-language($ted-language)"/>
						<xsl:variable name="info-add-lang" as="xs:string">
							<xsl:if test="$info-add">
								<xsl:variable name="parent">
									<xsl:call-template name="find-element">
										<xsl:with-param name="context" select="$form-element"/>
										<xsl:with-param name="relative-context" select="'COMPLEMENTARY_INFO/INFO_ADD'"/>
									</xsl:call-template>
								</xsl:variable>
								<xsl:value-of select="fn:normalize-space(fn:string-join($parent/*/ted:P, ' '))"/>
							</xsl:if>
						</xsl:variable>
						<xsl:variable name="url-national-procedure-lang">
							<xsl:if test="$url-national-procedure">
								<xsl:variable name="parent">
									<xsl:call-template name="find-element">
										<xsl:with-param name="context" select="$form-element"/>
										<xsl:with-param name="relative-context" select="'PROCEDURE/URL_NATIONAL_PROCEDURE'"/>
									</xsl:call-template>
								</xsl:variable>
								<xsl:value-of select="fn:normalize-space($parent/*)"/>
							</xsl:if>
						</xsl:variable>
					<xsl:variable name="text">
						<xsl:value-of select="$info-add-lang"/>
						<xsl:if test="$url-national-procedure-lang">
							<xsl:variable name="form-text" select="$translations//translation[@key='procedure-note']/text[@lang=$ted-language]/fn:string()"/>
							<xsl:if test="$info-add-lang"><xsl:text> </xsl:text></xsl:if>
							<xsl:value-of select="$form-text"/>
							<xsl:value-of select="$url-national-procedure-lang"/>
						</xsl:if>
					</xsl:variable>
					<xsl:if test="$text ne ''">
						<cbc:Note languageID="{$language}"><xsl:value-of select="$text"/></cbc:Note>
					</xsl:if>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="form-text" select="$translations//translation[@key='procedure-note']/text[@lang=$ted-form-first-language]/fn:string()"/>
				<xsl:variable name="text">
					<xsl:value-of select="$info-add"/>
					<xsl:if test="$url-national-procedure">
						<xsl:if test="$info-add"><xsl:text> </xsl:text></xsl:if>
						<xsl:value-of select="$form-text"/>
						<xsl:value-of select="$url-national-procedure"/>
					</xsl:if>
				</xsl:variable>
				<xsl:if test="$text ne ''">
					<cbc:Note languageID="{$eforms-first-language}"><xsl:value-of select="$text"/></cbc:Note>
				</xsl:if>
		</xsl:otherwise>
	</xsl:choose>
	</xsl:if>
</xsl:template>

<!--<xsl:template match="ted:OBJECT_CONTRACT/ted:VAL_ESTIMATED_TOTAL|ted:VAL_OBJECT">
--><xsl:template match="ted:FD_PRIOR_INFORMATION_DEFENCE/ted:OBJECT_WORKS_SUPPLIES_SERVICES_PRIOR_INFORMATION/ted:QUANTITY_SCOPE_WORKS_DEFENCE/ted:COSTS_RANGE_AND_CURRENCY/ted:VALUE_COST">
	<xsl:variable name="ted-value" select="fn:normalize-space(.)"/>
	<xsl:variable name="currency" select="fn:normalize-space(../@CURRENCY)"/>
	<cac:RequestedTenderTotal>
		<cbc:EstimatedOverallContractAmount currencyID="{$currency}"><xsl:value-of select="$ted-value"/></cbc:EstimatedOverallContractAmount>
	</cac:RequestedTenderTotal>
</xsl:template>
<xsl:template match="ted:FD_PRIOR_INFORMATION_DEFENCE/ted:OBJECT_WORKS_SUPPLIES_SERVICES_PRIOR_INFORMATION/ted:QUANTITY_SCOPE_WORKS_DEFENCE/ted:COSTS_RANGE_AND_CURRENCY/ted:RANGE_VALUE_COST">
	<xsl:variable name="ted-value" select="fn:normalize-space(./ted:HIGH_VALUE)"/>
	<xsl:variable name="currency" select="fn:normalize-space(../@CURRENCY)"/>
	<cac:RequestedTenderTotal>
		<cbc:EstimatedOverallContractAmount currencyID="{$currency}"><xsl:value-of select="$ted-value"/></cbc:EstimatedOverallContractAmount>
	</cac:RequestedTenderTotal>
</xsl:template>

</xsl:stylesheet>
