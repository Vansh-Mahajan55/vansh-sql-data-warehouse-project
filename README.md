# vansh-sql-data-warehouse-project

Welcome to the Data Warehousing Project
This is a warehousing Project that i have done using SQL and other technologies.
The project would not have been possible without the resources provided by [Data with Baraa](https://www.youtube.com/@DataWithBaraa). 

## Architecture
The Project follows the Medallion Architecture in Data Engineering consisting of Bronze, Silver, Gold Layers.
- Bronze - The data is loaded from the source system as it is into this layer without making any changes.
- Silver - The data from the bronze layer is transformed to remove missing values, inconsistencies , perform standardization and normalizations.
- Gold - The final layer where data is combined from sources into a star schema to be used for business analysis.

  Architecture Diagram:
  [Architecture](/docs/Architecture.jpg 'Architecture')


