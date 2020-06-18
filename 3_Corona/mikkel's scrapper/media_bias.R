#Import Packages

library(data.table)
library(tidyverse)
library(dplyr)
library(openxlsx)

#Import CSV:

floyd <- read.csv("~/GitHub/esade_fake_news/3_Corona/mikkel's scrapper/data/20200614-042606_George_Floyd.csv")
setDT(floyd)

media_bias <- read.csv("~/GitHub/esade_fake_news/3_Corona/mikkel's scrapper/media_bias_data.csv", sep = ";")
setDT(media_bias)

#Data Processing:

genres <- floyd[, genre]
unique_genres <- unique(genres)

unique_genres

#relevant_genres <- c("Comedy", "Entertainment","News & Politics", "Nonprofits & Activism", "People & Blogs")




relevant_videos <- floyd[genre=="News & Politics" |
                           genre=="Nonprofits & Activism"|
                           genre=="People & Blogs",]


#Percentage of Relevant Videos: 68.58%

per_rel <- length(relevant_videos[,title])/length(floyd[,title])

#Clean Media Bias Dataset:

#Eliminate URL from News.Source Variable:
s <- gsub("\\s*\\([^\\)]+\\)","",as.character(media_bias$News.Source))

media_bias2 <- media_bias
media_bias2$News.Source = s

media_bias <- media_bias2

#Add Additional Sources that were not in the Original Dataset:

sources <- c("92nd Street Y","Breakfast Club Power 105.1 FM", "Trevor Noah", "AFP News Agency", "Real Time with Bill Maher",
             "The Motley Fool", "KOMPASTV", "Patriot Act", "The Philadelphia Citizen", "The Obama White House",
             "Digiday", "Levy Economics Institute", "BrandeisUniversity", "Seattle Channel", "The News & Observer",
             "CISAus", "OxfordUnion", "Town Hall Seattle", "Centennial Institute", "Room for Discussion",
             "ReaganFoundation", "Richard Nixon Foundation", "Intelligence Squared", "The Economic Club of Washington, D.C.",
             "Aspen Institute", "JFK Library", "Noticias Telemundo")

biases <- c("Left", "Left", "Least Biased", "Left-Center", "Least Biased", "Left-Center","Left-Center", "Left-Center",
            "Left-Center","Least Biased", "Least Biased", "Least Biased", "Left-Centered", "Left-Centered",
            "Left", "Least Biased", "Least Biased", "Right", "Least Biased", "Right-Centered", "Right", "Least Biased",
            "Least Biased", "Left-Centered","Left", "Left-Centered", "Left-Centered")


additional_sources <- data.table(News.Source=sources, Bias=biases)

#Merge it with the bias dataset to obtain a complete one :
#(DO THIS ONLY ONCE OR IT WILL DUPLICATE THE ADDITIONS)

#If you are not sure, run the following:
# re-import the media_bias dataset & clean it again


media_bias <- rbind(media_bias,additional_sources)


#Unique Channels in relevant videos:

unique_channels <- unique(relevant_videos$channel)


#Rename Channels in related_videos to match the ones in media_bias, replace show from channel with channel:

relevant_videos$channel <- str_replace_all(relevant_videos$channel, "HooverInstitution", "Hoover Institution")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "PBS NewsHour", "PBS News Hour")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "NowThis News", "NowThisNews")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "Commonwealth Club", "CommonWealth fund")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "BBC America", "BBC News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "The New York Times", "New York Times")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "A&E", "NBC News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "WCCO - CBS Minnesota", "CBS News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "Washington Week", "PBS News Hour")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "The Late Show with Stephen Colbert", "CBS News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "Rocky Mountain PBS", "PBS News Hour")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "New York Times Events", "New York Times")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "Face the Nation", "CBS News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "WIRED", "Wired Magazine")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "CBC News: The National", "CBC News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "KPRC 2 Click2Houston", "NBC News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "ABC10", "ABC News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "Saturday Night Live", "NBC News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "Jimmy Kimmel Live", "ABC News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "KPBS", "PBS News Hour")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "CNBC Television", "CNBC")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "HuffPost", "Huffington Post")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "FRONTLINE PBS | Official", "PBS News Hour")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "11Alive", "NBC News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "PBS News Hour|PBS News Hour", "PBS News Hour")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "The Heritage Foundation", "Heritage Foudation")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "RT en Español", "Ruptly")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "Eyewitness News ABC7NY", "ABC11 Eyewitness News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "Tallahassee Democrat", "Tallahasee Democrat")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "CBS 8 San Diego", "CBS News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "7NEWS Australia", "7NEWS")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "C-SPAN", "C-Span")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "Yahoo Finance", "Yahoo News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "12 News", "NBC News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "WCPO 9", "ABC News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "Guardian Supporters", "The Guardian")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "Click On Detroit | Local 4 | WDIV", "NBC News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "The Telegraph", "The Daily Telegraph")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "FOX 13 News - Tampa Bay", "Fox News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "ABC Action News", "ABC News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "Prairie Public", "PBS News Hour")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "Bloomberg QuickTake Originals", "Bloomberg")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "10 Tampa Bay", "CBS News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "abcqanda", "ABC News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "The Young Turks", "Young Turks")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "WKMG News 6 ClickOrlando", "CBS News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "CBS Evening News", "CBS News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "VICE News", "Vice News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "KCTV5 News", "CBS News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "KPIX CBS SF Bay Area", "CBS News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "WPXI-TV News Pittsburgh", "CBS News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "KHOU 11", "CBS News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "KPIX CBS SF Bay Area", "CBS News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "NBC News|NBC News|NBC News", "NBC News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "PBS News Hour|PBS News Hour", "PBS News Hour")


#merge relevant videos and bias:
merged <- c()
merged <- merge(relevant_videos,media_bias, by.x = 'channel', by.y = 'News.Source', all=FALSE)
merged <- merged[, .(channel, title, Bias)]

#Identify Channels that have not been classified:

missing2 <- relevant_videos[!(relevant_videos$channel %in% merged$channel),]

missing2_unique <- unique(missing2$channel)
missing2_unique

#Not Related Channels:

not_related <- c("DoctorOz", "Talks at Google", "Mango News", "TEDx Talks", "PURPOSE ON TAP", "Diana Febrirosa", "KOMPASTV",
                 "TED", "Adelaide PHN", "ChristopherHitchslap","Dan Beaumont Space Museum","HISTORIAS", "Web3 Foundation",
                 "Fire Films", "That Atheist Guy")

#Eliminate Not Related Channels from relevant_videos discovered through manual search:
relevant_videos <- relevant_videos[!(relevant_videos$channel %in% not_related),]



#Create Datatable of missing channels already classified by bias


#Breakfast Club Power 105.1 FM = Left
#Trevor Noah = Left
#AFP News Agency = Least Biased
#Real Time with Bill Maher = Left-Center
#The Motley Fool = Least Biased
#KOMPASTV = Left-Center
#Patriot Act = Left-Center
#The Philadelphia Citizen = Left-Center
#The Obama White House = Left-Center
#Digiday = Least Biased
#Levy Economic Institute = Least Biased
#BrandeisUniversity = Least Biased
#Seattle Channel = Left-Centered
#The News & Observer = Left-Centered
#CISAus = Left
#Oxford Union = Least Biased
#Town Hall Seattle = Least Biased
#Centennial Institute = Right
#Room for Discussion = Least Biased
#ReaganFOundation = Right-Centered
#Richard Nixon Foundation = Right
#Intelligence Squared = Least Biased
#The Economic Club of Washington, D.C. = Least Biased
#Aspen Institute = Left-Center
#JFK Library = Left
#Noticias Telemundo = Left-Centered


#Counts of Classified Videos:

#BarPlot:
par(las=2)
counts <- table(merged$Bias)
barplot(counts, main="Bias Distribution",
        cex.names=0.6)

#Frequency Table:

frequency <- table(merged$Bias)
frequency <- as.data.frame(frequency)

names(frequency)[1]='bias'
setDT(frequency)
frequency <- frequency.set_index('bias')

frequency



#Classified Data:

classified <- merged

classified_unique <- classified[!duplicated(classified[,c('title')]),] 

#Write csv:

write.csv(classified_unique, "~/GitHub/esade_fake_news/3_Corona/mikkel's scrapper/George_Floyd_classified_bias_data.csv")









##################################### REPEAT ON FULL DATASET ############################################




#TAKE FULL DATASET THAT INCLUDES REPEATED VIDEOS AND MERGE BY CHANNEL TO INCLUDE BIASES:

full_floyd <- floyd <- read.csv("~/GitHub/esade_fake_news/3_Corona/mikkel's scrapper/data/16_06_2020_Geroge_Floyd_Full.csv")
setDT(floyd)

relevant_videos <- full_floyd[genre=="News & Politics" |
                           genre=="Nonprofits & Activism"|
                           genre=="People & Blogs",]


#Percentage of Relevant Videos: 68.58%

per_rel <- length(relevant_videos[,title])/length(floyd[,title])
per_rel


#Rename Channels in related_videos to match the ones in media_bias, replace show from channel with channel:

relevant_videos$channel <- str_replace_all(relevant_videos$channel, "HooverInstitution", "Hoover Institution")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "PBS NewsHour", "PBS News Hour")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "NowThis News", "NowThisNews")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "Commonwealth Club", "CommonWealth fund")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "BBC America", "BBC News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "The New York Times", "New York Times")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "A&E", "NBC News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "WCCO - CBS Minnesota", "CBS News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "Washington Week", "PBS News Hour")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "The Late Show with Stephen Colbert", "CBS News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "Rocky Mountain PBS", "PBS News Hour")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "New York Times Events", "New York Times")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "Face the Nation", "CBS News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "WIRED", "Wired Magazine")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "CBC News: The National", "CBC News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "KPRC 2 Click2Houston", "NBC News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "ABC10", "ABC News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "Saturday Night Live", "NBC News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "Jimmy Kimmel Live", "ABC News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "KPBS", "PBS News Hour")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "CNBC Television", "CNBC")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "HuffPost", "Huffington Post")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "FRONTLINE PBS | Official", "PBS News Hour")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "11Alive", "NBC News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "PBS News Hour|PBS News Hour", "PBS News Hour")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "The Heritage Foundation", "Heritage Foudation")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "RT en Español", "Ruptly")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "Eyewitness News ABC7NY", "ABC11 Eyewitness News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "Tallahassee Democrat", "Tallahasee Democrat")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "CBS 8 San Diego", "CBS News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "7NEWS Australia", "7NEWS")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "C-SPAN", "C-Span")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "Yahoo Finance", "Yahoo News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "12 News", "NBC News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "WCPO 9", "ABC News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "Guardian Supporters", "The Guardian")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "Click On Detroit | Local 4 | WDIV", "NBC News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "The Telegraph", "The Daily Telegraph")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "FOX 13 News - Tampa Bay", "Fox News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "ABC Action News", "ABC News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "Prairie Public", "PBS News Hour")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "Bloomberg QuickTake Originals", "Bloomberg")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "10 Tampa Bay", "CBS News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "abcqanda", "ABC News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "The Young Turks", "Young Turks")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "WKMG News 6 ClickOrlando", "CBS News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "CBS Evening News", "CBS News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "VICE News", "Vice News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "KCTV5 News", "CBS News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "KPIX CBS SF Bay Area", "CBS News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "WPXI-TV News Pittsburgh", "CBS News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "KHOU 11", "CBS News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "KPIX CBS SF Bay Area", "CBS News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "NBC News|NBC News|NBC News", "NBC News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "PBS News Hour|PBS News Hour", "PBS News Hour")


#Not related Channels that Slipped Through:

not_related <- c("DoctorOz", "Talks at Google", "Mango News", "TEDx Talks", "PURPOSE ON TAP", "Diana Febrirosa", "KOMPASTV",
                 "TED", "Adelaide PHN", "ChristopherHitchslap","Dan Beaumont Space Museum","HISTORIAS", "Web3 Foundation",
                 "Fire Films", "That Atheist Guy")


#Eliminate Not Related Channels from relevant_videos discovered through manual search:
relevant_videos <- relevant_videos[!(relevant_videos$channel %in% not_related),]


#merge relevant videos and bias AGAIN to account for the new ones:
merged <- merge(relevant_videos,media_bias, by.x = 'channel', by.y = 'News.Source')
merged <- merged[, .(channel, title, Bias)]

#Counts of Classified Videos:

#BarPlot:
par(las=2)
counts <- table(merged$Bias)
barplot(counts, main="Bias Distribution",
        cex.names=0.6)

#Frequency Table:

frequency <- table(merged$Bias)
frequency <- as.data.frame(frequency)

names(frequency)[1]='bias'

frequency <- frequency.set_index('bias')

frequency

#Save to Excel:

write.xlsx(frequency, "~/GitHub/esade_fake_news/3_Corona/mikkel's scrapper/bias_distribution_table.xlsx")





# LEFT TO DO:

#CREATE CHARTS ETC:





