# TED schema elements which cannot be converted to eForms

This table lists the elements defined in the TED R.2.0.9 schema for Contract Notices, but whose data cannot be converted to any data structures in eForms.

This table is under development. Elements used in Contract Award Notices and PINs have not been considered yet.

| TED Element | TED schema | Content format Usage | Description | Reason for inability to convert |
| --- | --- | --- | --- | --- |
| CA_ACTIVITY_OTHER | R.2.0.9 | Text | Alternative to CA_ACTIVITY, containing textual description | Cannot convert text to a code |
| CA_TYPE_OTHER | R.2.0.9 | Text | Alternative to CA_TYPE, containing textual description | Cannot convert text to a code |
| CRITERIA_CANDIDATE | R.2.0.9 | Text | Objective criteria for choosing the limited number of candidates | eForms does not record the criteria used for selecting candidates for the second stage |
| ECONOMIC_CRITERIA_DOC | R.2.0.9 | Text | Selection criteria as stated in the procurement documents | eForms does not allow for Selection Criteria to be contained in external documents |
| TECHNICAL_CRITERIA_DOC | R.2.0.9 | Text | Selection criteria as stated in the procurement documents | eForms does not allow for Selection Criteria to be contained in external documents |
| FT | R.2.0.9 | Text | Subscript and Superscript text within P (paragraph) elements | eForms does not support emphasised text. |
| LEGAL_BASIS_OTHER | R.2.0.9 | Text | LEGAL_BASIS_OTHER contains text which describes the legal basis for the notice | Cannot convert text to a code; eForms uses a codelist for Procedure Legal Basis (BT-01) |
| LOT_COMBINING_CONTRACT_RIGHT | R.2.0.9 | Text | The contracting authority reserves the right to award concessions combining the following lots or groups of lots - Text | Group of Lots described as text cannot be converted into a structural group of lots |
| NO_LOT_DIVISION | R.2.0.9 | Boolean | This contract is not divided into lots | No need to convert as no eForms output is required to state that there is no lot division |
| LOT_DIVISION | R.2.0.9 | Boolean | This contract is divided into lots | There is no equivalent BT to LOT_DIVISION. There are no children of LOT_DIVISION in F03 to convert |
| REFERENCE_TO_LAW | R.2.0.9 | Text | Reference to the relevant law, regulation or administrative provision (Execution of the service is reserved to a particular profession) | eForms does not have a BT to hold the reference to law for reserving the procurement for a particular profession |
| REFERENCE_NUMBER | R.2.0.9 | Text | Reference number (Object section) | eForms does not have a BT to hold a reference number |
| TECHNICAL_CRITERIA_DOC | R.2.0.9 | Text | Selection criteria as stated in the procurement documents | eForms does not allow for Selection Criteria to be contained in external documents |
| URL_NATIONAL_PROCEDURE | R.2.0.9 | URL | Information about national procedures is available at (URL) | eForms does not have a BT to hold a national procedure URL |

