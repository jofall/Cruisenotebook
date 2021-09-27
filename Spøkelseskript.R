invisible(ifelse(is.null(mydir),setwd("CRUISE_LOG/TRACK"),
                 setwd(paste0(mydir,"/CRUISE_LOG/TRACK"))))

for (i in 1:length(file_list)){
  temp_data <- data.table::fread(file_list[i], stringsAsFactors = F,header = T, skip = 2,fill = T,strip.white = FALSE) #read in files using the fread function from the data.table package
  #creating a new column that indicates which date each file comes from
  temp_data$Date <- strsplit(gsub(".csv", "", file_list[i]), "s")[[1]][2]
  temp_data$Date <- as.Date(temp_data$Date, format = "%d-%m-%Y")
  #The latitude column is in format "DDMM.MMMM N"
  #The longitude column is in format "0DDMM.MMMM E"
  #Create new columns with lon and lat in decimal degrees
  temp_data <- tidyr::separate(temp_data, Latitude, into = c("DD", "MM", "x1"),
                                             sep = c(2,9), remove = F)
  temp_data <- tidyr::separate(temp_data, Longitude, into = c("x1.lon", "DD.lon", "MM.lon", "x2.lon"),
                    sep = c(1,3,10), remove = F)
  temp_data$EW <- substr(temp_data$Longitude, nchar(temp_data$Longitude) - 1 + 1,
                         nchar(temp_data$Longitude)) 
  temp_data$DD <- as.numeric(temp_data$DD)
  temp_data$DD.lon <- as.numeric(temp_data$DD.lon)
  temp_data$MM <- as.numeric(temp_data$MM)
  temp_data$MM.lon <- as.numeric(temp_data$MM.lon)
  temp_data$Lat.dd <- temp_data$DD + temp_data$MM/60
  temp_data$Lon.dd <- temp_data$DD.lon + temp_data$MM.lon/60
  
  #modify Longitude according to E/W
  temp_data$EWF<-c(1)
  setDT(temp_data)[EW=="W", EWF:=-1]
  
  temp_data$Lon.dd <- (temp_data$DD.lon + temp_data$MM.lon/60)*temp_data$EWF
  
  temp_data <-  dplyr::rename(temp_data, gear.text = `Station type`)
  
  #for each iteration, bind the new data to the building dataset
  dataset <- rbindlist(list(dataset, temp_data), use.names = T, fill = T) 
  #arrange after date
  dataset  <- arrange(dataset, Date)
  rm(temp_data)
}
