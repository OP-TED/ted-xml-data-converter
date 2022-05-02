<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:functx="http://www.functx.com" 
xmlns:doc="http://www.pnp-software.com/XSLTdoc" xmlns:opfun="http://data.europa.eu/p27/ted-xml-data-converter"
xmlns:ted="http://publications.europa.eu/resource/schema/ted/R2.0.9/publication" xmlns:n2016="http://publications.europa.eu/resource/schema/ted/2016/nuts" 
xmlns:efbc="http://data.europa.eu/p27/eforms-ubl-extension-basic-components/1" xmlns:efac="http://data.europa.eu/p27/eforms-ubl-extension-aggregate-components/1" xmlns:efext="http://data.europa.eu/p27/eforms-ubl-extensions/1" xmlns:pin="urn:oasis:names:specification:ubl:schema:xsd:PriorInformationNotice-2" xmlns:cn="urn:oasis:names:specification:ubl:schema:xsd:ContractNotice-2" xmlns:can="urn:oasis:names:specification:ubl:schema:xsd:ContractAwardNotice-2"
xmlns:ccts="urn:un:unece:uncefact:documentation:2" xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
xmlns:gc="http://docs.oasis-open.org/codelist/ns/genericode/1.0/"
exclude-result-prefixes="xs xsi fn functx doc opfun ted gc n2016 pin cn can ccts ext" >
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>


	<!-- Template to create cac:AwardingTerms -->
	<xsl:template name="awarding-terms">
		<!-- TBD: will need to determine rules for including main element cac:AwardingTerms -->
		<cac:AwardingTerms>
			<!-- Following Contract (BT-41) cardinality + Mandatory for CN subtypes 23 and 24; Forbidden for other subtypes -->
			<xsl:comment>Following Contract (BT-41)</xsl:comment>
			<!-- Jury Decision Binding (BT-42) cardinality + Mandatory for CN subtypes 23 and 24; Forbidden for other subtypes -->
			<xsl:comment>Jury Decision Binding (BT-42)</xsl:comment>
			<!-- No Negotiation Necessary (BT-120) cardinality + Optional for CN subtypes 16 and 20; Forbidden for other subtypes -->
			<xsl:comment>No Negotiation Necessary (BT-120)</xsl:comment>
			<xsl:apply-templates select="../../ted:RIGHT_CONTRACT_INITIAL_TENDERS"/>
			<!-- Award Criteria Order Justification (BT-733) cardinality ? No equivalent element in TED XML -->
			<!-- Award Criteria Complicated (BT-543) cardinality ? No equivalent element in TED XML -->
			
			<!-- Award Criterion Number (BT-541) cardinality ? Optional for PIN subtypes 7-9, CN subtypes 10-24 and E3, CAN subtypes 25-37 and E4, CM subtype E5; Forbidden for other subtypes -->
			<!-- Award Criterion Number Weight (BT-5421) cardinality ? Optional for PIN subtypes 7-9, CN subtypes 10-24 and E3, CAN subtypes 25-37 and E4, CM subtype E5; Forbidden for other subtypes -->
			<!-- Award Criterion Number Fixed (BT-5422) cardinality ? Optional for PIN subtypes 7-9, CN subtypes 10-24 and E3, CAN subtypes 25-37 and E4, CM subtype E5; Forbidden for other subtypes -->
			<!-- Award Criterion Number Threshold (BT-5423) cardinality ? Optional for PIN subtypes 7-9, CN subtypes 10-24 and E3, CAN subtypes 25-37 and E4, CM subtype E5; Forbidden for other subtypes -->
			<!-- Award Criterion Type (BT-539) cardinality ? Mandatory for CAN subtypes 29, 31, and 32; Optional for PIN subtypes 7-9, CN subtypes 10-24 and E3, CAN subtypes 25-28, 30, 33-37, and E4, CM subtype E5; Forbidden for other subtypes -->
			<!-- Award Criterion Name (BT-734) cardinality ? Optional for PIN subtypes 7-9, CN subtypes 10-24 and E3, CAN subtypes 25-37 and E4, CM subtype E5; Forbidden for other subtypes -->
			<!-- Award Criterion Description (BT-540) cardinality ? Mandatory for CAN subtypes 29, 31, and 32; Optional for PIN subtypes 7-9, CN subtypes 10-24 and E3, CAN subtypes 25-28, 30, 33-37, and E4, CM subtype E5; Forbidden for other subtypes -->
			<xsl:apply-templates select="ted:AC"/>
			
			<!-- Jury Member Name (BT-46) cardinality + (Is this correct? Conflict between documentation and Annex spreadsheet) Optional for CN subtypes 23 and 24; Forbidden for other subtypes -->
			<!-- TBD: see TEDEFO-748 -->
			<!-- TBD: no equivalent element in TED XML identified -->
			<xsl:comment>Jury Member Name (BT-46)</xsl:comment>
			<cac:TechnicalCommitteePerson>
				<cbc:FamilyName></cbc:FamilyName>
			</cac:TechnicalCommitteePerson>
			
			<!-- Prize information is only for notices of type "CN design", and covers Prize Rank (BT-44), Value Prize (BT-644) and Rewards Other (BT-45); the last one being for prizes not having equivalent monetary value. -->
			<!-- Prize Rank (BT-44) cardinality 1 Optional for CN subtypes 23 and 24; Forbidden for other subtypes -->
			<!-- Value Prize (BT-644) cardinality 1 Optional for CN subtypes 23 and 24; Forbidden for other subtypes -->
			<!-- Rewards Other (BT-45) cardinality ? Optional for CN subtypes 23 and 24; Forbidden for other subtypes -->
		<xsl:comment>Prize information (Prize Rank (BT-44), Rewards Other (BT-45), Value Prize (BT-644))</xsl:comment>
		<xsl:apply-templates select="../../ted:PROCEDURE/ted:NUMBER_VALUE_PRIZE"/> 
			
		
		</cac:AwardingTerms>
	</xsl:template>

	<xsl:template match="ted:AC">
		<xsl:if test="ted:AC_PROCUREMENT_DOC|.//*[fn:normalize-space(.)!='']">
			<cac:AwardingCriterion>
				<xsl:apply-templates select="*"/>
			</cac:AwardingCriterion>
		</xsl:if>
	</xsl:template>

	<xsl:template match="ted:AC_QUALITY">
		<cac:SubordinateAwardingCriterion>
			<!-- Award Criterion Number (BT-541) cardinality ? Optional for PIN subtypes 7-9, CN subtypes 10-24 and E3, CAN subtypes 25-37 and E4, CM subtype E5; Forbidden for other subtypes -->
			<xsl:comment>Award Criterion Number (BT-541)</xsl:comment>
			<xsl:apply-templates select="ted:AC_WEIGHTING"/>
			<xsl:apply-templates select="ted:AC_CRITERION"/>
		</cac:SubordinateAwardingCriterion>
	</xsl:template>

	<xsl:template match="ted:AC_COST">
		<cac:SubordinateAwardingCriterion>
			<xsl:apply-templates select="ted:AC_WEIGHTING"/>
			<xsl:apply-templates select="ted:AC_CRITERION"/>
		</cac:SubordinateAwardingCriterion>
	</xsl:template>

	<xsl:template match="ted:AC_PRICE">
		<cac:SubordinateAwardingCriterion>
			<xsl:apply-templates select="ted:AC_WEIGHTING"/>
		</cac:SubordinateAwardingCriterion>
	</xsl:template>

	<xsl:template match="ted:AC_PROCUREMENT_DOC">
		<cac:SubordinateAwardingCriterion>
			<!-- Award Criterion Description (BT-540) cardinality ? Mandatory for CAN subtypes 29, 31, and 32; Optional for PIN subtypes 7-9, CN subtypes 10-24 and E3, CAN subtypes 25-28, 30, 33-37, and E4, CM subtype E5; Forbidden for other subtypes -->
			<xsl:comment>Award Criterion Description (BT-540)</xsl:comment>
			<cbc:Description languageID="{$eforms-first-language}"><xsl:text>Price is not the only award criterion and all criteria are stated only in the procurement documents.</xsl:text></cbc:Description>
		</cac:SubordinateAwardingCriterion>
	</xsl:template>
	
	<xsl:template match="ted:AC_CRITERION">
		<!-- Award Criterion Description (BT-540) cardinality ? Mandatory for CAN subtypes 29, 31, and 32; Optional for PIN subtypes 7-9, CN subtypes 10-24 and E3, CAN subtypes 25-28, 30, 33-37, and E4, CM subtype E5; Forbidden for other subtypes -->
		<xsl:comment>Award Criterion Description (BT-540)</xsl:comment>
		<cbc:Description languageID="{$eforms-first-language}"><xsl:value-of select="fn:normalize-space(.)"/></cbc:Description>
	</xsl:template>

	<xsl:template match="ted:AC_WEIGHTING">
		<xsl:variable name="text" select="fn:normalize-space(.)"/>
		<xsl:variable name="part1" select="fn:substring-before($text, ' ')"/>
		<xsl:variable name="rest" select="fn:lower-case(fn:substring-after($text, ' '))"/>
		<ext:UBLExtensions>
			<ext:UBLExtension>
				<ext:ExtensionContent>
					<efext:EformsExtension>
						<efac:AwardCriterionParameter>
							<!-- Award Criterion Number Weight (BT-5421) cardinality ? Optional for PIN subtypes 7-9, CN subtypes 10-24 and E3, CAN subtypes 25-37 and E4, CM subtype E5; Forbidden for other subtypes -->
							<xsl:comment>Award Criterion Number Weight (BT-5421)</xsl:comment>
							<!-- Award Criterion Number (BT-541) cardinality ? Optional for PIN subtypes 7-9, CN subtypes 10-24 and E3, CAN subtypes 25-37 and E4, CM subtype E5; Forbidden for other subtypes -->
							<xsl:comment>Award Criterion Number (BT-541)</xsl:comment>
							<xsl:choose>
								<xsl:when test="matches($text, '^[0-9]+$')">
									<efbc:ParameterCode listName="number-weight">dec-exa</efbc:ParameterCode>
									<efbc:ParameterNumeric><xsl:value-of select="$text"/></efbc:ParameterNumeric>
								</xsl:when>
								<xsl:when test="fn:matches($text,'^[0-9]+(,[0-9]{3})+$') or fn:matches($text,'^[0-9]+(\.[0-9]{3})+$')">
									<xsl:variable name="number" select="fn:replace($text, '[,.]', '')"/>
									<efbc:ParameterCode listName="number-weight">dec-exa</efbc:ParameterCode>
									<efbc:ParameterNumeric><xsl:value-of select="$number"/></efbc:ParameterNumeric>
								</xsl:when>
								<xsl:when test="fn:matches($text, '^[0-9.,]+ *%$')">
									<xsl:variable name="number" select="fn:replace($text, ' *%', '')"/>
									<efbc:ParameterCode listName="number-weight">per-exa</efbc:ParameterCode>
									<efbc:ParameterNumeric><xsl:value-of select="$number"/></efbc:ParameterNumeric>
								</xsl:when>
								<xsl:when test="fn:matches($part1, '^[0-9]+$') and fn:matches($rest, '^(points|punkte|punten|puntos|bodova|punti|punkts|pointes|pts)$')">
									<efbc:ParameterCode listName="number-weight">poi-exa</efbc:ParameterCode>
									<efbc:ParameterNumeric><xsl:value-of select="$part1"/></efbc:ParameterNumeric>
								</xsl:when>
								<!-- miscellaneous unparseable values here -->
								<xsl:otherwise>
									<!-- WARNING: Award Criterion Number Weight (BT-5421) requires a positive integer, but the content of AC_WEIGHTING could not be parsed. -->
									<xsl:variable name="message">WARNING: Award Criterion Number Weight (BT-5421) requires a positive integer, but the content of AC_WEIGHTING could not be parsed.</xsl:variable>
									<xsl:message terminate="no" select="$message"/>
									<xsl:comment><xsl:value-of select="$message"/></xsl:comment>
									<efbc:ParameterCode listName="number-weight">ord-imp</efbc:ParameterCode>
									<efbc:ParameterNumeric><xsl:value-of select="$text"/></efbc:ParameterNumeric>
								</xsl:otherwise>
							</xsl:choose>
						</efac:AwardCriterionParameter>
					</efext:EformsExtension>
				</ext:ExtensionContent>
			</ext:UBLExtension>
		</ext:UBLExtensions>
	</xsl:template>

<!--Start of Prize information -->
<!-- Prize information is only for notices of type "CN design", and covers Prize Rank (BT-44), Value Prize (BT-644) and Rewards Other (BT-45); the last one being for prizes not having equivalent monetary value. -->
			<!-- Prize Rank (BT-44) cardinality 1 Optional for CN subtypes 23 and 24; Forbidden for other subtypes -->
			<!-- Value Prize (BT-644) cardinality 1 Optional for CN subtypes 23 and 24; Forbidden for other subtypes -->
			<!-- Rewards Other (BT-45) cardinality ? Optional for CN subtypes 23 and 24; Forbidden for other subtypes -->
	<xsl:template match="ted:NUMBER_VALUE_PRIZE">
		<xsl:variable name="text" select="fn:normalize-space(fn:string-join($ted-form-main-element/ted:PROCEDURE/ted:NUMBER_VALUE_PRIZE/ted:P, ' '))"/>
		<xsl:if test="$text ne ''" >
			<cac:Prize>
				<xsl:comment>Prize Rank (BT-44)</xsl:comment>
				<!--WARNING: Prize information requires a Prize Rank (BT-44), but no equivalent information is specified in the TED XML schema. In order to obtain valid XML for this notice, a fixed value of "1" was used.-->
				<xsl:variable name="message">WARNING: Prize information requires a Prize Rank (BT-44), but no equivalent information is specified in the TED XML schema. In order to obtain valid XML for this notice, a fixed value of "1" was used.</xsl:variable>
				<xsl:message terminate="no" select="$message"/>
				<xsl:comment><xsl:value-of select="$message"/></xsl:comment>
				<cbc:RankCode>1</cbc:RankCode>
				<xsl:comment>Value Prize (BT-644)</xsl:comment>
				<!--WARNING: Prize information allows a Value Prize (BT-644), but no explicit equivalent information is specified in the TED XML schema. Implicit information might be extracted from the Prize description.-->
				<xsl:variable name="message">WARNING: Prize information allows a Value Prize (BT-644), but no explicit equivalent information is specified in the TED XML schema. Implicit information might be extracted from the Prize description.</xsl:variable>
				<xsl:message terminate="no" select="$message"/>
				<xsl:comment><xsl:value-of select="$message"/></xsl:comment>
				<xsl:comment>Rewards Other (Prize Description) (BT-45)</xsl:comment>
				<cbc:Description languageID="{$eforms-first-language}"><xsl:value-of select="$text"/>
				</cbc:Description>
			</cac:Prize>
		</xsl:if>			
	</xsl:template>
<!--End of Prize information -->	

</xsl:stylesheet>
