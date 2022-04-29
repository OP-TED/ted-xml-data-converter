<?xml version="1.0" encoding="UTF-8"?>
<!-- 
####################################################################################
#  XSLT name : ted-to-eforms
#  Version : 0.2.0
####################################################################################
 -->
<xsl:stylesheet version="2.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xlink="http://www.w3.org/1999/xlink"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:doc="http://www.pnp-software.com/XSLTdoc" 
xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:functx="http://www.functx.com" xmlns:opfun="http://data.europa.eu/p27/ted-xml-data-converter"
xmlns:ted="http://publications.europa.eu/resource/schema/ted/R2.0.9/publication" xmlns:n2016="http://publications.europa.eu/resource/schema/ted/2016/nuts" xmlns:n2021="http://publications.europa.eu/resource/schema/ted/2021/nuts"
xmlns:pin="urn:oasis:names:specification:ubl:schema:xsd:PriorInformationNotice-2" xmlns:cn="urn:oasis:names:specification:ubl:schema:xsd:ContractNotice-2" xmlns:can="urn:oasis:names:specification:ubl:schema:xsd:ContractAwardNotice-2"
xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"
xmlns:efbc="http://data.europa.eu/p27/eforms-ubl-extension-basic-components/1" xmlns:efac="http://data.europa.eu/p27/eforms-ubl-extension-aggregate-components/1" xmlns:efext="http://data.europa.eu/p27/eforms-ubl-extensions/1" 
xmlns:ccts="urn:un:unece:uncefact:documentation:2" xmlns:gc="http://docs.oasis-open.org/codelist/ns/genericode/1.0/"
exclude-result-prefixes="xs xsi fn functx doc opfun ted gc n2016 n2021 pin cn can ccts ext" >
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

<xsl:include href="functions-and-data.xslt"/>
<xsl:include href="simple.xslt"/>
<xsl:include href="award-criteria.xslt"/>
<xsl:include href="addresses.xslt"/>
<xsl:include href="procedure.xslt"/>
<xsl:include href="lot.xslt"/>
<xsl:include href="common.xslt"/>


<!-- TBD: Currently these stylesheets only cater for one form element, one language. Work is required to cater for other form elements with alternate languages -->
	
	
	
	
<!-- DEFAULT TEMPLATES -->

<!-- These templates exist to report where <xsl:apply-templates> select a TED element, but there is no matching <xsl:template> -->

<xsl:template match="*">
	<xsl:variable name="name" select="opfun:prefix-and-name(.)"/>
	<tedelement name="{$name}">
		<xsl:apply-templates select="@*|node()"></xsl:apply-templates>
	</tedelement>
</xsl:template>

<xsl:template match="@*">
	<xsl:copy/>
</xsl:template>


	
<!-- MAIN ROOT TEMPLATE -->

<!-- This is the starting template -->

<xsl:template match="/">
	<!-- terminate processing if XML file contains more than one type of form (form element name) -->
	<xsl:if test="fn:count($ted-form-elements-names) != 1">
		<xsl:message terminate="yes">ERROR: found <xsl:value-of select="fn:count($ted-form-elements-names)"/> different form types in <xsl:value-of select="document-uri(.)"/></xsl:message>
	</xsl:if>
	<xsl:apply-templates select="$ted-form-main-element"/>
</xsl:template>
	
	
	
<!-- SUPPRESSED TEMPLATES -->

<xsl:template match="ted:TECHNICAL_SECTION"/>
<xsl:template match="ted:LINKS_SECTION"/>
<xsl:template match="ted:CODED_DATA_SECTION"/>
<xsl:template match="ted:TRANSLATION_SECTION"/>
<!-- LEGAL_BASIS only occurs as direct child of the FORM ELEMENT, and is handled in <xsl:template name="notice-information"> -->
<xsl:template match="ted:LEGAL_BASIS"/>

<!-- NOTICE only occurs as direct child of the FORM ELEMENT, and is only used to select the eForms Notice subtype -->
<xsl:template match="ted:NOTICE"/>

<!-- Form ELEMENT (F01_2014, F02_2014, etc) -->
<!-- this template is called from the starting template above -->

<xsl:template match="*[@CATEGORY='ORIGINAL']">


	<!-- NOTE: all eForms dates and times should contain ISO-8601 format dates, i.e. expressed as UTC with offsets. -->
	<!-- TED date elements have no time zone associated, and TED time elements have "local time". -->
	<!-- Therefore for complete accuracy, a mapping of country codes to UTC timezone offsets is required -->
	<!-- In this initial conversion, no such mapping is used, and TED dates and times are assumed to be CET, i.e. UTC+01:00 -->

	<xsl:variable name="message">WARNING: TED date elements have no time zone associated. For all dates in this notice, the time zone is assumed to be CET, i.e. UTC+01:00 </xsl:variable>
	<xsl:message terminate="no" select="$message"/>
	<xsl:comment><xsl:value-of select="$message"/></xsl:comment>


	<xsl:element name="{opfun:get-eforms-element-name($eforms-form-type)}" namespace="{opfun:get-eforms-xmlns($eforms-form-type)}">
		<xsl:namespace name="cac" select="'urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2'"/>
		<xsl:namespace name="cbc" select="'urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2'"/>
		<xsl:namespace name="ext" select="'urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2'"/>
		<xsl:namespace name="efac" select="'http://data.europa.eu/p27/eforms-ubl-extension-aggregate-components/1'"/>
		<xsl:namespace name="efbc" select="'http://data.europa.eu/p27/eforms-ubl-extension-basic-components/1'"/>
		<xsl:namespace name="efext" select="'http://data.europa.eu/p27/eforms-ubl-extensions/1'"/>
		<xsl:namespace name="ccts" select="'urn:un:unece:uncefact:documentation:2'"/>
		<xsl:call-template name="root-extensions"/>
		<xsl:call-template name="notice-information"/>
		<xsl:call-template name="contracting-party"/>
		<xsl:call-template name="root-tendering-terms"/>
		<xsl:call-template name="root-tendering-process"/>
		<xsl:call-template name="root-procurement-project"/>
		<xsl:call-template name="procurement-project-lots"/>
	</xsl:element>
</xsl:template>











<!-- Procedure-level templates for Notice information -->

<xsl:template name="root-extensions">
	<ext:UBLExtensions>
		<ext:UBLExtension>
			<ext:ExtensionContent>
				<efext:EformsExtension>
					<xsl:if test="$eforms-form-type eq 'CAN'">
						<!-- TODO : efac:AppealsInformation : Review Requester Organization requesting for review or Review Requester Organization that requested a review request. -->
					</xsl:if>
					<xsl:if test="$ted-form-notice-type eq '14'">
						<xsl:call-template name="changes"/>
					</xsl:if>
					<xsl:if test="$eforms-notice-subtype = ('38', '39', '40')">
						<xsl:call-template name="contract-modification"/>
					</xsl:if>
					<xsl:if test="$eforms-form-type eq 'CAN'">
						<xsl:call-template name="notice-result"/>
					</xsl:if>
					<!-- Notice SubType (OPP-070) -->
					<xsl:comment>Notice SubType (OPP-070)</xsl:comment>
					<efac:NoticeSubType>
						<cbc:SubTypeCode listName="notice-subtype"><xsl:value-of select="$eforms-notice-subtype"/></cbc:SubTypeCode>
					</efac:NoticeSubType>
					<xsl:call-template name="organizations"/>
					<xsl:call-template name="publication"/>
				</efext:EformsExtension>
			</ext:ExtensionContent>
		</ext:UBLExtension>
	</ext:UBLExtensions>
</xsl:template>



<xsl:template name="notice-information">
	<!-- UBL version ID (UBL) -->
	<xsl:comment>UBL version ID (UBL)</xsl:comment>
	<cbc:UBLVersionID>2.3</cbc:UBLVersionID>
	<!-- Customization ID (UBL) -->
	<xsl:comment>Customization ID (UBL)</xsl:comment>
	<!-- TBD: hard-coded for now -->
	<cbc:CustomizationID>eforms-sdk-0.6</cbc:CustomizationID>
	<!-- Notice Identifier (BT-701) -->
	<xsl:comment>Notice Identifier (BT-701)</xsl:comment>
	<!-- TBD: hard-coded for now -->
	<cbc:ID>f252f386-55ac-4fa8-9be4-9f950b9904c8</cbc:ID>
	<!-- Procedure Identifier (BT-04) -->
	<xsl:comment>Procedure Identifier (BT-04)</xsl:comment>
	<!-- TBD: hard-coded for now -->
	<cbc:ContractFolderID>aff2863e-b4cc-4e91-baba-b3b85f709117</cbc:ContractFolderID>
	<!-- Notice Dispatch Date (BT-05) -->
	<xsl:comment>Notice Dispatch Date (BT-05)</xsl:comment>
	<!-- TBD: hard-coded for now, done -->
	<!--<cbc:IssueDate>2020-05-05+01:00</cbc:IssueDate>
	<cbc:IssueTime>12:00:00+01:00</cbc:IssueTime>-->
	<cbc:IssueDate><xsl:value-of select="ted:COMPLEMENTARY_INFO/ted:DATE_DISPATCH_NOTICE"/><xsl:text>+01:00</xsl:text></cbc:IssueDate>
	<cbc:IssueTime>12:00:00+01:00</cbc:IssueTime>
	<!-- Notice Version (BT-757) -->
	<xsl:comment>Notice Version (BT-757)</xsl:comment>
	<!-- TBD: hard-coded for now -->
	<cbc:VersionID>01</cbc:VersionID>
	<!-- Future Notice (BT-127) -->
	<!-- TBD: hard-coded for now -->
	<xsl:comment>Future Notice (BT-127)</xsl:comment>
	<!-- The "cbc:PlannedDate" is used for planning notices (PIN only excluded) [Notice subtypes 1,2,3, 7,8,9] to specify when the competition notice will be published. -->
	<!-- F01, F04 element is TED_EXPORT/FORM_SECTION/F01_2014/OBJECT_CONTRACT/DATE_PUBLICATION_NOTICE -->
	<!-- F16 PRIOR_INFORMATION_DEFENCE does not have an equivalent element -->
	<xsl:if test="$eforms-notice-subtype = ('1', '2', '3', '7', '8', '9')">
		<cbc:PlannedDate>2020-12-31+01:00</cbc:PlannedDate>
	</xsl:if>
	<!-- Procedure Legal Basis (BT-01) -->
	<xsl:comment>Procedure Legal Basis (BT-01)</xsl:comment>
	<cbc:RegulatoryDomain><xsl:value-of select="$legal-basis"/></cbc:RegulatoryDomain>
	<!-- Form Type (BT-03) and Notice Type (BT-02) -->
	<xsl:comment>Form Type (BT-03) and Notice Type (BT-02)</xsl:comment>
	<!-- TBD: hard-coded for now; to use tailored codelists -->
	<cbc:NoticeTypeCode listName="competition">cn-standard</cbc:NoticeTypeCode>
	<!-- Notice Official Language (BT-702) (first)-->
	<xsl:comment>Notice Official Language (BT-702) (first)</xsl:comment>
	<cbc:NoticeLanguageCode><xsl:value-of select="$eforms-first-language"/></cbc:NoticeLanguageCode>
	<xsl:for-each select="$ted-form-additional-languages">
	<!-- Notice Official Language (BT-702) (additional)-->
	<xsl:comment>Notice Official Language (BT-702) (additional)</xsl:comment>
		<cac:AdditionalNoticeLanguage>
			<cbc:ID><xsl:value-of select="opfun:get-eforms-language(.)"/></cbc:ID>
		</cac:AdditionalNoticeLanguage>
	</xsl:for-each>
</xsl:template>



<xsl:template name="changes">
	<xsl:comment> efac:changes here </xsl:comment>
</xsl:template>

<xsl:template name="contract-modification">
	<xsl:comment> efac:ContractModification here </xsl:comment>
</xsl:template>

<xsl:template name="notice-result">
	<xsl:comment> efac:NoticeResult here </xsl:comment>
</xsl:template>

<xsl:template name="publication">
	<xsl:comment> efac:Publication here </xsl:comment>
	<efac:Publication>
		<!-- Notice Publication ID (OPP-010) cardinality ? -->
		<xsl:comment>Notice Publication ID (OPP-010)</xsl:comment>
		<!-- TBD: hard-coded for now -->
		<efbc:NoticePublicationID schemeName="ojs-notice-id">12345678-2023</efbc:NoticePublicationID>
		<!-- OJEU Identifier (OPP-011) cardinality ? -->
		<xsl:comment>OJEU Identifier (OPP-011)</xsl:comment>
		<!-- TBD: hard-coded for now -->
		<efbc:GazetteID schemeName="ojs-id">123/2023</efbc:GazetteID>
		<!-- OJEU Publication Date (OPP-012) cardinality ? -->
		<xsl:comment>OJEU Publication Date (OPP-012)</xsl:comment>
		<!-- TBD: hard-coded for now -->
		<efbc:PublicationDate>2023-03-14+01:00</efbc:PublicationDate>
	</efac:Publication>
</xsl:template>

<xsl:template name="contracting-party">
	<xsl:comment> cac:ContractingParty here </xsl:comment>
	<xsl:apply-templates select="ted:CONTRACTING_BODY/ted:ADDRESS_CONTRACTING_BODY"/>
	<xsl:apply-templates select="ted:CONTRACTING_BODY/ted:ADDRESS_CONTRACTING_BODY_ADDITIONAL"/>
</xsl:template>

<!-- Procedure-level templates for Notice information end here-->









<!-- Procedure-level templates for Tendering Terms -->

<xsl:template name="root-tendering-terms">
	<xsl:comment> cac:TenderingTerms here </xsl:comment>
	<cac:TenderingTerms>
		<!-- A limited number of BTs are specified for tendering terms at root level -->
		<!-- no BTs at root level require Extensions -->
		<!-- Cross Border Law (BT-09) cardinality * No equivalent element in TED XML -->
		<xsl:comment>Cross Border Law (BT-09)</xsl:comment>
		<!-- BT-01 Legal Basis Local - Code cardinality * No equivalent element in TED XML -->
		<!-- BT-01 Legal Basis Local - Text cardinality * Element PROCUREMENT_LAW -->
		<xsl:comment>BT-01 Legal Basis Local - Text</xsl:comment>
		<xsl:apply-templates select="ted:CONTRACTING_BODY/ted:PROCUREMENT_LAW"/>
		<!-- Exclusion Grounds (BT-67) cardinality ? No Exclusion Grounds in TED XML-->
		<xsl:comment>Exclusion Grounds (BT-67)</xsl:comment>
		<!-- Lots Max Awarded (BT-33) cardinality 1 OOptional for PIN subtypes 7-9, CN subtypes 10-14, 16-24, and E3; Forbidden for other subtypes -->
		<xsl:comment>Lots Max Awarded (BT-33)</xsl:comment>
		<!-- Lots Max Allowed (BT-31) cardinality 1 Optional for PIN subtypes 7-9, CN subtypes 10-14, 16-24, and E3; Forbidden for other subtypes -->
		<xsl:comment>Lots Max Allowed (BT-31)</xsl:comment>
		<xsl:apply-templates select="//ted:LOT_DIVISION[ted:LOT_MAX_ONE_TENDERER|ted:LOT_ALL|ted:LOT_MAX_NUMBER|ted:LOT_ONE_ONLY]"/>
		<!-- Group Identifier (BT-330) cardinality 1 Optional for PIN subtypes 7-9, CN subtypes 10-14, 16-24, and E3; Forbidden for other subtypes -->
		<xsl:comment>Group Identifier (BT-330)</xsl:comment> <!-- should it have cardinality 1? No LotsGroup in TED XML -->
		<!-- Group Lot Identifier (BT-1375) cardinality 1 Optional for PIN subtypes 7-9, CN subtypes 10-14, 16-24, and E3; Forbidden for other subtypes -->
		<xsl:comment>Group Lot Identifier (BT-1375)</xsl:comment> <!-- should it have cardinality 1? No LotsGroup in TED XML -->
	</cac:TenderingTerms>
</xsl:template>



<!-- Procedure-level templates for Tendering Terms end here -->






















<!-- Procedure-level templates for Tendering Process -->



<xsl:template name="root-tendering-process">
	<xsl:comment> cac:TenderingProcess here </xsl:comment>
	<cac:TenderingProcess>
		<ext:UBLExtensions>
			<ext:UBLExtension>
				<ext:ExtensionContent>
					<efext:EformsExtension>
						<!-- Tool Name (BT-632) Optional for PIN subtypes 1-9, E1, and E2, CN subtypes 10-24 and E3; Forbidden for other subtypes -->
						<xsl:comment>Tool Name (BT-632)</xsl:comment>
						<!-- Deadline Receipt Expressions (BT-630) Mandatory for CN subtypes 10-14; Optional for CN subtypes 20 and 21; Forbidden for other subtypes -->
						<xsl:comment>Deadline Receipt Expressions (BT-630)</xsl:comment>
						<!-- Procurement Relaunch (BT-634) cardinality ? Optional for CN subtypes 10-24 and E3, CAN subtypes 29-37 and E4; Forbidden for other subtypes -->
						<!-- TBD: review after meeting on BT-634 and email from DG GROW -->
						<xsl:comment>Procurement Relaunch (BT-634)</xsl:comment>
					</efext:EformsExtension>
				</ext:ExtensionContent>
			</ext:UBLExtension>
		</ext:UBLExtensions>
		<!-- A limited number of BTs are specified for tendering process at root level -->
		
		<!-- Procedure Features (BT-88) cardinality ? Mandatory for CN subtypes 12, 13, 20, and 21; Optional for PIN subtypes 7-9, CN subtypes 10, 11, 16-19, 22-24, and E3, CAN subtypes 29-37 and E4, CM subtype E5; Forbidden for other subtypes -->
		<xsl:call-template name="main-features-award"/>	
		
		
		<!-- Procedure Type (BT-105) cardinality 1 Mandatory for CN subtypes 10, 11, 16-18, 23, and 24, CAN subtypes 25-31, 36, and 37; Optional for PIN subtypes 7-9, CN subtypes 12, 13, 20-22, and E3, CAN subtypes 33, 34, and E4, CM subtype E5; Forbidden for other subtypes -->
		<xsl:comment>Procedure Type (BT-105)</xsl:comment>
		<xsl:apply-templates select="ted:PROCEDURE/(ted:PT_OPEN|ted:PT_RESTRICTED|ted:PT_COMPETITIVE_NEGOTIATION|ted:PT_COMPETITIVE_DIALOGUE|ted:PT_INNOVATION_PARTNERSHIP|ted:PT_INVOLVING_NEGOTIATION|ted:PT_NEGOTIATED_WITH_PRIOR_CALL)"/>
		<!-- Lots All Required (BT-763) cardinality ? No equivalent element in TED XML -->
		<xsl:comment>Lots All Required (BT-763)</xsl:comment>
		<!-- PIN Competition Termination (BT-756) cardinality ? Optional for CAN subtypes 29, 30, 33, and 34; Forbidden for other subtypes -->
		<xsl:comment>PIN Competition Termination (BT-756)</xsl:comment>
		
		<!-- Previous Planning Identifier (BT-125) cardinality - Forbidden for CM subtypes 38-40 and E5; Optional for other subtypes. -->
		<xsl:comment>Previous Planning Identifier (BT-125)</xsl:comment>
		<!-- TBD: Discussion about methods of linking to previous notices is ongoing. This mapping/conversion may change. -->
		<!-- TBD: When the notice linked to is of type PIN Only, BT-125 and BT-1251 should be specified at Lot level, not at notice level. -->
		
		<xsl:apply-templates select="ted:PROCEDURE/ted:NOTICE_NUMBER_OJ"/>
		
		<!-- Previous Planning Part Identifier (BT-1251) cardinality - Forbidden for CM subtypes 38-40 and E5; Optional for other subtypes. No equivalent element in TED XML. -->
		<xsl:comment>Previous Planning Part Identifier (BT-1251)</xsl:comment>
		
		<!-- Procedure Accelerated (BT-106) cardinality ? Optional for CN subtypes 16-18 and E3, CAN subtypes 29-31 and E4, CM subtype E5; Forbidden for other subtypes -->
		<!-- Procedure Accelerated Justification (BT-1351) cardinality ? Optional for CN subtypes 16-18 and E3, CAN subtypes 29-31 and E4, CM subtype E5; Forbidden for other subtypes
 -->
		<xsl:apply-templates select="ted:PROCEDURE/ted:ACCELERATED_PROC"/>
		<!-- Direct Award Justification Previous Procedure Identifier (BT-1252) cardinality ? Optional for CAN subtypes 25-35 and E4, CM subtype E5; Forbidden for other subtypes -->
		<xsl:comment>Direct Award Justification Previous Procedure Identifier (BT-1252)</xsl:comment>
		<!-- Direct Award Justification (BT-136) ​/ Code cardinality ? Optional for CAN subtypes 25-35 and E4, CM subtype E5; Forbidden for other subtypes -->
		<xsl:comment>Direct Award Justification (BT-136)</xsl:comment>
		<!-- Direct Award Justification (BT-135) ​/ Text cardinality ? Optional for CAN subtypes 25-35 and E4, CM subtype E5; Forbidden for other subtypes -->
		<xsl:comment>Direct Award Justification (BT-135)</xsl:comment>
	</cac:TenderingProcess>
</xsl:template>


<!-- Procedure-level templates for Tendering Process end here -->














<!-- Procedure-level templates for Procurement Project -->


<xsl:template name="root-procurement-project">
	<xsl:comment> cac:ProcurementProject here </xsl:comment>
	<cac:ProcurementProject>
		<!-- A limited number of BTs are specified for procurement project at root level -->
		<!-- Internal Identifier (BT-22) cardinality 1 Optional for ALL Notice subtypes -->
		<xsl:comment>Internal Identifier (BT-22)</xsl:comment>
		<xsl:apply-templates select="ted:OBJECT_CONTRACT/ted:REFERENCE_NUMBER"/>
		<!-- Title (BT-21) cardinality 1 Mandatory for ALL Notice subtypes, except Optional for CM Notice subtypes 38-40 -->
		<xsl:comment>Title (BT-21)</xsl:comment>
		<xsl:apply-templates select="ted:OBJECT_CONTRACT/ted:TITLE"/>
		<!-- Description (BT-24) cardinality 1 Mandatory for ALL Notice subtypes -->
		<xsl:comment>Description (BT-24)</xsl:comment>
		<xsl:apply-templates select="ted:OBJECT_CONTRACT/ted:SHORT_DESCR"/>
		<!-- Main Nature (BT-23) cardinality 1 Optional for ALL Notice subtypes -->
		<xsl:comment>Main Nature (BT-23)</xsl:comment>
		<xsl:apply-templates select="ted:OBJECT_CONTRACT/ted:TYPE_CONTRACT"/>
		<!-- Additional Nature (different from Main) (BT-531) cardinality * No equivalent element in TED XML -->
		<!-- Additional Information (BT-300) cardinality ? Optional for ALL Notice subtypes -->
		<xsl:comment>Additional Information (BT-300)</xsl:comment>
		<xsl:apply-templates select="ted:COMPLEMENTARY_INFO/ted:INFO_ADD"/>
		
		<!-- Estimated Value (BT-27) cardinality ? -->
		<xsl:comment>Estimated Value (BT-27)</xsl:comment>
		<xsl:apply-templates select="ted:OBJECT_CONTRACT/ted:VAL_ESTIMATED_TOTAL"/>
		<!-- Classification Type (e.g. CPV) (BT-26) cardinality 1 Mandatory for ALL Notice subtypes, except Optional for CM Notice subtypes 38-40 -->
		<!-- Main Classification Code (BT-262) cardinality 1 Mandatory for ALL Notice subtypes, except Optional for CM Notice subtypes 38-40 -->
		<xsl:comment>Main Classification Code (BT-262)</xsl:comment>
		<xsl:apply-templates select="ted:OBJECT_CONTRACT/ted:CPV_MAIN"/>
		<!-- Additional Classification Code (BT-263) cardinality * No equivalent element in TED XML at Procedure level -->
		<xsl:comment>Additional Classification Code (BT-263)</xsl:comment>
		<!-- Place of Performance (*) -> RealizedLocation No equivalent element in TED XML at Procedure level -->
		<!-- No location elements exist in TED F02 schema at Procedure level. TBD: Question: if NO_LOT_DIVISION, should we copy the location details from the single Lot in OBJECT_DESCR? -->
			<!-- Place of Performance Additional Information (BT-728) -->
			<xsl:comment>Place of Performance Additional Information (BT-728)</xsl:comment>
			<!-- Place Performance City (BT-5131) -->
			<xsl:comment>Place Performance City (BT-5131)</xsl:comment>
			<!-- Place Performance Post Code (BT-5121) -->
			<xsl:comment>Place Performance Post Code (BT-5121)</xsl:comment>
			<!-- Place Performance Country Subdivision (BT-5071) -->
			<xsl:comment>Place Performance Country Subdivision (BT-5071)</xsl:comment>
			<!-- Place Performance Services Other (BT-727) -->
			<xsl:comment>Place Performance Services Other (BT-727)</xsl:comment>
			<!-- Place Performance Street (BT-5101) -->
			<xsl:comment>Place Performance Street (BT-5101)</xsl:comment>
			<!-- Place Performance Country Code (BT-5141) -->
			<xsl:comment>Place Performance Country Code (BT-5141)</xsl:comment>
	</cac:ProcurementProject>
</xsl:template>


<!-- Procedure-level templates for Procurement Project end here -->










<!-- Initial template to process each Lot -->


<xsl:template name="procurement-project-lots">
	<xsl:comment> multiple cac:ProcurementProjectLot here </xsl:comment>
			<xsl:apply-templates select="ted:OBJECT_CONTRACT/ted:OBJECT_DESCR"/>
</xsl:template>


</xsl:stylesheet>
