# Rendering The Slides as PDFs


pagedown::chrome_print("https://breonh.github.io/csss_508/lecture/week4/csss_508_week4_data_structures.html", format="pdf")



knitr::purl("csss_508_week4_data_structures.Rmd", output = "csss_508_week4_rscript_companion.R")
