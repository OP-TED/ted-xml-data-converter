
# TED XML Data Converter 0.6.0 Release Notes

## Prior Information Notices - TED forms F01, F04, F08, F21, F22, F23
Templates have been added to convert elements in TED XML Prior Information 
Notice forms F01, F04, F08, F21, F22, F23.

## Previous versions of R2.0.9 schema

In some previous versions of the R2.0.9 schema, different namespace URIs were used. To allow processing of XML files using these schemas without requiring extensive changes to the XSLT code, the "ted" namespace prefix used to reference TED elements was replaced by the * wildcard. Similarly, the "nuts" namespace prefix was replaced by the * wildcard to reference prior versions of the NUTS schema.

The different namspaces were declared with prefixes as follows:

| prefix | namespace URI |
| --- | --- |
| ted | http://publications.europa.eu/resource/schema/ted/R2.0.9/publication | 
| ted-1 | http://formex.publications.europa.eu/ted/schema/export/R2.0.9.S01.E01 |
| ted-2 | ted/R2.0.9.S02/publication |
| n2021 | http://publications.europa.eu/resource/schema/ted/2021/nuts |
| n2016 | http://publications.europa.eu/resource/schema/ted/2016/nuts |
| n2016-1 | ted/2016/nuts |


* added new namespace declarations
* changed references to TED elements to use the * wildcard for the namespace prefix

## 2022 Amendment to the eForms Regulation

The amendment to the 2019 eForms Implementing Regulation published in November 2022 [http://data.europa.eu/eli/reg_impl/2022/2303/oj](http://data.europa.eu/eli/reg_impl/2022/2303/oj)  changed and added several business terms.


## New parameters to set values for Business Terms

* `"notice-identifier"` for `BT-701 Notice Identifier` 
* `"procedure-identifier"` for `BT-04 Procedure Identifier` 
* `"sdk-version"` for the SDK version 

eforms-notice-subtypes.xml

## Minor changes
* Added mapping file eforms-notice-subtypes.xml to define BT-02 Notice Type and BT-03 Form Type
* The format of the LotResult Technical ID (OPT-322) was corrected
