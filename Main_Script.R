library(rvest)
library(writexl)
library(dplyr)
library(tidyverse)


finscrape <- function(ticker){
  
  result <- tibble()
  
  for(i in 1:2){
    
    cat("Scraping page income statement", i, "and waiting 3 seconds...\n")
    Sys.sleep(3)
    
    comp <- tryCatch({
      
      read_html(paste0("https://www.barchart.com/stocks/quotes/",ticker,"/income-statement/annual?reportPage=", i)) %>% 
        html_nodes("table") %>% html_table() %>% .[[1]] %>%
        janitor::row_to_names(1) %>%
        rename("Metric" = 1) %>% mutate(across(everything(), ~ gsub("[$,]", "", .)))
      
      
    }, error = function(e) {
      NULL
    })
    
    if (is.null(comp)) break
    
    if (i == 1) {
      result <- comp
    } else {
      result <- left_join(result, comp, by = "Metric")
    }
    
  }
  
  income_s <- result
  
  result <- tibble()
  
  for(i in 1:2){
    
    cat("Scraping page balance sheet", i, "and waiting 3 seconds...\n")
    Sys.sleep(3)
    
    comp <- tryCatch({
      
      read_html(paste0("https://www.barchart.com/stocks/quotes/",ticker,"/balance-sheet/annual?reportPage=", i)) %>% 
        html_nodes("table") %>% html_table() %>% .[[1]] %>%
        janitor::row_to_names(1) %>%
        rename("Metric" = 1) %>% mutate(across(everything(), ~ gsub("[$,]", "", .))) %>%
        hablar::retype() %>% filter(Metric != "") %>% filter(Metric != "TOTAL")
      
      
    }, error = function(e) {
      NULL
    })
    
    if (is.null(comp)) break
    
    if (i == 1) {
      result <- comp
    } else {
      result <- left_join(result, comp, by = "Metric")
    }
    
  }
  
  balance_s <- result
  
  
  result <- tibble()
  
  for(i in 1:2){
    
    cat("Scraping cash flow page", i, "and waiting 3 seconds...\n")
    Sys.sleep(3)
    
    comp <- tryCatch({
      
      read_html(paste0("https://www.barchart.com/stocks/quotes/",ticker,"/cash-flow/annual?reportPage=", i)) %>% 
        html_nodes("table") %>% html_table() %>% .[[1]] %>%
        janitor::row_to_names(1) %>%
        rename("Metric" = 1) %>% mutate(across(everything(), ~ gsub("[$,]", "", .))) %>%
        hablar::retype() %>% filter(Metric != "") %>% filter(Metric != "TOTAL") %>%
        filter(row_number() < which(Metric == "Free Cash Flow")[1])
      
      
      
    }, error = function(e) {
      NULL
    })
    
    if (is.null(comp)) break
    
    if (i == 1) {
      result <- comp
    } else {
      result <- left_join(result, comp, by = "Metric")
    }
    
  }
  
  cash_f <- result
  
  
  write_xlsx(
    list(
      IS = income_s,
      BS = balance_s,
      Cashflow = cash_f
    ),
    paste0("Data/", ticker, ".xlsx")
  )
  
}


finscrape(ticker)
