## ----setup, include=FALSE----------------------------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, dpi = 300, dev = "CairoPNG")


## ----customise report to cruise, echo=FALSE, message=FALSE-------------------------------------------------------
# Define cruise directory. If you have copied files into your R studio project directory, set mydir <- NULL (NB! If choosing this option you need to have the same folder structure in your project directory as in cruise_data)
mydir <- "//ces.hi.no/cruise_data/2020/S2020602_PKRISTINEBONNEVIE_1172"

# Define depth contours
d.contours<-c(-100,-200,-400,-500,-750,-1000) #Depth contours for plots with bathymetry

# Define the countries to show in the maps 
# (the map package uses country names from the 1980s, use: 
# regions <- map_data("worldHires")); regions[grepl("U", regions)] 
# to find country/region names starting with the letter defined in the grepl function)
regions <- c("Norway", "Sweden", "Finland", "USSR", "UK")

# Select species for distribution maps (scientific names starting with a capital letter)
species <- c("Reinhardtius hippoglossoides", "Boreogadus saida","Micromesistius poutassou", "Clupea harengus", 
             "Melanogrammus aeglefinus", "Gadus morhua", "Sebastes mentella", "Sebastes norvegicus", 
             "Sebastes viviparus", "Pandalus borealis")

# Set max size of bubbles in species distribution plots
Bubble.size<-8      

# Select metric for catches in species distribution plots (one or both)
numplot <- 0 #catches in numbers/nmi
bioplot <- 1 #catches in kg/nmi


## ----setup space between plots, echo=FALSE, message=FALSE--------------------------------------------------------
my_plot_hook <- function(x, options)
  paste("\n", knitr::hook_plot_tex(x, options), "\n")
knitr::knit_hooks$set(plot = my_plot_hook)


## ----install and load packages, echo=FALSE, message=FALSE--------------------------------------------------------
#Load required packages
Packages <- c("data.table", "reshape2", "readxl", "readODS", "worms","Cairo",
              "bookdown", "RstoxData", "maps", "mapdata", "chron","tidyverse", "ggforce", "kableExtra", "stringr")

invisible(lapply(Packages, FUN = function(x) {
    if (!require(x, character.only = TRUE)) {
      install.packages(x, dependencies = TRUE)
      library(x, character.only = TRUE)
    }
  }
))


## ----directory check, echo=FALSE, message=FALSE------------------------------------------------------------------
# Directory check - controls which parts of the script that will be run
ACO <- ifelse(is.null(mydir),dir.exists("ACOUSTIC/LSSS/REPORTS"), dir.exists(paste0(mydir,"/ACOUSTIC/LSSS/REPORTS")))
BIO <- ifelse(is.null(mydir), dir.exists("BIOLOGY/CATCH_MEASUREMENTS/BIOTIC"), dir.exists(paste0(mydir,"/BIOLOGY/CATCH_MEASUREMENTS/BIOTIC")))
CTD <- ifelse(is.null(mydir), dir.exists("PHYSICS/CTD/CTD_DATA"), dir.exists(paste0(mydir,"/PHYSICS/CTD/CTD_DATA")))
TRA <- ifelse(is.null(mydir), dir.exists("CRUISE_LOG/TRACK"), dir.exists(paste0(mydir,"/CRUISE_LOG/TRACK")))

