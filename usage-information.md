# TED XML to eForms XML Converter Usage information


## Usage

The TEDXDC Converter has been developed and tested using the Saxon-9 HE XSLT processor, available from https://sourceforge.net/projects/saxon/files/Saxon-HE/9.9/. However any XSLT 2 processor can be used. The main template is ted-to-eforms.xslt, the other templates and data XML files are called by the main template.

Please see [development-methodology.md](development-methodology.md) for the approach and methodology for developing the conversion in XSLT.

Please see [installation.md](installation.md) for installation and usage instructions.

An API for the converter is temporarily available as part of the eNotices2 Publication API. Documentation is available at [TED API Documentation](https://docs.ted.europa.eu/api/endpoints/enotices2-ted-europa-eu-esenders.html) or the [eNotices2 Public API endpoints Documentation](https://enotices2.ted.europa.eu/esenders/webjars/swagger-ui/index.html).
<br>

<br>

# About the converter

## Incomplete and invalid XML output

The XML output from the TED XML Data Converter will not be complete, and will also contain some errors. It will not pass all the eForms Schematron checks. This is because:

* Some information required by eForms is not used in the TED schemas (for example: Internal ID (BT-22) has no equivalent in the TED schema )
* Some information present in the TED XML is in a different format from that required by eForms (for example: a textual description in TED XML, a specific code from a codelist in eForms XML)

The TED XML Data Converter will report these issues as comments and application-level warnings.


## Limited Scope

The current version of the TED XML Data Converter will convert a subset of published TED notices:

* TED Schema: only TED schema R.2.0.9 is supported. Notices published under Directive 81 cannot be converted with this version of the Converter.
* TED Schema version: only the latest versions of the TED schema R.2.0.9 (S01 to S05) are supported. Notices published under earlier versions of the schema may be converted, but may contain more errors.
* Document Types: All the standard TED XML forms using the R2.0.9 TED XML schema (with the exceptions of F14 Corrigendum and F20 Modification) are currently supported


## HTML Comments in output eForms XML

Each leaf element in the output eForms XML will be preceded by an HTML comment naming the Business Term it is associated with.
 
Where the eForms XML standard requires information that is not present in the source TED XML, or the information is not of the required format, the XSLT application will report a warning.

* An HTML comment will precede the XML element stating that required information was not found in the source TED XML.
* A warning message will be sent to the XSLT processing application using \<xsl:message\>.

## External Parameters

Parameters passed to the XSLT processor may be used to set values for some Business Terms, and some processing options.

### Parameters to set values for Business Terms

* Use parameter `"notice-identifier"` to set `BT-701 Notice Identifier` 
* Use parameter `"procedure-identifier"` to set `BT-04 Procedure Identifier` 
* Use parameter `"sdk-version"` to set the SDK version 

### Parameters to change display of Warnings and Business Term comments

* Set parameter `"includecomments"` to 0 to suppress Business Terms as HTML comments 
* Set parameter `"includewarnings"` to 0 to suppress Warnings as HTML comments 
* Set parameter `"showwarnings"` to 0 to suppress Warnings as application messages 
