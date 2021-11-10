# Rendering The Slides as PDFs


pagedown::chrome_print("https://breonh.github.io/csss_508/lecture/week7/csss_508_week7_vectorization.html", format="pdf")



knitr::purl("week7/csss_508_week7_vectorization.Rmd", output = "csss_508_week7_rscript_companion.R")
