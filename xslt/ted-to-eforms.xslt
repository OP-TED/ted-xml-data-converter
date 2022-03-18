<?xml version="1.0" encoding="UTF-8"?>
<!-- 
####################################################################################
#  XSL name : ted-to-eforms
#  Version : 0.01
# TESTING VERSION                                     
####################################################################################
 -->
<xsl:stylesheet version="2.0"  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xlink="http://www.w3.org/1999/xlink"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:functx="http://www.functx.com" 
xmlns:doc="http://www.pnp-software.com/XSLTdoc" xmlns:opfun="http://publications.europa.eu/local/xslt-functions"
xmlns:ted="http://publications.europa.eu/resource/schema/ted/R2.0.9/publication" xmlns:n2016="http://publications.europa.eu/resource/schema/ted/2016/nuts" 
xmlns:efbc="http://data.europa.eu/p27/eforms-ubl-extension-basic-components/1" xmlns:efac="http://data.europa.eu/p27/eforms-ubl-extension-aggregate-components/1" xmlns:efext="http://data.europa.eu/p27/eforms-ubl-extensions/1" xmlns:pin="urn:oasis:names:specification:ubl:schema:xsd:PriorInformationNotice-2" xmlns:cn="urn:oasis:names:specification:ubl:schema:xsd:ContractNotice-2" xmlns:can="urn:oasis:names:specification:ubl:schema:xsd:ContractAwardNotice-2"
xmlns:ccts="urn:un:unece:uncefact:documentation:2" xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
xmlns:gc="http://docs.oasis-open.org/codelist/ns/genericode/1.0/"
exclude-result-prefixes="xlink xs xsi fn functx doc opfun ted gc n2016 pin cn can ccts " 
>
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

<xsl:include href="functions-and-data.xslt"/>
<xsl:include href="ted-to-eforms-simple.xslt"/>
<xsl:include href="ted-to-eforms-award-criteria.xslt"/>
<xsl:include href="ted-to-eforms-addresses.xslt"/>
<xsl:include href="ted-to-eforms-procedure.xslt"/>
<xsl:include href="ted-to-eforms-lot.xslt"/>


<!-- TBD : Currently these styleshets only cater for one form element, one language. Work is required to cater for other form elements with alternate languages -->
	
	
	
	
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

<!-- In TED, within element CONTRACTING_BODY, the elements ADDRESS_FURTHER_INFO_IDEM and ADDRESS_PARTICIPATION_IDEM are used to represent options for "to the abovementioned address" in the PDF forms. -->
<!-- These indicate that for the functions of "Additional information can be obtained from" and "Tenders or requests to participate must be submitted to", the Contracting Authority address should be used. -->
<!-- in eForms, such a direction is implicit, and no such elements are used. So the element ADDRESS_FURTHER_INFO_IDEM will not be mapped. -->
<!-- However, the element ADDRESS_PARTICIPATION_IDEM may exist with a sibling element URL_PARTICIPATION, which is mapped to the element cbc:EndpointID within cac:TenderRecipientParty. -->
<!-- In this case, it does not make sense to include cac:TenderRecipientParty without pointing to the correct address, so ADDRESS_PARTICIPATION_IDEM will be mapped if it has a URL_PARTICIPATION sibling -->
<xsl:template match="ted:ADDRESS_FURTHER_INFO_IDEM"/>


<!-- Form ELEMENT (F01_2014, F02_2014, etc) -->
<!-- this template is called from the starting template above -->

<xsl:template match="*[@CATEGORY='ORIGINAL']">
	<xsl:element name="{opfun:get-eforms-element-name($ubl-xsd-type)}" namespace="{opfun:get-eforms-xmlns($ubl-xsd-type)}">
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
						<cbc:SubTypeCode><xsl:value-of select="$eforms-notice-subtype"/></cbc:SubTypeCode>
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
	<cbc:CustomizationID>eforms-sdk-0.4</cbc:CustomizationID>
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

<xsl:template name="organizations">
	<xsl:comment> efac:Organizations here </xsl:comment>
	<xsl:variable name="is-joint-procurement" select="fn:boolean(ted:CONTRACTING_BODY/ted:JOINT_PROCUREMENT_INVOLVED)"/>
	<xsl:variable name="is-central-purchasing" select="fn:boolean(ted:CONTRACTING_BODY/ted:CENTRAL_PURCHASING)"/>
	<efac:Organizations>
		<!-- there are no F##_2014 forms that do not have ADDRESS_CONTRACTING_BODY -->
		<xsl:for-each select="$tedaddressesuniquewithid//ted-org/tedaddress">
			<efac:Organization>
				<!-- Organization Role : Acquiring CPB -->
				<xsl:comment>Organization Role : Acquiring CPB</xsl:comment>
				<!-- efbc:AcquiringCPBIndicator, used for central purchasing, only on Contracting Body addresses -->
				<!-- For Acquiring CPB, the element "efbc:AcquiringCPBIndicator" must either be omitted for all Buyers, or included for all Buyers, at least one of which should have the value "true". -->
				<xsl:if test="$is-central-purchasing and (../path[fn:contains(., 'ADDRESS_CONTRACTING_BODY')])">
					<efbc:AcquiringCPBIndicator>
						<xsl:choose>
							<xsl:when test="../path[fn:contains(., 'ADDRESS_CONTRACTING_BODY_ADDITIONAL')]">false</xsl:when>
							<xsl:otherwise>true</xsl:otherwise>
						</xsl:choose>
					</efbc:AcquiringCPBIndicator>
				</xsl:if>
				<!-- Organization Subrole (BT-770) : Group leader (Buyer)-->
				<xsl:comment>Organization Subrole (BT-770) : Group leader (Buyer)</xsl:comment>
				<!-- efbc:GroupLeadIndicator, used for joint procurement, only on Contracting Body addresses -->
				<xsl:if test="$is-joint-procurement and (../path[fn:contains(., 'ADDRESS_CONTRACTING_BODY')])">
					<efbc:GroupLeadIndicator>
						<xsl:choose>
							<xsl:when test="../path[fn:contains(., 'ADDRESS_CONTRACTING_BODY_ADDITIONAL')]">false</xsl:when>
							<xsl:otherwise>true</xsl:otherwise>
						</xsl:choose>
					</efbc:GroupLeadIndicator>
				</xsl:if>
				<efac:Company>
					<xsl:call-template name="org-address"/>
				</efac:Company>
			</efac:Organization>
		</xsl:for-each>
	</efac:Organizations>
	<!--
	These instructions can be un-commented to show the variables holding the organization addresses at intermediate stages
	<xsl:copy-of select="$tedaddresses"/>
	<xsl:copy-of select="$tedaddressesunique"/>
	<xsl:copy-of select="$tedaddressesuniquewithid"/>
	-->

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
		<xsl:apply-templates select="ted:CONTRACTING_BODY/ted:PROCUREMENT_LAW"/>
		<!-- Exclusion Grounds (BT-67) cardinality ? No Exclusion Grounds in TED XML-->
		<xsl:comment>Exclusion Grounds (BT-67)</xsl:comment>
		<!-- Lots Max Awarded (BT-33) cardinality 1 Optional for subtypes PIN 7,8,9, CN 10-14, 16-24. Forbidden for all other Notice subtype -->
		<xsl:comment>Lots Max Awarded (BT-33)</xsl:comment>
		<!-- Lots Max Allowed (BT-31) cardinality 1 -->
		<xsl:comment>Lots Max Allowed (BT-31)</xsl:comment>
		<xsl:apply-templates select="//ted:LOT_DIVISION[ted:LOT_MAX_ONE_TENDERER|ted:LOT_ALL|ted:LOT_MAX_NUMBER|ted:LOT_ONE_ONLY]"/>
		<!-- Group Identifier (BT-330) cardinality 1 -->
		<xsl:comment>Group Identifier (BT-330)</xsl:comment> <!-- should it have cardinality 1? No LotsGroup in TED XML -->
		<!-- Group Lot Identifier (BT-1375) cardinality 1 -->
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
						<!-- Tool Name (BT-632) -->
						<xsl:comment>Tool Name (BT-632)</xsl:comment>
						<!-- Deadline Receipt Expressions (BT-630) -->
						<xsl:comment>Deadline Receipt Expressions (BT-630)</xsl:comment>
						<!-- Procurement Relaunch (BT-634) cardinality >? Note: review after meeting on BT-634 and email from Carmen -->
						<xsl:comment>Procurement Relaunch (BT-634)</xsl:comment>
					</efext:EformsExtension>
				</ext:ExtensionContent>
			</ext:UBLExtension>
		</ext:UBLExtensions>
		<!-- A limited number of BTs are specified for tendering process at root level -->
		
		<!-- Procedure Features (BT-88) cardinality ? - for Lots, Forbiden for eForms (Contract Notice)? subtypes 1-6, E2, 14, 15, 25-28, 38-40; Optional for 7-11, 16-19, E3, 22-24, 29-37, E5; Mandatory for 12, 13, 20, 21. The equivalent TED XML is MAIN_FEATURES_AWARD element-->
		<xsl:call-template name="main-features-award"/>	
		
		
		<!-- Procedure Type (BT-105) cardinality 1 Maps from elements: PT_OPEN, PT_RESTRICTED, PT_COMPETITIVE_NEGOTIATION, PT_COMPETITIVE_DIALOGUE, PT_INNOVATION_PARTNERSHIP -->
		<xsl:comment>Procedure Type (BT-105)</xsl:comment>
		<xsl:apply-templates select="ted:PROCEDURE/(ted:PT_OPEN|ted:PT_RESTRICTED|ted:PT_COMPETITIVE_NEGOTIATION|ted:PT_COMPETITIVE_DIALOGUE|ted:PT_INNOVATION_PARTNERSHIP|ted:PT_INVOLVING_NEGOTIATION|ted:PT_NEGOTIATED_WITH_PRIOR_CALL)"/>
		<!-- PIN Competition Termination (BT-756) cardinality ? This BT only allowed for CAN notice subtypes 29, 30, 33, 34 -->
		<xsl:comment>PIN Competition Termination (BT-756)</xsl:comment>
		<!-- Lots All Required (BT-763) cardinality ? No equivalent element in TED XML -->
		<xsl:comment>Lots All Required (BT-763)</xsl:comment>
		<!-- Procedure Accelerated (BT-106), Procedure Accelerated Justification (BT-1351) -->
		<xsl:apply-templates select="ted:PROCEDURE/ted:ACCELERATED_PROC"/>
		<!-- Direct Award Justification Previous Procedure Identifier (BT-1252) cardinality ? this BT only allowed for CAN notice subtypes 25 to 35 and E4, E5 -->
		<xsl:comment>Direct Award Justification Previous Procedure Identifier (BT-1252)</xsl:comment>
		<!-- Direct Award Justification (BT-136) ​/ Code cardinality ? -->
		<xsl:comment>Direct Award Justification (BT-136)</xsl:comment>
		<!-- Direct Award Justification (BT-135) ​/ Text cardinality ? -->
		<xsl:comment>Direct Award Justification (BT-135)</xsl:comment>
	</cac:TenderingProcess>
</xsl:template>


<!-- Procedure-level templates for Tendering Process end here -->














<!-- Procedure-level templates for Procurement Project -->


<xsl:template name="root-procurement-project">
	<xsl:comment> cac:ProcurementProject here </xsl:comment>
	<cac:ProcurementProject>
		<!-- A limited number of BTs are specified for procurement project at root level -->
		<!-- Internal Identifier (BT-22) cardinality 1 REFERENCE_NUMBER -->
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
		<!-- Additional Information (BT-300) (*)* cardinality ? No equivalent element in TED XML -->
		<xsl:comment>Additional Information (BT-300)</xsl:comment>
		<!-- Estimated Value (BT-27) cardinality ? -->
		<xsl:comment>Estimated Value (BT-27)</xsl:comment>
		<xsl:apply-templates select="ted:OBJECT_CONTRACT/ted:VAL_ESTIMATED_TOTAL"/>
		<!-- Classification Type (e.g. CPV) (BT-26) cardinality 1 Mandatory for ALL Notice subtypes, except Optional for CM Notice subtypes 38-40 -->
		<xsl:apply-templates select="ted:OBJECT_CONTRACT/ted:CPV_MAIN"/>
		<!-- Main Classification Code (BT-262) cardinality 1 Mandatory for ALL Notice subtypes, except Optional for CM Notice subtypes 38-40 -->
		<xsl:comment>Main Classification Code (BT-262)</xsl:comment>
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
