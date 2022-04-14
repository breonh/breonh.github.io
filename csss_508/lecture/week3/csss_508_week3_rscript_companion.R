## ----set-options, echo=FALSE, cache=FALSE-------------------------------
options(width = 90)


## ---- message=FALSE, warning=FALSE--------------------------------------
library(dplyr)
library(gapminder)
gapminder %>% filter(country == "Canada") %>% head(4)


## ---- eval=FALSE--------------------------------------------------------
## take_these_data %>%
##     do_first_thing(with = this_value) %>%
##     do_next_thing(using = that_value) %>% ...


## ---- eval=FALSE--------------------------------------------------------
## gapminder %>% lm(pop ~ year, data = .)


## ---- eval=FALSE--------------------------------------------------------
## lm_pop_year <- gapminder %>%
##   filter(continent == "Americas") %>%
##   lm(pop ~ year, data = .)


## -----------------------------------------------------------------------
Canada <- gapminder %>%
    filter(country == "Canada")
head(Canada)


## -----------------------------------------------------------------------
former_yugoslavia <- c("Bosnia and Herzegovina", "Croatia", 
                       "Montenegro", "Serbia", "Slovenia")

yugoslavia <- gapminder %>% filter(country %in% former_yugoslavia)
slice(yugoslavia, 12:14)


## -----------------------------------------------------------------------
gapminder %>% distinct(continent, year)


## -----------------------------------------------------------------------
gapminder %>% distinct(continent, year, .keep_all=TRUE)


## -----------------------------------------------------------------------
set.seed(789) # makes random numbers repeatable #<<
yugoslavia %>% sample_n(size = 6, replace = FALSE)


## -----------------------------------------------------------------------
yugoslavia %>% arrange(year, desc(pop))


## -----------------------------------------------------------------------
yugoslavia %>% select(country, year, pop) %>% head(4)


## -----------------------------------------------------------------------
yugoslavia %>% select(-continent, -pop, -lifeExp) %>% head(4)


## ---- eval=FALSE--------------------------------------------------------
## DYS %>% select(starts_with("married"))
## DYS %>% select(ends_with("18"))


## -----------------------------------------------------------------------
gapminder %>% select(where(is.numeric)) %>% head(3)


## -----------------------------------------------------------------------
gapminder %>% select(where(is.factor)) %>% head(3)


## -----------------------------------------------------------------------
yugoslavia %>%
    select(Life_Expectancy = lifeExp) %>%
    head(4)


## -----------------------------------------------------------------------
yugoslavia %>%
    select(country, year, lifeExp) %>%
    rename(Life_Expectancy = lifeExp) %>%
    head(4)


## ---- warning=FALSE-----------------------------------------------------
library(pander)
yugoslavia %>% filter(country == "Serbia") %>%
    select(year, lifeExp) %>%
    rename(Year = year, `Life Expectancy` = lifeExp) %>%
    head(5) %>%
    pander(style = "rmarkdown", caption = "Serbian life expectancy")


## -----------------------------------------------------------------------
yugoslavia %>% filter(country == "Serbia") %>%
    select(year, pop, lifeExp) %>%
    mutate(pop_million = pop / 1000000,
           life_exp_past_40 = lifeExp - 40) %>%
    head(5)


## ---- eval=FALSE--------------------------------------------------------
## ifelse(test = x==y, yes = first_value , no = second_value)


## -----------------------------------------------------------------------
example <- c(1, 0, NA, -2)
ifelse(example > 0, "Positive", "Not Positive")


## -----------------------------------------------------------------------
yugoslavia %>% mutate(short_country = 
                 ifelse(country == "Bosnia and Herzegovina", 
                        "B and H", as.character(country))) %>% #<<
    select(country, short_country, year, pop) %>%
    arrange(year, short_country) %>% head(3)


## -----------------------------------------------------------------------
yugoslavia %>% 
  mutate(country = recode(country, 
                          `Bosnia and Herzegovina`="B and H", #<<
                           Montenegro="M")) %>% 
  distinct(country)


## -----------------------------------------------------------------------
gapminder %>% 
  mutate(gdpPercap_ordinal = 
    case_when(
      gdpPercap <  700 ~ "low",
      gdpPercap >= 700 & gdpPercap < 800 ~ "moderate",
      TRUE ~ "high" )) %>% # Value when all other statements are FALSE
  slice(6:9) # get rows 6 through 9


## -----------------------------------------------------------------------
gapminder %>% pull(lifeExp) %>% head(4)


## -----------------------------------------------------------------------
gapminder %>% select(lifeExp) %>% head(4)


## -----------------------------------------------------------------------
yugoslavia %>%
    filter(year == 1982) %>%
    summarize(n_obs          = n(),
              total_pop      = sum(pop),
              mean_life_exp  = mean(lifeExp),
              range_life_exp = max(lifeExp) - min(lifeExp))


## -----------------------------------------------------------------------
yugoslavia %>%
  filter(year == 1982) %>%
  summarize(across(c(lifeExp, pop), list(avg = ~mean(.), sd = ~sd(.))))


## ---- eval = FALSE------------------------------------------------------
## yugoslavia %>%
##   filter(year == 1982) %>%
##   summarize(
##     across(
##       c(lifeExp, pop),
##       list(
##         avg = ~mean(.),
##         sd = ~sd(.)
##       )
##     )
##   )


## ---- eval=FALSE--------------------------------------------------------
## dataframe %>%
##   summarize(across(everything(), list(mean = ~mean(.), sd = ~sd(.))))


## ---- eval=FALSE--------------------------------------------------------
## dataframe %>%
##   summarize(across(where(is.numeric), list(mean = ~mean(.), sd = ~sd(.))))


## -----------------------------------------------------------------------
yugoslavia %>%
  group_by(year) %>% #<<
    summarize(num_countries     = n_distinct(country),
              total_pop         = sum(pop),
              total_gdp_per_cap = sum(pop*gdpPercap)/total_pop) %>%
    head(4)


## -----------------------------------------------------------------------
yugoslavia %>% 
  select(country, year, pop) %>%
  filter(year >= 2002) %>% 
  group_by(country) %>%
  mutate(lag_pop = lag(pop, order_by = year),
         pop_chg = pop - lag_pop) %>%
  head(4)


## ---- message = FALSE, warning = FALSE----------------------------------
# install.packages("nycflights13") # Uncomment to run
library(nycflights13)


## ---- eval=FALSE--------------------------------------------------------
## data(flights)
## data(airlines)
## data(airports)
## # and so on...


## -----------------------------------------------------------------------
flights %>% filter(dest == "SEA") %>% select(tailnum) %>%
    left_join(planes %>% select(tailnum, manufacturer), #<<
              by = "tailnum") %>%
    count(manufacturer) %>% # Count observations by manufacturer
    arrange(desc(n)) # Arrange data descending by count


## -----------------------------------------------------------------------
flights %>% filter(dest == "SEA") %>% 
    select(carrier) %>%
    left_join(airlines, by = "carrier") %>%
    group_by(name) %>% 
    tally() %>% #<<
    arrange(desc(n))


## ---- warning=FALSE, message=FALSE, eval=FALSE--------------------------
## library(ggplot2)
## flights %>%
##     select(origin, year, month, day, hour, dep_delay) %>%
##     inner_join(weather,
##            by = c("origin", "year", "month", "day", "hour")) %>%
##     select(dep_delay, wind_gust) %>%
##     # removing rows with missing values
##     filter(!is.na(dep_delay) & !is.na(wind_gust)) %>%
##     ggplot(aes(x = wind_gust, y = dep_delay)) +
##       geom_point() +
##       geom_smooth()


## ---- warning=FALSE, message=FALSE, echo=FALSE, cache=FALSE, fig.height=4, dev='png', dpi=600----
flights %>% select(origin, year, month, day, hour, dep_delay) %>%
    inner_join(weather, by = c("origin", "year", "month", "day", "hour")) %>%
    select(dep_delay, wind_gust) %>%
    # removing rows with missing values
    filter(!is.na(dep_delay) & !is.na(wind_gust)) %>%
    # Funky 1200 mph observations were dropped so I make new ones!
    mutate(wind_gust = if_else(row_number() %in% c(1,2,3), 1200, wind_gust)) %>%
    ggplot(aes(x = wind_gust, y = dep_delay)) +
      geom_point() + geom_smooth()


## ---- warning=FALSE, message=FALSE, eval=FALSE--------------------------
## flights %>%
##     select(origin, year, month, day, hour, dep_delay) %>%
##     inner_join(weather, by = c("origin", "year", "month", "day", "hour")) %>%
##     select(dep_delay, wind_gust) %>%
##     filter(!is.na(dep_delay) & !is.na(wind_gust) & wind_gust < 250) %>% #<<
##     ggplot(aes(x = wind_gust, y = dep_delay)) +
##       geom_smooth() +
##       theme_bw(base_size = 16) +
##       xlab("Wind gusts in departure hour (mph)") +
##       ylab("Average departure delay (minutes)")


## ---- warning=FALSE, message=FALSE, echo=FALSE, cache=FALSE, fig.height=4, dev='svg'----
flights %>% 
    select(origin, year, month, day, hour, dep_delay) %>%
    inner_join(weather, by = c("origin", "year", "month", "day", "hour")) %>%
    select(dep_delay, wind_gust) %>%
    filter(!is.na(dep_delay) & !is.na(wind_gust) & wind_gust < 250) %>% 
    ggplot(aes(x = wind_gust, y = dep_delay)) +
      geom_smooth() + 
      theme_bw(base_size = 16) +
      xlab("Wind gusts in departure hour (mph)") +
      ylab("Average departure delay (minutes)")

