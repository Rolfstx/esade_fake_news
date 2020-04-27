#Install libraries
#install.packages("RCurl")
#install.packages("jsonlite")
#install.packages("tuber")


#Load libraries
library(RCurl)
library(jsonlite)
library(tuber)

#Clean the list, remove the datestamps and keep unique IDs, as soom are repeated
allids <- read.table("~/Documents/GitHub/esade_fake_news/4_Politics/youtube_recommendation_scrapper/data/csv/biden_20200427_unique_ids.csv", header=TRUE)

allids <- unique(allids)

#Build a URL to call the API
URL_base='https://www.googleapis.com/youtube/v3/videos?id=' #this is the base URL
URL_details='&part=contentDetails&key='                     #getting contentDetail for technical metadata
URL_key=''
#cred <- yt_oauth(app_id = "USE YOUR APP_ID", app_secret = "USE YOUR APP_SECRET", scope = "ssl", token = ".httr-oauth")
allids2 <- base::as.list(allids)

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

# Video info (title, description, etc.) - Youtube API part: snippet
alldata2 = data.frame()
URL_details2='&part=snippet&key='                     #getting snippet for general metadata

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



# Video statistics (likes, views, etc.) - Youtube API part: statistics
alldata3 = data.frame()
error3=0
URL_details3='&part=statistics&key='                     #getting statistics for technical metadata

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
  }, error=function(e){cat("Error at row:", i, "\n")
      error3= error3 + 1}
  )
} 

for(i in 1:nrow(allids)){
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
}

# Save files as
alldata4 = merge(alldata, alldata2, by.x='id', by.y="id2")
alldata5 = merge(alldata4, alldata3, by.x='id', by.y="id3")

write.csv(alldata5, "data/test.csv")

# Visualize some variables
youtube_likes_comments_v1 <- read_excel("~/Dropbox (IESE)/PhD/PhD Thesis/Algorithm Youtube/Datasets Test/youtube_likes_comments_v1.xlsx")
dataset <- youtube_likes_comments_v1

# Views
ggplot(dataset,aes(views)) + geom_histogram(colour="darkblue", size=1, fill="blue") + scale_x_continuous(labels = comma)

# Likes
ggplot(dataset,aes(likes)) + geom_histogram(colour="darkred", size=1, fill="red") + scale_x_continuous(labels = comma)

# Comments
ggplot(dataset,aes(comments)) + geom_histogram(colour="darkgreen", size=1, fill="green") + scale_x_continuous(labels = comma)


'https://www.googleapis.com/youtube/v3/videoCategories?part=snippet&id=25&key=AIzaSyDshWBYU8ibrGWh7bScYa-DCVGA9gumqI0

https://www.googleapis.com/youtube/v3/videoCategories?part=snippet&id=25&key=AIzaSyDshWBYU8ibrGWh7bScYa-DCVGA9gumqI0

https://www.googleapis.com/youtube/v3/guideCategories