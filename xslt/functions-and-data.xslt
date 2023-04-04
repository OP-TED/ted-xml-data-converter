<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xlink="http://www.w3.org/1999/xlink"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:doc="http://www.pnp-software.com/XSLTdoc" 
xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:functx="http://www.functx.com" xmlns:opfun="http://data.europa.eu/p27/ted-xml-data-converter"
xmlns:ted="http://publications.europa.eu/resource/schema/ted/R2.0.9/publication"
xmlns:ted-1="http://formex.publications.europa.eu/ted/schema/export/R2.0.9.S01.E01"
xmlns:ted-2="ted/R2.0.9.S02/publication"
xmlns:n2016-1="ted/2016/nuts" 
xmlns:n2016="http://publications.europa.eu/resource/schema/ted/2016/nuts" xmlns:n2021="http://publications.europa.eu/resource/schema/ted/2021/nuts"
xmlns:pin="urn:oasis:names:specification:ubl:schema:xsd:PriorInformationNotice-2" xmlns:cn="urn:oasis:names:specification:ubl:schema:xsd:ContractNotice-2" xmlns:can="urn:oasis:names:specification:ubl:schema:xsd:ContractAwardNotice-2"
xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"
xmlns:efbc="http://data.europa.eu/p27/eforms-ubl-extension-basic-components/1" xmlns:efac="http://data.europa.eu/p27/eforms-ubl-extension-aggregate-components/1" xmlns:efext="http://data.europa.eu/p27/eforms-ubl-extensions/1" 
xmlns:ccts="urn:un:unece:uncefact:documentation:2" xmlns:gc="http://docs.oasis-open.org/codelist/ns/genericode/1.0/"
exclude-result-prefixes="xlink xs xsi fn functx doc opfun ted ted-1 ted-2 gc n2016-1 n2016 n2021 pin cn can ccts ext" >
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

<!-- include FunctX XSLT Function Library -->
<xsl:include href="lib/functx-1.0.1-doc.xsl"/>

<!-- default SDK version -->
<xsl:variable name="sdk-version-default" select="'eforms-sdk-1.7'"/>

<!-- application parameters -->
<xsl:param name="showwarnings" select="1" as="xs:integer"/>
<xsl:param name="includewarnings" select="1" as="xs:integer"/>
<xsl:param name="includecomments" select="1" as="xs:integer"/>
	
<!-- external conversion parameters -->
<!-- Value for BT-701 Notice Identifier -->
<xsl:param name="notice-identifier" select="'f252f386-55ac-4fa8-9be4-9f950b9904c8'" as="xs:string"/>
<!-- Value for BT-04 Procedure Identifier -->
<xsl:param name="procedure-identifier" select="'aff2863e-b4cc-4e91-baba-b3b85f709117'" as="xs:string"/>
<!-- Value for SDK version -->
<xsl:param name="sdk-version" select="$sdk-version-default" as="xs:string"/>

<!-- MAPPING FILES -->
	
<xsl:variable name="mappings" select="fn:document('other-mappings.xml')"/>
<xsl:variable name="translations" select="fn:document('translations.xml')"/>
<xsl:variable name="country-codes-map" select="fn:document('countries-map.xml')"/>
<xsl:variable name="language-codes-map" select="fn:document('languages-map.xml')"/>



<!-- #### GLOBAL VARIABLES #### -->

<xsl:variable name="newline" select="'&#10;'"/>
<xsl:variable name="tab" select="'&#09;'"/>

<xsl:variable name="source-document" select="fn:base-uri()"/>

<!-- Apart from <NOTICE_UUID>, all direct children of FORM_SECTION have the same element name / form type -->
<!-- Variable ted-form-elements holds all the form elements (in alternate languages) -->
<xsl:variable name="ted-form-elements" select="/*/*:FORM_SECTION/*[@CATEGORY]"/>
<!-- Variable ted-form-main-element holds the first form element that has @CATEGORY='ORIGINAL'. This is the TED form element which is processed -->
<xsl:variable name="ted-form-main-element" select="/*/*:FORM_SECTION/*[@CATEGORY='ORIGINAL'][1]"/>
<!-- Variable ted-form-additional-elements holds the form elements that are not the main form element -->
<xsl:variable name="ted-form-additional-elements" select="/*/*:FORM_SECTION/*[@CATEGORY][not(@CATEGORY='ORIGINAL' and not(preceding-sibling::*[@CATEGORY='ORIGINAL']))]"/>
<!-- Variable ted-form-elements-names holds a list of unique element names of the ted form elements -->
<xsl:variable name="ted-form-elements-names" select="fn:distinct-values($ted-form-elements/fn:local-name())"/>
<!-- Variable ted-form-element-name holds the element name of the main form element. -->
<xsl:variable name="ted-form-element-name" select="$ted-form-main-element/fn:local-name()"/> <!-- F06_2014 or CONTRACT_DEFENCE or MOVE or OTH_NOT or ... -->
<!-- Variable ted-form-name holds the name of the main form element as held in the @FORM attribute -->
<xsl:variable name="ted-form-name" select="$ted-form-main-element/fn:string(@FORM)"/><!-- F06 or 17 or T02 or ... -->
<!-- Variable ted-form-element-xpath holds the XPath with positional predicates of the main form element -->
<xsl:variable name="ted-form-element-xpath" select="functx:path-to-node-with-pos($ted-form-main-element)"/>
<!-- Variable ted-form-notice-type holds the value of the @TYPE attribute of the NOTICE element -->
<xsl:variable name="ted-form-notice-type" select="$ted-form-main-element/fn:string(*:NOTICE/@TYPE)"/><!-- '' or PRI_ONLY or AWARD_CONTRACT ... -->
<!-- Variable document-code holds the value of the @TYPE attribute of the NOTICE element -->
<xsl:variable name="document-code" select="/*/*:CODED_DATA_SECTION/*:CODIF_DATA/*:TD_DOCUMENT_TYPE/fn:string(@CODE)"/><!-- 0 or 6 or A or H ... -->
<!-- Variable ted-form-first-language holds the value of the @LG attribute of the first form element with @CATEGORY='ORIGINAL' -->
<xsl:variable name="ted-form-first-language" select="$ted-form-main-element/fn:string(@LG)"/>
<!-- Variable ted-form-additional-languages holds the values of the @LG attribute of the remaining form elements -->
<xsl:variable name="ted-form-additional-languages" select="$ted-form-additional-elements/fn:string(@LG)"/>


<!-- Variable eforms-first-language holds the eForms three-letter code for the first language -->
<xsl:variable name="eforms-first-language" select="opfun:get-eforms-language($ted-form-first-language)"/>

<!-- Variable legal-basis holds the value of the @VALUE attribute of the element LEGAL_BASIS, if it exists. If element LEGAL_BASIS does not exist, it holds the value "OTHER" -->
<xsl:variable name="legal-basis">
	<xsl:choose>
		<xsl:when test="$ted-form-main-element/*:LEGAL_BASIS"><xsl:value-of select="$ted-form-main-element/*:LEGAL_BASIS/@VALUE"/></xsl:when>
		<xsl:otherwise><xsl:text>OTHER</xsl:text></xsl:otherwise>
	</xsl:choose>
</xsl:variable>

<!-- Variable directive holds the value of the @VALUE attribute of the element DIRECTIVE, if it exists. Othewise it holds the empty string -->
<xsl:variable name="directive" select="fn:string(/*/*:CODED_DATA_SECTION/*:CODIF_DATA/*:DIRECTIVE/@VALUE)"/>


<!-- Variable eforms-notice-subtype holds the computed eForms notice subtype value -->
<xsl:variable name="eforms-notice-subtype">
	<xsl:value-of select="opfun:get-eforms-notice-subtype($ted-form-element-name, $ted-form-name, $ted-form-notice-type, $legal-basis, $directive, $document-code)"/>
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
<xsl:variable name="number-of-lots" select="$ted-form-main-element/*:OBJECT_CONTRACT/fn:count(*:OBJECT_DESCR)"/>

<!-- Variable lot-numbers-map holds a mapping of the TED XML Lots (OBJECT_DESCR XPath) to the calculated eForms Purpose Lot Identifier (BT-137) -->
<xsl:variable name="lot-numbers-map">
	<xsl:variable name="count-lots" select="fn:count($ted-form-main-element/*:OBJECT_CONTRACT/*:OBJECT_DESCR)"/>
	<!-- eForms subtypes 1 to 9 are Planning type notices, and use Parts, not Lots, and the BT-137 value uses "PAR-" and not "LOT-". -->
	<xsl:variable name="lot-prefix">
		<xsl:choose>
			<xsl:when test="$eforms-notice-subtype = ('4', '5', '6', 'E2')">
				<xsl:value-of select="'PAR-'"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="'LOT-'"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<lots>
		<xsl:for-each select="$ted-form-main-element/*:OBJECT_CONTRACT/*:OBJECT_DESCR">
			<lot>
				<xsl:variable name="lot-no"><xsl:value-of select="*:LOT_NO"/></xsl:variable>
				<xsl:variable name="lot-no-is-convertible" select="(($lot-no eq '') or (fn:matches($lot-no, '^[1-9][0-9]{0,3}$')))"/>
				<path><xsl:value-of select="functx:path-to-node-with-pos(.)"/></path>
				<lot-no><xsl:value-of select="$lot-no"/></lot-no>
				<xsl:if test="$lot-no-is-convertible"><is-convertible/></xsl:if>
				<lot-id>
					<xsl:choose>
						<!-- When LOT_NO exists -->
						<xsl:when test="$lot-no">
							<xsl:choose>
								<!-- LOT_NO is a positive integer between 1 and 9999 -->
								<xsl:when test="$lot-no-is-convertible">
									<xsl:value-of select="fn:concat($lot-prefix, functx:pad-integer-to-length(*:LOT_NO, 4))"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="fn:concat($lot-prefix, *:LOT_NO)"/>
								</xsl:otherwise>							
							</xsl:choose>
						</xsl:when>
						<!-- When LOT_NO does not exist -->
						<xsl:otherwise>
							<xsl:choose>
								<!-- This is the only Lot in the notice -->
								<xsl:when test="$count-lots = 1">
									<!-- use identifier LOT-0000 or PAR-0000 -->
									<xsl:value-of select="fn:concat($lot-prefix, '0000')"/>
								</xsl:when>
								<xsl:otherwise>
									<!-- not tested, no examples found -->
									<!-- There is more than one Lot in the notice, eForms Lot identifier is derived from the position -->
									<xsl:value-of select="fn:concat($lot-prefix, functx:pad-integer-to-length((fn:count(./preceding-sibling::*:OBJECT_DESCR) + 1), 4))"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</lot-id>
			</lot>
		</xsl:for-each>
	</lots>
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
				<xsl:when test="opfun:is-valid-nuts-code(.)"><xsl:value-of select="."/></xsl:when>
			</xsl:choose>
		</xsl:for-each>
</xsl:function>

<!-- Function opfun:is-valid-nut-code returns true if the given string is a valid NUTS code (string length > 4) -->
<xsl:function name="opfun:is-valid-nuts-code" as="xs:boolean">
	<xsl:param name="nuts-code" as="xs:string"/>
	<xsl:sequence select="fn:string-length($nuts-code) &gt; 4"/>
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
	<xsl:param name="legal-basis"/><!-- could be value 'ANY' -->
	<xsl:param name="directive"/><!-- could be value 'ANY' -->
	<xsl:param name="ted-form-document-code"/>
	<xsl:variable name="notice-mapping-file" select="fn:document('notice-type-mapping.xml')"/>
	<!-- get rows from notice-type-mapping.xml with values matching the given parameters -->
	<xsl:variable name="mapping-row" select="$notice-mapping-file/mapping/row[form-element eq $ted-form-element][form-number eq $ted-form-name][notice-type eq $ted-form-notice-type][(legal-basis eq $legal-basis) or (legal-basis eq 'ANY')][(directive eq $directive) or (directive eq 'ANY')][(document-code eq $ted-form-document-code) or (document-code eq 'ANY')]"/>
	<!-- exit with an error if there is not exactly one matching row -->
	<xsl:if test="fn:count($mapping-row) != 1">
		<xsl:message terminate="yes">
			<xsl:text>ERROR: found </xsl:text>
			<xsl:choose>
				<xsl:when test="fn:count($mapping-row) = 0">no</xsl:when>
				<xsl:otherwise><xsl:value-of select="fn:count($mapping-row)"/> different</xsl:otherwise>
			</xsl:choose>
			<xsl:text> eForms subtype mappings for this Notice: </xsl:text><xsl:value-of select="$source-document"/><xsl:value-of select="$newline"/>
			<xsl:text>TED form element name: </xsl:text><xsl:value-of select="$ted-form-element"/><xsl:value-of select="$newline"/>
			<xsl:text>TED form name: </xsl:text><xsl:value-of select="$ted-form-name"/><xsl:value-of select="$newline"/>
			<xsl:text>TED form notice type: </xsl:text><xsl:value-of select="$ted-form-notice-type"/><xsl:value-of select="$newline"/>
			<xsl:text>TED form legal basis: </xsl:text><xsl:value-of select="$legal-basis"/><xsl:value-of select="$newline"/>
			<xsl:text>TED form directive: </xsl:text><xsl:value-of select="$directive"/><xsl:value-of select="$newline"/>
			<xsl:text>TED form document code: </xsl:text><xsl:value-of select="$ted-form-document-code"/><xsl:value-of select="$newline"/>
		</xsl:message>
	</xsl:if>
	<!-- read the eForms notice subtype from the row -->
	<xsl:variable name="eforms-subtype" select="$mapping-row/fn:string(eforms-subtype)"/>
	<!-- exit with an error if the eForms notice subtype is not a recognised value for the converter -->
	<xsl:choose>
		<xsl:when test="$eforms-subtype eq ''">
			<xsl:message terminate="yes">
				<xsl:text>ERROR: no eForms subtype mapping available for this Notice:</xsl:text><xsl:value-of select="$source-document"/><xsl:value-of select="$newline"/>
				<xsl:text>TED form element name: </xsl:text><xsl:value-of select="$ted-form-element"/><xsl:value-of select="$newline"/>
				<xsl:text>TED form name: </xsl:text><xsl:value-of select="$ted-form-name"/><xsl:value-of select="$newline"/>
				<xsl:text>TED form notice type: </xsl:text><xsl:value-of select="$ted-form-notice-type"/><xsl:value-of select="$newline"/>
				<xsl:text>TED form legal basis: </xsl:text><xsl:value-of select="$legal-basis"/><xsl:value-of select="$newline"/>
				<xsl:text>TED form directive: </xsl:text><xsl:value-of select="$directive"/><xsl:value-of select="$newline"/>
				<xsl:text>TED form document code: </xsl:text><xsl:value-of select="$ted-form-document-code"/><xsl:value-of select="$newline"/>
			</xsl:message>
		</xsl:when>
		<xsl:when test="$eforms-subtype eq 'ERROR'">
			<xsl:message terminate="yes">
				<xsl:text>ERROR: The combination of data in this Notice is considered an error:</xsl:text><xsl:value-of select="$source-document"/><xsl:value-of select="$newline"/>
				<xsl:text>TED form element name: </xsl:text><xsl:value-of select="$ted-form-element"/><xsl:value-of select="$newline"/>
				<xsl:text>TED form name: </xsl:text><xsl:value-of select="$ted-form-name"/><xsl:value-of select="$newline"/>
				<xsl:text>TED form notice type: </xsl:text><xsl:value-of select="$ted-form-notice-type"/><xsl:value-of select="$newline"/>
				<xsl:text>TED form legal basis: </xsl:text><xsl:value-of select="$legal-basis"/><xsl:value-of select="$newline"/>
				<xsl:text>TED form directive: </xsl:text><xsl:value-of select="$directive"/><xsl:value-of select="$newline"/>
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
	<!-- return the valid eForms notice subtype -->
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

<!-- Function opfun:name-with-pos returns the name of the given element, and its sequence number as a predicate if there are more than one instance within its parent -->
<!-- Adapted from functx:path-to-node-with-pos, FunctX XSLT Function Library -->
<xsl:function name="opfun:name-with-pos" as="xs:string">
  <xsl:param name="element" as="element()"/>
  <xsl:variable name="sibsOfSameName" select="$element/../*[name() = name($element)]"/>
  <xsl:sequence select="concat(name($element),
         if (count($sibsOfSameName) &lt;= 1)
         then ''
         else concat('[',functx:index-of-node($sibsOfSameName,$element),']'))"/>
</xsl:function>


<!-- Message Functions -->

<xsl:template name="report-warning">
	<xsl:param name="message" as="xs:string"/>
	<xsl:if test="$showwarnings=1">
		<xsl:message terminate="no"><xsl:value-of select="$message"/></xsl:message>
	</xsl:if>
	<xsl:if test="$includewarnings=1">
		<xsl:comment><xsl:value-of select="$message"/></xsl:comment>
	</xsl:if>
</xsl:template>

<xsl:template name="include-comment">
	<xsl:param name="comment" as="xs:string"/>
	<xsl:if test="$includecomments=1">
		<xsl:comment><xsl:value-of select="$comment"/></xsl:comment>
	</xsl:if>
</xsl:template>


<xsl:template name="find-element">
	<xsl:param name="context" as="element()"/>
	<xsl:param name="relative-context" as="xs:string"/>
	<xsl:variable name="child-name-and-pos" select="functx:substring-before-if-contains($relative-context, '/')"/>
	<xsl:variable name="next-context" select="fn:substring-after($relative-context, '/')"/>
	<xsl:variable name="element" select="$context/*[opfun:name-with-pos(.) = $child-name-and-pos]"/>
	<xsl:variable name="result">
		<xsl:choose>
			<xsl:when test="not($element)"><xsl:sequence select="()"/></xsl:when>
			<xsl:when test="$next-context">
				<xsl:call-template name="find-element">
					<xsl:with-param name="context" select="$element"/>
					<xsl:with-param name="relative-context" select="$next-context"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise><xsl:sequence select="$element"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:sequence select="$result"/>
</xsl:template>

<xsl:template name="multilingual">
	<xsl:param name="contexts" as="node()*"/>
	<xsl:param name="local"/>
	<xsl:param name="element"/>
	<xsl:variable name="relative-contexts" select="for $context in $contexts return fn:substring-after(functx:path-to-node-with-pos($context), fn:concat($ted-form-element-xpath, '/'))"/>
	<xsl:choose>
		<xsl:when test="$ted-form-additional-elements">
			<xsl:for-each select="($ted-form-main-element, $ted-form-additional-elements)">
				<xsl:variable name="language" select="opfun:get-eforms-language(@LG)"/>
				<xsl:variable name="form-element" select="."/>
				<xsl:variable name="text-content">
				<xsl:for-each select="$relative-contexts">
					<xsl:variable name="relative-context" select="."/>
					<xsl:variable name="this-context" select="fn:concat(functx:path-to-node-with-pos($form-element), .)"/>
					<xsl:variable name="parent">
						<xsl:call-template name="find-element">
							<xsl:with-param name="context" select="$form-element"/>
							<xsl:with-param name="relative-context" select="$relative-context"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:choose>
						<xsl:when test="$local eq ''">
							<xsl:value-of select="fn:normalize-space($parent/*)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="fn:normalize-space(fn:string-join($parent/*/*[fn:local-name() = $local], ' '))"/>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:text> </xsl:text>
				</xsl:for-each>
				</xsl:variable>
				<xsl:element name="{$element}">
					<xsl:attribute name="languageID" select="$language"/>
					<xsl:value-of select="fn:normalize-space(fn:string-join($text-content, ' '))"/>
				</xsl:element>
			</xsl:for-each>
		</xsl:when>
		<xsl:otherwise>
			<xsl:variable name="text" as="xs:string">
				<xsl:choose>
					<xsl:when test="$local eq ''">
						<xsl:value-of select="fn:normalize-space($contexts)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="fn:normalize-space(fn:string-join($contexts/*[fn:local-name() = $local], ' '))"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:element name="{$element}">
				<xsl:attribute name="languageID" select="$eforms-first-language"/>
				<xsl:value-of select="$text"/>
			</xsl:element>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
