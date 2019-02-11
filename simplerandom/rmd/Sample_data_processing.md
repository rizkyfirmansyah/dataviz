---
title: "Sample interpretation data processing"
author: "Diana Parker"
date: "March 5, 2018"
output:
  html_document: default
  pdf_document: default
  word_document: default
---

This document contains the code I used to process sample interpretation data downloaded from the LAPAN-UMD shared Google Sheets folder, and the steps I used to incorporate edits from workshop 7 & 8 into the final dataset. 





To run this code, you will need the following packages:



```r
### Packages
library(tidyverse)
library(forcats)
```


The datasets I used in this analysis were downloaded from the Google Sheets drive on March 1. The file paths and document names are listed below:

### Workshop 4 data

**LAPAN-UMD training > Sampling analysis > Workshop 4 reinterpretation > Reinterpretation by island group >**

  **Workshop4_reinterpretation_SUMATRA_with_QC_info;** 
  **Workshop4_reinterpretation_SULAWESI;**
  **Workshop4_reinterpretation_NUSA_TENGGARA;** 
  **Workshop4_reinterpretation_MALUKU;** 
  **Workshop4_reinterpretation_KALIMANTAN;** 
  **Workshop4_reinterpretation_JAVA;** 
  **Workshop4_reinterpretation_IRIAN_JAYA** 
  
*Initial validation data (workshop 4 reinterpretation folder), updated by the validation team during the July/August workshops, and finished on August 18. After the final validation workshop, I corrected data entry errors and reviewed all pixels that underwent more than three changes. For pixels with 3+ changes, additional change events were saved in the Change 4, 5, and 6 columns, which I added to the Google Sheets docs. I also added a column titled "Diana edited notes" to record notes on data entry error corrections.*

For each file above, only the **"Reinterpretation"** sheet was saved to CSV format and used in the analysis. 

### Workshop 7 data

**LAPAN-UMD training > workshop7 > Updated spreadsheet >**
**Comparison_pixels_to_check**

*Workshop 7 data includes pixels reviewed during our November workshop. During workshop 7, we reviewed pixels not consistent with the UMD 2001 primary forest map (Turubanova et al, in review) and the KLHK 1990 primary/secondary forest map.*

Individual user sheets (**Anna, Diana, Inggit, Rizky, Tatik, Yazid,** and **Zuzu**) were saved to CSV format from the **"Comparision_pixels_to_check.xlsx"** file.  

### Workshop 8 data

**Team_1_FINAL_15FEB2018_kalimantanfinal.xlsx;**
**Team_2_Final.xlsx;**
**Team_3_ZUZU.xlsx;**

*Workshop 8 data, shared by team leaders after the final quality check (not yet posted Google Sheets)*

After the final workshop, me and Rizky reviewed the Maluku pixels in the Team_2_Final file, and corrected small data entry errors. I reviewed the final dataset once more for data entry errors on March 3, and corrected additional small errors in another 10 pixels (primarily errors in the previous cloud free year column).

To read the files into R, I saved the relevant sheets into csv files in my working directory's Data folder. I also saved two files with info on which pixels met the workshop 7 & 8 review criteria, which I used to incorporate the edited files from these workshops into the full dataset. The workshop 7 list, **"Workshop7_review_list.csv"**, was created using the first 8 columns of the Full_data_set_Nov.22_version.xlsx file, available in the Workshop 7 Google Sheets folder. The workshop 8 list, **"Workshop8_review_list.csv"**, was created using notes from my Nov-Dec. review. 

I can send a zipped version of this data folder for anyone who wants to run the code on their own computers. 


## Part 1: Reading and formatting data from Workshop 4



```r
### Workshop 4 data was downloaded from the following Google Sheets folder:
### LAPAN-UMD training > 
### Sampling analysis > 
### Workshop 4 reinterpretation > 
### Reinterpretation by island group >

### Before reading in files, the reinterpretation sheets from the downloaded files were converted to .csv format

### Be sure to unhide all columns in the reinterpretation sheets before saving to .csv
### Should have one .csv file per island group; with file names corresponding to the names below

PAPUA <- read_csv("Data/Workshop4_reinterpretation_IRIAN_JAYA.csv",  col_names = TRUE, na = c("", "NA"), trim_ws = TRUE)
JAVA <- read_csv("Data/Workshop4_reinterpretation_JAVA.csv",  col_names = TRUE, na = c("", "NA"), trim_ws = TRUE)
KALIM <- read_csv("Data/Workshop4_reinterpretation_KALIMANTAN.csv",  col_names = TRUE, na = c("", "NA"), trim_ws = TRUE)
```

```
## Warning: Missing column names filled in: 'X4' [4], 'X54' [54]
```

```r
MALUK <- read_csv("Data/Workshop4_reinterpretation_MALUKU.csv",  col_names = TRUE, na = c("", "NA"), trim_ws = TRUE)
NUTEN <- read_csv("Data/Workshop4_reinterpretation_NUSA_TENGGARA.csv",  col_names = TRUE, na = c("", "NA"), trim_ws = TRUE)
SULA <- read_csv("Data/Workshop4_reinterpretation_SULAWESI.csv",  col_names = TRUE, na = c("", "NA"), trim_ws = TRUE)
```

```
## Warning: Missing column names filled in: 'X56' [56], 'X57' [57], 'X58' [58]
```

```r
SUMAT <- read_csv("Data/Workshop4_reinterpretation_SUMATRA_with_QC_info.csv",  col_names = TRUE, na = c("", "NA"), trim_ws = TRUE)
```

```
## Warning: Missing column names filled in: 'X56' [56], 'X57' [57], 'X58' [58]
```



```r
### Some of the csv files contained extra columns
### I'm removing them here since the island datasets will need the same number of columns in the same order to merge correctly

JAVA <-
  JAVA %>%
  select(-Person, -`Entry-1`)

MALUK <-
  MALUK %>%
  select(-Person, -`Entry-1`)

NUTEN <-
  NUTEN %>%
  select(-Person, -`Entry-1`)

PAPUA <-
  PAPUA %>%
  select(-Person, -`Entry-1`)

KALIM <-
  KALIM %>%
  select(-`Quality note`, -Quality, -X4, -X54)

SULA <-
  SULA %>%
  select(-Check, -`Quality note`, -Quality, -`Sample ID QC`, -`SampleID (from user join)`, -X56, -X57, -X58)

SUMAT <-
  SUMAT %>%
  select(-Check, -`SPOT data is cloudy; LULC from GE 2014`, -Quality, -`Sample ID QC`, -`SampleID (from user join)`, -X56, -X57, -X58)
```


 Each island group dataset should have 50 variables at this point, with variables in the following order:

  *"Island Group";                     "Sample ID";                        "1990 Landcover";*                  
  *"1990 sub-class";                   "First year of cloud-free data";    "1990 confidence";*                 
  *"change event? 1990-2015";          "change event conf";                "1990 notes";*                      
  *"year of change 1";                 "Prev cloud-free yr 1";             "change type 1";*                   
  *"Confidence change 1";              "notes change 1";                   "year of change 2";*                
  *"previous cloud-free year 2";       "change type 2";                    "Confidence change 2";*             
  *"notes change 2";                   "year of change 3";                 "previous cloud-free year 3";*      
  *"change type 3";                    "Confidence change 3";              "notes change 3";*                  
  *"LULC SPOT6/7";                     "Classification Notes";             "Transition Summary";*              
  *"AGREE or DISAGREE";                "SPOT image?";                      "High Res GE?";*                    
  *"More than 3 change events?";       "Confidence of final interpreter";  "User";*                            
  *"Final interpreter notes";          "Diana edited notes";               "year of change 4";*                
  *"previous cloud-free year 4";       "change type 4";                    "Confidence change 4";*             
  *"notes change 4";                   "year of change 5";                 "previous cloud-free year 5";*      
  *"change type 5";                    "Confidence change 5";              "notes change 5";*                  
  *"year of change 6";                 "previous cloud-free year 6";       "change type 6";*                   
  *"Confidence change 6";              "notes change 6"*



```r
col_names <- c("ISLAND","ID","X1990_LC",
               "X1990_SC","FY_CF","X1990_CONF",
               "CHANGE_EVENT","CHANGE_E_CONF","X1990_NOTES",
               "CH1_YR","CH1_PCF","CH1_TYPE",
               "CH1_CONF","CH1_NOTES","CH2_YR",
               "CH2_PCF","CH2_TYPE","CH2_CONF",
               "CH2_NOTES","CH3_YR","CH3_PCF",
               "CH3_TYPE","CH3_CONF","CH3_NOTES",
               "FINAL_LU","CLASS_NOTES","TRANS_SUM",
               "AGREE_DISAGREE","SPOT","HIGHRES_GE",
               "CH_3PLUS","CONF_FINAL","USER",
               "NOTES_FINAL", "D_EDITS", "CH4_YR", 
               "CH4_PCF", "CH4_TYPE", "CH4_CONF", 
               "CH4_NOTES", "CH5_YR", "CH5_PCF", 
               "CH5_TYPE", "CH5_CONF", "CH5_NOTES", 
               "CH6_YR", "CH6_PCF", "CH6_TYPE", 
               "CH6_CONF", "CH6_NOTES")

names(PAPUA) <- col_names
names(JAVA) <- col_names
names(KALIM) <- col_names
names(MALUK) <- col_names
names(NUTEN) <- col_names
names(SULA) <- col_names
names(SUMAT) <- col_names


### Combine files into a master file, Nusantara (NUSAN)

NUSAN <- rbind(PAPUA, JAVA, KALIM, MALUK, NUTEN, SULA, SUMAT)
```


## Part 2: Reading and formatting data from Workshop 7
### And incorporating pixels reviewed in Workshop 7 with the full data set



```r
### Workshop 7 data was downloaded from the following Google Sheets folder:
### LAPAN-UMD training > 
### workshop7 > 
### Updated spreadsheet >
### Comparison_pixels_to_check

### The reviewed sheets (sheets named for validation team members) 
### from the Comparison_pixels_to_check file were converted to .csv format for reading into R

### Be sure to unhide all columns in the reinterpretation sheets before saving to .csv
### Should have one .csv file per validation team member; with file names corresponding to the names below:

Anna <- read_csv("Data/Workshop7_Anna.csv", col_names = TRUE, na = c("", "NA"), trim_ws = TRUE)
Diana <- read_csv("Data/Workshop7_Diana.csv", col_names = TRUE, na = c("", "NA"), trim_ws = TRUE)
Inggit <- read_csv("Data/Workshop7_Inggit.csv", col_names = TRUE, na = c("", "NA"), trim_ws = TRUE)
Rizky <- read_csv("Data/Workshop7_Rizky.csv", col_names = TRUE, na = c("", "NA"), trim_ws = TRUE)
Tatik <- read_csv("Data/Workshop7_Tatik.csv", col_names = TRUE, na = c("", "NA"), trim_ws = TRUE)
Yazid <- read_csv("Data/Workshop7_Yazid.csv", col_names = TRUE, na = c("", "NA"), trim_ws = TRUE)
Zuzu <- read_csv("Data/Workshop7_Zuzu.csv", col_names = TRUE, na = c("", "NA"), trim_ws = TRUE)
```



```r
### Delete extra entries in Zuzu's sheet and my sheet

Zuzu <- Zuzu[1:141, ]
Diana <- Diana[1:425, ]

### Remove the "link" columns from Rizky & my sheets

Rizky <- 
  Rizky %>%
  select(-Link)

Diana <- 
  Diana %>%
  select(-`Link start`, -`Link end`)


### Also, replace the one "none" entry in Anna's change 1 year column with "NA" 
### (so it will read in as a numerical column)

Anna$`Change 1 year` <- gsub("none", "NA", Anna$`Change 1 year`, ignore.case=T)

### Now bind the user data sets together

All_edits <- rbind(Anna, Diana, Inggit, Rizky, Tatik, Yazid, Zuzu)
```


After reading in the data from workshop 4 and workshop 7, I'll merge the un-edited data from workshop 4 (pixels from NUSAN that weren't part of the workshop 7 review) with the reviewed workshop 7 data, which is stored stored in All_edits. 

To extract the pixels from NUSAN that weren't reviewed, I will use the *Workshop7_review_list.csv* file. 



```r
### Info on whether a pixel was included in the workshop 7 review is included in the "DISAGREEMENTS" column 
### in the Workshop7_review_list csv file
### this file contains the first 8 columns of the Full_data_Nov.22_version Google Sheets sheets (workshop 7 folder)

W7_review_list <- read_csv("Data/Workshop7_review_list.csv", col_names = TRUE, na = c("", "NA"), trim_ws = TRUE)

### We only need the following columns:

W7_review_list <-
  W7_review_list %>%
  select(ID, Editor, COMPARE_KLHK_1990, COMPARE_UMD_2001, 
         DISAGREEMENTS, DISAG_EDITS = `DISAGREEMENT EDITS`, DISAG_NOTES = `DISAGREEMENT NOTES`)

### Next join the review list dataset to NUSAN and subset by the DISAGREEMENTS column
### Pixels with the DISAGREEMENTS value "NONE" did not meet the workshop 7 review criteria

Pre_no_disag <- 
  left_join(NUSAN, W7_review_list) %>%
  subset(DISAGREEMENTS == "NONE")
```


I'll create an updated version of NUSAN by merging Pre_no_disag (pixels not reviewed in workshop 7) with All_edits. Before merging, I will also need to reorder and rename the variable columns so the column namees and orders match for both files. 



```r
### List the columns to select in the NUSAN_COLUMNS object

NUSAN_COLUMNS <- c("ISLAND", "ID", "X1990_LC", "X1990_CONF", "X1990_NOTES",
                   "CH1_YR", "CH1_PCF", "CH1_TYPE", "CH1_CONF", "CH1_NOTES",
                   "CH2_YR", "CH2_PCF", "CH2_TYPE", "CH2_CONF", "CH2_NOTES",
                   "CH3_YR", "CH3_PCF", "CH3_TYPE", "CH3_CONF", "CH3_NOTES",
                   "CH4_YR", "CH4_PCF", "CH4_TYPE", "CH4_CONF", "CH4_NOTES",
                   "CH5_YR", "CH5_PCF", "CH5_TYPE", "CH5_CONF", "CH5_NOTES",
                   "CH6_YR", "CH6_PCF", "CH6_TYPE", "CH6_CONF", "CH6_NOTES",
                   "KLHK_LU", "FY_CF", "SPOT", "HIGHRES_GE", "USER",
                   "AGREE_DISAGREE", "CONF_FINAL", "CLASS_NOTES", "NOTES_FINAL",
                   "CHANGE_E_CONF", "Editor", "DISAG_EDITS", "DISAG_NOTES")


### Rename columns whose names don't match the list above
### Then select only columns included in the NUSAN_COLUMNS list

Pre_no_disag <-
  Pre_no_disag %>%
  rename(KLHK_LU = FINAL_LU) %>%
  select(NUSAN_COLUMNS)

### Now reorder, rename, and select the relevant columns in All_edits

All_edits <-
	All_edits %>%
  rename(X1990_LC = `1990 land cover`,
	       CH1_YR = `Change 1 year`, 
         CH1_PCF = `Change 1 previous cloud free year`, 
	       CH1_TYPE = `Change 1 type`, 
         CH1_CONF = `Change 1 confidence`, 
	       CH2_YR = `Change 2 year`, 
         CH2_PCF = `Change 2 previous cloud free year`,
	       CH2_TYPE = `Change 2 type`, 
         CH2_CONF = `Change 2 confidence`, 
	       CH3_YR = `Change 3 year`, 
         CH3_PCF = `Change 3 previous cloud free year`, 
	       CH3_TYPE = `Change 3 type`, 
         CH3_CONF = `Change 3 confidence`, 
	       CH4_YR = `Change 4 year`, 
         CH4_PCF = `Change 4 previous cloud free year`, 
	       CH4_TYPE = `Change 4 type`, 
         CH4_CONF = `Change 4 confidence`, 
	       CH5_YR = `Change 5 year`, 
         CH5_PCF = `Change 5 previous cloud free`, 
	       CH5_TYPE = `Change 5 type`, 
         CH5_CONF = `Change 5 confidence`, 
	       CH6_YR = `Change 6 year`, 
         CH6_PCF = `Change 6 previous cloud free`, 
	       CH6_TYPE = `Change 6 type`, 
         CH6_CONF = `Change 6 confidence`, 
	       KLHK_LU = `Final land use KLHK`, 
         DISAG_EDITS = `NEW EDITS`, 
         DISAG_NOTES = `DISAGREEMENT NOTES`) %>%
  select(NUSAN_COLUMNS)
	       
### All_edits and Pre_no_disag should now have the same number of columns in the same order and with the same column names
### This allows us to correctly merge the two datasets using rbind

NUSAN <- rbind(All_edits, Pre_no_disag)
```


I can test that this has been done correctly by checking the number of unique values in the ID column. If rbind worked correctly, NUSAN$ID should have 10,000 unique values, with a min of 1 and a max of 10,000.



```r
NUSAN$ID <- parse_integer(NUSAN$ID, na = c("NA"))

length(unique(NUSAN$ID))
```

```
## [1] 10000
```

```r
summary(NUSAN$ID)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##       1    2501    5000    5000    7500   10000
```


## Part 3: Reading and formatting data from Workshop 7
### And incorporating pixels reviewed in Workshop 8 with the full data set



```r
Team_1_final <- read_csv("Data/Workshop8_Team_1_FINAL.csv", col_names = TRUE, na = c("", "NA"), trim_ws = TRUE)
Team_2_final <- read_csv("Data/Workshop8_Team_2_FINAL.csv", col_names = TRUE, na = c("", "NA"), trim_ws = TRUE)
Team_3_final <- read_csv("Data/Workshop8_Team_3_FINAL.csv", col_names = TRUE, na = c("", "NA"), trim_ws = TRUE)

### Filter by the islands reviewed by each team
### Team 1 reviewed all the island groups in its csv file except Papua
### Team 2 reviewed all the island groups in its CSV file except Java & Nusa Tenggara
### The team 3 file contained only the island groups reviewed by team 3 - Papua, Java, and Nusa Tenggara

Team_1_final <- 
  Team_1_final %>%
  filter(ISLAND != "Irian_Jaya")

Team_2_final <- 
  Team_2_final %>%
  filter(ISLAND != "Jawa" & ISLAND != "Nusa_Tenggara")
```



```r
### Select, reorder and rename relevant column names

Team_1_final <- 
  Team_1_final %>%  
  rename(KLHK_LU = FINAL_LU, 
         DISAG_EDITS = DISAGREEMENT_EDITS, 
         DISAG_NOTES = DISAGREEMENT_NOTES, 
         D_REVIEW_NOTES = NOTES) %>%  
  select(NUSAN_COLUMNS, Checked, D_REVIEW_NOTES)

Team_2_final <- 
  Team_2_final %>%  
  rename(KLHK_LU = FINAL_LU, 
         DISAG_EDITS = DISAGREEMENT_EDITS, 
         DISAG_NOTES = DISAGREEMENT_NOTES, 
         D_REVIEW_NOTES = NOTES) %>%  
  select(NUSAN_COLUMNS, Checked, D_REVIEW_NOTES)

Team_3_final <- 
  Team_3_final %>%  
  rename(KLHK_LU = FINAL_LU, 
         DISAG_EDITS = DISAGREEMENT_EDITS, 
         DISAG_NOTES = DISAGREEMENT_NOTES, 
         D_REVIEW_NOTES = NOTES) %>%  
  select(NUSAN_COLUMNS, Checked, D_REVIEW_NOTES)
```



```r
### Merge each team's review data into a single spreadsheet using rbind

Feb_reviewed_final <- rbind(Team_1_final, Team_2_final, Team_3_final)
```



```r
### To pixels not part of the February review from the NUSAN dataset
### I'll need to read in dataset with the Checked and D_REVIEW_NOTES columns for each pixel ID
### This can be found in "Workshop8_review_list.csv"

W8_review <- read_csv("Data/Workshop8_review_list.csv")

### Convert NA values to "Not checked"
W8_review$Checked[is.na(W8_review$Checked)] <- 0
W8_review$Checked <- gsub(0, "Not checked", W8_review$Checked, ignore.case=T)

NUSAN <- left_join(NUSAN, W8_review)

### Filter for pixels not part of the February review
### Or all pixels  with "Agree" or "Not checked" in the checked column (not "UNSURE" or "Recommend change")
### Then select, reorder and rename relevant column names so they match the column names/order of the Feb_reviewed_final dataframe

NUSAN_not_reviewed <- 
  NUSAN %>%  
  filter(Checked != "Unsure" & Checked != "Recommend change") %>%  
  select(NUSAN_COLUMNS, Checked, D_REVIEW_NOTES)
```



```r
NUSAN <- rbind(NUSAN_not_reviewed, Feb_reviewed_final)

length(unique(NUSAN$ID))
```

```
## [1] 10000
```

```r
summary(NUSAN$ID)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##       1    2501    5000    5000    7500   10000
```


## Part 4: Preparing data for easier R processing


Now that the data set includes edits from both workshops, I will format the NUSAN dataframe for processing in R and will calculate new analysis variables, including final land use (FINAL_LU_UMD) and the first year/type of clearing (CLEAR_YR_FIRST/CLEAR_TYPE_FIRST).

Much of the code below deals with correcting small inconsistencies in the way categorical data was entered, so that I can convert the categorical variables (change types, etc.) to factors. This is not terribly important for analyzing the data in Excel, but it is important for analyzing the data in R, including for calculating the CLEAR_YR_FIRST and CLEAR_TYPE_FIRST columns. 


### Setting numeric data columns as integers



```r
### First, substitute NAs for 0s in the numeric columns
### I'll also use gsub here to replace any non-standard entries

NUSAN$CH1_PCF <- gsub("-", 0, NUSAN$CH1_PCF, ignore.case=T)

NUSAN$CH1_YR[is.na(NUSAN$CH1_YR)] <- 0
NUSAN$CH2_YR[is.na(NUSAN$CH2_YR)] <- 0
NUSAN$CH3_YR[is.na(NUSAN$CH3_YR)] <- 0
NUSAN$CH4_YR[is.na(NUSAN$CH4_YR)] <- 0
NUSAN$CH5_YR[is.na(NUSAN$CH5_YR)] <- 0
NUSAN$CH6_YR[is.na(NUSAN$CH6_YR)] <- 0

NUSAN$CH1_PCF[is.na(NUSAN$CH1_PCF)] <- 0
NUSAN$CH2_PCF[is.na(NUSAN$CH2_PCF)] <- 0
NUSAN$CH3_PCF[is.na(NUSAN$CH3_PCF)] <- 0
NUSAN$CH4_PCF[is.na(NUSAN$CH4_PCF)] <- 0
NUSAN$CH5_PCF[is.na(NUSAN$CH5_PCF)] <- 0
NUSAN$CH6_PCF[is.na(NUSAN$CH6_PCF)] <- 0
```



```r
### Now I will parse the numeric columns as integers 

NUSAN$ID <- parse_integer(NUSAN$ID, na = c("NA"))

NUSAN$CH1_YR <- parse_integer(NUSAN$CH1_YR, na = c("NA"))
NUSAN$CH2_YR <- parse_integer(NUSAN$CH2_YR, na = c("NA"))
NUSAN$CH3_YR <- parse_integer(NUSAN$CH3_YR, na = c("NA"))
NUSAN$CH4_YR <- parse_integer(NUSAN$CH4_YR, na = c("NA"))
NUSAN$CH5_YR <- parse_integer(NUSAN$CH5_YR, na = c("NA"))
NUSAN$CH6_YR <- parse_integer(NUSAN$CH6_YR, na = c("NA"))

NUSAN$CH1_PCF <- parse_integer(NUSAN$CH1_PCF, na = c("NA"))
NUSAN$CH2_PCF <- parse_integer(NUSAN$CH2_PCF, na = c("NA"))
NUSAN$CH3_PCF <- parse_integer(NUSAN$CH3_PCF, na = c("NA"))
NUSAN$CH4_PCF <- parse_integer(NUSAN$CH4_PCF, na = c("NA"))
NUSAN$CH5_PCF <- parse_integer(NUSAN$CH5_PCF, na = c("NA"))
NUSAN$CH6_PCF <- parse_integer(NUSAN$CH6_PCF, na = c("NA"))

NUSAN$FY_CF <- parse_integer(NUSAN$FY_CF, na = c("NA"))
```


### Setting categorical data columns as factors

Next, I will format the character columns as factors and replace any non-standard entries with the correct text



```r
Case_sync <- function(factor, data_column) {
  gsub(factor, factor, data_column, ignore.case = T)
}

Non_standard_replace <- function(incorrect, correct, data_column) {
  gsub(incorrect, correct, data_column, ignore.case = T)
}
```



```r
NUSAN$ISLAND <- Non_standard_replace("Irian Jaya", "Irian_Jaya", NUSAN$ISLAND)
NUSAN$ISLAND <- Non_standard_replace("Nusa Tenggara", "Nusa_Tenggara", NUSAN$ISLAND)

levels_ISLAND <- c("Irian_Jaya", 
                   "Jawa",
                   "Kalimantan",
                   "Maluku",
                   "Nusa_Tenggara",
                   "Sulawesi",
                   "Sumatera")

### The island column has 7 levels (island group names), so I will need to standardize the letter cases for each level
### I will do this by referencing each name (1-7) in the levels_ISLAND vector

NUSAN$ISLAND <- Case_sync(levels_ISLAND[1], NUSAN$ISLAND)
NUSAN$ISLAND <- Case_sync(levels_ISLAND[2], NUSAN$ISLAND)
NUSAN$ISLAND <- Case_sync(levels_ISLAND[3], NUSAN$ISLAND)
NUSAN$ISLAND <- Case_sync(levels_ISLAND[4], NUSAN$ISLAND)
NUSAN$ISLAND <- Case_sync(levels_ISLAND[5], NUSAN$ISLAND)
NUSAN$ISLAND <- Case_sync(levels_ISLAND[6], NUSAN$ISLAND)
NUSAN$ISLAND <- Case_sync(levels_ISLAND[7], NUSAN$ISLAND)

### Now I can parse the ISLAND column as a factor; there should be no parsing errors

NUSAN$ISLAND <- parse_factor(NUSAN$ISLAND, levels_ISLAND, ordered = FALSE, na = c("NA"), include_na = TRUE)
```



```r
### this column should have no irregular entries, so I'll just need to standardize the cases

levels_1990 <- c("Primary intact", 
                 "Primary degraded", 
                 "Non forest")

NUSAN$X1990_LC <- Case_sync(levels_1990[1], NUSAN$X1990_LC)
NUSAN$X1990_LC <- Case_sync(levels_1990[2], NUSAN$X1990_LC)
NUSAN$X1990_LC <- Case_sync(levels_1990[3], NUSAN$X1990_LC)

NUSAN$X1990_LC <- parse_factor(NUSAN$X1990_LC, levels_1990, ordered = FALSE, na = c("NA"), include_na = TRUE)
```



```r
### The change type columns have 6 non-standard entries:
### "Cleared - Abandoned/transitional", "Cleared - Palm estates", "Cleared - Small-holder land use", 
### "Cleared - Tree plantations", "Cleared - Roading", "Cleared - Road", "Degraded - Peatland draining nearby"

### These will need to be updated in each change type column

NUSAN$CH1_TYPE <- Non_standard_replace("Cleared - Abandoned/transitional", "Cleared - Abandoned", NUSAN$CH1_TYPE)
NUSAN$CH1_TYPE <- Non_standard_replace("Cleared - Palm estates", "Cleared - Palm estate", NUSAN$CH1_TYPE)
NUSAN$CH1_TYPE <- Non_standard_replace("Cleared - Small-holder land use", "Cleared - Smallholder", NUSAN$CH1_TYPE)
NUSAN$CH1_TYPE <- Non_standard_replace("Cleared - Tree plantations", "Cleared - Tree plantation", NUSAN$CH1_TYPE)
NUSAN$CH1_TYPE <- Non_standard_replace("Cleared - Roading", "Cleared - Road", NUSAN$CH1_TYPE)
NUSAN$CH1_TYPE <- Non_standard_replace("Degraded - Peatland draining nearby", "Degraded - Peatland draining", NUSAN$CH1_TYPE)

NUSAN$CH2_TYPE <- Non_standard_replace("Cleared - Abandoned/transitional", "Cleared - Abandoned", NUSAN$CH2_TYPE)
NUSAN$CH2_TYPE <- Non_standard_replace("Cleared - Palm estates", "Cleared - Palm estate", NUSAN$CH2_TYPE)
NUSAN$CH2_TYPE <- Non_standard_replace("Cleared - Small-holder land use", "Cleared - Smallholder", NUSAN$CH2_TYPE)
NUSAN$CH2_TYPE <- Non_standard_replace("Cleared - Tree plantations", "Cleared - Tree plantation", NUSAN$CH2_TYPE)
NUSAN$CH2_TYPE <- Non_standard_replace("Cleared - Roading", "Cleared - Road", NUSAN$CH2_TYPE)
NUSAN$CH2_TYPE <- Non_standard_replace("Degraded - Peatland draining nearby", "Degraded - Peatland draining", NUSAN$CH2_TYPE)

NUSAN$CH3_TYPE <- Non_standard_replace("Cleared - Abandoned/transitional", "Cleared - Abandoned", NUSAN$CH3_TYPE)
NUSAN$CH3_TYPE <- Non_standard_replace("Cleared - Palm estates", "Cleared - Palm estate", NUSAN$CH3_TYPE)
NUSAN$CH3_TYPE <- Non_standard_replace("Cleared - Small-holder land use", "Cleared - Smallholder", NUSAN$CH3_TYPE)
NUSAN$CH3_TYPE <- Non_standard_replace("Cleared - Tree plantations", "Cleared - Tree plantation", NUSAN$CH3_TYPE)
NUSAN$CH3_TYPE <- Non_standard_replace("Cleared - Roading", "Cleared - Road", NUSAN$CH3_TYPE)
NUSAN$CH3_TYPE <- Non_standard_replace("Degraded - Peatland draining nearby", "Degraded - Peatland draining", NUSAN$CH3_TYPE)

NUSAN$CH4_TYPE <- Non_standard_replace("Cleared - Abandoned/transitional", "Cleared - Abandoned", NUSAN$CH4_TYPE)
NUSAN$CH4_TYPE <- Non_standard_replace("Cleared - Palm estates", "Cleared - Palm estate", NUSAN$CH4_TYPE)
NUSAN$CH4_TYPE <- Non_standard_replace("Cleared - Small-holder land use", "Cleared - Smallholder", NUSAN$CH4_TYPE)
NUSAN$CH4_TYPE <- Non_standard_replace("Cleared - Tree plantations", "Cleared - Tree plantation", NUSAN$CH4_TYPE)
NUSAN$CH4_TYPE <- Non_standard_replace("Cleared - Roading", "Cleared - Road", NUSAN$CH4_TYPE)
NUSAN$CH4_TYPE <- Non_standard_replace("Degraded - Peatland draining nearby", "Degraded - Peatland draining", NUSAN$CH4_TYPE)

NUSAN$CH5_TYPE <- Non_standard_replace("Cleared - Abandoned/transitional", "Cleared - Abandoned", NUSAN$CH5_TYPE)
NUSAN$CH5_TYPE <- Non_standard_replace("Cleared - Palm estates", "Cleared - Palm estate", NUSAN$CH5_TYPE)
NUSAN$CH5_TYPE <- Non_standard_replace("Cleared - Small-holder land use", "Cleared - Smallholder", NUSAN$CH5_TYPE)
NUSAN$CH5_TYPE <- Non_standard_replace("Cleared - Tree plantations", "Cleared - Tree plantation", NUSAN$CH5_TYPE)
NUSAN$CH5_TYPE <- Non_standard_replace("Cleared - Roading", "Cleared - Road", NUSAN$CH5_TYPE)
NUSAN$CH5_TYPE <- Non_standard_replace("Degraded - Peatland draining nearby", "Degraded - Peatland draining", NUSAN$CH5_TYPE)

NUSAN$CH6_TYPE <- Non_standard_replace("Cleared - Abandoned/transitional", "Cleared - Abandoned", NUSAN$CH6_TYPE)
NUSAN$CH6_TYPE <- Non_standard_replace("Cleared - Palm estates", "Cleared - Palm estate", NUSAN$CH6_TYPE)
NUSAN$CH6_TYPE <- Non_standard_replace("Cleared - Small-holder land use", "Cleared - Smallholder", NUSAN$CH6_TYPE)
NUSAN$CH6_TYPE <- Non_standard_replace("Cleared - Tree plantations", "Cleared - Tree plantation", NUSAN$CH6_TYPE)
NUSAN$CH6_TYPE <- Non_standard_replace("Cleared - Roading", "Cleared - Road", NUSAN$CH6_TYPE)
NUSAN$CH6_TYPE <- Non_standard_replace("Degraded - Peatland draining nearby", "Degraded - Peatland draining", NUSAN$CH6_TYPE)
```



```r
### 0's also need to be replaced with NAs
### to allow the columns to be parsed correctly as factors

NUSAN$CH1_TYPE <- Non_standard_replace("0", "NA" ,NUSAN$CH1_TYPE)
NUSAN$CH2_TYPE <- Non_standard_replace("0", "NA" ,NUSAN$CH2_TYPE)
NUSAN$CH3_TYPE <- Non_standard_replace("0", "NA" ,NUSAN$CH3_TYPE)
NUSAN$CH4_TYPE <- Non_standard_replace("0", "NA" ,NUSAN$CH4_TYPE)
NUSAN$CH5_TYPE <- Non_standard_replace("0", "NA" ,NUSAN$CH5_TYPE)
NUSAN$CH6_TYPE <- Non_standard_replace("0", "NA" ,NUSAN$CH6_TYPE)
```



```r
levels_change <- c("Cleared - Abandoned", 
                   "Cleared - Palm estate", 
                   "Cleared - Smallholder", 
                   "Cleared - Tree plantation", 
                   "Cleared - Fire", 
                   "Cleared - Road", 
                   "Cleared - Settlement", 
                   "Cleared - Rubber", 
                   "Cleared - Mining", 
                   "Cleared - Other", 
                   "Degraded - Fire", 
                   "Degraded - Selective logging", 
                   "Degraded - Nearby clearing", 
                   "Degraded - Natural disturbance", 
                   "Degraded - Peatland draining")

### The change columns have 15 levels (change types), so I will need to standardize the letter cases for each level, for each change type column
### I will do this by referencing each type (1-15) in the CH1-CH6_TYPE columns

NUSAN$CH1_TYPE <- Case_sync(levels_change[1], NUSAN$CH1_TYPE)
NUSAN$CH1_TYPE <- Case_sync(levels_change[2], NUSAN$CH1_TYPE)
NUSAN$CH1_TYPE <- Case_sync(levels_change[3], NUSAN$CH1_TYPE)
NUSAN$CH1_TYPE <- Case_sync(levels_change[4], NUSAN$CH1_TYPE)
NUSAN$CH1_TYPE <- Case_sync(levels_change[5], NUSAN$CH1_TYPE)
NUSAN$CH1_TYPE <- Case_sync(levels_change[6], NUSAN$CH1_TYPE)
NUSAN$CH1_TYPE <- Case_sync(levels_change[7], NUSAN$CH1_TYPE)
NUSAN$CH1_TYPE <- Case_sync(levels_change[8], NUSAN$CH1_TYPE)
NUSAN$CH1_TYPE <- Case_sync(levels_change[10], NUSAN$CH1_TYPE)
NUSAN$CH1_TYPE <- Case_sync(levels_change[11], NUSAN$CH1_TYPE)
NUSAN$CH1_TYPE <- Case_sync(levels_change[12], NUSAN$CH1_TYPE)
NUSAN$CH1_TYPE <- Case_sync(levels_change[13], NUSAN$CH1_TYPE)
NUSAN$CH1_TYPE <- Case_sync(levels_change[14], NUSAN$CH1_TYPE)
NUSAN$CH1_TYPE <- Case_sync(levels_change[15], NUSAN$CH1_TYPE)

NUSAN$CH2_TYPE <- Case_sync(levels_change[1], NUSAN$CH2_TYPE)
NUSAN$CH2_TYPE <- Case_sync(levels_change[2], NUSAN$CH2_TYPE)
NUSAN$CH2_TYPE <- Case_sync(levels_change[3], NUSAN$CH2_TYPE)
NUSAN$CH2_TYPE <- Case_sync(levels_change[4], NUSAN$CH2_TYPE)
NUSAN$CH2_TYPE <- Case_sync(levels_change[5], NUSAN$CH2_TYPE)
NUSAN$CH2_TYPE <- Case_sync(levels_change[6], NUSAN$CH2_TYPE)
NUSAN$CH2_TYPE <- Case_sync(levels_change[7], NUSAN$CH2_TYPE)
NUSAN$CH2_TYPE <- Case_sync(levels_change[8], NUSAN$CH2_TYPE)
NUSAN$CH2_TYPE <- Case_sync(levels_change[10], NUSAN$CH2_TYPE)
NUSAN$CH2_TYPE <- Case_sync(levels_change[11], NUSAN$CH2_TYPE)
NUSAN$CH2_TYPE <- Case_sync(levels_change[12], NUSAN$CH2_TYPE)
NUSAN$CH2_TYPE <- Case_sync(levels_change[13], NUSAN$CH2_TYPE)
NUSAN$CH2_TYPE <- Case_sync(levels_change[14], NUSAN$CH2_TYPE)
NUSAN$CH2_TYPE <- Case_sync(levels_change[15], NUSAN$CH2_TYPE)

NUSAN$CH3_TYPE <- Case_sync(levels_change[1], NUSAN$CH3_TYPE)
NUSAN$CH3_TYPE <- Case_sync(levels_change[2], NUSAN$CH3_TYPE)
NUSAN$CH3_TYPE <- Case_sync(levels_change[3], NUSAN$CH3_TYPE)
NUSAN$CH3_TYPE <- Case_sync(levels_change[4], NUSAN$CH3_TYPE)
NUSAN$CH3_TYPE <- Case_sync(levels_change[5], NUSAN$CH3_TYPE)
NUSAN$CH3_TYPE <- Case_sync(levels_change[6], NUSAN$CH3_TYPE)
NUSAN$CH3_TYPE <- Case_sync(levels_change[7], NUSAN$CH3_TYPE)
NUSAN$CH3_TYPE <- Case_sync(levels_change[8], NUSAN$CH3_TYPE)
NUSAN$CH3_TYPE <- Case_sync(levels_change[10], NUSAN$CH3_TYPE)
NUSAN$CH3_TYPE <- Case_sync(levels_change[11], NUSAN$CH3_TYPE)
NUSAN$CH3_TYPE <- Case_sync(levels_change[12], NUSAN$CH3_TYPE)
NUSAN$CH3_TYPE <- Case_sync(levels_change[13], NUSAN$CH3_TYPE)
NUSAN$CH3_TYPE <- Case_sync(levels_change[14], NUSAN$CH3_TYPE)
NUSAN$CH3_TYPE <- Case_sync(levels_change[15], NUSAN$CH3_TYPE)

NUSAN$CH4_TYPE <- Case_sync(levels_change[1], NUSAN$CH4_TYPE)
NUSAN$CH4_TYPE <- Case_sync(levels_change[2], NUSAN$CH4_TYPE)
NUSAN$CH4_TYPE <- Case_sync(levels_change[3], NUSAN$CH4_TYPE)
NUSAN$CH4_TYPE <- Case_sync(levels_change[4], NUSAN$CH4_TYPE)
NUSAN$CH4_TYPE <- Case_sync(levels_change[5], NUSAN$CH4_TYPE)
NUSAN$CH4_TYPE <- Case_sync(levels_change[6], NUSAN$CH4_TYPE)
NUSAN$CH4_TYPE <- Case_sync(levels_change[7], NUSAN$CH4_TYPE)
NUSAN$CH4_TYPE <- Case_sync(levels_change[8], NUSAN$CH4_TYPE)
NUSAN$CH4_TYPE <- Case_sync(levels_change[10], NUSAN$CH4_TYPE)
NUSAN$CH4_TYPE <- Case_sync(levels_change[11], NUSAN$CH4_TYPE)
NUSAN$CH4_TYPE <- Case_sync(levels_change[12], NUSAN$CH4_TYPE)
NUSAN$CH4_TYPE <- Case_sync(levels_change[13], NUSAN$CH4_TYPE)
NUSAN$CH4_TYPE <- Case_sync(levels_change[14], NUSAN$CH4_TYPE)
NUSAN$CH4_TYPE <- Case_sync(levels_change[15], NUSAN$CH4_TYPE)

NUSAN$CH5_TYPE <- Case_sync(levels_change[1], NUSAN$CH5_TYPE)
NUSAN$CH5_TYPE <- Case_sync(levels_change[2], NUSAN$CH5_TYPE)
NUSAN$CH5_TYPE <- Case_sync(levels_change[3], NUSAN$CH5_TYPE)
NUSAN$CH5_TYPE <- Case_sync(levels_change[4], NUSAN$CH5_TYPE)
NUSAN$CH5_TYPE <- Case_sync(levels_change[5], NUSAN$CH5_TYPE)
NUSAN$CH5_TYPE <- Case_sync(levels_change[6], NUSAN$CH5_TYPE)
NUSAN$CH5_TYPE <- Case_sync(levels_change[7], NUSAN$CH5_TYPE)
NUSAN$CH5_TYPE <- Case_sync(levels_change[8], NUSAN$CH5_TYPE)
NUSAN$CH5_TYPE <- Case_sync(levels_change[10], NUSAN$CH5_TYPE)
NUSAN$CH5_TYPE <- Case_sync(levels_change[11], NUSAN$CH5_TYPE)
NUSAN$CH5_TYPE <- Case_sync(levels_change[12], NUSAN$CH5_TYPE)
NUSAN$CH5_TYPE <- Case_sync(levels_change[13], NUSAN$CH5_TYPE)
NUSAN$CH5_TYPE <- Case_sync(levels_change[14], NUSAN$CH5_TYPE)
NUSAN$CH5_TYPE <- Case_sync(levels_change[15], NUSAN$CH5_TYPE)

NUSAN$CH6_TYPE <- Case_sync(levels_change[1], NUSAN$CH6_TYPE)
NUSAN$CH6_TYPE <- Case_sync(levels_change[2], NUSAN$CH6_TYPE)
NUSAN$CH6_TYPE <- Case_sync(levels_change[3], NUSAN$CH6_TYPE)
NUSAN$CH6_TYPE <- Case_sync(levels_change[4], NUSAN$CH6_TYPE)
NUSAN$CH6_TYPE <- Case_sync(levels_change[5], NUSAN$CH6_TYPE)
NUSAN$CH6_TYPE <- Case_sync(levels_change[6], NUSAN$CH6_TYPE)
NUSAN$CH6_TYPE <- Case_sync(levels_change[7], NUSAN$CH6_TYPE)
NUSAN$CH6_TYPE <- Case_sync(levels_change[8], NUSAN$CH6_TYPE)
NUSAN$CH6_TYPE <- Case_sync(levels_change[10], NUSAN$CH6_TYPE)
NUSAN$CH6_TYPE <- Case_sync(levels_change[11], NUSAN$CH6_TYPE)
NUSAN$CH6_TYPE <- Case_sync(levels_change[12], NUSAN$CH6_TYPE)
NUSAN$CH6_TYPE <- Case_sync(levels_change[13], NUSAN$CH6_TYPE)
NUSAN$CH6_TYPE <- Case_sync(levels_change[14], NUSAN$CH6_TYPE)
NUSAN$CH6_TYPE <- Case_sync(levels_change[15], NUSAN$CH6_TYPE)
```



```r
### Now I can parse the change type columns as factors; there should be no parsing errors

NUSAN$CH1_TYPE <- parse_factor(NUSAN$CH1_TYPE, levels_change, ordered = FALSE, na = c("NA"), include_na = TRUE)
NUSAN$CH2_TYPE <- parse_factor(NUSAN$CH2_TYPE, levels_change, ordered = FALSE, na = c("NA"), include_na = TRUE)
NUSAN$CH3_TYPE <- parse_factor(NUSAN$CH3_TYPE, levels_change, ordered = FALSE, na = c("NA"), include_na = TRUE)
NUSAN$CH4_TYPE <- parse_factor(NUSAN$CH4_TYPE, levels_change, ordered = FALSE, na = c("NA"), include_na = TRUE)
NUSAN$CH5_TYPE <- parse_factor(NUSAN$CH5_TYPE, levels_change, ordered = FALSE, na = c("NA"), include_na = TRUE)
NUSAN$CH6_TYPE <- parse_factor(NUSAN$CH6_TYPE, levels_change, ordered = FALSE, na = c("NA"), include_na = TRUE)
```



```r
levels_KLHK <- c("Air",
                 "Awan",
                 "Bandara",
                 "Belukar",
                 "Belukar Rawa",
                 "Hutan Mangrove",
                 "Hutan Mangrove Sekunder",
                 "Hutan Primer",
                 "Hutan Rawa Primer",
                 "Hutan Rawa Sekunder",
                 "Hutan Sekunder",
                 "Hutan Tanaman",
                 "Lahan Terbuka",
                 "Pemukiman",
                 "Perkebunan",
                 "Pertambangan",
                 "Pertanian Lahan Kering",
                 "Pertanian Lahan Kering Campur Semak",
                 "Rawa",
                 "Savana",
                 "Sawah",
                 "Tambak",
                 "Transmigrasi")

### The KLHK column has 23 levels (land use types), so I will need to standardize the letter cases for each level
### I will do this by referencing each type (1-23) in the KLHK column

NUSAN$KLHK_LU <- Case_sync(levels_KLHK[1], NUSAN$KLHK_LU)
NUSAN$KLHK_LU <- Case_sync(levels_KLHK[2], NUSAN$KLHK_LU)
NUSAN$KLHK_LU <- Case_sync(levels_KLHK[3], NUSAN$KLHK_LU)
NUSAN$KLHK_LU <- Case_sync(levels_KLHK[4], NUSAN$KLHK_LU)
NUSAN$KLHK_LU <- Case_sync(levels_KLHK[5], NUSAN$KLHK_LU)
NUSAN$KLHK_LU <- Case_sync(levels_KLHK[6], NUSAN$KLHK_LU)
NUSAN$KLHK_LU <- Case_sync(levels_KLHK[7], NUSAN$KLHK_LU)
NUSAN$KLHK_LU <- Case_sync(levels_KLHK[8], NUSAN$KLHK_LU)
NUSAN$KLHK_LU <- Case_sync(levels_KLHK[10], NUSAN$KLHK_LU)
NUSAN$KLHK_LU <- Case_sync(levels_KLHK[11], NUSAN$KLHK_LU)
NUSAN$KLHK_LU <- Case_sync(levels_KLHK[12], NUSAN$KLHK_LU)
NUSAN$KLHK_LU <- Case_sync(levels_KLHK[13], NUSAN$KLHK_LU)
NUSAN$KLHK_LU <- Case_sync(levels_KLHK[14], NUSAN$KLHK_LU)
NUSAN$KLHK_LU <- Case_sync(levels_KLHK[15], NUSAN$KLHK_LU)
NUSAN$KLHK_LU <- Case_sync(levels_KLHK[16], NUSAN$KLHK_LU)
NUSAN$KLHK_LU <- Case_sync(levels_KLHK[17], NUSAN$KLHK_LU)
NUSAN$KLHK_LU <- Case_sync(levels_KLHK[18], NUSAN$KLHK_LU)
NUSAN$KLHK_LU <- Case_sync(levels_KLHK[19], NUSAN$KLHK_LU)
NUSAN$KLHK_LU <- Case_sync(levels_KLHK[20], NUSAN$KLHK_LU)
NUSAN$KLHK_LU <- Case_sync(levels_KLHK[21], NUSAN$KLHK_LU)
NUSAN$KLHK_LU <- Case_sync(levels_KLHK[22], NUSAN$KLHK_LU)
NUSAN$KLHK_LU <- Case_sync(levels_KLHK[23], NUSAN$KLHK_LU)


### Now I can parse the column as a factor; there should be no parsing errors

NUSAN$KLHK_LU <- parse_factor(NUSAN$KLHK_LU, levels_KLHK, ordered = FALSE, na = c("NA"), include_na = TRUE)
```



```r
### Confidence columns

NUSAN$X1990_CONF <- Non_standard_replace("High", "H" ,NUSAN$X1990_CONF)
NUSAN$X1990_CONF <- Non_standard_replace("Low", "L" ,NUSAN$X1990_CONF)
NUSAN$CH1_CONF <- Non_standard_replace("High", "H" ,NUSAN$CH1_CONF)
NUSAN$CH1_CONF <- Non_standard_replace("Low", "L" ,NUSAN$CH1_CONF)
NUSAN$CH1_CONF <- Non_standard_replace("h", "H" ,NUSAN$CH1_CONF)
NUSAN$CH2_CONF <- Non_standard_replace("High", "H" ,NUSAN$CH2_CONF)
NUSAN$CH2_CONF <- Non_standard_replace("Low", "L" ,NUSAN$CH2_CONF)
NUSAN$CH3_CONF <- Non_standard_replace("High", "H" ,NUSAN$CH3_CONF)
NUSAN$CH3_CONF <- Non_standard_replace("Low", "L" ,NUSAN$CH3_CONF)
NUSAN$CH4_CONF <- Non_standard_replace("High", "H" ,NUSAN$CH4_CONF)
NUSAN$CH4_CONF <- Non_standard_replace("Low", "L" ,NUSAN$CH4_CONF)
NUSAN$CH5_CONF <- Non_standard_replace("High", "H" ,NUSAN$CH5_CONF)
NUSAN$CH5_CONF <- Non_standard_replace("Low", "L" ,NUSAN$CH5_CONF)
NUSAN$CH6_CONF <- Non_standard_replace("High", "H" ,NUSAN$CH6_CONF)
NUSAN$CH6_CONF <- Non_standard_replace("Low", "L" ,NUSAN$CH6_CONF)
NUSAN$CONF_FINAL <- Non_standard_replace("High", "H" ,NUSAN$CONF_FINAL)
NUSAN$CONF_FINAL <- Non_standard_replace("Low", "L" ,NUSAN$CONF_FINAL)
NUSAN$CONF_FINAL <- Non_standard_replace("h", "H" ,NUSAN$CONF_FINAL)
NUSAN$CHANGE_E_CONF <- Non_standard_replace("High", "H" ,NUSAN$CHANGE_E_CONF)
NUSAN$CHANGE_E_CONF <- Non_standard_replace("Low", "L" ,NUSAN$CHANGE_E_CONF)

### CH4_CONF column also has a weird type "pond", which I assume was meant to be a note but which I'll convert to NA
NUSAN$CH4_CONF <- Non_standard_replace("pond", "NA" ,NUSAN$CH4_CONF)


### Now I can parse the confidence columns 
levels_conf <- c("H", "L")

NUSAN$X1990_CONF <- parse_factor(NUSAN$X1990_CONF, levels_conf, ordered = FALSE, na = c("NA"), include_na = TRUE)
NUSAN$CH1_CONF <- parse_factor(NUSAN$CH1_CONF, levels_conf, ordered = FALSE, na = c("NA"), include_na = TRUE)
NUSAN$CH2_CONF <- parse_factor(NUSAN$CH2_CONF, levels_conf, ordered = FALSE, na = c("NA"), include_na = TRUE)
NUSAN$CH3_CONF <- parse_factor(NUSAN$CH3_CONF, levels_conf, ordered = FALSE, na = c("NA"), include_na = TRUE)
NUSAN$CH4_CONF <- parse_factor(NUSAN$CH4_CONF, levels_conf, ordered = FALSE, na = c("NA"), include_na = TRUE)
NUSAN$CH5_CONF <- parse_factor(NUSAN$CH5_CONF, levels_conf, ordered = FALSE, na = c("NA"), include_na = TRUE)
NUSAN$CH6_CONF <- parse_factor(NUSAN$CH6_CONF, levels_conf, ordered = FALSE, na = c("NA"), include_na = TRUE)
NUSAN$CONF_FINAL <- parse_factor(NUSAN$CONF_FINAL, levels_conf, ordered = FALSE, na = c("NA"), include_na = TRUE)
NUSAN$CHANGE_E_CONF <- parse_factor(NUSAN$CHANGE_E_CONF, levels_conf, ordered = FALSE, na = c("NA"), include_na = TRUE)
```



```r
### SPOT

NUSAN$SPOT <- Case_sync("Yes", NUSAN$SPOT)
NUSAN$SPOT <- Case_sync("No", NUSAN$SPOT)

levels_yes_no <- c("Yes", "No")

NUSAN$SPOT <- parse_factor(NUSAN$SPOT, levels_yes_no, ordered = FALSE, na = c("NA"), include_na = TRUE)


### AGREE_DISAGREE

levels_agree <- c("Agree",
                  "Disagree - minor",
                  "Disagree - major")

NUSAN$AGREE_DISAGREE <- Case_sync(levels_agree[1], NUSAN$AGREE_DISAGREE)
NUSAN$AGREE_DISAGREE <- Case_sync(levels_agree[2], NUSAN$AGREE_DISAGREE)
NUSAN$AGREE_DISAGREE <- Case_sync(levels_agree[3], NUSAN$AGREE_DISAGREE)

NUSAN$AGREE_DISAGREE <- parse_factor(NUSAN$AGREE_DISAGREE, levels_agree, ordered = FALSE, na = c("NA"), include_na = TRUE)


### DISAG_EDITS

levels_disag <- c("Edited entry",
                  "No edits needed")

NUSAN$DISAG_EDITS <- Case_sync(levels_disag[1], NUSAN$DISAG_EDITS)
NUSAN$DISAG_EDITS <- Case_sync(levels_disag[2], NUSAN$DISAG_EDITS)

NUSAN$DISAG_EDITS <- parse_factor(NUSAN$DISAG_EDITS, levels_disag, ordered = FALSE, na = c("NA"), include_na = TRUE)


### Checked

levels_checked <- c("Not checked", 
                    "Agree", 
                    "Unsure", 
                    "Recommend change")

NUSAN$Checked <- Case_sync(levels_checked[1], NUSAN$Checked)
NUSAN$Checked <- Case_sync(levels_checked[2], NUSAN$Checked)
NUSAN$Checked <- Case_sync(levels_checked[3], NUSAN$Checked)
NUSAN$Checked <- Case_sync(levels_checked[4], NUSAN$Checked)


NUSAN$Checked <- parse_factor(NUSAN$Checked, levels_checked, ordered = FALSE, na = c("NA"), include_na = TRUE)
```



```r
levels_user <- c("Anna checked", 
                 "Yazid checked",
                 "Rizky checked",
                 "Zuraidah checked",
                 "Diana checked",
                 "Inggit checked",
                 "Tatik checked",
                 "Kustiyo checked")

NUSAN$USER <- Case_sync(levels_user[1], NUSAN$USER)
NUSAN$USER <- Case_sync(levels_user[2], NUSAN$USER)
NUSAN$USER <- Case_sync(levels_user[3], NUSAN$USER)
NUSAN$USER <- Case_sync(levels_user[4], NUSAN$USER)
NUSAN$USER <- Case_sync(levels_user[5], NUSAN$USER)
NUSAN$USER <- Case_sync(levels_user[6], NUSAN$USER)
NUSAN$USER <- Case_sync(levels_user[7], NUSAN$USER)
NUSAN$USER <- Case_sync(levels_user[8], NUSAN$USER)

NUSAN$Editor <- Case_sync(levels_user[1], NUSAN$Editor)
NUSAN$Editor <- Case_sync(levels_user[2], NUSAN$Editor)
NUSAN$Editor <- Case_sync(levels_user[3], NUSAN$Editor)
NUSAN$Editor <- Case_sync(levels_user[4], NUSAN$Editor)
NUSAN$Editor <- Case_sync(levels_user[5], NUSAN$Editor)
NUSAN$Editor <- Case_sync(levels_user[6], NUSAN$Editor)
NUSAN$Editor <- Case_sync(levels_user[7], NUSAN$Editor)
NUSAN$Editor <- Case_sync(levels_user[8], NUSAN$Editor)


NUSAN$USER <- parse_factor(NUSAN$USER, levels_user, ordered = FALSE, na = c("NA"), include_na = TRUE)
NUSAN$Editor <- parse_factor(NUSAN$Editor, levels_user, ordered = FALSE, na = c("NA"), include_na = TRUE)
```


## Part 5: Creating new variables

Now that I have correctly formatted columns containing numeric and categorical variables, I can calculate additional columns from the existing data. 

### Final land use, number of changes, and trajectory columns



```r
### Final land use

No_changes <- 
  NUSAN %>%
  filter(CH1_YR == 0) %>%
  mutate(FINAL_LU_UMD = X1990_LC) %>%
  mutate(NUM_CHANGE = 0) %>%
  mutate(TRAJECTORY = X1990_LC)

One_change <-
  NUSAN %>%
  filter(CH1_YR > 0, CH2_YR == 0) %>%
  mutate(FINAL_LU_UMD = CH1_TYPE) %>%
  mutate(NUM_CHANGE = 1)  %>%
  mutate(TRAJECTORY = str_c(X1990_LC, CH1_TYPE, sep = " > "))

Two_changes <-
  NUSAN %>%
  filter(CH2_YR > 0, CH3_YR == 0) %>%
  mutate(FINAL_LU_UMD = CH2_TYPE) %>%
  mutate(NUM_CHANGE = 2)  %>%
  mutate(TRAJECTORY = str_c(X1990_LC, CH1_TYPE, CH2_TYPE, sep = " > "))

Three_changes <-
  NUSAN %>%
  filter(CH3_YR > 0, CH4_YR == 0) %>%
  mutate(FINAL_LU_UMD = CH3_TYPE) %>%
  mutate(NUM_CHANGE = 3)  %>%
  mutate(TRAJECTORY = str_c(X1990_LC, CH1_TYPE, CH2_TYPE, CH3_TYPE, sep = " > "))

Four_changes <-
  NUSAN %>%
  filter(CH4_YR > 0, CH5_YR == 0) %>%
  mutate(FINAL_LU_UMD = CH4_TYPE) %>%
  mutate(NUM_CHANGE = 4)   %>%
  mutate(TRAJECTORY = str_c(X1990_LC, CH1_TYPE, CH2_TYPE, CH3_TYPE, CH4_TYPE, sep = " > "))

Five_changes <-
  NUSAN %>%
  filter(CH5_YR > 0, CH6_YR == 0) %>%
  mutate(FINAL_LU_UMD = CH5_TYPE) %>%
  mutate(NUM_CHANGE = 5)   %>%
  mutate(TRAJECTORY = str_c(X1990_LC, CH1_TYPE, CH2_TYPE, CH3_TYPE, CH4_TYPE, CH5_TYPE, sep = " > "))

Six_changes <-
  NUSAN %>%
  filter(CH6_YR > 0) %>%
  mutate(FINAL_LU_UMD = CH6_TYPE) %>%
  mutate(NUM_CHANGE = 6) %>%
  mutate(TRAJECTORY = str_c(X1990_LC, CH1_TYPE, CH2_TYPE, CH3_TYPE, CH4_TYPE, CH5_TYPE, CH6_TYPE, sep = " > "))

NUSAN <- rbind(No_changes, One_change, Two_changes, Three_changes, Four_changes, Five_changes, Six_changes)
```



```r
###final land use factor list

levels_final = c("Primary intact", 
                 "Primary degraded", 
                 "Non forest", 
                 "Cleared - Abandoned", 
                 "Cleared - Palm estate", 
                 "Cleared - Smallholder", 
                 "Cleared - Tree plantation", 
                 "Cleared - Fire", 
                 "Cleared - Road", 
                 "Cleared - Settlement", 
                 "Cleared - Rubber", 
                 "Cleared - Mining", 
                 "Cleared - Other", 
                 "Degraded - Fire", 
                 "Degraded - Selective logging", 
                 "Degraded - Nearby clearing", 
                 "Degraded - Natural disturbance", 
                 "Degraded - Peatland draining")

NUSAN$FINAL_LU_UMD <- parse_factor(NUSAN$FINAL_LU_UMD, levels_final, ordered = FALSE, na = c("NA"), include_na = TRUE)
NUSAN$NUM_CHANGE <- parse_integer(NUSAN$NUM_CHANGE, na = c("NA"))
```


### First year and type of degradation, and first year/type of clearing



```r
levels_clear <- c("Cleared - Abandoned", 
                  "Cleared - Palm estate", 
                  "Cleared - Smallholder", 
                  "Cleared - Tree plantation", 
                  "Cleared - Fire", 
                  "Cleared - Road", 
                  "Cleared - Settlement", 
                  "Cleared - Rubber", 
                  "Cleared - Mining", 
                  "Cleared - Other")

levels_deg <- c("Degraded - Fire", 
                "Degraded - Selective logging", 
                "Degraded - Nearby clearing", 
                "Degraded - Natural disturbance", 
                "Degraded - Peatland draining")

No_changes <- 
  No_changes %>%
  mutate(CLEAR_YR_FIRST = 0, CLEAR_TYPE_FIRST = "NA") %>%
  mutate(DEG_YR_FIRST = 0, DEG_TYPE_FIRST = "NA")

Deg_only <- 
  NUSAN %>%
  filter(FINAL_LU_UMD %in% levels_deg) %>%
  mutate(CLEAR_YR_FIRST = 0, CLEAR_TYPE_FIRST = "NA") %>%
  mutate(DEG_YR_FIRST = CH1_YR, DEG_TYPE_FIRST = CH1_TYPE)

First_clearing_CH1 <- 
  NUSAN %>%
  filter(CH1_TYPE %in% levels_clear) %>%
  mutate(CLEAR_YR_FIRST = CH1_YR, CLEAR_TYPE_FIRST = CH1_TYPE) %>%
  mutate(DEG_YR_FIRST = 0, DEG_TYPE_FIRST = "NA")

First_clearing_CH2 <- 
  NUSAN %>%
  filter(CH1_TYPE %in% levels_deg, CH2_TYPE %in% levels_clear) %>%
  mutate(CLEAR_YR_FIRST = CH2_YR, CLEAR_TYPE_FIRST = CH2_TYPE) %>%
  mutate(DEG_YR_FIRST = CH1_YR, DEG_TYPE_FIRST = CH1_TYPE)

First_clearing_CH3 <- 
  NUSAN %>%
  filter(CH2_TYPE %in% levels_deg, CH3_TYPE %in% levels_clear) %>%
  mutate(CLEAR_YR_FIRST = CH3_YR, CLEAR_TYPE_FIRST = CH3_TYPE) %>%
  mutate(DEG_YR_FIRST = CH1_YR, DEG_TYPE_FIRST = CH1_TYPE)

First_clearing_CH4 <- 
  NUSAN %>%
  filter(CH3_TYPE %in% levels_deg, CH4_TYPE %in% levels_clear) %>%
  mutate(CLEAR_YR_FIRST = CH4_YR, CLEAR_TYPE_FIRST = CH4_TYPE) %>%
  mutate(DEG_YR_FIRST = CH1_YR, DEG_TYPE_FIRST = CH1_TYPE)

First_clearing_CH5 <- 
  NUSAN %>%
  filter(CH4_TYPE %in% levels_deg, CH5_TYPE %in% levels_clear) %>%
  mutate(CLEAR_YR_FIRST = CH5_YR, CLEAR_TYPE_FIRST = CH5_TYPE) %>%
  mutate(DEG_YR_FIRST = CH1_YR, DEG_TYPE_FIRST = CH1_TYPE)

First_clearing_CH6 <- 
  NUSAN %>%
  filter(CH5_TYPE %in% levels_deg, CH6_TYPE %in% levels_clear) %>%
  mutate(CLEAR_YR_FIRST = CH6_YR, CLEAR_TYPE_FIRST = CH6_TYPE) %>%
  mutate(DEG_YR_FIRST = CH1_YR, DEG_TYPE_FIRST = CH1_TYPE)

NUSAN <- rbind(No_changes, 
               Deg_only, 
               First_clearing_CH1, 
               First_clearing_CH2, 
               First_clearing_CH3, 
               First_clearing_CH4, 
               First_clearing_CH5, 
               First_clearing_CH6)


NUSAN$DEG_TYPE_FIRST <- parse_factor(NUSAN$DEG_TYPE_FIRST, levels_deg, ordered = FALSE, na = c("NA"), include_na = TRUE)
NUSAN$CLEAR_TYPE_FIRST <- parse_factor(NUSAN$CLEAR_TYPE_FIRST, levels_clear, ordered = FALSE, na = c("NA"), include_na = TRUE)

length(unique(NUSAN$ID))
```

```
## [1] 10000
```

```r
summary(unique(NUSAN$ID))
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##       1    2501    5000    5000    7500   10000
```

## Part 6: saving the final dataset to CSV and RDS formats

I will save two versions of NUSAN - the full data set (NUSAN_FINAL_FULL_VERSION) and a shorter summary dataset, containing only the key change variables. I'll save each of these files in both CSV format, for analysis in Excel, and as .rds files, for analysis in R. (Reading the NUSAN data into R from an RDS file will ensure the correct factor levels are preserved for categorical variables). 



```r
write_csv(NUSAN, "NUSAN_FINAL_FULL_VERSION.csv")
saveRDS(NUSAN, file = "NUSAN_FINAL_FULL_VERSION.rds")

### I will also write a summary file, containing only the most important files for analysis 
### Columns included in the summary file are listed in the SUMMARY_COLUMNS object below

SUMMARY_COLUMNS <- c("ISLAND", 
                     "ID", 
                     "FINAL_LU_UMD",
                     "DEG_YR_FIRST",
                     "DEG_TYPE_FIRST",
                     "CLEAR_YR_FIRST", 
                     "CLEAR_TYPE_FIRST",
                     "NUM_CHANGE", 
                     "X1990_LC",
                     "CH1_YR", 
                     "CH1_TYPE",
                     "CH2_YR", 
                     "CH2_TYPE",
                     "CH3_YR", 
                     "CH3_TYPE",
                     "CH4_YR", 
                     "CH4_TYPE",
                     "CH5_YR", 
                     "CH5_TYPE", 
                     "CH6_YR", 
                     "CH6_TYPE",
                     "KLHK_LU",
                     "TRAJECTORY") 

NUSAN_SUMMARY <- 
  NUSAN %>%
  select(SUMMARY_COLUMNS)

write_csv(NUSAN_SUMMARY, "NUSAN_FINAL_SUMMARY_VERSION.csv")
saveRDS(NUSAN_SUMMARY, file = "NUSAN_FINAL_SUMMARY_VERSION.rds")

summary(NUSAN_SUMMARY$FINAL_LU_UMD)
```

```
##                 Primary intact               Primary degraded 
##                           3387                            418 
##                     Non forest            Cleared - Abandoned 
##                           3954                            345 
##          Cleared - Palm estate          Cleared - Smallholder 
##                            355                            230 
##      Cleared - Tree plantation                 Cleared - Fire 
##                            112                            140 
##                 Cleared - Road           Cleared - Settlement 
##                             51                              4 
##               Cleared - Rubber               Cleared - Mining 
##                             34                             13 
##                Cleared - Other                Degraded - Fire 
##                             50                             75 
##   Degraded - Selective logging     Degraded - Nearby clearing 
##                            421                            364 
## Degraded - Natural disturbance   Degraded - Peatland draining 
##                             37                             10
```
