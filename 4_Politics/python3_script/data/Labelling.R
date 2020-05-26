library(data.table)
#install.packages('bit64')

#library(sjmisc)
#library(dplyr)

#install.packages('devtools')
#devtools::install_github("favstats/AllSideR")
#allsides = AllSideR::allsides_data

#load dataset
df = fread("~/Documents/GitHub/esade_fake_news/4_Politics/python3_script/data/20200504-193926_joe_biden.csv")

#create relevant column equals 1 if it contains keywords
#115 videos contain keywords in title or description columns
df$relevant = ifelse(grepl('biden|trump|democrat|republican|politics|president', paste(df$title, df$description), ignore.case=TRUE), 1, 0)
sum(df$relevant)

#number of videos that contain keywords in title column
#59 videos
sum(ifelse(grepl('biden|trump|democrat|republican|politics|president', df$title, ignore.case=TRUE), 1, 0))

#number of videos that contain keywords in description column
#113
sum(ifelse(grepl('biden|trump|democrat|republican|politics|president', df$description, ignore.case=TRUE), 1, 0))

#Look for fake news
df2 = df[relevant==1, .(title, description, channel)]

#write csv with channels and genre
channels = df[, .N, by='channel'][order(-N)]
channels_genre = df[, .N, by=c('channel','genre')]
write.csv(channels_genre, "~/Documents/GitHub/esade_fake_news/4_Politics/python3_script/data/channels/20200504-193926_joe_biden_channels.csv", row.names=FALSE)

#write csv with genre
genre = df[, .N, by='genre'][order(-N)]
write.csv(genre, "~/Documents/GitHub/esade_fake_news/4_Politics/python3_script/data/genre/20200504-193926_joe_biden_genre.csv", row.names=FALSE)

genre_relevant = fread("~/Documents/GitHub/esade_fake_news/4_Politics/python3_script/data/genre/20200504-193926_joe_biden_genre.csv")

df2 = merge(df[, c('title','description','genre','channel','id')], 
            genre_relevant, 
            by='genre')

#percentage of videos that are relevant
mean(df2$relevant)

#create table with only relevant videos
relevant = df2[relevant == 1]

#top25 channels weight
sum(channels[1:25]$N) / sum(channels$N)

#top25 channels - average number of videos per channel
sum(channels[1:25]$N) / 25


write.csv(df2, "~/Documents/GitHub/esade_fake_news/4_Politics/youtube_api_request_info/data/biden_labelling.csv")
