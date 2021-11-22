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

	<xsl:function name="opfun:get-award-criteria-number-codelist-and-code" as="xs:string*">
		<!--
			<AC_WEIGHTING>10.01 %</AC_WEIGHTING>
			<AC_WEIGHTING>Τιμή 30 / Ποιότητα 70</AC_WEIGHTING>
			<AC_WEIGHTING>0,40</AC_WEIGHTING>
			<AC_WEIGHTING>20 punkti</AC_WEIGHTING>
		-->
		<xsl:param name="weighting-elem" as="element()"/>
		<xsl:variable name="weighting" select="fn:normalize-space(fn:string($weighting-elem))"/>

		<xsl:variable name="number-and-type" >
		<xsl:choose>
			<xsl:when test="fn:matches($weighting, '^\s*\d+\s*$')">
				<nat><number><xsl:value-of select="fn:normalize-space($weighting)"/></number><codelist>number-fixed</codelist><code>fix-tot</code></nat>
			</xsl:when>
			<xsl:when test="fn:matches($weighting, '^\s*\d+([.,]\d+)?\s*%?\s*$')">
				<nat><number><xsl:value-of select="fn:normalize-space(fn:substring-before($weighting,'%'))"/></number><codelist>number-weight</codelist><code>per-exa</code></nat>
			</xsl:when>
			<xsl:otherwise>
				<nat><number>ERROR: UNKNOWN WEIGHTING: <xsl:value-of select="$weighting"/></number><codelist>error</codelist><code>error</code></nat>
			</xsl:otherwise>
		</xsl:choose>
		</xsl:variable>
		<xsl:sequence select="fn:string($number-and-type//number), fn:string($number-and-type//codelist), fn:string($number-and-type//code)"/>
	</xsl:function>


<xsl:template match="ted:AC">
	<cac:AwardingCriterion>
		<xsl:call-template name="awarding-criterion-description"/>
		<xsl:apply-templates/>
	</cac:AwardingCriterion>
</xsl:template>

<xsl:template match="ted:AC_QUALITY">
	<xsl:variable name="weighting" select="fn:normalize-space(fn:string(ted:AC_WEIGHTING))"/>
	<xsl:variable name="number-codelist-and-code" select="opfun:get-award-criteria-number-codelist-and-code(ted:AC_WEIGHTING)"/>
	
    <cac:SubordinateAwardingCriterion>
        <ext:UBLExtensions>
            <ext:UBLExtension>
                <ext:ExtensionContent>
                    <efext:EformsExtension>
                        <efac:AwardCriterionParameter>
							<efbc:ParameterCode listName="{$number-codelist-and-code[2]}"><xsl:value-of select="$number-codelist-and-code[3]"/></efbc:ParameterCode>
							<efbc:ParameterNumeric><xsl:value-of select="$number-codelist-and-code[1]"/></efbc:ParameterNumeric>
                        </efac:AwardCriterionParameter>
					</efext:EformsExtension>
				</ext:ExtensionContent>
			</ext:UBLExtension>
		</ext:UBLExtensions>
		<cbc:AwardingCriterionTypeCode listName="award-criterion-type">quality</cbc:AwardingCriterionTypeCode>
		<cbc:Description languageID="ENG">The price score contributes for 60 % ...</cbc:Description>
	</cac:SubordinateAwardingCriterion>

</xsl:template>


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


<xsl:template name="awarding-criterion-description">
	<!-- When the use of Award Criteria is performed sequentially based on order of importance
		 instead of involving weighted scores, the buyer shall justify this decision (BT-733) 
		using the "cbc:Description" element of "cac:AwardingCriterion" -->
	<xsl:comment>May need cbc:Description here </xsl:comment>
</xsl:template>

</xsl:stylesheet>
