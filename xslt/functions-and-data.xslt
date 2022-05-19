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

<!-- include FunctX XSLT Function Library -->
<xsl:include href="lib/functx-1.0.1-doc.xsl"/>

<!-- MAPPING FILES -->
	
<xsl:variable name="mappings" select="fn:document('other-mappings.xml')"/>



<!-- #### GLOBAL VARIABLES #### -->

<xsl:variable name="newline" select="'&#10;'"/>
<xsl:variable name="tab" select="'&#09;'"/>

<!-- Apart from <NOTICE_UUID>, all direct children of FORM_SECTION have the same element name / form type -->
<!-- Variable ted-form-elements holds all the form elements (in alternate languages) -->
<xsl:variable name="ted-form-elements" select="/ted:TED_EXPORT/ted:FORM_SECTION/*[@CATEGORY]"/>
<!-- Variable ted-form-main-element holds the first form element that has @CATEGORY='ORIGINAL'. This is the TED form element which is processed -->
<xsl:variable name="ted-form-main-element" select="/ted:TED_EXPORT/ted:FORM_SECTION/*[@CATEGORY='ORIGINAL'][1]"/>
<!-- Variable ted-form-additional-elements holds the form elements that are not the main form element -->
<xsl:variable name="ted-form-additional-elements" select="/ted:TED_EXPORT/ted:FORM_SECTION/*[@CATEGORY][not(@CATEGORY='ORIGINAL' and not(preceding-sibling::*[@CATEGORY='ORIGINAL']))]"/>
<!-- Variable ted-form-elements-names holds a list of unique element names of the ted form elements -->
<xsl:variable name="ted-form-elements-names" select="fn:distinct-values($ted-form-elements/fn:local-name())"/>
<!-- Variable ted-form-element-name holds the element name of the main form element. -->
<xsl:variable name="ted-form-element-name" select="$ted-form-main-element/fn:local-name()"/> <!-- F06_2014 or CONTRACT_DEFENCE or MOVE or OTH_NOT or ... -->
<!-- Variable ted-form-name holds the name of the main form element as held in the @FORM attribute -->
<xsl:variable name="ted-form-name" select="$ted-form-main-element/fn:string(@FORM)"/><!-- F06 or 17 or T02 or ... -->
<!-- Variable ted-form-notice-type holds the value of the @TYPE attribute of the NOTICE element. -->
<xsl:variable name="ted-form-notice-type" select="$ted-form-main-element/fn:string(ted:NOTICE/@TYPE)"/><!-- '' or PRI_ONLY or AWARD_CONTRACT ... -->
<!-- Variable ted-form-document-code holds the value of the @TYPE attribute of the NOTICE element -->
<xsl:variable name="ted-form-document-code" select="/ted:TED_EXPORT/ted:CODED_DATA_SECTION/ted:CODIF_DATA/ted:TD_DOCUMENT_TYPE/fn:string(@CODE)"/><!-- 0 or 6 or A or H ... -->
<!-- Variable ted-form-first-language holds the value of the @LG attribute of the first form element with @CATEGORY='ORIGINAL' -->
<xsl:variable name="ted-form-first-language" select="$ted-form-main-element/fn:string(@LG)"/>
<!-- Variable ted-form-additional-languages holds the values of the @LG attribute of the remaining form elements -->
<xsl:variable name="ted-form-additional-languages" select="$ted-form-additional-elements/fn:string(@LG)"/>


<!-- Variable eforms-first-language holds the eForms three-letter code for the first language -->
<xsl:variable name="eforms-first-language" select="opfun:get-eforms-language($ted-form-first-language)"/>

<!-- Variable legal-basis holds the value of the @VALUE attribute of the element LEGAL_BASIS, if it exists. If element LEGAL_BASIS does not exist, it holds the value "OTHER" -->
<xsl:variable name="legal-basis">
	<xsl:choose>
		<xsl:when test="$ted-form-main-element/ted:LEGAL_BASIS"><xsl:value-of select="$ted-form-main-element/ted:LEGAL_BASIS/@VALUE"/></xsl:when>
		<xsl:otherwise><xsl:text>OTHER</xsl:text></xsl:otherwise>
	</xsl:choose>
</xsl:variable>

<!-- Variable eforms-notice-subtype holds the computed eForms notice subtype value -->
<xsl:variable name="eforms-notice-subtype">
	<xsl:value-of select="opfun:get-eforms-notice-subtype($ted-form-element-name, $ted-form-name, $ted-form-notice-type, $legal-basis, $ted-form-document-code)"/>
</xsl:variable>

<!-- Variable eforms-subtypes-pin holds the values of eForms notice subtypes for notices of Document Type PIN -->
<xsl:variable name="eforms-subtypes-pin" as="xs:string*">
	<xsl:for-each select="1 to 9"><xsl:sequence select="xs:string(.)"/></xsl:for-each>
	<xsl:sequence select="('E1', 'E2')"/>
</xsl:variable>

<!-- Variable eforms-subtypes-cn holds the values of eForms notice subtypes for notices of Document Type Contract Notice -->
<xsl:variable name="eforms-subtypes-cn" as="xs:string*">
	<xsl:for-each select="10 to 24"><xsl:sequence select="xs:string(.)"/></xsl:for-each>
	<xsl:sequence select="('E3')"/>
</xsl:variable>

<!-- Variable eforms-subtypes-can holds the values of eForms notice subtypes for notices of Document Type Contract Award Notice -->
<xsl:variable name="eforms-subtypes-can" as="xs:string*">
	<xsl:for-each select="25 to 40"><xsl:sequence select="xs:string(.)"/></xsl:for-each>
	<xsl:sequence select="('E4')"/>
</xsl:variable>

<!-- Variable eforms-form-type holds the computed Document Type of the notice being converted -->
<xsl:variable name="eforms-form-type">
	<xsl:choose>
		<xsl:when test="$eforms-notice-subtype = $eforms-subtypes-pin"><xsl:value-of select="'PIN'"/></xsl:when>
		<xsl:when test="$eforms-notice-subtype = $eforms-subtypes-cn"><xsl:value-of select="'CN'"/></xsl:when>
		<xsl:when test="$eforms-notice-subtype = $eforms-subtypes-can"><xsl:value-of select="'CAN'"/></xsl:when>
		<xsl:otherwise><xsl:value-of select="'UNKNOWN'"/></xsl:otherwise>
	</xsl:choose>
</xsl:variable>

<!-- Variable number-of-lots holds the number of Lots (element OBJECT_DESCR) of the notice being converted -->
<xsl:variable name="number-of-lots" select="$ted-form-main-element/ted:OBJECT_CONTRACT/fn:count(ted:OBJECT_DESCR)"/>

<!-- Variable language-codes-map holds a mapping of language codes from TED two-letter format to eForms three-letter format -->
<xsl:variable name="language-codes-map">
	<xsl:variable name="source-language-file" select="fn:document('languages.xml')"/>
	<languages>
		<xsl:for-each select="$source-language-file//record[@deprecated='false'][op-mapped-code/@source='TED']">
			<language>
				<xsl:variable name="ted-form" select="fn:string(op-mapped-code[@source='TED'])"/>
				<xsl:variable name="eforms-form" select="fn:string(authority-code)"/>
				<ted><xsl:value-of select="$ted-form"/></ted>
				<eforms><xsl:value-of select="$eforms-form"/></eforms>
			</language>
		</xsl:for-each>
	</languages>
</xsl:variable>

<!-- Variable country-codes-map holds a mapping of country codes from TED two-letter format to eForms three-letter format -->
<xsl:variable name="country-codes-map">
	<xsl:variable name="source-country-file" select="fn:document('countries.xml')"/>
	<countries>
		<xsl:for-each select="$source-country-file//record[@deprecated='false'][op-mapped-code/@source='TED']">
			<country>
				<xsl:variable name="ted-form" select="fn:string(op-mapped-code[@source='TED'])"/>
				<xsl:variable name="eforms-form" select="fn:string(authority-code)"/>
				<ted><xsl:value-of select="$ted-form"/></ted>
				<eforms><xsl:value-of select="$eforms-form"/></eforms>
			</country>
		</xsl:for-each>
	</countries>
</xsl:variable>


<!-- #### GLOBAL FUNCTIONS #### -->

<!-- Function opfun:get-eforms-language converts a language code from TED two-letter format to eForms three-letter format -->
<xsl:function name="opfun:get-eforms-language" as="xs:string">
	<!-- function to get eForms language code from given TED language code, e.g. "DA" to "DAN" -->
	<xsl:param name="ted-language" as="xs:string"/>
	<xsl:variable name="mapped-language" select="$language-codes-map//language[ted eq $ted-language]/fn:string(eforms)"/>
	<xsl:value-of select="if ($mapped-language) then $mapped-language else 'UNKNOWN-LANGUAGE'"/>
</xsl:function>

<xsl:function name="opfun:get-eforms-country" as="xs:string">
	<!-- function to get eForms country code from given TED country code, e.g. "BG" to "BGR" -->
	<xsl:param name="ted-country" as="xs:string"/>
	<xsl:variable name="mapped-country" select="$country-codes-map//country[ted eq $ted-country]/fn:string(eforms)"/>
	<xsl:value-of select="if ($mapped-country) then $mapped-country else 'UNKNOWN-COUNTRY'"/>
</xsl:function>

<!-- Function opfun:get-valid-nuts-codes filters a list of NUTS codes to those of more than 4 characters -->
<xsl:function name="opfun:get-valid-nuts-codes" as="xs:string*">
	<!-- function to get eForms language code from given TED language code, e.g. "DA" to "DAN" -->
	<xsl:param name="nuts-codes" as="xs:string*"/>
		<xsl:for-each select="$nuts-codes">
			<xsl:choose>
				<xsl:when test="fn:string-length(.) > 4"><xsl:value-of select="."/></xsl:when>
			</xsl:choose>
		</xsl:for-each>
</xsl:function>


<!-- FORM TYPES AND SUBTYPES -->

<!-- Function opfun:get-eforms-element-name returns the name of eForms schema root element, given the Document Type code, e.g. "CN" to "ContractNotice" -->
<xsl:function name="opfun:get-eforms-element-name" as="xs:string">
	<xsl:param name="form-abbreviation" as="xs:string"/>
	<xsl:value-of select="$mappings//form-types/mapping[abbreviation=$form-abbreviation]/fn:string(element-name)"/>
</xsl:function>

<!-- Function opfun:get-eforms-xmlns returns the eForms schema XML namespace, given the Document Type code, e.g. "CN" to "urn:oasis:names:specification:ubl:schema:xsd:ContractNotice-2" -->
<xsl:function name="opfun:get-eforms-xmlns" as="xs:string">
	<xsl:param name="form-abbreviation" as="xs:string"/>
	<xsl:value-of select="$mappings//form-types/mapping[abbreviation=$form-abbreviation]/fn:string(xmlns)"/>
</xsl:function>

<!-- Function opfun:get-eforms-notice-subtype computes the eForms notice subtype, using information from the TED notice -->
<xsl:function name="opfun:get-eforms-notice-subtype" as="xs:string">
	<xsl:param name="ted-form-element"/>
	<xsl:param name="ted-form-name"/>
	<xsl:param name="ted-form-notice-type"/>
	<xsl:param name="ted-form-legal-basis"/><!-- could be value 'ANY' -->
	<xsl:param name="ted-form-document-code"/>
	<xsl:variable name="notice-mapping-file" select="fn:document('notice-type-mapping.xml')"/>
	<!-- get rows from notice-type-mapping.xml with values matching the given parameters -->
	<xsl:variable name="mapping-row" select="$notice-mapping-file/mapping/row[form-element eq $ted-form-element][form-number eq $ted-form-name][notice-type eq $ted-form-notice-type][(legal-basis eq $ted-form-legal-basis) or (legal-basis eq 'ANY')][document-code eq $ted-form-document-code]"/>
	<!-- exit with an error if there is not exactly one matching row -->
	<xsl:if test="fn:count($mapping-row) != 1">
		<xsl:message terminate="yes">
			<xsl:text>ERROR: found </xsl:text>
			<xsl:choose>
				<xsl:when test="fn:count($mapping-row) = 0">no</xsl:when>
				<xsl:otherwise><xsl:value-of select="fn:count($mapping-row)"/> different</xsl:otherwise>
			</xsl:choose>
			<xsl:text> eForms subtype mappings for this Notice: </xsl:text><xsl:value-of select="$newline"/>
			<xsl:text>TED form element name: </xsl:text><xsl:value-of select="$ted-form-element"/><xsl:value-of select="$newline"/>
			<xsl:text>TED form name: </xsl:text><xsl:value-of select="$ted-form-name"/><xsl:value-of select="$newline"/>
			<xsl:text>TED form notice type: </xsl:text><xsl:value-of select="$ted-form-notice-type"/><xsl:value-of select="$newline"/>
			<xsl:text>TED form legal basis: </xsl:text><xsl:value-of select="$ted-form-legal-basis"/><xsl:value-of select="$newline"/>
			<xsl:text>TED form document code: </xsl:text><xsl:value-of select="$ted-form-document-code"/><xsl:value-of select="$newline"/>
		</xsl:message>
	</xsl:if>
	<!-- read the eForms subtype from the row -->
	<xsl:variable name="eforms-subtype" select="$mapping-row/fn:string(eforms-subtype)"/>
	<!-- exit with an error if the eForms subtype is not a recognised value for the converter -->
	<xsl:choose>
		<xsl:when test="$eforms-subtype eq ''">
			<xsl:message terminate="yes">
				<xsl:text>ERROR: no eForms subtype mapping available for this Notice:</xsl:text><xsl:value-of select="$newline"/>
				<xsl:text>TED form element name: </xsl:text><xsl:value-of select="$ted-form-element"/><xsl:value-of select="$newline"/>
				<xsl:text>TED form name: </xsl:text><xsl:value-of select="$ted-form-name"/><xsl:value-of select="$newline"/>
				<xsl:text>TED form notice type: </xsl:text><xsl:value-of select="$ted-form-notice-type"/><xsl:value-of select="$newline"/>
				<xsl:text>TED form legal basis: </xsl:text><xsl:value-of select="$ted-form-legal-basis"/><xsl:value-of select="$newline"/>
				<xsl:text>TED form document code: </xsl:text><xsl:value-of select="$ted-form-document-code"/><xsl:value-of select="$newline"/>
			</xsl:message>
		</xsl:when>
		<xsl:when test="$eforms-subtype eq 'ERROR'">
			<xsl:message terminate="yes">
				<xsl:text>ERROR: The combination of data in this Notice is considered an error:</xsl:text><xsl:value-of select="$newline"/>
				<xsl:text>TED form element name: </xsl:text><xsl:value-of select="$ted-form-element"/><xsl:value-of select="$newline"/>
				<xsl:text>TED form name: </xsl:text><xsl:value-of select="$ted-form-name"/><xsl:value-of select="$newline"/>
				<xsl:text>TED form notice type: </xsl:text><xsl:value-of select="$ted-form-notice-type"/><xsl:value-of select="$newline"/>
				<xsl:text>TED form legal basis: </xsl:text><xsl:value-of select="$ted-form-legal-basis"/><xsl:value-of select="$newline"/>
				<xsl:text>TED form document code: </xsl:text><xsl:value-of select="$ted-form-document-code"/><xsl:value-of select="$newline"/>
			</xsl:message>
		</xsl:when>
		<xsl:when test="fn:not(fn:matches($eforms-subtype, '^[1-9]|[1-3][0-9]|40*$'))">
			<xsl:message terminate="yes">
				<xsl:text>ERROR: Conversion for eForms subtype </xsl:text>
				<xsl:value-of select="$eforms-subtype"/>
				<xsl:text> is not supported by this version of the converter</xsl:text>
			</xsl:message>
		</xsl:when>
	</xsl:choose>
	<!-- return the valid eForms subtype -->
	<xsl:value-of select="$eforms-subtype"/>
</xsl:function>



<!-- GENERAL FUNCTIONS -->
	
<!-- Function opfun:descendants-deep-equal compares the contents of two nodes, returning TRUE or FALSE. The names of the root node elements are ignored -->
<xsl:function name="opfun:descendants-deep-equal" as="xs:boolean">
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

<!-- Function opfun:prefix-and-name returns the namespace prefix and local name of a given element, e.g. "cbc:ID" -->
<xsl:function name="opfun:prefix-and-name" as="xs:string">
	<xsl:param name="elem" as="element()"/>
	<xsl:variable name="name" select="$elem/fn:local-name()"/>
	<xsl:variable name="prefix" select="fn:prefix-from-QName(fn:node-name($elem))"/>
	<xsl:value-of select="fn:string-join(($prefix,$name),':')"/>
</xsl:function>
	
</xsl:stylesheet>
