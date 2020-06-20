library(data.table)

#load dataset
#unique video dataset or all videos dataset
df = fread("~/Documents/GitHub/esade_fake_news/4_Politics/python3_script/data/videos/20200504-193926_joe_biden_recommendations.csv")
df[, 'V1':=NULL]

#df = fread("~/Documents/GitHub/esade_fake_news/4_Politics/python3_script/data/videos/20200504-193926_joe_biden.csv")

#groupby genre and count number of videos
genre = df[, .N, by='genre']

#groupby channel and count number of channels
channel = df[, unique(channel), by='genre']
channel2 = channel[, .N, by='genre']

#merge genre and channel2
genre_channel = merge(genre,
                      channel2,
                      by='genre',
                      suffixes= c('.video', '.channel'))[order(-N.video)]

#export genre_channel. Then label relevant genres with 1 in excel
#write.csv(genre_channel, "~/Documents/GitHub/esade_fake_news/4_Politics/python3_script/data/genre/20200504-193926_joe_biden_genre_channel.csv", row.names=FALSE)

#import genre_channel with added relevant column
genre_relevant = fread("~/Documents/GitHub/esade_fake_news/4_Politics/python3_script/data/genre/20200504-193926_joe_biden_genre_channel.csv")

#merge datasets to obtain relevant videos.
df2 = merge(df, 
            genre_relevant, 
            by='genre')

# 75% of videos are relevant
mean(df2$relevant)

#create new dataset with only relevant videos
df_relevant = df2[relevant==1]

#create dataset with only channel and count.
df_relevant_channel = df_relevant[, .N, by='channel'][order(channel)]

#export df_relevant. Match channels with media bias rating in Excel.
#the channel names are not exact matches. thus, mannually prepare in Excel.
#write.csv(df_relevant_channel, "~/Documents/GitHub/esade_fake_news/4_Politics/python3_script/data/channels/20200504-193926_joe_biden_channels_relevant.csv")

#load cleaned channel dataset
df_updated = fread("~/Documents/GitHub/esade_fake_news/4_Politics/python3_script/data/channels/20200504-193926_joe_biden_channels_relevant.csv", na.strings=c("","NA"), drop=c('Column1'))

#load media bias dataset
media_bias = fread("~/Documents/GitHub/esade_fake_news/4_Politics/python3_script/data/channels/media_bias_data.csv", drop='Website')

#merge cleaned channel dataset with media bias
df_merged = merge(df_updated,
                  media_bias,
                  by.x='media_bias',
                  by.y='News Source')

#remove N column
df_merged[, 'N':=NULL]

#complete dataset
df_merged2 = merge(df_relevant,
                   df_merged,
                   by='channel')

#complete dataset with all videos
#all 19'000 videos, used for graph/network analysis
df_all =merge(df,
              df_merged,
              by='channel',
              all.x=TRUE)

#ensure compelte_cases in views
df_all = df_all[complete.cases(views), ]

# % of videos still present in raw dataset.
nrow(df_merged2) / nrow(df)

#table with count and percentage
tblFun <- function(x){
  tbl <- table(x)
  res <- cbind(tbl,round(prop.table(tbl)*100,2))
  colnames(res) <- c('Count','Percentage')
  res
}

#
group_by_bias = do.call(rbind,lapply(df_all[, 'Bias'],tblFun))
group_by_bias

#write.csv(group_by_bias, "~/Documents/GitHub/esade_fake_news/4_Politics/python3_script/data/nlp/20200504-193926_joe_biden_group_bias.csv")

#export dataset with channel bias
#write.csv(df_merged2, "~/Documents/GitHub/esade_fake_news/4_Politics/python3_script/data/nlp/20200504-193926_joe_biden_bias.csv")

#convert Bias into binary
#right = 1
#left = 0
mapping <- c("Left" = 0, "Left-Center" = 0, 
             "Least Biased" = 1, "Right" = 1, "Right-Center" = 1)

df_merged2$Bias_num <- mapping[df_merged2$Bias]
#df_all$Bias_num <- mapping[df_all$Bias]

#keep columns title, description and Bias_num for NLP dataset
df_nlp = df_merged2[, c('Bias_num' ,'title', 'description', 'channel','id')]

#export NLP dataset
#write.csv(df_nlp, "~/Documents/GitHub/esade_fake_news/4_Politics/python3_script/data/nlp/20200504-193926_joe_biden_nlp.csv")

#export all videos dataset with media bias
write.csv(df_all, "~/Documents/GitHub/esade_fake_news/4_Politics/python3_script/data/videos/20200504-193926_joe_biden_all.csv")

# 32% Bias_num is 1, 68% is 0
sum(df_nlp$Bias_num) / nrow(df_nlp)
