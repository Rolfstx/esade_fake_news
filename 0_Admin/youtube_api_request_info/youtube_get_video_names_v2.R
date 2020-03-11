#Install libraries
install.packages("RCurl")
install.packages("jsonlite")
install.packages("tuber")

#Load libraries
library(RCurl)
library(jsonlite)
library(tuber)

#Clean the list, remove the datestamps and keep unique IDs, as soom are repeated
allids <- read_csv("~/Dropbox (IESE)/PhD/PhD Thesis/Algorithm Youtube/vid_id_list_science_vertical.csv", col_names = FALSE)
allids <- unique(allids)

#Build a URL to call the API
URL_base='https://www.googleapis.com/youtube/v3/videos?id=' #this is the base URL
URL_details='&part=contentDetails&key='                     #getting contentDetail for technical metadata
URL_key='AIzaSyDR7gW29gCGg_KD1jPioOPbD3Jso0diC4w'
cred <- yt_oauth(app_id = "677364780411-hcer7htd1l0v22b1jejj22b9gbq38mqc.apps.googleusercontent.com", app_secret = "lqj6o-wM0F4xQ1hoTrC3Y65Y", scope = "ssl", token = ".httr-oauth")
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
  alldata2 = rbind(alldata2, data.frame(id2, title, description, publishedAt, channelid, channeltitle))
} 

# Video statistics (likes, views, etc.) - Youtube API part: statistics
alldata3 = data.frame()
URL_details3='&part=statistics&key='                     #getting statistics for technical metadata

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
#alldata = 
#alldata2 =
#alldata3 =

# Visualize some variables
youtube_likes_comments_v1 <- read_excel("~/Dropbox (IESE)/PhD/PhD Thesis/Algorithm Youtube/Datasets Test/youtube_likes_comments_v1.xlsx")
dataset <- youtube_likes_comments_v1

# Views
ggplot(dataset,aes(views)) + geom_histogram(colour="darkblue", size=1, fill="blue") + scale_x_continuous(labels = comma)

# Likes
ggplot(dataset,aes(likes)) + geom_histogram(colour="darkred", size=1, fill="red") + scale_x_continuous(labels = comma)

# Comments
ggplot(dataset,aes(comments)) + geom_histogram(colour="darkgreen", size=1, fill="green") + scale_x_continuous(labels = comma)




