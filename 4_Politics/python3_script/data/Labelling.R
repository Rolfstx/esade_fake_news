library(data.table)
#install.packages('bit64')

library(sjmisc)
library(dplyr)

#install.packages('devtools')
devtools::install_github("favstats/AllSideR")
allsides = AllSideR::allsides_data

#load dataset
df = fread("~/Documents/GitHub/esade_fake_news/4_Politics/python3_script/data/20200501-200819_joe_biden.csv")

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

#huckabee is fake: The DEEP STATE vs General Flynn
df[, .N, by='channel'][order(-N)][1:10]
genre = df[, .N, by='genre'][order(-N)]

write.csv(genre, "~/Documents/GitHub/esade_fake_news/4_Politics/python3_script/data/genre/20200501-200819_joe_biden.csv")

channel_unique = data.table()
channel_unique$channel = unique(df$channel)

#create new df by merging df2 with allsides
#https://www.allsides.com/media-bias/media-bias-ratings
channel_unique2 = merge(channel_unique, 
            allsides[, c('news_source', 'rating', 'rating_num')], 
            by.x='channel',
            by.y='news_source', 
            all.x=TRUE)


write.csv(df2, "~/Documents/GitHub/esade_fake_news/4_Politics/youtube_api_request_info/data/biden_labelling.csv")
