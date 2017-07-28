#dplyr_exercise_2017.07.26
library(readr)
rank20170726 <- read_csv("E:/workspace_r/rank20170726.csv")
View(rank20170726)

rank_top10<-rank20170726 %>% 
  select(pid,sname,score,label3,tagname) %>%  
  group_by(label3) %>% 
  arrange(desc(score)) %>% 
  do(head(.,10))

rank_last10<-rank20170726 %>% 
  select(pid,sname,score,label3,tagname) %>%  
  group_by(label3) %>% 
  arrange(score) %>% 
  do(head(.,10))

rank_notutf8<-read.csv("E:/workspace_r/rank_notutf8.csv",header = T)

sample_n(rank_top10,3)
sample_frac(rank_top10,0.1)
distinct(rank_top10["tagname"])#not rank_top10$tagname
distinct(rank_top10,tagname,.keep_all = TRUE)
distinct(rank_top10,tagname,labels,.keep_all = TRUE)


class(rank_top10)
rank_top10<-data.frame(rank_top10)

names(rank_top10)
View(select(rank_top10,-pid,-label3))
View(select(rank_top10,-c(pid,label3)))


View(select(rank_top10,-starts_with("s")))
View(select(rank_top10,-ends_with("s")))
View(select(rank_top10,contains("a")))
View(select(rank_top10,tagname,score,everything()))


View(rename(rank_top10,Label_3=label3))#new=old

View(filter(rank_top10,label3=10101))
View(filter(rank_top10,label3!=10101))

View(filter(rank_top10,label3 %in% c(10101,70201)))
View(filter(rank_top10,!label3 %in% c(10101,70201)))

View(filter(rank_top10,label3 %in% c(10101,70201,70301) & score>700))
View(filter(rank_top10,!label3 %in% c(10101,70201,70301) & score>700))

View(filter(rank_top10,grepl("网",sname))) #not only starts_with/ends_with

summarise(rank_top10,score_mean=mean(score))

summarise_at(rank_top10,vars(score,pid),funs(n(),mean,median))

summarise_at(rank_top10,vars(score,pid),funs(n(),missing=sum(is.na(.)),mean(.,na.rm=T),median(.,na.rm = T)))

summarise_if(rank_top10,is.numeric,funs(n(),mean,median))

summarise_all(rank_top10["tagname"],funs(nlevels(.),sum(is.na(.))))

View(arrange(rank_top10,score))

View(arrange(rank_top10,score,label3))
View(arrange(rank_top10,score,desc(label3)))


View(filter(rank_top10,tagname=="游戏开发"))

View(rank_top10 %>% 
       select(label3,score) %>% 
       group_by(label3) %>% 
       summarise(score_mean=mean(score)))

View(rank_top10 %>% 
       filter(score >800) %>% 
       group_by(label3) %>% 
       do(head(.,2)))

View(rank_top10 %>% 
       filter(score >600) %>% 
       group_by(label3) %>% 
       arrange(desc(score)) %>% 
       slice(3))

View(rank_top10 %>% 
       filter(score >600) %>% 
       arrange(desc(score)) %>% 
       filter(min_rank(tagname)==2))#min_rank 通用排名，并列的名次结果一样，占用下一名次


View(mutate(rank_top10,change=score/1000))

View(mutate_at(rank_top10,vars(sname:tagname),funs(Rank=min_rank(.))))
View(mutate_at(rank_top10,vars(sname:tagname),funs(Rank=min_rank(desc(.)))))

union(x,y)#
union_all(x,y)#allow duplicate

setdiff(x,y)

View(rank_top10 %>% rowwise() %>% 
  mutate(Max=max(pid,label3)))#rowwise() allow apply functions to rows

View(bind_rows(rank_top10,rank_last10))
View(bind_cols(rank_top10,rank_last10))

View(mutate_if(rank_top10,is.numeric,funs("new"=.*1000)))

###########################END################################