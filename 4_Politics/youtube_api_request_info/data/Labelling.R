library(data.table)

df = fread("~/Documents/GitHub/esade_fake_news/4_Politics/youtube_api_request_info/data/biden_w_category_v1.csv")

df2 = df[, c('id', 'title', 'description','channeltitle','category.y')]

write.csv(df2, "~/Documents/GitHub/esade_fake_news/4_Politics/youtube_api_request_info/data/biden_labelling.csv")
