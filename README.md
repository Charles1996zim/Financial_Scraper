# Financial Statement Scraper

This repository contains an R script (Main_Script.R) and a trigger script (Trigger.R) that scrape annual financial statement data (income statement, balance sheet, and cash flow) from barchart.com for any given stock ticker.

The scraped data is saved as an Excel file with three sheets (IS, BS, Cashflow) under the Data/ folder.

## Files

- Main_Script.R  
  Contains the main finscrape() function, which:
  - Loops over income statement, balance sheet, and cash flow pages (up to two pages each)
  - Scrapes and cleans the financial data
  - Joins multi-page data by the Metric column
  - Exports the final data into an Excel file with three sheets (using writexl)

- Trigger.R  
  Defines the ticker (stock symbol) and runs the finscrape() function.

## Requirements

You need the following R packages:

- rvest
- writexl
- dplyr
- tidyverse
- janitor
- hablar

You can install them with:

install.packages(c("rvest", "writexl", "dplyr", "tidyverse", "janitor", "hablar"))

## How to Use

1. Set the ticker in Trigger.R

Example:
ticker <- "BATS.LN"

2. Run Trigger.R

This will call:
finscrape(ticker)

3. Check the Data/ folder

An Excel file named <ticker>.xlsx will be saved, containing:
- IS → Income Statement
- BS → Balance Sheet
- Cashflow → Cash Flow Statement

## Notes

- The script includes a Sys.sleep(3) pause between page requests to avoid overloading the website.
- The loop stops automatically when no more table data is found.
- Cash flow data is filtered to exclude rows below Free Cash Flow.
