# TED XML files selected for testing the converter

In order to provide a way of testing the converter, a set of Notices in both TED XML and eForms XML formats is required. The TED XML notices should be representative; each set of notices should:

- cover all the TED form types that have been included in the converter XSLT 
- collectively include all the TED XML elements used in each TED form type covered
- include variations in structure and language

This table lists the TED XML files chosen to test the Converter, and the reasons for their choosing.

| File | Form Name | Form Type | Reasons for selection |
| --- | --- | --- | --- | 
| 20-320448-001-EXP.xml | F02_2014 | CN | Covers 81 elements, 2 Lots |
| 20-242009-001-EXP.xml | F02_2014 | CN | Covers 25 other elements, 1 Lot, includes translations |
| 21-013188-001-EXP.xml | F02_2014 | CN | Covers 11 other elements, 1 Lot |
| 20-382921-001-EXP.xml | F02_2014 | CN | Covers 7 other elements, 1 Lot |
| 20-259392-001-EXP.xml | F02_2014 | CN | LOT_MAX_NUMBER = 2 and 4 Lots |
| 20-156925-001-EXP.xml | F02_2014 | CN | LOT_ONE_ONLY and 4 Lots |

There are 14 elements in TED not covered by the first four files:
ACCELERATED_PROC
AC_COST
CPV_SUPPLEMENTARY_CODE
DOCUMENT_RESTRICTED
LEGAL_BASIS_OTHER
LOT_COMBINING_CONTRACT_RIGHT
LOT_MAX_NUMBER
LOT_ONE_ONLY
PLACE
PROCUREMENT_LAW
PT_COMPETITIVE_DIALOGUE
PT_INNOVATION_PARTNERSHIP
RESTRICTED_SHELTERED_PROGRAM
RESTRICTED_SHELTERED_WORKSHOP

In TEDXDC-29, Lamya said that of the above list of elements, most can be added to one or more of the first four files in the list. The two that can't are: LOT_MAX_NUMBER and LOT_ONE_ONLY. These are covered by the last two files in the list.