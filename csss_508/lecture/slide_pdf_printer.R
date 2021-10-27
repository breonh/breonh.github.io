# Rendering The Slides as PDFs


pagedown::chrome_print("https://breonh.github.io/csss_508/lecture/week5/csss_508_week5_import_export.html", format="pdf")



knitr::purl("csss_508_week5_import_export.Rmd", output = "csss_508_week5_rscript_companion.R")
