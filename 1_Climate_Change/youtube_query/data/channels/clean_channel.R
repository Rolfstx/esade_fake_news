library(data.table)
library(dplyr)
library(tidyverse)
test_data = fread("~/Documents/GitHub/esade_fake_news/1_Climate_Change/youtube_query/data/channels/20200507-033205_climate_change_channels.csv", na.strings=c("","NA"))
test_channel = fread("~/Documents/GitHub/esade_fake_news/1_Climate_Change/youtube_query/data/channels/media_bias_data.csv", drop='Website')

news_source = test_channel[,"News Source"]
news_source2 <- data.frame(news_source, news_source)
colnames(news_source2) <- c("channel", "news_source")
setDT(news_source2)
head(news_source2)

new_test_data = merge(test_data, news_source2, by.x = "channel", by.y = "channel", all.x = TRUE)

write.csv(new_test_data, "~/Documents/GitHub/esade_fake_news/1_Climate_Change/youtube_query/data/channels/20200507-033205_climate_change_channels_clean.csv")

df = fread("~/Documents/GitHub/esade_fake_news/1_Climate_Change/youtube_query/data/channels/20200507-033205_climate_change_channels_clean.csv", na.strings=c("","NA"))

head(df)
df <- df %>% drop_na()

write.csv(df, "~/Documents/GitHub/esade_fake_news/1_Climate_Change/youtube_query/data/channels/20200507-033205_climate_change_channels_clean.csv")

?drop_na
