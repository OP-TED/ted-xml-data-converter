# TED XML to eForms XML Converter


## Purpose

The purpose of the TED XML Data Converter is to assist eSenders in the migration to eForms. 

An eSender may wish to switch the production of notices in their system from the TED schemas to the eForms schema on a single date. In this case, they will have published some initial notices (PIN, Contract Notice, etc.) for an ongoing Procedure using the TED schemas. They will want to publish following notices, continuing the Procedure, using the eForms schema. 

The TED XML Data Converter is designed to help with this process, by converting a notice published in the TED schemas, to a draft form of the same notice in eForms. The eSender can then correct and complete this notice, and use it as a basis for creating a following notice in eForms.

## How to use

The code for the TED XML Data Converter is contained in this repository. Basic usage instructions for developers to run the code in their own system is available here (link to usage markdown file).
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

Information about the code and associated files, and brief information on how to use them, can be found here (link to code markdown file).


## Feedback

Feedback on this converter is welcome. Please address questions, comments and bug reports using the [Contact details on SIMAP](https://simap.ted.europa.eu/contact). Please ensure you include "TEDXDC Converter" in the Subject line.




<br>

<br>



---

Content below this line may be moved to another Markdown file in this repository or deleted.

---

<br>


Project to convert notices in TED XML format to eForms XML format.

Please see [Conversion-Methodology.md](Conversion-Methodology.md) for the approach and methodology for developing the conversion XSLT.

Please see [Installation.md](Installation.md) for installation and usage instructions.

### Summary
The repository contains the following folders:

| Folder | Purpose |
| --- | --- |
| `xslt` | The xslt and data for the conversion |
| `ted-xml` | Sample source TED XML files. See [Files-Selected-for-Testing.md](ted-xml/Files-Selected-for-Testing.md) |
| `eforms-xml` | The converted eForms XML files. |
| `data` | Files used for analysis |

### XSLT files
Currently, the `xslt` folder contains these files:

| File | Purpose |
| --- | --- |
| XSLT |
|  [ted-to-eforms.xslt](xslt/ted-to-eforms.xslt) | The main (starting) XSLT file |
|  [functions-and-data.xslt](xslt/functions-and-data.xslt) | An XSLT file for retrieving data from other files, and common functions |
|  [ted-to-eforms-simple.xslt](xslt/ted-to-eforms-simple.xslt) | An XSLT file containing simple templates (one-to-one mappings) |
|  [ted-to-eforms-addresses.xslt](xslt/ted-to-eforms-addresses.xslt) | An XSLT file containing templates for converting addresses |
|  [ted-to-eforms-award-criteria.xslt](xslt/ted-to-eforms-award-criteria.xslt) | An XSLT file containing templates for converting Award Criteria (BG-38) |
| XSpec testing |
| [test-ted-to-eforms-xslt.xspec](xslt/test-ted-to-eforms-xslt.xspec) | XSPec file for testing the XSLT |
| Mapping files |
|  [ubl-form-types.xml](xslt/ubl-form-types.xml) | An XML file containing mappings data for eForms form element names and XML namespaces |
|  [languages.xml](xslt/languages.xml) | The "Language" codelist XML file, downloaded from https://op.europa.eu/en/web/eu-vocabularies/e-procurement/tables |
| [ted-notice-mapping.xml](xslt/ted-notice-mapping.xml) | Mapping file to determine eForms Notice Subtype from TED XML content |
| [ubl-form-types.xml](xslt/ubl-form-types.xml) | Mapping file from Notice Type abbreviation (eg CAN) to root element name and namespace |
| [languages.xml](xslt/languages.xml) | Authority codelist for languages, to map from TED abbreviations to eForms abbreviations |
| [ca-types-mapping.xml](xslt/ca-types-mapping.xml) | Mapping file between CA_TYPE and buyer-legal-type |

<br>

### Analysis files in the `data` folder

These files are in draft status.

The "structure" files are intended to include all possible elements used in eForms. This excludes elements that are valid according to the relevant eForms schema, but which are not actually used in eForms. Use of the correct attributes and values is not guaranteed. These files will not pass the eForms business rules Schematron validation. Element values used are fictitious, and may be redundant or inconsistent or contradictory.

Repeatability. Where elements are repeatable, it is not the purpose of these XML files to show that. Only one instance of these elements will usually be present. However, where the schema defines an exclusive choice of child elements for a parent element (meaning that the XML would be schema-invalid if the same parent element contained both child elements), then the parent element will be repeated to allow all possible child elements to be present, and maintain schema validity.


| File | Purpose |
| --- | --- |
| notice-structure-CN.xml | XML file containing all possible used elements for any Contract Notice |
| notice-structure-CAN.xml | XML file containing all possible used elements for any Contract Award Notice |
| notice-structure-PIN-CFC.xml | XML file containing all possible used elements for any PIN used as a Call for Competition Notice |
