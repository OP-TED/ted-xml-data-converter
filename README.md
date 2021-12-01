## TED XML to eForms XML Converter

Project to convert notices in TED XML format to eForms XML format

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
<br>

### Conversion using the command line

The conversion is currently being tested using the Saxon-HE 9.9.1.7J Java processor, available here: https://sourceforge.net/projects/saxon/files/Saxon-HE/9.9/. Documentation is available here: https://saxonica.com/documentation9.9/index.html#!using-xsl

A typical Unix command-line command to convert a file is:

`java  -Xms6291456  -cp [path to saxon folder]/saxon9he.jar net.sf.saxon.Transform  -dtd:off -expand:off -strip:all  -s:ted-xml/21-000061-001-EXP.xml -xsl:xslt/ted-to-eforms.xslt -o:eforms-xml/21-000061-001-EXP.xml`

To convert all the test TED XML files use:

`find ted-xml -type f -name "*.xml" | while read -r file; do outfile=${file/ted-xml/eforms-xml}; java -Xms6291456 -cp [path to saxon folder]/saxon9he.jar net.sf.saxon.Transform -dtd:off -expand:off -strip:all  -s:"$file" -xsl:xslt/ted-to-eforms.xslt -o:"$outfile"; done `

<br>
<br>

### Testing the XSLT

The XSLT can be tested using the unit-testing [XSpec framework](https://github.com/xspec/xspec). Tests are written in XML, and reports are output in both XML and HTML. Installation instructions, documentation and a tutorial are available on the [XSpec wiki](https://github.com/xspec/xspec/wiki/Getting-Started).

The Unix command to test the XSLT is:

[path to XSpec folder]/bin/xspec.sh xslt/test-ted-to-eforms-xslt.xspec





