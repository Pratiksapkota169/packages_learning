rm(list = ls())
gc()

library(rvest)

url<-"https://mp.weixin.qq.com/s?__biz=MjM5ODY0NTQ4Mg==&mid=2658746726&idx=1&sn=0f7e43171d43d268805424341592e801&chksm=bd4a7ae38a3df3f5434057be3507cca0dd51e2d00daa94adeb0e1814397eb0a411271c2adc32&scene=0#rd"
webpage<-read_html(url)

data_html<-html_nodes(webpage,"td")
data<-html_text(data_html)

test<-as.list(data)



start_index_新三板定增<-which(data=="定增金额",arr.ind = TRUE)-2
end_index_新三板定增<-length(test)

start_index_新三板挂牌<-which(data=="代码",arr.ind = TRUE)-1
end_index_新三板挂牌<-start_index_新三板定增-1

start_index_IPO事件<-which(data=="上市企业",arr.ind = TRUE)
end_index_IPO事件<-start_index_新三板挂牌-1

start_index_并购事件<-which(data=="被并购方",arr.ind = TRUE)
end_index_并购事件<-start_index_IPO事件-1




#新三板定增部分
新三板定增<-list()
N<-seq(start_index_新三板定增,end_index_新三板定增,by=4)

for(i in N){
  temp<-rbind(test[i:(i+3)])
  新三板定增<-rbind(新三板定增,temp)
}

新三板定增<-data.frame(新三板定增)

names(新三板定增)<-c(新三板定增$X1[1],新三板定增$X2[1],新三板定增$X3[1],新三板定增$X4[1])

新三板定增<-新三板定增[-1,]
# View(新三板定增)


#新三板挂牌部分
新三板挂牌<-list()
N<-seq(start_index_新三板挂牌,end_index_新三板挂牌,by=4)

for(i in N){
  temp<-rbind(test[i:(i+3)])
  新三板挂牌<-rbind(新三板挂牌,temp)
}

新三板挂牌<-data.frame(新三板挂牌)

names(新三板挂牌)<-c(新三板挂牌$X1[1],新三板挂牌$X2[1],新三板挂牌$X3[1],新三板挂牌$X4[1])

新三板挂牌<-新三板挂牌[-1,]
# View(新三板挂牌)


#IPO事件部分
IPO事件<-list()
N<-seq(start_index_IPO事件,end_index_IPO事件,by=4)

for(i in N){
  temp<-rbind(test[i:(i+3)])
  IPO事件<-rbind(IPO事件,temp)
}

IPO事件<-data.frame(IPO事件)

names(IPO事件)<-c(IPO事件$X1[1],IPO事件$X2[1],IPO事件$X3[1],IPO事件$X4[1])

IPO事件<-IPO事件[-1,]
# View(IPO事件)


#并购事件部分
并购事件<-list()
N<-seq(start_index_并购事件,end_index_并购事件,by=6)

for(i in N){
  temp<-rbind(test[i:(i+5)])
  并购事件<-rbind(并购事件,temp)
}

并购事件<-data.frame(并购事件)

names(并购事件)<-c(并购事件$X1[1],并购事件$X2[1],并购事件$X3[1],并购事件$X4[1],并购事件$X5[1],并购事件$X6[1])

并购事件<-并购事件[-1,]
# View(并购事件)




#行业部分
test<-test[1:(start_index_并购事件-1)]

title_index_行业<-which(test=="轮次",arr.ind = TRUE)-4
test<-test[-title_index_行业]

title<-c("企业","主营业务","所在地","轮次","金额","投资人","所属行业")


行业<-list()
N<-seq(1,length(test),by=7)

for(i in N){
  temp<-rbind(test[i:(i+6)])
  行业<-rbind(行业,temp)
}

行业<-data.frame(行业)

names(行业)<-title

行业<-filter(行业,企业!="企业")


