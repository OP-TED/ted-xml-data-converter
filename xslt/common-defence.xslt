<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xlink="http://www.w3.org/1999/xlink"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:doc="http://www.pnp-software.com/XSLTdoc"
xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:functx="http://www.functx.com" xmlns:opfun="http://data.europa.eu/p27/ted-xml-data-converter"
xmlns:ted="http://publications.europa.eu/resource/schema/ted/R2.0.8/publication" xmlns:ted-2="ted/R2.0.8.S03/publication"
xmlns:n2016="http://publications.europa.eu/resource/schema/ted/2016/nuts" xmlns:n2021="http://publications.europa.eu/resource/schema/ted/2021/nuts" xmlns:n2016-1="ted/2016/nuts"
xmlns:pin="urn:oasis:names:specification:ubl:schema:xsd:PriorInformationNotice-2" xmlns:cn="urn:oasis:names:specification:ubl:schema:xsd:ContractNotice-2" xmlns:can="urn:oasis:names:specification:ubl:schema:xsd:ContractAwardNotice-2"
xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"
xmlns:efbc="http://data.europa.eu/p27/eforms-ubl-extension-basic-components/1" xmlns:efac="http://data.europa.eu/p27/eforms-ubl-extension-aggregate-components/1" xmlns:efext="http://data.europa.eu/p27/eforms-ubl-extensions/1"
xmlns:ccts="urn:un:unece:uncefact:documentation:2" xmlns:gc="http://docs.oasis-open.org/codelist/ns/genericode/1.0/"
exclude-result-prefixes="xlink xs xsi fn functx doc opfun ted ted-2 gc n2016 n2016-1 n2021 pin cn can ccts ext" >
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

<xsl:template match="*:TITLE_CONTRACT">
	<xsl:variable name="text" select="fn:normalize-space(fn:string-join(*:P, ' '))"/>
	<xsl:call-template name="multilingual">
		<xsl:with-param name="contexts" select="."/>
		<xsl:with-param name="local" select="'P'"/>
		<xsl:with-param name="element" select="'cbc:Name'"/>
	</xsl:call-template>
</xsl:template>

<xsl:template match="*:TOTAL_QUANTITY_OR_SCOPE|*:LOT_DESCRIPTION">
	<xsl:variable name="text" select="fn:normalize-space(fn:string-join(*:P, ' '))"/>
	<xsl:call-template name="multilingual">
		<xsl:with-param name="contexts" select="."/>
		<xsl:with-param name="local" select="'P'"/>
		<xsl:with-param name="element" select="'cbc:Description'"/>
	</xsl:call-template>
</xsl:template>

<xsl:template match="*:FD_PRIOR_INFORMATION_DEFENCE|*:FD_PRIOR_INFORMATION">
	<xsl:variable name="ted-value" select="fn:normalize-space(@CTYPE)"/>
	<xsl:variable name="eforms-contract-nature-type" select="$mappings//contract-nature-types/mapping[ted-value eq $ted-value]/fn:string(eforms-value)"/>
	<cbc:ProcurementTypeCode listName="contract-nature"><xsl:value-of select="$eforms-contract-nature-type"/></cbc:ProcurementTypeCode>
</xsl:template>

<xsl:template match="*:TYPE_CONTRACT">
	<xsl:variable name="ted-value" select="fn:normalize-space(@VALUE)"/>
	<xsl:variable name="eforms-contract-nature-type" select="$mappings//contract-nature-types/mapping[ted-value eq $ted-value]/fn:string(eforms-value)"/>
	<cbc:ProcurementTypeCode listName="contract-nature"><xsl:value-of select="$eforms-contract-nature-type"/></cbc:ProcurementTypeCode>
</xsl:template>

<xsl:template match="*:CPV_MAIN">
	<xsl:variable name="ted-value" select="fn:normalize-space(*:CPV_CODE/@CODE)"/>
	<cac:MainCommodityClassification>
		<cbc:ItemClassificationCode listName="cpv"><xsl:value-of select="$ted-value"/></cbc:ItemClassificationCode>
	</cac:MainCommodityClassification>
</xsl:template>

<xsl:template match="*:CPV_ADDITIONAL">
	<xsl:variable name="ted-value" select="fn:normalize-space(*:CPV_CODE/@CODE)"/>
	<cac:AdditionalCommodityClassification>
		<cbc:ItemClassificationCode listName="cpv"><xsl:value-of select="$ted-value"/></cbc:ItemClassificationCode>
	</cac:AdditionalCommodityClassification>
</xsl:template>

<xsl:template match="*:SITE_OR_LOCATION[not(*:NUTS)]/*:LABEL">
	<xsl:variable name="text" select="fn:normalize-space(fn:string-join(*:P, ' '))"/>
	<cac:RealizedLocation>
		<xsl:call-template name="multilingual">
			<xsl:with-param name="contexts" select="."/>
			<xsl:with-param name="local" select="'P'"/>
			<xsl:with-param name="element" select="'cbc:Description'"/>
		</xsl:call-template>
	</cac:RealizedLocation>
</xsl:template>

<xsl:template match="*:SITE_OR_LOCATION/*:NUTS">
	<xsl:variable name="text" select="fn:normalize-space(fn:string-join(./*:LABEL/*:P, ' '))"/>
	<cac:RealizedLocation>
		<xsl:call-template name="multilingual">
			<xsl:with-param name="contexts" select="../*:LABEL"/>
			<xsl:with-param name="local" select="'P'"/>
			<xsl:with-param name="element" select="'cbc:Description'"/>
		</xsl:call-template>
		<cbc:CountrySubentityCode listName="nuts"><xsl:value-of select="@CODE"/></cbc:CountrySubentityCode>
	</cac:RealizedLocation>
</xsl:template>


<xsl:template name="place-performance">
	<!-- the BG-708 Place of Performance is Mandatory for most form subtypes, but none of its child BTs are Mandatory -->
	<!-- Note: it is not possible to convert the content of MAIN_SITE to any eForms elements that will pass the business rules validation. -->
	<!-- It is also not possible to recognise any part of the content of MAIN_SITE and assign it to a particular eForms BT -->
	<!-- To maintain any existing separation of the address in P elements: -->
	<!--    the first P element will be converted to a cac:AddressLine/cbc:StreetName element -->
	<!--    the second P element will be converted to a cac:AddressLine/cbc:AdditionalStreetName element -->
	<!--    the remaining P elements will be converted to separate cac:AddressLine/cbc:Line elements -->
	<!-- get list of only NUTS level 3 codes -->
	<xsl:param name="location-element" as="element()"/>
	<xsl:variable name="location-text-element" select="$location-element/(*:MAIN_SITE_WORKS|*:LOCATION|*:LABEL)"/>
	<xsl:variable name="location-text" select="fn:normalize-space(fn:string-join($location-text-element/(*:P|*:FT), ' '))"/>
	<xsl:variable name="location-nuts-codes" select="$location-element/opfun:get-valid-nuts-codes(*:NUTS/@CODE)" as="xs:string*"/>
	<xsl:variable name="main-nuts" select="$location-nuts-codes[1]"/>
	<xsl:variable name="rest-nuts" select="functx:value-except($location-nuts-codes, $main-nuts)"/>
	<xsl:if test="$location-text or fn:not(fn:empty($location-nuts-codes)) or $eforms-notice-subtype = ('1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '29', '30', '31', '32', '33', '34', '35', '36', '37')">
		<xsl:call-template name="include-comment"><xsl:with-param name="comment" select="'Place of performance (BG-708) : Place Performance: Additional Information (BT-728), City (BT-5131), Post Code (BT-5121), Country Subdivision (BT-5071), Services Other (as a codelist) (BT-727), Street (BT-5101), Code (BT-5141)'"/></xsl:call-template>
		<xsl:choose>
			<xsl:when test="fn:not($location-text) and fn:empty($location-nuts-codes)">
				<!-- No valid location text element and no valid NUTS codes -->
				<cac:RealizedLocation>
					<cac:Address>
						<cbc:Region>anyw</cbc:Region>
					</cac:Address>
				</cac:RealizedLocation>
			</xsl:when>
			<!-- Valid location text element and no valid NUTS codes -->
			<xsl:when test="$location-text and fn:empty($location-nuts-codes)">
				<!-- valid location text element exists but no valid NUTS codes -->
				<xsl:call-template name="main-site">
					<xsl:with-param name="nuts-code" select="''"/>
					<xsl:with-param name="main-site" select="$location-text-element"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<!-- valid location text element exists and at least one valid NUTS code exists, create a <cac:RealizedLocation><cac:Address> for each NUTS code -->
				<xsl:for-each select="$location-nuts-codes">
					<xsl:call-template name="main-site">
						<xsl:with-param name="nuts-code" select="."/>
						<xsl:with-param name="main-site" select="$location-text-element"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:if>
</xsl:template>

<xsl:template name="main-site">
	<xsl:param name="nuts-code"/>
	<xsl:param name="main-site"/>
	<xsl:variable name="valid-main-site-paragraphs" select="$main-site/(*:P|*:FT)[fn:normalize-space(.) != '']/fn:normalize-space()"/>
	<cac:RealizedLocation>
		<cac:Address>
			<!-- need to follow order of elements defined in the eForms schema -->
			<xsl:if test="$valid-main-site-paragraphs[1]">
				<cbc:StreetName>
					<xsl:value-of select="$valid-main-site-paragraphs[1]"/>
				</cbc:StreetName>
			</xsl:if>
			<xsl:if test="$valid-main-site-paragraphs[2]">
				<cbc:AdditionalStreetName>
					<xsl:value-of select="$valid-main-site-paragraphs[2]"/>
				</cbc:AdditionalStreetName>
			</xsl:if>
			<xsl:if test="$nuts-code != ''">
				<cbc:CountrySubentityCode listName="nuts">
					<xsl:value-of select="$nuts-code"/>
				</cbc:CountrySubentityCode>
			</xsl:if>
			<xsl:if test="$valid-main-site-paragraphs[3]">
				<xsl:variable name="address-line" select="fn:string-join(($valid-main-site-paragraphs[fn:position() &gt; 2]), ' ')"/>
				<cac:AddressLine>
					<cbc:Line>
						<xsl:value-of select="$address-line"/>
					</cbc:Line>
				</cac:AddressLine>
			</xsl:if>
		</cac:Address>
	</cac:RealizedLocation>
</xsl:template>

</xsl:stylesheet>
