<?xml version="1.0" encoding="UTF-8"?>
<!-- 
####################################################################################
#  XSL name : ted-to-eforms
#  Version : 0.01
# TESTING VERSION                                     
####################################################################################
 -->
<xsl:stylesheet version="2.0"  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:functx="http://www.functx.com" 
xmlns:doc="http://www.pnp-software.com/XSLTdoc" xmlns:opfun="http://publications.europa.eu/local/xslt-functions"
xmlns:ted="http://publications.europa.eu/resource/schema/ted/R2.0.9/publication" xmlns:n2016="http://publications.europa.eu/resource/schema/ted/2016/nuts" 
xmlns:efbc="http://eforms/v1.0/ExtensionBasicComponents" xmlns:efac="http://eforms/v1.0/ExtensionAggregateComponents" xmlns:efext="http://eforms/v1.0/Extensions" xmlns:pin="urn:oasis:names:specification:ubl:schema:xsd:PriorInformationNotice-2" xmlns:cn="urn:oasis:names:specification:ubl:schema:xsd:ContractNotice-2" xmlns:can="urn:oasis:names:specification:ubl:schema:xsd:ContractAwardNotice-2"
xmlns:ccts="urn:un:unece:uncefact:documentation:2" xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
xmlns:gc="http://docs.oasis-open.org/codelist/ns/genericode/1.0/"
exclude-result-prefixes="xs xsi fn functx doc opfun ted gc n2016 pin cn can ccts " >
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

<xsl:include href="functions-and-data.xslt"/>
<xsl:include href="ted-to-eforms-simple.xslt"/>
<xsl:include href="ted-to-eforms-suppressed.xslt"/>
<xsl:include href="ted-to-eforms-award-criteria.xslt"/>
<xsl:include href="ted-to-eforms-addresses.xslt"/>

<!-- FUNCTIONS -->

    	
<!-- GLOBAL VARIABLES -->

	<doc:doc> Form Name </doc:doc>
	<!-- Apart from <NOTICE_UUID>, all direct children of FORM_SECTION have the same element name / form type -->
	<xsl:variable name="ted-form-elements" select="/*:TED_EXPORT/*:FORM_SECTION/*[@CATEGORY]"/> <!-- this is all the TED form elements -->
	<xsl:variable name="ted-form-main-element" select="/*:TED_EXPORT/*:FORM_SECTION/*[@CATEGORY='ORIGINAL'][1]"/> <!-- this is the TED form element to process -->
	<xsl:variable name="ted-form-additional-elements" select="/*:TED_EXPORT/*:FORM_SECTION/*[@CATEGORY][not(@CATEGORY='ORIGINAL' and not(preceding-sibling::*[@CATEGORY='ORIGINAL']))]"/> <!-- these are the other TED form elements -->
	
	<xsl:variable name="ted-form-elements-names" select="fn:distinct-values($ted-form-elements/fn:local-name())"/> <!-- F06_2014 -->
	<xsl:variable name="ted-form-element-name" select="$ted-form-main-element/fn:local-name()"/> <!-- F06_2014 or CONTRACT_DEFENCE or MOVE or OTH_NOT or ... -->
	<xsl:variable name="ted-form-name" select="$ted-form-main-element/fn:string(@FORM)"/><!-- F06 or 17 or T02 or ... -->
	<xsl:variable name="ted-form-notice-type" select="$ted-form-main-element/fn:string(*:NOTICE/@TYPE)"/><!-- '' or PRI_ONLY or AWARD_CONTRACT ... -->
	<xsl:variable name="ted-form-document-code" select="/*:TED_EXPORT/*:CODED_DATA_SECTION/*:CODIF_DATA/*:TD_DOCUMENT_TYPE/fn:string(@CODE)"/><!-- 0 or 6 or A or H ... -->
	<xsl:variable name="ted-form-first-language" select="$ted-form-main-element/fn:string(@LG)"/>
	<xsl:variable name="ted-form-additional-languages" select="$ted-form-additional-elements/fn:string(@LG)"/>
	 
	<xsl:variable name="eforms-first-language" select="opfun:get-eforms-language($ted-form-first-language)"/>
	
	<xsl:variable name="legal-basis-element" select="$ted-form-main-element/*[1]"/> <!-- the legal basis element is always the first child of the form element -->
	
	<doc:doc> Legal basis </doc:doc>
	<xsl:variable name="legal-basis">
		<xsl:choose>
			<xsl:when test="$legal-basis-element/fn:local-name() eq 'LEGAL_BASIS_OTHER'">OTHER</xsl:when>
			<xsl:otherwise><xsl:value-of select="$legal-basis-element/@VALUE"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="legal-basis-other-text" select="if ($legal-basis eq 'OTHER') then $legal-basis-element/fn:string(P) else ''"/>
	
	<doc:doc> Form Types </doc:doc>
	<!-- TODO draft, needs development -->
	<!-- TODO requires mapping of TED forms to eForms type, subtype, xsd -->
	
	<xsl:variable name="eforms-notice-subtype">
		<xsl:value-of select="opfun:get-eforms-notice-subtype($ted-form-element-name, $ted-form-name, $ted-form-notice-type, $legal-basis, $ted-form-document-code)"/>
	</xsl:variable>
	
	<xsl:variable name="eforms-subtypes-pin" as="xs:string*">
		<xsl:for-each select="1 to 9"><xsl:sequence select="xs:string(.)"/></xsl:for-each>
		<xsl:sequence select="('E1', 'E2')"/>
	</xsl:variable>

	<xsl:variable name="eforms-subtypes-cn" as="xs:string*">
		<xsl:for-each select="10 to 24"><xsl:sequence select="xs:string(.)"/></xsl:for-each>
		<xsl:sequence select="('E3')"/>
	</xsl:variable>

	<xsl:variable name="eforms-subtypes-can" as="xs:string*">
		<xsl:for-each select="25 to 40"><xsl:sequence select="xs:string(.)"/></xsl:for-each>
		<xsl:sequence select="('E4')"/>
	</xsl:variable>
	
	<xsl:variable name="eforms-form-type">
		<xsl:choose>
			<xsl:when test="$eforms-notice-subtype = $eforms-subtypes-pin"><xsl:value-of select="'PIN'"/></xsl:when>
			<xsl:when test="$eforms-notice-subtype = $eforms-subtypes-cn"><xsl:value-of select="'CN'"/></xsl:when>
			<xsl:when test="$eforms-notice-subtype = $eforms-subtypes-can"><xsl:value-of select="'CAN'"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="'UNKNOWN'"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="ubl-xsd-type">
		<xsl:choose>
			<xsl:when test="$eforms-notice-subtype = $eforms-subtypes-pin"><xsl:value-of select="'PIN'"/></xsl:when>
			<xsl:when test="$eforms-notice-subtype = $eforms-subtypes-cn"><xsl:value-of select="'CN'"/></xsl:when>
			<xsl:when test="$eforms-notice-subtype = $eforms-subtypes-can"><xsl:value-of select="'CAN'"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="'UNKNOWN'"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	

	<doc:doc> Form Language </doc:doc>
	
	<!-- TODO : currently only catering for one form , one language -->
	
	
	
	
<!-- DEFAULT TEMPLATES -->

	<xsl:template match="*">
		<xsl:variable name="name" select="opfun:prefix-and-name(.)"/>
		<element name="{$name}">
			<xsl:apply-templates select="@*|node()"></xsl:apply-templates>
		</element>
	</xsl:template>

	<xsl:template match="@*">
		<xsl:copy/>
	</xsl:template>


	
<!-- MAIN ROOT TEMPLATE -->	

	<xsl:template match="/">
		<!-- terminate processing if XML file contains more than one type of form (form element name) -->
		<xsl:if test="fn:count($ted-form-elements-names) != 1">
			<xsl:message terminate="yes">ERROR: found <xsl:value-of select="fn:count($ted-form-elements-names)"/> different form types in <xsl:value-of select="document-uri(.)"/></xsl:message>
		</xsl:if>
		<xsl:apply-templates select="$ted-form-main-element"/>
	</xsl:template>
	
	
	
<!-- SUPPRESSED TEMPLATES -->

<xsl:template match="*:TECHNICAL_SECTION"/>
<xsl:template match="*:LINKS_SECTION"/>
<xsl:template match="*:CODED_DATA_SECTION"/>
<xsl:template match="*:TRANSLATION_SECTION"/>

<!-- ROOT ELEMENT -->

<xsl:template match="*[@CATEGORY='ORIGINAL']">
	<xsl:element name="{opfun:get-eforms-element-name($ubl-xsd-type)}" namespace="{opfun:get-eforms-xmlns($ubl-xsd-type)}">
		<xsl:namespace name="cac" select="'urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2'"/>
		<xsl:namespace name="cbc" select="'urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2'"/>
		<xsl:namespace name="ext" select="'urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2'"/>
		<xsl:namespace name="efac" select="'http://eforms/v1.0/ExtensionAggregateComponents'"/>
		<xsl:namespace name="efbc" select="'http://eforms/v1.0/ExtensionBasicComponents'"/>
		<xsl:namespace name="efext" select="'http://eforms/v1.0/Extensions'"/>
		<xsl:namespace name="ccts" select="'urn:un:unece:uncefact:documentation:2'"/>
		<xsl:call-template name="root-extensions"/>
		<xsl:call-template name="notice-information"/>
		<xsl:call-template name="contracting-party"/>
		<xsl:call-template name="root-tendering-terms"/>
		<xsl:call-template name="root-tendering-process"/>
		<xsl:call-template name="root-procurement-project"/>
		<xsl:call-template name="procurement-project-lots"/>
<!--
cac:ContractingParty
cac:TenderingTerms
cac:TenderingProcess
cac:ProcurementProject
cac:ProcurementProjectLot
-->
	</xsl:element>

</xsl:template>

<xsl:template name="root-extensions">
	<ext:UBLExtensions>
		<ext:UBLExtension>
			<ext:ExtensionContent>
				<efext:EformsExtension>
<!--
			<xsd:sequence>
				<xsd:element ref="efbc:AccessToolName" minOccurs="0" maxOccurs="unbounded"/> Not relevant for Root (and contradiction in documentation)
				<xsd:element ref="efbc:ProcedureRelaunchIndicator" minOccurs="0" maxOccurs="1"/> Not relevant for Root (relevancy still to be decided)
				<xsd:element ref="efac:AnswerReceptionPeriod" minOccurs="0" maxOccurs="1"/> Not in documentation
				<xsd:element ref="efac:AppealRequestsStatistics" minOccurs="0" maxOccurs="unbounded"/> BT-712 BT-636 BT-635 Only relevant for /*/efac:NoticeResult/LotResult
				<xsd:element ref="efac:AppealsInformation" minOccurs="0" maxOccurs="unbounded"/> Only relevant for ContractAwardNotice
				<xsd:element ref="efac:AwardCriterionParameter" minOccurs="0" maxOccurs="unbounded"/> Not relevant for Root; Only relevant within cac:AwardingCriterion/cac:SubordinateAwardingCriterion
				<xsd:element ref="efac:BuyingPartyReference" minOccurs="0" maxOccurs="unbounded"/> Not in documentation
				<xsd:element ref="efac:Changes" minOccurs="0" maxOccurs="1"/> Only relevant for Root
				<xsd:element ref="efac:ContractModification" minOccurs="0" maxOccurs="unbounded"/> Only relevant for Root
				<xsd:element ref="efac:FieldsPrivacy" minOccurs="0" maxOccurs="unbounded"/> Does not exist in TED XML
				<xsd:element ref="efac:InterestExpressionReceptionPeriod" minOccurs="0" maxOccurs="1"/> Only relevant for Lot
				<xsd:element ref="efac:NoticeResult" minOccurs="0" maxOccurs="1"/> Only relevant for Root
				<xsd:element ref="efac:NoticeSubType" minOccurs="0" maxOccurs="1"/> Only relevant for Root
				<xsd:element ref="efac:Organizations" minOccurs="0" maxOccurs="1"/> Only relevant for Root
				<xsd:element ref="efac:Publication" minOccurs="0" maxOccurs="1"/> Only relevant for Root
				<xsd:element ref="efac:SelectionCriteria" minOccurs="0" maxOccurs="unbounded"/> Only relevant for Lot or LotsGroup
				<xsd:element ref="efac:StrategicProcurementStatistics" minOccurs="0" maxOccurs="unbounded"/> Only relevant within LotResult
				<xsd:element ref="efac:SubsidiaryClassification" minOccurs="0" maxOccurs="unbounded"/> Only relevant within MainCommodityClassification
				<xsd:element ref="efac:ReferencedDocumentPart" minOccurs="0" maxOccurs="unbounded"/> Not in documentation
				<xsd:element ref="efac:TenderSubcontractingRequirements" minOccurs="0" maxOccurs="unbounded"/> Only relevant for Lot in PIN and CN
			</xsd:sequence>
-->
					<xsl:if test="$eforms-form-type eq 'CAN'">
						<!-- TODO : efac:AppealsInformation : Review Requester Organization requesting for review or  Review Requester Organization that requested a review request. -->
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
					<efac:NoticeSubtype>
						<cbc:SubTypeCode><xsl:value-of select="$eforms-notice-subtype"/></cbc:SubTypeCode>
					</efac:NoticeSubtype>
					<xsl:call-template name="organizations"/>
					<xsl:call-template name="publication"/>
				</efext:EformsExtension>
			</ext:ExtensionContent>
		</ext:UBLExtension>
	</ext:UBLExtensions>
</xsl:template>



<xsl:template name="notice-information">
	<cbc:UBLVersionID>2.3</cbc:UBLVersionID>
	<!-- TBD: hard-coded for now -->
	<cbc:CustomizationID>eforms-sdk-0.4</cbc:CustomizationID>
	<!--BT-701-->
	<!-- TBD: hard-coded for now -->
	<cbc:ID>f252f386-55ac-4fa8-9be4-9f950b9904c8</cbc:ID>
	<!--BT-04-->
	<!-- TBD: hard-coded for now -->
	<cbc:ContractFolderID>aff2863e-b4cc-4e91-baba-b3b85f709117</cbc:ContractFolderID>
	<!--BT-05-->
	<!-- TBD: hard-coded for now -->
	<cbc:IssueDate>2020-05-05+01:00</cbc:IssueDate>
	<!-- TBD: hard-coded for now -->
	<cbc:IssueTime>12:00:00+01:00</cbc:IssueTime>
	<!--BT-757-->
	<!-- TBD: hard-coded for now -->
	<cbc:VersionID>01</cbc:VersionID>
	<!-- Future Notice (BT-127) TBD: hard-coded for now -->
	<!-- The "cbc:PlannedDate" is used for planning notices (PIN only excluded) [Notice subtypes 1,2,3, 7,8,9] to specify when the competition notice will be published.  -->
	<!-- F16 PRIOR_INFORMATION_DEFENCE does not have an equivalent element -->
	<xsl:if test="$eforms-notice-subtype = ('1', '2', '3', '7', '8', '9')">
		<cbc:PlannedDate>2020-12-31+01:00</cbc:PlannedDate>
	</xsl:if>
	<!--BT-01 Legal basis -->
	<cbc:RegulatoryDomain><xsl:value-of select="$legal-basis"/></cbc:RegulatoryDomain>
	<!--BT-03--> <!--BT-02-->
	<!-- TBD: hard-coded for now; to use tailored codelists -->
	<cbc:NoticeTypeCode listName="competition">cn-standard</cbc:NoticeTypeCode>
	<!--BT-702 first language -->
	<cbc:NoticeLanguageCode><xsl:value-of select="$eforms-first-language"/></cbc:NoticeLanguageCode>
	<xsl:for-each select="$ted-form-additional-languages">
		<cac:AdditionalNoticeLanguage>
			<cbc:ID><xsl:value-of select="."/></cbc:ID>
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
</xsl:template>

<xsl:template name="publication">
	<xsl:comment> efac:Publication here </xsl:comment>
	<efac:Publication>
		<!-- TBD: hard-coded for now -->
		<efbc:NoticePublicationID schemeName="ojs-notice-id">12345678-2023</efbc:NoticePublicationID>
		<!-- TBD: hard-coded for now -->
		<efbc:GazetteID schemeName="ojs-id">123/2023</efbc:GazetteID>
		<!-- TBD: hard-coded for now -->
		<efbc:PublicationDate>2023-03-14+01:00</efbc:PublicationDate>
	</efac:Publication>
</xsl:template>

<xsl:template name="contracting-party">
	<xsl:comment> cac:ContractingParty here </xsl:comment>
	<xsl:apply-templates select="*:CONTRACTING_BODY"/>
</xsl:template>
<xsl:template name="root-tendering-terms">
	<xsl:comment> cac:TenderingTerms here </xsl:comment>
	<cac:TenderingTerms>
		<!-- A limited number of BTs are specified for tendering terms at root level -->
		<!-- no BTs at root level require Extensions -->
		<!-- Cross Border Law (BT-09) cardinality * -->
		<!-- BT-01 Legal Basis Local - Code cardinality * -->
		<!-- BT-01 Legal Basis Local - Text cardinality * -->
		<!-- Exclusion Grounds (BT-67) cardinality ? -->
		<!-- Lots Max Awarded (BT-33) cardinality 1 -->
		<!-- Lots Max Allowed (BT-31) cardinality 1 -->
		<!-- Group Identifier (BT-330) cardinality 1 --> <!-- should it have cardinality 1? No LotsGroup in TED XML -->
		<!-- Group Lot Identifier (BT-1375) cardinality 1 --> <!-- should it have cardinality 1? No LotsGroup in TED XML -->
	</cac:TenderingTerms>
</xsl:template>
<xsl:template name="root-tendering-process">
	<xsl:comment> cac:TenderingProcess here </xsl:comment>
	<cac:TenderingProcess>
		<ext:UBLExtensions>
			<ext:UBLExtension>
				<ext:ExtensionContent>
					<efext:EformsExtension>
						<!-- Procurement Relaunch (BT-634) cardinality > -->
					</efext:EformsExtension>
				</ext:ExtensionContent>
			</ext:UBLExtension>
		</ext:UBLExtensions>
		<!-- A limited number of BTs are specified for tendering process at root level -->
		<!-- Procedure Features (BT-88) cardinality ? -->
		<!-- Procedure Type (BT-105) cardinality 1 -->
		<!-- PIN Competition Termination (BT-756) cardinality ? -->
		<!-- Lots All Required (BT-763) cardinality ? -->
		<!-- Procedure Accelerated (BT-106) cardinality ? -->
		<!-- Procedure Accelerated Justification (BT-1351) / Code cardinality ? -->
		<!-- Procedure Accelerated Justification (BT-1351) ​/ Text cardinality ? -->
		<!-- Direct Award Justification Previous Procedure Identifier (BT-1252) cardinality ? -->
		<!-- Direct Award Justification (BT-136) ​/ Code cardinality ? -->
		<!-- Direct Award Justification (BT-135) ​/ Text cardinality ? -->
	</cac:TenderingProcess>
</xsl:template>
<xsl:template name="root-procurement-project">
	<xsl:comment> cac:ProcurementProject here </xsl:comment>
	<cac:ProcurementProject>
		<!-- A limited number of BTs are specified for procurement project at root level -->
		<!-- Internal Identifier (BT-22) cardinality 1 -->
		<!-- Title (BT-21) cardinality 1 -->
		<!-- Description (BT-24) cardinality 1 -->
		<!-- Main Nature (BT-23) cardinality 1 -->
		<!-- Additional Nature (different from Main) (BT-531) cardinality * -->
		<!-- Additional Information (BT-300) (*)* cardinality ? -->
		<!-- Estimated Value (BT-27) cardinality ? -->
		<!-- Classification Type (e.g. CPV) (BT-26) cardinality 1 -->
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
	</cac:ProcurementProject>
</xsl:template>
<xsl:template name="procurement-project-lots">
	<xsl:comment> multiple cac:ProcurementProjectLot here </xsl:comment>
</xsl:template>


<xsl:template match="LEFTI/SUITABILITY">
<xsl:apply-templates/>
</xsl:template>



</xsl:stylesheet>
