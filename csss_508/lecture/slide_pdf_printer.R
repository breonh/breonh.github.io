# Rendering The Slides as PDFs


pagedown::chrome_print("https://breonh.github.io/csss_508/lecture/week8/csss_508_week8_strings.html", format="pdf")



knitr::purl("week8/csss_508_week8_strings.Rmd", output = "csss_508_week8_rscript_companion.R")
