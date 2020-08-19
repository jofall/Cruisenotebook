## Code for plotting bird observations in Cruisenotebook (Excel version) ##
#2020-08-19

library(readxl);library(tidyverse)

#Read in the unedited bird data
dat <- paste0("Data/Bird/",list.files(path="Data/Bird", pattern = ".xlsx"))
birds <- read_excel(dat,sheet = 2,skip = 6,
                    col_types = c("date", "text",rep("numeric",7),
                                  "text", "numeric", "text", "numeric",
                                  "text", "numeric", "numeric","text", "numeric"))
#need to specify column types to avoid conversion of date to numeric
#gives a warning for duplicate column names, but automatically fixes this by adding
#a number to each column

#We want to plot information on non-ship followers in columns 1:11 - 
#the last four columns are observations of ship followers.

#fix NAs in date
for(i in 1:nrow(birds)){
  if(is.na(birds$...1[i])) birds$...1[i] <- birds$...1[i-1]
}

#..and hour of observation
for(i in 1:nrow(birds)){
  if(is.na(birds$Hrs...8[i])) birds$Hrs...8[i] <- birds$Hrs...8[i-1]
}

#read in species codes - put file "speccode.txt" in Data/Definitions folder
dat <- paste0("Data/Definitions/",list.files(path="Data/Definitions", pattern = ".txt"))
speccode <- read.table(dat,header =T, sep=";")
	
#fix hours and minutes variable to always be 2 characters long
birds.nona <- birds %>% dplyr::filter(!is.na(`Species...10`))

for(i in 1:nrow(birds.nona)){
  if(is.na(birds.nona[i,8])==FALSE){
    if(nchar(birds.nona[i,8])<2) birds.nona[i,8] <- paste0("0",birds.nona[i,8])
  }
  if(is.na(birds.nona[i,9])==FALSE){
  if(nchar(birds.nona[i,9])<2) birds.nona[i,9] <- paste0("0",birds.nona[i,9])
  }
}

#Create new time and date variables
birds.nona$Time <- paste0(birds.nona$Hrs...8, ":", birds.nona$mts...9,":00")
birds.nona$Date <- as.Date(birds.nona$...1)
birds.nona$Date <- format(birds.nona$Date, "%d-%m-%Y")

## The data only has position for when the observer goes on watch.
# need to calculate position of observations based on date and time. 
# Make position file from toktlogger:
birdpos <- dataset %>% select(Date,Time, Lat = Lat.dd, Lon = Lon.dd)

#combine with bird data
birdsdat <- birds.nona %>% 
  select(Date, Time, code = `Species...10`, Num = `Number...11`)
birdsdat <- left_join(birdsdat, birdpos)

#add the species key
birdsdat <-left_join(birdsdat, speccode)
#NB some species observed in 2020 that were not included
#in the key I got last year, needs updating.

#use the English name, but if there is none, use the Latin one
birdsdat <- birdsdat %>% mutate(usename = ifelse(is.na(Engelsk), 
                                                 as.character(Latinsk), 
                                                 as.character(Engelsk)))

#most abundant species (total abundance)
tst <- birdsdat %>% group_by(usename) %>% summarise(tot = sum(Num)) %>% arrange(-tot)
#NB NA-value in Northern gannet - check with observer

#most frequently observed species
tst2 <- birdsdat %>% group_by(usename) %>% summarise(nobs = length(Num)) %>%
  arrange(-nobs)

#species occurring in highest group numbers
tst3 <- birdsdat %>% group_by(usename) %>% summarise(minN = min(Num),
                                                     maxN = max(Num)) %>% 
  arrange(-maxN)
