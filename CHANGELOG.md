
# TED XML Data Converter 0.5.0 Release Notes

## Contract Award Notices - TED forms F06, F13, F15, F21, F22, F23, F24, F25
Templates have been added to convert elements in TED XML Contract Award 
Notice forms F06, F13, F15, F21, F22, F23, F24, F25.

A mapping for all TED elements defining justifications for direct awards to 
values of the "direct-award-justification" codelist has been created for 
BT-136 (Direct Award Justification).

## Multilingual Business Terms
A new template has been created to handle the conversion of multilingual text, 
and the code for all such BTs has been updated to use it. One TED element,
URL_NATIONAL_PROCEDURE required the addition of static text included in the form PDF. The XML file 
"translations.xml" was created to hold the translations of the associated
labels from the source TED form PDFs.

## Improved performance
Performance analysis of the converter revealed a significant amount of time 
was spent parsing the large codelist files "countries.xml" and "languages.xml". 
A separate XSLT file "create-ted-map.xslt" was written to create the smaller XML 
files "countries-map.xml" and "languages-map.xml". The use of these XML files
instead of the original codelists reduced processing time by more than 50%.

## Control of the output of BT comments and warning messages
Two new templates "include-comment" and "report-warning" were added to the XSLT 
file functions-and-data.xslt in order to consolidate the processing of comments 
and warnings. Parameters were added to these templates to control their output; by
default their values are set to 1, which allows the output of these templates.
* "includecomments": set to 0 to suppress the "BT" comments from the output eForms XML
* "includewarnings": set to 0 to suppress the "WARNING" comments from the output eForms XML
* "showwarnings": set to 0 to suppress the "WARNING" comments from the output to the console

## Minor changes
* Minor fixes for Award Criteria and Contract Extension
* Improved conversion of values in AC_WEIGHTING
* The meaning of "cardinality" in HTML comments in the XSLT was clarified
