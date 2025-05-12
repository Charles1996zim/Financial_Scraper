library(rvest)
library(dplyr)
library(openxlsx)

ticker <- "AIR"

strsplit(ticker, ":")

ls <- c("", "balance-sheet", "cash-flow-statement", "ratios")
wb <- createWorkbook()

for(list in ls){
  
  data <-
  read_html(paste0("https://stockanalysis.com/quote/lon/", ticker, "/financials/", list)) %>% html_node("table") %>% html_table() %>%
    select(-ncol(.)) %>% slice(-1) %>%
    mutate(across(2:ncol(.), ~ gsub("[$,%]", "", .))) %>% mutate(across(2:ncol(.), ~ as.numeric(.)))
  
  # Define sheet name (use 'financials' if list == "")
  sheet_name <- ifelse(list == "", "income-statement", list)
  
  # Add a worksheet and write data
  addWorksheet(wb, sheet_name)
  writeData(wb, sheet = sheet_name, data)
  
  print("Done: waiting....")

  Sys.sleep(3)
  
}

saveWorkbook(wb, paste0("Data/SA/", ticker, "_financials.xlsx"), overwrite = TRUE)
  

