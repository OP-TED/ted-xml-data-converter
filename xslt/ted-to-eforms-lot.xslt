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
			<!-- Organization providing additional information cardinality BT-18 ? -->
			
			<!-- In TED, within element CONTRACTING_BODY, the elements ADDRESS_FURTHER_INFO_IDEM and ADDRESS_PARTICIPATION_IDEM are used to represent options for "to the abovementioned address" in the PDF forms. -->
			<!-- These indicate that for the functions of "Additional information can be obtained from" and "Tenders or requests to participate must be submitted to", the Contracting Authority address should be used. -->
			<!-- in eForms, such a direction is implicit, and no such elements are used. So the element ADDRESS_FURTHER_INFO_IDEM will not be mapped. -->
			<!-- However, the element ADDRESS_PARTICIPATION_IDEM may exist with a sibling element URL_PARTICIPATION, which is mapped to the element cbc:EndpointID within cac:TenderRecipientParty. -->
			<!-- In this case, it does not make sense to include cac:TenderRecipientParty without pointing to the correct address, so ADDRESS_PARTICIPATION_IDEM will be mapped if it has a URL_PARTICIPATION sibling -->
			
			<!-- Organization providing offline access to the procurement documents cardinality ? -->
			<xsl:apply-templates select="../../ted:CONTRACTING_BODY/ted:ADDRESS_FURTHER_INFO"/>
			<!-- Organization receiving tenders ​/ Requests to participate cardinality ? No equivalent element in TED XML -->
			<!-- Submission URL (BT-18) cardinality ? -->
			<!-- Organization processing tenders ​/ Requests to participate cardinality ? -->
			<xsl:call-template name="address-participation-url-participation"/>
			<!-- Tender Validity Deadline (BT-98) cardinality ? Only relevant for eForms Contract Notice subtypes 16, 17 (F02, F05) and 20, 21 (F21, F22) and E3 -->
			<xsl:apply-templates select="../../ted:PROCEDURE/(ted:DATE_TENDER_VALID|ted:DURATION_TENDER_VALID)"/>
			<!-- Review Deadline Description (BT-99) cardinality ? -->
			<!-- Review organization cardinality ? -->
			<!-- Organization providing more information on the time limits for review cardinality ? -->
			<!-- Mediation Organization cardinality ? -->
			<xsl:call-template name="appeal-terms"/>
			<!-- Submission Language (BT-97) cardinality + Mandatory for PIN Notice subtypes 7, 8 and 9, and CN Notice subtypes 10-14, 16-22; Optional for CN Notice subtypes 15, 23, 24 and E3 -->
			<!-- Forbidden for all other Notice subtypes -->
			<xsl:apply-templates select="../../ted:PROCEDURE/ted:LANGUAGES/ted:LANGUAGE"/>
			<!-- Electronic Ordering (BT-92) cardinality ? Mandatory for CN subtype 16, Optional for CN subtypes 7-15 and 17-22 -->
			<!-- Electronic Payment (BT-93) cardinality ? Mandatory for CN subtype 16, Optional for CN subtypes 7-15 and 17-22 -->
			<xsl:call-template name="post-award-processing"/>
			<!-- Participant Name (BT-47) cardinality ? Optional for CN Design subtypes 23 and 24; Forbidden for all other Notice subtypes -->
			<!-- Security Clearance Code (BT-578) cardinality ? No equivalent element in TED XML -->
			<!-- Security Clearance Description (BT-732) cardinality ? No equivalent element in TED XML -->
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
	
	<xsl:template name="address-participation-url-participation">
		<!-- if either ADDRESS_PARTICIPATION or URL_PARTICIPATION is present, cac:TenderRecipientParty must be used. -->
		<!-- if ADDRESS_PARTICIPATION_IDEM is present alone, cac:TenderRecipientParty is not output -->
		<xsl:if test="../../ted:CONTRACTING_BODY/(ted:ADDRESS_PARTICIPATION|ted:URL_PARTICIPATION)">
			<cac:TenderRecipientParty>
				<xsl:apply-templates select="../../ted:CONTRACTING_BODY/ted:URL_PARTICIPATION"/>
				<xsl:apply-templates select="../../ted:CONTRACTING_BODY/(ted:ADDRESS_PARTICIPATION|ted:ADDRESS_PARTICIPATION_IDEM)"/>
			</cac:TenderRecipientParty>
		</xsl:if>
	</xsl:template>

	<xsl:template match="ted:DATE_TENDER_VALID">
		<!-- need to calculate an integer value of days from DATE_TENDER_VALID minus DATE_RECEIPT_TENDERS -->
		<xsl:variable name="date-receipt-tenders" select="xs:date(../ted:DATE_RECEIPT_TENDERS)"/>
		<xsl:variable name="date-tender-valid" select="xs:date(.)"/>
		<xsl:variable name="days" select="($date-tender-valid - $date-receipt-tenders) div xs:dayTimeDuration('P1D')"/>
		<cac:TenderValidityPeriod>
			<cbc:DurationMeasure unitCode="DAY"><xsl:value-of select="$days"/></cbc:DurationMeasure>
		</cac:TenderValidityPeriod>
	</xsl:template>

	<xsl:template match="ted:DURATION_TENDER_VALID">
		<!-- Duration in months (from the date stated for receipt of tender) -->
		<!-- TYPE attribute is FIXED to "MONTH" -->		
		<cac:TenderValidityPeriod>
			<cbc:DurationMeasure unitCode="MONTH"><xsl:value-of select="fn:number(.)"/></cbc:DurationMeasure>
		</cac:TenderValidityPeriod>
	</xsl:template>

	<xsl:template name="appeal-terms">
		<cac:AppealTerms>
			<xsl:apply-templates select="../../ted:COMPLEMENTARY_INFO/ted:REVIEW_PROCEDURE"/>
			<xsl:apply-templates select="../../ted:COMPLEMENTARY_INFO/ted:ADDRESS_REVIEW_INFO"/>
			<xsl:apply-templates select="../../ted:COMPLEMENTARY_INFO/ted:ADDRESS_REVIEW_BODY"/>
			<xsl:apply-templates select="../../ted:COMPLEMENTARY_INFO/ted:ADDRESS_MEDIATION_BODY"/>
		</cac:AppealTerms>
	</xsl:template>
	
	<xsl:template match="ted:REVIEW_PROCEDURE">
		<xsl:variable name="text" select="fn:normalize-space(fn:string-join(ted:P, ' '))"/>
		<xsl:if test="$text ne ''">
			<cac:PresentationPeriod>
				<cbc:Description languageID="{$eforms-first-language}"><xsl:value-of select="$text"/></cbc:Description>
			</cac:PresentationPeriod>
		</xsl:if>
	</xsl:template>

	<xsl:template match="ted:LANGUAGE">
		<xsl:variable name="lang" select="opfun:get-eforms-language(@VALUE)"/>
		<cac:Language>
			<cbc:ID><xsl:value-of select="$lang"/></cbc:ID>
		</cac:Language>
	</xsl:template>

	<xsl:template name="post-award-processing">
		<xsl:if test="../../ted:COMPLEMENTARY_INFO/(ted:EORDERING|ted:EINVOICING) or $eforms-notice-subtype eq '16'">
			<cac:PostAwardProcess>
				<xsl:apply-templates select="../../ted:COMPLEMENTARY_INFO/(ted:EORDERING|ted:EINVOICING)"/>
			</cac:PostAwardProcess>
		</xsl:if>
	</xsl:template>

	
	<xsl:template name="lot-tendering-process">
		<xsl:comment> cac:TenderingProcess here </xsl:comment>
	
	
		<cac:TenderingProcess>
			<ext:UBLExtensions>
				<ext:UBLExtension>
					<ext:ExtensionContent>
						<efext:EformsExtension>
							<!-- Procurement Relaunch (BT-634) cardinality ? TBD: review after meeting on BT-634 and email from Carmen -->
							<!-- Tool Name (BT-632) cardinality ? Optional for PIN and CN Notice subtypes 1 to 24, E1, E2 and E3; Forbidden for other Notice subtypes No equivalent element in TED XML -->
							<!-- Deadline Receipt Expressions (BT-630) cardinality ? Mandatory for CN Notice subtypes 10-14, Optional for CN Notice subtypes 20,21; Forbidden for other Notice subtypes -->
							<!-- Note: TED DATE_RECEIPT_TENDERS and TIME_RECEIPT_TENDERS map to either Deadline Receipt Expressions (BT-630) or Deadline Receipt Tenders (BT-131) depending on the Notice subtype -->
							<xsl:if test="(../../ted:PROCEDURE/ted:DATE_RECEIPT_TENDERS) and ($eforms-notice-subtype = ('10', '11', '12', '13', '14', '20', '21'))">
								<efac:InterestExpressionReceptionPeriod>
									<xsl:call-template name="date-time-receipt-tenders"/>
								</efac:InterestExpressionReceptionPeriod>
							</xsl:if>
						</efext:EformsExtension>
					</ext:ExtensionContent>
				</ext:UBLExtension>
			</ext:UBLExtensions>
			<!-- SubmissionElectronic (BT-17) cardinality ? Mandatory for CN Notice subtypes 10, 11, 15-17, 23, 24; Optional for PIN Notice subtypes 7-9 and CN Notice subtypes 12-14, 18-22; Forbidden for other Notice subtypes -->
			<!-- NB TED does not cater for the meaning of the value "Required" from the permission codelist in this context -->
			<!-- TBD Question in TEDXDC-38: What does it mean when URL_TOOL is present, but URL_PARTICIPATION is not present? -->
			<xsl:variable name="electronic-submission">
				<xsl:choose>
					<xsl:when test="../../ted:CONTRACTING_BODY/ted:URL_PARTICIPATION"><xsl:text>allowed</xsl:text></xsl:when>
					<xsl:otherwise><xsl:text>not-allowed</xsl:text></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<cbc:SubmissionMethodCode listName="esubmission"><xsl:value-of select="$electronic-submission"/></cbc:SubmissionMethodCode>
			<!-- Successive Reduction Indicator (Procedure) (BT-52) cardinality ? Mandatory for CN Notice subtype 16; Optional for PIN Notice subtypes 7-9, CN Notice subtypes 10-14, 17-18, 20-24 and E3. Forbidden for other Notice subtypes -->
			<xsl:if test="../../ted:PROCEDURE/ted:REDUCTION_RECOURSE or $eforms-notice-subtype = '16'">
				<cbc:CandidateReductionConstraintIndicator><xsl:value-of select="if (fn:exists(../../ted:PROCEDURE/ted:REDUCTION_RECOURSE)) then 'true' else 'false'"/></cbc:CandidateReductionConstraintIndicator>
			</xsl:if>
			<!-- GPA Coverage (BT-115) cardinality ? Mandatory for subtypes PIN 7, 8; CN 10, 11, 15, 16, 17; CAN 25, 26, 29, 30; Optional for subtypes PIN 4, 5; CN 19; CAN 28; CM 38-40. Forbidden for other Notice subtypes -->
			<xsl:if test="../../ted:PROCEDURE/(CONTRACT_COVERED_GPA|NO_CONTRACT_COVERED_GPA)">
				<cbc:GovernmentAgreementConstraintIndicator><xsl:value-of select="if (fn:exists(../../ted:PROCEDURE/ted:CONTRACT_COVERED_GPA)) then 'true' else 'false'"/></cbc:GovernmentAgreementConstraintIndicator>
			</xsl:if>
			
			<!-- Tool Atypical URL (BT-124) cardinality ? Optional for PIN and CN Notice subtypes 1 to 24, E1, E2 and E3 Forbidden for other Notice subtypes CONTRACTING_BODY/URL_TOOL -->
			<xsl:apply-templates select="../../ted:CONTRACTING_BODY/ted:URL_TOOL"/>
			
			<!-- Deadline Receipt Tenders (BT-131) cardinality ? Mandatory for subtypes PIN 8; Optional for subtypes PIN 7, 9; CN 16-24; Forbidden for other Notice subtypes -->
			<!-- Note: TED DATE_RECEIPT_TENDERS and TIME_RECEIPT_TENDERS map to either Deadline Receipt Expressions (BT-630) or Deadline Receipt Tenders (BT-131) depending on the Notice subtype -->
			<!-- TBD: Question: For Notice Subtypes 20 and 21, BOTH Deadline Receipt Expressions (BT-630) AND Deadline Receipt Tenders (BT-131) map from TED DATE_RECEIPT_TENDERS and TIME_RECEIPT_TENDERS - What should we do? -->
			<xsl:if test="(../../ted:PROCEDURE/ted:DATE_RECEIPT_TENDERS) and ($eforms-notice-subtype = ('7', '8', '9', '16', '17', '18', '19', '20', '21','22', '23', '24'))">
				<cac:TenderSubmissionDeadlinePeriod>
					<xsl:call-template name="date-time-receipt-tenders"/>
				</cac:TenderSubmissionDeadlinePeriod>
			</xsl:if>
			<!-- Dispatch Invitation Tender (BT-130) cardinality ? Optional for subtypes PIN 7-9, CN 10-14, 16-24. Forbidden for other Notice subtypes -->
			<xsl:apply-templates select="../../ted:COMPLEMENTARY_INFO/ted:DATE_DISPATCH_NOTICE"/>
			<!-- Deadline Receipt Requests (BT-1311) cardinality ? Optional for subtypes PIN 7, 9; CN 16-24; Forbidden for other Notice subtypes -->
			
			
			<!-- Additional Information Deadline (BT-13) cardinality ? No equivalent element in TED XML -->
			<!-- Previous Planning Identifier (BT-125) cardinality ? The equivalent element(s) in TED are at TED_EXPORT/CODED_DATA_SECTION/NOTICE_DATA/REF_NOTICE/NO_DOC_OJS -->
			<!-- They are not at Lot level, but at the level of the Notice. This will need discussion on what is required and how to implement it. -->
			<!-- Submission Nonelectronic Justification (BT-19) cardinality ? No equivalent element in TED XML -->
			<!-- Submission Nonelectronic Description (BT-745) cardinality ? No equivalent element in TED XML -->
			
			<!-- Note: TED element TED_EXPORT/FORM_SECTION/F02_2014/OBJECT_CONTRACT/OBJECT_DESCR/NB_ENVISAGED_CANDIDATE has no equivalent in eForms -->
			<!-- Maximum Candidates Indicator (BT-661) cardinality ? Mandatory for subtypes CN 16; Optional for subtypes PIN 7-9; CN 10-14, 17, 18, 20-24 and E3; Forbidden for other Notice subtypes TED_EXPORT/FORM_SECTION/F02_2014/OBJECT_CONTRACT/OBJECT_DESCR/NB_MAX_LIMIT_CANDIDATE -->
			<!-- Maximum Candidates (BT-51) cardinality ? Optional for subtypes PIN 7-9; CN 10-14, 16-18, 20-24 and E3; Forbidden for other Notice subtypes -->
			<!-- Minimum Candidates (BT-50) cardinality ? Mandatory for subtypes CN 16; Optional for subtypes PIN 7-9; CN 10-14, 17, 18, 20-24 and E3; Forbidden for other Notice subtypes -->
			<xsl:call-template name="limit-candidate"/>
			<!-- Public Opening Date (BT-132) cardinality ? Optional for subtypes CN 16, 17, 20, 21 and E3; Forbidden for other Notice subtypes TED_EXPORT/FORM_SECTION/F02_2014/PROCEDURE/OPENING_CONDITION/DATE_OPENING_TENDERS -->
			<!-- Public Opening Description (BT-134) cardinality ? Optional for subtypes CN 16, 17, 20, 21 and E3; Forbidden for other Notice subtypes -->
			<!-- Public Opening Place (BT-133) cardinality ? Optional for subtypes CN 16, 17, 20, 21 and E3; Forbidden for other Notice subtypes -->
			<xsl:apply-templates select="../../ted:PROCEDURE/ted:OPENING_CONDITION"/>
			<!-- Electronic Auction (BT-767) cardinality ? Mandatory for subtypes CN 16-18, 22; Optional for subtypes PIN 7-9; CN 10-14, 19-21 and E3; Forbidden for other Notice subtypes -->
			<!-- Electronic Auction Description (BT-122) cardinality ? Optional for subtypes PIN 7-9; CN 10-14, 16-22 and E3; Forbidden for other Notice subtypes -->
			<!-- Electronic Auction URL (BT-123) cardinality ? Optional for subtypes PIN 7-9; CN 10-14, 16-22 and E3; Forbidden for other Notice subtypes -->
			<xsl:call-template name="eauction-used"/>
			<!-- Framework Maximum Participants Number (BT-113) cardinality ? Optional for subtypes PIN 7-9; CN 10-13, 16-18, 20-22 and E3; Forbidden for other Notice subtypes -->
			<!-- Framework Duration Justification (BT-109) cardinality ? Optional for subtypes PIN 7-9; CN 10-13, 16-18, 20-22 and E3; Forbidden for other Notice subtypes -->
			<!-- Group Framework Estimated Maximum Value (BT-157) ? No equivalent element in TED XML -->
			<!-- Framework Buyer Categories (BT-111) cardinality ? No equivalent element in TED XML -->
			<!-- Framework Agreement (BT-765) cardinality ? Mandatory for subtypes PIN 7-9, CN 10-11, 16-18, 22; CAN 29-31; Optional for subtypes PIN 4-6 and E2; CN 12-13, 20-21 and E3; CAN 25-27, 33-34 and E4; Forbidden for other Notice subtypes -->
			<xsl:call-template name="framework-agreement"/>
			<!-- Dynamic Purchasing System (BT-766) cardinality ? Mandatory for subtypes PIN 7-8, CN 10-11, 16-17; CAN 29-30; Optional for subtypes CN 12-13, 20-22 and E3; CAN 25-27, 33-34 and E4; Forbidden for other Notice subtypes -->
			<xsl:call-template name="dps"/>
		</cac:TenderingProcess>
	</xsl:template>
	
	<xsl:template name="date-time-receipt-tenders">
		<!-- NOTE: cbc:EndDate and cbc:EndTime should contain ISO-8601 format dates, i.e. expressed as UTC with offsets. -->
		<!-- TED date elements have no time zone associated, and TED time elements have "local time". -->
		<!-- Therfore for complete accuracy, a mapping of country codes to UTC timezone offsets is required -->
		<!-- In this initial conversion, no such mapping is used, and TED dates and times are assumed to be CET, i.e. UTC+01:00 -->
		<!-- If TIME_RECEIPT_TENDERS is not present, a time of 23:59+01:00 is assumed -->
		<cbc:EndDate><xsl:value-of select="../../ted:PROCEDURE/ted:DATE_RECEIPT_TENDERS"/><xsl:text>+01:00</xsl:text></cbc:EndDate>
		<xsl:variable name="endtime">
			<xsl:choose>
				<xsl:when test="../../ted:PROCEDURE/ted:TIME_RECEIPT_TENDERS">
					<!-- add any missing leading "0" from the hour -->
					<xsl:value-of select="fn:replace(../../ted:PROCEDURE/ted:TIME_RECEIPT_TENDERS, '^([0-9]):', '0$1:')"/>
					<xsl:text>+01:00</xsl:text>
				</xsl:when>
				<xsl:otherwise><xsl:text>23:59+01:00</xsl:text></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<cbc:EndTime><xsl:value-of select="$endtime"/></cbc:EndTime>
	</xsl:template>

	<xsl:template match="ted:DATE_DISPATCH_NOTICE">
		<!-- NOTE: cbc:EndDate and cbc:EndTime should contain ISO-8601 format dates, i.e. expressed as UTC with offsets. -->
		<!-- TED date elements have no time zone associated, and TED time elements have "local time". -->
		<!-- Therfore for complete accuracy, a mapping of country codes to UTC timezone offsets is required -->
		<!-- In this initial conversion, no such mapping is used, and TED dates and times are assumed to be CET, i.e. UTC+01:00 -->
		<cac:InvitationSubmissionPeriod>
			<cbc:StartDate><xsl:value-of select="."/><xsl:text>+01:00</xsl:text></cbc:StartDate>
		</cac:InvitationSubmissionPeriod>
	</xsl:template>

	<xsl:template name="limit-candidate">
		<xsl:if test="ted:NB_MAX_LIMIT_CANDIDATE or ted:NB_MIN_LIMIT_CANDIDATE or $eforms-notice-subtype = '16'">
			<cac:EconomicOperatorShortList>
				<xsl:choose>
					<xsl:when test="ted:NB_MAX_LIMIT_CANDIDATE">
						<cbc:LimitationDescription>true</cbc:LimitationDescription>
						<cbc:MaximumQuantity><xsl:value-of select="ted:NB_MAX_LIMIT_CANDIDATE"/></cbc:MaximumQuantity>
					</xsl:when>
					<xsl:otherwise>
						<cbc:LimitationDescription>false</cbc:LimitationDescription>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="ted:NB_MIN_LIMIT_CANDIDATE">
						<cbc:MinimumQuantity><xsl:value-of select="ted:NB_MIN_LIMIT_CANDIDATE"/></cbc:MinimumQuantity>
					</xsl:when>
					<xsl:when test="$eforms-notice-subtype = '16'">
						<cbc:MinimumQuantity>TEDERR_NO_MINIMUM_QUANTITY</cbc:MinimumQuantity>
					</xsl:when>
				</xsl:choose>
			</cac:EconomicOperatorShortList>
		</xsl:if>
	</xsl:template>

	<xsl:template match="ted:OPENING_CONDITION">
		<!-- NOTE: cbc:OccurrenceDate and cbc:OccurrenceTime should contain ISO-8601 format dates, i.e. expressed as UTC with offsets. -->
		<!-- TED date elements have no time zone associated, and TED time elements have "local time". -->
		<!-- Therfore for complete accuracy, a mapping of country codes to UTC timezone offsets is required -->
		<!-- In this initial conversion, no such mapping is used, and TED dates and times are assumed to be CET, i.e. UTC+01:00 -->
		<cac:OpenTenderEvent>
			<cbc:OccurrenceDate><xsl:value-of select="ted:DATE_OPENING_TENDERS"/><xsl:text>+01:00</xsl:text></cbc:OccurrenceDate>
			<cbc:OccurrenceTime><xsl:value-of select="fn:replace(ted:TIME_OPENING_TENDERS, '^([0-9]):', '0$1:')"/><xsl:text>+01:00</xsl:text></cbc:OccurrenceTime>
			<xsl:apply-templates select="ted:INFO_ADD"/>
			<xsl:apply-templates select="ted:PLACE"/>
		</cac:OpenTenderEvent>
	</xsl:template>
	
	<xsl:template match="ted:OPENING_CONDITION/ted:INFO_ADD">
		<xsl:variable name="text" select="fn:normalize-space(fn:string-join(ted:P, ' '))"/>
		<xsl:if test="$text ne ''">
			<cbc:Description languageID="{$eforms-first-language}"><xsl:value-of select="$text"/></cbc:Description>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="ted:OPENING_CONDITION/ted:PLACE">
		<xsl:variable name="text" select="fn:normalize-space(fn:string-join(ted:P, ' '))"/>
		<xsl:if test="$text ne ''">
			<cac:OccurenceLocation>
				<cbc:Description languageID="{$eforms-first-language}"><xsl:value-of select="$text"/></cbc:Description>
			</cac:OccurenceLocation>
		</xsl:if>
	</xsl:template>

	<xsl:template name="eauction-used">
		<xsl:if test="../../ted:PROCEDURE/ted:EAUCTION_USED or $eforms-notice-subtype = '16'">
			<cac:AuctionTerms>
				<xsl:choose>
					<xsl:when test="../../ted:PROCEDURE/ted:EAUCTION_USED">
						<cbc:AuctionConstraintIndicator>true</cbc:AuctionConstraintIndicator>
						<cbc:Description languageID="{$eforms-first-language}">
							<xsl:variable name="text" select="fn:normalize-space(fn:string-join(../../ted:PROCEDURE/ted:INFO_ADD_EAUCTION/ted:P, ' '))"/>
							<xsl:choose>
								<xsl:when test="$text ne ''"><xsl:value-of select="$text"/></xsl:when>
								<xsl:otherwise><xsl:text>TEDERR_NO_INFO_ADD_EAUCTION</xsl:text></xsl:otherwise>
							</xsl:choose>
						</cbc:Description>
						<cbc:AuctionURI><xsl:text>TEDERR_NO_AuctionURI_ELEMENT</xsl:text></cbc:AuctionURI>
					</xsl:when>
					<xsl:otherwise>
						<cbc:AuctionConstraintIndicator>false</cbc:AuctionConstraintIndicator>
					</xsl:otherwise>
				</xsl:choose>
			</cac:AuctionTerms>
		</xsl:if>
	</xsl:template>

	<xsl:template name="framework-agreement">
		<xsl:if test="../../ted:PROCEDURE/ted:FRAMEWORK or $eforms-notice-subtype = ('7', '8', '9', '10', '11', '16', '17', '18', '22', '29', '30', '31')">
			<xsl:choose>
				<xsl:when test="../../ted:PROCEDURE/ted:FRAMEWORK">
					<xsl:apply-templates select="../../ted:PROCEDURE/ted:FRAMEWORK"/>
					<cac:ContractingSystem>
						<cbc:ContractingSystemTypeCode listName="framework-agreement">fa-wo-rc</cbc:ContractingSystemTypeCode>
					</cac:ContractingSystem>
				</xsl:when>
				<xsl:otherwise>
					<cac:ContractingSystem>
						<cbc:ContractingSystemTypeCode listName="framework-agreement">none</cbc:ContractingSystemTypeCode>
					</cac:ContractingSystem>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="ted:FRAMEWORK">
		<cac:FrameworkAgreement>
			<cbc:MaximumOperatorQuantity>
				<xsl:choose>
					<xsl:when test="ted:SINGLE_OPERATOR"><xsl:text>1</xsl:text></xsl:when>
					<xsl:when test="ted:NB_PARTICIPANTS"><xsl:value-of select="ted:NB_PARTICIPANTS"/></xsl:when>
					<xsl:otherwise><xsl:text>TEDERR_NO_NB_PARTICIPANTS</xsl:text></xsl:otherwise>
				</xsl:choose>
			</cbc:MaximumOperatorQuantity>
			<xsl:apply-templates select="ted:JUSTIFICATION"/>
		</cac:FrameworkAgreement>
	</xsl:template>
	
	<xsl:template match="ted:JUSTIFICATION">
		<xsl:variable name="text" select="fn:normalize-space(fn:string-join(ted:P, ' '))"/>
		<xsl:if test="$text ne ''">
			<cbc:Justification languageID="{$eforms-first-language}"><xsl:value-of select="$text"/></cbc:Justification>
		</xsl:if>
	</xsl:template>

	<xsl:template name="dps">
<!-- dps-usage codelist:
dps-list Dynamic purchasing system, only usable by buyers listed in this notice
dps-nlist Dynamic purchasing system, also usable by buyers not listed in this notice
none None
-->
		<xsl:if test="../../ted:PROCEDURE/ted:DPS or $eforms-notice-subtype = ('7', '8', '10', '11', '16', '17', '29', '30')">
			<cac:ContractingSystem>
				<cbc:ContractingSystemTypeCode listName="dps-usage">
					<xsl:choose>
						<xsl:when test="../../ted:PROCEDURE/ted:DPS_ADDITIONAL_PURCHASERS"><xsl:text>dps-nlist</xsl:text></xsl:when>
						<xsl:when test="../../ted:PROCEDURE/ted:DPS"><xsl:text>dps-list</xsl:text></xsl:when>
						<xsl:otherwise><xsl:text>none</xsl:text></xsl:otherwise>
					</xsl:choose>
				</cbc:ContractingSystemTypeCode>
			</cac:ContractingSystem>
		</xsl:if>
	</xsl:template>

	<xsl:template name="lot-procurement-project">
		<xsl:comment> cac:ProcurementProject here </xsl:comment>
		<cac:ProcurementProject>
			
<!-- CONTINUE HERE -->
			
	
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
