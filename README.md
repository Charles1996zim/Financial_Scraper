# Financial Statement Scrapers

This repository contains R scripts to scrape annual financial statement data for publicly listed companies from two sources:

1. Barchart.com — covers income statement, balance sheet, and cash flow
2. StockAnalysis.com — provides a more complete balance sheet and additional metrics like ratios

Each script saves the results in Excel format with separate sheets for each statement.

------------------------------------------------------------
Scripts
------------------------------------------------------------

##. Main_Script.R

Scrapes financial data from Barchart.com for a given ticker.

- Income Statement
- Balance Sheet
- Cash Flow

The data is cleaned, numeric strings are converted, and the result is saved as an Excel file with 3 sheets:
- IS — Income Statement
- BS — Balance Sheet
- Cashflow — Cash Flow

Trigger Script:
- Trigger.R defines the ticker variable and runs finscrape(ticker)

##. SA_Scraper.R

Scrapes financial data from StockAnalysis.com for a given ticker listed on the London Stock Exchange.

Statements scraped:
- Income Statement
- Balance Sheet
- Cash Flow Statement
- Ratios

The data is:
- Extracted from HTML tables
- Cleaned of $, %, and commas
- Converted to numeric format where applicable

Saved in:
Data/SA/<TICKER>_financials.xlsx  
with sheets:
- income-statement
- balance-sheet
- cash-flow-statement
- ratios

------------------------------------------------------------
Requirements
------------------------------------------------------------

You need the following R packages installed:

rvest  
dplyr  
tidyverse  
writexl  
janitor  
hablar  
openxlsx

Install them with:

install.packages(c("rvest", "dplyr", "tidyverse", "writexl", "janitor", "hablar", "openxlsx"))

------------------------------------------------------------
Usage
------------------------------------------------------------

Barchart Scraper:
1. Set the ticker in Trigger.R, e.g.
   ticker <- "BATS.LN"

2. Run Trigger.R

3. The output will be saved in:
   Data/BATS.LN.xlsx

StockAnalysis Scraper:
1. Set the ticker in StockAnalysis_Scraper.R, e.g.
   ticker <- "AIR"

2. Run the script

3. The output will be saved in:
   Data/SA/AIR_financials.xlsx

------------------------------------------------------------
Notes
------------------------------------------------------------

- Both scripts include a Sys.sleep(3) delay between requests to avoid IP bans
- Barchart scraping stops automatically if no table is found
- StockAnalysis scrapes a single page per section (no pagination)
- StockAnalysis uses more complete balance sheet data in some cases
- Barchart requires tickers like "BATS.LN", while StockAnalysis uses base ticker like "AIR"
