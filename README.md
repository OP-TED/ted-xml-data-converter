## TED XML to eForms XML Converter

Project to convert notices in TED XML format to eForms XML format

### Summary
The repository contains the following folders:

`xslt`: contains the xslt and data for the conversion

`ted-xml`: contains sample source TED XML files.

`eforms-xml`: contains the converted eForms XML files.

### XSLT files
Currently, the `xslt` folder contains these files:

`ted-to-eforms.xslt`: The main (starting) XSLT file

`functions-and-data.xslt`: An XSLT file for retrieving data from other files, and common functions

`ted-to-eforms-simple.xslt`: An XSLT file containing simple templates (one-to-one mappings)

`ted-to-eforms-addresses.xslt`: An XSLT file containing templates for converting addresses

`ted-to-eforms-award-criteria.xslt`: An XSLT file containing templates for converting Award Criteria (BG-38)

`ubl-form-types.xml`: An XML file containing mappings data for eForms form element names and XML namespaces

`languages.xml`: The "Language" codelist XML file, downloaded from https://op.europa.eu/en/web/eu-vocabularies/e-procurement/tables

### Conversion using the command line

The conversion is currently being tested using the Saxon-HE 9.9.1.7J Java processor, available here: https://sourceforge.net/projects/saxon/files/Saxon-HE/9.9/. Documentation is available here: https://saxonica.com/documentation9.9/index.html#!using-xsl

A typical 
Unix command-line command to convert a file is:

`java  -Xms6291456  -cp [path to saxon folder]/saxon9he.jar net.sf.saxon.Transform  -dtd:off -expand:off -strip:all  -s:ted-xml/21-000061-001-EXP.xml -xsl:xslt/ted-to-eforms.xslt -o:eforms-xml/21-000061-001-EXP.xml`
