library(dplyr)
library(data.table)

#Import File:
data <- read.csv('~/GitHub/esade_fake_news/3_Corona/youtube_recommendation_scrapper/data/csv/covid_20200429_unique_search2_depth7_branch7.csv')
setDT(data)

#Get Unique Channels:

unique_channel <- unique(data, by = 'channel')
unique_channel2 <- unique_channel[!apply(unique_channel, 1, function(x) any(x=="")),] 
