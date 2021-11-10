<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions"
 xmlns:o="urn:schemas-microsoft-com:office:office"
 xmlns:x="urn:schemas-microsoft-com:office:excel"
 xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
 xmlns:html="http://www.w3.org/TR/REC-html40"
 exclude-result-prefixes="xs fn o x ss html ">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

<!-- IDENTITY TEMPLATE -->

    <xsl:template match="@*|node()">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

	
<xsl:template match="/">
	<xsl:apply-templates select="/*/ss:Worksheet[@ss:Name='form-notice-mapping']"/>
</xsl:template>

<xsl:template match="/*/ss:Worksheet">
	<xsl:variable name="sheetname" select="fn:string(@ss:Name)"/>
	<mapping name="{$sheetname}">
		<xsl:apply-templates select="ss:Table"/>
	</mapping>
</xsl:template>

<xsl:template match="ss:Table">
	<xsl:variable name="headings" as="xs:string*">
		<xsl:for-each select="ss:Row[1]/ss:Cell">
			<xsl:value-of select="fn:lower-case(fn:replace(., ' ', '-'))"/>
		</xsl:for-each>
	</xsl:variable>
	<xsl:apply-templates select="ss:Row[position() > 1]">
		<xsl:with-param name="headings" select="$headings"/>
	</xsl:apply-templates>

</xsl:template>

<xsl:template match="ss:Row">
	<xsl:param name="headings"/>
	<xsl:variable name="thisrow" select="."/>
	<xsl:variable name="rowpos" select="fn:count(./preceding-sibling::ss:Row) + 1"/>
	<xsl:element name="row">
		<xsl:attribute name="rowpos" select="$rowpos"/>
		<xsl:variable name="normalisedrow">
			<xsl:call-template name="processcell">
				<xsl:with-param name="realpos" select="1"/>
				<xsl:with-param name="cellpos" select="1"/>
				<xsl:with-param name="row" select="$thisrow"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:for-each select="$headings">
			<xsl:variable name="pos" select="fn:position()"/>
			<xsl:variable name="elemname" select="."/>
			<xsl:variable name="value" select="$normalisedrow/cell[@realpos = $pos]/text()"/>
			<xsl:variable name="value-normalised" select="if (fn:matches($value,'^\d\.\d{3,}(E-?[0-9]+)?$')) then fn:format-number($value, '##.###') else $value"/>
			<xsl:element name="{$elemname}">
				<xsl:value-of select="$value-normalised"/>
			</xsl:element>
		</xsl:for-each>
	</xsl:element>
</xsl:template>

<xsl:template name="processcell">
	<xsl:param name="realpos" as="xs:integer"/>
	<xsl:param name="cellpos" as="xs:integer"/>
	<xsl:param name="row"/>
	<xsl:variable name="cell" select="$row/ss:Cell[$cellpos]"/>
	<xsl:variable name="normalisedpos" select="if ($cell[@ss:Index]) then xs:integer($cell/@ss:Index) else $realpos"/>
	<xsl:variable name="value" select="fn:string($cell[1])"/>
	<xsl:element name="cell">
		<xsl:attribute name="cellpos" select="$cellpos"/>
		<xsl:attribute name="realpos" select="$normalisedpos"/>
		<xsl:value-of select="$value"/>
	</xsl:element>
	<xsl:if test="$row/ss:Cell[$cellpos + 1]">
		<xsl:call-template name="processcell">
			<xsl:with-param name="realpos" select="$normalisedpos + 1"/>
			<xsl:with-param name="cellpos" select="$cellpos + 1"/>
			<xsl:with-param name="row" select="$row"/>
		</xsl:call-template>
	</xsl:if>
</xsl:template>

</xsl:stylesheet>
