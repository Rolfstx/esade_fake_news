#Install libraries
#install.packages("RCurl")
#install.packages("jsonlite")
#install.packages("tuber")

#Load libraries
library(RCurl)
library(jsonlite)
library(tuber)
library(data.table)

#Import only unique video IDs
allids <- read.table("GitHub/esade_fake_news/3_Corona/youtube_recommendation_scrapper/data/csv/id_only_corona_2020_04_30.csv", header=TRUE)

#Build a URL to call the API
URL_base='https://www.googleapis.com/youtube/v3/videos?id=' #this is the base URL
URL_details='&part=contentDetails&key='                     #getting contentDetail for technical metadata

###### INSERT API KEY #######
#create API from here: https://console.developers.google.com/
#click on "Credentials" -> "Create Credentials" -> "API KEY" -> Copy paste below in "URL_key"
#enable youtube data api v3: https://console.developers.google.com/apis/library/youtube.googleapis.com
#API has a 10'000 limit request per day. Checked here: https://console.developers.google.com/apis/api/youtube.googleapis.com/quotas

URL_key='AIzaSyCJ3DxCeehOBhM5mCqK4gxJnFj3s4vebC8'


allids2 <- base::as.list(allids)



#### LOOP 1 ####

#Loop through URLS to retrieve basic info (duration, format)
alldata = data.frame()
ptm <- proc.time()                                          #Time responses to the server

# General info - Youtube API part: contentDetails
for(i in 1:nrow(allids)){
  cat('Iteracio', i, '/', nrow(allids), '\n')
  url = paste(URL_base, allids[i, ], URL_details, URL_key, sep = "")
  dd <- getURL(url)
  result <- fromJSON(dd)
  id = result$items$id[[1]]
  duration = result$items$contentDetails$duration
  caption = result$items$contentDetails$caption
  definition = result$items$contentDetails$definition
  alldata = rbind(alldata, data.frame(id, duration, caption, definition))
} 

#write to csv in case something goes wrong.
write.csv(alldata, "GitHub/esade_fake_news/3_Corona/youtube_recommendation_scrapper/data/csv/contentDetails_covid_v1.csv")



#### LOOP 2 ####

# Video info (title, description, etc.) - Youtube API part: snippet
alldata2 = data.frame()
URL_details2='&part=snippet&key='                     #getting snippet for general metadata

## common error -> lexical error (problem with the text) in description field.
## Thus, tryCatch function to skip errors

for(i in 1:nrow(allids)){
  tryCatch({
    cat('Iteracio', i, '/', nrow(allids), '\n')
    url2 = paste(URL_base, allids[i, ], URL_details2, URL_key, sep = "")
    dd2 <- getURL(url2)
    result2 <- fromJSON(dd2)
    id2 = result2$items$id[[1]]
    publishedAt = result2$items$snippet$publishedAt
    channelid = result2$items$snippet$channelId
    channeltitle = result2$items$snippet$channelTitle
    title = result2$items$snippet$title
    description = result2$items$snippet$description
    tag = result2$items$snippet$tags
    category = result2$items$snippet$categoryId
    alldata2 = rbind(alldata2, data.frame(id2, title, description, publishedAt, channelid, channeltitle, category))
  }, error=function(e){cat("Error at row:", i, "\n")}
  )
} 


#write to csv in case something goes wrong.
write.csv(alldata, "GitHub/esade_fake_news/3_Corona/youtube_recommendation_scrapper/data/csv//contentDetails_covid_v1.csv")

#### LOOP 3 ####

# change API key ##########
# if you have another google account, create an API key for that account. 
# if you don't wait 24 hours to have enough credits to start. 
URL_key=''

# Video statistics (likes, views, etc.) - Youtube API part: statistics
alldata3 = data.frame()
URL_details3='&part=statistics&key='                     #getting statistics for technical metadata

## common error -> comments are disabled, which returns an error.
## Thus, tryCatch function to skip errors

for(i in 1:nrow(allids)){
  tryCatch({
    cat('Iteracio', i, '/', nrow(allids), '\n')
    url3 = paste(URL_base, allids[i, ], URL_details3, URL_key, sep = "")
    dd3 <- getURL(url3)
    result3 <- fromJSON(dd3)
    id3 = result3$items$id[[1]]
    views = result3$items$statistics$viewCount
    likes = result3$items$statistics$likeCount
    dislikes = result3$items$statistics$dislikeCount
    favorite = result3$items$statistics$favoriteCount
    comments = result3$items$statistics$commentCount
    alldata3 = rbind(alldata3, data.frame(id3, views, likes, dislikes, favorite, comments))
  }, error=function(e){cat("Error at row:", i, "\n")}
  )
} 

#write to csv in case something goes wrong.
write.csv(alldata3,"GitHub/esade_fake_news/3_Corona/youtube_recommendation_scrapper/data/csv//statistics_covid_v1.csv")


#### LOOP 4 ####

#retrieve category of each video

alldata6 = data.frame()
URL_base2='https://www.googleapis.com/youtube/v3/videoCategories?id='
URL_details4='&part=snippet&key='  

for(i in 1:nrow(unique_category)){
  tryCatch({
    cat('Iteracio', i, '/', nrow(unique_category), '\n')
    url4 = paste(URL_base2, unique_category[i, ], URL_details4, URL_key, sep = "")
    dd4 <- getURL(url4)
    result4 <- fromJSON(dd4)
    id4 = result4$items$id[[1]]
    category = result4$items$snippet$title
    alldata6 = rbind(alldata6, data.frame(id4, category))
  }, error=function(e){cat("Error at row:", i, "\n")}
  )
}


# Save files as
alldata4 = merge(alldata, alldata2, by.x='id', by.y="id2")
alldata5 = merge(alldata4, alldata3, by.x='id', by.y="id3")

unique_category = data.frame(unique(alldata5$category))
write.csv(unique_category, "GitHub/esade_fake_news/3_Corona/youtube_recommendation_scrapper/data/csv/covid_category_list.csv")
alldata7 = merge(alldata5, alldata6, by.x='category', by.y="id4", all=TRUE)




write.csv(alldata7, "GitHub/esade_fake_news/3_Corona/youtube_recommendation_scrapper/data/csv/corona_API_COMPLETE_V2.csv")

#Group by category to check distribution of videos against categories.
alldata8 = setDT(alldata7)
alldata8[, .N, by='category.y']
