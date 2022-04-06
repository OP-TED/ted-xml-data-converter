# TED XML to eForms XML Converter Usage information


## Usage

The TEDXDC Converter has been developed and tested using the Saxon-9 HE XSLT processor, available from https://sourceforge.net/projects/saxon/files/Saxon-HE/9.9/. However any XSLT 2 processor can be used. The main template is ted-to-eforms.xslt, the other templates and data XML files are called by the main template.

Please see [Development-Methodology.md](Development-Methodology.md) for the approach and methodology for developing the conversion XSLT.

Please see [Installation.md](Installation.md) for installation and usage instructions.

An API for the converter is being developed which will allow conversion of notices via HTTPS requests.
<br>

<br>

# About the converter

## XML output will be incomplete and invalid.

The XML output from the TED XML Data Converter will not be complete, and will also contain some errors. It will not pass all the eForms Schematron checks. This is because:

* Some information required by eForms is not used in the TED schemas (for example: Internal ID (BT-22) has no equivalent in the TED schema )
* Some information present in the TED XML is in a different format from that required by eForms (for example: a textual description in TED XML, a specific code from a codelist in eForms XML)

The TED XML Data Converter will report these issues as comments and application-level warnings.


## Limited Scope

The current version of the TED XML Data Converter will only convert a limited subset of published TED notices:

* TED Schema: only TED schema R.2.0.9 is supported. Notices published under Directive 23 cannot be converted with this version of the Converter.
* TED Schema version: only the latest version of the TED schema R.2.0.9 (S05) is supported. Notices published under earlier versions of the schema may be converted, but may contain more errors.
* Document Types: only Contract Notices are currently supported:
    * All elements in TED XML form F02 are supported
    * Most elements in TED XML forms F05, F12 and the Contract Notice variants of forms F21, F22, F23 and F24 are supported
* Languages: currently the converter only converts the main (original) language of each notice. Other languages which may be present in the TED XML are not included.

## HTML Comments in output eForms XML

Each leaf element in the output eForms XML will be preceded by an HTML comment naming the Business Term it is associated with.

## Warnings

Where the eForms XML standard requires information that is not present in the source TED XML, the XSLT application will report a warning.

* An HTML comment will precede the XML element stating that required information was not found in the source TED XML.
* A warning message will be sent to the XSLT processing application using \<xsl:message\>
* In some cases, such as dates, valid values will be added to make the XML schema-valid.

