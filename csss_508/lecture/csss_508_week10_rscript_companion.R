## ---- include=FALSE-------------------------------------------------------------------
library(tidyverse)
library(pander)
library(knitr)
`%!in%` <- Negate(`%in%`)
hook_output = knit_hooks$get('output')
knit_hooks$set(output = function(x, options) {
  if (!is.null(n <- options$out.lines)) {
    x = unlist(stringr::str_split(x, '\n'))
    if (length(x) > n) {
      # truncate the output
      x = c(head(x, n), '....\n')
    }
    x = paste(x, collapse = '\n') # paste first n lines together
  }
  hook_output(x, options)
})
opts_chunk$set(out.lines = 20)

ex_dat <- data.frame(num1 = rnorm(200, 1, 2), 
                     fac1 = sample(c(1, 2, 3), 200, TRUE),
                     num2 = rnorm(200, 0, 3),
                     fac2 = sample(c(1, 2))) %>%
  mutate(yn = num1*0.5 + fac1*1.1 + num2*0.7 + fac2-1.5  + rnorm(200, 0, 2)) %>% 
  mutate(yb = as.numeric(yn > mean(yn))) %>%
  mutate(fac1 = factor(fac1, labels=c("A", "B", "C")),
         fac2 = factor(fac2, labels=c("Yes", "No")))


## ---- warning=FALSE-------------------------------------------------------------------
library(broom)


## -------------------------------------------------------------------------------------
lm_1 <- lm(yn ~ num1 + fac1, data = ex_dat)
summary(lm_1)


## ---- op------------------------------------------------------------------------------
glm_1 <- glm(yb ~ num1 + fac1, data = ex_dat, family=binomial(link="logit"))
summary(glm_1)


## -------------------------------------------------------------------------------------
lm_1 %>% tidy()


## -------------------------------------------------------------------------------------
glm_1 %>% tidy()


## -------------------------------------------------------------------------------------
glance(lm_1)


## -------------------------------------------------------------------------------------
augment(lm_1) %>% head()


## -------------------------------------------------------------------------------------
ex_dat %>% 
  nest_by(fac1) %>% #<<
  mutate(model = list(lm(yn ~  num1 + fac2, data = data))) %>%  
  summarize(tidy(model), .groups = "drop")


## ---- warning=FALSE-------------------------------------------------------------------
library(gapminder)


## ---- fig.height = 2.75, fig.width = 7, dev="svg", warning=FALSE, message=FALSE-------
ggplot(data = gapminder, 
       aes(x = year, y = lifeExp, color = continent)) +
  geom_point(position = position_jitter(1,0), size = 0.5) +
  geom_smooth()


## ---- fig.height = 2.75, fig.width = 7, dev="svg", warning=FALSE, message=FALSE-------
ggplot(data = gapminder, 
       aes(x = year, y = lifeExp, color = continent)) +
  geom_point(position = position_jitter(1,0), size = 0.5) +
  geom_smooth(method = "glm", formula = y ~ x) #<<


## ---- fig.height = 2.75, fig.width = 7, dev="svg", warning=FALSE, message=FALSE-------
ggplot(data = gapminder, 
       aes(x = year, y = lifeExp, color = continent)) +
  geom_point(position = position_jitter(1,0), size = 0.5) +
  geom_smooth(method = "glm", formula = y ~ poly(x, 2)) #<<


## ---- warning=FALSE-------------------------------------------------------------------
library(ggeffects)


## -------------------------------------------------------------------------------------
ex_dat <- data.frame(num1 = rnorm(200, 1, 2), 
                     fac1 = sample(c(1, 2, 3), 200, TRUE),
                     num2 = rnorm(200, 0, 3),
                     fac2 = sample(c(1, 2))) %>%
  mutate(yn = num1 * 0.5 + fac1 * 1.1 + num2 * 0.7 +
              fac2 - 1.5  + rnorm(200, 0, 2)) %>% 
  mutate(yb = as.numeric(yn > mean(yn))) %>%
  mutate(fac1 = factor(fac1, labels = c("A", "B", "C")),
         fac2 = factor(fac2, labels = c("Yes", "No")))


## -------------------------------------------------------------------------------------
lm_1 <- lm(yn ~ num1 + fac1, data = ex_dat)
lm_1_est <- ggpredict(lm_1, terms = "num1")


## -------------------------------------------------------------------------------------
lm_1_est


## ---- warning=FALSE, message=FALSE, dev="svg", fig.height=4---------------------------
plot(lm_1_est)


## ---- warning=FALSE, message=FALSE, dev="svg", fig.height=3.5-------------------------
glm(yb ~ num1 + fac1 + num2 + fac2, data = ex_dat, family=binomial(link = "logit")) %>%
  ggpredict(terms = c("num1", "fac1")) %>% plot()


## ---- warning=FALSE, message=FALSE, dev="svg", fig.height=3.5-------------------------
glm(yb ~ num1 + fac1 + num2 + fac2, data = ex_dat, family = binomial(link = "logit")) %>%
  ggpredict(terms = c("num1", "fac1")) %>% plot(facet=TRUE)


## ---- warning=FALSE, message=FALSE, dev="svg", fig.height=3.5-------------------------
glm(yb ~ num1 + fac1 + num2 + fac2, data=ex_dat, family=binomial(link="logit")) %>%
  ggpredict(terms = c("num1 [-1,0,1]", "fac1 [A,B]")) %>% plot(facet=TRUE)


## ---- warning=FALSE, message=FALSE, dev="svg", fig.height=3.5-------------------------
glm(yb ~ num1 + fac1 + num2 + fac2, data = ex_dat, family = binomial(link = "logit")) %>%
  ggpredict(terms = c("num1 [meansd]", "num2 [minmax]")) %>% plot(facet=TRUE)


## ---- warning=FALSE, message=FALSE, dev="svg", fig.height=3.5-------------------------
lm(yn ~ fac1 + fac2, data = ex_dat) %>% 
  ggpredict(terms=c("fac1", "fac2")) %>% plot()


## ----pander, warning=FALSE------------------------------------------------------------
library(pander)


## ---- include=FALSE-------------------------------------------------------------------
panderOptions("table.style", "rmarkdown")


## ---- echo=TRUE, eval=FALSE-----------------------------------------------------------
## pander(lm_1)


## ---- eval=FALSE, echo=TRUE-----------------------------------------------------------
## pander(summary(lm_1))


## ---- warning=FALSE-------------------------------------------------------------------
library(gt)
tes_chars <- starwars %>% 
  unnest(films) %>% 
  unnest(starships, keep_empty=TRUE) %>% 
  filter(films == "The Empire Strikes Back") %>% 
  select(name, species, starships, mass, height) %>%
  distinct(name, .keep_all = TRUE) %>%
  mutate(starships = ifelse(name == "Obi-Wan Kenobi" | is.na(starships), 
                            "No Ship", starships))
glimpse(tes_chars)


## ---- eval=FALSE----------------------------------------------------------------------
## tes_chars %>%
##   gt()
## 


## ---- echo=FALSE----------------------------------------------------------------------
tes_chars %>%
  gt() %>% 
  gtsave("img/sw_table_1.png")


## ---- eval=FALSE----------------------------------------------------------------------
## tes_chars %>%
##   group_by(starships) %>%
##   gt()


## ---- echo=FALSE----------------------------------------------------------------------
tes_chars %>% 
  group_by(starships) %>%
  gt() %>%  
  gtsave("img/sw_table_2.png")


## ---- eval=FALSE----------------------------------------------------------------------
## tes_chars %>%
##   group_by(starships) %>%
##   gt(rowname_col = "name")


## ---- echo=FALSE----------------------------------------------------------------------
tes_chars %>% 
  group_by(starships) %>%
  gt(rowname_col = "name") %>%
  gtsave("img/sw_table_3.png")


## ---- eval=FALSE----------------------------------------------------------------------
## tes_chars %>%
##   group_by(starships) %>%
##   gt(rowname_col = "name") %>%
##   tab_header(
##     title = "Star Wars Characters",
##     subtitle = "The Empire Strikes Back"
##   )


## ---- echo=FALSE----------------------------------------------------------------------
tes_chars %>% 
  group_by(starships) %>%
  gt(rowname_col = "name") %>%
  tab_header(
    title = "Star Wars Characters", 
    subtitle = "The Empire Strikes Back"
  ) %>% gtsave("img/sw_table_4.png")


## ---- eval=FALSE----------------------------------------------------------------------
## tes_chars %>%
##   group_by(starships) %>%
##   gt(rowname_col = "name") %>%
##   tab_header(
##     title = "Star Wars Characters",
##     subtitle = "The Empire Strikes Back"
##   ) %>%
##   tab_spanner(
##     label = "Vitals",
##     columns = c(mass, height)
##   )


## ---- echo=FALSE----------------------------------------------------------------------
tes_chars %>% 
  group_by(starships) %>%
  gt(rowname_col = "name") %>%
  tab_header(
    title = "Star Wars Characters", 
    subtitle = "The Empire Strikes Back"
  ) %>%
  tab_spanner(
    label = "Vitals",
    columns = c(mass, height)
  ) %>% gtsave("img/sw_table_5.png")


## ---- eval=FALSE----------------------------------------------------------------------
## tes_chars %>%
##   group_by(starships) %>%
##   gt(rowname_col = "name") %>%
##   tab_header(
##     title = "Star Wars Characters",
##     subtitle = "The Empire Strikes Back"
##   ) %>%
##   tab_spanner(
##     label = "Vitals",
##     columns = c(mass, height)
##   ) %>%
##   cols_label(
##     mass = "Mass (kg)",
##     height = "Height (cm)",
##     species = "Species"
##   )


## ---- echo=FALSE----------------------------------------------------------------------
tes_chars %>% 
  group_by(starships) %>%
  gt(rowname_col = "name") %>%
  tab_header(
    title = "Star Wars Characters", 
    subtitle = "The Empire Strikes Back"
  ) %>%
  tab_spanner(
    label = "Vitals",
    columns = c(mass, height)
  ) %>%
  cols_label(
    mass = "Mass (kg)",
    height = "Height (cm)",
    species = "Species"
  ) %>% gtsave("img/sw_table_6.png")


## ---- eval=FALSE----------------------------------------------------------------------
## tes_chars %>%
##   group_by(starships) %>%
##   gt(rowname_col = "name") %>%
##   tab_header(
##     title = "Star Wars Characters",
##     subtitle = "The Empire Strikes Back"
##   ) %>%
##   tab_spanner(
##     label = "Vitals",
##     columns = c(mass, height)
##   ) %>%
##   cols_label(
##     mass = "Mass (kg)",
##     height = "Height (cm)",
##     species = "Species"
##   ) %>%
##   fmt_number(
##     columns = c(mass),
##     decimals = 0)


## ---- echo=FALSE----------------------------------------------------------------------
tes_chars %>% 
  group_by(starships) %>%
  gt(rowname_col = "name") %>%
  tab_header(
    title = "Star Wars Characters", 
    subtitle = "The Empire Strikes Back"
  ) %>%
  tab_spanner(
    label = "Vitals",
    columns = c(mass, height)
  ) %>%
  cols_label(
    mass = "Mass (kg)",
    height = "Height (cm)",
    species = "Species"
  ) %>%
  fmt_number(
    columns = c(mass),
    decimals = 0
  ) %>% gtsave("img/sw_table_7.png")


## ---- eval=FALSE----------------------------------------------------------------------
## tes_chars %>%
##   group_by(starships) %>%
##   gt(rowname_col = "name") %>%
##   tab_header(
##     title = "Star Wars Characters",
##     subtitle = "The Empire Strikes Back"
##   ) %>%
##   tab_spanner(
##     label = "Vitals",
##     columns = c(mass, height)
##   ) %>%
##   cols_label(
##     mass = "Mass (kg)",
##     height = "Height (cm)",
##     species = "Species"
##   ) %>%
##   fmt_number(
##     columns = c(mass),
##     decimals = 0
##   ) %>%
##   cols_align(
##     align = "center",
##     columns = c(species, mass, height)
##   )


## ---- echo=FALSE----------------------------------------------------------------------
tes_chars %>% 
  group_by(starships) %>%
  gt(rowname_col = "name") %>%
  tab_header(
    title = "Star Wars Characters", 
    subtitle = "The Empire Strikes Back"
  ) %>%
  tab_spanner(
    label = "Vitals",
    columns = c(mass, height)
  ) %>%
  cols_label(
    mass = "Mass (kg)",
    height = "Height (cm)",
    species = "Species"
  ) %>%
  fmt_number(
    columns = c(mass),
    decimals = 0
  ) %>%
  cols_align(
    align = "center",
    columns = c(species, mass, height)
  ) %>% gtsave("img/sw_table_8.png")


## ---- eval=FALSE----------------------------------------------------------------------
## tes_chars %>%
##   group_by(starships) %>%
##   gt(rowname_col = "name") %>%
##   tab_header(
##     title = "Star Wars Characters",
##     subtitle = "The Empire Strikes Back"
##   ) %>%
##   tab_spanner(
##     label = "Vitals",
##     columns = c(mass, height)
##   ) %>%
##   cols_label(
##     mass = "Mass (kg)",
##     height = "Height (cm)",
##     species = "Species"
##   ) %>%
##   fmt_number(
##     columns = c(mass),
##     decimals = 0
##   ) %>%
##   cols_align(
##     align = "center",
##     columns = c(species, mass, height)
##   ) %>%
##   row_group_order(
##     groups = c("X-wing",
##                "Millennium Falcon")
##   )


## ---- echo=FALSE----------------------------------------------------------------------
tes_chars %>% 
  group_by(starships) %>%
  gt(rowname_col = "name") %>%
  tab_header(
    title = "Star Wars Characters", 
    subtitle = "The Empire Strikes Back"
  ) %>%
  tab_spanner(
    label = "Vitals",
    columns = c(mass, height)
  ) %>%
  cols_label(
    mass = "Mass (kg)",
    height = "Height (cm)",
    species = "Species"
  ) %>%
  fmt_number(
    columns = c(mass),
    decimals = 0
  ) %>%
  cols_align(
    align = "center",
    columns = c(species, mass, height)
  ) %>%
  row_group_order(
    groups = c("X-wing", 
               "Millennium Falcon")
  ) %>% gtsave("img/sw_table_9.png")


## ---- echo=FALSE----------------------------------------------------------------------
tes_chars %>%
  gt() %>% 
  gtsave("img/sw_table_1.png")


## ---- echo=FALSE----------------------------------------------------------------------
tes_chars %>% 
  group_by(starships) %>%
  gt(rowname_col = "name") %>%
  tab_header(
    title = "Star Wars Characters", 
    subtitle = "The Empire Strikes Back"
  ) %>%
  tab_spanner(
    label = "Vitals",
    columns = c(mass, height)
  ) %>%
  cols_label(
    mass = "Mass (kg)",
    height = "Height (cm)",
    species = "Species"
  ) %>%
  fmt_number(
    columns = c(mass),
    decimals = 0
  ) %>%
  cols_align(
    align = "center",
    columns = c(species, mass, height)
  ) %>%
  row_group_order(
    groups = c("X-wing", 
               "Millennium Falcon")
  ) %>% gtsave("img/sw_table_9.png")


## ---- message=FALSE, warning=FALSE----------------------------------------------------
library(modelsummary)


## ---- eval=FALSE, echo=TRUE-----------------------------------------------------------
## mod_1 <- lm(mpg ~ wt, data = mtcars)
## msummary(mod_1)


## ---- eval=TRUE, echo=FALSE-----------------------------------------------------------
mod_1 <- lm(mpg ~ wt, data = mtcars)
msummary(mod_1)


## ---- eval=FALSE, echo=TRUE-----------------------------------------------------------
## mod_1 <- lm(mpg ~ wt, data = mtcars)
## mod_2 <- lm(mpg ~ hp + wt, data = mtcars)
## mod_3 <- lm(mpg ~ hp + wt + factor(am),
##             data = mtcars)
## model_list <- list("Model 1" = mod_1,
##                    "Model 2" = mod_2,
##                    "Model 3" = mod_3)
## msummary(model_list)


## ---- eval=TRUE, echo=FALSE-----------------------------------------------------------
mod_1 <- lm(mpg ~ wt, data = mtcars)
mod_2 <- lm(mpg ~ hp + wt, data = mtcars)
mod_3 <- lm(mpg ~ hp + wt + factor(am), 
            data = mtcars)
model_list <- list("Model 1" = mod_1, 
                   "Model 2" = mod_2, 
                   "Model 3" = mod_3)
msummary(model_list, output = "gt")


## ---- eval=FALSE----------------------------------------------------------------------
## msummary(model_list, output = "latex")


## -------------------------------------------------------------------------------------
msummary(model_list, output = "ex_table.png")


## ---- eval=FALSE----------------------------------------------------------------------
## msummary(model_list, output = "gt") %>%
##   tab_header(
##     title = "Table 1. Linear Models",
##     subtitle = "DV: Miles per Gallon"
##   )


## ---- echo=FALSE----------------------------------------------------------------------
msummary(model_list, output = "gt") %>%
  tab_header(
    title = "Table 1. Linear Models", 
    subtitle = "DV: Miles per Gallon"
  ) %>%
  gtsave("img/gt_summary.png")


## ---- warning=FALSE-------------------------------------------------------------------
library(gtsummary)


## ---- eval=FALSE----------------------------------------------------------------------
## mtcars %>%
##   select(1:9) %>%
##   tbl_summary()


## ---- echo=FALSE----------------------------------------------------------------------
mtcars %>% 
  select(1:9) %>%
  tbl_summary()


## ---- eval=FALSE----------------------------------------------------------------------
## mtcars %>%
##   select(1:9) %>%
##   tbl_summary(by = "am")


## ---- echo=FALSE----------------------------------------------------------------------
mtcars %>% 
  select(1:9) %>%
  tbl_summary(by = "am")


## ---- eval=FALSE----------------------------------------------------------------------
## mtcars %>%
##   select(1:9) %>%
##   tbl_summary(by = "am") %>%
##   as_gt() %>%
##   tab_spanner(
##     label = "Transmission",
##     columns = starts_with("stat_")
##   ) %>%
##   tab_header(
##     title = "Motor Trend Cars",
##     subtitle = "Descriptive Statistics"
##   )


## ---- echo=FALSE----------------------------------------------------------------------
mtcars %>% 
  select(1:9) %>%
  tbl_summary(by = "am") %>%
  as_gt() %>%
  tab_spanner(label = "Transmission", 
              columns = starts_with("stat_")) %>%
  tab_header("Motor Trend Cars", 
             subtitle = "Descriptive Statistics") %>%
  gtsave("img/gtsummary.png")


## ---- message=FALSE, warning=FALSE, eval=FALSE----------------------------------------
## library(corrplot)
## corrplot(
##   cor(mtcars),
##   addCoef.col = "white",
##   addCoefasPercent=T,
##   type="upper",
##   order="AOE")


## ---- message=FALSE, warning=FALSE, eval=TRUE, echo=FALSE, dev="svg", fig.height=5----
library(corrplot)
corrplot(cor(mtcars), addCoef.col = "white", addCoefasPercent=T, type="upper", order="FPC")

