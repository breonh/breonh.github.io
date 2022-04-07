## ------------------------------------------
new.object <- 1:10 # Making vector of 1 to 10 


## ------------------------------------------
save(new.object, file="new_object.RData")


## ------------------------------------------
load("new_object.RData")


## ------------------------------------------
getwd()


## ---- eval=FALSE---------------------------
## setwd("C:/Users/breha/Documents")


## ---- warning=FALSE------------------------
library(gapminder)


## ------------------------------------------
str(gapminder)


## ---- message=TRUE-------------------------
library(dplyr)


## ------------------------------------------
log(mean(gapminder$pop))


## ------------------------------------------
gapminder$pop %>% mean() %>% log()


## ------------------------------------------
gapminder %>% filter(country == "Algeria")


## ------------------------------------------
head(gapminder$country == "Algeria", 50) # display first 50 elements


## ------------------------------------------
gapminder %>%
    filter(country == "Oman" & year > 1980)


## ---- eval=FALSE---------------------------
## gapminder %>%
##   filter(country == "Oman" &
##          year > 1980)


## ---- eval=FALSE---------------------------
## gapminder %>%
##   filter(country == "Oman" |
##          year > 1980)


## ------------------------------------------
China <- gapminder %>% filter(country == "China")
head(China, 4)


## ---- eval=FALSE---------------------------
## plot(lifeExp ~ year,
##      data = China,
##      xlab = "Year",
##      ylab = "Life expectancy",
##      main = "Life expectancy in China",
##      col = "red",
##      cex.lab = 1.5,
##      cex.main= 1.5,
##      pch = 16)


## ---- echo=FALSE---------------------------
plot(lifeExp ~ year, data = China, xlab = "Year", ylab = "Life expectancy",
     main = "Life expectancy in China", col = "red", cex = 1, pch = 16)


## ------------------------------------------
library(ggplot2)


## ----  dev='svg', eval=FALSE---------------
## ggplot(data = China,
##        aes(x = year, y = lifeExp)) +
##     geom_point()


## ----  dev='svg', echo=FALSE---------------
ggplot(data = China, aes(x = year, y = lifeExp)) +
    geom_point()


## ---- fig.height=4, dev='svg', eval=FALSE----
## ggplot(data = China,  #<<
##        aes(x = year, y = lifeExp)) #<<


## ---- dev='svg', echo=FALSE----------------
ggplot(data = China,  
       aes(x = year, y = lifeExp)) 


## ---- fig.height=4, dev='svg', eval=FALSE----
## ggplot(data = China,
##        aes(x = year, y = lifeExp)) +
##   geom_point() #<<


## ----  dev='svg', echo=FALSE---------------
ggplot(data = China, 
       aes(x = year, y = lifeExp)) +
  geom_point() 


## ---- fig.height=4, dev='svg', eval=FALSE----
## ggplot(data = China,
##        aes(x = year, y = lifeExp)) +
##   geom_point(color = "red", size = 3) #<<


## ----  dev='svg', echo=FALSE---------------
ggplot(data = China, 
       aes(x = year, y = lifeExp)) +
  geom_point(color = "red", size = 3) 


## ---- fig.height=4, dev='svg', eval=FALSE----
## ggplot(data = China,
##        aes(x = year, y = lifeExp)) +
##   geom_point(color = "red", size = 3) +
##   xlab("Year") #<<


## ----  dev='svg', echo=FALSE---------------
ggplot(data = China, 
       aes(x = year, y = lifeExp)) +
  geom_point(color = "red", size = 3) +
  xlab("Year") 


## ---- fig.height=4, dev='svg', eval=FALSE----
## ggplot(data = China,
##        aes(x = year, y = lifeExp)) +
##   geom_point(color = "red", size = 3) +
##   xlab("Year") +
##   ylab("Life expectancy") #<<


## ----  dev='svg', echo=FALSE---------------
ggplot(data = China, 
       aes(x = year, y = lifeExp)) +
  geom_point(color = "red", size = 3) +
  xlab("Year") + 
  ylab("Life expectancy")


## ---- fig.height=4, dev='svg', eval=FALSE----
## ggplot(data = China,
##        aes(x = year, y = lifeExp)) +
##   geom_point(color = "red", size = 3) +
##   xlab("Year") +
##   ylab("Life expectancy") +
##   ggtitle("Life expectancy in China") #<<


## ----  dev='svg', echo=FALSE---------------
ggplot(data = China, 
       aes(x = year, y = lifeExp)) +
  geom_point(color = "red", size = 3) +
  xlab("Year") + 
  ylab("Life expectancy") +
  ggtitle("Life expectancy in China")


## ---- fig.height=4, dev='svg', eval=FALSE----
## ggplot(data = China,
##        aes(x = year, y = lifeExp)) +
##   geom_point(color = "red", size = 3) +
##   xlab("Year") +
##   ylab("Life expectancy") +
##   ggtitle("Life expectancy in China") +
##   theme_bw() #<<


## ----  dev='svg', echo=FALSE---------------
ggplot(data = China, 
       aes(x = year, y = lifeExp)) +
  geom_point(color = "red", size = 3) +
  xlab("Year") + 
  ylab("Life expectancy") +
  ggtitle("Life expectancy in China") +
  theme_bw() #<<


## ---- fig.height=4, dev='svg', eval=FALSE----
## ggplot(data = China,
##        aes(x = year, y = lifeExp)) +
##   geom_point(color = "red", size = 3) +
##   xlab("Year") +
##   ylab("Life expectancy") +
##   ggtitle("Life expectancy in China") +
##   theme_bw(base_size=18) #<<


## ----  dev='svg', echo=FALSE---------------
ggplot(data = China, 
       aes(x = year, y = lifeExp)) +
  geom_point(color = "red", size = 3) +
  xlab("Year") + 
  ylab("Life expectancy") +
  ggtitle("Life expectancy in China") +
  theme_bw(base_size=18) #<<


## ---- fig.height=4, dev='svg', eval=FALSE----
## ggplot(data = gapminder,#<<
##        aes(x = year, y = lifeExp)) +
##   geom_point(color = "red", size = 3) +
##   xlab("Year") +
##   ylab("Life expectancy") +
##   ggtitle("Life expectancy over time") +
##   theme_bw(base_size=18)


## ----  dev='svg', echo=FALSE---------------
ggplot(data = gapminder, #<<
       aes(x = year, y = lifeExp)) +
  geom_point(color = "red", size = 3) +
  xlab("Year") + 
  ylab("Life expectancy") +
  ggtitle("Life expectancy over time") +
  theme_bw(base_size=18)


## ---- fig.height=4, dev='svg', eval=FALSE----
## ggplot(data = gapminder,
##        aes(x = year, y = lifeExp)) +
##   geom_line(color = "red", size = 3) + #<<
##   xlab("Year") +
##   ylab("Life expectancy") +
##   ggtitle("Life expectancy over time") +
##   theme_bw(base_size=18)


## ----  dev='svg', echo=FALSE---------------
ggplot(data = gapminder, 
       aes(x = year, y = lifeExp)) +
  geom_line(color = "red", size = 3) + #<<
  xlab("Year") + 
  ylab("Life expectancy") +
  ggtitle("Life expectancy over time") +
  theme_bw(base_size=18)


## ---- fig.height=4, dev='svg', eval=FALSE----
## ggplot(data = gapminder,
##        aes(x = year, y = lifeExp,
##            group = country)) + #<<
##   geom_line(color = "red", size = 3) +
##   xlab("Year") +
##   ylab("Life expectancy") +
##   ggtitle("Life expectancy over time") +
##   theme_bw(base_size=18)


## ----  dev='svg', echo=FALSE---------------
ggplot(data = gapminder, 
       aes(x = year, y = lifeExp, 
           group = country)) + #<<
  geom_line(color = "red", size = 3) +
  xlab("Year") + 
  ylab("Life expectancy") +
  ggtitle("Life expectancy over time") +
  theme_bw(base_size=18)


## ---- fig.height=4, dev='svg', eval=FALSE----
## ggplot(data = gapminder,
##        aes(x = year, y = lifeExp,
##            group = country)) +
##   geom_line(color = "red") + #<<
##   xlab("Year") +
##   ylab("Life expectancy") +
##   ggtitle("Life expectancy over time") +
##   theme_bw(base_size=18)


## ----  dev='svg', echo=FALSE---------------
ggplot(data = gapminder, 
       aes(x = year, y = lifeExp, 
           group = country)) +
  geom_line(color = "red") + #<<
  xlab("Year") + 
  ylab("Life expectancy") +
  ggtitle("Life expectancy over time") +
  theme_bw(base_size=18)


## ---- fig.height=4, dev='svg', eval=FALSE----
## ggplot(data = gapminder,
##        aes(x = year, y = lifeExp,
##            group = country,
##            color = continent)) + #<<
##   geom_line() + #<<
##   xlab("Year") +
##   ylab("Life expectancy") +
##   ggtitle("Life expectancy over time") +
##   theme_bw(base_size=18)


## ----  dev='svg', echo=FALSE---------------
ggplot(data = gapminder, 
       aes(x = year, y = lifeExp, 
           group = country, 
           color = continent)) + #<<
  geom_line() + #<<
  xlab("Year") + 
  ylab("Life expectancy") +
  ggtitle("Life expectancy over time") +
  theme_bw(base_size=18) #<<


## ---- fig.height=4, dev='svg', eval=FALSE----
## ggplot(data = gapminder,
##        aes(x = year, y = lifeExp,
##            group = country,
##            color = continent)) +
##   geom_line() +
##   xlab("Year") +
##   ylab("Life expectancy") +
##   ggtitle("Life expectancy over time") +
##   theme_bw(base_size=18) +
##   facet_wrap(~ continent) #<<


## ----  dev='svg', echo=FALSE---------------
ggplot(data = gapminder, 
       aes(x = year, y = lifeExp, 
           group = country, 
           color = continent)) +
  geom_line() +
  xlab("Year") + 
  ylab("Life expectancy") +
  ggtitle("Life expectancy over time") +
  theme_bw(base_size=18) +
  facet_wrap(~ continent) #<<


## ---- fig.height=4, dev='svg', eval=FALSE----
## ggplot(data = gapminder,
##        aes(x = year, y = lifeExp,
##            group = country,
##            color = continent)) +
##   geom_line() +
##   xlab("Year") +
##   ylab("Life expectancy") +
##   ggtitle("Life expectancy over time") +
##   theme_bw() +  #<<
##   facet_wrap(~ continent)


## ----  dev='svg', echo=FALSE---------------
ggplot(data = gapminder, 
       aes(x = year, y = lifeExp, 
           group = country, 
           color = continent)) +
  geom_line() +
  xlab("Year") + 
  ylab("Life expectancy") +
  ggtitle("Life expectancy over time") +
  theme_bw() + #<<
  facet_wrap(~ continent)


## ---- fig.height=4, dev='svg', eval=FALSE----
## ggplot(data = gapminder,
##        aes(x = year, y = lifeExp,
##            group = country,
##            color = continent)) +
##   geom_line() +
##   xlab("Year") +
##   ylab("Life expectancy") +
##   ggtitle("Life expectancy over time") +
##   theme_bw() +
##   facet_wrap(~ continent) +
##   theme(legend.position = c(0.8, 0.25)) #<<


## ----  dev='svg', echo=FALSE---------------
ggplot(data = gapminder, 
       aes(x = year, y = lifeExp, 
           group = country, 
           color = continent)) +
  geom_line() +
  xlab("Year") + 
  ylab("Life expectancy") +
  ggtitle("Life expectancy over time") +
  theme_bw() + 
  facet_wrap(~ continent) +
  theme(legend.position = c(0.8, 0.25)) #<<


## ---- fig.height=4, dev='svg', eval=FALSE----
## ggplot(data = gapminder,
##        aes(x = year, y = lifeExp,
##            group = country,
##            color = continent)) +
##   geom_line() +
##   xlab("Year") +
##   ylab("Life expectancy") +
##   ggtitle("Life expectancy over time") +
##   theme_bw() +
##   facet_wrap(~ continent) +
##   theme(legend.position = "none") #<<


## ----  dev='svg', echo=FALSE---------------
ggplot(data = gapminder, 
       aes(x = year, y = lifeExp, 
           group = country, 
           color = continent)) +
  geom_line() +
  xlab("Year") + 
  ylab("Life expectancy") +
  ggtitle("Life expectancy over time") +
  theme_bw() + 
  facet_wrap(~ continent) +
  theme(legend.position = "none") #<<


## ------------------------------------------
lifeExp_by_year <- 
  ggplot(data = gapminder, 
       aes(x = year, y = lifeExp, 
           group = country, 
           color = continent)) +
  geom_line() +
  xlab("Year") + 
  ylab("Life expectancy") +
  ggtitle("Life expectancy over time") +
  theme_bw() + 
  facet_wrap(~ continent) +
  theme(legend.position = "none")


## ---- fig.height=4, dev='svg'--------------
lifeExp_by_year


## ---- fig.height=4, dev='svg'--------------
lifeExp_by_year +
    theme(legend.position = "bottom")


## ---- fig.height=3.2, dev='svg'------------
ggplot(data = China, aes(x = year, y = gdpPercap)) +
    geom_line() +
    scale_y_log10(breaks = c(1000, 2000, 3000, 4000, 5000), #<<
                  labels = scales::dollar) + #<<
    xlim(1940, 2010) + 
  ggtitle("GDP per capita in China")


## ---- fig.height=3.5, dev='svg'------------
ggplot(data = China, aes(x = year, y = lifeExp)) +
    geom_line() +
    ggtitle("Life Expectancy in China") +
    theme_gray(base_size = 20) #<<


## ---- fig.height=4, dev='svg'--------------
lifeExp_by_year +
  theme(legend.position = c(0.8, 0.2)) +
  scale_color_manual(
    name = "Which continent are\nwe looking at?", # \n adds a line break #<<
    values = c("Africa" = "seagreen", "Americas" = "turquoise1", 
               "Asia" = "royalblue", "Europe" = "violetred1", "Oceania" = "yellow"))


## ---- eval=FALSE---------------------------
## ggplot(data = gapminder, aes(x = year, y = lifeExp, group = country)) +
##     geom_line(alpha = 0.5, aes(color = "Country", size = "Country")) +
##     geom_line(stat = "smooth", method = "loess", #<<
##           aes(group = continent, color = "Continent", size = "Continent"), alpha = 0.5) +
##     facet_wrap(~ continent, nrow = 2) + #<<
##     scale_color_manual(name = "Life Exp. for:", #<<
##                        values = c("Country" = "black", "Continent" = "blue")) + #<<
##     scale_size_manual(name = "Life Exp. for:",
##                       values = c("Country" = 0.25, "Continent" = 3)) +
##     theme_minimal(base_size = 14) +
##     ylab("Years") + xlab("") +
##     ggtitle("Life Expectancy, 1952-2007", subtitle = "By continent and country") +
##     theme(legend.position=c(0.75, 0.2), axis.text.x = element_text(angle = 45)) #<<


## ---- echo=TRUE, fig.height=3.5, dev='svg', fig.show="hold", warning=FALSE----
ggplot(data = gapminder, aes(x = year, y = lifeExp, group = country)) #<<
  #
  #
  #  
  #
  #
  #
  #
  #
  #


## ---- echo=TRUE, fig.height=3.5, dev='svg', fig.show="hold", warning=FALSE, message=FALSE----
ggplot(data = gapminder, aes(x = year, y = lifeExp, group = country)) +
  geom_line() #<<
  #
  #  
  #
  #
  #
  #
  #
  #


## ---- echo=TRUE, fig.height=3.5, dev='svg', fig.show="hold", warning=FALSE, message=FALSE----
ggplot(data = gapminder, aes(x = year, y = lifeExp, group = country)) +
  geom_line() +
  geom_line(stat = "smooth", method = "loess", #<<
            aes(group = continent)) #<<
  #
  #
  #
  #
  #
  #


## ---- echo=TRUE, fig.height=3.5, dev='svg', fig.show="hold", warning=FALSE, message=FALSE----
ggplot(data = gapminder, aes(x = year, y = lifeExp, group = country)) +
  geom_line() +
  geom_line(stat = "smooth", method = "loess", 
            aes(group = continent)) +
  facet_wrap(~ continent, nrow = 2) #<<
  #
  #
  #
  #
  #


## ---- echo=TRUE, fig.height=3.5, dev='svg', fig.show="hold", warning=FALSE, message=FALSE----
ggplot(data = gapminder, aes(x = year, y = lifeExp, group = country)) +
  geom_line(aes(color = "Country")) + #<<
  geom_line(stat = "smooth", method = "loess", 
            aes(group = continent, color = "Continent")) + #<<
  facet_wrap(~ continent, nrow = 2) +
  scale_color_manual(name = "Life Exp. for:", values = c("Country" = "black", "Continent" = "blue")) #<<
  #
  #
  #
  #


## ---- echo=TRUE, fig.height=3.5, dev='svg', fig.show="hold", warning=FALSE, message=FALSE----
ggplot(data = gapminder, aes(x = year, y = lifeExp, group = country)) +
  geom_line(aes(color = "Country", size = "Country")) + #<<
  geom_line(stat = "smooth", method = "loess", 
            aes(group = continent, color = "Continent", size = "Continent")) + #<<
  facet_wrap(~ continent, nrow = 2) +
  scale_color_manual(name = "Life Exp. for:", values = c("Country" = "black", "Continent" = "blue")) +
  scale_size_manual(name = "Life Exp. for:", values = c("Country" = 0.25, "Continent" = 3)) #<<
  #
  #
  #


## ---- echo=TRUE, fig.height=3.5, dev='svg', fig.show="hold", warning=FALSE, message=FALSE----
ggplot(data = gapminder, aes(x = year, y = lifeExp, group = country)) +
  geom_line(alpha = 0.5, aes(color = "Country", size = "Country")) + #<<
  geom_line(stat = "smooth", method = "loess", 
            aes(group = continent, color = "Continent", size = "Continent"), alpha = 0.5) + #<<
  facet_wrap(~ continent, nrow = 2) +
  scale_color_manual(name = "Life Exp. for:", values = c("Country" = "black", "Continent" = "blue")) +
  scale_size_manual(name = "Life Exp. for:", values = c("Country" = 0.25, "Continent" = 3))
  #
  #
  #


## ---- echo=TRUE, fig.height=3.5, dev='svg', fig.show="hold", warning=FALSE, message=FALSE----
ggplot(data = gapminder, aes(x = year, y = lifeExp, group = country)) +
  geom_line(alpha = 0.5, aes(color = "Country", size = "Country")) +
  geom_line(stat = "smooth", method = "loess", 
            aes(group = continent, color = "Continent", size = "Continent"), alpha = 0.5) +
  facet_wrap(~ continent, nrow = 2) +
  scale_color_manual(name = "Life Exp. for:", values = c("Country" = "black", "Continent" = "blue")) +
  scale_size_manual(name = "Life Exp. for:", values = c("Country" = 0.25, "Continent" = 3)) +
  theme_minimal(base_size = 14) + ylab("Years") + xlab("") #<<
  #
  #


## ---- echo=TRUE, fig.height=3.5, dev='svg', fig.show="hold", warning=FALSE, message=FALSE----
ggplot(data = gapminder, aes(x = year, y = lifeExp, group = country)) +
  geom_line(alpha = 0.5, aes(color = "Country", size = "Country")) +
  geom_line(stat = "smooth", method = "loess", 
            aes(group = continent, color = "Continent", size = "Continent"), alpha = 0.5) +
  facet_wrap(~ continent, nrow = 2) +
  scale_color_manual(name = "Life Exp. for:", values = c("Country" = "black", "Continent" = "blue")) +
  scale_size_manual(name = "Life Exp. for:", values = c("Country" = 0.25, "Continent" = 3)) +
  theme_minimal(base_size = 14) + ylab("Years") + xlab("") + 
  ggtitle("Life Expectancy, 1952-2007", subtitle = "By continent and country") #<<
  #


## ---- echo=TRUE, fig.height=3.5, dev='svg', fig.show="hold", warning=FALSE, message=FALSE----
ggplot(data = gapminder, aes(x = year, y = lifeExp, group = country)) +
  geom_line(alpha = 0.5, aes(color = "Country", size = "Country")) +
  geom_line(stat = "smooth", method = "loess", 
            aes(group = continent, color = "Continent", size = "Continent"), alpha = 0.5) +
  facet_wrap(~ continent, nrow = 2) +
  scale_color_manual(name = "Life Exp. for:", values = c("Country" = "black", "Continent" = "blue")) +
  scale_size_manual(name = "Life Exp. for:", values = c("Country" = 0.25, "Continent" = 3)) +
  theme_minimal(base_size = 14) + ylab("Years") + xlab("") + 
  ggtitle("Life Expectancy, 1952-2007", subtitle = "By continent and country") +
  theme(axis.text.x = element_text(angle = 45)) #<<


## ---- echo=TRUE, fig.height=3.5, dev='svg', fig.show="hold", warning=FALSE, message=FALSE----
ggplot(data = gapminder, aes(x = year, y = lifeExp, group = country)) +
  geom_line(alpha = 0.5, aes(color = "Country", size = "Country")) +
  geom_line(stat = "smooth", method = "loess", 
            aes(group = continent, color = "Continent", size = "Continent"), alpha = 0.5) +
  facet_wrap(~ continent, nrow = 2) +
  scale_color_manual(name = "Life Exp. for:", values = c("Country" = "black", "Continent" = "blue")) +
  scale_size_manual(name = "Life Exp. for:", values = c("Country" = 0.25, "Continent" = 3)) +
  theme_minimal(base_size = 14) + ylab("Years") + xlab("") + 
  ggtitle("Life Expectancy, 1952-2007", subtitle = "By continent and country") +
  theme(legend.position=c(0.82, 0.15), axis.text.x = element_text(angle = 45)) #<<


## ---- echo=FALSE, fig.height=3.5, dev='svg', message=FALSE----
ggplot(data = gapminder, aes(x = year, y = lifeExp, group = country)) +
    geom_line(alpha = 0.5, aes(color = "Country", size = "Country")) +
    geom_line(stat = "smooth", method = "loess", aes(group = continent, color = "Continent", size = "Continent"), alpha = 0.5) +
    facet_wrap(~ continent, nrow = 2) +
    scale_color_manual(name = "Life Exp. for:", values = c("Country" = "black", "Continent" = "blue")) +
    scale_size_manual(name = "Life Exp. for:", values = c("Country" = 0.25, "Continent" = 3)) +
    theme_minimal(base_size = 14) + ylab("Years") + xlab("") + ggtitle("Life Expectancy, 1952-2007", subtitle = "By continent and country") +
    theme(legend.position=c(0.82, 0.15), axis.text.x = element_text(angle = 45))


## ---- eval=FALSE---------------------------
## ggsave("I_saved_a_file.pdf", plot = lifeExp_by_year,
##        height = 3, width = 5, units = "in")

