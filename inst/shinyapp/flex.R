library(flexdashboard)
# library(FreqProf)

---
title: "Frequency Profile"
output : flexdashboard::flex_dashboard
runtime: shiny
---

Column
---------------------------------------------------------------------------------------------------------------------
```{r}
library(shiny)
# setwd("//ELGOOG/Users/admin/Documents/INTERN FOLDERS/STEPHANIE Chen/FreqProf_sc/inst/shinyapp")
    appDir <- system.file("shinyapp", package = "FreqProf", mustWork = TRUE)
#     if(appDir == "") {
#       stop("Could not find example directory. Try reinstalling `FreqProf`"
#            call. = FALSE)
#     }
# 
#     appDir <- '//ELGOOG/Users/admin/Documents/INTERN FOLDERS/STEPHANIE Chen/FreqProf_sc/inst'
    shinyAppDir(appDir= '//ELGOOG/Users/admin/Documents/INTERN FOLDERS/STEPHANIE Chen/FreqProf_sc/inst')
# #     
# #     
#     
# # include the module
# source("module.R")
#     
# # call the module
# shinyUI("frequency profile")
# callModule(shiny,"frequency profile")
```