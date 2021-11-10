<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:functx="http://www.functx.com" 
xmlns:doc="http://www.pnp-software.com/XSLTdoc" xmlns:opfun="http://publications.europa.eu/local/xslt-functions"
xmlns:ted="http://publications.europa.eu/resource/schema/ted/R2.0.9/publication" xmlns:n2016="http://publications.europa.eu/resource/schema/ted/2016/nuts" 
xmlns:efbc="http://eforms/v1.0/ExtensionBasicComponents" xmlns:efac="http://eforms/v1.0/ExtensionAggregateComponents" xmlns:efext="http://eforms/v1.0/Extensions" xmlns:pin="urn:oasis:names:specification:ubl:schema:xsd:PriorInformationNotice-2" xmlns:cn="urn:oasis:names:specification:ubl:schema:xsd:ContractNotice-2" xmlns:can="urn:oasis:names:specification:ubl:schema:xsd:ContractAwardNotice-2"
xmlns:ccts="urn:un:unece:uncefact:documentation:2" xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
xmlns:gc="http://docs.oasis-open.org/codelist/ns/genericode/1.0/" >
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	
<xsl:variable name="newline" select="'&#10;'"/>
<xsl:variable name="tab" select="'&#09;'"/>

<xsl:function name="opfun:prefix-and-name" as="xs:string">
	<xsl:param name="elem" as="element()"/>
	<xsl:variable name="name" select="$elem/fn:local-name()"/>
	<xsl:variable name="prefix" select="fn:prefix-from-QName(fn:node-name($elem))"/>
	<xsl:value-of select="fn:string-join(($prefix,$name),':')"/>
</xsl:function>

<xsl:variable name="languages">
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

<xsl:function name="opfun:get-eforms-language" as="xs:string">
	<xsl:param name="ted-language" as="xs:string"/>
	<xsl:variable name="mapped-language" select="$languages//language[ted eq $ted-language]/fn:string(eforms)"/>
	<xsl:value-of select="if ($mapped-language) then $mapped-language else 'UNKNOWN-LANGUAGE'"/>
</xsl:function>

<xsl:function name="opfun:get-eforms-notice-subtype" as="xs:string">
	<xsl:param name="ted-form-element"/>
	<xsl:param name="ted-form-name"/>
	<xsl:param name="ted-form-notice-type"/>
	<xsl:param name="ted-form-legal-basis"/>
	<xsl:param name="ted-form-document-code"/>
	<xsl:variable name="notice-mapping-file" select="fn:document('ted-notice-mapping.xml')"/>
	<xsl:variable name="mapping-row" select="$notice-mapping-file/mapping/row[form-element eq $ted-form-element][form-number eq $ted-form-name][notice-type eq $ted-form-notice-type][legal-basis eq $ted-form-legal-basis][document-code eq $ted-form-document-code]"/>
	<xsl:if test="fn:count($mapping-row) != 1">
		<xsl:message terminate="yes">ERROR: found <xsl:value-of select="fn:count($mapping-row)"/> different eForms subtype mappings for this Notice:<xsl:value-of select="$newline"/>
		<xsl:value-of select="fn:string-join(($ted-form-element, $ted-form-name, $ted-form-notice-type, $ted-form-legal-basis, $ted-form-document-code), ':')"/></xsl:message>
	</xsl:if>
	<xsl:variable name="eforms-subtype" select="$mapping-row/fn:string(eforms-subtype)"/>
	<xsl:if test="$eforms-subtype eq ''">
		<xsl:message terminate="yes">ERROR: no eForms subtype mapping available for this Notice:<xsl:value-of select="$newline"/>
		<xsl:value-of select="fn:string-join(($ted-form-element, $ted-form-name, $ted-form-notice-type, $ted-form-legal-basis, $ted-form-document-code), ':')"/></xsl:message>
	</xsl:if>
	<xsl:value-of select="$eforms-subtype"/>
</xsl:function>

<xsl:variable name="form-types" select="fn:document('ubl-form-types.xml')"/>

<xsl:function name="opfun:get-eforms-element-name" as="xs:string">
	<xsl:param name="form-abbreviation" as="xs:string"/>
	<xsl:value-of select="$form-types//form-type[abbreviation=$form-abbreviation]/fn:string(element-name)"/>
</xsl:function>

<xsl:function name="opfun:get-eforms-xmlns" as="xs:string">
	<xsl:param name="form-abbreviation" as="xs:string"/>
	<xsl:value-of select="$form-types//form-type[abbreviation=$form-abbreviation]/fn:string(xmlns)"/>
</xsl:function>

	
</xsl:stylesheet>
