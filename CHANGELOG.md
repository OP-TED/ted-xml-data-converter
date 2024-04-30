
# TED XML Data Converter 1.0.3 Release Notes

This is a bugfix release of the TED XML Data Converter. Some cosmetic changes are not listed below.

## Bug fixes

* Fatal error in "lot-results" template
* Improved link between LotResult and Lot

## Mapping changes

* Mapped from EEIG to eForms subtype X01

## Notes
This release of the TED XML Data Converter can convert notices published in the R2.0.9 TED schema, versions S01 to S05. It is not able to convert notices published in the R2.0.8 schema, or notices published under the 1370/2007 ("Transport") Regulation.

It is not possible to convert F14 (Corrigendum) notices, due to their text-based format. F20 (Contract Modification) notices can be converted, but only the original contract information will be included, the modifications will be excluded.
