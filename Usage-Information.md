# TED XML to eForms XML Converter Usage information

## Summary
The repository contains the following folders:

| Folder | Purpose |
| --- | --- |
| `xslt` | The xslt and data for the conversion |
| `sample-files/ted-xml` | Sample source TED XML files. See [Files-Selected-for-Testing.md](sample-files/Files-Selected-for-Testing.md) |
| `sample-files/eforms-xml` | The sample source TED XML files converted to eForms XML files. |
| `structure-files` | Sample files for the structure of eForms XML. Only the notice-structure-CN.xml is complete. |
| `examples` | Some files in this folder should be removed. Sample XML in TED schema XML and eForms XML format for testing the converter |

## XSLT files
Currently, the `xslt` folder contains these files:

| File | Purpose |
| --- | --- |
| XSLT |
|  [ted-to-eforms.xslt](xslt/ted-to-eforms.xslt) | The main (starting) XSLT file |
|  [functx-1.0.1-doc.xsl](xslt/lib/functx-1.0.1-doc.xsl) | The FunctX XSLT Function Library, available [here](http://www.xsltfunctions.com/) |
|  [functions-and-data.xslt](xslt/functions-and-data.xslt) | An XSLT file for retrieving data from the mapping files, and common functions |
|  [simple.xslt](xslt/simple.xslt) | An XSLT file containing simple templates (one-to-one mappings) |
|  [addresses.xslt](xslt/addresses.xslt) | An XSLT file containing templates for converting addresses |
|  [award-criteria.xslt](xslt/award-criteria.xslt) | An XSLT file containing templates for converting Award Criteria (BG-38) |
|  [procedure.xslt](xslt/procedure.xslt) | An XSLT file containing templates for converting information at Procedure level |
|  [lot.xslt](xslt/lot.xslt) | An XSLT file containing templates for converting information at Lot level |
| Mapping files |
| [ted-notice-type-mapping.xml](xslt/ted-notice-mapping.xml) | Mapping file to determine eForms Notice Subtype from TED XML content |
| [languages.xml](xslt/languages.xml) | The "Language" codelist XML file, downloaded from https://op.europa.eu/en/web/eu-vocabularies/e-procurement/tables |
| [other-mappings.xml](xslt/other-mappings.xml) | A file containing other data mappings |

## Usage

The TEDXDC Converter has been developed and tested using the Saxon-9 HE XSLT processor, available from https://sourceforge.net/projects/saxon/files/Saxon-HE/9.9/. However any XSLT 2 processor can be used. The main template is ted-to-eforms.xslt, the other templates and data XML files are called by the main template.



Project to convert notices in TED XML format to eForms XML format.

Please see [Conversion-Methodology.md](Conversion-Methodology.md) for the approach and methodology for developing the conversion XSLT.

Please see [Installation.md](Installation.md) for installation and usage instructions.


<br>

<br>



---

Content below this line is relevant to the eForms developers, and ma be moved to another Markdown file in this repository or deleted.

---

<br>

### Analysis files in the `structure-files` folder

These files are in draft status.

The "structure" files are intended to include all possible elements used in eForms. This excludes elements that are valid according to the relevant eForms schema, but which are not actually used in eForms. Use of the correct attributes and values is not guaranteed. These files will not pass the eForms business rules Schematron validation. Element values used are fictitious, and may be redundant or inconsistent or contradictory.

Repeatability. Where elements are repeatable, it is not the purpose of these XML files to show that. Only one instance of these elements will usually be present. However, where the schema defines an exclusive choice of child elements for a parent element (meaning that the XML would be schema-invalid if the same parent element contained both child elements), then the parent element will be repeated to allow all possible child elements to be present, and maintain schema validity.



| File | Purpose |
| --- | --- |
| notice-structure-CN.xml | XML file containing all possible used elements for any Contract Notice |
| notice-structure-CAN.xml | XML file containing all possible used elements for any Contract Award Notice |
| notice-structure-PIN-CFC.xml | XML file containing all possible used elements for any PIN used as a Call for Competition Notice |
