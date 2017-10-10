#https://mp.weixin.qq.com/s?__biz=MzI5MzQzMjU4Mw==&mid=2247485852&idx=1&sn=5228b3e963aa37d6770bed11f5257fd8&chksm=ec7375f4db04fce247df2b1e3d5125238a116b165620d7d2f4b7fef6c36002ec0d74eb845f4e&scene=0#rd
#R语言数据清洗实战——世界濒危遗产地数据爬取案例

library(rvest)
url <-
  "https://en.wikipedia.org/wiki/List_of_World_Heritage_in_Danger"
webpage <- read_html(url)
mydata <- html_nodes(webpage, "td ,th")
data <- html_text(mydata)
# head(data,100)
# View(data)

library(stringr)
which(
  data == "Map this section's coordinates using OSMMap this section's coordinates using Google"
)
data[1:10]#1-5
data[483:487]
data[488:496]

col_names <- data[6:14]
# col_names
data_new <- data[-c(c(1:14), c(483:496))]

# head(data_new)
# length(data_new)
# class(data_new)

N <- seq(1, length(data_new), by = 9)
heritage <- data.frame()
for (i in N) {
  temp <- data.frame(t(data_new[i:(i + 8)]),stringsAsFactors = FALSE)
  heritage <- rbind(heritage, temp)
}

colnames(heritage) <- col_names
heritage <- heritage[-nrow(heritage), ]
heritage <- heritage[, -2]


heritage$long <- heritage$Location %>%
  str_extract("-?\\d{1,2}\\.\\d{1,}; -?\\d{1,3}\\.\\d{1,}") %>%
  strsplit(";") %>%
  sapply("[[", 1) %>%
  as.numeric
heritage$lat <- heritage$Location %>% 
  str_extract("-?\\d{1,2}\\.\\d{1,}; -?\\d{1,3}\\.\\d{1,}") %>% 
  strsplit(";") %>% 
  sapply("[[", 2) %>% 
  as.numeric

#Error in strsplit(., ",") : non-character argument:data.frame(...,stringsAsFactors = FALSE)
heritage$Address<-heritage$Location %>% strsplit(",") %>% sapply("[[",1)
heritage$Criteria<-heritage$Criteria %>% strsplit(":") %>% sapply("[[",1)
heritage<-heritage[,c("Name","Criteria","Address","Year (WHS)","long","lat","Reason")]  %>% rename("Year"="Year (WHS)")  
heritage$Year<-as.numeric(heritage$Year)

# View(heritage)
#数据处理结束

#绘图
library(RColorBrewer)
library(ggthemes)
library(maps)
library(ggplot2)
world_map<-map_data("world")#从maps包中提取世界地图


ggplot()+ 
  geom_polygon(data=world_map,aes(x=long,y=lat,group=group),col="grey60",fill="white",size=.2,alpha=.4)+
  geom_point(data=heritage,aes(x=long,y=lat,shape=Criteria,fill=Criteria),size=3,colour="white")+ 
  scale_shape_manual(values=c(21,22))+
  scale_fill_wsj()+
  labs(title="世界濒危文化遗产分布图",caption="数据来源：维基百科")+   
  theme_void(base_size=15) %+replace%
  theme(
    plot.title=element_text(size=25,hjust=0),
    plot.caption=element_text(hjust=0),       
    legend.position = c(0.05,0.55),
    plot.margin = unit(c(1,0,1,0), "cm")
  )


# gc();gc()
