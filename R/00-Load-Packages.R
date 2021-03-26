# https://gist.github.com/stevenworthington/3178163

ipak <- function(pkg){
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg)) 
    install.packages(new.pkg, dependencies = TRUE)
  sapply(pkg, require, character.only = TRUE)
}

ipak(c("flora",
       "devtools",
       "Rocc",
       "dplyr",
       "ENMTML"))

# From GitHub -------------------------------------------------------------

# Use this session only whether GitHub packages are not installed

devtools::install_github("liibre/Rocc")
library(Rocc)