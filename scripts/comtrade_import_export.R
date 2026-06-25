#set up the working directory
#adjsut this to your own directory
setwd("D:/WorldBank/Comtrade")
getwd()
dir()

#install the comtrade library
install.packages("comtradr")

#call the library
library(comtradr)
library(dplyr)

#set up the API key
set_primary_comtrade_key("***********************")  #add your API key here 

#downloading the data
#exports (origin)
bulgaria_exports<-ct_get_data(
  reporter = "BGR", #bulgaria - cahnge this to your country code
  partner = "everything", #all partner countries
  flow_direction = "export",  #exports only
  commodity_classification = "HS", #hs classification
  commodity_code = sprintf("%02d", 1:97),  #2 digit commodities only
  start_date = 2023,  
  end_date = 2024,
  frequency = "A" #annual
  #mode_of_transport = "road"
)

# Clean the excel
bulgaria_exports_clean <- bulgaria_exports %>%
  select(
    period,
    reporter_desc,
    flow_desc,
    partner_desc,
    partner_iso,
    cmd_code,
    cmd_desc,
    net_wgt,
    fobvalue
  ) %>%
  filter(partner_desc != "World") %>%
  rename(
    year         = period,
    reporter     = reporter_desc,
    flow         = flow_desc,
    partner      = partner_desc,
    partner_code = partner_iso,
    hs_code      = cmd_code,
    hs_desc      = cmd_desc,
    weight_kg    = net_wgt,
    value_usd    = fobvalue
  )

# Check it looks right
glimpse(bulgaria_exports_clean)
#head(bulgaria_exports_clean, 10)


#saving the downloaded data
write.csv(bulgaria_exports, 
          "bulgaria_exports_2023_2024.csv", 
          row.names = FALSE)
write.csv(bulgaria_exports_clean, 
          "bulgaria_exports_final_2023_2024.csv", 
          row.names = FALSE)

#imports
bulgaria_imports <- ct_get_data(
  reporter = "BGR",
  partner = "everything",
  flow_direction = "import",
  commodity_classification = "HS",
  commodity_code = sprintf("%02d", 1:97),
  start_date = 2023,
  end_date = 2024,
  frequency = "A"
)

#clean the csv
# Clean imports
bulgaria_imports_clean <- bulgaria_imports %>%
  select(period, reporter_desc, flow_desc, partner_desc,
         partner_iso, cmd_code, cmd_desc, net_wgt, primary_value) %>%
  filter(partner_desc != "World") %>%
  rename(
    year         = period,
    reporter     = reporter_desc,
    flow         = flow_desc,
    partner      = partner_desc,
    partner_code = partner_iso,
    hs_code      = cmd_code,
    hs_desc      = cmd_desc,
    weight_kg    = net_wgt,
    value_usd    = primary_value
  )


#save the downloaded data
write.csv(bulgaria_imports,
          "bulgaria_imports_2023_2024.csv",
          row.names=FALSE)
write.csv(bulgaria_imports_clean, 
          "bulgaria_imports_final_2023_2024.csv",
          row.names = FALSE)

#combin e export and imports into one
# Combine into one OD table
bulgaria_OD <- bind_rows(bulgaria_exports_clean,
                         bulgaria_imports_clean)

write.csv(bulgaria_OD,
          "Bulgaria_OD_2023_2024.csv")
