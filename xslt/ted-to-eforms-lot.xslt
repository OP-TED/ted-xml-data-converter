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

	<xsl:template match="ted:OBJECT_DESCR">
		<cac:ProcurementProjectLot>
			<!-- for form F02, the element OBJECT_DESCR is the same, whether there is one lot (NO_LOT_DIVISION) or more than one lot (LOT_DIVISION) -->
			<!-- But, for eForms, one Lot is given lot ID LOT-0000, whereas the first of many lots is given lot ID LOT-0001 -->
			<xsl:variable name="lot-id" select="fn:concat('LOT-', functx:pad-integer-to-length((fn:count(./preceding-sibling::ted:OBJECT_DESCR) + 1), 3))"/>
			<cbc:ID schemeName="Lot"><xsl:value-of select="$lot-id"/></cbc:ID>
			<xsl:call-template name="lot-tendering-terms"/>
			<xsl:call-template name="lot-tendering-process"/>
			<xsl:call-template name="lot-procurement-project"/>
		</cac:ProcurementProjectLot>
	</xsl:template>

	<xsl:template name="lot-tendering-terms">
		<xsl:comment> Lot cac:TenderingTerms here </xsl:comment>
		<cac:TenderingTerms>
			<!-- In eForms, Selection Criteria are specified at the Lot level. Multiple Selection Criteria each use a separate <efac:SelectionCriteria> element. -->
			<!--            The different types of Selection Criteria are indicated by values from the selection-criterion codelist -->
			<!-- sui-act Suitability to pursue the professional activity -->
			<!-- ef-stand Economic and financial standing -->
			<!-- tp-abil Technical and professional ability -->
			<!-- other Other -->
			<!-- In TED, Selection Criteria are specified by the LEFTI element, at Procedure level. There are no Selection Criteria specified at Lot level. -->
			<!--            The different types of Selection Criteria are indicated by different elements within the LEFTI element -->
			<!-- PARTICULAR_PROFESSION always has @CTYPE set to "SERVICES". It is most often accompanied by REFERENCE_TO_LAW which contains selection requirements for service providers -->
			
			<!-- Selection Criteria Type (BT-747) cardinality ? -->
			<!-- Selection Criteria Name (BT-749) cardinality ? -->
			<!-- Selection Criteria Description (BT-750) cardinality ? -->
			<!-- Selection Criteria Used (BT-748) cardinality ? -->
			
			<!-- Second Stage Criteria do not have equivalent elements in TED XML -->
			<!-- Selection Criteria Second Stage Invite (BT-40) cardinality ? -->
			<!-- Selection Criteria Second Stage Invite Number Weight (BT-7531) cardinality * -->
			<!-- Selection Criteria Second Stage Invite Number Threshold (BT-7532) cardinality * -->
			<!-- Selection Criteria Second Stage Invite Number (BT-752) cardinality * -->

			<!-- Selection Criteria information is repeatable -->
			<!-- Clarifications requested for documentation of Selection Criteria in TEDEFO-548 -->
			
			<!-- the empty TED elements ECONOMIC_CRITERIA_DOC and TECHNICAL_CRITERIA_DOC indicate that the economic/technical criteria are described in the procurement documents. -->
			<!-- there is no equivalent in eForms. Need to determine if/how to map this element -->
			
			<xsl:apply-templates select="../../ted:LEFTI/(ted:SUITABILITY|ted:ECONOMIC_FINANCIAL_INFO|ted:ECONOMIC_FINANCIAL_MIN_LEVEL|ted:TECHNICAL_PROFESSIONAL_INFO|ted:TECHNICAL_PROFESSIONAL_MIN_LEVEL)"/>
			
			<!-- Variants (BT-63) cardinality ? -->
			<xsl:apply-templates select="ted:NO_ACCEPTED_VARIANTS|ted:ACCEPTED_VARIANTS"/>
			<!-- EU Funds (BT-60) cardinality ? -->
			<xsl:apply-templates select="ted:NO_EU_PROGR_RELATED|ted:EU_PROGR_RELATED"/>
			<!-- Performing Staff Qualification (BT-79) cardinality ? -->
			<xsl:apply-templates select="../../ted:LEFTI/PERFORMANCE_STAFF_QUALIFICATION"/>
			<!-- Recurrence (BT-94) cardinality ? -->
			<!-- Recurrence is a procurement that is likely to be included later in another procedure. -->
			<xsl:apply-templates select="../../ted:COMPLEMENTARY_INFO/(ted:NO_RECURRENT_PROCUREMENT|ted:RECURRENT_PROCUREMENT)"/>
			<!-- Recurrence Description (BT-95) cardinality ? -->
			<xsl:apply-templates select="../../ted:COMPLEMENTARY_INFO/ted:ESTIMATED_TIMING"/>
			<!-- Security Clearance Deadline (BT-78) cardinality ? No equivalent element in TED XML -->
			<!-- Multiple Tenders (BT-769) cardinality ? No equivalent element in TED XML -->
			<!-- Guarantee Required (BT-751) cardinality ? Only exists in TED form F05 -->
			<!-- Guarantee Required Description (BT-75) cardinality ? Only exists in TED form F05 -->
			<!-- Tax legislation information provider No equivalent element in TED XML -->
			<!-- Environment legislation information provider No equivalent element in TED XML -->
			<!-- Employment legislation information provider No equivalent element in TED XML -->
			
			<!-- Documents Restricted Justification (BT-707) cardinality ? No equivalent element in TED XML -->
			<!-- Documents Official Language (BT-708) cardinality ? No equivalent element in TED XML -->
			<!-- Documents Unofficial Language (BT-737) cardinality ? No equivalent element in TED XML -->
			<!-- Documents Restricted (BT-14) cardinality ?, Documents URL (BT-15) cardinality ?, Documents Restricted URL (BT-615) cardinality ? -->
			<xsl:apply-templates select="../../ted:CONTRACTING_BODY/(ted:DOCUMENT_RESTRICTED|ted:DOCUMENT_FULL)"/>
			<!-- Terms Financial (BT-77) cardinality ? No equivalent element in TED XML -->
			<!-- Reserved Participation (BT-71) cardinality + Mandatory in eForms Contract Notice -->
			<xsl:call-template name="reserved-participation"/>

			<!-- Tenderer Legal Form (BT-761) cardinality ? Element LEGAL_FORM only exists in form F05 -->
			<!-- Tenderer Legal Form Description (BT-76) cardinality ? Element LEGAL_FORM only exists in form F05 -->
			<!-- Late Tenderer Information (BT-771) cardinality ? No equivalent element in TED XML -->
			<!-- Subcontracting Tender Indication (BT-651) cardinality + Only relevant for D81 Defense or OTHER -->
			<!-- Subcontracting Obligation (BT-65) cardinality ? Only relevant for D81 Defense or OTHER -->
			<!-- Subcontracting Obligation Maximum (BT-729) cardinality ? Only relevant for D81 Defense or OTHER -->
			<!-- Subcontracting Obligation Minimum (BT-64) cardinality ? Only relevant for D81 Defense or OTHER -->
			<!-- Reserved Execution (BT-736) cardinality 1 Mandatory in eForms Contract Notice -->
			<xsl:call-template name="reserved-execution"/>
			<!-- Electronic Invoicing (BT-743) cardinality ? Mandatory for eForms Contract Notice subtype 16 -->
			<xsl:call-template name="e-invoicing"/>
			<!-- Terms Performance (BT-70) cardinality ? Mandatory for eForms Contract Notice subtypes 17 (F05), 18 and 22 PERFORMANCE_CONDITIONS -->
			<xsl:call-template name="terms-performance"/>
			<!-- Submission Electronic Signature (BT-744) cardinality ? No equivalent element in TED XML -->
			<xsl:call-template name="awarding-terms"/>
			<!-- Organization providing additional information cardinality ? -->
			
			<!-- Organization providing offline access to the procurement documents cardinality ? -->
			<!-- Organization receiving tenders ​/ Requests to participate cardinality ? -->
			<!-- Submission URL (BT-18) cardinality ? -->
			<!-- Organization processing tenders ​/ Requests to participate cardinality ? -->
			<!-- Tender Validity Deadline (BT-98) cardinality ? -->
			<!-- Review Deadline Description (BT-99) cardinality ? -->
			<!-- Review organization cardinality ? -->
			<!-- Organization providing more information on the time limits for review cardinality ? -->
			<!-- Mediation Organization cardinality ? -->
			<!-- Submission Language (BT-97) cardinality + -->
	
	
			<!-- Electronic Ordering (BT-92) cardinality ? -->
			<!-- Electronic Payment (BT-93) cardinality ? -->
			<!-- Participant Name (BT-47) cardinality ? -->
			<!-- Security Clearance Code (BT-578) cardinality 1 -->
			<!-- Security Clearance Description (BT-732) cardinality 1 -->
		</cac:TenderingTerms>
	</xsl:template>
	
	<xsl:template match="ted:SUITABILITY|ted:ECONOMIC_FINANCIAL_INFO|ted:ECONOMIC_FINANCIAL_MIN_LEVEL|ted:TECHNICAL_PROFESSIONAL_INFO|ted:TECHNICAL_PROFESSIONAL_MIN_LEVEL">
		<xsl:variable name="text" select="fn:normalize-space(fn:string-join(ted:P, ' '))"/>
		<xsl:variable name="element-name" select="fn:local-name(.)"/>
		<xsl:variable name="selection-criterion-type" select="$mappings//selection-criterion-types/mapping[ted-value eq $element-name]/fn:string(eforms-value)"/>
		<xsl:if test="$text ne ''">
			<cac:SelectionCriteria>
				<cbc:CriterionTypeCode listName="selection-criterion"><xsl:value-of select="$selection-criterion-type"/></cbc:CriterionTypeCode>
				<cbc:Description languageID="{$eforms-first-language}"><xsl:value-of select="$text"/></cbc:Description>
			</cac:SelectionCriteria>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="ted:DOCUMENT_RESTRICTED|ted:DOCUMENT_FULL">
		<xsl:variable name="element-name" select="fn:local-name(.)"/>
		<cac:CallForTendersDocumentReference>
			<cbc:ID>DOCUMENT_ID_REQUIRED_HERE</cbc:ID>
			<xsl:choose>
				<xsl:when test="$element-name eq 'DOCUMENT_RESTRICTED'">
					<cbc:DocumentTypeCode listName="communication-justification">CODE_FOR_RESTRICTED_DOCUMENT_JUSTIFICATION_REQUIRED_HERE</cbc:DocumentTypeCode>
					<cbc:DocumentType>restricted-document</cbc:DocumentType>
				</xsl:when>
				<xsl:otherwise>
					<cbc:DocumentType>non-restricted-document</cbc:DocumentType>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates select="following-sibling::ted:URL_DOCUMENT"/>
		</cac:CallForTendersDocumentReference>
	</xsl:template>
	
	<xsl:template match="ted:URL_DOCUMENT">
		<cac:Attachment>
			<cac:ExternalReference>
				<cbc:URI><xsl:value-of select="."/></cbc:URI>
			</cac:ExternalReference>
		</cac:Attachment>
	</xsl:template>
	
<!-- 
eForms reserved-procurement codelist
res-ws Participation is reserved to sheltered workshops and economic operators aiming at the social and professional integration of disabled or disadvantaged persons.
res-pub-ser Participation is reserved to organisations pursuing a public service mission and fulfilling other relevant conditions in the legislation.
none None

TED elements
RESTRICTED_SHELTERED_WORKSHOP	The contract/concession is reserved to sheltered workshops and economic operators aiming at the social and professional integration of disabled or disadvantaged persons
RESERVED_ORGANISATIONS_SERVICE_MISSION	Participation in the procedure is reserved to organisations pursuing a public service mission and fulfilling the conditions set in Article 77(2) of Directive 2014/24/EU
RESERVED_ORGANISATIONS_SERVICE_MISSION	Participation in the procedure is reserved to organisations pursuing a public service mission and fulfilling the conditions set in Article 94(2) of Directive 2014/25/EU

-->
	<xsl:template name="reserved-participation">
		<!-- Reserved Participation (BT-71) is Mandatory for notice subtypes 7-9 (PIN) and 10-22 (CN) -->
		<!-- reserved-procurement code res-pub-ser is RESERVED_ORGANISATIONS_SERVICE_MISSION in TED XML, used only in F21 -->
		<xsl:choose>
			<xsl:when test="fn:boolean($ted-form-main-element/ted:LEFTI/(ted:RESTRICTED_SHELTERED_WORKSHOP|ted:RESERVED_ORGANISATIONS_SERVICE_MISSION))">
				<xsl:apply-templates select="$ted-form-main-element/ted:LEFTI/(ted:RESTRICTED_SHELTERED_WORKSHOP|ted:RESERVED_ORGANISATIONS_SERVICE_MISSION)"/>
			</xsl:when>
			<xsl:otherwise>
				<cac:SpecificTendererRequirement>
					<cbc:TendererRequirementTypeCode listName="reserved-procurement">none</cbc:TendererRequirementTypeCode>
				</cac:SpecificTendererRequirement>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="ted:RESTRICTED_SHELTERED_WORKSHOP">
		<cac:SpecificTendererRequirement>
			<cbc:TendererRequirementTypeCode listName="reserved-procurement">res-ws</cbc:TendererRequirementTypeCode>
		</cac:SpecificTendererRequirement>
	</xsl:template>

	<xsl:template match="ted:RESERVED_ORGANISATIONS_SERVICE_MISSION">
		<cac:SpecificTendererRequirement>
			<cbc:TendererRequirementTypeCode listName="reserved-procurement">res-pub-ser</cbc:TendererRequirementTypeCode>
		</cac:SpecificTendererRequirement>
	</xsl:template>

<!-- 
TED elements
RESTRICTED_SHELTERED_PROGRAM	The execution of the contract/concession is restricted to the framework of sheltered employment programmes
-->
	<xsl:template name="reserved-execution">
		<!-- Reserved Execution (BT-736) is Mandatory for notice subtypes 7-9 (PIN) and 10-22 (CN) -->
		<xsl:variable name="is-reserved-execution">
			<xsl:choose>
				<xsl:when test="fn:boolean($ted-form-main-element/ted:LEFTI/ted:RESTRICTED_SHELTERED_PROGRAM)">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<cac:ContractExecutionRequirement>
			<cbc:ExecutionRequirementCode listName="reserved-execution"><xsl:value-of select="$is-reserved-execution"/></cbc:ExecutionRequirementCode>
		</cac:ContractExecutionRequirement>
	</xsl:template>

<!--
eForms permission codelist
not-allowed Not allowed
allowed Allowed
required Required
TED element
EINVOICING	Electronic invoicing will be accepted
-->
	<xsl:template name="e-invoicing">
		<!-- Electronic Invoicing (BT-743) is Mandatory for notice subtype 16 (CN) -->
		<xsl:variable name="is-e-invoicing">
			<xsl:choose>
				<xsl:when test="fn:boolean($ted-form-main-element/ted:COMPLEMENTARY_INFO/ted:EINVOICING)">allowed</xsl:when>
				<xsl:otherwise>not-allowed</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<cac:ContractExecutionRequirement>
			<cbc:ExecutionRequirementCode listName="einvoicing"><xsl:value-of select="$is-e-invoicing"/></cbc:ExecutionRequirementCode>
		</cac:ContractExecutionRequirement>
	</xsl:template>

	<xsl:template name="terms-performance">
		<!-- Terms Performance (BT-70) is Mandatory for eForms Contract Notice subtypes 17 (F05), 18 (CONTRACT_DEFENCE) and 22 (CONTRACT_CONCESSIONAIRE_DEFENCE) -->
		<xsl:variable name="text" select="fn:normalize-space(fn:string-join($ted-form-main-element/ted:LEFTI/ted:PERFORMANCE_CONDITIONS/ted:P, ' '))"/>
		<xsl:if test="$eforms-notice-subtype = ('17', '18', '22') or $text ne ''">
			<xsl:variable name="text-or-default" select="if ($text ne '') then $text else 'PERFORMANCE CONDITIONS NOT FOUND'"/>
			<cac:ContractExecutionRequirement>
				<cbc:ExecutionRequirementCode listName="conditions">performance</cbc:ExecutionRequirementCode>
				<cbc:Description languageID="{$eforms-first-language}"><xsl:value-of select="$text-or-default"/></cbc:Description>
			</cac:ContractExecutionRequirement>
		</xsl:if>
	</xsl:template>




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
		<cac:AwardingCriterion>
			<xsl:apply-templates select="*"/>
		</cac:AwardingCriterion>
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

	<xsl:template name="lot-tendering-process">
		<xsl:comment> cac:TenderingProcess here </xsl:comment>
		<cac:TenderingProcess>
			<ext:UBLExtensions>
				<ext:UBLExtension>
					<ext:ExtensionContent>
						<efext:EformsExtension>
							<!-- Procurement Relaunch (BT-634) cardinality >? Note: review after meeting on BT-634 and email from Carmen -->
						</efext:EformsExtension>
					</ext:ExtensionContent>
				</ext:UBLExtension>
			</ext:UBLExtensions>
			<!-- Tool Name (BT-632) cardinality ? -->
			<!-- Deadline Receipt Expressions (BT-630) cardinality ? -->
			<!-- SubmissionElectronic (BT-17) cardinality ? -->
			<!-- Successive Reduction Indicator (Procedure) (BT-52) cardinality ? -->
			<!-- GPA Coverage (BT-115) cardinality ? -->
			<!-- Tool Atypical URL (BT-124) cardinality ? -->
			<!-- Deadline Receipt Tenders (BT-131) cardinality ? -->
			<!-- Dispatch Invitation Tender (BT-130) cardinality ? -->
			<!-- Deadline Receipt Requests (BT-1311) cardinality ? -->
			<!-- Additional Information Deadline (BT-13) cardinality ? -->
			<!-- Previous Planning Identifier (BT-125) cardinality ? -->
			<!-- Submission Nonelectronic Justification (BT-19) cardinality ? -->
			<!-- Additional Information Deadline (BT-13) cardinality ? -->
			<!-- Submission Nonelectronic Description (BT-745) cardinality ? -->
			<!-- Maximum Candidates Indicator (BT-661) cardinality ? -->
			<!-- Maximum Candidates (BT-51) cardinality ? -->
			<!-- Minimum Candidates (BT-50) cardinality ? -->
			<!-- Public Opening Date (BT-132) cardinality ? -->
			<!-- Public Opening Description (BT-134) cardinality ? -->
			<!-- Public Opening Place (BT-133) cardinality ? -->
			<!-- Electronic Auction (BT-767) cardinality ? -->
			<!-- Electronic Auction Description (BT-122) cardinality ? -->
			<!-- Electronic Auction URL (BT-123) cardinality ? -->
			<!-- Framework Maximum Participants Number (BT-113) cardinality ? -->
			<!-- Framework Duration Justification (BT-109) cardinality ? -->
			<!-- Framework Buyer Categories (BT-111) cardinality ? -->
			<!-- Framework Agreement (BT-765) cardinality ? -->
			<!-- Dynamic Purchasing System (BT-766) cardinality ? -->
		</cac:TenderingProcess>
	</xsl:template>
	<xsl:template name="lot-procurement-project">
		<xsl:comment> cac:ProcurementProject here </xsl:comment>
		<cac:ProcurementProject>
	
			<!-- Internal Identifier (BT-22) cardinality 1 No equivalent element in TED XML -->
			<!-- Title (BT-21) cardinality 1 -->
			<xsl:apply-templates select="ted:OBJECT_CONTRACT/ted:TITLE"/>
			<!-- Description (BT-24) cardinality 1 -->
			<xsl:apply-templates select="ted:OBJECT_CONTRACT/ted:SHORT_DESCR"/>
			<!-- Main Nature (BT-23) cardinality 1 -->
			<xsl:apply-templates select="ted:OBJECT_CONTRACT/ted:TYPE_CONTRACT"/>
			<!-- Additional Nature (different from Main) (BT-531) cardinality * No equivalent element in TED XML -->
			<!-- Strategic Procurement (BT-06) cardinality * -->
			<!-- Strategic Procurement Description (BT-777) cardinality * -->
			<!-- Green Procurement (BT-774) cardinality * -->
			<!-- Social Procurement (BT-775) cardinality * -->
			<!-- Innovative Procurement (BT-776) cardinality * -->
			<!-- Accessibility Justification (BT-755) cardinality ? -->
			<!-- Accessibility (BT-754) cardinality ? -->
			<!-- Quantity (BT-25) cardinality ? -->
			<!-- Unit (BT-625) cardinality ? -->
			<!-- Suitable for SMEs (BT-726) cardinality ? -->
	
			<!-- Additional Information (BT-300) (*)* cardinality ? -->
			<!-- Estimated Value (BT-27) cardinality ? -->
			<xsl:apply-templates select="ted:OBJECT_CONTRACT/ted:VAL_ESTIMATED_TOTAL"/>
			<!-- Classification Type (e.g. CPV) (BT-26) cardinality 1 -->
			<xsl:apply-templates select="ted:OBJECT_CONTRACT/ted:CPV_MAIN"/>
			<!-- Main Classification Code (BT-262) cardinality 1 -->
			<!-- Additional Classification Code (BT-263) cardinality * -->
			<!-- Place of Performance (*) -> RealizedLocation -->
	
				<!-- Place of Performance Additional Information (BT-728) -->
				<!-- Place Performance City (BT-5131) -->
				<!-- Place Performance Post Code (BT-5121) -->
				<!-- Place Performance Country Subdivision (BT-5071) -->
				<!-- Place Performance Services Other (BT-727) -->
				<!-- Place Performance Street (BT-5101) -->
				<!-- Place Performance Country Code (BT-5141) -->
				<!-- Duration Start Date (BT-536) -->
				<!-- Duration End Date (BT-537) -->
				<!-- Duration Period (BT-36) -->
				<!-- Duration Other (BT-538) -->
				<!-- Options Description (BT-54) -->
				<!-- Renewal maximum (BT-58) -->
				<!-- Renewal Description (BT-57) -->
		</cac:ProcurementProject>
	</xsl:template>

</xsl:stylesheet>
