
## XSLT files
This folder contains the converteer code: XSLT and data files.

| File | Purpose |
| --- | --- |
| XSLT |
|  [ted-to-eforms.xslt](ted-to-eforms.xslt) | The main (starting) XSLT file |
|  [functx-1.0.1-doc.xsl](lib/functx-1.0.1-doc.xsl) | The FunctX XSLT Function Library, available [here](http://www.xsltfunctions.com/) |
|  [functions-and-data.xslt](functions-and-data.xslt) | Retrieving data from the mapping files, and common functions |
|  [simple.xslt](simple.xslt) | Simple templates (one-to-one mappings) |
|  [addresses.xslt](addresses.xslt) | Templates for addresses |
|  [award-criteria.xslt](award-criteria.xslt) | Templates for converting Award Criteria (BG-38) |
|  [procedure.xslt](procedure.xslt) | Templates for converting information at Procedure level |
|  [lot.xslt](lot.xslt) | Templates for converting information at Lot level |
|  [common.xslt](common.xslt) | Templates used in more than one location |
| Mapping files |
| [notice-type-mapping.xml](notice-type-mapping.xml) | Mapping file to determine eForms Notice Subtype from TED XML content |
| [languages.xml](languages.xml) | The "Language" codelist XML file, downloaded from https://op.europa.eu/en/web/eu-vocabularies/e-procurement/tables |
| [countries.xml](countries.xml) | The "Country" codelist XML file, downloaded from https://op.europa.eu/en/web/eu-vocabularies/e-procurement/tables |
| [other-mappings.xml](other-mappings.xml) | Other data mappings |

