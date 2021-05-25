### This program creates PDF slides and R files from the Rmd files

library(knitr)
library(here)

mypurl <- function(fn){
   purl(here(stringr::str_c(fn, ".Rmd")),
        output=here(stringr::str_c(fn, ".R")),
        documentation=2)
   
}

mypurl("Slides")

# remotes::install_github("jhelvy/xaringanBuilder")
# remotes::install_github('rstudio/chromote')
xaringanBuilder::build_pdf(
   input=here("Slides.html"),
   output_file=here("Slides.pdf"),
   partial_slides= TRUE)