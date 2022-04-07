
# Disclaimer
This project is currently under development. We may update the current version and replace it with a new version at any time. In this case, we recommend you retrieve the latest version in order to ensure technical compliance. The Publications Office cannot guarantee the accuracy, adequacy, validity, reliability, availability or completeness of this information and accepts no responsibility for any use you may make of this project’s component parts.

The code and data in this repository is created by the Publications Office of the European Union and is licensed under the terms of the [EUPL-1.2 license](LICENSE).

# Summary

This project is managed by the Publications Office of the European Union to assist organisations publishing procurement notices in their migration to eForms. 

An organisation publishing procurement notices may wish to switch the production of notices in their system from the TED schemas to the eForms schema at a point in time. In this case, they will have published some initial notices (PIN, Contract Notice, etc.) for an ongoing Procedure using the TED schemas. They will want to publish following notices, continuing the Procedure, using the eForms schema. 

The TED XML Data Converter is designed to help with this process, by converting a notice published in the TED schemas, to a draft form of the same notice in eForms. The publisher can then correct and complete this notice, and use it as a basis for creating a following notice in eForms.

The repository contains the following folders:

| Folder | Purpose |
| --- | --- |
| `xslt` | The xslt and data for the conversion |
| `development-notices` | Sample source TED XML files used for testing during development |
| `eforms-structure-files` | Sample files for the structure of eForms XML |
| `test-notices` | Sample notices in in TED schema XML to be used for testing the converter |


# How to use

Basic usage instructions for developers to run the code in their own system is available [here](usage-information.md).


## Versioning scheme

The versioning scheme which will be adopted for the TED XML Data Converter will be similar to that for the [eForms SDK](https://docs.ted.europa.eu/eforms/latest/versioning.html).


## Feedback

Feedback on this converter is welcome. Please address questions, comments and bug reports using [Github Discussions](https://github.com/OP-TED/ted-xml-data-converter/discussions).

## What's next?
Work on conversion of the remaining Contract Notice TED XML forms (F05, F12, F21, F22, F23 and F24) is ongoing.

Work will begin on Contract Award notice forms in the near future.


