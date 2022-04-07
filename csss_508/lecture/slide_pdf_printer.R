# Rendering The Slides as PDFs


pagedown::chrome_print("C:/Users/breha/OneDrive/Documents/breonh.github.io/csss_508/lecture/week2/csss_508_Week2_ggplot2.html", format="pdf")

knitr::purl("week2/csss_508_Week2_model_results.Rmd", output = "csss_508_week2_rscript_companion.R")
