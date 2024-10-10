
# TED XML Data Converter 1.0.4 Release Notes

This is a minor release of the TED XML Data Converter. Some cosmetic changes are not listed below.

## Changes

* Changed fatal error message output for F14 notices
* Changed mapping for NOTICE_NUMBER_OJ to always map to OPP-090

## Notes
This release of the TED XML Data Converter can convert notices published in the R2.0.9 TED schema, versions S01 to S05. It is not able to convert notices published in the R2.0.8 schema, or notices published under the 1370/2007 ("Transport") Regulation.

It is not possible to convert F14 (Corrigendum) notices, due to their text-based format. F20 (Contract Modification) notices can be converted, but only the original contract information will be included, the modifications will be excluded.
