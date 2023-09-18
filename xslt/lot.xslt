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


<!-- template for a single Lot -->
<xsl:template match="*:OBJECT_DESCR">
	<cac:ProcurementProjectLot>
		<!-- For form F02, the element OBJECT_DESCR is the same, whether there is one lot (NO_LOT_DIVISION) or more than one lot (LOT_DIVISION) -->
		<!-- But for eForms, one Lot is given lot ID LOT-0000, whereas the first of many lots is given lot ID LOT-0001 -->
		<!-- The same logic is true for Parts, using "PAR-" instead of "LOT-" -->
		<!-- In TED LOT_NO, if present, usually contains a positive integer. This will be converted to the new eForms format -->
		<!-- Purpose Lot Identifier (BT-137): eForms documentation cardinality (Lot) = 1 | eForms Regulation Annex table conditions = Forbidden for PIN subtypes 1-3; Optional (O or EM or CM) for all other subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Purpose Lot Identifier (BT-137)'"/></xsl:call-template>
		<xsl:variable name="path" select="functx:path-to-node-with-pos(.)"/>
		<xsl:variable name="lot-info" select="$lot-numbers-map//lot[path = $path]"/>
		<xsl:choose>
			<!-- When LOT_NO exists -->
			<xsl:when test="fn:not($lot-info/is-convertible)">
				<xsl:variable name="message"> WARNING: Cannot convert original TED lot or part number of <xsl:value-of select="*:LOT_NO"/> to eForms </xsl:variable>
				<xsl:call-template name="report-warning"><xsl:with-param name="message" select="$message"/></xsl:call-template>
			</xsl:when>
			<xsl:when test="fn:count(../*:OBJECT_DESCR) = 1">
				<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Only one Lot in the TED notice'"/></xsl:call-template>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="$eforms-notice-subtype = ('4', '5', '6', 'E2')">
				<cbc:ID schemeName="Part">
					<xsl:value-of select="$lot-info/lot-id"/>
				</cbc:ID>
			</xsl:when>
			<xsl:otherwise>
				<cbc:ID schemeName="Lot">
					<xsl:value-of select="$lot-info/lot-id"/>
				</cbc:ID>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:call-template name="lot-tendering-terms"/>
		<xsl:call-template name="lot-tendering-process"/>
		<xsl:call-template name="lot-procurement-project"/>
	</cac:ProcurementProjectLot>
</xsl:template>


<!-- Lot Tendering Terms templates -->
<xsl:template name="lot-tendering-terms">
	<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="' Lot cac:TenderingTerms '"/></xsl:call-template>
	<cac:TenderingTerms>
		<!-- Selection Criteria and Funding Details -->
		<xsl:call-template name="selection-criteria-funding-details"/>
		<!-- Variants (BT-63): eForms documentation cardinality (Lot) = ? | Optional for PIN subtypes 7-9, CN subtypes 10-14, 16-24 and E3; Forbidden for other subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Variants (BT-63)'"/></xsl:call-template>
		<xsl:apply-templates select="*:NO_ACCEPTED_VARIANTS|*:ACCEPTED_VARIANTS"/>
		<!-- EU Funds (BT-60): eForms documentation cardinality (Lot) = ? | Mandatory for PIN subtype 7, CN subtypes 10, 16, 19, and 23, CAN subtypes 29, 32, and 36; Forbidden for PIN subtypes 1-6, E1, and E2; Optional for other subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'EU Funds (BT-60)'"/></xsl:call-template>
		<xsl:apply-templates select="*:NO_EU_PROGR_RELATED|*:EU_PROGR_RELATED"/>
		<!-- Performing Staff Qualification (BT-79): eForms documentation cardinality (Lot) = ? | Optional for PIN subtypes 7-9, CN subtypes 10-22 and E3; Forbidden for other subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Performing Staff Qualification (BT-79)'"/></xsl:call-template>
		<xsl:apply-templates select="../../*:LEFTI/PERFORMANCE_STAFF_QUALIFICATION"/>
		<!-- Recurrence (BT-94): eForms documentation cardinality (Lot) = ? | Optional for CN subtypes 15-22 and E3, CM subtypes 38-40; Forbidden for other subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Recurrence (BT-94)'"/></xsl:call-template>
		<!-- Recurrence is a procurement that is likely to be included later in another procedure. -->
		<xsl:apply-templates select="../../*:COMPLEMENTARY_INFO/(*:NO_RECURRENT_PROCUREMENT|*:RECURRENT_PROCUREMENT)"/>
		<!-- Recurrence Description (BT-95): eForms documentation cardinality (Lot) = ? | Optional for CN subtypes 15-22 and E3, CM subtypes 38-40; Forbidden for other subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Recurrence Description (BT-95)'"/></xsl:call-template>
		<xsl:apply-templates select="../../*:COMPLEMENTARY_INFO/*:ESTIMATED_TIMING"/>
		<!-- Security Clearance Deadline (BT-78): eForms documentation cardinality (Lot) = ? | No equivalent element in TED XML -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Security Clearance Deadline (BT-78)'"/></xsl:call-template>
		<!-- Multiple Tenders (BT-769): eForms documentation cardinality (Lot) = ? | No equivalent element in TED XML -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Multiple Tenders (BT-769)'"/></xsl:call-template>
		<!-- Guarantee Required (BT-751): eForms documentation cardinality (Lot) = ? | Only exists in TED form F05. Optional for PIN subtypes 7-9, CN subtypes 10-22 and E3; Forbidden for other subtypes -->
		<!-- Guarantee Required Description (BT-75): eForms documentation cardinality (Lot) = ? | Only exists in TED form F05. Mandatory for CN subtypes 17, 18, and 22; Optional for PIN subtypes 7-9, CN subtypes 10-16, 19-21, and E3; Forbidden for other subtypes -->
		<xsl:apply-templates select="../../*:LEFTI/*:DEPOSIT_GUARANTEE_REQUIRED"/>
		<!-- Tax legislation information provider No equivalent element in TED XML -->
		<!-- Environment legislation information provider No equivalent element in TED XML -->
		<!-- Employment legislation information provider No equivalent element in TED XML -->
		<!-- Documents Restricted Justification (BT-707): eForms documentation cardinality (Lot) = ? | No equivalent element in TED XML -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Documents Restricted Justification (BT-707)'"/></xsl:call-template>
		<!-- Documents Official Language (BT-708): eForms documentation cardinality (Lot) = ? | No equivalent element in TED XML -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Documents Official Language (BT-708)'"/></xsl:call-template>
		<!-- Documents Unofficial Language (BT-737): eForms documentation cardinality (Lot) = ? | No equivalent element in TED XML -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Documents Unofficial Language (BT-737)'"/></xsl:call-template>
		<!-- Documents Restricted (BT-14), Documents URL (BT-15), Documents Restricted URL (BT-615) -->
		<xsl:apply-templates select="../../*:CONTRACTING_BODY/(*:DOCUMENT_RESTRICTED|*:DOCUMENT_FULL)"/>
		<!-- Terms Financial (BT-77): eForms documentation cardinality (Lot) = ? | Mandatory for CN subtypes 17, 18, 22; Optional for PIN subtypes 7-9, CN subtypes 10-16, 19-21, E3; Forbidden for other subtypes -->
		<xsl:call-template name="terms-financial"/>
		<!-- Reserved Participation (BT-71): eForms documentation cardinality (Lot) = + | Mandatory for PIN subtypes 7-9, CN subtypes 10-22; Optional for PIN subtypes 4-6 and E2, CN subtype E3; Forbidden for other subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Reserved Participation (BT-71)'"/></xsl:call-template>
		<xsl:call-template name="reserved-participation"/>
		<!-- Tenderer Legal Form (BT-761): eForms documentation cardinality (Lot) = ? | Mandatory for CN subtypes 17 and 18; Optional for PIN subtypes 7-9, CN subtypes 10-16, 19-22, and E3, CM subtypes 38-40; Forbidden for other subtypes -->
		<!-- Tenderer Legal Form Description (BT-76): eForms documentation cardinality (Lot) = ? | Optional for PIN subtypes 7-9, CN subtypes 10-22 and E3, CM subtypes 38-40; Forbidden for other subtypes -->
		<xsl:call-template name="tenderer-legal-form"/>
		<!-- Late Tenderer Information (BT-771): eForms documentation cardinality (Lot) = ? | No equivalent element in TED XML -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Late Tenderer Information (BT-771)'"/></xsl:call-template>
		<!-- Subcontracting Tender Indication (BT-651): eForms documentation cardinality (Lot) = + | Only relevant for D81 Defence or OTHER Mandatory for CN subtype 18; Optional for PIN subtype 9, CN subtype E3; Forbidden for other subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Subcontracting Tender Indication (BT-651)'"/></xsl:call-template>
		<!-- Subcontracting Obligation (BT-65): eForms documentation cardinality (Lot) = ? | Only relevant for D81 Defence or OTHER Mandatory for CN subtype 18; Optional for PIN subtype 9, CN subtype E3; Forbidden for other subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Subcontracting Obligation (BT-65)'"/></xsl:call-template>
		<!-- Subcontracting Obligation Maximum (BT-729): eForms documentation cardinality (Lot) = ? | Only relevant for D81 Defence or OTHER Optional for PIN subtype 9, CN subtypes 18 and E3; Forbidden for other subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Subcontracting Obligation Maximum (BT-729)'"/></xsl:call-template>
		<!-- Subcontracting Obligation Minimum (BT-64): eForms documentation cardinality (Lot) = ? | Only relevant for D81 Defence or OTHER Optional for PIN subtype 9, CN subtypes 18 and E3; Forbidden for other subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Subcontracting Obligation Minimum (BT-64)'"/></xsl:call-template>
		<!-- Reserved Execution (BT-736): eForms documentation cardinality (Lot) = ? | Mandatory for PIN subtypes 7-9, CN subtypes 10-22; Optional for PIN subtypes 4-6 and E2, CN subtype E3, CM subtypes 38-40; Forbidden for other subtypes -->
		<xsl:call-template name="reserved-execution"/>
		<!-- Electronic Invoicing (BT-743): eForms documentation cardinality (Lot) = ? | Mandatory for CN subtype 16; Optional for PIN subtypes 7-9, CN subtypes 10-15, 17-22, and E3, CM subtypes 38-40; Forbidden for other subtypes -->
		<xsl:call-template name="e-invoicing"/>
		<!-- Non Disclosure Agreement (BT-801): eForms documentation cardinality (Lot) = ? | No equivalent element in TED XML -->
		<!-- Non Disclosure Agreement Description (BT-802): eForms documentation cardinality (Lot) = ? | No equivalent element in TED XML -->
		<!-- Terms Performance (BT-70): eForms documentation cardinality (Lot) = ? | Mandatory for CN subtypes 17, 18, and 22; Optional for PIN subtypes 7-9, CN subtypes 10-16, 19-21, and E3, CM subtypes 38-40; Forbidden for other subtypes -->
		<xsl:call-template name="terms-performance"/>
		<!-- Submission Electronic Catalog (BT-764): eForms documentation cardinality (Lot) = ? | Mandatory for CN subtypes 16 and 17; Optional for PIN subtypes 7-9, CN subtypes 10-13, 18, 20-22, and E3; Forbidden for other subtypes -->
		<xsl:call-template name="submission-electronic-catalog"/>
		<!-- Submission Electronic Signature (BT-744): eForms documentation cardinality (Lot) = ? | No equivalent element in TED XML -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Submission Electronic Signature (BT-744)'"/></xsl:call-template>
		<xsl:call-template name="awarding-terms"/>
		<!-- Organization providing additional information: eForms documentation cardinality (Lot) = ? -->
		<!-- Organization providing offline access to the procurement documents: eForms documentation cardinality (Lot) = ? | -->
		<xsl:apply-templates select="../../*:CONTRACTING_BODY/(*:ADDRESS_FURTHER_INFO|*:ADDRESS_FURTHER_INFO_IDEM)"/>
		<!-- Organization receiving tenders ​/ Requests to participate: eForms documentation cardinality (Lot) = ? | No equivalent element in TED XML -->
		<!-- Submission URL (BT-18): eForms documentation cardinality (Lot) = ? | Mandatory for PIN subtype E1; Optional for PIN subtypes 7-9, CN subtypes 10-24 and E3; Forbidden for other subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Submission URL (BT-18)'"/></xsl:call-template>
		<!-- Organization processing tenders ​/ Requests to participate: eForms documentation cardinality (Lot) = ? | -->
		<xsl:call-template name="address-participation-url-participation"/>
		<!-- Tender Validity Deadline (BT-98): eForms documentation cardinality (Lot) = ? | Optional for CN subtypes 16, 17, 20, 21, and E3; Forbidden for other subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Tender Validity Deadline (BT-98)'"/></xsl:call-template>
		<xsl:apply-templates select="../../*:PROCEDURE/(*:DATE_TENDER_VALID|*:DURATION_TENDER_VALID)"/>
		<!-- Review Deadline Description (BT-99): eForms documentation cardinality (Lot) = ? | Forbidden for PIN subtypes 1-6, E1, and E2, CN subtype 22; Optional for other subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Review Deadline Description (BT-99)'"/></xsl:call-template>
		<!-- Review organization: eForms documentation cardinality (Lot) = ? | -->
		<!-- Organization providing more information on the time limits for review: eForms documentation cardinality (Lot) = ? | -->
		<!-- Mediation Organization: eForms documentation cardinality (Lot) = ? | -->
		<xsl:call-template name="appeal-terms"/>
		<!-- Submission Language (BT-97): eForms documentation cardinality (Lot) = + | Mandatory for PIN subtypes 7-9, CN subtypes 10-14 and 16-22; Optional for PIN subtype E1, CN subtypes 15, 23, 24, and E3; Forbidden for other subtypes -->
		<xsl:call-template name="submission-language"/>
		<!-- Electronic Ordering (BT-92) and Electronic Payment (BT-93) -->
		<xsl:call-template name="post-award-processing"/>
		<!-- Participant Name (BT-47): eForms documentation cardinality (Lot) = ? | Optional for CN subtypes 23 and 24; Forbidden for other subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Participant Name (BT-47)'"/></xsl:call-template>
		<!-- Security Clearance Code (BT-578): eForms documentation cardinality (Lot) = ? | No equivalent element in TED XML -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Security Clearance Code (BT-578)'"/></xsl:call-template>
		<!-- Security Clearance Description (BT-732): eForms documentation cardinality (Lot) = ? | No equivalent element in TED XML -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Security Clearance Description (BT-732)'"/></xsl:call-template>
	</cac:TenderingTerms>
</xsl:template>

<xsl:template name="selection-criteria-funding-details">
	<!-- template to ensure the BT comments for selection criteria are always output -->
	<!-- In eForms, Selection Criteria are specified at the Lot level. Multiple Selection Criteria each use a separate <efac:SelectionCriteria> element. -->
	<!--            The different types of Selection Criteria are indicated by values from the selection-criterion codelist -->
	<!-- In TED, Selection Criteria are specified by the LEFTI element, at Procedure level. There are no Selection Criteria specified at Lot level. -->
	<!--            The different types of Selection Criteria are indicated by different elements within the LEFTI element -->
	<!-- PARTICULAR_PROFESSION always has @CTYPE set to "SERVICES". It is most often accompanied by REFERENCE_TO_LAW which contains selection requirements for service providers -->
	<!-- There is no eForms BT equivalent to REFERENCE_TO_LAW -->
	<!-- All Notices (except F12) with PARTICULAR_PROFESSION also have <TYPE_CONTRACT CTYPE="SERVICES"/> -->
	<!-- Selection Criteria information is repeatable -->
	<!-- Clarifications requested for documentation of Selection Criteria in TEDEFO-548 -->
	<xsl:variable name="funding-text" select="fn:normalize-space(fn:string-join(*:EU_PROGR_RELATED/*:P, ' '))"/>
	<xsl:choose>
		<xsl:when test="$funding-text ne '' or (../../*:LEFTI/(*:SUITABILITY|*:ECONOMIC_FINANCIAL_INFO|*:ECONOMIC_FINANCIAL_MIN_LEVEL|*:TECHNICAL_PROFESSIONAL_INFO|*:TECHNICAL_PROFESSIONAL_MIN_LEVEL|*:RULES_CRITERIA|*:CRITERIA_SELECTION|*:QUALIFICATION/*:CONDITIONS|*:QUALIFICATION/*:METHODS))">
			<ext:UBLExtensions>
				<ext:UBLExtension>
					<ext:ExtensionContent>
						<efext:EformsExtension>
							<!-- EU Funds Financing Identifier (BT-5010): eForms documentation cardinality (Lot) = ? | Optional for PIN subtypes 7-9 and CN subtypes 10-24; Forbidden for other subtypes -->
							<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'EU Funds Financing Identifier (BT-5010)'"/></xsl:call-template>
							<!-- EU Funds Programme (BT-7220: eForms documentation cardinality (Lot) = ? | Optional for PIN subtypes 7-9 and CN subtypes 10-24; Forbidden for other subtypes -->
							<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'EU Funds Programme (BT-7220)'"/></xsl:call-template>
							<!-- EU Funds Details (BT-6140): eForms documentation cardinality (Lot) = ? | Optional for PIN subtypes 7-9 and CN subtypes 10-24; Forbidden for other subtypes -->
							<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'EU Funds Details (BT-6140)'"/></xsl:call-template>
							<xsl:if test="$funding-text ne ''">
								<efac:Funding>
									<xsl:call-template name="multilingual">
										<xsl:with-param name="contexts" select="*:EU_PROGR_RELATED"/>
										<xsl:with-param name="local" select="'P'"/>
										<xsl:with-param name="element" select="'cbc:Description'"/>
									</xsl:call-template>
								</efac:Funding>
							</xsl:if>
							<xsl:apply-templates select="../../*:LEFTI/(*:SUITABILITY|*:ECONOMIC_FINANCIAL_INFO|*:ECONOMIC_FINANCIAL_MIN_LEVEL|*:TECHNICAL_PROFESSIONAL_INFO|*:TECHNICAL_PROFESSIONAL_MIN_LEVEL|*:RULES_CRITERIA|*:CRITERIA_SELECTION|*:QUALIFICATION/*:CONDITIONS|*:QUALIFICATION/*:METHODS)"/>
							<!-- the empty TED elements ECONOMIC_CRITERIA_DOC and TECHNICAL_CRITERIA_DOC indicate that the economic/technical criteria are described in the procurement documents. -->
							<!-- there are no equivalents in eForms. So these elements cannot be converted -->
							<!-- Selection Criteria Type (BT-747), Selection Criteria Name (BT-749), Selection Criteria Description (BT-750), Selection Criteria Used (BT-748) -->
							<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Selection Criteria Type (BT-747)'"/></xsl:call-template>
							<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Selection Criteria Name (BT-749)'"/></xsl:call-template>
							<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Selection Criteria Description (BT-750)'"/></xsl:call-template>
							<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Selection Criteria Used (BT-748)'"/></xsl:call-template>
							<!-- Second Stage Criteria do not have equivalent elements in TED XML -->
							<!-- Selection Criteria Second Stage Invite (BT-40): eForms documentation cardinality (Lot) = ? | No equivalent element in TED XML -->
							<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Selection Criteria Second Stage Invite (BT-40)'"/></xsl:call-template>
							<!-- Selection Criteria Second Stage Invite Number Weight (BT-7531): eForms documentation cardinality (Lot) = * | No equivalent element in TED XML -->
							<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Selection Criteria Second Stage Invite Number Weight (BT-7531)'"/></xsl:call-template>
							<!-- Selection Criteria Second Stage Invite Number Threshold (BT-7532): eForms documentation cardinality (Lot) = * | No equivalent element in TED XML -->
							<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Selection Criteria Second Stage Invite Number Threshold (BT-7532)'"/></xsl:call-template>
							<!-- Selection Criteria Second Stage Invite Number (BT-752): eForms documentation cardinality (Lot) = * | No equivalent element in TED XML -->
							<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Selection Criteria Second Stage Invite Number (BT-752)'"/></xsl:call-template>
						</efext:EformsExtension>
					</ext:ExtensionContent>
				</ext:UBLExtension>
			</ext:UBLExtensions>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Selection Criteria Type (BT-747)'"/></xsl:call-template>
			<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Selection Criteria Name (BT-749)'"/></xsl:call-template>
			<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Selection Criteria Description (BT-750)'"/></xsl:call-template>
			<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Selection Criteria Used (BT-748)'"/></xsl:call-template>
			<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Selection Criteria Second Stage Invite (BT-40)'"/></xsl:call-template>
			<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Selection Criteria Second Stage Invite Number Weight (BT-7531)'"/></xsl:call-template>
			<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Selection Criteria Second Stage Invite Number Threshold (BT-7532)'"/></xsl:call-template>
			<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Selection Criteria Second Stage Invite Number (BT-752)'"/></xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="*:SUITABILITY|*:ECONOMIC_FINANCIAL_INFO|*:ECONOMIC_FINANCIAL_MIN_LEVEL|*:TECHNICAL_PROFESSIONAL_INFO|*:TECHNICAL_PROFESSIONAL_MIN_LEVEL|*:RULES_CRITERIA|*:CRITERIA_SELECTION|*:QUALIFICATION/*:CONDITIONS|*:QUALIFICATION/*:METHODS">
	<xsl:variable name="text" select="fn:normalize-space(fn:string-join(*:P, ' '))"/>
	<xsl:variable name="element-name" select="fn:local-name(.)"/>
	<xsl:variable name="selection-criterion-type" select="$mappings//selection-criterion-types/mapping[ted-value eq $element-name]/fn:string(eforms-value)"/>
	<xsl:if test="$text ne ''">
		<efac:SelectionCriteria>
			<!-- Selection Criteria Type (BT-747): eForms documentation cardinality (Lot) = ? | Mandatory for PIN subtypes 7-9, CN subtypes 10-24; Optional for CN subtype E3; Forbidden for other subtypes -->
			<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Selection Criteria Type (BT-747)'"/></xsl:call-template>
			<cbc:CriterionTypeCode listName="selection-criterion">
				<xsl:value-of select="$selection-criterion-type"/>
			</cbc:CriterionTypeCode>
			<!-- Selection Criteria Name (BT-749): eForms documentation cardinality (Lot) = ? | Optional for PIN subtypes 7-9, CN subtypes 10-24 and E3; Forbidden for other subtypes -->
			<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Selection Criteria Name (BT-749)'"/></xsl:call-template>
			<!-- Selection Criteria Description (BT-750): eForms documentation cardinality (Lot) = ? -->
			<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Selection Criteria Description (BT-750)'"/></xsl:call-template>
			<xsl:call-template name="multilingual">
				<xsl:with-param name="contexts" select="."/>
				<xsl:with-param name="local" select="'P'"/>
				<xsl:with-param name="element" select="'cbc:Description'"/>
			</xsl:call-template>
			<!-- Selection Criteria Used (BT-748): eForms documentation cardinality (Lot) = ? | Optional for PIN subtypes 7-9, CN subtypes 10-24 and E3; Forbidden for other subtypes -->
			<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Selection Criteria Used (BT-748)'"/></xsl:call-template>
			<cbc:CalculationExpressionCode listName="usage">used</cbc:CalculationExpressionCode>
		</efac:SelectionCriteria>
	</xsl:if>
</xsl:template>

<xsl:template match="*:DEPOSIT_GUARANTEE_REQUIRED">
	<xsl:variable name="text" select="fn:normalize-space(fn:string-join(*:P, ' '))"/>
	<!-- Guarantee Required (BT-751): eForms documentation cardinality (Lot) = ? | Only exists in TED form F05. Optional for PIN subtypes 7-9, CN subtypes 10-22 and E3; Forbidden for other subtypes -->
	<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Guarantee Required (BT-751)'"/></xsl:call-template>
	<!-- Guarantee Required Description (BT-75): eForms documentation cardinality (Lot) = ? | Only exists in TED form F05. Mandatory for CN subtypes 17, 18, and 22; Optional for PIN subtypes 7-9, CN subtypes 10-16, 19-21, and E3; Forbidden for other subtypes -->
	<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Guarantee Required Description (BT-75)'"/></xsl:call-template>
	<xsl:if test="$text ne ''">
		<cac:RequiredFinancialGuarantee>
			<cbc:GuaranteeTypeCode listName="tender-guarantee-required">true</cbc:GuaranteeTypeCode>
			<xsl:call-template name="multilingual">
				<xsl:with-param name="contexts" select="."/>
				<xsl:with-param name="local" select="'P'"/>
				<xsl:with-param name="element" select="'cbc:Description'"/>
			</xsl:call-template>
		</cac:RequiredFinancialGuarantee>
	</xsl:if>
</xsl:template>

<xsl:template match="*:DOCUMENT_RESTRICTED|*:DOCUMENT_FULL">
	<xsl:variable name="element-name" select="fn:local-name(.)"/>
	<cac:CallForTendersDocumentReference>
		<cbc:ID>DOCUMENT_ID_REQUIRED_HERE</cbc:ID>
		<!-- Documents Restricted (BT-14): eForms documentation cardinality (Lot) = ? | Mandatory for CN subtypes 16, 17, 19, 23, and 24; Optional for PIN subtypes 1-9, E1, and E2, CN subtypes 10-15, 18, 20-22, and E3; Forbidden for other subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Documents Restricted (BT-14)'"/></xsl:call-template>
		<xsl:choose>
			<xsl:when test="$element-name eq 'DOCUMENT_RESTRICTED'">
				<cbc:DocumentTypeCode listName="communication-justification">CODE_FOR_RESTRICTED_DOCUMENT_JUSTIFICATION_REQUIRED_HERE</cbc:DocumentTypeCode>
				<cbc:DocumentType>restricted-document</cbc:DocumentType>
			</xsl:when>
			<xsl:otherwise>
				<cbc:DocumentType>non-restricted-document</cbc:DocumentType>
			</xsl:otherwise>
		</xsl:choose>
		<!-- Documents URL (BT-15): eForms documentation cardinality (Lot) = ? | Optional for PIN subtypes 1-9, E1, and E2, CN subtypes 10-24 and E3; Forbidden for other subtypes -->
		<!-- Documents Restricted URL (BT-615): eForms documentation cardinality (Lot) = ? | Optional for PIN subtypes 1-9, E1, and E2, CN subtypes 10-24 and E3; Forbidden for other subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Documents URL (BT-15) or Documents Restricted URL (BT-615)'"/></xsl:call-template>
		<xsl:apply-templates select="following-sibling::*:URL_DOCUMENT"/>
	</cac:CallForTendersDocumentReference>
</xsl:template>

<xsl:template match="*:URL_DOCUMENT">
	<cac:Attachment>
		<cac:ExternalReference>
			<cbc:URI>
				<xsl:value-of select="."/>
			</cbc:URI>
		</cac:ExternalReference>
	</cac:Attachment>
</xsl:template>

<xsl:template name="terms-financial">
	<!-- Terms Financial (BT-77): eForms documentation cardinality (Lot) = ? | Mandatory for CN subtypes 17, 18, 22; Optional for PIN subtypes 7-9, CN subtypes 10-16, 19-21, E3; Forbidden for other subtypes -->
	<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Terms Financial (BT-77)'"/></xsl:call-template>
	<xsl:variable name="text" select="$ted-form-main-element/*:LEFTI/*:MAIN_FINANCING_CONDITION/fn:normalize-space(fn:string-join(*:P, ' '))"/>
	<xsl:choose>
		<xsl:when test="$text ne ''">
			<cac:PaymentTerms>
				<xsl:call-template name="multilingual">
					<xsl:with-param name="contexts" select="$ted-form-main-element/*:LEFTI/*:MAIN_FINANCING_CONDITION"/>
					<xsl:with-param name="local" select="'P'"/>
					<xsl:with-param name="element" select="'cbc:Note'"/>
				</xsl:call-template>
			</cac:PaymentTerms>
		</xsl:when>
		<xsl:when test="$eforms-notice-subtype = ('17', '18', '22')">
			<!-- WARNING: Terms Financial (BT-77) is Mandatory for eForms subtypes 17, 18 and 22, but no MAIN_FINANCING_CONDITION was found in TED XML. -->
			<xsl:variable name="message">WARNING: Terms Financial (BT-77) is Mandatory for eForms subtypes 17, 18 and 22, but no MAIN_FINANCING_CONDITION was found in TED XML.</xsl:variable>
			<xsl:call-template name="report-warning"><xsl:with-param name="message" select="$message"/></xsl:call-template>
			<cac:PaymentTerms>
				<cbc:Note languageID="{$eforms-first-language}"></cbc:Note>
			</cac:PaymentTerms>
		</xsl:when>
	</xsl:choose>
</xsl:template>

<xsl:template name="tenderer-legal-form">
	<xsl:variable name="text" select="$ted-form-main-element/*:LEFTI/*:LEGAL_FORM/fn:normalize-space(fn:string-join(*:P, ' '))"/>
	<!-- Tenderer Legal Form (BT-761): eForms documentation cardinality (Lot) = ? | Mandatory for CN subtypes 17 and 18; Optional for PIN subtypes 7-9, CN subtypes 10-16, 19-22, and E3, CM subtypes 38-40; Forbidden for other subtypes -->
	<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Tenderer Legal Form (BT-761)'"/></xsl:call-template>
	<!-- Tenderer Legal Form Description (BT-76): eForms documentation cardinality (Lot) = ? | Optional for PIN subtypes 7-9, CN subtypes 10-22 and E3, CM subtypes 38-40; Forbidden for other subtypes -->
	<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Tenderer Legal Form Description (BT-76)'"/></xsl:call-template>
	<xsl:choose>
		<xsl:when test="$text ne ''">
			<cac:TendererQualificationRequest>
				<cbc:CompanyLegalFormCode listName="required">true</cbc:CompanyLegalFormCode>
				<xsl:call-template name="multilingual">
					<xsl:with-param name="contexts" select="$ted-form-main-element/*:LEFTI/*:LEGAL_FORM"/>
					<xsl:with-param name="local" select="'P'"/>
					<xsl:with-param name="element" select="'cbc:CompanyLegalForm'"/>
				</xsl:call-template>
			</cac:TendererQualificationRequest>
		</xsl:when>
		<xsl:when test="$eforms-notice-subtype = ('17', '18', '22')">
			<cac:TendererQualificationRequest>
				<cbc:CompanyLegalFormCode listName="required">false</cbc:CompanyLegalFormCode>
			</cac:TendererQualificationRequest>
		</xsl:when>
	</xsl:choose>
</xsl:template>

<xsl:template name="reserved-participation">
	<!-- Reserved Participation (BT-71): eForms documentation cardinality (Lot) = + | Mandatory for PIN subtypes 7-9, CN subtypes 10-22; Optional for PIN subtypes 4-6 and E2, CN subtype E3; Forbidden for other subtypes -->
	<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Reserved Participation (BT-71)'"/></xsl:call-template>
	<!-- reserved-procurement code res-pub-ser is RESERVED_ORGANISATIONS_SERVICE_MISSION in TED XML, used only in F21 -->
	<xsl:if test="$eforms-notice-subtype = ('7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22') or $ted-form-main-element/*:LEFTI/(*:RESTRICTED_SHELTERED_WORKSHOP|*:RESERVED_ORGANISATIONS_SERVICE_MISSION)">
		<cac:TendererQualificationRequest>
			<xsl:choose>
				<xsl:when test="fn:boolean($ted-form-main-element/*:LEFTI/(*:RESTRICTED_SHELTERED_WORKSHOP|*:RESERVED_ORGANISATIONS_SERVICE_MISSION))">
					<xsl:apply-templates select="$ted-form-main-element/*:LEFTI/(*:RESTRICTED_SHELTERED_WORKSHOP|*:RESERVED_ORGANISATIONS_SERVICE_MISSION)"/>
				</xsl:when>
				<xsl:otherwise>
					<cac:SpecificTendererRequirement>
						<cbc:TendererRequirementTypeCode listName="reserved-procurement">none</cbc:TendererRequirementTypeCode>
					</cac:SpecificTendererRequirement>
				</xsl:otherwise>
			</xsl:choose>
		</cac:TendererQualificationRequest>
	</xsl:if>
</xsl:template>

<xsl:template match="*:RESTRICTED_SHELTERED_WORKSHOP">
	<cac:SpecificTendererRequirement>
		<cbc:TendererRequirementTypeCode listName="reserved-procurement">res-ws</cbc:TendererRequirementTypeCode>
	</cac:SpecificTendererRequirement>
</xsl:template>

<xsl:template match="*:RESERVED_ORGANISATIONS_SERVICE_MISSION">
	<cac:SpecificTendererRequirement>
		<cbc:TendererRequirementTypeCode listName="reserved-procurement">res-pub-ser</cbc:TendererRequirementTypeCode>
	</cac:SpecificTendererRequirement>
</xsl:template>

<xsl:template name="reserved-execution">
	<!-- Reserved Execution (BT-736): eForms documentation cardinality (Lot) = ? | Mandatory for PIN subtypes 7-9, CN subtypes 10-22; Optional for PIN subtypes 4-6 and E2, CN subtype E3, CM subtypes 38-40; Forbidden for other subtypes -->
	<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Reserved Execution (BT-736)'"/></xsl:call-template>
	<xsl:if test="$eforms-notice-subtype = ('7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22') or $ted-form-main-element/*:LEFTI/(*:RESTRICTED_SHELTERED_PROGRAM|*:PARTICULAR_PROFESSION)">
		<xsl:variable name="is-reserved-execution">
			<xsl:choose>
				<xsl:when test="fn:boolean($ted-form-main-element/*:LEFTI/(*:RESTRICTED_SHELTERED_PROGRAM|*:PARTICULAR_PROFESSION))">yes</xsl:when>
				<xsl:otherwise>no</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<cac:ContractExecutionRequirement>
			<cbc:ExecutionRequirementCode listName="reserved-execution">
				<xsl:value-of select="$is-reserved-execution"/>
			</cbc:ExecutionRequirementCode>
		</cac:ContractExecutionRequirement>
	</xsl:if>
</xsl:template>

<xsl:template name="e-invoicing">
	<!-- Electronic Invoicing (BT-743): eForms documentation cardinality (Lot) = ? | Mandatory for CN subtype 16; Optional for PIN subtypes 7-9, CN subtypes 10-15, 17-22, and E3, CM subtypes 38-40; Forbidden for other subtypes -->
	<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Electronic Invoicing (BT-743)'"/></xsl:call-template>
	<xsl:choose>
		<xsl:when test="$ted-form-main-element/*:COMPLEMENTARY_INFO/*:EINVOICING">
			<cac:ContractExecutionRequirement>
				<cbc:ExecutionRequirementCode listName="einvoicing">
					<xsl:text>allowed</xsl:text>
				</cbc:ExecutionRequirementCode>
			</cac:ContractExecutionRequirement>
		</xsl:when>
		<xsl:when test="$eforms-notice-subtype = ('16')">
			<cac:ContractExecutionRequirement>
				<cbc:ExecutionRequirementCode listName="einvoicing">
					<xsl:text>not-allowed</xsl:text>
				</cbc:ExecutionRequirementCode>
			</cac:ContractExecutionRequirement>
		</xsl:when>
	</xsl:choose>
</xsl:template>

<xsl:template name="terms-performance">
	<!-- Terms Performance (BT-70): eForms documentation cardinality (Lot) = ? | Mandatory for CN subtypes 17, 18, and 22; Optional for PIN subtypes 7-9, CN subtypes 10-16, 19-21, and E3, CM subtypes 38-40; Forbidden for other subtypes -->
	<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Terms Performance (BT-70)'"/></xsl:call-template>
	<xsl:variable name="text" select="fn:normalize-space(fn:string-join($ted-form-main-element/*:LEFTI/*:PERFORMANCE_CONDITIONS/*:P, ' '))"/>
	<xsl:choose>
		<xsl:when test="$text ne ''">
			<cac:ContractExecutionRequirement>
				<cbc:ExecutionRequirementCode listName="conditions">performance</cbc:ExecutionRequirementCode>
				<xsl:call-template name="multilingual">
					<xsl:with-param name="contexts" select="$ted-form-main-element/*:LEFTI/*:PERFORMANCE_CONDITIONS"/>
					<xsl:with-param name="local" select="'P'"/>
					<xsl:with-param name="element" select="'cbc:Description'"/>
				</xsl:call-template>
			</cac:ContractExecutionRequirement>
		</xsl:when>
		<xsl:when test="$eforms-notice-subtype = ('17', '18', '22')">
			<!-- WARNING: Terms Performance (BT-70) is Mandatory for eForms subtypes 17, 18 and 22, but no PERFORMANCE_CONDITIONS was found in TED XML. -->
			<xsl:variable name="message">WARNING: Terms Performance (BT-70) is Mandatory for eForms subtypes 17, 18 and 22, but no PERFORMANCE_CONDITIONS was found in TED XML.</xsl:variable>
			<xsl:call-template name="report-warning"><xsl:with-param name="message" select="$message"/></xsl:call-template>
			<cac:ContractExecutionRequirement>
				<cbc:ExecutionRequirementCode listName="conditions">performance</cbc:ExecutionRequirementCode>
				<cbc:Description languageID="{$eforms-first-language}"></cbc:Description>
			</cac:ContractExecutionRequirement>
		</xsl:when>
	</xsl:choose>
</xsl:template>

<xsl:template name="submission-electronic-catalog">
	<!-- Submission Electronic Catalog (BT-764): eForms documentation cardinality (Lot) = ? | Mandatory for CN subtypes 16 and 17; Optional for PIN subtypes 7-9, CN subtypes 10-13, 18, 20-22, and E3; Forbidden for other subtypes -->
	<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Submission Electronic Catalog (BT-764)'"/></xsl:call-template>
	<xsl:choose>
		<xsl:when test="*:ECATALOGUE_REQUIRED">
			<cac:ContractExecutionRequirement>
				<cbc:ExecutionRequirementCode listName="ecatalog-submission">
					<xsl:text>allowed</xsl:text>
				</cbc:ExecutionRequirementCode>
			</cac:ContractExecutionRequirement>
		</xsl:when>
		<xsl:when test="$eforms-notice-subtype = ('16','17', '18', '22')">
			<!-- WARNING: Submission Electronic Catalog (BT-764) is Mandatory for eForms subtypes 16, 17, 18 and 22, but no ECATALOGUE_REQUIRED was found in TED XML. -->
			<xsl:variable name="message">WARNING: Submission Electronic Catalog (BT-764) is Mandatory for eForms subtypes 16, 17, 18 and 22, but no ECATALOGUE_REQUIRED was found in TED XML.</xsl:variable>
			<xsl:call-template name="report-warning"><xsl:with-param name="message" select="$message"/></xsl:call-template>
			<cac:ContractExecutionRequirement>
				<cbc:ExecutionRequirementCode listName="ecatalog-submission"></cbc:ExecutionRequirementCode>
			</cac:ContractExecutionRequirement>
		</xsl:when>
	</xsl:choose>
</xsl:template>

<xsl:template name="address-participation-url-participation">
	<xsl:if test="../../*:CONTRACTING_BODY/(*:ADDRESS_PARTICIPATION|*:ADDRESS_PARTICIPATION_IDEM|*:URL_PARTICIPATION)">
		<cac:TenderRecipientParty>
			<xsl:apply-templates select="../../*:CONTRACTING_BODY/*:URL_PARTICIPATION"/>
			<xsl:apply-templates select="../../*:CONTRACTING_BODY/(*:ADDRESS_PARTICIPATION|*:ADDRESS_PARTICIPATION_IDEM)"/>
		</cac:TenderRecipientParty>
	</xsl:if>
</xsl:template>

<xsl:template match="*:DATE_TENDER_VALID">
	<!-- Calculate an integer value of days from DATE_TENDER_VALID minus DATE_RECEIPT_TENDERS -->
	<xsl:variable name="date-receipt-tenders" select="xs:date(../*:DATE_RECEIPT_TENDERS)"/>
	<xsl:variable name="date-tender-valid" select="xs:date(.)"/>
	<xsl:variable name="days" select="($date-tender-valid - $date-receipt-tenders) div xs:dayTimeDuration('P1D')"/>
	<cac:TenderValidityPeriod>
		<cbc:DurationMeasure unitCode="DAY">
			<xsl:value-of select="$days"/>
		</cbc:DurationMeasure>
	</cac:TenderValidityPeriod>
</xsl:template>

<xsl:template match="*:DURATION_TENDER_VALID">
	<!-- Duration in months (from the date stated for receipt of tender) -->
	<!-- TYPE attribute is FIXED to "MONTH" -->
	<cac:TenderValidityPeriod>
		<cbc:DurationMeasure unitCode="MONTH">
			<xsl:value-of select="fn:number(.)"/>
		</cbc:DurationMeasure>
	</cac:TenderValidityPeriod>
</xsl:template>

<xsl:template name="appeal-terms">
	<xsl:variable name="bt-99-text" select="../../*:COMPLEMENTARY_INFO/*:REVIEW_PROCEDURE/fn:normalize-space(fn:string-join(*:P, ' '))"/>
	<!-- Review Deadline Description (BT-99): eForms documentation cardinality (Lot) = ? | Forbidden for PIN subtypes 1-6, E1, and E2, CN subtype 22; Optional for other subtypes -->
	<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Review Deadline Description (BT-99)'"/></xsl:call-template>
	<!-- Review Information Providing Organization -->
	<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Review Information Providing Organization'"/></xsl:call-template>
	<!-- Review organization -->
	<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Review organization'"/></xsl:call-template>
	<!-- Mediation organization -->
	<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Mediation organization'"/></xsl:call-template>
	<xsl:if test="$bt-99-text or ../../*:COMPLEMENTARY_INFO/(*:ADDRESS_REVIEW_INFO|*:ADDRESS_REVIEW_BODY|*:ADDRESS_MEDIATION_BODY)">
		<cac:AppealTerms>
			<xsl:apply-templates select="../../*:COMPLEMENTARY_INFO/*:REVIEW_PROCEDURE"/>
			<xsl:apply-templates select="../../*:COMPLEMENTARY_INFO/*:ADDRESS_REVIEW_INFO"/>
			<xsl:apply-templates select="../../*:COMPLEMENTARY_INFO/*:ADDRESS_REVIEW_BODY"/>
			<xsl:apply-templates select="../../*:COMPLEMENTARY_INFO/*:ADDRESS_MEDIATION_BODY"/>
		</cac:AppealTerms>
	</xsl:if>
</xsl:template>

<xsl:template match="*:REVIEW_PROCEDURE">
	<xsl:variable name="text" select="fn:normalize-space(fn:string-join(*:P, ' '))"/>
	<xsl:if test="$text ne ''">
		<cac:PresentationPeriod>
			<xsl:call-template name="multilingual">
				<xsl:with-param name="contexts" select="."/>
				<xsl:with-param name="local" select="'P'"/>
				<xsl:with-param name="element" select="'cbc:Description'"/>
			</xsl:call-template>
		</cac:PresentationPeriod>
	</xsl:if>
</xsl:template>

<xsl:template name="submission-language">
	<!-- Submission Language (BT-97): eForms documentation cardinality (Lot) = + | Mandatory for PIN subtypes 7-9, CN subtypes 10-14 and 16-22; Optional for PIN subtype E1, CN subtypes 15, 23, 24, and E3; Forbidden for other subtypes -->
	<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Submission Language (BT-97)'"/></xsl:call-template>
	<xsl:choose>
		<xsl:when test="../../*:PROCEDURE/*:LANGUAGES/*:LANGUAGE">
			<xsl:apply-templates select="../../*:PROCEDURE/*:LANGUAGES/*:LANGUAGE"/>
		</xsl:when>
		<xsl:when test="($eforms-notice-subtype = ('7','8','9','10','11','12','13','14','16','17','18','19','20','21','22'))">
			<!-- WARNING: Submission Language (BT-97) is Mandatory for eForms subtype 7, 8, 9, 10, 11, 12, 13, 14, 16, 17, 18, 19, 20, 21, 22, but no LANGUAGE was found in TED XML. In order to obtain valid XML for this notice, ENG is used. -->
			<xsl:variable name="message">WARNING: Submission Language (BT-97) is Mandatory for eForms subtype 7, 8, 9, 10, 11, 12, 13, 14, 16, 17, 18, 19, 20, 21, 22, but no LANGUAGE was found in TED XML. In order to obtain valid XML for this notice, ENG is used.</xsl:variable>
			<xsl:call-template name="report-warning"><xsl:with-param name="message" select="$message"/></xsl:call-template>
			<cac:Language>
				<cbc:ID>
					<xsl:text>ENG</xsl:text>
				</cbc:ID>
			</cac:Language>
		</xsl:when>
	</xsl:choose>
</xsl:template>

<xsl:template match="*:LANGUAGE">
	<xsl:variable name="lang" select="opfun:get-eforms-language(@VALUE)"/>
	<cac:Language>
		<cbc:ID>
			<xsl:value-of select="$lang"/>
		</cbc:ID>
	</cac:Language>
</xsl:template>

<xsl:template name="post-award-processing">
	<xsl:if test="../../*:COMPLEMENTARY_INFO/(*:EORDERING|*:EPAYMENT) or $eforms-notice-subtype eq '16'">
		<cac:PostAwardProcess>
			<!-- Electronic Ordering (BT-92): eForms documentation cardinality (Lot) = ? | Mandatory for CN subtype 16; Optional for PIN subtypes 7-9, CN subtypes 10-15, 17-22, and E3, CM subtypes 38-40; Forbidden for other subtypes -->
			<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Electronic Ordering (BT-92)'"/></xsl:call-template>
			<xsl:choose>
				<xsl:when test="../../*:COMPLEMENTARY_INFO/*:EORDERING">
					<cbc:ElectronicOrderUsageIndicator>true</cbc:ElectronicOrderUsageIndicator>
				</xsl:when>
				<xsl:when test="$eforms-notice-subtype eq '16'">
					<cbc:ElectronicOrderUsageIndicator>false</cbc:ElectronicOrderUsageIndicator>
				</xsl:when>
			</xsl:choose>
			<!-- Electronic Payment (BT-93): eForms documentation cardinality (Lot) = ? | Mandatory for CN subtype 16; Optional for PIN subtypes 7-9, CN subtypes 10-15, 17-22, and E3, CM subtypes 38-40; Forbidden for other subtypes -->
			<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Electronic Payment (BT-93)'"/></xsl:call-template>
			<xsl:choose>
				<xsl:when test="../../*:COMPLEMENTARY_INFO/*:EPAYMENT">
					<cbc:ElectronicPaymentUsageIndicator>true</cbc:ElectronicPaymentUsageIndicator>
				</xsl:when>
				<xsl:when test="$eforms-notice-subtype eq '16'">
					<cbc:ElectronicPaymentUsageIndicator>false</cbc:ElectronicPaymentUsageIndicator>
				</xsl:when>
			</xsl:choose>
		</cac:PostAwardProcess>
	</xsl:if>
</xsl:template>


<!-- end of Lot Tendering Terms templates -->



<!-- Lot Tendering Process templates -->

<xsl:template name="lot-tendering-process">
	<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="' cac:TenderingProcess '"/></xsl:call-template>
	<cac:TenderingProcess>
		<ext:UBLExtensions>
			<ext:UBLExtension>
				<ext:ExtensionContent>
					<efext:EformsExtension>
						<!-- TBD: review after meeting on BT-634 and email from GROW -->
						<!-- Procurement Relaunch (BT-634): eForms documentation cardinality (Lot) = ? | Optional for CN subtypes 10-24 and E3, CAN subtypes 29-37 and E4; Forbidden for other subtypes -->
						<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Procurement Relaunch (BT-634)'"/></xsl:call-template>
						<!-- Tool Name (BT-632): eForms documentation cardinality (Lot) = ? | No equivalent element in TED XML -->
						<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Tool Name (BT-632)'"/></xsl:call-template>
						<!-- Deadline Receipt Expressions (BT-630): eForms documentation cardinality (Lot) = ? | Mandatory for CN subtypes 10-14; Optional for CN subtypes 20 and 21; Forbidden for other subtypes -->
						<!-- Note: TED DATE_RECEIPT_TENDERS and TIME_RECEIPT_TENDERS map to either Deadline Receipt Expressions (BT-630) or Deadline Receipt Tenders (BT-131) depending on the Notice subtype -->
						<xsl:call-template name="date-time-receipt-expressions"/>
					</efext:EformsExtension>
				</ext:ExtensionContent>
			</ext:UBLExtension>
		</ext:UBLExtensions>
		<!-- SubmissionElectronic (BT-17): eForms documentation cardinality (Lot) = ? | Mandatory for CN subtypes 10, 11, 15-17, 23, and 24; Optional for PIN subtypes 7-9, CN subtypes 12-14, 18-22, and E3; Forbidden for other subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'SubmissionElectronic (BT-17)'"/></xsl:call-template>
		<!-- NB TED does not cater for the meaning of the value "Required" from the permission codelist in this context -->
		<xsl:variable name="electronic-submission">
			<xsl:choose>
				<xsl:when test="../../*:CONTRACTING_BODY/*:URL_PARTICIPATION">
					<xsl:text>allowed</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>not-allowed</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<cbc:SubmissionMethodCode listName="esubmission">
			<xsl:value-of select="$electronic-submission"/>
		</cbc:SubmissionMethodCode>
		<!-- Successive Reduction (BT-52): eForms documentation cardinality (Lot) = ? | Mandatory for CN subtype 16; Optional for PIN subtypes 7-9, CN subtypes 10-14, 17, 18, 20-24, and E3; Forbidden for other subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Successive Reduction Indicator (Procedure) (BT-52)'"/></xsl:call-template>
		<xsl:if test="../../*:PROCEDURE/*:REDUCTION_RECOURSE or $eforms-notice-subtype = '16'">
			<cbc:CandidateReductionConstraintIndicator>
				<xsl:value-of select="if (fn:exists(../../*:PROCEDURE/*:REDUCTION_RECOURSE)) then 'true' else 'false'"/>
			</cbc:CandidateReductionConstraintIndicator>
		</xsl:if>
		<!-- GPA Coverage (BT-115): eForms documentation cardinality (Lot) = ? | Mandatory for PIN subtypes 7 and 8, CN subtypes 10, 11, and 15-17, CAN subtypes 25, 26, 29, and 30; Optional for PIN subtypes 4 and 5, CN subtype 19, CAN subtypes 28 and 32, CM subtypes 38-40; Forbidden for other subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'GPA Coverage (BT-115)'"/></xsl:call-template>
		<xsl:apply-templates select="../../*:PROCEDURE/(*:CONTRACT_COVERED_GPA|*:NO_CONTRACT_COVERED_GPA)"/>
		<!-- Tool Atypical URL (BT-124): eForms documentation cardinality (Lot) = ? | Optional for PIN subtypes 1-9, E1, and E2, CN subtypes 10-24 and E3; Forbidden for other subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Tool Atypical URL (BT-124)'"/></xsl:call-template>
		<xsl:apply-templates select="../../*:CONTRACTING_BODY/*:URL_TOOL"/>
		<!-- Deadline Receipt Tenders (BT-131): eForms documentation cardinality (Lot) = ? | Mandatory for PIN subtype 8; Optional for PIN subtypes 7 and 9, CN subtypes 16-24 and E3; Forbidden for other subtypes -->
		<!-- Note: TED DATE_RECEIPT_TENDERS and TIME_RECEIPT_TENDERS map to either Deadline Receipt Expressions (BT-630) or Deadline Receipt Tenders (BT-131) depending on the Notice subtype -->
		<!-- TBD: Question: For Notice Subtypes 20 and 21, BOTH Deadline Receipt Expressions (BT-630) AND Deadline Receipt Tenders (BT-131) map from TED DATE_RECEIPT_TENDERS and TIME_RECEIPT_TENDERS - What should we do? -->
		<xsl:call-template name="date-time-receipt-tenders"/>
		<!-- Dispatch Invitation Tender (BT-130): eForms documentation cardinality (Lot) = ? | Optional for PIN subtypes 7-9, CN subtypes 10-14, 16-24, and E3; Forbidden for other subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Dispatch Invitation Tender (BT-130)'"/></xsl:call-template>
		<xsl:apply-templates select="../../*:PROCEDURE/*:DATE_DISPATCH_INVITATIONS"/>
		<!-- Deadline Receipt Requests (BT-1311): eForms documentation cardinality (Lot) = ? | Optional for PIN subtypes 7 and 9, CN subtypes 16-24 and E3; Forbidden for other subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Deadline Receipt Requests (BT-1311)'"/></xsl:call-template>
		<!-- Additional Information Deadline (BT-13): eForms documentation cardinality (Lot) = ? | No equivalent element in TED XML -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Additional Information Deadline (BT-13)'"/></xsl:call-template>
		<!-- Previous Planning Identifier (BT-125): eForms documentation cardinality (Lot) = ? | Forbidden for PIN subtypes 1-3 and E1, CM subtypes 38-40 and E5; Optional for other subtypes -->
		<!-- NOTICE_NUMBER_OJ maps to BT-125 only for Competition notices; for other notices, it maps to OPP-090 -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Previous Planning Identifier (BT-125)'"/></xsl:call-template>
		<xsl:if test="$eforms-form-type = 'competition'">
			<xsl:apply-templates select="../../*:PROCEDURE/*:NOTICE_NUMBER_OJ"/>
		</xsl:if>
		<!-- Submission Nonelectronic Justification (BT-19): eForms documentation cardinality (Lot) = ? | No equivalent element in TED XML -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Submission Nonelectronic Justification (BT-19)'"/></xsl:call-template>
		<!-- Submission Nonelectronic Description (BT-745): eForms documentation cardinality (Lot) = ? | No equivalent element in TED XML -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Submission Nonelectronic Description (BT-745)'"/></xsl:call-template>
		<!-- Maximum Candidates Indicator (BT-661): eForms documentation cardinality (Lot) = ? | Mandatory for CN subtype 16; Optional for PIN subtypes 7-9, CN subtypes 10-14, 17, 18, 20-24, and E3; Forbidden for other subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Maximum Candidates Indicator (BT-661)'"/></xsl:call-template>
		<!-- Maximum Candidates (BT-51): eForms documentation cardinality (Lot) = ? | Optional for PIN subtypes 7-9, CN subtypes 10-14, 16-18, 20-24, and E3; Forbidden for other subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Maximum Candidates (BT-51)'"/></xsl:call-template>
		<!-- Minimum Candidates (BT-50): eForms documentation cardinality (Lot) = ? | Mandatory for CN subtype 16; Optional for PIN subtypes 7-9, CN subtypes 10-14, 17, 18, 20-24, and E3; Forbidden for other subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Minimum Candidates (BT-50)'"/></xsl:call-template>
		<xsl:call-template name="limit-candidate"/>
		<!-- Public Opening Date (BT-132): eForms documentation cardinality (Lot) = ? | Optional for CN subtypes 16, 17, 20, 21, and E3; Forbidden for other subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Public Opening Date (BT-132)'"/></xsl:call-template>
		<!-- Public Opening Description (BT-134): eForms documentation cardinality (Lot) = ? | Optional for CN subtypes 16, 17, 20, 21, and E3; Forbidden for other subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Public Opening Description (BT-134)'"/></xsl:call-template>
		<!-- Public Opening Place (BT-133): eForms documentation cardinality (Lot) = ? | Optional for CN subtypes 16, 17, 20, 21, and E3; Forbidden for other subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Public Opening Place (BT-133)'"/></xsl:call-template>
		<xsl:apply-templates select="../../*:PROCEDURE/*:OPENING_CONDITION"/>
		<!-- Electronic Auction (BT-767): eForms documentation cardinality (Lot) = ? | Mandatory for CN subtypes 16-18 and 22, CAN subtypes 29-31; Optional for PIN subtypes 7-9, CN subtypes 10-14, 19-21, and E3, CAN subtypes 32-35 and E4, CM subtype E5; Forbidden for other subtypes -->
		<!-- Electronic Auction Description (BT-122): eForms documentation cardinality (Lot) = ? | Optional for PIN subtypes 7-9, CN subtypes 10-14, 16-22, and E3; Forbidden for other subtypes -->
		<!-- Electronic Auction URL (BT-123): eForms documentation cardinality (Lot) = ? | Optional for PIN subtypes 7-9, CN subtypes 10-14, 16-22, and E3; Forbidden for other subtypes -->
		<xsl:call-template name="eauction-used"/>
		<!-- Framework Maximum Participants Number (BT-113): eForms documentation cardinality (Lot) = ? | Optional for PIN subtypes 7-9, CN subtypes 10-13, 16-18, 20-22, and E3; Forbidden for other subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Framework Maximum Participants Number (BT-113)'"/></xsl:call-template>
		<!-- Framework Duration Justification (BT-109): eForms documentation cardinality (Lot) = ? | Optional for PIN subtypes 7-9, CN subtypes 10-13, 16-18, 20-22, and E3; Forbidden for other subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Framework Duration Justification (BT-109)'"/></xsl:call-template>
		<!-- Group Framework Maximum Value (BT-157) ? No equivalent element in TED XML -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Group Framework Maximum Value (BT-157)'"/></xsl:call-template>
		<!-- Framework Buyer Categories (BT-111): eForms documentation cardinality (Lot) = ? | No equivalent element in TED XML -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Framework Buyer Categories (BT-111)'"/></xsl:call-template>
		<!-- Framework Agreement (BT-765): eForms documentation cardinality (Lot) = ? | Mandatory for PIN subtypes 7-9, CN subtypes 10, 11, 16-18, and 22, CAN subtypes 29-31; Optional for PIN subtypes 4-6 and E2, CN subtypes 12, 13, 20, 21, and E3, CAN subtypes 25-27, 33, 34, and E4, CM subtype E5; Forbidden for other subtypes -->
		<!-- Framework Agreement (BT-765), Framework Maximum Participants Number (BT-113), Framework Duration Justification (BT-109) -->
		<xsl:call-template name="framework-agreement"/>
		<!-- Dynamic Purchasing System (BT-766): eForms documentation cardinality (Lot) = ? | Mandatory for PIN subtypes 7 and 8, CN subtypes 10, 11, 16, and 17, CAN subtypes 29 and 30; Optional for CN subtypes 12, 13, 20-22, and E3, CAN subtypes 25-27, 33, 34, and E4, CM subtype E5; Forbidden for other subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Dynamic Purchasing System (BT-766)'"/></xsl:call-template>
		<xsl:call-template name="dps"/>
	</cac:TenderingProcess>
</xsl:template>

<xsl:template match="*:CONTRACT_COVERED_GPA">
	<cbc:GovernmentAgreementConstraintIndicator>true</cbc:GovernmentAgreementConstraintIndicator>
</xsl:template>

<xsl:template match="*:NO_CONTRACT_COVERED_GPA">
	<cbc:GovernmentAgreementConstraintIndicator>false</cbc:GovernmentAgreementConstraintIndicator>
</xsl:template>

<xsl:template name="date-time-receipt-expressions">
	<!-- Deadline Receipt Expressions (BT-630): eForms documentation cardinality (Lot) = ? | Mandatory for CN subtypes 10-14; Optional for CN subtypes 20 and 21; Forbidden for other subtypes -->
	<!-- Note: TED DATE_RECEIPT_TENDERS and TIME_RECEIPT_TENDERS map to either Deadline Receipt Expressions (BT-630) or Deadline Receipt Tenders (BT-131) depending on the Notice subtype -->
	<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Deadline Receipt Expressions (BT-630)'"/></xsl:call-template>
	<xsl:choose>
		<xsl:when test="(../../*:PROCEDURE/*:DATE_RECEIPT_TENDERS)">
			<efac:InterestExpressionReceptionPeriod>
				<xsl:call-template name="date-time-receipt-common"/>
			</efac:InterestExpressionReceptionPeriod>
		</xsl:when>
		<xsl:when test="($eforms-notice-subtype = ('10', '11', '12', '13', '14'))">
			<!-- WARNING: Deadline Receipt Expressions (BT-630) is Mandatory for eForms subtypes 10, 11, 12, 13 and 14, but no DATE_RECEIPT_TENDERS was found in TED XML. In order to obtain valid XML for this notice, a far future date was used (2099-01-01+01:00). -->
			<xsl:variable name="message">WARNING: Deadline Receipt Expressions (BT-630) is Mandatory for eForms subtypes 10, 11, 12, 13 and 14, but no DATE_RECEIPT_TENDERS was found in TED XML. In order to obtain valid XML for this notice, a far future date was used (2099-01-01+01:00).</xsl:variable>
			<xsl:call-template name="report-warning"><xsl:with-param name="message" select="$message"/></xsl:call-template>
			<efac:InterestExpressionReceptionPeriod>
				<cbc:EndDate>2099-01-01+01:00</cbc:EndDate>
				<cbc:EndTime>11:59:59+01:00</cbc:EndTime>
			</efac:InterestExpressionReceptionPeriod>
		</xsl:when>
	</xsl:choose>
</xsl:template>

<xsl:template name="date-time-receipt-tenders">
	<!-- Deadline Receipt Tenders (BT-131): eForms documentation cardinality (Lot) = ? | Mandatory for PIN subtype 8; Optional for PIN subtypes 7 and 9, CN subtypes 16-24 and E3; Forbidden for other subtypes -->
	<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Deadline Receipt Tenders (BT-131)'"/></xsl:call-template>
	<!-- Note: TED DATE_RECEIPT_TENDERS and TIME_RECEIPT_TENDERS map to either Deadline Receipt Expressions (BT-630) or Deadline Receipt Tenders (BT-131) depending on the Notice subtype -->
	<!-- TBD: Question: For Notice Subtypes 20 and 21, BOTH Deadline Receipt Expressions (BT-630) AND Deadline Receipt Tenders (BT-131) map from TED DATE_RECEIPT_TENDERS and TIME_RECEIPT_TENDERS - What should we do? -->
	<xsl:choose>
		<xsl:when test="(../../*:PROCEDURE/*:DATE_RECEIPT_TENDERS)">
			<cac:TenderSubmissionDeadlinePeriod>
				<xsl:call-template name="date-time-receipt-common"/>
			</cac:TenderSubmissionDeadlinePeriod>
		</xsl:when>
		<xsl:when test="($eforms-notice-subtype = ('8'))">
			<!-- WARNING: Deadline Receipt Tenders (BT-131) is Mandatory for eForms notice subtype 8, but no DATE_RECEIPT_TENDERS was found in TED XML. In order to obtain valid XML for this notice, a far future date was used (2099-01-01+01:00). -->
			<xsl:variable name="message">WARNING: Deadline Receipt Tenders (BT-131) is Mandatory for eForms subtype 8, but no DATE_RECEIPT_TENDERS was found in TED XML. In order to obtain valid XML for this notice, a far future date was used (2099-01-01+01:00).</xsl:variable>
			<xsl:call-template name="report-warning"><xsl:with-param name="message" select="$message"/></xsl:call-template>
			<cac:TenderSubmissionDeadlinePeriod>
				<cbc:EndDate>2099-01-01+01:00</cbc:EndDate>
				<cbc:EndTime>11:59:59+01:00</cbc:EndTime>
			</cac:TenderSubmissionDeadlinePeriod>
		</xsl:when>
	</xsl:choose>
</xsl:template>

<xsl:template name="date-time-receipt-common">
	<!-- NOTE: cbc:EndDate and cbc:EndTime should contain ISO-8601 format dates, i.e. expressed as UTC with offsets. -->
	<!-- TED date elements have no time zone associated, and TED time elements have "local time". -->
	<!-- Therefore for complete accuracy, a mapping of country codes to UTC timezone offsets would be required -->
	<!-- In this initial conversion, no such mapping is used, and TED dates and times are assumed to be CET, i.e. UTC+01:00 -->
	<!-- If TIME_RECEIPT_TENDERS is not present, a time of 23:59+01:00 is assumed -->
	<cbc:EndDate>
		<xsl:value-of select="../../*:PROCEDURE/*:DATE_RECEIPT_TENDERS"/>
		<xsl:text>+01:00</xsl:text>
	</cbc:EndDate>
	<xsl:choose>
		<xsl:when test="../../*:PROCEDURE/*:TIME_RECEIPT_TENDERS">
			<cbc:EndTime>
				<!-- add any missing leading "0" from the hour -->
				<xsl:value-of select="fn:replace(../../*:PROCEDURE/*:TIME_RECEIPT_TENDERS, '^([0-9]):', '0$1:')"/>
				<!-- add ":00" for the seconds; add the TimeZone offset for CET -->
				<xsl:text>:00+01:00</xsl:text>
			</cbc:EndTime>
		</xsl:when>
		<xsl:otherwise>
			<!-- WARNING: TIME_RECEIPT_TENDERS was not found in TED XML. In order to obtain valid XML for this notice, a time of 23:59+01:00 was used. -->
			<xsl:variable name="message">WARNING: TIME_RECEIPT_TENDERS was not found in TED XML. In order to obtain valid XML for this notice, a time of 23:59+01:00 was used.</xsl:variable>
			<xsl:call-template name="report-warning"><xsl:with-param name="message" select="$message"/></xsl:call-template>
			<cbc:EndTime>23:59:00+01:00</cbc:EndTime>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="*:DATE_DISPATCH_INVITATIONS">
	<!-- NOTE: cbc:EndDate and cbc:EndTime should contain ISO-8601 format dates, i.e. expressed as UTC with offsets. -->
	<!-- TED date elements have no time zone associated, and TED time elements have "local time". -->
	<!-- Therefore for complete accuracy, a mapping of country codes to UTC timezone offsets is required -->
	<!-- In this initial conversion, no such mapping is used, and TED dates and times are assumed to be CET, i.e. UTC+01:00 -->
	<cac:InvitationSubmissionPeriod>
		<cbc:StartDate>
			<xsl:value-of select="."/>
			<xsl:text>+01:00</xsl:text>
		</cbc:StartDate>
	</cac:InvitationSubmissionPeriod>
</xsl:template>

<xsl:template name="limit-candidate">
	<xsl:if test="*:NB_MAX_LIMIT_CANDIDATE or *:NB_MIN_LIMIT_CANDIDATE or *:NB_ENVISAGED_CANDIDATE or $eforms-notice-subtype = '16'">
		<cac:EconomicOperatorShortList>
			<xsl:choose>
				<xsl:when test="*:NB_ENVISAGED_CANDIDATE">
					<cbc:LimitationDescription>true</cbc:LimitationDescription>
					<cbc:MaximumQuantity>
						<xsl:value-of select="*:NB_ENVISAGED_CANDIDATE"/>
					</cbc:MaximumQuantity>
				</xsl:when>
				<xsl:when test="*:NB_MAX_LIMIT_CANDIDATE">
					<cbc:LimitationDescription>true</cbc:LimitationDescription>
					<cbc:MaximumQuantity>
						<xsl:value-of select="*:NB_MAX_LIMIT_CANDIDATE"/>
					</cbc:MaximumQuantity>
				</xsl:when>
				<xsl:otherwise>
					<cbc:LimitationDescription>false</cbc:LimitationDescription>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="*:NB_MIN_LIMIT_CANDIDATE">
					<cbc:MinimumQuantity>
						<xsl:value-of select="*:NB_MIN_LIMIT_CANDIDATE"/>
					</cbc:MinimumQuantity>
				</xsl:when>
				<xsl:when test="*:NB_ENVISAGED_CANDIDATE">
					<cbc:MinimumQuantity>
						<xsl:value-of select="*:NB_ENVISAGED_CANDIDATE"/>
					</cbc:MinimumQuantity>
				</xsl:when>
				<xsl:when test="$eforms-notice-subtype = '16'">
					<!-- WARNING: Minimum Candidates (BT-50) is mandatory for eForms notice subtype 16, but no value was given in the source TED XML. The value "0" has been used. -->
					<xsl:variable name="message">WARNING: Minimum Candidates (BT-50) is mandatory for eForms subtype 16, but no value was given in the source TED XML. The value "0" has been used.</xsl:variable>
					<xsl:call-template name="report-warning"><xsl:with-param name="message" select="$message"/></xsl:call-template>
					<cbc:MinimumQuantity>0</cbc:MinimumQuantity>
				</xsl:when>
			</xsl:choose>
		</cac:EconomicOperatorShortList>
	</xsl:if>
</xsl:template>

<xsl:template match="*:OPENING_CONDITION">
	<cac:OpenTenderEvent>
		<cbc:OccurrenceDate>
			<xsl:value-of select="*:DATE_OPENING_TENDERS"/>
			<!-- add the TimeZone offset for CET -->
			<xsl:text>+01:00</xsl:text>
		</cbc:OccurrenceDate>
		<cbc:OccurrenceTime>
			<!-- add any missing leading "0" from the hour -->
			<xsl:value-of select="fn:replace(*:TIME_OPENING_TENDERS, '^([0-9]):', '0$1:')"/>
			<!-- add ":00" for the seconds; add the TimeZone offset for CET -->
			<xsl:text>:00+01:00</xsl:text>
		</cbc:OccurrenceTime>
		<xsl:apply-templates select="*:INFO_ADD"/>
		<xsl:apply-templates select="*:PLACE"/>
	</cac:OpenTenderEvent>
</xsl:template>

<xsl:template match="*:OPENING_CONDITION/*:INFO_ADD">
	<xsl:variable name="text" select="fn:normalize-space(fn:string-join(*:P, ' '))"/>
	<xsl:if test="$text ne ''">
		<xsl:call-template name="multilingual">
			<xsl:with-param name="contexts" select="."/>
			<xsl:with-param name="local" select="''"/>
			<xsl:with-param name="element" select="'cbc:Description'"/>
		</xsl:call-template>
	</xsl:if>
</xsl:template>

<xsl:template match="*:OPENING_CONDITION/*:PLACE">
	<xsl:variable name="text" select="fn:normalize-space(fn:string-join(*:P, ' '))"/>
	<xsl:if test="$text ne ''">
		<cac:OccurenceLocation>
			<xsl:call-template name="multilingual">
				<xsl:with-param name="contexts" select="."/>
				<xsl:with-param name="local" select="'P'"/>
				<xsl:with-param name="element" select="'cbc:Description'"/>
			</xsl:call-template>
		</cac:OccurenceLocation>
	</xsl:if>
</xsl:template>

<xsl:template name="eauction-used">
	<xsl:choose>
		<xsl:when test="../../*:PROCEDURE/*:EAUCTION_USED or $eforms-notice-subtype = ('16', '17', '18', '22', '29', '30', '31')">
			<cac:AuctionTerms>
				<!-- Electronic Auction (BT-767): eForms documentation cardinality (Lot) = ? | Mandatory for CN subtypes 16-18 and 22, CAN subtypes 29-31; Optional for PIN subtypes 7-9, CN subtypes 10-14, 19-21, and E3, CAN subtypes 32-35 and E4, CM subtype E5; Forbidden for other subtypes -->
				<xsl:choose>
					<xsl:when test="$ted-form-main-element/*:PROCEDURE/*:EAUCTION_USED">
						<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Electronic Auction (BT-767)'"/></xsl:call-template>
						<cbc:AuctionConstraintIndicator>true</cbc:AuctionConstraintIndicator>
						<!-- Electronic Auction Description (BT-122): eForms documentation cardinality (Lot) = ? | Optional for PIN subtypes 7-9, CN subtypes 10-14, 16-22, and E3; Forbidden for other subtypes -->
						<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Electronic Auction Description (BT-122)'"/></xsl:call-template>
						<!-- When Electronic Auction (BT-767) is "true", Electronic Auction Description (BT-122) and Electronic Auction URL (BT-123) should be specified -->
						<xsl:if test="$eforms-notice-subtype = ('7', '8', '9', '10', '11', '12', '13', '14', '16', '17', '18', '19', '20', '21', '22', 'E3')">
							<xsl:variable name="text" select="fn:normalize-space(fn:string-join($ted-form-main-element/*:PROCEDURE/*:INFO_ADD_EAUCTION/*:P, ' '))"/>
							<xsl:choose>
								<xsl:when test="$text ne ''">
									<xsl:call-template name="multilingual">
										<xsl:with-param name="contexts" select="$ted-form-main-element/*:PROCEDURE/*:INFO_ADD_EAUCTION"/>
										<xsl:with-param name="local" select="'P'"/>
										<xsl:with-param name="element" select="'cbc:Description'"/>
									</xsl:call-template>
								</xsl:when>
								<xsl:otherwise>
									<xsl:variable name="message">WARNING: source TED XML notice does not contain information for Electronic Auction Description (BT-122).</xsl:variable>
									<xsl:call-template name="report-warning"><xsl:with-param name="message" select="$message"/></xsl:call-template>
									<cbc:Description languageID="{$eforms-first-language}"></cbc:Description>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:if>
						<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Electronic Auction URL (BT-123)'"/></xsl:call-template>
						<!-- When Electronic Auction (BT-767) is "true", Electronic Auction Description (BT-122) and Electronic Auction URL (BT-123) should be specified -->
						<xsl:if test="$eforms-notice-subtype = ('7', '8', '9', '10', '11', '12', '13', '14', '16', '17', '18', '19', '20', '21', '22', 'E3')">
							<xsl:variable name="message">WARNING: source TED XML notice does not contain information for Electronic Auction URL (BT-123).</xsl:variable>
							<xsl:call-template name="report-warning"><xsl:with-param name="message" select="$message"/></xsl:call-template>
							<cbc:AuctionURI></cbc:AuctionURI>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Electronic Auction (BT-767)'"/></xsl:call-template>
						<cbc:AuctionConstraintIndicator>false</cbc:AuctionConstraintIndicator>
						<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Electronic Auction Description (BT-122)'"/></xsl:call-template>
						<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Electronic Auction URL (BT-123)'"/></xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</cac:AuctionTerms>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Electronic Auction (BT-767)'"/></xsl:call-template>
			<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Electronic Auction Description (BT-122)'"/></xsl:call-template>
			<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Electronic Auction URL (BT-123)'"/></xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="framework-agreement">
	<!-- Framework Agreement (BT-765) -->
	<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Framework Agreement (BT-765)'"/></xsl:call-template>
	<xsl:if test="../../*:PROCEDURE/*:FRAMEWORK or $eforms-notice-subtype = ('7', '8', '9', '10', '11', '16', '17', '18', '22', '29', '30', '31')">
		<xsl:choose>
			<xsl:when test="../../*:PROCEDURE/*:FRAMEWORK">
				<!--For CN forms F02, F05, F21, F22 FRAMEWORK has child elements specifying the number of participants and the duration justification-->
				<xsl:apply-templates select="../../*:PROCEDURE/*:FRAMEWORK[*]"/>
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

<xsl:template match="*:FRAMEWORK">
	<cac:FrameworkAgreement>
		<!-- Framework Maximum Participants Number (BT-113): eForms documentation cardinality (Lot) = ? | Optional for PIN subtypes 7-9, CN subtypes 10-13, 16-18, 20-22, and E3; Forbidden for other subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Framework Maximum Participants Number (BT-113)'"/></xsl:call-template>
		<xsl:choose>
			<xsl:when test="*:SINGLE_OPERATOR">
				<cbc:MaximumOperatorQuantity>
					<xsl:text>1</xsl:text>
				</cbc:MaximumOperatorQuantity>
			</xsl:when>
			<xsl:when test="*:NB_PARTICIPANTS">
				<cbc:MaximumOperatorQuantity>
					<xsl:value-of select="*:NB_PARTICIPANTS"/>
				</cbc:MaximumOperatorQuantity>
			</xsl:when>
			<xsl:otherwise>
				<!-- WARNING: Framework with Multiple Operators is specified in the source TED XML, but no value is given for Framework Maximum Participants Number (BT-113). -->
				<xsl:variable name="message">WARNING: Framework with Multiple Operators is specified in the source TED XML, but no value is given for Framework Maximum Participants Number (BT-113).</xsl:variable>
				<xsl:call-template name="report-warning"><xsl:with-param name="message" select="$message"/></xsl:call-template>
				<cbc:MaximumOperatorQuantity></cbc:MaximumOperatorQuantity>
			</xsl:otherwise>
		</xsl:choose>
		<!-- Framework Duration Justification (BT-109): eForms documentation cardinality (Lot) = ? | Optional for PIN subtypes 7-9, CN subtypes 10-13, 16-18, 20-22, and E3; Forbidden for other subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Framework Duration Justification (BT-109)'"/></xsl:call-template>
		<xsl:apply-templates select="*:JUSTIFICATION"/>
	</cac:FrameworkAgreement>
</xsl:template>

<xsl:template match="*:JUSTIFICATION">
	<xsl:variable name="text" select="fn:normalize-space(fn:string-join(*:P, ' '))"/>
	<xsl:if test="$text ne ''">
		<xsl:call-template name="multilingual">
			<xsl:with-param name="contexts" select="."/>
			<xsl:with-param name="local" select="'P'"/>
			<xsl:with-param name="element" select="'cbc:Justification'"/>
		</xsl:call-template>
	</xsl:if>
</xsl:template>

<xsl:template name="dps">
	<xsl:if test="../../*:PROCEDURE/*:DPS or $eforms-notice-subtype = ('7', '8', '10', '11', '16', '17', '29', '30')">
		<!-- WARNING: Dynamic Purchasing System (BT-766) is specified at Procedure level in TED XML. It has been copied to Lot level in this eForms XML. -->
		<xsl:variable name="message">WARNING: Dynamic Purchasing System (BT-766) is specified at Procedure level in TED XML. It has been copied to Lot level in this eForms XML.</xsl:variable>
		<xsl:call-template name="report-warning"><xsl:with-param name="message" select="$message"/></xsl:call-template>
		<cac:ContractingSystem>
			<cbc:ContractingSystemTypeCode listName="dps-usage">
				<xsl:choose>
					<xsl:when test="../../*:PROCEDURE/*:DPS_ADDITIONAL_PURCHASERS">
						<xsl:text>dps-nlist</xsl:text>
					</xsl:when>
					<xsl:when test="../../*:PROCEDURE/*:DPS">
						<xsl:text>dps-list</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>none</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</cbc:ContractingSystemTypeCode>
		</cac:ContractingSystem>
	</xsl:if>
</xsl:template>

<!-- end of Lot Tendering Process templates -->



<!-- Lot Procurement Project templates -->
<xsl:template name="lot-procurement-project">
	<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="' cac:ProcurementProject '"/></xsl:call-template>
	<cac:ProcurementProject>
		<!-- Internal Identifier (BT-22): eForms documentation cardinality (Lot) = 1 | No equivalent element in TED XML -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Internal Identifier (BT-22)'"/></xsl:call-template>
		<!-- TBD: unique ID required here -->
		<!-- WARNING: Internal ID (BT-22) is required but there is no equivalent element in TED XML. -->
		<xsl:variable name="message">WARNING: Internal ID (BT-22) is required but there is no equivalent element in TED XML.</xsl:variable>
		<xsl:call-template name="report-warning"><xsl:with-param name="message" select="$message"/></xsl:call-template>
		<cbc:ID schemeName="InternalID"></cbc:ID>
		<!-- Title (BT-21): eForms documentation cardinality (Lot) = 1 | Mandatory for ALL Notice subtypes, except Optional for CM Notice subtypes 38-40-->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Title (BT-21)'"/></xsl:call-template>
		<!-- if TITLE exists in OBJ_DESCR, use that, otherwise use TITLE in OBJECT_CONTRACT parent -->
		<xsl:choose>
			<xsl:when test="fn:normalize-space(fn:string(*:TITLE))">
				<xsl:apply-templates select="*:TITLE"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="../*:TITLE"/>
			</xsl:otherwise>
		</xsl:choose>
		<!-- Description (BT-24): eForms documentation cardinality (Lot) = 1 | Mandatory for ALL Notice subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Description (BT-24)'"/></xsl:call-template>
		<xsl:apply-templates select="*:SHORT_DESCR"/>
		<!-- Main Nature (BT-23): eForms documentation cardinality (Lot) = 1 | Optional for ALL Notice subtypes Equivalent element TYPE_CONTRACT in TED does not exist in OBJ_DESCR, so use TYPE_CONTRACT in OBJECT_CONTRACT parent -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Main Nature (BT-23)'"/></xsl:call-template>
		<xsl:apply-templates select="../*:TYPE_CONTRACT"/>
		<!-- Additional Nature (BT-531): eForms documentation cardinality (Lot) = * | No equivalent element in TED XML -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Additional Nature (BT-531)'"/></xsl:call-template>
		<!-- Strategic Procurement (BT-06): eForms documentation cardinality (Lot) = * | No equivalent element in TED XML -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Strategic Procurement (BT-06)'"/></xsl:call-template>
		<!-- Strategic Procurement Description (BT-777): eForms documentation cardinality (Lot) = * | No equivalent element in TED XML -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Strategic Procurement Description (BT-777)'"/></xsl:call-template>
		<!-- Green Procurement (BT-774): eForms documentation cardinality (Lot) = * | No equivalent element in TED XML -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Green Procurement (BT-774)'"/></xsl:call-template>
		<!-- Social Procurement (BT-775): eForms documentation cardinality (Lot) = * | No equivalent element in TED XML -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Social Procurement (BT-775)'"/></xsl:call-template>
		<!-- Procurement of Innovation (BT-776): eForms documentation cardinality (Lot) = * | No equivalent element in TED XML -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Procurement of Innovation (BT-776)'"/></xsl:call-template>
		<!-- Accessibility Justification (BT-755): eForms documentation cardinality (Lot) = ? | No equivalent element in TED XML -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Accessibility Justification (BT-755)'"/></xsl:call-template>
		<!-- Accessibility (BT-754): eForms documentation cardinality (Lot) = ? | No equivalent element in TED XML -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Accessibility (BT-754)'"/></xsl:call-template>
		<!-- Quantity (BT-25): eForms documentation cardinality (Lot) = ? | No equivalent element in TED XML -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Quantity (BT-25)'"/></xsl:call-template>
		<!-- Unit (BT-625): eForms documentation cardinality (Lot) = ? | No equivalent element in TED XML -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Unit (BT-625)'"/></xsl:call-template>
		<!-- Suitable for SMEs (BT-726): eForms documentation cardinality (Lot) = ? | No equivalent element in TED XML -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Suitable for SMEs (BT-726)'"/></xsl:call-template>
		<!-- Additional Information (BT-300): eForms documentation cardinality (Lot) = ? | Optional for ALL Notice subtypes. -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Additional Information (BT-300)'"/></xsl:call-template>
		<xsl:apply-templates select="*:INFO_ADD"/>
		<!-- Estimated Value (BT-27): eForms documentation cardinality (Lot) = ? | Optional for PIN subtypes 4-9, E1, and E2, CN subtypes 10-14, 16-22, and E3, CAN subtypes 29-35 and E4, CM subtype E5; Forbidden for other subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Estimated Value (BT-27)'"/></xsl:call-template>
		<xsl:apply-templates select="*:VAL_OBJECT"/>
		<!-- Classification Type (BT-26): eForms documentation cardinality (Lot) = 1 | Mandatory for ALL Notice subtypes, except Optional for CM Notice subtypes 38-40 -->
		<!-- Main Classification Code (BT-262): eForms documentation cardinality (Lot) = 1 | Mandatory for ALL Notice subtypes, except Optional for CM Notice subtypes 38-40 -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Main Classification Code (BT-262)'"/></xsl:call-template>
		<xsl:apply-templates select="../*:CPV_MAIN"/>
		<!-- Additional Classification Code (BT-263): eForms documentation cardinality (Lot) = * | Optional for ALL Notice subtypes, No equivalent element in TED XML at Lot level -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Additional Classification Code (BT-263)'"/></xsl:call-template>
		<xsl:apply-templates select="*:CPV_ADDITIONAL"/>
		<!-- Place of Performance (BG-708) -> RealizedLocation | Mandatory for subtypes PIN 1-9, CN 10-24, CAN 29-37; Optional for VEAT 25-28, CM 38-40, E1, E2, E3, E4 and E5 -->
		<!-- Place of Performance Additional Information (BT-728): eForms documentation cardinality (Lot) = ? | Optional for ALL subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Place of Performance Additional Information (BT-728)'"/></xsl:call-template>
		<!-- Place Performance City (BT-5131): eForms documentation cardinality (Lot) = ? | Optional for ALL subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Place Performance City (BT-5131)'"/></xsl:call-template>
		<!-- Place Performance Post Code (BT-5121): eForms documentation cardinality (Lot) = ? | Optional for ALL subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Place Performance Post Code (BT-5121)'"/></xsl:call-template>
		<!-- Place Performance Country Subdivision (BT-5071): eForms documentation cardinality (Lot) = ? | Optional for ALL subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Place Performance Country Subdivision (BT-5071)'"/></xsl:call-template>
		<!-- Place Performance Services Other (BT-727): eForms documentation cardinality (Lot) = ? | Optional for ALL subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Place Performance Services Other (BT-727)'"/></xsl:call-template>
		<!-- Place Performance Street (BT-5101): eForms documentation cardinality (Lot) = ? | Optional for ALL subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Place Performance Street (BT-5101)'"/></xsl:call-template>
		<!-- Place Performance Country Code (BT-5141): eForms documentation cardinality (Lot) = ? | Optional for ALL subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Place Performance Country Code (BT-5141)'"/></xsl:call-template>
		<xsl:call-template name="place-performance"/>
		<!-- Duration Start Date (BT-536): eForms documentation cardinality (Lot) = ? | Mandatory for CM subtype E5; Forbidden for CN subtypes 23 and 24, CAN subtypes 36 and 37; Optional for other subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Duration Start Date (BT-536)'"/></xsl:call-template>
		<!-- Duration End Date (BT-537): eForms documentation cardinality (Lot) = ? | Mandatory for CM subtype E5; Forbidden for CN subtypes 23 and 24, CAN subtypes 36 and 37; Optional for other subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Duration End Date (BT-537)'"/></xsl:call-template>
		<!-- Duration Period (BT-36): eForms documentation cardinality (Lot) = ? | Forbidden for CN subtypes 23 and 24, CAN subtypes 36 and 37, CM subtype E5; Optional for other subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Duration Period (BT-36)'"/></xsl:call-template>
		<!-- Duration Other (BT-538): eForms documentation cardinality (Lot) = ? | Forbidden for CN subtypes 23 and 24, CAN subtypes 36 and 37, CM subtype E5; Optional for other subtypes -->
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Duration Other (BT-538)'"/></xsl:call-template>
		<xsl:apply-templates select="*:DURATION|*:DATE_START|*:DATE_END[fn:not(../*:DATE_START)]"/>
		<xsl:apply-templates select="*:QS/(*:INDEFINITE_DURATION|*:DATE_START)"/>
		<!-- cbc:MaximumNumberNumeric is mandatory for Notice subtypes 15 (Notice on the existence of a qualification system), 17 and 18 (Contract, or concession, notice — standard regime, Directives 2014/25/EU and 2009/81/EC) -->
		<!-- cbc:MaximumNumberNumeric shall be a whole number (when no extension is foreseen, the element shouldn’t be used, except for Notice subtypes 15, 17 and 18, where it should have the value 0) -->
		<!-- cbc:MaximumNumberNumeric refers to the number of possible renewals; an encoded value of "3" involves an initial contract followed by up to 3 renewals -->
		<!-- Contract Extensions group -->
		<xsl:call-template name="contract-extension"/>
	</cac:ProcurementProject>
</xsl:template>

<xsl:template match="*:OBJECT_DESCR/*:INFO_ADD">
	<xsl:variable name="text" select="fn:normalize-space(fn:string-join(*:P, ' '))"/>
	<xsl:if test="$text ne ''">
		<xsl:call-template name="multilingual">
			<xsl:with-param name="contexts" select="."/>
			<xsl:with-param name="local" select="'P'"/>
			<xsl:with-param name="element" select="'cbc:Note'"/>
		</xsl:call-template>
	</xsl:if>
</xsl:template>

<xsl:template match="*:OBJECT_DESCR/*:TITLE">
	<xsl:variable name="text" select="fn:normalize-space(fn:string-join(*:P, ' '))"/>
	<xsl:if test="$text ne ''">
		<xsl:call-template name="multilingual">
			<xsl:with-param name="contexts" select="."/>
			<xsl:with-param name="local" select="'P'"/>
			<xsl:with-param name="element" select="'cbc:Name'"/>
		</xsl:call-template>
	</xsl:if>
</xsl:template>

<xsl:template name="place-performance">
	<!-- the BG-708 Place of Performance is Mandatory for most form subtypes, but none of its child BTs are Mandatory -->
	<!-- Note: it is not possible to convert the content of MAIN_SITE to any eForms elements that will pass the business rules validation. -->
	<!-- It is also not possible to recognise any part of the content of MAIN_SITE and assign it to a particular eForms BT -->
	<!-- To maintain any existing separation of the address in P elements: -->
	<!--    the first P element will be converted to a cac:AddressLine/cbc:StreetName element -->
	<!--    the second P element will be converted to a cac:AddressLine/cbc:AdditionalStreetName element -->
	<!--    the remaining P elements will be converted to separate cac:AddressLine/cbc:Line elements -->
	<!-- get list of only NUTS level 3 codes -->
	<xsl:variable name="valid-nuts" select="opfun:get-valid-nuts-codes(*:NUTS/@CODE)"/>
	<xsl:variable name="main-nuts" select="$valid-nuts[1]"/>
	<xsl:variable name="rest-nuts" select="functx:value-except($valid-nuts, $main-nuts)"/>
	<xsl:variable name="main-site-text" select="fn:normalize-space(*:MAIN_SITE)"/>
	<xsl:if test="$main-site-text or fn:not(fn:empty($valid-nuts)) or $eforms-notice-subtype = ('1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '29', '30', '31', '32', '33', '34', '35', '36', '37')">
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Place of performance (BG-708) : Place Performance: Additional Information (BT-728), City (BT-5131), Post Code (BT-5121), Country Subdivision (BT-5071), Services Other (as a codelist) (BT-727), Street (BT-5101), Code (BT-5141)'"/></xsl:call-template>
		<xsl:choose>
			<xsl:when test="fn:not($main-site-text) and fn:empty($valid-nuts)">
				<!-- No valid MAIN_SITE and no valid NUTS codes -->
				<cac:RealizedLocation>
					<cac:Address>
						<cbc:Region>anyw</cbc:Region>
					</cac:Address>
				</cac:RealizedLocation>
			</xsl:when>
			<!-- Valid MAIN_SITE and no valid NUTS codes -->
			<xsl:when test="$main-site-text and fn:empty($valid-nuts)">
				<!-- valid MAIN_SITE exists but no valid NUTS codes -->
				<xsl:call-template name="main-site">
					<xsl:with-param name="nuts-code" select="''"/>
					<xsl:with-param name="main-site" select="*:MAIN_SITE"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<!-- valid MAIN_SITE exists and at least one valid NUTS code exists, create a <cac:RealizedLocation><cac:Address> for each NUTS code -->
				<xsl:variable name="main-site" select="*:MAIN_SITE"/>
				<xsl:for-each select="$valid-nuts">
					<xsl:call-template name="main-site">
						<xsl:with-param name="nuts-code" select="."/>
						<xsl:with-param name="main-site" select="$main-site"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:if>
</xsl:template>

<xsl:template name="main-site">
	<xsl:param name="nuts-code"/>
	<xsl:param name="main-site"/>
	<xsl:variable name="valid-main-site-paragraphs" select="$main-site/*:P[fn:normalize-space(.) != '']/fn:normalize-space()"/>
	<cac:RealizedLocation>
		<cac:Address>
			<!-- need to follow order of elements defined in the eForms schema -->
			<xsl:if test="$valid-main-site-paragraphs[1]">
				<cbc:StreetName>
					<xsl:value-of select="$valid-main-site-paragraphs[1]"/>
				</cbc:StreetName>
			</xsl:if>
			<xsl:if test="$valid-main-site-paragraphs[2]">
				<cbc:AdditionalStreetName>
					<xsl:value-of select="$valid-main-site-paragraphs[2]"/>
				</cbc:AdditionalStreetName>
			</xsl:if>
			<xsl:if test="$nuts-code != ''">
				<cbc:CountrySubentityCode listName="nuts">
					<xsl:value-of select="$nuts-code"/>
				</cbc:CountrySubentityCode>
			</xsl:if>
			<xsl:if test="$valid-main-site-paragraphs[3]">
				<xsl:variable name="address-line" select="fn:string-join(($valid-main-site-paragraphs[fn:position() &gt; 2]), ' ')"/>
				<cac:AddressLine>
					<cbc:Line>
						<xsl:value-of select="$address-line"/>
					</cbc:Line>
				</cac:AddressLine>
			</xsl:if>
		</cac:Address>
	</cac:RealizedLocation>
</xsl:template>

<xsl:template match="*:DURATION">
	<cac:PlannedPeriod>
		<!--"YEAR"|"MONTH"|"DAY"-->
		<xsl:variable name="duration-type" select="@TYPE"/>
		<cbc:DurationMeasure unitCode="{$duration-type}">
			<xsl:value-of select="."/>
		</cbc:DurationMeasure>
	</cac:PlannedPeriod>
</xsl:template>

<xsl:template match="*:INDEFINITE_DURATION">
	<cac:PlannedPeriod>
		<cbc:DescriptionCode listName="timeperiod">UNLIMITED</cbc:DescriptionCode>
	</cac:PlannedPeriod>
</xsl:template>

<xsl:template match="*:DATE_START">
	<cac:PlannedPeriod>
		<cbc:StartDate>
			<xsl:value-of select="."/>
			<xsl:text>+01:00</xsl:text>
		</cbc:StartDate>
		<xsl:choose>
			<xsl:when test="../*:DATE_END">
				<cbc:EndDate>
					<xsl:value-of select="../*:DATE_END"/>
					<xsl:text>+01:00</xsl:text>
				</cbc:EndDate>
			</xsl:when>
			<xsl:otherwise>
				<!-- WARNING: Duration Other (BT-538) cbc:EndDate is required but the source TED notice does not contain DATE_END. In order to obtain valid XML for this notice, a far future date was used (2099-12-31+01:00) -->
				<xsl:variable name="message">WARNING: Duration Other (BT-538) cbc:EndDate is required but the source TED notice does not contain DATE_END. In order to obtain valid XML for this notice, a far future date was used (2099-12-31+01:00).</xsl:variable>
				<xsl:call-template name="report-warning"><xsl:with-param name="message" select="$message"/></xsl:call-template>
				<cbc:EndDate>
					<xsl:text>2099-12-31+01:00</xsl:text>
				</cbc:EndDate>
			</xsl:otherwise>
		</xsl:choose>
	</cac:PlannedPeriod>
</xsl:template>

<xsl:template match="*:DATE_END[fn:not(../*:DATE_START)]">
	<cac:PlannedPeriod>
		<!-- WARNING: cbc:StartDate is required but the source TED notice does not contain DATE_START. In order to obtain valid XML for this notice, a far past date was used (1900-01-01+01:00) -->
		<xsl:variable name="message">WARNING: cbc:StartDate is required but the source TED notice does not contain DATE_START. In order to obtain valid XML for this notice, a far past date was used (1900-01-01+01:00).</xsl:variable>
		<xsl:call-template name="report-warning"><xsl:with-param name="message" select="$message"/></xsl:call-template>
		<cbc:StartDate>
			<xsl:text>1900-01-01+01:00</xsl:text>
		</cbc:StartDate>
		<cbc:EndDate>
			<xsl:value-of select="."/>
			<xsl:text>+01:00</xsl:text>
		</cbc:EndDate>
	</cac:PlannedPeriod>
</xsl:template>

<xsl:template name="contract-extension">
	<!-- Note: the presence of Options Description (BT-54) implies Options (BT-53) -->
	<xsl:choose>
		<xsl:when test="($eforms-notice-subtype = ('15', '17', '18') or (*:OPTIONS) or (*:RENEWAL) or (*:QS/*:RENEWAL))">
			<cac:ContractExtension>
				<xsl:variable name="text" select="fn:normalize-space(fn:string-join(*:OPTIONS_DESCR/*:P, ' '))"/>
				<!-- Options Description (BT-54): eForms documentation cardinality (Lot) = ? | Optional for PIN subtypes 7-9, CN subtypes 10-14, 16-22, and E3, CAN subtypes 25-35 and E4, CM subtypes 38-40 and E5; Forbidden for other subtypes -->
				<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Options Description (BT-54)'"/></xsl:call-template>
				<xsl:if test="$text ne ''">
					<xsl:call-template name="multilingual">
						<xsl:with-param name="contexts" select="*:OPTIONS_DESCR"/>
						<xsl:with-param name="local" select="'P'"/>
						<xsl:with-param name="element" select="'cbc:OptionsDescription'"/>
					</xsl:call-template>
				</xsl:if>
				<xsl:variable name="text" select="fn:normalize-space(fn:string-join((*:RENEWAL_DESCR|*:QS/*:RENEWAL_DESCR)/*:P, ' '))"/>
				<!--cbc:MaximumNumberNumeric shall be a whole number (when no extension is foreseen, the element shouldn’t be used, except for Notice subtypes 15, 17 and 18, where it should have the value 0)-->
				<!-- Renewal Maximum (BT-58): eForms documentation cardinality (Lot) = ? | Mandatory for CN subtypes 15, 17, and 18; Optional for PIN subtypes 7-9, CN subtypes 10-13, 16, 19-22, and E3, CAN subtypes 25-35 and E4, CM subtypes 38-40 and E5; Forbidden for other subtypes -->
				<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Renewal Maximum (BT-58)'"/></xsl:call-template>
				<xsl:choose>
					<xsl:when test="$text ne ''">
						<!-- WARNING: the source TED notice contains information for Renewal Description (BT-57), but does not contain information for the maximum number of times a contract may be renewed (Renewal Maximum, BT-58). -->
						<xsl:variable name="message">WARNING: the source TED notice contains information for Renewal Description (BT-57), but does not contain information for the maximum number of times a contract may be renewed (Renewal Maximum, BT-58).</xsl:variable>
						<xsl:call-template name="report-warning"><xsl:with-param name="message" select="$message"/></xsl:call-template>
						<cbc:MaximumNumberNumeric>0</cbc:MaximumNumberNumeric>
						<!-- Renewal Description (BT-57): eForms documentation cardinality (Lot) = ? | Optional for PIN subtypes 7-9, CN subtypes 10-13, 15-22, and E3, CAN subtypes 25-35 and E4, CM subtypes 38-40 and E5; Forbidden for other subtypes -->
						<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Renewal Description (BT-57)'"/></xsl:call-template>
						<cac:Renewal>
							<cac:Period>
								<xsl:call-template name="multilingual">
									<xsl:with-param name="contexts" select="*:RENEWAL_DESCR|*:QS/*:RENEWAL_DESCR"/>
									<xsl:with-param name="local" select="'P'"/>
									<xsl:with-param name="element" select="'cbc:Description'"/>
								</xsl:call-template>
							</cac:Period>
						</cac:Renewal>
					</xsl:when>
					<xsl:when test="$eforms-notice-subtype = ('15', '17', '18')">
						<cbc:MaximumNumberNumeric>0</cbc:MaximumNumberNumeric>
						<!-- Renewal Description (BT-57): eForms documentation cardinality (Lot) = ? | Optional for PIN subtypes 7-9, CN subtypes 10-13, 15-22, and E3, CAN subtypes 25-35 and E4, CM subtypes 38-40 and E5; Forbidden for other subtypes -->
						<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Renewal Description (BT-57)'"/></xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<!-- Renewal Description (BT-57): eForms documentation cardinality (Lot) = ? | Optional for PIN subtypes 7-9, CN subtypes 10-13, 15-22, and E3, CAN subtypes 25-35 and E4, CM subtypes 38-40 and E5; Forbidden for other subtypes -->
						<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Renewal Description (BT-57)'"/></xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</cac:ContractExtension>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Options Description (BT-54)'"/></xsl:call-template>
			<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Renewal Maximum (BT-58)'"/></xsl:call-template>
			<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Renewal Description (BT-57)'"/></xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- end of Lot Procurement Project templates -->

</xsl:stylesheet>
