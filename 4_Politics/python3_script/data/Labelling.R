library(data.table)

#load dataset
df = fread("~/Documents/GitHub/esade_fake_news/4_Politics/python3_script/data/20200504-193926_joe_biden.csv")

genre_relevant = fread("~/Documents/GitHub/esade_fake_news/4_Politics/python3_script/data/genre/20200504-193926_joe_biden_genre.csv")

#merge datasets to obtain relevant videos.
df2 = merge(df, 
            genre_relevant, 
            by='genre')

# 75% of videos are relevant
mean(df2$relevant)

#create new dataset with only relevant videos
df_relevant = df2[relevant==1]

df_relevant_channel = genre = df_relevant[, .N, by='channel'][order(channel)]

#export df_relevant and edit channels
#write.csv(df_relevant_channel, "~/Documents/GitHub/esade_fake_news/4_Politics/python3_script/data/channels/20200504-193926_joe_biden_channels_relevant.csv")

#export df_relevant and edit channels
#write.csv(allsides, "~/Documents/GitHub/esade_fake_news/4_Politics/python3_script/data/channels/allsides_bias.csv")

#load cleaned channel dataset
df_updated = fread("~/Documents/GitHub/esade_fake_news/4_Politics/python3_script/data/channels/20200504-193926_joe_biden_channels_relevant.csv", na.strings=c("","NA"), drop=c('Column1'))

#load media bias dataset
media_bias = fread("~/Documents/GitHub/esade_fake_news/4_Politics/python3_script/data/channels/media_bias_data.csv", drop='Website')

#merge cleaned channel dataset with media bias
df_merged = merge(df_updated,
                  media_bias,
                  by.x='media_bias',
                  by.y='News Source')

# 55% of all videos have a media bias
sum(df_merged$N) / nrow(df)

# 75% of relevant videos have a media bias 
sum(df_merged$N) / nrow(df_relevant)

#remove N column
df_merged[, 'N':=NULL]

#complete dataset
df_merged2 = merge(df_relevant,
                   df_merged,
                   by='channel')

#stats
df_merged2[, .N, by=c('Bias','channel')][order(Bias, -N)]

df_merged2[Bias=='Right-Center', .N, by='Bias']

mytable = table(df_merged2$Bias)
prop.table(mytable)


tblFun <- function(x){
  tbl <- table(x)
  res <- cbind(tbl,round(prop.table(tbl)*100,2))
  colnames(res) <- c('Count','Percentage')
  res
}

do.call(rbind,lapply(df_merged2[, 'Bias'],tblFun))
