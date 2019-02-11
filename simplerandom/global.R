# Put all of your variables or parameters in here

library(shiny)
library(ggplot2)
library(dplyr)
library(DT)
library(sf)

nusan_raw <- read.csv("data/NUSAN_FINAL_FULL_VERSION.csv")
nusan <- nusan_raw %>%
	mutate(hectare = 0.09) %>%
	mutate(std = ifelse(
			CONF_FINAL == "H", 0, 0.09))

n_total <- nrow(nusan)

# read shapefile data
nusan_shp <- st_read("data/nusan_final_summary.shp") %>%
	mutate(hectare = 0.09) %>%
	mutate(final_lu = case_when(
			FINAL_LU_U == "Primary intact" ~ "Primary intact forest",
			FINAL_LU_U == "Primary degraded" ~ "Primary degraded (before 1990)", 
			FINAL_LU_U == "Non Forest" ~ "Non forest (before 1990)", TRUE~as.character("Forest loss")))

#select(san_shp, FINAL_LU_U, final_lu)

nusan_degraded <- nusan_shp %>% filter(DEG_YR_FIR != 0)
nusan_cleared <- nusan_shp %>% filter(CLEAR_YR_F != 0)