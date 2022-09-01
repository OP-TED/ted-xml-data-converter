<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xlink="http://www.w3.org/1999/xlink"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:doc="http://www.pnp-software.com/XSLTdoc"
xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:functx="http://www.functx.com" xmlns:opfun="http://data.europa.eu/p27/ted-xml-data-converter"
xmlns:ted="http://publications.europa.eu/resource/schema/ted/R2.0.9/publication" xmlns:n2016="http://publications.europa.eu/resource/schema/ted/2016/nuts" xmlns:n2021="http://publications.europa.eu/resource/schema/ted/2021/nuts"
xmlns:pin="urn:oasis:names:specification:ubl:schema:xsd:PriorInformationNotice-2" xmlns:cn="urn:oasis:names:specification:ubl:schema:xsd:ContractNotice-2" xmlns:can="urn:oasis:names:specification:ubl:schema:xsd:ContractAwardNotice-2"
xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"
xmlns:efbc="http://data.europa.eu/p27/eforms-ubl-extension-basic-components/1" xmlns:efac="http://data.europa.eu/p27/eforms-ubl-extension-aggregate-components/1" xmlns:efext="http://data.europa.eu/p27/eforms-ubl-extensions/1"
xmlns:ccts="urn:un:unece:uncefact:documentation:2" xmlns:gc="http://docs.oasis-open.org/codelist/ns/genericode/1.0/"
exclude-result-prefixes="xlink xs xsi fn functx doc opfun ted gc n2016 n2021 pin cn can ccts ext" >
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>


<!-- Template to create cac:AwardingTerms -->
<xsl:template name="awarding-terms">
	<!-- TBD: will need to determine rules for including main element cac:AwardingTerms -->
	<cac:AwardingTerms>
		<!-- Following Contract (BT-41): eForms documentation cardinality (Lot) = + | Mandatory for CN subtypes 23 and 24; Forbidden for other subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Following Contract (BT-41)'"/></xsl:call-template>
		<xsl:apply-templates select="../../ted:PROCEDURE/(ted:FOLLOW_UP_CONTRACTS|ted:NO_FOLLOW_UP_CONTRACTS)"/>

		<!-- Jury Decision Binding (BT-42): eForms documentation cardinality (Lot) = + | Mandatory for CN subtypes 23 and 24; Forbidden for other subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Jury Decision Binding (BT-42)'"/></xsl:call-template>
		<xsl:apply-templates select="../../ted:PROCEDURE/(ted:DECISION_BINDING_CONTRACTING|ted:NO_DECISION_BINDING_CONTRACTING)"/>

		<!-- No Negotiation Necessary (BT-120): eForms documentation cardinality (Lot) = + | Optional for CN subtypes 16 and 20; Forbidden for other subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'No Negotiation Necessary (BT-120)'"/></xsl:call-template>
		<xsl:apply-templates select="../../ted:PROCEDURE/ted:RIGHT_CONTRACT_INITIAL_TENDERS"/>

		<!-- Award Criteria Order Justification (BT-733): eForms documentation cardinality (Lot) = ? | No equivalent element in TED XML -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Award Criteria Order Justification (BT-733)'"/></xsl:call-template>
		<!-- Award Criteria Complicated (BT-543): eForms documentation cardinality (Lot) = ? | No equivalent element in TED XML -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Award Criteria Complicated (BT-543)'"/></xsl:call-template>
		<!-- Award Criterion Number (BT-541): eForms documentation cardinality (Lot) = ? | eForms Regulation Annex table conditions = Optional for PIN subtypes 7-9, CN subtypes 10-24 and E3, CAN subtypes 25-37 and E4, CM subtype E5; Forbidden for other subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Award Criterion Number (BT-541)'"/></xsl:call-template>
		<!-- Award Criterion Number Weight (BT-5421): eForms documentation cardinality (Lot) = ? | eForms Regulation Annex table conditions = Optional for PIN subtypes 7-9, CN subtypes 10-24 and E3, CAN subtypes 25-37 and E4, CM subtype E5; Forbidden for other subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Award Criterion Number Weight (BT-5421)'"/></xsl:call-template>
		<!-- Award Criterion Number Fixed (BT-5422): eForms documentation cardinality (Lot) = ? | eForms Regulation Annex table conditions = Optional for PIN subtypes 7-9, CN subtypes 10-24 and E3, CAN subtypes 25-37 and E4, CM subtype E5; Forbidden for other subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Award Criterion Number Fixed (BT-5422)'"/></xsl:call-template>
		<!-- Award Criterion Number Threshold (BT-5423): eForms documentation cardinality (Lot) = ? | eForms Regulation Annex table conditions = Optional for PIN subtypes 7-9, CN subtypes 10-24 and E3, CAN subtypes 25-37 and E4, CM subtype E5; Forbidden for other subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Award Criterion Number Threshold (BT-5423)'"/></xsl:call-template>
		<!-- Award Criterion Type (BT-539): eForms documentation cardinality (Lot) = ? | eForms Regulation Annex table conditions = Mandatory for CAN subtypes 29, 31, and 32; Optional for PIN subtypes 7-9, CN subtypes 10-24 and E3, CAN subtypes 25-28, 30, 33-37, and E4, CM subtype E5; Forbidden for other subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Award Criterion Type (BT-539)'"/></xsl:call-template>
		<!-- Award Criterion Name (BT-734): eForms documentation cardinality (Lot) = ? | eForms Regulation Annex table conditions = Optional for PIN subtypes 7-9, CN subtypes 10-24 and E3, CAN subtypes 25-37 and E4, CM subtype E5; Forbidden for other subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Award Criterion Name (BT-734)'"/></xsl:call-template>
		<!-- Award Criterion Description (BT-540): eForms documentation cardinality (Lot) = ? | eForms Regulation Annex table conditions = Mandatory for CAN subtypes 29, 31, and 32; Optional for PIN subtypes 7-9, CN subtypes 10-24 and E3, CAN subtypes 25-28, 30, 33-37, and E4, CM subtype E5; Forbidden for other subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Award Criterion Description (BT-540)'"/></xsl:call-template>
		<xsl:apply-templates select="ted:AC|(ted:DIRECTIVE_2014_24_EU|ted:DIRECTIVE_2014_25_EU|ted:DIRECTIVE_2014_23_EU|ted:DIRECTIVE_2009_81_EC)/ted:AC|../../ted:PROCEDURE/ted:CRITERIA_EVALUATION"/>

		<!-- Jury Member Name (BT-46): eForms documentation cardinality (Lot) = * | Optional for CN subtypes 23 and 24; Forbidden for other subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Jury Member Name (BT-46)'"/></xsl:call-template>
		<xsl:apply-templates select="../../ted:PROCEDURE/ted:MEMBER_NAME"/>

		<!-- Prize information is only for notices of type "CN design", and covers Prize Rank (BT-44), Value Prize (BT-644) and Rewards Other (BT-45); the last one being for prizes not having equivalent monetary value. -->
		<!-- Prize Rank (BT-44): eForms documentation cardinality (Lot) = 1 | Optional for CN subtypes 23 and 24; Forbidden for other subtypes -->
		<!-- Value Prize (BT-644): eForms documentation cardinality (Lot) = 1 | Optional for CN subtypes 23 and 24; Forbidden for other subtypes -->
		<!-- Rewards Other (BT-45): eForms documentation cardinality (Lot) = ? | Optional for CN subtypes 23 and 24; Forbidden for other subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Prize information (Prize Rank (BT-44), Rewards Other (BT-45), Value Prize (BT-644))'"/></xsl:call-template>
		<xsl:call-template name="prize"/>
	</cac:AwardingTerms>
</xsl:template>

<!-- Following Contract (BT-41): eForms documentation cardinality (Lot) = + | Mandatory for CN subtypes 23 and 24; Forbidden for other subtypes -->
<xsl:template match="ted:FOLLOW_UP_CONTRACTS">
	<cbc:FollowupContractIndicator>true</cbc:FollowupContractIndicator>
</xsl:template>

<xsl:template match="ted:NO_FOLLOW_UP_CONTRACTS">
	<cbc:FollowupContractIndicator>false</cbc:FollowupContractIndicator>
</xsl:template>

<!-- Jury Decision Binding (BT-42): eForms documentation cardinality (Lot) = + | Mandatory for CN subtypes 23 and 24; Forbidden for other subtypes -->
<xsl:template match="ted:DECISION_BINDING_CONTRACTING">
	<cbc:BindingOnBuyerIndicator>true</cbc:BindingOnBuyerIndicator>
</xsl:template>

<xsl:template match="ted:NO_DECISION_BINDING_CONTRACTING">
	<cbc:BindingOnBuyerIndicator>false</cbc:BindingOnBuyerIndicator>
</xsl:template>

<!-- Jury Member Name (BT-46): eForms documentation cardinality (Lot) = * | Optional for CN subtypes 23 and 24; Forbidden for other subtypes -->
<xsl:template match="ted:MEMBER_NAME">
	<cac:TechnicalCommitteePerson>
		<cbc:FamilyName><xsl:value-of select="(.)"/></cbc:FamilyName>
	</cac:TechnicalCommitteePerson>
</xsl:template>

<xsl:template match="ted:AC">
	<xsl:if test="ted:AC_PROCUREMENT_DOC|.//*[fn:normalize-space(.)!='']">
		<cac:AwardingCriterion>
			<xsl:apply-templates select="ted:AC_PROCUREMENT_DOC"/>
			<xsl:apply-templates select="ted:AC_QUALITY|ted:AC_COST|ted:AC_PRICE"/>
			<xsl:if test="ted:AC_CRITERION">
				<!-- WARNING: Award Criterion Type (BT-539) is required, but the source TED notice does not contain this information. The type "quality" has been used as a default. -->
				<xsl:variable name="message">WARNING: Award Criterion Type (BT-539) is required, but the source TED notice does not contain this information. The type "quality" has been used as a default.</xsl:variable>
				<xsl:call-template name="report-warning"><xsl:with-param name="message" select="$message"/></xsl:call-template>
				<xsl:apply-templates select="ted:AC_CRITERION"/>
			</xsl:if>
		</cac:AwardingCriterion>
	</xsl:if>
</xsl:template>

<xsl:template match="ted:DIRECTIVE_2009_81_EC/ted:AC">
	<xsl:choose>
		<xsl:when test="ted:AC_PRICE">
			<cac:AwardingCriterion>
				<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Award Criterion Type (BT-539)'"/></xsl:call-template>
				<cbc:AwardingCriterionTypeCode listName="award-criterion-type">price</cbc:AwardingCriterionTypeCode>
				<!-- WARNING: Award Criterion Description (BT-540) is required, but the source TED notice does not contain this information. -->
				<xsl:variable name="message">WARNING: Award Criterion Description (BT-540) is required, but the source TED notice does not contain this information.</xsl:variable>
				<xsl:call-template name="report-warning"><xsl:with-param name="message" select="$message"/></xsl:call-template>
				<cbc:Description languageID="{$eforms-first-language}"></cbc:Description>
			</cac:AwardingCriterion>
		</xsl:when>
		<xsl:when test="ted:AC_CRITERIA">
			
		</xsl:when>
	</xsl:choose>
</xsl:template>

<xsl:template match="ted:AC/ted:AC_CRITERIA">
	<cac:SubordinateAwardingCriterion>
		<!-- Award Criterion Number (BT-541): eForms documentation cardinality (Lot) = ? | eForms Regulation Annex table conditions = Optional for PIN subtypes 7-9, CN subtypes 10-24 and E3, CAN subtypes 25-37 and E4, CM subtype E5; Forbidden for other subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Award Criterion Number (BT-541)'"/></xsl:call-template>
		<xsl:apply-templates select="ted:AC_WEIGHTING"/>
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Award Criterion Type (BT-539)'"/></xsl:call-template>
		<cbc:AwardingCriterionTypeCode listName="award-criterion-type">quality</cbc:AwardingCriterionTypeCode>
		<xsl:apply-templates select="ted:AC_CRITERION"/>
	</cac:SubordinateAwardingCriterion>
</xsl:template>


<xsl:template match="ted:AC/ted:AC_QUALITY">
	<cac:SubordinateAwardingCriterion>
		<!-- Award Criterion Number (BT-541): eForms documentation cardinality (Lot) = ? | eForms Regulation Annex table conditions = Optional for PIN subtypes 7-9, CN subtypes 10-24 and E3, CAN subtypes 25-37 and E4, CM subtype E5; Forbidden for other subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Award Criterion Number (BT-541)'"/></xsl:call-template>
		<xsl:apply-templates select="ted:AC_WEIGHTING"/>
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Award Criterion Type (BT-539)'"/></xsl:call-template>
		<cbc:AwardingCriterionTypeCode listName="award-criterion-type">quality</cbc:AwardingCriterionTypeCode>
		<xsl:apply-templates select="ted:AC_CRITERION"/>
	</cac:SubordinateAwardingCriterion>
</xsl:template>

<xsl:template match="ted:AC/ted:AC_COST">
	<cac:SubordinateAwardingCriterion>
		<xsl:apply-templates select="ted:AC_WEIGHTING"/>
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Award Criterion Type (BT-539)'"/></xsl:call-template>
		<cbc:AwardingCriterionTypeCode listName="award-criterion-type">cost</cbc:AwardingCriterionTypeCode>
		<xsl:apply-templates select="ted:AC_CRITERION"/>
	</cac:SubordinateAwardingCriterion>
</xsl:template>

<xsl:template match="ted:AC/ted:AC_PRICE">
	<cac:SubordinateAwardingCriterion>
		<xsl:apply-templates select="ted:AC_WEIGHTING"/>
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Award Criterion Type (BT-539)'"/></xsl:call-template>
		<cbc:AwardingCriterionTypeCode listName="award-criterion-type">price</cbc:AwardingCriterionTypeCode>
		<!-- WARNING: Award Criterion Description (BT-540) is required, but the source TED notice does not contain this information. -->
		<xsl:variable name="message">WARNING: Award Criterion Description (BT-540) is required, but the source TED notice does not contain this information.</xsl:variable>
		<xsl:call-template name="report-warning"><xsl:with-param name="message" select="$message"/></xsl:call-template>
		<cbc:Description languageID="{$eforms-first-language}"></cbc:Description>
	</cac:SubordinateAwardingCriterion>
</xsl:template>

<xsl:template match="ted:AC_PROCUREMENT_DOC">
	<cac:SubordinateAwardingCriterion>
		<!-- Award Criterion Description (BT-540): eForms documentation cardinality (Lot) = ? | eForms Regulation Annex table conditions = Mandatory for CAN subtypes 29, 31, and 32; Optional for PIN subtypes 7-9, CN subtypes 10-24 and E3, CAN subtypes 25-28, 30, 33-37, and E4, CM subtype E5; Forbidden for other subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Award Criterion Description (BT-540)'"/></xsl:call-template>
		<cbc:Description languageID="{$eforms-first-language}"><xsl:text>Price is not the only award criterion and all criteria are stated only in the procurement documents.</xsl:text></cbc:Description>
	</cac:SubordinateAwardingCriterion>
</xsl:template>

<xsl:template match="ted:AC_CRITERION">
	<!-- Award Criterion Description (BT-540): eForms documentation cardinality (Lot) = ? | eForms Regulation Annex table conditions = Mandatory for CAN subtypes 29, 31, and 32; Optional for PIN subtypes 7-9, CN subtypes 10-24 and E3, CAN subtypes 25-28, 30, 33-37, and E4, CM subtype E5; Forbidden for other subtypes -->
	<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Award Criterion Description (BT-540)'"/></xsl:call-template>
	<xsl:call-template name="multilingual">
		<xsl:with-param name="contexts" select="."/>
		<xsl:with-param name="local" select="''"/>
		<xsl:with-param name="element" select="'cbc:Description'"/>
	</xsl:call-template>
</xsl:template>

<xsl:template match="ted:AC/ted:AC_CRITERION">
	<cac:SubordinateAwardingCriterion>
		<!-- Award Criterion Type (BT-539): eForms documentation cardinality (Lot) = ? | eForms Regulation Annex table conditions = Mandatory for CAN subtypes 29, 31, and 32; Optional for PIN subtypes 7-9, CN subtypes 10-24 and E3, CAN subtypes 25-28, 30, 33-37, and E4, CM subtype E5; Forbidden for other subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Award Criterion Type (BT-539)'"/></xsl:call-template>
		<cbc:AwardingCriterionTypeCode listName="award-criterion-type">quality</cbc:AwardingCriterionTypeCode>
		<!-- Award Criterion Description (BT-540): eForms documentation cardinality (Lot) = ? | eForms Regulation Annex table conditions = Mandatory for CAN subtypes 29, 31, and 32; Optional for PIN subtypes 7-9, CN subtypes 10-24 and E3, CAN subtypes 25-28, 30, 33-37, and E4, CM subtype E5; Forbidden for other subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Award Criterion Description (BT-540)'"/></xsl:call-template>
		<xsl:call-template name="multilingual">
			<xsl:with-param name="contexts" select="."/>
			<xsl:with-param name="local" select="''"/>
			<xsl:with-param name="element" select="'cbc:Description'"/>
		</xsl:call-template>
	</cac:SubordinateAwardingCriterion>
</xsl:template>

<xsl:template match="ted:AC_WEIGHTING">
	<xsl:variable name="text" select="fn:normalize-space(.)"/>
	<xsl:variable name="part1" select="fn:substring-before($text, ' ')"/>
	<xsl:variable name="rest" select="fn:lower-case(fn:normalize-space(fn:substring-after($text, ' ')))"/>
	<ext:UBLExtensions>
		<ext:UBLExtension>
			<ext:ExtensionContent>
				<efext:EformsExtension>
					<efac:AwardCriterionParameter>
						<!-- Award Criterion Number Weight (BT-5421): eForms documentation cardinality (Lot) = ? | eForms Regulation Annex table conditions = Optional for PIN subtypes 7-9, CN subtypes 10-24 and E3, CAN subtypes 25-37 and E4, CM subtype E5; Forbidden for other subtypes -->
						<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Award Criterion Number Weight (BT-5421)'"/></xsl:call-template>
						<!-- Award Criterion Number (BT-541): eForms documentation cardinality (Lot) = ? | eForms Regulation Annex table conditions = Optional for PIN subtypes 7-9, CN subtypes 10-24 and E3, CAN subtypes 25-37 and E4, CM subtype E5; Forbidden for other subtypes -->
						<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Award Criterion Number (BT-541)'"/></xsl:call-template>
						<!-- The content of Award Criterion Number (BT-541) must fulfil the decimal XSM Schema primitive data type -->
						<!-- Values and labels from "number-weight" codelist:
							per-exa Weight (percentage, exact)
							per-mid Weight (percentage, middle of a range)
							dec-exa Weight (decimal, exact)
							dec-mid Weight (decimal, middle of a range)
							poi-exa Weight (points, exact)
							poi-mid Weight (points, middle of a range)
							ord-imp Order of importance 
						-->
						<xsl:choose>
							<!-- digits only -->
							<xsl:when test="matches($text, '^[0-9]+$')">
								<!-- check if the sum of all AC_WEIGHTING elements in this Lot is exactly 100 -->
								<xsl:choose>
									<xsl:when test="fn:not(ancestor::ted:AC//ted:AC_WEIGHTING[fn:not(functx:is-a-number(.))]) and fn:sum(ancestor::ted:AC//ted:AC_WEIGHTING) = 100">
										<efbc:ParameterCode listName="number-weight">per-exa</efbc:ParameterCode>
										<efbc:ParameterNumeric><xsl:value-of select="$text"/></efbc:ParameterNumeric>
									</xsl:when>
									<xsl:otherwise>
										<efbc:ParameterCode listName="number-weight">dec-exa</efbc:ParameterCode>
										<efbc:ParameterNumeric><xsl:value-of select="$text"/></efbc:ParameterNumeric>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<!-- comma as thousands separator -->
							<xsl:when test="fn:matches($text,'^[0-9]+(,[0-9]{3})+(\.[0-9]+)?$')">
								<xsl:variable name="number" select="fn:replace($text, '[,]', '')"/>
								<efbc:ParameterCode listName="number-weight">dec-exa</efbc:ParameterCode>
								<efbc:ParameterNumeric><xsl:value-of select="$number"/></efbc:ParameterNumeric>
							</xsl:when>
							<!-- period as thousands separator -->
							<xsl:when test="fn:matches($text,'^[0-9]+(\.[0-9]{3})+(,[0-9]+)?$')">
								<xsl:variable name="number" select="fn:replace(fn:replace($text, '[.]', ''), ',', '.')"/>
								<efbc:ParameterCode listName="number-weight">dec-exa</efbc:ParameterCode>
								<efbc:ParameterNumeric><xsl:value-of select="$number"/></efbc:ParameterNumeric>
							</xsl:when>
							<!-- period as decimal point-->
							<xsl:when test="fn:matches($text,'^[0-9]+(\.[0-9]{2})$')">
								<xsl:variable name="number" select="$text"/>
								<efbc:ParameterCode listName="number-weight">dec-exa</efbc:ParameterCode>
								<efbc:ParameterNumeric><xsl:value-of select="$number"/></efbc:ParameterNumeric>
							</xsl:when>
							<!-- comma as decimal point-->
							<xsl:when test="fn:matches($text,'^[0-9]+(,[0-9]{2})$')">
								<xsl:variable name="number" select="fn:replace($text, ',', '.')"/>
								<efbc:ParameterCode listName="number-weight">dec-exa</efbc:ParameterCode>
								<efbc:ParameterNumeric><xsl:value-of select="$number"/></efbc:ParameterNumeric>
							</xsl:when>
							<!-- digits only, or period as decimal point, followed by % -->
							<xsl:when test="fn:matches($text, '^[0-9]+(\.[0-9]{2})? *%$')">
								<xsl:variable name="number" select="fn:replace($text, ' *%', '')"/>
								<efbc:ParameterCode listName="number-weight">per-exa</efbc:ParameterCode>
								<efbc:ParameterNumeric><xsl:value-of select="$number"/></efbc:ParameterNumeric>
							</xsl:when>
							<!-- comma as decimal point, followed by % -->
							<xsl:when test="fn:matches($text, '^[0-9]+,[0-9]{2} *%$')">
								<xsl:variable name="number" select="fn:replace(fn:replace($text, ' *%', ''), ',', '.')"/>
								<efbc:ParameterCode listName="number-weight">per-exa</efbc:ParameterCode>
								<efbc:ParameterNumeric><xsl:value-of select="$number"/></efbc:ParameterNumeric>
							</xsl:when>
							<!-- digits, followed by a word meaning "points" -->
							<xsl:when test="fn:matches($part1, '^[0-9]+$') and fn:matches($rest, '^(points|punkte|punten|puntos|bodova|punti|punkts|pointes|pts)$')">
								<efbc:ParameterCode listName="number-weight">poi-exa</efbc:ParameterCode>
								<efbc:ParameterNumeric><xsl:value-of select="$part1"/></efbc:ParameterNumeric>
							</xsl:when>
							<!-- miscellaneous unparseable values here -->
							<xsl:otherwise>
								<!-- WARNING: Award Criterion Number Weight (BT-5421) requires a positive integer, but the content of AC_WEIGHTING could not be parsed. -->
								<xsl:variable name="message">WARNING: Award Criterion Number Weight (BT-5421) requires a positive integer, but the content of AC_WEIGHTING could not be parsed.</xsl:variable>
								<xsl:call-template name="report-warning"><xsl:with-param name="message" select="$message"/></xsl:call-template>
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

<xsl:template match="ted:CRITERIA_EVALUATION">
	<!-- There is a business rule: Award Criteria (BG-707) must include at least one Award Criterion (BG-38) that includes Award Criterion Type (BT-539) value that is equal to ("Price" or "Cost"). -->
	<!-- To assist users to achieve correct information and to comply with the rule, CRITERIA_EVALUATION is copied to one cac:SubordinateAwardingCriterion for each possible Award Criterion Type (BT-539) -->
	<!-- These will need to be edited, and some possibly deleted, to complete the cac:AwardingCriterion. -->
	<xsl:variable name="text" select="fn:normalize-space(fn:string-join(ted:P, ' '))"/>
	<xsl:if test="$text ne ''">
		<cac:AwardingCriterion>
			<!-- WARNING: The content of TED XML element CRITERIA_EVALUATION has been copied to three Award Criterion Description (BT-540), to assist with editing and correction. -->
			<xsl:variable name="message">WARNING: The content of TED XML element CRITERIA_EVALUATION has been copied to three Award Criterion Description (BT-540), to assist with editing and correction.</xsl:variable>
			<xsl:call-template name="report-warning"><xsl:with-param name="message" select="$message"/></xsl:call-template>
			<cac:SubordinateAwardingCriterion>
				<!-- Award Criterion Type (BT-539): eForms documentation cardinality (Lot) = ? | eForms Regulation Annex table conditions = Mandatory for CAN subtypes 29, 31, and 32; Optional for PIN subtypes 7-9, CN subtypes 10-24 and E3, CAN subtypes 25-28, 30, 33-37, and E4, CM subtype E5; Forbidden for other subtypes -->
				<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Award Criterion Type (BT-539)'"/></xsl:call-template>
				<cbc:AwardingCriterionTypeCode listName="award-criterion-type">cost</cbc:AwardingCriterionTypeCode>
			<!-- Award Criterion Description (BT-540): eForms documentation cardinality (Lot) = ? | eForms Regulation Annex table conditions = Mandatory for CAN subtypes 29, 31, and 32; Optional for PIN subtypes 7-9, CN subtypes 10-24 and E3, CAN subtypes 25-28, 30, 33-37, and E4, CM subtype E5; Forbidden for other subtypes -->
				<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Award Criterion Description (BT-540)'"/></xsl:call-template>
				<xsl:call-template name="multilingual">
					<xsl:with-param name="contexts" select="."/>
					<xsl:with-param name="local" select="'P'"/>
					<xsl:with-param name="element" select="'cbc:Description'"/>
				</xsl:call-template>
			</cac:SubordinateAwardingCriterion>
			<cac:SubordinateAwardingCriterion>
				<!-- Award Criterion Type (BT-539): eForms documentation cardinality (Lot) = ? | eForms Regulation Annex table conditions = Mandatory for CAN subtypes 29, 31, and 32; Optional for PIN subtypes 7-9, CN subtypes 10-24 and E3, CAN subtypes 25-28, 30, 33-37, and E4, CM subtype E5; Forbidden for other subtypes -->
				<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Award Criterion Type (BT-539)'"/></xsl:call-template>
				<cbc:AwardingCriterionTypeCode listName="award-criterion-type">price</cbc:AwardingCriterionTypeCode>
			<!-- Award Criterion Description (BT-540): eForms documentation cardinality (Lot) = ? | eForms Regulation Annex table conditions = Mandatory for CAN subtypes 29, 31, and 32; Optional for PIN subtypes 7-9, CN subtypes 10-24 and E3, CAN subtypes 25-28, 30, 33-37, and E4, CM subtype E5; Forbidden for other subtypes -->
				<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Award Criterion Description (BT-540)'"/></xsl:call-template>
				<xsl:call-template name="multilingual">
					<xsl:with-param name="contexts" select="."/>
					<xsl:with-param name="local" select="'P'"/>
					<xsl:with-param name="element" select="'cbc:Description'"/>
				</xsl:call-template>
			</cac:SubordinateAwardingCriterion>
			<cac:SubordinateAwardingCriterion>
				<!-- Award Criterion Type (BT-539): eForms documentation cardinality (Lot) = ? | eForms Regulation Annex table conditions = Mandatory for CAN subtypes 29, 31, and 32; Optional for PIN subtypes 7-9, CN subtypes 10-24 and E3, CAN subtypes 25-28, 30, 33-37, and E4, CM subtype E5; Forbidden for other subtypes -->
				<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Award Criterion Type (BT-539)'"/></xsl:call-template>
				<cbc:AwardingCriterionTypeCode listName="award-criterion-type">quality</cbc:AwardingCriterionTypeCode>
			<!-- Award Criterion Description (BT-540): eForms documentation cardinality (Lot) = ? | eForms Regulation Annex table conditions = Mandatory for CAN subtypes 29, 31, and 32; Optional for PIN subtypes 7-9, CN subtypes 10-24 and E3, CAN subtypes 25-28, 30, 33-37, and E4, CM subtype E5; Forbidden for other subtypes -->
				<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Award Criterion Description (BT-540)'"/></xsl:call-template>
				<xsl:call-template name="multilingual">
					<xsl:with-param name="contexts" select="."/>
					<xsl:with-param name="local" select="'P'"/>
					<xsl:with-param name="element" select="'cbc:Description'"/>
				</xsl:call-template>
			</cac:SubordinateAwardingCriterion>
		</cac:AwardingCriterion>
	</xsl:if>
</xsl:template>

<!-- Prize information is only for notices of type "CN design", and covers Prize Rank (BT-44), Value Prize (BT-644) and Rewards Other (BT-45); the last one being for prizes not having equivalent monetary value. -->
<xsl:template name="prize">
	<!-- NUMBER_VALUE_PRIZE and DETAILS_PAYMENT often occur in the same notice -->
	<xsl:variable name="text" select="fn:normalize-space(fn:string-join($ted-form-main-element/ted:PROCEDURE/(ted:NUMBER_VALUE_PRIZE|ted:DETAILS_PAYMENT)/ted:P, ' '))"/>
	<xsl:choose>
		<xsl:when test="$text ne ''">
			<cac:Prize>
				<!-- Prize Rank (BT-44): eForms documentation cardinality (Lot) = 1 | Optional for CN subtypes 23 and 24; Forbidden for other subtypes -->
				<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Prize Rank (BT-44)'"/></xsl:call-template>
				<!--WARNING: Prize information requires a Prize Rank (BT-44), but no equivalent information is specified in the TED XML schema. In order to obtain valid XML for this notice, a fixed value of "1" was used.-->
				<xsl:variable name="message">WARNING: Prize information requires a Prize Rank (BT-44), but no equivalent information is specified in the TED XML schema. In order to obtain valid XML for this notice, a fixed value of "1" was used.</xsl:variable>
				<xsl:call-template name="report-warning"><xsl:with-param name="message" select="$message"/></xsl:call-template>
				<cbc:RankCode>1</cbc:RankCode>
				<!-- Value Prize (BT-644): eForms documentation cardinality (Lot) = 1 | Optional for CN subtypes 23 and 24; Forbidden for other subtypes -->
				<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Value Prize (BT-644)'"/></xsl:call-template>
				<!--WARNING: Prize information allows a Value Prize (BT-644), but no explicit equivalent information is specified in the TED XML schema. Implicit information might be extracted from the Prize description.-->
				<xsl:variable name="message">WARNING: Prize information allows a Value Prize (BT-644), but no explicit equivalent information is specified in the TED XML schema. Implicit information might be extracted from the Prize description.</xsl:variable>
				<xsl:call-template name="report-warning"><xsl:with-param name="message" select="$message"/></xsl:call-template>
				<!-- Rewards Other (BT-45): eForms documentation cardinality (Lot) = ? | Optional for CN subtypes 23 and 24; Forbidden for other subtypes -->
				<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Rewards Other (Prize Description) (BT-45): may contain content from both NUMBER_VALUE_PRIZE and DETAILS_PAYMENT'"/></xsl:call-template>
				<xsl:if test="$text ne ''">
					<xsl:call-template name="multilingual">
						<xsl:with-param name="contexts" select="$ted-form-main-element/ted:PROCEDURE/(ted:NUMBER_VALUE_PRIZE|ted:DETAILS_PAYMENT)"/>
						<xsl:with-param name="local" select="'P'"/>
						<xsl:with-param name="element" select="'cbc:Description'"/>
					</xsl:call-template>
				</xsl:if>
			</cac:Prize>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Prize Rank (BT-44)'"/></xsl:call-template>
			<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Value Prize (BT-644)'"/></xsl:call-template>
			<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Rewards Other (Prize Description) (BT-45)'"/></xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
