#Detele observations with error in parsing JSON (snippet part in Youtube's API)
allids2 <- allids[-c(262, 514, 513, 557, 581, 669, 765, 802, 1023, 1030, 1173, 1209, 1278, 1325),]
allids2 <- allids[-c(1354, 1444, 1570, 1774, 1806, 2001, 2171, 2234),]


for(i in 2235:nrow(allids2)){
  cat('Iteracio', i, '/', nrow(allids2), '\n')
  url2 = paste(URL_base, allids2[i, ], URL_details2, URL_key, sep = "")
  dd2 <- getURL(url2)
  result2 <- fromJSON(dd2)
  id2 = result2$items$id[[1]]
  publishedAt = result2$items$snippet$publishedAt
  channelid = result2$items$snippet$channelId
  channeltitle = result2$items$snippet$channelTitle
  title = result2$items$snippet$title
  description = result2$items$snippet$description
  alldata2 = rbind(alldata2, data.frame(id2, title, description, publishedAt, channelid, channeltitle))
} 

#Detele observations with error in parsing JSON (statistics part in Youtube's API)
allids3 <- allids[-c(8, 19, 33, 83, 97, 112, 166, 256, 271, 279, 283),]
allids3 <- allids[-c(301, 312, 337, 340, 398, 400, 423, 425, 429, 451),]
allids3 <- allids[-c(464,547, 549, 586, 602, 613, 618, 649, 654, 688),]
allids3 <- allids[-c(696, 736, 755, 810, 811, 818, 879, 901, 932, 935),]
allids3 <- allids[-c(972, 998, 1024, 1038, 1097, 1129, 1151, 1192, 1204),]
allids3 <- allids[-c(1221, 1265, 1304, 1373, 1381, 1442, 1489, 1490, 1492),]
allids3 <- allids[-c(1496, 1515, 1530, 1543, 1547, 1566, 1595, 1600),]
allids3 <- allids[-c(1625, 1652, 1675, 1682, 1724, 1727, 1729, 1744, 1747),]
allids3 <- allids[-c(1831, 1898, 1954, 1957, 1964, 1981, 1988, 2011, 2020),]
allids3 <- allids[-c(2090, 2136, 2156, 2298, 2301, 2306, 2320, 2342, 2354),]
allids3 <- allids[-c(2368, 2394, 2416, 2473, 2486, 2504, 2516, 2566, 2585),]
allids3 <- allids[-c(2389, 2602, 2613, 2623),]


for(i in 2624:nrow(allids3)){
  cat('Iteracio', i, '/', nrow(allids3), '\n')
  url3 = paste(URL_base, allids3[i, ], URL_details3, URL_key, sep = "")
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


