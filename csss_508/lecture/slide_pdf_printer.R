# Rendering The Slides as PDFs


pagedown::chrome_print("https://breonh.github.io/csss_508/lecture/week10/csss_508_Week10_model_results.html#1", format="pdf")



knitr::purl("week10/csss_508_week10_model_results.Rmd", output = "csss_508_week10_rscript_companion.R")
