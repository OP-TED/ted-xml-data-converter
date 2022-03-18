<?xml version="1.0" encoding="UTF-8"?>
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
	
<xsl:include href="functx-1.0.1-doc.xsl"/>

<xsl:variable name="newline" select="'&#10;'"/>
<xsl:variable name="tab" select="'&#09;'"/>

<!-- GLOBAL VARIABLES -->

<!-- Apart from <NOTICE_UUID>, all direct children of FORM_SECTION have the same element name / form type -->
<!-- Variable ted-form-elements holds all the form elements (in alternate languages) -->
<xsl:variable name="ted-form-elements" select="/ted:TED_EXPORT/ted:FORM_SECTION/*[@CATEGORY]"/>
<!-- Variable ted-form-main-element holds the first form element that has @CATEGORY='ORIGINAL'. This is the TED form element which is processed. -->
<xsl:variable name="ted-form-main-element" select="/ted:TED_EXPORT/ted:FORM_SECTION/*[@CATEGORY='ORIGINAL'][1]"/>
<!-- Variable ted-form-additional-elements holds the form elements that are not the main form element. -->
<xsl:variable name="ted-form-additional-elements" select="/ted:TED_EXPORT/ted:FORM_SECTION/*[@CATEGORY][not(@CATEGORY='ORIGINAL' and not(preceding-sibling::*[@CATEGORY='ORIGINAL']))]"/>
<!-- Variable ted-form-elements-names holds a list of unique element names of the ted form elements. -->
<xsl:variable name="ted-form-elements-names" select="fn:distinct-values($ted-form-elements/fn:local-name())"/>
<!-- Variable ted-form-element-name holds a the element name of the main form element. -->
<xsl:variable name="ted-form-element-name" select="$ted-form-main-element/fn:local-name()"/> <!-- F06_2014 or CONTRACT_DEFENCE or MOVE or OTH_NOT or ... -->
<xsl:variable name="ted-form-name" select="$ted-form-main-element/fn:string(@FORM)"/><!-- F06 or 17 or T02 or ... -->
<xsl:variable name="ted-form-notice-type" select="$ted-form-main-element/fn:string(ted:NOTICE/@TYPE)"/><!-- '' or PRI_ONLY or AWARD_CONTRACT ... -->
<xsl:variable name="ted-form-document-code" select="/ted:TED_EXPORT/ted:CODED_DATA_SECTION/ted:CODIF_DATA/ted:TD_DOCUMENT_TYPE/fn:string(@CODE)"/><!-- 0 or 6 or A or H ... -->
<xsl:variable name="ted-form-first-language" select="$ted-form-main-element/fn:string(@LG)"/>
<xsl:variable name="ted-form-additional-languages" select="$ted-form-additional-elements/fn:string(@LG)"/>
 
<xsl:variable name="eforms-first-language" select="opfun:get-eforms-language($ted-form-first-language)"/>

<xsl:variable name="legal-basis">
	<xsl:choose>
		<xsl:when test="$ted-form-main-element/ted:LEGAL_BASIS"><xsl:value-of select="$ted-form-main-element/ted:LEGAL_BASIS/@VALUE"/></xsl:when>
		<xsl:otherwise><xsl:text>OTHER</xsl:text></xsl:otherwise>
	</xsl:choose>
</xsl:variable>

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
	

<xsl:variable name="number-of-lots" select="$ted-form-main-element/ted:OBJECT_CONTRACT/fn:count(ted:OBJECT_DESCR)"/>


<xsl:variable name="languages">
	<!-- variable containing XML of map of language codes from TED to eForms from codelist "languages.xml" -->
	<xsl:variable name="source-language-file" select="fn:document('languages.xml')"/>
	<languages>
		<xsl:for-each select="$source-language-file//record[op-mapped-code/@source='TED']">
			<language>
				<xsl:variable name="ted-form" select="fn:string(op-mapped-code[@source='TED'])"/>
				<xsl:variable name="eforms-form" select="fn:string(authority-code)"/>
				<ted><xsl:value-of select="$ted-form"/></ted>
				<eforms><xsl:value-of select="$eforms-form"/></eforms>
			</language>
		</xsl:for-each>
	</languages>
</xsl:variable>



<!-- LANGUAGES -->

<xsl:function name="opfun:get-eforms-language" as="xs:string">
	<!-- function to get eForms language code from given TED language code, e.g. "DA" to "DAN" -->
	<xsl:param name="ted-language" as="xs:string"/>
	<xsl:variable name="mapped-language" select="$languages//language[ted eq $ted-language]/fn:string(eforms)"/>
	<xsl:value-of select="if ($mapped-language) then $mapped-language else 'UNKNOWN-LANGUAGE'"/>
</xsl:function>

<!-- NUTS -->

<xsl:function name="opfun:get-valid-nuts-codes" as="xs:string*">
	<!-- function to get eForms language code from given TED language code, e.g. "DA" to "DAN" -->
	<xsl:param name="nuts-codes" as="xs:string*"/>
		<xsl:for-each select="$nuts-codes">
			<xsl:choose>
				<xsl:when test="fn:string-length(.) > 4"><xsl:value-of select="."/></xsl:when>
			</xsl:choose>
		</xsl:for-each>
</xsl:function>




<!-- MAPPING FILES -->
	
<xsl:variable name="mappings" select="fn:document('mappings.xml')"/>


<!-- FORM TYPES AND SUBTYPES -->


<xsl:function name="opfun:get-eforms-element-name" as="xs:string">
	<!-- function to get name of eForms schema root element, given abbreviation, e.g. "CN" to "ContractNotice" -->
	<xsl:param name="form-abbreviation" as="xs:string"/>
	<xsl:value-of select="$mappings//form-types/mapping[abbreviation=$form-abbreviation]/fn:string(element-name)"/>
</xsl:function>

<xsl:function name="opfun:get-eforms-xmlns" as="xs:string">
	<!-- function to get name of eForms schema XML namespace given abbreviation, e.g. "CN" to "urn:oasis:names:specification:ubl:schema:xsd:ContractNotice-2" -->
	<xsl:param name="form-abbreviation" as="xs:string"/>
	<xsl:value-of select="$mappings//form-types/mapping[abbreviation=$form-abbreviation]/fn:string(xmlns)"/>
</xsl:function>

<xsl:function name="opfun:get-eforms-notice-subtype" as="xs:string">
	<!-- function to get eForms Notice Subtype value, given values from TED XML notice -->
	<xsl:param name="ted-form-element"/>
	<xsl:param name="ted-form-name"/>
	<xsl:param name="ted-form-notice-type"/>
	<xsl:param name="ted-form-legal-basis"/><!-- could be value 'ANY' -->
	<xsl:param name="ted-form-document-code"/>
	<xsl:variable name="notice-mapping-file" select="fn:document('ted-notice-mapping.xml')"/>
	<xsl:variable name="mapping-row" select="$notice-mapping-file/mapping/row[form-element eq $ted-form-element][form-number eq $ted-form-name][notice-type eq $ted-form-notice-type][(legal-basis eq $ted-form-legal-basis) or (legal-basis eq 'ANY')][document-code eq $ted-form-document-code]"/>
	<xsl:if test="fn:count($mapping-row) != 1">
		<xsl:message terminate="yes">ERROR: found <xsl:value-of select="fn:count($mapping-row)"/> different eForms subtype mappings for this Notice:<xsl:value-of select="$newline"/>
		<xsl:value-of select="fn:string-join(($ted-form-element, $ted-form-name, $ted-form-notice-type, $ted-form-legal-basis, $ted-form-document-code), ':')"/></xsl:message>
	</xsl:if>
	<xsl:variable name="eforms-subtype" select="$mapping-row/fn:string(eforms-subtype)"/>
		<xsl:choose>
			<xsl:when test="$eforms-subtype eq ''">
				<xsl:message terminate="yes">ERROR: no eForms subtype mapping available for this Notice:<xsl:value-of select="$newline"/>
				<xsl:value-of select="fn:string-join(($ted-form-element, $ted-form-name, $ted-form-notice-type, $ted-form-legal-basis, $ted-form-document-code), ':')"/></xsl:message>
			</xsl:when>
			<xsl:when test="$eforms-subtype eq 'ERROR'">
				<xsl:message terminate="yes">ERROR: The combination of data in this Notice is considered an error:<xsl:value-of select="$newline"/>
				<xsl:value-of select="fn:string-join(($ted-form-element, $ted-form-name, $ted-form-notice-type, $ted-form-legal-basis, $ted-form-document-code), ':')"/></xsl:message>
			</xsl:when>
			<xsl:when test="fn:not(fn:matches($eforms-subtype, '^[1-9]|[1-3][0-9]|40*$'))">
				<xsl:message terminate="yes">ERROR: Conversion for eForms subtype <xsl:value-of select="$eforms-subtype"/> has not been created</xsl:message>
			</xsl:when>
		</xsl:choose>
	<xsl:value-of select="$eforms-subtype"/>
</xsl:function>



<!-- GENERAL FUNCTIONS -->
	
<xsl:function name="opfun:descendants-deep-equal" as="xs:boolean">
	<!-- function to deep-compare the contents of two nodes, returning TRUE or FALSE. The names of the root node elements are ignored -->
	<xsl:param name="node1" as="node()"/>
	<xsl:param name="node2" as="node()"/>
	<xsl:variable name="out1">
		<out>
			<xsl:for-each select="$node1/node()">
				<xsl:copy-of select="."/>
			</xsl:for-each>
		</out>	
	</xsl:variable>
	<xsl:variable name="out2">
		<out>
			<xsl:for-each select="$node2/node()">
				<xsl:copy-of select="."/>
			</xsl:for-each>
		</out>	
	</xsl:variable>
	<xsl:value-of select="fn:deep-equal($out1, $out2)"/>
</xsl:function>

<xsl:function name="opfun:prefix-and-name" as="xs:string">
	<!-- function to return the prefix and name of given element, e.g. "cbc:ID" -->
	<xsl:param name="elem" as="element()"/>
	<xsl:variable name="name" select="$elem/fn:local-name()"/>
	<xsl:variable name="prefix" select="fn:prefix-from-QName(fn:node-name($elem))"/>
	<xsl:value-of select="fn:string-join(($prefix,$name),':')"/>
</xsl:function>
	
</xsl:stylesheet>
