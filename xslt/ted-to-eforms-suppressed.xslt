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

<!-- LEGAL_BASIS only occurs as direct child of the FORM ELEMENT, and is handled in <xsl:template name="notice-information"> -->
<xsl:template match="ted:LEGAL_BASIS"/>

<!-- NOTICE only occurs as direct child of the FORM ELEMENT, and is only used to select the eForms Notice subtype -->
<xsl:template match="ted:NOTICE"/>

<!-- In TED, within element CONTRACTING_BODY, the elements ADDRESS_FURTHER_INFO_IDEM and ADDRESS_PARTICIPATION_IDEM are used to represent options for "to the abovementioned address" in the PDF forms. -->
<!-- These indicate that for the functions of "Additional information can be obtained from" and "Tenders or requests to participate must be submitted to", the Contracting Authority address should be used. -->
<!-- in eForms, such a direction is implicit, and no such elements are used. So the element ADDRESS_FURTHER_INFO_IDEM will not be mapped. -->
<!-- However, the element ADDRESS_PARTICIPATION_IDEM may exist with a sibling element URL_PARTICIPATION, which is mapped to the element cbc:EndpointID within cac:TenderRecipientParty. -->
<!-- In this case, it does not make sense to include cac:TenderRecipientParty without pointing to the correct address, so ADDRESS_PARTICIPATION_IDEM will be mapped if it has a URL_PARTICIPATION sibling -->
<xsl:template match="ted:ADDRESS_FURTHER_INFO_IDEM"/>


</xsl:stylesheet>
