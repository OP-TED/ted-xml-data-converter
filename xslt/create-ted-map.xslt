<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions"
exclude-result-prefixes=" xs xsl fn ">
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

<xsl:variable name="source-file-name" select="fn:replace(fn:base-uri(), '^.*/', '')"/>
<xsl:variable name="root-element-name" select="fn:replace($source-file-name,'\.xml', '')"/>
<xsl:variable name="singular-element-name">
	<xsl:choose>
		<xsl:when test="$root-element-name eq 'countries'"><xsl:text>country</xsl:text></xsl:when>
		<xsl:otherwise><xsl:value-of select="fn:replace($root-element-name, 's$', '')"/></xsl:otherwise>
	</xsl:choose>
</xsl:variable>

<xsl:template match="/">
	<!-- terminate processing if XML file contains more than one type of form (form element name) -->
	<xsl:element name="{$root-element-name}">
		<xsl:apply-templates select="//record[@deprecated='false'][op-mapped-code/@source='TED']"></xsl:apply-templates>
	</xsl:element>
</xsl:template>

<xsl:template match="record">
	<xsl:element name="{$singular-element-name}">
				<xsl:variable name="ted-form" select="fn:string(op-mapped-code[@source='TED'])"/>
				<xsl:variable name="eforms-form" select="fn:string(authority-code)"/>
				<ted><xsl:value-of select="$ted-form"/></ted>
				<eforms><xsl:value-of select="$eforms-form"/></eforms>
	</xsl:element>
</xsl:template>

</xsl:stylesheet>
