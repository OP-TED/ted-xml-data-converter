# TED schema elements which cannot be converted to eForms

This table lists the elements defined in the TED R.2.0.8 schema, but whose data cannot be converted to any data structures in eForms.

This table is under development.

| TED Element | TED schema | Content format Usage | Description | Reason for inability to convert |
| --- | --- | --- | --- | --- |
|SERVICE_CATEGORY_DEFENCE | R.2.0.8 | Number | Service categories referred to in Section II: Object of the contract | eForms does not have an equivalent for this element |
|PROCEDURE_DATE_STARTING | R.2.0.8 | Date | Scheduled date for start of award procedures referred to in Section II: Object of the contract | eForms does not have an equivalent for this element |
|OBJECT_WORKS_SUPPLIES_SERVICES_PRIOR_INFORMATION/QUANTITY_SCOPE_WORKS_DEFENCE/COSTS_RANGE_AND_CURRENCY/RANGE_VALUE_COST/LOW_VALUE OBJECT_WORKS_SUPPLIES_SERVICES_PRIOR_INFORMATION/QUANTITY_SCOPE_WORKS_DEFENCE/COSTS_RANGE_AND_CURRENCY/RANGE_VALUE_COST/HIGH_VALUE | R.2.0.8 | Value | Total value of the procurement (excluding VAT) - Lowest offer / Highest offer taken into consideration | eForms does not have a BT to hold range values for offers across all lots |
|F16_DIV_INTO_LOT_YES/LOT_PRIOR_INFORMATION/NATURE_QUANTITY_SCOPE/COSTS_RANGE_AND_CURRENCY/RANGE_VALUE_COST/LOW_VALUE F16_DIV_INTO_LOT_YES/LOT_PRIOR_INFORMATION/NATURE_QUANTITY_SCOPE/COSTS_RANGE_AND_CURRENCY/RANGE_VALUE_COST/HIGH_VALUE | R.2.0.8 | Value | Total value of the procurement (excluding VAT) - Lowest offer / Highest offer taken into consideration | eForms does not have a BT to hold range values for offers for a given lot |
