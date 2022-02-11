<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:functx="http://www.functx.com" 
xmlns:doc="http://www.pnp-software.com/XSLTdoc" xmlns:opfun="http://publications.europa.eu/local/xslt-functions"
xmlns:ted="http://publications.europa.eu/resource/schema/ted/R2.0.9/publication" xmlns:n2016="http://publications.europa.eu/resource/schema/ted/2016/nuts" 
xmlns:efbc="http://data.europa.eu/p27/eforms-ubl-extension-basic-components/1" xmlns:efac="http://data.europa.eu/p27/eforms-ubl-extension-aggregate-components/1" xmlns:efext="http://data.europa.eu/p27/eforms-ubl-extensions/1" xmlns:pin="urn:oasis:names:specification:ubl:schema:xsd:PriorInformationNotice-2" xmlns:cn="urn:oasis:names:specification:ubl:schema:xsd:ContractNotice-2" xmlns:can="urn:oasis:names:specification:ubl:schema:xsd:ContractAwardNotice-2"
xmlns:ccts="urn:un:unece:uncefact:documentation:2" xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
xmlns:gc="http://docs.oasis-open.org/codelist/ns/genericode/1.0/"
exclude-result-prefixes="xs xsi fn functx doc opfun ted gc n2016 pin cn can ccts ext" >
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

	<xsl:template match="ted:OFFICIALNAME">
		<cac:PartyName>
			<cbc:Name><xsl:apply-templates/></cbc:Name>
		</cac:PartyName>
	</xsl:template>
	
	<xsl:template match="ted:URL_GENERAL">
		<cbc:WebsiteURI><xsl:apply-templates/></cbc:WebsiteURI>
	</xsl:template>
	<!-- Need to investigate purpose and meaning of element URL_BUYER in addresses not CONTRACTING_BODY -->
	<!--
	<xsl:template match="ted:URL_BUYER">
		<cbc:EndpointID><xsl:apply-templates/></cbc:EndpointID>
	</xsl:template>
	-->
	<xsl:template match="ted:ADDRESS">
		<cbc:StreetName><xsl:apply-templates/></cbc:StreetName>
	</xsl:template>
	
	<xsl:template match="ted:TOWN">
		<cbc:CityName><xsl:apply-templates/></cbc:CityName>
	</xsl:template>
	
	<xsl:template match="ted:POSTAL_CODE">
		<cbc:PostalZone><xsl:apply-templates/></cbc:PostalZone>
	</xsl:template>
	
	<xsl:template match="n2016:NUTS">
		<cbc:CountrySubentityCode listName="nuts"><xsl:value-of select="@CODE"/></cbc:CountrySubentityCode>
	</xsl:template>
	
	<xsl:template match="ted:COUNTRY">
		<cac:Country>
			<cbc:IdentificationCode><xsl:value-of select="@VALUE"/></cbc:IdentificationCode>
		</cac:Country>
	</xsl:template>
	
	<xsl:template match="ted:PHONE">
		<cbc:Telephone><xsl:apply-templates/></cbc:Telephone>
	</xsl:template>

	<xsl:template match="ted:FAX">
		<cbc:Telefax><xsl:apply-templates/></cbc:Telefax>
	</xsl:template>

	<xsl:template match="ted:E_MAIL">
		<cbc:ElectronicMail><xsl:apply-templates/></cbc:ElectronicMail>
	</xsl:template>
	
	<xsl:template match="ted:URL_BUYER">
		<cbc:BuyerProfileURI><xsl:apply-templates/></cbc:BuyerProfileURI>
	</xsl:template>
	
	
	<!-- 
						<OFFICIALNAME>European Commission, Directorate-General for Informatics, Directorate A: Startegy and Resources, Unit A3: ICT Procurement and Contracts</OFFICIALNAME>
						<ADDRESS>rue Montoyer 15, Office MO15 07/P001</ADDRESS>
						<TOWN>Brussels</TOWN>
						<POSTAL_CODE>1049</POSTAL_CODE>
						<COUNTRY VALUE="BE"/>
						<CONTACT_POINT>Digit Contracts Info Centre</CONTACT_POINT>
						<E_MAIL>digit-contracts-info-centre@ec.europa.eu</E_MAIL>
						<n2016:NUTS CODE="BE1"/>
						<URL_GENERAL>https://ec.europa.eu/info/departments/informatics_en#responsibilities</URL_GENERAL>
						<URL_BUYER>https://ec.europa.eu/info/funding-tenders/tenders/tender-opportunities-department/tender-opportunities-informatics_en</URL_BUYER>
	
	-->
	
	
	
	<xsl:template match="ted:LOT_MAX_ONE_TENDERER">
		<cbc:MaximumLotsAwardedNumeric><xsl:apply-templates/></cbc:MaximumLotsAwardedNumeric>
	</xsl:template>
	
	<xsl:template match="ted:LOT_ALL">
		<cbc:MaximumLotsSubmittedNumeric><xsl:value-of select="$number-of-lots"/></cbc:MaximumLotsSubmittedNumeric>
	</xsl:template>
	
	<xsl:template match="ted:LOT_MAX_NUMBER">
		<cbc:MaximumLotsSubmittedNumeric><xsl:apply-templates/></cbc:MaximumLotsSubmittedNumeric>
	</xsl:template>
	
	<xsl:template match="ted:LOT_ONE_ONLY">
		<cbc:MaximumLotsSubmittedNumeric>1</cbc:MaximumLotsSubmittedNumeric>
	</xsl:template>
	
	<xsl:template match="ted:ACCEPTED_VARIANTS">
		<cbc:VariantConstraintCode listName="permission">allowed</cbc:VariantConstraintCode>
	</xsl:template>
	
	<xsl:template match="ted:NO_ACCEPTED_VARIANTS">
		<cbc:VariantConstraintCode listName="permission">not allowed</cbc:VariantConstraintCode>
	</xsl:template>
	
	<xsl:template match="ted:EU_PROGR_RELATED">
		<cbc:FundingProgramCode listName="eu-funded">eu-funds</cbc:FundingProgramCode>
	</xsl:template>
	
	<xsl:template match="ted:NO_EU_PROGR_RELATED">
		<cbc:FundingProgramCode listName="eu-funded">no-eu-funds</cbc:FundingProgramCode>
	</xsl:template>
	
	<!-- The TED element PERFORMANCE_STAFF_QUALIFICATION does not indicate at what procedure stage  supporting information for staff qualification should be provided, "t-requ" or "par-requ"  
	requirement-stage codelist:
	t-requ Tender requirement
	par-requ Request to participate requirement
	not-requ Not required
	nyk Not yet known 
	-->
	<xsl:template match="ted:PERFORMANCE_STAFF_QUALIFICATION">
		<cbc:RequiredCurriculaCode listName="requirement-stage"></cbc:RequiredCurriculaCode>
	</xsl:template>
	
	<xsl:template match="ted:RECURRENT_PROCUREMENT">
		<cbc:RecurringProcurementIndicator>true</cbc:RecurringProcurementIndicator>
	</xsl:template>
	
	<xsl:template match="ted:NO_RECURRENT_PROCUREMENT">
		<cbc:RecurringProcurementIndicator>false</cbc:RecurringProcurementIndicator>
	</xsl:template>

	<xsl:template match="ted:ESTIMATED_TIMING">
		<xsl:variable name="text" select="fn:normalize-space(fn:string-join(ted:P, ' '))"/>
		<xsl:if test="$text ne ''">
			<cbc:RecurringProcurementDescription languageID="{$eforms-first-language}"><xsl:value-of select="$text"/></cbc:RecurringProcurementDescription>
		</xsl:if>
	</xsl:template>

	<xsl:template match="ted:RIGHT_CONTRACT_INITIAL_TENDERS">
		<cbc:NoFurtherNegotiationIndicator>true</cbc:NoFurtherNegotiationIndicator>
	</xsl:template>

	<xsl:template match="ted:URL_PARTICIPATION">
		<cbc:EndpointID><xsl:apply-templates/></cbc:EndpointID>
	</xsl:template>
	
	<xsl:template match="ted:EORDERING">
		<cbc:ElectronicOrderUsageIndicator>true</cbc:ElectronicOrderUsageIndicator>
	</xsl:template>
	
	<xsl:template match="ted:EINVOICING">
		<cbc:ElectronicPaymentUsageIndicator>true</cbc:ElectronicPaymentUsageIndicator>
	</xsl:template>

	<xsl:template match="ted:URL_TOOL">
		<cbc:AccessToolsURI><xsl:apply-templates/></cbc:AccessToolsURI>
	</xsl:template>
	
</xsl:stylesheet>
