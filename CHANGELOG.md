
# TED XML Data Converter 1.0.1 Release Notes

This is a bugfix release of the TED XML Data Converter.

## SDK version
* Updated version of converted eForms notices to SDK-1.10

## Bug fixes

* Notice Publication Identifier (OPP-010): replaced hard-coded value with value from TED_EXPORT/@DOC_ID
* Contract Conclusion Date (BT-145): only output first date found when different dates were found in DATE_CONCLUSION_CONTRACT sharing the same CONTRACT_NO
* Fixed invalid eForms generation of Award Criterion Number (BT-541) efbc:ParameterNumeric from text in AC_WEIGHTING
* Fixed invalid order of Concession Revenue User (BT-162) efbc:RevenueUserAmount and Concession Revenue Buyer (BT-160) efbc:RevenueBuyerAmount
* Changed content of Framework Maximum Participants Number (BT-113) cbc:MaximumOperatorQuantity to "1" when no value is found in the TED XML
* Moved Participant Name (BT-47) from cac:ProcurementProject to cac:TenderingTerms
* Subtype 36: included Contract IDs in LotResults
* Improved detection of Lots referenced from AWARD_CONTRACT
* Created separate contracts for AWARD_CONTRACT elements which do not contain CONTRACT_NO.



## Notes
This release of the TED XML Data Converter can convert notices published in the R2.0.9 TED schema, versions S01 to S05. It is not able to convert notices published in the R2.0.8 schema, or notices published under the 1370/2007 ("Transport") Regulation.

It is not possible to convert F14 (Corrigendum) notices, due to their text-based format. F20 (Contract Modification) notices can be converted, but only the original contract information will be included, the modifications will be excluded.


