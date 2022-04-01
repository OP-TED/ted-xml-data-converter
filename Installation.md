# TED XML to eForms XML Converter - installation instructions

Project to convert notices in TED XML format to eForms XML format

Please see the [README.md](README.md) file for information about the files included in this repository.


## Installation instructions

These instructions are for installation in a Unix environment.

<br>

## Summary
To run the converter requires the following :

### Java

The user's system must have either a Java Virtual Machine, or a Java development environment. At least Java SE 8 (also known as JDK 1.8) must be available. Java must be available to run from the Unix terminal. Type "java -version" to confirm.

<br>

### Saxon, or another XSLT processor

A processor for XSLT version 2.0 is required. This converter has only been tested using the open-source version of Saxon, Saxon-9 HE, available from https://sourceforge.net/projects/saxon/files/Saxon-HE/9.9/. The installation instructions are here: https://www.saxonica.com/html/documentation9.9/about/installationjava/. Make sure the saxon9he.jar file is in the Java CLASSPATH environment variable.

Documentation on running XSL using Saxon9 is available here: https://saxonica.com/documentation9.9/index.html#!using-xsl

<br>

### This repository

Clone the TED XML Data Converter from https://github.com/OP-TED/ted-xml-data-converter.

<br>

## Using the TED XML Data Converter

### Running the converter

A typical Unix command to convert a file is:

`java  -Xms6291456  -cp [path to saxon folder]/saxon9he.jar net.sf.saxon.Transform  -dtd:off -expand:off -strip:all  -s:sample-files/ted-xml/21-000061-001-EXP.xml -xsl:xslt/ted-to-eforms.xslt -o:sample-files/eforms-xml/21-000061-001-EXP.xml`

To convert all the test TED XML files use:

`find sample-files/ted-xml -type f -name "*.xml" | while read -r file; do outfile=${file/ted-xml/eforms-xml}; java -Xms6291456 -cp [path to saxon folder]/saxon9he.jar net.sf.saxon.Transform -dtd:off -expand:off -strip:all  -s:"$file" -xsl:xslt/ted-to-eforms.xslt -o:"$outfile"; done `





