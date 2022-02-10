# TED XML to eForms XML Converter - Methodology

*Paul Donohoe, December 2021*

<br/>

This page attemps to describe the technical approach to the conversion, and the process of analysis for determining the correct mapping and conversion between TED XML and eForms XML elements.

## Technical Approach

### Business Terms
The expression "Business Term" is exclusive to eForms. It has not been used previously in TED. It refers to an eForms business concept. Sometimes this will be expressed in only one structure/location in eForms XML. Often, it is relevant in multiple contexts ("top-level" Procedure, Lot, Result), and so could be expressed in more than one structure/location in eForms XML. The [eForms documentation](https://docs.ted.europa.eu) groups these contexts together (see section "4.4. Procedure, Group of Lots, Lot & Part related information"), so that each Business Term is described only once.

Since this document is expressly about XSLT conversion, it will focus mainly on XML elements, and less about Business Terms. Hence, I will use the term "XML structure" to refer to a single XML element or XML structure; this may or may not be an expression of a single Business Term.

### Considerations

There is not always a 1-to-1 mapping between a single TED XML structure and a single eForms structure.

* Some TED elements have no equivalent in eForms
* Some TED XML structures map to multiple XML structures and locations in eForms
* Some eForms Business Terms are mandatory in some contexts; their expression as XML structures are thus also mandatory, even if no equivalent TED XML structure is present in the source XML notice.


### XSLT Processing Model

In XSLT conversion, there are two main models. These can be mixed within one conversion.

| Aspect | Push Model | Pull Model |
| --- | --- | --- |
| Language style | Declarative | Procedural |
| Conversion driven by | Source XML | XSLT Stylesheet |
| Structure provided by | Source XML | XSLT Stylesheet |
| Order provided by | Source XML | XSLT Stylesheet |
| 1-to-1 conversion of optional elements | Automatic | Test required |
| 1-to-many element conversion | Contextual tests required | Driven by location |
| Looping | Automatic | For-each required |
| Output required when source elements missing | Not possible | Possible |
| Same output in multiple locations | Automatic | Must be repeated |
| Where multiple data points required | Very complex expressions; must be repeated in each required context | Calculated once and stored in variables |


<br/>

From the above comparison, it can be seen that the Push Model is used when there is great similarity between the structure and order of elements between the input XML and the output XML. The Pull Model is used when the structures or order differ significantly.

In this conversion XSLT, the Pull Model dominates. This is because:
* Higher-level structures are significantly different between eForms and TED
* Results of complex data expressions can be used in multiple contexts
* Some eForms elements are mandatory, while TED equivalents may not be
* Some TED XML structures require expression in multiple locations in eForms XML

However, where there is a consistent and simple mapping between TED XML elements and eForms XML elements, the Push Model is used. This is because:
* Push Model templates can be easier to understand
* It supports abstraction into data maps for automatic XSLT template generation
* Only one template is required if conversion is the same in multiple locations

<br/>

## Source Data

### Multiple dimensions

There are multiple dimensions to this conversion:

* Two main distinct sets of TED XML schemas:
   * R.2.0.9 - "Standard" forms
   * R.2.0.8 - "Defence" forms
* 22 TED Forms map to 45 eForms Forms
* eForms schema is well written, consistent and well documented (but incomplete)
* TED schema is poorly written, inconsistent and poorly documented
* Organisation of information differs between the schemas
* TED XML schemas evolved over time -> differences in published TED notices
* eForms schema has more information points than TED schemas
* Element occurrence rules are defined differently between eForms and TED
* Millions of published TED XML notices can be used as examples
* Less than 20 eForms example XML notices, these are not complete and not fully definitive

### Information sources

#### TED 

* TED XML Schemas
* Millions of published XML notices <sup>[1](footnote1)</sup>
* Validation Rules spreadsheets
* Deloitte mapping spreadsheets
* TED procurement PDF forms

#### eForms

* eForms XML Schemas
* UBL documentation
* eForms documentation
* eForms Regulation Annex spreadsheet 


| Aspect | TED Sources | eForms sources |
| --- | --- | --- |
| Document structure | **TED XML schemas** <br/> Published notices | **eForms XML Schemas** <br/> **eForms documentation**  |
| Element occurrence <br/> variations | **TED XML schemas** <br/> Published notices <br/> Validation Rules spreadsheets <br/> Deloitte mapping spreadsheets | **eForms documentation** <br/> *eForms Regulation Annex spreadsheet* |
| Element purpose, <br/> definitions, documentation | Element names *partly* <br/> Validation Rules spreadsheets *poor and incomplete* <br/> Deloitte mapping spreadsheets *unreliable* <br/> TED PDF forms | **eForms XML Schemas** <br/> **eForms documentation** <br/> *eForms Regulation Annex spreadsheet* <br/> eForms codelists |

## Occurrence and Priority

There exists an extremely large number of variations of types of existing TED XML notice, arising from the combination of different TED schemas, the multiple Form types, and the historic schema evolution.  These variations in types are far from evenly distributed. As it is considered not feasible to complete the conversion XSLT for all these variations, priority must be given to those with the greatest number of published notices.

### Calculation of notice occurrence counts

<a name="footnote1"></a>In preparation for this work, a year's worth (600.000 XML files) of TED XML notices were downloaded and prepared for analysis. This set spans from March 2020 to February 2021. It covers the two TED XML schemas, but only the latest versions of these. Previous versions are thus not currently considered.

These notices were analysed to determine the relative occurrence of:
* TED XML Schema
* Main Form type
* Form subtypes
* Languages
* Legal basis

More details and the results of these analysis are available in the ["TED to eForms Converter" Teams channel](https://teams.microsoft.com/l/channel/19%3ad422031f501349fbad5b2e49d90980ac%40thread.tacv2/TED%2520to%2520eForms%2520Converter?groupId=debf29ba-857a-4fda-8ee9-6303c7d7848b&tenantId=b24c8b06-522c-46fe-9080-70926f8dddb1), in the "TED XML Analysis.docx" document and the "ted-eforms-notice-type-mapping.xlsx" spreadsheet. 

Forms F02 (maps to eForms subtype 16) and F03 (maps to eForms subtype 29) of the R.2.0.9 schema are used by two-thirds of all the analysed notice sets. So these two forms will be focussed on during the first phase of conversion development. As Form F02 (Contract Notice) is easier to convert, it has been handled first.

## Analysis Process

This section attempts to describe the analysis process used to determine the mapping and conversion templates required for each element. As the process relies heavily on analysis of the downloaded XML, which is currently only available on my laptop, this process is restricted to me.


### The main structures

As explained above, for the overall structure of the XSLT a Pull Model based on the eForms XML schema has been used. The order of analysis follows the order of structures and elements of the eForms schema. This ensures that all required output elements are included, irrespective of any equivalent elements in the TED XML schema.

Thus the main structures (of the first form to be analysed, the Contract Notice form) are:

* Notice Information
* Procurement Information
* Organization Information
* Procedure Tendering Terms
* Procedure Tendering Process
* Procedure Procurement Project
* Lots
    * Lot Tendering Terms
    * Lot Tendering Process
    * Lot Procurement Project

Within each structure, the steps taken are:

### 1. Identify the next structure in eForms to work on
In the eForms documentation for the section, read the table at the beginning of the section, which lists all the Business Terms used. Read the occurrence symbol for that BT to ensure that it is relevant in the section context. Document this in a comment in the XSLT file.
Check that the order matches with the element order defined in the eForms schema.

### 2. Check the Annex spreadsheet for Form relevance
Review the Annex spreadsheet for the related BTs **and BGs**, determining which Forms they are allowed / forbidden / mandatory for. Document this in a comment in the XSLT file. If they are allowed for form 16, proceed with the next steps. 

### 3. Determine the cardinality(-ies) of the structure
Examine the documentation for all the related BTs for the structure, reviewing the cardinalities of all the elements involved. If the structure is repeated, either for the current BT or for other BTs, check which element which should be repeated by reviewing the documentation and the schema.

### 4. Determine the use / purpose of the structure
Review the documentation and Annex spreadsheet to understand what information the structure is used for.

If the structure uses a codelist, extract the codes and labels for consideration.

### 5. Identify the structure used in TED XML for the same purpose
Review the information sources listed above for the TED XML to find the appropriate structures used for the same information. If none are found, document this in a comment in the XSLT, and move on to the next eForms structure.
If an equivalent TED XML structure is found, check:
* If the structure is used in only one, or more, locations in the TED schema
* If the structure is an enumerated set of alternatives, consider an eForms codelist
* Which TED forms allow the structure, and for each the cardinality and requirement (Optional or Mandatory)

### 6. Optional: Analyse text content of the TED structure
If the identified TED XML structure contains text (such as a \<P\> element), write a script to extract and collate all the text variations from the downloaded TED XML data set. 

If the text is an enumerated set (either an attribute with an enumerated set of values, or a set of empty elements (the element names are considerered values)), list them. Determine the meaning behind each, and map to the equivalent eForms codelist code.

If the text is expressed in the language of the form, consider only the English versions. Read enough to confirm understanding of the meaning / use of the structure.

### Choose the appropriate conversion approach (processing model, template structure)

*This is more of a guide than definitive*

* If the mapping is simple, and there is no mapping required for "missing" TED elements (that is, no eForms subtypes have this BT as mandatory), choose the Push model, and write \<xsl:apply-templates select\> and \<xsl:template match\> templates.

* If the eForms element is mandatory according to either the Annex or the documentation (also consider the parent BG), and the TED XML element is not always present, choose the Pull model, and write \<xsl:call-template name\> and \<xsl:template name\> templates.







