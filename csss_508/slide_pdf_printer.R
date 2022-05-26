# Rendering The Slides as PDFs

render_and_print_slides <- function(week){
  week_dir     <- paste0(getwd(), "/lecture/", "week", week, "/")
  current_rmd  <- paste0(week_dir, stringr::str_subset(list.files(week_dir),
                                                       "^csss_508_week.*\\.Rmd$"))
  rmarkdown::render(current_rmd, encoding = "UTF-8")
  current_html <- stringr::str_replace(current_rmd,  "\\.Rmd",  "\\.html")
  new_pdf_file <- stringr::str_replace(current_html, "\\.html", "\\.pdf")
  new_r_script <- stringr::str_replace(current_html, "\\.html", "_companion\\.R")
  message("Slides rendered, waiting 5 seconds.")
  Sys.sleep(5)
  message("Purling slides.")
  knitr::purl(input = current_rmd, output = new_r_script, documentation = 0)
  message("Printing from Chrome.")
  pagedown::chrome_print(current_html, format="pdf")
  message(paste0("Printing complete at ", week_dir)) }


