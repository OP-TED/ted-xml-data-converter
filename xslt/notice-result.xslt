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


<!-- Create temporary XML structure to hold all the TED CONTRACTORS elements, with the XPath for each -->
<xsl:variable name="ted-contractor-groups" as="element()">
	<ted-contractor-groups>
		<xsl:for-each select="$ted-form-main-element/ted:AWARD_CONTRACT/ted:AWARDED_CONTRACT/ted:CONTRACTORS">
			<ted-contractor-group>
				<xsl:variable name="path" select="functx:path-to-node-with-pos(.)"/>
				<path><xsl:value-of select="$path"/></path>
				<contractor-group>
					<xsl:for-each select="ted:CONTRACTOR">
						<xsl:variable name="contractor-path" select="functx:path-to-node-with-pos(.)"/>
						<xsl:variable name="orgid" select="$ted-addresses-unique-with-id//ted-org/path[fn:starts-with(.,$contractor-path)]/fn:string(../orgid)"/>
						<ted-contractor><xsl:value-of select="$orgid"/></ted-contractor>
					</xsl:for-each>
				</contractor-group>
			</ted-contractor-group>
		</xsl:for-each>
	</ted-contractor-groups>
</xsl:variable>

<!-- Create temporary XML structure to hold the UNIQUE (using deep-equal) contractor groups in TED XML. Each xml structure includes the XPATH of all source TED contractor groups that are the same group -->
<xsl:variable name="ted-contractor-groups-unique" as="element()">
	<ted-contractor-groups>
		<xsl:for-each select="$ted-contractor-groups//ted-contractor-group">
			<xsl:variable name="pos" select="fn:position()"/>
			<xsl:variable name="this-group" as="element()" select="contractor-group"/>
			<!-- find if any preceding addresses are deep-equal to this one -->
			<xsl:variable name="prevsame">
				<xsl:for-each select="./preceding-sibling::ted-contractor-group">
					<xsl:if test="fn:deep-equal(contractor-group, $this-group)">
						<xsl:value-of select="'same'"/>
					</xsl:if>
				</xsl:for-each>
			</xsl:variable>
			<data><xsl:value-of select="$pos"/><xsl:text>:</xsl:text><xsl:value-of select="$prevsame"/></data>
			<!-- if no preceding addresses are deep-equal to this one, then ... -->
			<xsl:if test="$prevsame = ''">
				<ted-contractor-group>
					<!-- get list of paths of addresses, this one and following, that are deep-equal to this one -->
					<path><xsl:sequence select="fn:string(path)"/></path>
					<xsl:for-each select="./following-sibling::ted-contractor-group">
						<xsl:if test="fn:deep-equal(contractor-group, $this-group)">
							<path><xsl:sequence select="fn:string(path)"/></path>
						</xsl:if>
					</xsl:for-each>
					<!-- copy the address -->
					<xsl:copy-of select="contractor-group"/>
				</ted-contractor-group>
			</xsl:if>
		</xsl:for-each>
	</ted-contractor-groups>
</xsl:variable>

<!-- create temporary XML structure that is a copy of the UNIQUE contractor groups in TED XML, and assign a unique identifier to each (OPT-210, "Tendering Party ID") -->
<xsl:variable name="ted-contractor-groups-unique-with-id" as="element()">
	<ted-contractor-groups>
		<xsl:for-each select="$ted-contractor-groups-unique//ted-contractor-group">
			<ted-contractor-group>
				<xsl:variable name="typepos" select="functx:pad-integer-to-length((fn:count(./preceding-sibling::ted-contractor-group) + 1), 4)"/>
				<tpaid><xsl:text>TPA-</xsl:text><xsl:value-of select="$typepos"/></tpaid>
				<xsl:copy-of select="path"/>
				<xsl:copy-of select="contractor-group"/>
			</ted-contractor-group>
		</xsl:for-each>
	</ted-contractor-groups>
</xsl:variable>


<!-- Create temporary XML structure to hold all the LotTender elements, with the source XPath for each, and assign a unique identifier to each (OPT-321, "Tender Technical Identifier") -->
<xsl:variable name="lot-tenders-with-id" as="element()">
	<ted-lot-tenders>
		<xsl:for-each select="$ted-form-main-element/ted:AWARD_CONTRACT">
			<ted-lot-tender>
				<xsl:variable name="path" select="functx:path-to-node-with-pos(.)"/>
				<path><xsl:value-of select="$path"/></path>
				<xsl:variable name="typepos" select="functx:pad-integer-to-length((fn:count(./preceding-sibling::ted:AWARD_CONTRACT) + 1), 4)"/>
				<tenid><xsl:text>TEN-</xsl:text><xsl:value-of select="$typepos"/></tenid>
				<!-- copy selected elements from AWARD_CONTRACT that relate to Lot Tenders -->
				<xsl:copy-of select="ted:CONTRACT_NO" copy-namespaces="no"/>
				<xsl:copy-of select="ted:LOT_NO" copy-namespaces="no"/>
			</ted-lot-tender>
		</xsl:for-each>
	</ted-lot-tenders>
</xsl:variable>


<xsl:template name="notice-result">
	<efac:NoticeResult>
<!--
These instructions can be un-commented to show the variables holding the contractor-groups at intermediate stages

<xsl:copy-of select="$ted-contractor-groups"/>
<xsl:copy-of select="$ted-contractor-groups-unique"/>-->
<xsl:copy-of select="$ted-contractor-groups-unique-with-id"/>

<!--
This instruction can be un-commented to show the variable holding the lot-tenders
-->
<xsl:copy-of select="$lot-tenders-with-id"/>

	
	<!-- Notice Value (BT-161): eForms documentation cardinality (LotResult) = 1 | eForms Regulation Annex table conditions = Optional (O or EM or CM) for CAN subtypes 25-35 and E4, CM subtypes 38-40 and E5; Forbidden (blank) for all other subtypes cbc:TotalAmount -->
	<xsl:comment>Notice Value (BT-161)</xsl:comment>
	<xsl:apply-templates select="ted:OBJECT_CONTRACT/(ted:VAL_TOTAL|ted:VAL_RANGE_TOTAL)"/>
	

	<!-- Notice Framework Value (BT-118): eForms documentation cardinality (LotResult) = 1 | eForms Regulation Annex table conditions = Optional (O or EM or CM) for CAN subtypes 25-27, 29-31, 33, 34 and E4; CM subtypes 38-40 and E5; Forbidden (blank) for all other subtypes cbc:EstimatedOverallFrameworkContractsAmount -->
	<!-- efac:GroupFramework -->
		<!-- Group Framework Value (BT-156): eForms documentation cardinality (LotResult) = 1 | eForms Regulation Annex table conditions = Optional (O or EM or CM) for CAN subtypes 25-27, 29-31, 33, 34 and E4; CM subtypes 38-40 and E5; Forbidden (blank) for all other subtypes efbc:GroupFrameworkValueAmount -->
		<!-- Group Framework Value Lot Identifier (BT-556): eForms documentation cardinality (LotResult) = 1 | eForms Regulation Annex table conditions = Optional (O or EM or CM) for CAN subtypes 25-27, 29-31, 33, 34 and E4; CM subtypes 38-40 and E5; Forbidden (blank) for all other subtypes efac:TenderLot -->


	<!-- efac:LotResult -->
		<!-- Tender Value Highest (BT-711): eForms documentation cardinality (LotResult) = 1 | eForms Regulation Annex table conditions = Optional (O or EM or CM) for CAN subtypes 29-31 and E4; CM subtype E5; Forbidden (blank) for all other subtypes | cbc:HigherTenderAmount -->
		<!-- Tender Value Lowest (BT-710): eForms documentation cardinality (LotResult) = 1 | eForms Regulation Annex table conditions = Optional (O or EM or CM) for CAN subtypes 29-31 and E4; CM subtype E5; Forbidden (blank) for all other subtypes cbc:LowerTenderAmount -->		

		
		<!-- Winner Chosen (BT-142): eForms documentation cardinality (LotResult) = 1 | eForms Regulation Annex table conditions = Mandatory (M) for CAN subtypes 29-37 and E4, CM subtype E5; Forbidden (blank) for all other subtypes | cbc:TenderResultCode -->
		<!-- Dynamic Purchasing System Termination (BT-119): eForms documentation cardinality (LotResult) = ? | eForms Regulation Annex table conditions = Optional (O or EM or CM) for CAN subtypes 29, 30, 33, 34 and E4, CM subtype E5; Forbidden (blank) for all other subtypes efbc:DPSTerminationIndicator -->
		<!-- Financing Party: eForms documentation cardinality (LotResult) = * | cac:FinancingParty​/cac:PartyIdentification​/cbc:ID -->
		<!-- Payer Party: eForms documentation cardinality (LotResult) = * cac:PayerParty​/cac:PartyIdentification/cbc:ID -->
		<!-- Buyer Review Complainants (BT-712): eForms documentation cardinality (LotResult) = ? | eForms Regulation Annex table conditions = Optional (O or EM or CM) for CAN subtypes 29-37 and E4, CM subtypes 38-40 and E5; Forbidden (blank) for all other subtypes efac:AppealRequestsStatistics[efbc:StatisticsCode​/@listName='review-type']​/efbc:StatisticsNumeric -->
		<!-- Buyer Review Requests Irregularity Type (BT-636): eForms documentation cardinality (LotResult) = * | eForms Regulation Annex table conditions = Optional (O or EM or CM) for CAN subtypes 29-37 and E4, CM subtypes 38-40 and E5; Forbidden (blank) for all other subtypes efac:AppealRequestsStatistics[efbc:StatisticsCode​/@listName='irregularity-type']​/efbc:StatisticsCode -->
		<!-- Buyer Review Requests Count (BT-635): eForms documentation cardinality (LotResult) = * | eForms Regulation Annex table conditions = Optional (O or EM or CM) for CAN subtypes 29-37 and E4, CM subtypes 38-40 and E5; Forbidden (blank) for all other subtypes efac:AppealRequestsStatistics[efbc:StatisticsCode​/@listName='irregularity-type']​/efbc:StatisticsNumeric -->
		<!-- Not Awarded Reason (BT-144): eForms documentation cardinality (LotResult) = 1 | eForms Regulation Annex table conditions = Optional (O or EM or CM) for CAN subtypes 29-37 and E4, CM subtype E5; Forbidden (blank) for all other subtypes efac:DecisionReason​/efbc:DecisionReasonCode -->
		<!-- Tender Identifier Reference (OPT-320): eForms documentation cardinality (LotResult) = * | efac:LotTender​/cbc:ID -->
		<!-- Framework Estimated Value (BT-660): eForms documentation cardinality (LotResult) = ? | eForms Regulation Annex table conditions = Optional (O or EM or CM) for CAN subtypes 25-27, 29-31, 33, 34 and E4, CM subtypes 38-40 and E5; Forbidden (blank) for all other subtypes efac:FrameworkAgreementValues​/cbc:EstimatedMaximumValueAmount -->
		<!-- Framework Maximum Value (BT-709): eForms documentation cardinality (LotResult) = ? | eForms Regulation Annex table conditions = Optional (O or EM or CM) for CAN subtypes 25-27, 29-31, 33, 34 and E4, CM subtypes 38-40 and E5; Forbidden (blank) for all other subtypes efac:FrameworkAgreementValues​/cbc:MaximumValueAmount -->
		
		
		<!-- Received Submissions Type (BT-760): eForms documentation cardinality (LotResult) = * | eForms Regulation Annex table conditions = Mandatory (M) for CAN subtypes 29-37; Optional (O or EM or CM) for CAN subtype E4, CM subtype E5; Forbidden (blank) for all other subtypes efac:ReceivedSubmissionsStatistics​/efbc:StatisticsCode -->
		<!-- Received Submissions Count (BT-759): eForms documentation cardinality (LotResult) = * | eForms Regulation Annex table conditions = Mandatory (M) for CAN subtypes 29-37; Optional (O or EM or CM) for CAN subtype E4, CM subtype E5; Forbidden (blank) for all other subtypes efac:ReceivedSubmissionsStatistics​/efbc:StatisticsNumeric -->

		<!-- Contract Identifier Reference (OPT-315): eForms documentation cardinality (LotResult) = * | efac:SettledContract​/cbc:ID -->
		<!-- Vehicle Type (OPT-155): eForms documentation cardinality (LotResult) = * | efac:StrategicProcurementStatistics​/efbc:StatisticsCode -->
		<!-- Vehicle Numeric (OPT-156): eForms documentation cardinality (LotResult) = * | efac:StrategicProcurementStatistics​/efbc:StatisticsNumeric -->
		<!-- Result Lot Identifier (BT-13713): eForms documentation cardinality (LotResult) = 1 | efac:TenderLot​/cbc:ID -->
		
		
		
	<!-- efac:LotTender -->
		<!-- Tender Technical Identifier (OPT-321): eForms documentation cardinality (LotTender) = 1 | cbc:ID -->
		
		<!-- Tender Rank (BT-171): eForms documentation cardinality (LotTender) = ? | eForms Regulation Annex table conditions = Optional (O or EM or CM) for CAN subtypes 25-27, 29-31, 33, 34, 36, 37 and E4, CM subtypes 38-40 and E5; Forbidden (blank) for all other subtypes cbc:RankCode -->
		<!-- Kilometers Public Transport (OPP-080): eForms documentation cardinality (LotTender) = 1 (T02 form only) | efbc:PublicTransportationCumulatedDistance -->
		<!-- Tender Variant (BT-193): eForms documentation cardinality (LotTender) = ? | eForms Regulation Annex table conditions = Mandatory (M) for CAN subtype 30; Optional (O or EM or CM) for CAN subtypes 29, 31-37 and E4, CM subtype E5; Forbidden (blank) for all other subtypes efbc:TenderVariantIndicator -->
		<!-- Tender Value (BT-720): eForms documentation cardinality (LotTender) = ? | eForms Regulation Annex table conditions = Mandatory (M) for CM subtypes 38-40 and 35; Optional (O or EM or CM) for CAN subtypes 25-35 and E4; Forbidden (blank) for all other subtypes cac:LegalMonetaryTotal​/cbc:PayableAmount *ORDER* -->
		<!-- Tender Payment Value (BT-779): eForms documentation cardinality (LotTender) = ? | eForms Regulation Annex table conditions = Mandatory (M) for CM subtype E5; Forbidden (blank) for all other subtypes efac:AggregatedAmounts​/cbc:PaidAmount *ORDER* -->
		<!-- Tender Payment Value Additional Information (BT-780): eForms documentation cardinality (LotTender) = ? | eForms Regulation Annex table conditions = Optional (O or EM or CM) for CM subtype E5; Forbidden (blank) for all other subtypes efac:AggregatedAmounts​/efbc:PaidAmountDescription *ORDER* -->
		<!-- Tender Penalties (BT-782): eForms documentation cardinality (LotTender) = ? | eForms Regulation Annex table conditions = Mandatory (M) for CM subtype E5; Forbidden (blank) for all other subtypes efac:AggregatedAmounts​/efbc:PenaltiesAmount *ORDER* -->
		<!-- Concession Revenue Buyer (BT-160): eForms documentation cardinality (LotTender) = ? | eForms Regulation Annex table conditions = Mandatory (M) for CAN subtypes 32 and 35; Optional (O or EM or CM) for CAN subtypes 28 and E4, CM subtypes 40 and E5; Forbidden (blank) for all other subtypes efac:ConcessionRevenue​/efbc:RevenueBuyerAmount -->
		<!-- Concession Revenue User (BT-162): eForms documentation cardinality (LotTender) = ? | eForms Regulation Annex table conditions = Mandatory (M) for CAN subtypes 32 and 35; Optional (O or EM or CM) for CAN subtypes 28 and E4, CM subtypes 40 and E5; Forbidden (blank) for all other subtypes efac:ConcessionRevenue​/efbc:RevenueUserAmount -->
		<!-- Concession Value Description (BT-163): eForms documentation cardinality (LotTender) = ? | eForms Regulation Annex table conditions = Mandatory (M) for CAN subtypes 32 and 35; Optional (O or EM or CM) for CAN subtypes 28 and E4, CM subtypes 40 and E5; Forbidden (blank) for all other subtypes efac:ConcessionRevenue​/efbc:ValueDescription -->
		<!-- Penalties and Rewards Code (OPP-033): eForms documentation cardinality (LotTender) = ? (T02 form only) | efac:ContractTerm​/efbc:TermCode[@listName='rewards-penalties'] -->
		<!-- Penalties and Rewards Description (OPP-034): eForms documentation cardinality (LotTender) = ? (T02 form only) | efac:ContractTerm[efbc:TermCode​/@listName='rewards-penalties']​/efbc:TermDescription -->
		<!-- Contract conditions Code (OPP-030): eForms documentation cardinality (LotTender) = * (T02 form only) | efac:ContractTerm​/efbc:TermCode[@listName='contract-term'] -->
		<!-- Contract conditions Description (other than revenue allocation) (OPP-031): eForms documentation cardinality (LotTender) = * (T02 form only) | efac:ContractTerm[not(efbc:TermCode​/text()='all-rev-tic')][efbc:TermCode​/@listName='contract-term']​/efbc:TermDescription -->
		<!-- Revenues Allocation (OPP-032): eForms documentation cardinality (LotTender) = ? (T02 form only) | efac:ContractTerm[efbc:TermCode​/text()='all-rev-tic']​/efbc:TermPercent -->
		<!-- Country Origin (BT-191): eForms documentation cardinality (LotTender) = ? | eForms Regulation Annex table conditions = Optional (O or EM or CM) for CAN subtype 30; Forbidden (blank) for all other subtypes efac:Origin​/efbc:AreaCode *ORDER* -->
		<!-- Subcontracting Value (BT-553): eForms documentation cardinality (LotTender) = 1 | eForms Regulation Annex table conditions = Optional (O or EM or CM) for CAN subtypes 25-35 and E4, CM subtypes 38-40 and E5; Forbidden (blank) for all other subtypes efac:SubcontractingTerm​/efbc:TermAmount -->
		<!-- Subcontracting Description (BT-554): eForms documentation cardinality (LotTender) = 1 | eForms Regulation Annex table conditions = Optional (O or EM or CM) for CAN subtypes 25-35 and E4, CM subtypes 38-40 and E5; Forbidden (blank) for all other subtypes efac:SubcontractingTerm​/efbc:TermDescription -->
		<!-- Subcontracting Percentage (BT-555): eForms documentation cardinality (LotTender) = 1 | eForms Regulation Annex table conditions = Optional (O or EM or CM) for CAN subtypes 25-35 and E4, CM subtypes 38-40 and E5; Forbidden (blank) for all other subtypes efac:SubcontractingTerm​/efbc:TermPercent -->
		<!-- Subcontracting (BT-773): eForms documentation cardinality (LotTender) = ? | eForms Regulation Annex table conditions = Mandatory (M) for CAN subtypes 29-31; Optional (O or EM or CM) for CAN subtypes 25-28, 32-35 and E4, CM subtypes 38-40 and E5; Forbidden (blank) for all other subtypes efac:SubcontractingTerm​/efbc:TermCode -->
		<!-- Subcontracting Percentage Known (BT-731): eForms documentation cardinality (LotTender) = ? | eForms Regulation Annex table conditions = Optional (O or EM or CM) for CAN subtypes 25-35 and E4, CM subtypes 38-40 and E5; Forbidden (blank) for all other subtypes efac:SubcontractingTerm​/efbc:PercentageKnownIndicator -->
		
		<!-- Subcontracting Value Known (BT-730): eForms documentation cardinality (LotTender) = ? | eForms Regulation Annex table conditions = Optional (O or EM or CM) for CAN subtypes 25-35 and E4, CM subtypes 38-40 and E5; Forbidden (blank) for all other subtypes efac:SubcontractingTerm​/efbc:ValueKnownIndicator -->
		<!-- Tendering Party ID Reference (OPT-310) eForms documentation cardinality (LotTender) = 1 | efac:TenderingParty​/cbc:ID -->
		
		<!-- Tender Lot Identifier (BT-13714): eForms documentation cardinality (LotTender) = 1 | eForms Regulation Annex table conditions = Optional (O or EM or CM) for CAN subtypes 25-37 and E4, CM subtypes 38-40 and E5; Forbidden (blank) for all other subtypes efac:TenderLot​/cbc:ID -->
		<!-- Tender Identifier (BT-3201): eForms documentation cardinality (LotTender) = 1 | eForms Regulation Annex table conditions = Mandatory (M) for CAN subtypes 29-37 and E4, CM subtypes 38-40 and E5; Optional (O or EM or CM) for CAN subtypes 25-28; Forbidden (blank) for all other subtypes efac:TenderReference​/cbc:ID -->
		
		
	<!-- efac:SettledContract -->
		<!-- Contract Technical Identifier (OPT-316): eForms documentation cardinality (SettledContract) = 1 | cbc:ID -->
		<!-- Winner Decision Date (BT-1451): eForms documentation cardinality (SettledContract) = ? | eForms Regulation Annex table conditions = Mandatory (M) for CAN subtype 36, Optional (O or EM or CM) for CAN subtypes 25-35, 37 and E4, CM subtypes 38-40 and E5; Forbidden (blank) for all other subtypes cbc:AwardDate -->
		<!-- Contract Conclusion Date (BT-145): eForms documentation cardinality (SettledContract) = ? | eForms Regulation Annex table conditions = Mandatory (M) for CM subtypes 38-40 and E5; Optional (O or EM or CM) for CAN subtypes 29-37 and E4; Forbidden (blank) for all other subtypes cbc:IssueDate -->
		<!-- Contract Title (BT-721): eForms documentation cardinality (SettledContract) = ? | eForms Regulation Annex table conditions = Optional (O or EM or CM) for CAN subtypes 25-37 and E4, CM subtypes 38-40 and E5; Forbidden (blank) for all other subtypes cbc:Title -->

		<!-- Contract URL (BT-151): eForms documentation cardinality (SettledContract) = ? | eForms Regulation Annex table conditions = Optional (O or EM or CM) for CAN subtypes 29-37 and E4, CM subtypes 38-40 and E5; Forbidden (blank) for all other subtypes cbc:URI -->
		
		<!-- Contract Framework Agreement (BT-768): eForms documentation cardinality (SettledContract) = ? | eForms Regulation Annex table conditions = Optional (O or EM or CM) for CAN subtypes 29-35 and E4, CM subtype E5; Forbidden (blank) for all other subtypes efbc:ContractFrameworkIndicator -->
		<!-- Framework Notice Identifier (OPT-100): eForms documentation cardinality (SettledContract) = ? | cac:NoticeDocumentReference/cbc:ID -->
		<!-- Signatory Identifier Reference (OPT-300): eForms documentation cardinality (SettledContract) = + | cac:SignatoryParty​/cac:PartyIdentification​/cbc:ID -->
		<!-- Contract Identifier (BT-150): eForms documentation cardinality (SettledContract) = 1 | eForms Regulation Annex table conditions = Mandatory (M) for CAN subtypes 25-35 and E4, CM subtype E5; Optional (O or EM or CM) for CM subtypes 38-40; Forbidden (blank) for all other subtypes efac:ContractReference​/cbc:ID -->
		<!-- Assets related contract extension indicator (OPP-020): eForms documentation cardinality (SettledContract) = 1 (T02 form only) | efac:DurationJustification​/efbc:ExtendedDurationIndicator -->
		<!-- Used asset (OPP-021): eForms documentation cardinality (SettledContract) = * (T02 form only) | efac:DurationJustification​/efac:AssetsList​/efac:Asset​/efbc:AssetDescription -->
		<!-- Significance (%) (OPP-022): eForms documentation cardinality (SettledContract) = * (T02 form only) | efac:DurationJustification​/efac:AssetsList​/efac:Asset​/efbc:AssetSignificance -->
		<!-- Predominance (%) (OPP-023): eForms documentation cardinality (SettledContract) = * (T02 form only) | efac:DurationJustification​/efac:AssetsList​/efac:Asset​/efbc:AssetPredominance -->
		<!-- Contract Tender ID (Reference, BT-3202): eForms documentation cardinality (SettledContract) = + | eForms Regulation Annex table conditions = Mandatory (M) for CAN subtypes 25-35 and E4, CM subtype E5; Optional (O or EM or CM) for CM subtypes 38-40; Forbidden (blank) for all other subtypes efac:LotTender​/cbc:ID *ORDER* -->
		<!-- Contract EU Funds Identifier (BT-5011): eForms documentation cardinality (SettledContract) = ? | eForms Regulation Annex table conditions = Optional (O or EM or CM) for CAN subtypes 25-37 and E4, CM subtypes 38-40 and E5; Forbidden (blank) for all other subtypes efac:Funding​/cbc:FundingProgramCode -->
		<!-- Contract EU Funds Name (BT-722): eForms documentation cardinality (SettledContract) = ? | eForms Regulation Annex table conditions = Optional (O or EM or CM) for CAN subtypes 25-37 and E4, CM subtypes 38-40 and E5; Forbidden (blank) for all other subtypes efac:Funding​/cbc:FundingProgram -->


		<xsl:for-each select="$ted-contractor-groups-unique-with-id//contractor-group">
			<efac:TenderingParty>
				<!-- Tendering Party ID (OPT-210): eForms documentation cardinality (TenderingParty) = 1 | cbc:ID -->
				<cbc:ID schemeName="tendering-party"><xsl:value-of select="../tpaid"/></cbc:ID>
				<xsl:variable name="ted-contractor-count" select="fn:count(ted-contractor)"/>
				<xsl:for-each select="ted-contractor">
					<efac:Tenderer>
						<!-- Tenderer ID Reference (OPT-300): eForms documentation cardinality (TenderingParty) = + -->
						<cbc:ID schemeName="organization"><xsl:value-of select="."/></cbc:ID>
						<!-- Tendering Party Leader (OPT-170): eForms documentation cardinality (TenderingParty) = * -->
						<!-- Assume if more than one CONTRACTOR that the first one is a Group Leader -->
						<xsl:if test="$ted-contractor-count > 1">
							<xsl:choose>
								<xsl:when test="fn:position() = 1">
									<efbc:GroupLeadIndicator>true</efbc:GroupLeadIndicator>
								</xsl:when>
								<xsl:otherwise>
									<efbc:GroupLeadIndicator>false</efbc:GroupLeadIndicator>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:if>
						<!-- Subcontractor ID Reference (OPT-301): eForms documentation cardinality (TenderingParty) = * | No equivalent element in TED XML -->
						<!-- Main Contractor ID Reference (OPT-301): eForms documentation cardinality (TenderingParty) = * | No equivalent element in TED XML -->
					</efac:Tenderer>
				</xsl:for-each>
			</efac:TenderingParty>
		</xsl:for-each>

	</efac:NoticeResult>
	<!--  -->
</xsl:template>

<!-- *** Start of Notice Value *** -->
<!-- Notice Value (BT-161): eForms documentation cardinality (LotResult) = 1 | eForms Regulation Annex table conditions = Optional (O or EM or CM) for CAN subtypes 25-35 and E4; CM subtypes 38-40 and E5; Forbidden (blank) for all other subtypes cbc:TotalAmount -->

<xsl:template match="ted:OBJECT_CONTRACT/ted:VAL_TOTAL">
	<xsl:variable name="ted-value" select="fn:normalize-space(.)"/>
	<xsl:variable name="currency" select="fn:normalize-space(@CURRENCY)"/>
	<cbc:TotalAmount currencyID="{$currency}"><xsl:value-of select="$ted-value"/></cbc:TotalAmount>	
</xsl:template>	

<xsl:template match="ted:OBJECT_CONTRACT/ted:VAL_RANGE_TOTAL">
	<xsl:variable name="ted-value-highest" select="fn:normalize-space(ted:HIGH)"/>
	<xsl:variable name="currency" select="fn:normalize-space(@CURRENCY)"/>	
	<!--WARNING: Notice Value (BT-161) exists in this TED XML notice as a range of values (VAL_RANGE_TOTAL). In order to not lose information, the highest value given (HIGH) was used.-->
	<xsl:variable name="message">WARNING: Notice Value (BT-161) exists in this TED XML notice as a range of values (VAL_RANGE_TOTAL). In order to not lose information, the highest value given (HIGH) was used.</xsl:variable>
	<xsl:message terminate="no" select="$message"/>
	<xsl:comment><xsl:value-of select="$message"/></xsl:comment>
	<cbc:TotalAmount currencyID="{$currency}"><xsl:value-of select="$ted-value-highest"/></cbc:TotalAmount>	
</xsl:template>
<!-- *** End of Notice Value *** -->


</xsl:stylesheet>
