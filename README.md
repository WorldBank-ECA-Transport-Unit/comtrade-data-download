# Comtrade Data Download

> World Bank ECA Transport Unit 

> Automated download and cleaning of import and export trade data from the UN Comtrade database using R

## Overview

UN Comtrade is the most comprehensive multilateral trade database available, covering goods trade statistics reported by national customs authorities. Accessing it programmatically removes the need for manual downloads through the web portal and makes the workflow reproducible across countries and time periods.

This script uses the `comtradr` R package to query the Comtrade API and download bilateral trade flows by HS commodity code for a chosen reporter country. It retrieves both exports and imports, cleans and standardises the output, and combines them into a single origin-destination table ready for analysis.

## Repository Structure

```
comtrade-data-download/
├── scripts/
│   └── comtrade_import_export.
```

## Prerequisites

R 4.0 or later. The following packages are required:

- `comtradr` — Comtrade API wrapper for R
- `dplyr` — data manipulation

Install them by running:

```r
install.packages("comtradr")
install.packages("dplyr")
```

## API Key

This script requires a UN Comtrade API key. To obtain one:

1. Register for a free account at https://comtradeplus.un.org
2. Log in and navigate to your profile
3. Generate an API key under the subscriptions section
4. Paste your key into the script where indicated

```r
set_primary_comtrade_key("your_api_key_here")
```

Keep your API key private. Do not commit it to GitHub.

## How to Use

**Set your working directory**

At the top of the script, set the path to the folder where you want outputs saved:

```r
setwd("C:/path/to/your/folder")
```

**Configure your query**

Edit the parameters in the `ct_get_data()` calls to match your country and time period:

```r
reporter = "BGR"   # ISO3 country code — change to your country
start_date = 2023  # start year
end_date = 2024    # end year
```

Common ISO3 country code examples:

| Country | ISO3 Code |
|---|---|
| Bulgaria | BGR |
| Romania | ROU |
| Turkey | TUR |
| Ukraine | UKR |
| Georgia | GEO |
| Moldova | MDA |
| Poland | POL |

A full list of ISO3 codes is available at https://unstats.un.org/unsd/tradekb/Knowledgebase/50377/Comtrade-Country-Code-and-Name

**Run the script**

Run the full script in R or RStudio. It will download exports and imports separately, clean each dataset, and combine them into a single OD table.

## Outputs

The script produces the following CSV files in your working directory:

| File | Description |
|---|---|
| `{country}_exports_raw.csv` | Raw export data as returned by the API |
| `{country}_exports_final.csv` | Cleaned and renamed export columns |
| `{country}_imports_raw.csv` | Raw import data as returned by the API |
| `{country}_imports_final.csv` | Cleaned and renamed import columns |
| `{country}_OD.csv` | Exports and imports combined into one table |

The cleaned files contain the following columns:

| Column | Description |
|---|---|
| `year` | Reference year |
| `reporter` | Reporting country name |
| `flow` | Export or import |
| `partner` | Partner country name |
| `partner_code` | Partner country ISO3 code |
| `hs_code` | HS commodity code (2 digit) |
| `hs_desc` | HS commodity description |
| `weight_kg` | Net weight in kilograms |
| `value_usd` | Trade value in USD (FOB for exports, CIF for imports) |

## Notes

The script queries all 2-digit HS commodity codes (01 to 97) and excludes aggregate World totals from the cleaned output, retaining only bilateral country pairs. API rate limits apply depending on your subscription tier. For large queries covering many years or countries, consider splitting requests and adding a pause between calls.

## Authors

World Bank ECA Transport Unit


## License

MIT License
