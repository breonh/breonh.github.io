# Rendering The Slides as PDFs


pagedown::chrome_print("https://breonh.github.io/csss_508/lecture/week6/csss_508_week6_loops.html", format="pdf")



knitr::purl("week6/csss_508_week6_loops.Rmd", output = "csss_508_week6_rscript_companion.R")
