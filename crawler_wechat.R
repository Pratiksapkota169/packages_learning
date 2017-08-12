library(rvest)


url<-"https://mp.weixin.qq.com/s?__biz=MjM5ODY0NTQ4Mg==&mid=2658746726&idx=1&sn=0f7e43171d43d268805424341592e801&chksm=bd4a7ae38a3df3f5434057be3507cca0dd51e2d00daa94adeb0e1814397eb0a411271c2adc32&scene=0#rd"
webpage<-read_html(url)
webpage


data_html<-html_nodes(webpage,"td")
data<-html_text(data_html)
head(data)
class(data)
typeof(data)

test<-as.list(data)
View(test)
head(test)

names(test)

start_index_行业<-which(data=="所在地",arr.ind = TRUE)-2
end_index_行业<-which(data=="所属行业",arr.ind = TRUE)

start_index_并购事件<-which(data=="被并购方",arr.ind = TRUE)
end_index_并购事件<-which(data=="收购金额",arr.ind = TRUE)

start_index_IPO事件<-which(data=="上市企业",arr.ind = TRUE)
end_index_IPO事件<-which(data=="募集金额",arr.ind = TRUE)

start_index_新三板挂牌<-which(data=="代码",arr.ind = TRUE)-1
end_index_新三板挂牌<-which(data=="行业",arr.ind = TRUE)

start_index_新三板定增<-which(data=="定增金额",arr.ind = TRUE)-2
end_index_新三板定增<-which(data=="定增金额",arr.ind = TRUE)+1


#新三板定增
b<-list()
N<-seq(1255,length(test),by=4)
#N
for(i in N){
    a<-rbind(test[i:(i+3)])
    b<-rbind(b,a)
}

c<-data.frame(b)
View(c)

names(c)<-c(c$X1[1],c$X2[1],c$X3[1],c$X4[1])

d<-c[-1,]
View(d)

