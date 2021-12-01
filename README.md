# TED XML to eForms XML Converter

Project to convert notices in TED XML format to eForms XML format.

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
|  [ted-to-eforms.xslt](xslt/ted-to-eforms.xslt) | The main (starting) XSLT file |
|  [functions-and-data.xslt](xslt/functions-and-data.xslt) | An XSLT file for retrieving data from other files, and common functions |
|  [ted-to-eforms-simple.xslt](xslt/ted-to-eforms-simple.xslt) | An XSLT file containing simple templates (one-to-one mappings) |
|  [ted-to-eforms-addresses.xslt](xslt/ted-to-eforms-addresses.xslt) | An XSLT file containing templates for converting addresses |
|  [ted-to-eforms-award-criteria.xslt](xslt/ted-to-eforms-award-criteria.xslt) | An XSLT file containing templates for converting Award Criteria (BG-38) |
|  [ubl-form-types.xml](xslt/ubl-form-types.xml) | An XML file containing mappings data for eForms form element names and XML namespaces |
|  [languages.xml](xslt/languages.xml) | The "Language" codelist XML file, downloaded from https://op.europa.eu/en/web/eu-vocabularies/e-procurement/tables |
| XML Support files |
| [ted-notice-mapping.xml](xslt/ted-notice-mapping.xml) | Mapping file to determine eForms Notice Subtype from TED XML content |
| [ubl-form-types.xml](xslt/ubl-form-types.xml) | Mapping file from Notice Tyep abbreviation (eg CAN) to root element name and namespace |
| [languages.xml](xslt/languages.xml) | Authority codelist for languages, to map from TED abbreviations to eForms abbreviations |
| Testing |
| [test-ted-to-eforms-xslt.xspec](xslt/test-ted-to-eforms-xslt.xspec) | XSPec file for testing the XSLT |

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
