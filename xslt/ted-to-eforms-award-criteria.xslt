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


<!-- 
               <AC>
                  <AC_QUALITY>
                     <AC_CRITERION>Health, safety and wellbeing (HS&amp;W)</AC_CRITERION>
                     <AC_WEIGHTING>10.08 %</AC_WEIGHTING>
                  </AC_QUALITY>
                  <AC_QUALITY>
                     <AC_CRITERION>Supply chain management</AC_CRITERION>
                     <AC_WEIGHTING>10.01 %</AC_WEIGHTING>
                  </AC_QUALITY>
                  <AC_PRICE>
                     <AC_WEIGHTING>30 %</AC_WEIGHTING>
                  </AC_PRICE>
               </AC>

-->



	<xsl:template name="awarding-terms">
		<!-- will need to determine rules for including main element cac:AwardingTerms -->
		<cac:AwardingTerms>
			<!-- Following Contract (BT-41) cardinality + Forbidden for all Forms except Mandatory for Contract Notice subtypes 23 and 24 -->
			<!-- Jury Decision Binding (BT-42) cardinality + Forbidden for all Forms except Mandatory for Contract Notice subtypes 23 and 24 -->
			<!-- No Negotiation Necessary (BT-120) cardinality + Forbidden for all Forms except CM for Contract Notice subtype 16 and Optional for Contract Notice subtype 20 RIGHT_CONTRACT_INITIAL_TENDERS -->
			<xsl:apply-templates select="../../ted:RIGHT_CONTRACT_INITIAL_TENDERS"/>
			<!-- Award Criteria Order Justification (BT-733) cardinality ? No equivalent element in TED XML -->
			<!-- Award Criteria Complicated (BT-543) cardinality ? No equivalent element in TED XML -->
			
			<!-- Award Criterion Number Weight (BT-5421) cardinality ? -->
			<!-- Award Criterion Number Fixed (BT-5422) cardinality ? -->
			<!-- Award Criterion Number Threshold (BT-5423) cardinality ? -->
			<!-- Award Criterion Type (BT-539) cardinality ? -->
			<!-- Award Criterion Name (BT-734) cardinality ? -->
			<!-- Award Criterion Description (BT-540) cardinality ? -->
			<xsl:apply-templates select="ted:AC"/>
			
			<!-- Jury Member Name (BT-46) cardinality + -->
			<!-- TBD: no equivalent element in TED XML identified -->
			<cac:TechnicalCommitteePerson>
				<cbc:FamilyName></cbc:FamilyName>
			</cac:TechnicalCommitteePerson>
			<!-- Prize information is only for notices of type "CN design", and covers Prize Rank (BT-44), Value Prize (BT-644) and Rewards Other (BT-45); the last one being for prizes not having equivalent monetary value. -->
			<!-- Prize Rank (BT-44) cardinality ? -->
			<!-- Value Prize (BT-644) cardinality ? -->
			<!-- Rewards Other (BT-45) cardinality ? -->
	
		</cac:AwardingTerms>
	</xsl:template>

	<xsl:template match="ted:AC">
		<!-- Some TED XML notices have no valid information within the AC element, so these must be checked -->
		<xsl:if test="ted:AC_PROCUREMENT_DOC|.//*[fn:normalize-space(.)!='']">
			<cac:AwardingCriterion>
				<xsl:apply-templates select="*"/>
			</cac:AwardingCriterion>
		</xsl:if>
	</xsl:template>

	<xsl:template match="ted:AC_QUALITY">
		<cac:SubordinateAwardingCriterion>
			<xsl:apply-templates select="AC_WEIGHTING"/>
			<xsl:apply-templates select="AC_CRITERION"/>
		</cac:SubordinateAwardingCriterion>
	</xsl:template>

	<xsl:template match="ted:AC_COST">
		<cac:SubordinateAwardingCriterion>
			<xsl:apply-templates select="AC_WEIGHTING"/>
			<xsl:apply-templates select="AC_CRITERION"/>
		</cac:SubordinateAwardingCriterion>
	</xsl:template>

	<xsl:template match="ted:AC_PRICE">
		<cac:SubordinateAwardingCriterion>
			<xsl:apply-templates select="AC_WEIGHTING"/>
		</cac:SubordinateAwardingCriterion>
	</xsl:template>

	<xsl:template match="ted:AC_PROCUREMENT_DOC">
		<cac:SubordinateAwardingCriterion>
			<cbc:Description languageID="{$eforms-first-language}"><xsl:text>Price is not the only award criterion and all criteria are stated only in the procurement documents.</xsl:text></cbc:Description>
		</cac:SubordinateAwardingCriterion>
	</xsl:template>
	
	<xsl:template match="ted:AC_CRITERION">
		<cbc:Description languageID="{$eforms-first-language}"><xsl:value-of select="fn:normalize-space(.)"/></cbc:Description>
	</xsl:template>
<!--
eForms number-fixed codelist
fix-tot Fixed (total)
fix-unit Fixed (per unit)

eForms number-weight codelist
per-exa Weight (percentage, exact)
per-mid Weight (percentage, middle of a range)
dec-exa Weight (decimal, exact)
dec-mid Weight (decimal, middle of a range)
poi-exa Weight (points, exact)
poi-mid Weight (points, middle of a range)
ord-imp Order of importance

eForms number-threshold codelist
min-score Minimum score
max-pass Maximum number of tenders passing
-->	
	<xsl:template match="ted:AC_WEIGHTING">
		<xsl:variable name="text" select="fn:normalize-space(.)"/>
		<xsl:variable name="part1" select="fn:substring-before($text, ' ')"/>
		<xsl:variable name="rest" select="fn:lower-case(fn:substring-after($text, ' '))"/>
		<ext:UBLExtensions>
			<ext:UBLExtension>
				<ext:ExtensionContent>
					<efext:EformsExtension>
						<efac:AwardCriterionParameter>
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
								<xsl:when test="fn:matches($text, '^[0-9]+ *%$')">
									<xsl:variable name="number" select="fn:replace($text, '% *', '')"/>
									<efbc:ParameterCode listName="number-weight">per-exa</efbc:ParameterCode>
									<efbc:ParameterNumeric><xsl:value-of select="$number"/></efbc:ParameterNumeric>
								</xsl:when>
								<xsl:when test="fn:matches($part1, '^[0-9]+$') and fn:matches($rest, '^(points|punkte|punten|puntos|bodova|punti|punkts|pointes|pts)$')">
									<efbc:ParameterCode listName="number-weight">poi-exa</efbc:ParameterCode>
									<efbc:ParameterNumeric><xsl:value-of select="$part1"/></efbc:ParameterNumeric>
								</xsl:when>
								<!-- miscellaneous unparseable values here -->
								<xsl:otherwise>
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


</xsl:stylesheet>
