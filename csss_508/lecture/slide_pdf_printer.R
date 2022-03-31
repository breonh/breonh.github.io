# Rendering The Slides as PDFs


pagedown::chrome_print("C:/Users/breha/OneDrive/Documents/breonh.github.io/csss_508/lecture/week1/csss_508_week1_Rstudio_and_Rmarkdown.html", format="pdf")

knitr::purl("week10/csss_508_week10_model_results.Rmd", output = "csss_508_week10_rscript_companion.R")
