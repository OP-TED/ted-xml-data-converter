# TED XML to eForms XML Converter Usage information

## Summary
The repository contains the following folders:

| Folder | Purpose |
| --- | --- |
| `xslt` | The xslt and data for the conversion |
| `ted-xml` | Sample source TED XML files. See [Files-Selected-for-Testing.md](ted-xml/Files-Selected-for-Testing.md) |
| `eforms-xml` | The converted eForms XML files. |
| `data` | This folder should be removed. Files used for analysis |
| `examples` | Some files in this folder should be removed. Sample XML in TED schema XML and eForms XML format for testing the converter |

## XSLT files
Currently, the `xslt` folder contains these files:

| File | Purpose |
| --- | --- |
| XSLT |
|  [ted-to-eforms.xslt](xslt/ted-to-eforms.xslt) | The main (starting) XSLT file |
|  [functx-1.0.1-doc.xsl](xslt/functx-1.0.1-doc.xsl) | The FunctX XSLT Function Library, available [here](http://www.xsltfunctions.com/) |
|  [functions-and-data.xslt](xslt/functions-and-data.xslt) | An XSLT file for retrieving data from the mapping files, and common functions |
|  [ted-to-eforms-simple.xslt](xslt/ted-to-eforms-simple.xslt) | An XSLT file containing simple templates (one-to-one mappings) |
|  [ted-to-eforms-addresses.xslt](xslt/ted-to-eforms-addresses.xslt) | An XSLT file containing templates for converting addresses |
|  [ted-to-eforms-award-criteria.xslt](xslt/ted-to-eforms-award-criteria.xslt) | An XSLT file containing templates for converting Award Criteria (BG-38) |
|  [ted-to-eforms-procedure.xslt](xslt/ted-to-eforms-procedure.xslt) | An XSLT file containing templates for converting information at Procedure level |
|  [ted-to-eforms-lot.xslt](xslt/ted-to-eforms-lot.xslt) | An XSLT file containing templates for converting information at Lot level |
| Mapping files |
| [ted-notice-type-mapping.xml](xslt/ted-notice-mapping.xml) | Mapping file to determine eForms Notice Subtype from TED XML content |
| [languages.xml](xslt/languages.xml) | The "Language" codelist XML file, downloaded from https://op.europa.eu/en/web/eu-vocabularies/e-procurement/tables |
| [other-mappings.xml](xslt/other-mappings.xml) | A file containing other data mappings |

## Usage

The TEDXDC Converter 

<br>

<br>



---

Content below this line is relevant to the eForms developers, and ma be moved to another Markdown file in this repository or deleted.

---

<br>

### Analysis files in the `data` folder

These files are in draft status.

The "structure" files are intended to include all possible elements used in eForms. This excludes elements that are valid according to the relevant eForms schema, but which are not actually used in eForms. Use of the correct attributes and values is not guaranteed. These files will not pass the eForms business rules Schematron validation. Element values used are fictitious, and may be redundant or inconsistent or contradictory.

Repeatability. Where elements are repeatable, it is not the purpose of these XML files to show that. Only one instance of these elements will usually be present. However, where the schema defines an exclusive choice of child elements for a parent element (meaning that the XML would be schema-invalid if the same parent element contained both child elements), then the parent element will be repeated to allow all possible child elements to be present, and maintain schema validity.



Project to convert notices in TED XML format to eForms XML format.

Please see [Conversion-Methodology.md](Conversion-Methodology.md) for the approach and methodology for developing the conversion XSLT.

Please see [Installation.md](Installation.md) for installation and usage instructions.


| File | Purpose |
| --- | --- |
| notice-structure-CN.xml | XML file containing all possible used elements for any Contract Notice |
| notice-structure-CAN.xml | XML file containing all possible used elements for any Contract Award Notice |
| notice-structure-PIN-CFC.xml | XML file containing all possible used elements for any PIN used as a Call for Competition Notice |
