
## XSLT files
This folder contains the converteer code: XSLT and data files.

| File | Purpose |
| --- | --- |
| XSLT |
|  [ted-to-eforms.xslt](ted-to-eforms.xslt) | The main (starting) XSLT file |
|  [functx-1.0.1-doc.xsl](lib/functx-1.0.1-doc.xsl) | The FunctX XSLT Function Library, available [here](http://www.xsltfunctions.com/) |
|  [functions-and-data.xslt](functions-and-data.xslt) | Retrieving data from the mapping files, and common functions |
|  [common.xslt](common.xslt) | Templates used in more than one location |
|  [simple.xslt](simple.xslt) | Simple templates (one-to-one mappings) |
|  [lot.xslt](lot.xslt) | Templates for converting information at Lot level |
|  [notice-result.xslt](notice-result.xslt) | Templates for converting information at Notice Result level |
|  [addresses.xslt](addresses.xslt) | Templates for addresses |
|  [award-criteria.xslt](award-criteria.xslt) | Templates for converting Award Criteria (BG-38) |
|  [procedure.xslt](procedure.xslt) | Templates for converting information at Procedure level |
| [create-ted-map.xslt](create-ted-map.xslt) | XSLT to create languages-map.xml and countries-map.xml from the EU Vocabularies files |
| Mapping files |
| [notice-type-mapping.xml](notice-type-mapping.xml) | Mapping file to determine eForms Notice Subtype from TED XML content for R2.0.9 schema |
| [notice-type-mapping-r208.xml](notice-type-mapping.xml) | Mapping file to determine eForms Notice Subtype from TED XML content for R2.0.8 schema |
| [eforms-notice-subtypes.xml](eforms-notice-subtypes.xml) | Mapping file to determine BT-02 Notice Type and BT-03 Form Type from Notice Subtype |
| [languages.xml](languages.xml) | The "Language" codelist XML file, downloaded from https://op.europa.eu/en/web/eu-vocabularies/e-procurement/tables |
| [languages-map.xml](languages-map.xml) | Mapping of Language codes in TED to eForms, derived from the "Language" codelist XML file |
| [countries.xml](countries.xml) | The "Country" codelist XML file, downloaded from https://op.europa.eu/en/web/eu-vocabularies/e-procurement/tables |
| [countries-map.xml](countries-map.xml) | Mapping of Country codes in TED to eForms, derived from the "Country" codelist XML file |
| [other-mappings.xml](other-mappings.xml) | Other data mappings |
| [translations.xml](translations.xml) | Translations for TED form section IV.1.10 "Information about national procedures is available at:" for BT-300 Additional Information |

