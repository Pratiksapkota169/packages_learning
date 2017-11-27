#learn from:http://mp.weixin.qq.com/s?__biz=MzA3Njc0NzA0MA==&mid=2653192074&idx=1&sn=7818fd94ed84a7400abe012bcd9b09dc&chksm=848c47c5b3fbced3521565ebc8e3336f9007acdf67a4613a4b38983f7614175a60e85f42ae85&mpshare=1&scene=1&srcid=1121FbV3DZu4ju2yuMzemvBn#rd

library(rvest)
URL <-"https://www.aqistudy.cn/historydata/monthdata.php?city=北京" %>% 
  xml2::url_escape(reserved ="][!$&'()*+,;=:/?@#")
URL


library(RCurl)
header<-c("User-Agent"="Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.79 Safari/537.36")
mytable <- getURL(URL,httpheader=header,.encoding="UTF-8") %>%
  htmlParse(encoding ="UTF-8") %>%
  readHTMLTable(header=TRUE)


mytable<-URL %>% read_html(encoding = "UTF-8") %>% 
  html_table(header=TRUE) %>% `[[`(1)


stopifnot(Sys.which("phantomjs") != "")

# devtools::install_github("cpsievert/rdom",force=TRUE)

# install.packages("devtools")
library(curl)
library(dplyr)

library("rdom")
tbl <- rdom(URL) %>% readHTMLTable(header=TRUE)  %>% `[[`(1)






