# Cruisenotebook
Create a quick cruise summary report detailing the survey track, trawl catches, acoustic registrations, CTD data, and other observations during or after a cruise. Can be set up to read data direcly from the servers on board.

## Create a project and folder structure

1. Create a new R Studio project.

2. Download the cruise report script *Report.Rmd* from https://github.com/jofall/Cruisenotebook and place in project directory (or fork/download the entire repository).

3. The script requires a specific folder structure for storing the cruise data. Create these folders in the project directory:
   + Data
      + Acoustic
         + Integrated
         + Channels
      + Biotic
      + Bird
      + CTD
      + Track
      + Whale
      + Definitions
      + GeoData
   
For acoustic, biotic and track data, it is also possible to replace the folder structure with paths directly to the location of data on the server on board. This way, the files in the script with be updated automatically when you knit the file. However, CTD data cannot be read directly from the server location with this version of the script (as there are several different types of .cnv-files and the current code looks for files with this extension).

4. Download the HI logo from https://hinnsiden.no/tema/profiltorg/LOGO/HI%20logo%20farger%20engelsk.jpg and place in project directory (optional, but see information below on how to avoid an error if you do not include the logo).

## Gather data

Collect the following cruise data from the server on board:

1. Acoustic data: *ListUserFile03.txt* and *ListUserFile16.txt*. If these reports have not been created, export them from LSSS.
   + Example path to acoustic reports on Johan Hjort: //nas1-jhjort/CRUISE_DATA_*YEAR*/  
   *cruise_name*/ACOUSTIC/LSSS/REPORTS/
   + Place in "Acoustic" folder.

2. Trawl data: The *.xml* file exported from Sea2Data. 
   + Example path from Johan Hjort: //nas1-jhjort/CRUISE_DATA_*YEAR*/*cruise_name*/  
   BIOLOGY/CATCH_MEASUREMENTS/BIOTIC/
   + Place in "Biotic" folder.

3. Seabird data: Data sheet from bird observer (ods-format, if other format change code for reading in this file at line 1732 in the script) and the file *"Field sheet, Methodology, species codes NINA.xls"*. Place in folder "Birds".

4. CTD data: *ctdsort.cnv*-files (one for each CTD cast).
   + Example path from Johan Hjort: //nas1-jhjort/CRUISE_DATA_*YEAR*/*cruise_name*/  
   PHYSICS/CTD/CTD_DATA/
   + Place in "CTD" folder.

5. Definitions: These are files used for reading the biotic xlm-data. Download them from https://github.com/Sea2Data/cruisetools and place in folder "Definitions".

6. Map data: depth contours for plotting. Download the file *ETOPO1_nm4.csv* from the github repository and place in folder "GeoData".

7. Cruise track data: .csv-files (one for each day).
   + Example path from Johan Hjort:
   //nas1-jhjort/CRUISE_DATA_*YEAR*/*cruise_name*/  
   CRUISE_LOG/TRACK/
   + Place in "Track" folder.

8. Whale data: Excel-file with sightings and the *Miljø.log*-file (from either the starboard or port side) from the whale observers. Place in "Whale" folder.

NB! It is important not to place other files in these folders, as the code is based on loading files with specific file extensions.

## Change or check the following in the script to adapt the report to specific survey areas and species in the catch

Line numbers refer to the file *Report_BESS.Rmd*

1. Remove line 3 if you do not wish to have the HI logo.

2. Change title and author.

3. Check the r packages specified in the second r code chunk (lines 27-29), and install any packages you do not have on your computer.

4. Lines 44-46: specify the extent of your survey area and the depth contours you would like to show in map plots.

### Trawl data

5. Load packages by running lines 27-29 (without knitting the whole document!), then run lines 55-76. Run unique(dataset$`Station type`) and check that the gear definitions on lines 80-87 correspond to those used in your cruise. If not, change the definitions.

6. Check if you are using any other trawls than those specified at lines 499-501, if so add them/modify. Change also the gears at line 505 if necessary.

7. Lines 622-959 contain code for plotting catches of different species on a map, by gear type. For each species, two sets of plots are produced - one showing catch rates in biomass/nmi and one showing numbers/nmi. Adjust this code to match the species in your area by changing the "species <-" argument in each code chunk, and deleting/copying code chunks as necessary. The figure size can be adjusted using the "fig.width" and "fig.height" arguments at the beginning of each code chunk. In this example, this has been done for herring and shrimp, which were caught in fewer gears than the other species.

8. Lines 975-976: specify the species that you wish to plot length distributions, length-weight relationships, and length-age relationships for. Here they are divided into larger (demersal) and smaller (pelagic) species. Note that age data will not be available early in the survey, and will later only be available for species whose otholits are read on board.

9. Line 1030: This inline code summarises the total distance of scrutinized acoustic transects, accounting for the possibility of a reset in the log values, i.e., that the log reaches 10000 and then starts over from 1. No change necessary.

10. Line 1032: In this section it is possible to add screenshots from LSSS (or other images) in case you find particularly interesting or unusual echograms. The screenshot must be placed in the project directory, and the filename inserted within the brackets on line 1034. The figure width can be adjusted within the curly brackets. Remove line 1034 and the figure text at line 1036 in case you have no screenshots to add.

### Acoustic data

11. Line 1044: For acoustic plots, the maximum bubble size can be adjusted here.

12. Line 1047: Change year manually in case you are using this script to plot data from a past year, or use code on line 1048.

13. Line 1049: This script selects data from the 38 kHz frequency, which is what is normally exported from LSSS. Change here if you are looking at other frequencies.

14. Line 1062: If you want other names for the acoustic categories than the Norwegian output from LSSS, specify labels here. "Comment out" or delete lines 1066-1068 & 1204-1206 if you don't want to change the names.

15. Line 1073: Check name of survey and vessel.

16. Line 1095/1115: Specify names of pelagic/demersal acoustic categories that you want to plot on a map.

### CTD

17. Line 1376: Choose the maximum depth for plots of density and irradiance.

### Whales

20. Line 1446: If other species have been observed, specify names here. 

21. Line 1474: This line was required to clean some old entries from the file that belonged to a different cruise. "Comment out" or delete if this does not apply to your cruise.

22. Lines 1513-1543: These plots assume that you are in an area where white-beaked dolphins are much more abundant than the other species, and they therefore get their own plot. If this does not apply, the two plots can be combined into one by deleting the second block of code and removing "%>% dplyr::filter(!species == "White-beaked dolphin")" from the first plot.

### Birds

23. Lines 1645-1662: These two figures show histograms of the total number observed, by species. As some species occur in higher numbers than others, one figure shows species that are more abundant while the other shows those occuring in lower numbers. The split between the figures can be specified at line 1642.

24. The last set of figures show the spatial distribution of bird observations. These are divided into three plots based on observed numbers - low, medium, and high. The split between these three plots can be adjusted at lines 1685, 1703, and 1720 (e.g., "filter(maxN>25)").


---