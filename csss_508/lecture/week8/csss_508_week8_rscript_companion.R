## ---- echo=FALSE, warning=FALSE, message=FALSE----
library(tidyverse)
load("restaurants.Rdata")


## ----download_restaurant_data, eval=FALSE------
## library(tidyverse)
## restaurants <-
##   read_csv("https://raw.githubusercontent.com/breonh/breonh.github.io/main/csss_508/lecture/week8/restaurants.csv",
##                         col_types = "ccccccccnnccicccciccciD") #<<


## ----------------------------------------------
glimpse(restaurants)


## ----nchar_zip---------------------------------
restaurants %>% 
  mutate(ZIP_length = nchar(Zip_Code)) %>%
  count(ZIP_length)


## ----substr------------------------------------
restaurants <- restaurants %>%
    mutate(ZIP_5 = substr(Zip_Code, 1, 5))
restaurants %>% distinct(ZIP_5) %>% head()


## ----mailing_address---------------------------
restaurants <- restaurants %>%
    mutate(mailing_address = 
           paste(Address, ", ", City, ", WA ", ZIP_5, sep = ""))
restaurants %>% distinct(mailing_address) %>% head()


## ----paste0------------------------------------
paste(1:5, letters[1:5]) # sep is a space by default
paste(1:5, letters[1:5], sep ="")
paste0(1:5, letters[1:5])


## ----paste_practice, eval=TRUE, results="hold"----
paste(letters[1:5], collapse = "!")
paste(1:5, letters[1:5], sep = "+")
paste0(1:5, letters[1:5], collapse = "???")
paste(1:5, "Z", sep = "*")
paste(1:5, "Z", sep = "*", collapse = " ~ ")


## ----load_stringr------------------------------
library(stringr)


## ----str_sub_example---------------------------
str_sub("Washington", 1, -3)


## ----str_c_example-----------------------------
str_c(letters[1:5], 1:5)


## ----nchar_v_str_length------------------------
nchar("weasels")
str_length("weasels")


## ----make_seattle_uppercase--------------------
head(unique(restaurants$City))
restaurants <- restaurants %>%
    mutate(across(c(Name, Address, City), ~str_to_upper(.)))
head(unique(restaurants$City))


## ----show_whitespace---------------------------
head(unique(restaurants$Name), 4)


## ----clean_whitespace--------------------------
restaurants <- restaurants %>% 
  mutate(across(where(is.character), ~str_trim(.))) #<<
head(unique(restaurants$Name), 4)


## ----coffee_check------------------------------
coffee <- restaurants %>% 
  filter(str_detect(Name, "COFFEE|ESPRESSO|ROASTER"))
coffee %>% distinct(Name) %>% head()


## ----coffee_histogram, fig.height = 3, dev = "svg"----
coffee %>% select(Business_ID, Name, Inspection_Score, Date) %>%
       group_by(Business_ID) %>% filter(Date == max(Date)) %>% 
       distinct(.keep_all=TRUE) %>% ggplot(aes(Inspection_Score)) + 
    geom_histogram(bins=8) + xlab("Most recent inspection score") + ylab("") +
    ggtitle("Histogram of inspection scores for Seattle coffee shops")


## ----look_for_206------------------------------
area_code_206_pattern <- "^\\(?206"
phone_test_examples <- c("2061234567", "(206)1234567",
                         "(206) 123-4567", "555-206-1234")
str_detect(phone_test_examples, area_code_206_pattern)


## ----str_view, eval=FALSE----------------------
## str_view(phone_test_examples, area_code_206_pattern)


## ----look_for_206_rest-------------------------
restaurants %>% 
  mutate(has_206_number = 
           str_detect(Phone, area_code_206_pattern)) %>% 
  count(has_206_number) 


## ----test_direction----------------------------
direction_pattern <- " (N|NE|E|SE|S|SW|W|NW)( |$)"
direction_examples <- c("2812 THORNDYKE AVE W", "512 NW 65TH ST",
                        "407 CEDAR ST", "15 NICKERSON ST")
str_extract(direction_examples, direction_pattern)


## ----extract_directions------------------------
restaurants %>% 
  distinct(Address) %>% 
  mutate(city_region = 
          str_trim(str_extract(Address, direction_pattern))) %>% #<<
  count(city_region) %>% arrange(desc(n))


## ----test_address_numbers----------------------
number_pattern <- "^[0-9]*-?[A-Z]? (1/2 )?"
number_examples <- 
  c("2812 THORNDYKE AVE W", "1ST AVE", "10A 1ST AVE", 
    "10-A 1ST AVE", "5201-B UNIVERSITY WAY NE",
    "7040 1/2 15TH AVE NW")
str_replace(number_examples, number_pattern, replacement = "")


## ----------------------------------------------
str_remove(number_examples, number_pattern)


## ----replace_numbers---------------------------
restaurants <- restaurants %>% 
  mutate(street_only = str_remove(Address, number_pattern))
restaurants %>% distinct(street_only) %>% head(10)


## ----test_unit_numbers-------------------------
unit_pattern <- " (#|STE|SUITE|SHOP|UNIT).*$"
unit_examples <-
  c("1ST AVE", "RAINIER AVE S #A", "FAUNTLEROY WAY SW STE 108", 
    "4TH AVE #100C", "NW 54TH ST")
str_remove(unit_examples, unit_pattern)


## ----replace_units-----------------------------
restaurants <- restaurants %>% 
  mutate(street_only = 
           str_trim(str_remove(street_only, unit_pattern)))
restaurants %>% distinct(street_only) %>% head(11)


## ----failed_inspections------------------------
restaurants %>% 
  filter(Inspection_Score > 45) %>% 
  distinct(Business_ID, Date, Inspection_Score, street_only) %>% 
  count(street_only) %>%
  arrange(desc(n)) %>% 
  head(n=5)


## ----str_split_violation-----------------------
head(str_split_fixed(restaurants$Violation_Description, " - ", n = 2))


## ---- message=FALSE, warning=FALSE-------------
library(lubridate)
recent_scores <- restaurants %>%
  select(Name, Address, City, 
         Inspection_Score, Inspection_Date) %>% 
  filter(!is.na(Inspection_Score)) %>% 
  group_by(Name) %>% 
  arrange(desc(Inspection_Score)) %>% 
  slice(1) %>% 
  ungroup() %>%
  mutate(across(c(Name, Address, City), ~ str_to_title(.))) %>%
  mutate(Inspection_Date = mdy(Inspection_Date)) %>%
  sample_n(3)


## ---- message=FALSE, warning=FALSE-------------
library(scales) # for ordinal day text
recent_scores %>%
  mutate(text_desc = 
           paste(Name, 
                 "is located at", Address, "in", City,
                 "and received a score of", Inspection_Score, "on",
                 month(Inspection_Date, label=TRUE, abbr=FALSE),
                 paste0(ordinal(day(Inspection_Date)),","), 
                 paste0(year(Inspection_Date), "."))) %>% 
  select(text_desc)


## ----------------------------------------------
(score_text <- recent_scores %>%
  mutate(text_desc = 
           str_glue("{Name} is located at {Address} in {City} ",
                    "and received a score of {Inspection_Score} ",
                    "on {month(when, label=TRUE, abbr=FALSE)} ",
                    "{ordinal(day(when))}, {year(when)}.",
                    when = Inspection_Date)) %>% 
  select(text_desc))


## ----------------------------------------------
score_text %>% 
  pull(text_desc) %>% 
  str_wrap(width = 70) %>% #<<
  paste0("\n\n") %>% # add two linebreaks as a paragraph break #<<
  cat() # cat combines text and prints it

