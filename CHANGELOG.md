
# TED XML Data Converter 1.0.0 Release Notes

This is the first production-ready release of the TED XML Data Converter. It can convert notices published in the R2.0.9 TED schema, versions S01 to S05. It is not able to convert notices published in the R2.0.8 schema, or notices published under the 1370/2007 ("Transport") Regulation.

It is not possible to convert F14 (Corrigendum) notices, due to their text-based format. F20 (Contract Modification) notices can be converted, but only the original contract information will be included, the modifications will be excluded.

## Code changes

* Improved reporting of errors for notices which cannot be converted
* Fixed subtype mapping for form F15
* Added mapping from DIRECTIVE to Procedure Legal Basis (BT-01)
* Derived OJEU Identifier (OPP-011) and OJEU Publication Date (OPP-012) from TED XML
* Added Description elements to countries-map.xml and languages-map.xml
* Added new test notices to cover all convertible forms and elements
WINNER, ADDRESS_WINNER, AWARDED_PRIZE, NO_AWARDED_PRIZE, DATE_DECISION_JURY, NB_PARTICIPANTS, NB_MAX_PARTICIPANTS, NB_MIN_PARTICIPANTS

## Bug fixes

* Where INFO_ADD and URL_NATIONAL_PROCEDURE exist together
* Mapping for F15, Directive 2014/25/EU
* BT-163 Concession Value Description
* Links to previous notices: Previous Planning Identifier (BT-125(i)) and Previous Notice Identifier (OPP-090)
