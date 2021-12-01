## ---- message=FALSE, warning=FALSE----------------------------------------------
library(tidyverse)

## ----read_spd_data, cache=FALSE, message=FALSE, warning=FALSE-------------------
spd_raw <- read_csv("https://breonh.github.io/csss_508/lecture/week5/data/Seattle_Police_Department_911_Incident_Response.csv")


## -------------------------------------------------------------------------------
glimpse(spd_raw)


## ---- eval=FALSE----------------------------------------------------------------
## ggplot(spd_raw,
##        aes(Longitude, Latitude)) +
##   geom_point() +
##   coord_fixed() + # evenly spaces x and y
##   ggtitle("Seattle Police Incidents",
##           subtitle="March 25, 2016") +
##   theme_classic()




## ---- eval=FALSE----------------------------------------------------------------
## install.packages("ggmap")


## ---- eval=FALSE----------------------------------------------------------------
## if(!requireNamespace("remotes")) install.packages("remotes")
## remotes::install_github("dkahle/ggmap", ref = "tidyup")






## ----qmplot, cache=TRUE, message = FALSE, echo=FALSE, fig.height = 5, fig.width=2.5, dev="svg"----
qmplot(data = spd_raw, x = Longitude, y = Latitude, color = I("#342c5c"), alpha = I(0.5))




## ----quick_plot_density_2, echo=FALSE, message = FALSE, cache=TRUE, fig.height = 5, fig.width=2.5, dev="svg"----
qmplot(data = spd_raw, 
  geom = "blank", 
  x = Longitude,
  y = Latitude, 
  maptype = "toner-lite", 
  darken = 0.5) + 
  stat_density_2d(
    aes(fill = stat(level)), 
      geom = "polygon", 
      alpha = .2,
      color = NA) + 
  scale_fill_gradient2(
      "Incident\nConcentration", 
      low = "white", 
      mid = "yellow", 
      high = "red") + 
  theme(legend.position = "bottom")


## ----flag_assaults--------------------------------------------------------------
downtown <- spd_raw %>%
  filter(Latitude > 47.58, Latitude < 47.64,
         Longitude > -122.36, Longitude < -122.31)


## -------------------------------------------------------------------------------
assaults <- downtown %>% 
  filter(`Event Clearance Group` %in%
                  c("ASSAULTS", "ROBBERY")) %>%
  mutate(assault_label = `Event Clearance Description`)




## ----labels_2, echo=FALSE, message = FALSE, cache=TRUE, fig.height = 6, fig.width=3, dev="svg"----
qmplot(data = downtown,
       x = Longitude,
       y = Latitude,
       maptype = "toner-lite",
       color = I("firebrick"),
       alpha = I(0.5)) + 
  geom_label(data = assaults,
       aes(label = assault_label),
       size=2)




## ----ggrepel_2, echo=FALSE, message = FALSE, cache=TRUE, warning=FALSE, fig.height = 6, fig.width=3, dev="svg"----
library(ggrepel)
qmplot(data = 
    downtown,
    x = Longitude,
    y = Latitude,
    maptype = "toner-lite", 
    color = I("firebrick"), 
    alpha = I(0.5)) + 
  geom_label_repel(
    data = assaults,
    aes(label = assault_label), 
    fill = "black", 
    color = "white", 
    segment.color = "black",
    size=2)




## ---- include=FALSE-------------------------------------------------------------
library(sf)


## ---- cache=TRUE, message=FALSE, warning=FALSE----------------------------------
precinct_shape <- st_read("./data/district/votdst.shp",
                          stringsAsFactors = F) %>% 
  select(Precinct=NAME, geometry)


## ---- cache=TRUE, message=FALSE, warning=FALSE----------------------------------
precincts_votes_sf <- 
  read_csv("./data/king_county_elections_2016.txt") %>%
  filter(Race=="US President & Vice President",
         str_detect(Precinct, "SEA ")) %>% 
  select(Precinct, CounterType, SumOfCount) %>%
  group_by(Precinct) %>%
  filter(CounterType %in% 
           c("Donald J. Trump & Michael R. Pence",
             "Hillary Clinton & Tim Kaine",
             "Registered Voters",
             "Times Counted")) %>%
  mutate(CounterType =
           recode(CounterType, 
                  `Donald J. Trump & Michael R. Pence` = "Trump",
                  `Hillary Clinton & Tim Kaine` = "Clinton",
                  `Registered Voters`="RegisteredVoters",
                  `Times Counted` = "TotalVotes")) %>%
  spread(CounterType, SumOfCount) %>%
  mutate(P_Dem = Clinton / TotalVotes, 
         P_Rep = Trump / TotalVotes, 
         Turnout = TotalVotes / RegisteredVoters) %>%
  select(Precinct, P_Dem, P_Rep, Turnout) %>% 
  filter(!is.na(P_Dem)) %>%
  left_join(precinct_shape) %>%
  st_as_sf() # Makes sure resulting object is an sf dataframe


## -------------------------------------------------------------------------------
glimpse(precincts_votes_sf)




## ---- echo=FALSE, message=FALSE, warning=FALSE, cache=FALSE, dev="png", fig.retina=5, fig.width = 5, fig.height=8----
ggplot(precincts_votes_sf, 
       aes(fill=P_Dem)) + #<<
  geom_sf(size=NA) +
  theme_void() +
  theme(legend.position = 
          "right")


## ---- eval=FALSE, echo=FALSE----------------------------------------------------
## # If following along, you can install with this
## # Note you'll ALSO need to go get a Census API key above
## install.packages("tidycensus")


## ---- echo=FALSE----------------------------------------------------------------
library(tidycensus)


## ---- cache=TRUE, message=FALSE, warning=FALSE----------------------------------
library(tidycensus)
# census_api_key("PUT YOUR KEY HERE", install=TRUE)
acs_2015_vars <- load_variables(2015, "acs5")
acs_2015_vars[10:18,] %>% print() 


## ---- include=FALSE, cache=TRUE-------------------------------------------------
king_county <- get_acs(geography="tract", state="WA", 
                       county="King", geometry = TRUE,
                       variables=c("B02001_001E", 
                                   "B02009_001E"), 
                       output="wide")




## -------------------------------------------------------------------------------
glimpse(king_county)


## -------------------------------------------------------------------------------
king_county <-  king_county %>%
  select(-ends_with("M")) %>%
  rename(`Total Population`=B02001_001E,
         `Any Black`=B02009_001E) %>%
  mutate(`Any Black` = `Any Black` / `Total Population`)
glimpse(king_county)




## ----king_plot, eval=TRUE, echo=FALSE, dev="svg", fig.height = 6----------------
king_county %>% 
  ggplot(aes(fill = `Any Black`)) + 
  geom_sf(size = NA) + 
  coord_sf(crs = "+proj=longlat +datum=WGS84", datum = NA) + 
  scale_fill_continuous(name = "Any Black\n", 
                        low  = "#d4d5f9",
                        high = "#00025b") + 
  theme_minimal() + ggtitle("Proportion Any Black")


## ---- include=FALSE, cache=FALSE------------------------------------------------
st_erase <- function(x, y) {
  st_difference(x, st_make_valid(st_union(st_combine(y))))
}
kc_water <- tigris::area_water("WA", "King", class = "sf")
kc_nowater <- king_county %>% 
  st_erase(kc_water)




## ---- eval=TRUE, echo=FALSE, dev="svg", dpi = 300, fig.height = 6---------------
  ggplot(kc_nowater, 
         aes(fill=`Any Black`)) + 
  geom_sf(size = NA) + 
  coord_sf(crs = "+proj=longlat +datum=WGS84", datum=NA) + 
  scale_fill_continuous(name="Any Black\n", 
                        low="#d4d5f9",
                        high="#00025b") + 
  theme_minimal() + ggtitle("Proportion Any Black")


## ---- include=FALSE, cache=FALSE------------------------------------------------
pb_state <- 
  get_acs(geography = "tract", state = "IL",
          geometry  = TRUE,
          variables = c("B02001_001E", 
                        "B02009_001E"),
          output = "wide") %>%
  select(-ends_with("M")) %>%
  rename(`Total Population`=B02001_001E,
         `Any Black`=B02009_001E) %>%
  mutate(`Any Black` = `Any Black` / `Total Population`)






## ---- cache=FALSE, echo=FALSE, fig.height = 6, dev="svg"------------------------
pb_state %>% 
  ggplot(aes(fill = `Any Black`)) + 
  geom_sf(size = NA) + 
  coord_sf(crs = "+proj=longlat +datum=WGS84", datum=NA) + 
  scale_fill_continuous(name = "Any Black\n", 
                        low  = "#d4d5f9",
                        high = "#00025b") + 
  theme_minimal()


## ---- cache=FALSE, message=FALSE, warning=FALSE, results='hide'-----------------
urbans <- tigris::urban_areas(cb = TRUE, class = "sf")
glimpse(urbans)


## ---- echo=FALSE----------------------------------------------------------------
glimpse(urbans)


## -------------------------------------------------------------------------------
urban_il <- urbans %>% filter(str_detect(NAME10, "IL"))




## ---- eval=TRUE, echo=FALSE, cache=FALSE, echo=FALSE, fig.height = 6, dev="svg"----
pb_state %>% 
  ggplot(aes(fill=`Any Black`)) + 
  geom_sf(size = NA) + 
  geom_sf(data = urban_il, color = "black", fill = NA, size = 0.1, inherit.aes=FALSE) +
  coord_sf(crs = "+proj=longlat +datum=WGS84", datum=NA) + 
  scale_fill_continuous(name = "Any Black\n", 
                        low  = "#d4d5f9",
                        high = "#00025b") + 
  theme_minimal()

