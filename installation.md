    # TED XML to eForms XML Converter: installation instructions

Please see the [README.md](README.md) file for information about the files included in this repository.


## Installation instructions

These instructions are for installation in a Unix environment.

<br>

## Summary
To run the converter requires the following:

### Java

The user's system must have either a Java Virtual Machine, or a Java development environment. At least Java SE 8 (also known as JDK 1.8) must be available. Java must be available to run from the Unix terminal. Type "java -version" to confirm.

<br>

### An XSLT processor

A processor for XSLT version 2.0 is required. This converter has only been tested using the open-source version of Saxon, Saxon-9 HE, available from https://sourceforge.net/projects/saxon/files/Saxon-HE/9.9/. The installation instructions are here: https://www.saxonica.com/html/documentation9.9/about/installationjava/. Make sure the saxon9he.jar file is in the Java CLASSPATH environment variable.

Documentation on running XSL using Saxon9 is available here: https://saxonica.com/documentation9.9/index.html#!using-xsl

<br>

### This repository

Clone the TED XML Data Converter from https://github.com/OP-TED/ted-xml-data-converter.

<br>

## Running the converter

A typical Unix command using Saxon HE to convert a file is:

`java -Xms6291456 -cp [path to saxon folder]/saxon9he.jar net.sf.saxon.Transform -dtd:off -expand:off -strip:all -s:development-notices/ted-xml/21-000061-001-EXP.xml -xsl:xslt/ted-to-eforms.xslt -o:development-notices/eforms-xml/21-000061-001-EXP.xml`

### Warnings and comments

Each leaf element in the output eForms XML will be preceded by an HTML comment naming the Business Term it is associated with.
Where the eForms XML standard requires information that is not present in the source TED XML, or the information is not of the 
required format, the XSLT application will report a warning, and the warning will be included in the output XML as an HTML comment.

These warnings and comments can be suppressed by the use of the "includecomments", "includewarnings" and "showwarnings" parameters:

`java -Xms6291456 -cp [path to saxon folder]/saxon9he.jar net.sf.saxon.Transform -dtd:off -expand:off -strip:all -s:development-notices/ted-xml/21-000061-001-EXP.xml -xsl:xslt/ted-to-eforms.xslt -o:development-notices/eforms-xml/21-000061-001-EXP.xml includecomments=0 includewarnings=0 showwarnings=0`

