
# Disclaimer
This project is currently under development. We may update the current version and replace it with a new version at any time. In this case, we recommend you retrieve the latest version in order to ensure technical compliance. The Publications Office cannot guarantee the accuracy, adequacy, validity, reliability, availability or completeness of this information and accepts no responsibility for any use you may make of this project’s component parts.

# Purpose

The purpose of the TED XML Data Converter is to assist eSenders in the migration to eForms. 

An eSender may wish to switch the production of notices in their system from the TED schemas to the eForms schema on a single date. In this case, they will have published some initial notices (PIN, Contract Notice, etc.) for an ongoing Procedure using the TED schemas. They will want to publish following notices, continuing the Procedure, using the eForms schema. 

The TED XML Data Converter is designed to help with this process, by converting a notice published in the TED schemas, to a draft form of the same notice in eForms. The eSender can then correct and complete this notice, and use it as a basis for creating a following notice in eForms.

# How to use

The code for the TED XML Data Converter is contained in this repository. Basic usage instructions for developers to run the code in their own system is available [here](Usage-Information.md).
An API will be developed for the converter. A user will specify the TED notice number, and the API will retrieve the published TED notice XML, convert it to eForms XML and return it to the user.

## XML output will be incomplete and invalid.

The XML output from the TED XML Data Converter will not be complete, and will also contain some errors. It will not pass all the eForms Schematron checks. This is because:

* Some information required by eForms is not used in the TED schemas (for example: )
* Some information present in the TED XML is in a different format from that required by eForms (for example: textual description in TED XML, a specific code from a codelist in eForms XML)


## Limited Scope

The current version of the TED XML Data Converter will only convert a limited subset of published TED notices:

* TED Schema: Only TED schema R.2.0.9 is supported. Notices published under Directive 23 cannot be converted with this version of the Converter.
* TED Schema version: Only the latest version of the TED schema R.2.0.9 (S05) is supported. Notices published under earlier versions of the schema may be converted, but may contain more errors.
* Contract Notices: Only Contract Notices are currently supported.


## HTML Comments in output eForms XML

Each leaf element in the output eForms XML will be preceded by an HTML comment naming the Business Term it is associated with.
Where an XML element or Business Term is mandatory for an eForms notice, and the source TED XML does not contain the required information:

* The eForms XML element associated with the mandatory Business Term will be included in the output.
* An HTML comment will precede the XML element stating that required information was not found in the source TED XML.
* In some cases, such as dates, valid values will be added to make the XML schema-valid.


## Versioning scheme

Some notes about the versioning scheme here. Similar to that for the eForms SDK.

## Developer information

Information about the code and associated files, and brief information on how to use them, can be found [here](Usage-Information.md).


## Feedback

Feedback on this converter is welcome. Please address questions, comments and bug reports using the [Contact details on SIMAP](https://simap.ted.europa.eu/contact). Please ensure you include "TEDXDC Converter" in the Subject line.



