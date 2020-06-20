#install.packages("stringr")

library(stringr)
library(data.table)
library(dplyr)





#FIRST CORONA FILE:
#Search:   search=2, branch=3, depth=4 keyword: coronavirus


#Import File:
corona <- read.csv("GitHub/esade_fake_news/3_Corona/mikkel's scrapper/data/20200502-111326_coronavirus.csv")
setDT(corona)

#Unique Channels:
unique_channels <- corona[, .(channel, genre, channel_url, channelDescription)]
unique_channels <- unique(unique_channels, by='channel')

#Fake Channels:
fake_channels <- c("The 5th Kind","Jon Scobie")

#Fake Videos by Fake Channel:
fake_by_channel <- corona[channel=="The 5th Kind" | channel=="Jon Scobie",]

#Suspect Channel:
suspect <- c("Syndicado TV", "Democracy Now!", "China in Focus - NTD", "Crossroads with JOSHUA PHILIPP", 
"Reel Truth Science Documentaries", )

#Fake plus suspects by channel:
fake_suspects <- corona[channel=="The 5th Kind" | 
                         channel=="Jon Scobie"|
                         channel=="Syndicado TV"|
                         channel=="Democracy Now!"|
                         channel=="China in Focus - NTD"|
                         channel=="Crossroads with JOSHUA PHILIPP"|
                         channel=="Reel Truth Science Documentaries",]

#syndacado <- corona[channel=='Syndicado TV', .(title, genre)]
#fox_news <- corona[channel=='Fox News', .(title, genre)]
#dem_now <- corona[channel=='Democracy Now!', .(title, genre)]
#cbc <- corona[channel=='CBC News', .(title, genre)]
#sixty_mins <-corona[channel=='60 Minutes Australia', .(title, genre)]
#nbc <- corona[channel=='NBC News', .(title, genre)]
#cnn <- corona[channel=='CNN', .(title, genre)]
#al_jaz <- corona[channel=='Al Jazeera English', .(title, genre)]
#compound <- corona[channel=='The Compound', .(title, genre)]
#cna <- corona[channel=='CNA Insider', .(title, genre)]
#sky_au <- corona[channel=='Sky News Australia', .(title, genre)]
#china_focus <- corona[channel=='China in Focus - NTD', .(title, genre)]


#Classification2:


#Check if videos have keyword in the title or description:
related <- corona%>%
  select(title, description, channel, genre)%>%
  filter(str_detect(description, "coronavirus") == TRUE)

related2 <- corona%>%
  select(title, description, channel, genre)%>%
  filter(str_detect(title, "coronavirus") == TRUE)

related3 <- corona%>%
  select(title, description, channel, genre)%>%
  filter(str_detect(description, "covid") == TRUE)

related4 <- corona%>%
  select(title, description, channel, genre)%>%
  filter(str_detect(description, "COVID") == TRUE)

related5 <- corona%>%
  select(title, description, channel, genre)%>%
  filter(str_detect(title, "COVID") == TRUE)

#Unite all relevant videos in one dataset:

all_related_videos <- union(related,related2,related3,related4,related5)
setDT(all_related_videos)


#Fake Relevant Videos:
sky_au <- all_related_videos[channel=='Sky News Australia', .(title, genre)]
china_focus <- all_related_videos[channel=='China in Focus - NTD', .(title, genre)]
josh_philipp <- all_related_videos[channel=='Crossroads with JOSHUA PHILIPP', .(title,genre)]


#SECOND CORONA FILE:
#Search: search=4, branch=3, depth=6  keyword=coronavirus is a hoax

#Import file:
covid1 <- read.csv("GitHub/esade_fake_news/3_Corona/mikkel's scrapper/data/20200503-184010_coronavirus_is_a_haux.csv")
setDT(covid1)

#Unique Channels:
unique_channels <- covid1[, .(channel, genre, channel_url, channelDescription)]
unique_channels <- unique(unique_channels, by='channel')

#Related Videos:
related <- covid1%>%
  select(title, description, channel, genre)%>%
  filter(str_detect(description, "coronavirus") == TRUE)

related2 <- covid1%>%
  select(title, description, channel, genre)%>%
  filter(str_detect(title, "coronavirus") == TRUE)

related3 <- covid1%>%
  select(title, description, channel, genre)%>%
  filter(str_detect(description, "covid") == TRUE)

related4 <- covid1%>%
  select(title, description, channel, genre)%>%
  filter(str_detect(title, "covid") == TRUE)

related5 <- covid1%>%
  select(title, description, channel, genre)%>%
  filter(str_detect(description, "COVID") == TRUE)

related6 <- covid1%>%
  select(title, description, channel, genre)%>%
  filter(str_detect(title, "COVID") == TRUE)

all_related_videos <- union(related,related2,related3,related4,related5, related6)
setDT(all_related_videos)

#Fake Related Videos:
ntd <- all_related_videos[channel=='NTD', .(title, genre)][1]
intercept <- all_related_videos[channel=='The Intercept', .(title, genre)]
fox_news <- covid1[channel=='Fox News' & (title =="Tucker: Are coronavirus lockdowns working?" | 
                                            title=="Tucker: Big Tech censors dissent over coronavirus lockdowns")]
china_focus <- all_related_videos[channel=='China in Focus - NTD', .(title, genre)]
josh_philipp <- all_related_videos[channel=='Crossroads with JOSHUA PHILIPP', .(title,genre)]

#THIRD FILE:
#Search: search=2, branch=5, depth=6  keyword=covid 19 conspiracy

covid2 <- read.csv("GitHub/esade_fake_news/3_Corona/mikkel's scrapper/data/20200504-170931_covid_19_conspiracy.csv")
setDT(covid2)

#Unique Channels:
unique_channels <- covid1[, .(channel, genre, channel_url, channelDescription)]
unique_channels <- unique(unique_channels, by='channel')

#Fake Channels:

fake_by_channel <- covid2[channel=="",] #AKA NONE

#Suspect Channels:
suspect <- c("China in Focus - NTD", "NTD", "Crossroads with JOSHUA PHILIPP", )

#Fake + Suspect:
fake_suspects <- covid2[channel=="NTD" | 
                          channel=="China in Focus - NTD" |
                          channel=="Crossroads with JOSHUA PHILIPP",]

#Relevant Videos:
related <- covid2%>%
  select(title, description, channel, genre)%>%
  filter(str_detect(description, "coronavirus") == TRUE)

related2 <- covid2%>%
  select(title, description, channel, genre)%>%
  filter(str_detect(title, "coronavirus") == TRUE)

related3 <- covid2%>%
  select(title, description, channel, genre)%>%
  filter(str_detect(description, "covid") == TRUE)

related4 <- covid2%>%
  select(title, description, channel, genre)%>%
  filter(str_detect(title, "covid") == TRUE)

related5 <- covid2%>%
  select(title, description, channel, genre)%>%
  filter(str_detect(description, "COVID") == TRUE)

related6 <- covid2%>%
  select(title, description, channel, genre)%>%
  filter(str_detect(title, "COVID") == TRUE)

related7 <- covid2%>%
  select(title, description, channel, genre)%>%
  filter(str_detect(title, "conspiracy") == TRUE)

related8 <- covid2%>%
  select(title, description, channel, genre)%>%
  filter(str_detect(title, "Conspiracy") == TRUE)

all_related_videos <- union(related,related2,related3,related4,related5, related6, related7,related8)
setDT(all_related_videos)

#Fake Related Videos:

fake_related <- covid2[title=="1st documentary movie on the origin of CCP virus, Tracking Down the Origin of the Wuhan Coronavirus"|
                         title=="Top 5 Most Outrageous News Stories: April 26, 2020 | NowThis" |
                         title=="Wuhan residents reveal the truth as CCP celebrates victory against CCP virus. US challenges China",]



#Suspect Related Videos:




