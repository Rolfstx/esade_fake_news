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

biases <- c("Left", "Left", "Left", "Left-Center", "Least Biased", "Left-Center","Left-Center", "Left-Center",
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
merged_unique <- c()
merged_unique <- merge(relevant_videos,media_bias, by.x = 'channel', by.y = 'News.Source', all=FALSE)
merged_unique <- merged_unique[, .(channel, title, Bias)]

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

# Binarize left & left-centered = 0:

#df$colC <- ifelse(df$colA == 0, 1, 0)

#First only include Left, Left-Center, Right and Right-Center

merged_unique <- merged_unique[Bias== "Left" | Bias == "Left-Center" | Bias == "Right" | Bias == "Right-Center",]
#
merged_unique$binary <- ifelse(merged_unique$Bias == "Left"|merged_unique$Bias == "Left-Center", 0, 1)

final_df <- merged_unique[, .(binary,title, description,channel, id)]

#Write csv:

write.csv(final_df, "~/GitHub/esade_fake_news/3_Corona/mikkel's scrapper/George_Floyd_nlp_data.csv")


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


########################################################################################################################
########################################################################################################################
########################################################################################################################
##################################### CLASSIFY BLACK LIVES MATTER FILE #################################################
########################################################################################################################
########################################################################################################################
########################################################################################################################


#Import CSV:

blm <- read.csv("~/GitHub/esade_fake_news/3_Corona/mikkel's scrapper/data/23_06_2020_Black_Lives_Matter_Unique.csv")
setDT(blm)

media_bias <- read.csv("~/GitHub/esade_fake_news/3_Corona/mikkel's scrapper/media_bias_data.csv", sep = ";")
setDT(media_bias)

#Data Processing:

genres <- blm[, genre]
unique_genres <- unique(genres)

unique_genres

#relevant_genres <- c("Comedy", "Entertainment","News & Politics", "Nonprofits & Activism", "People & Blogs")




relevant_videos <- blm[genre=="News & Politics" |
                           genre=="Nonprofits & Activism"|
                           genre=="People & Blogs" |
                           genre=="Entertainment",]


#Percentage of Relevant Videos: 69.64%

per_rel <- length(relevant_videos[,title])/length(blm[,title])

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
             "Aspen Institute", "JFK Library", "Noticias Telemundo", "LastWeekTonight", "Comedy Central")

biases <- c("Left", "Left", "Left", "Left-Center", "Least Biased", "Left-Center","Left-Center", "Left-Center",
            "Left-Center","Least Biased", "Least Biased", "Least Biased", "Left-Centered", "Left-Centered",
            "Left", "Least Biased", "Least Biased", "Right", "Least Biased", "Right-Centered", "Right", "Least Biased",
            "Least Biased", "Left-Centered","Left", "Left-Centered", "Left-Centered", "Left-Centered", "Left-Centered"
            )


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
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "FRONTLINE PBS \\| Official", "PBS News Hour")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "11Alive", "NBC News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "PBS News Hour\\|PBS News Hour", "PBS News Hour")
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
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "Click On Detroit \\| Local 4 \\| WDIV", "NBC News")
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
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "NBC News\\|NBC News\\|NBC News", "NBC News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "PBS News Hour\\|PBS News Hour", "PBS News Hour")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "The Daily Show with Trevor Noah", "Trevor Noah")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "Late Night with Seth Meyers", "NBC News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "The Tonight Show Starring Jimmy Fallon", "NBC News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, fox, "Fox News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "FOX 9 News \\| KMSP-TV Minneapolis-St. Paul", "Fox News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, cbs, "CBS News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, nbc, "NBC News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, pbs, "PBS News Hour")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, vice, "Vice News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "CBS News News", "CBS News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "PBS News Hour News Hour", "PBS News Hour")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "Vice News Hacks with Oobah Butler", "Vice News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "ABC News (Australia)", "ABC News Australia")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "ABC News In-depth", "ABC News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "ABC7 News Bay Area", "ABC News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "ABC7", "ABC News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "ABC11 Eyewitness News", "ABC News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "ABC 10 News", "ABC News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "48 Hours", "CBS News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "WMUR-TV", "ABC News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "9 News Australia", "9 News")
relevant_videos$channel <- str_replace_all(relevant_videos$channel, "China in Focus - NTD", "NTD.TV")



#Create Patterns for Replace:

rel_vid <- relevant_videos

#FOX RELATED CHANNELS:


fox <- rel_vid$channel[grepl('Fox', rel_vid$channel)]

fox <- c("FOX 17 WXMI|FOX 4 Now|FOX 4 News - Dallas-Fort Worth|FOX Carolina News")
fox

#CBS RELATED CHANNELS:

cbs<-rel_vid$channel[grepl('CBS', rel_vid$channel)]
cbs <- c("CBS This Morning|azfamily powered by 3TV & CBS5AZ|CBS Sacramento|CBS Sunday Morning|CBS New York|CBSN|CBS Los Angeles|CBS 17|CBS Miami|CBS")
cbs

#NBC RELATED CHANNELS:
nbc <- rel_vid$channel[grepl('NBC', rel_vid$channel)]
nbc <- c("NBCLA|NBC Left Field|NBC10 Philadelphia|WXII NBC News|NBC 10 WJAR|NBC4 Columbus|NBC 6 South Florida")
nbc

#PBS RELATED CHANNELS:
pbs <- rel_vid$channel[grepl('PBS', rel_vid$channel)]
pbs <- c("PBS|ChicagoPBS News Hour|FamilyPBS News Hour|Jeremy Vine on 5 -PBS News Hour Channel")
pbs

#VICE RELATED CHANNELS:
vice <- rel_vid$channel[grepl('VICE', rel_vid$channel)]
vice <- c("VICE|Vice News Life|Vice News Asia|Vice News on HBO|Vice News Life Hacks with Oobah Butler")
vice

#ABC Related CHANNELS:
abc <- relevant_videos$channel[grepl('ABC', relevant_videos$channel)]

abc


#NEWS Channel:
news <- relevant_videos$channel[grepl('NEWS', relevant_videos$channel)]
u_news <- unique(news)
m_news <- u_news[!(u_news %in% merged_unique$channel)]
m_news


#merge relevant videos and bias:
merged_unique <- c()
merged_unique <- merge(relevant_videos,media_bias, by.x = 'channel', by.y = 'News.Source', all=FALSE)
merged_unique <- merged_unique[, .(channel, title, Bias)]

#Identify Channels that have not been classified:

missing2 <- relevant_videos[!(relevant_videos$channel %in% merged_unique$channel),]

missing2_unique <- unique(missing2$channel)
missing2_unique

#Not Related Channels:

not_related <- c("DoctorOz", "Talks at Google", "Mango News", "TEDx Talks", "PURPOSE ON TAP", "Diana Febrirosa", "KOMPASTV",
                 "TED", "Adelaide PHN", "ChristopherHitchslap","Dan Beaumont Space Museum","HISTORIAS", "Web3 Foundation",
                 "Fire Films", "That Atheist Guy", "#48 on Trending", "Gabriel Iglesias", "#33 on Trending", "LaughPlanet",
                 "Peter Kay", "Cleantones", "United States","JRE Clips", "PowerfulJRE","Russell Peters", "Dhar Mann","Got Talent Global","Yangxi","SnewJ",
                 "Alfredo","Goddard Bolt","Iplay2win","TV Land","SPOOF","joycollector")

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
counts <- table(merged_unique$Bias)
barplot(counts, main="Bias Distribution",
        cex.names=0.6)

#Frequency Table:

frequency <- table(merged$Bias)
frequency <- as.data.frame(frequency)

names(frequency)[1]='bias'
setDT(frequency)
frequency <- frequency.set_index('bias')

frequency

# Prepare Data for NLP:

#Binarize left & left-centered = 0:
  
  #df$colC <- ifelse(df$colA == 0, 1, 0)
  
#First only include Left, Left-Center, Right and Right-Center

  
merged_unique <- merged_unique[Bias== "Left" | Bias == "Left-Center" | Bias == "Right" | Bias == "Right-Center" | Bias=="Questionable",]
#
merged_unique$binary <- ifelse(merged_unique$Bias == "Left"|merged_unique$Bias == "Left-Center"|merged_unique$Bias=="Questionable", 0, 1)

final_df <- merged_unique[, .(binary,title, description,channel, id)]

#Write csv:

write.csv(final_df, "~/GitHub/esade_fake_news/3_Corona/mikkel's scrapper/Black_Lives_nlp_data.csv")


