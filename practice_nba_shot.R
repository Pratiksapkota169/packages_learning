#learn from:https://mp.weixin.qq.com/s?__biz=MzA3MTM3NTA5Ng==&mid=2651056641&idx=2&sn=6290688dcaad12a1fb02f2fd68a864ae&chksm=84d9cb96b3ae4280c6fe5e5ed8551c621b60031e52c885757e2cfcf840c95512622f70874b0e&mpshare=1&scene=1&srcid=09227OK55WMxJXdjlQNzm44Q#rd

#分析目标（探索性分析）：
#1.现今NBA球员们的投篮选择有何偏好？
#2.球员们的投篮命中率都与哪些因素有关？
#3.主客场真的对球员们表现、球队胜负有那么大影响吗？
#4.现今联盟里有哪些关键先生？
#5.哪些球员防守好，哪些球员防守差？


nba_shots<-read.csv("shot_logs.csv")
dim(nba_shots)#数据量
str(nba_shots)#数据结构

names(nba_shots)

library(dplyr)
library(ggplot2)

#1.球员们的投篮选择
ggplot(nba_shots,aes(SHOT_DIST))+geom_histogram()
#由于投篮距离的直方图分布可见，现今球员的投篮距离是双峰分布，
#容易解释的是球员们在投篮上更偏向于冲击篮下突破或者选择三分线外发炮，
#而中距离出手明显较少，禁区内距离为0-10英尺，三分线为22英尺

ggplot(nba_shots,aes(CLOSE_DEF_DIST))+geom_histogram()+xlim(0,22)
#从防守人位置分布图中看出，大多数投篮发生时防守人并未完全失位，
#5英尺以内防守人对投篮球员有足够的威胁，只有少数快攻发生时防守球员
#不在位置而放弃防守，一方面可见NBA比赛强度可观，另一方面也体现了NBA
#球员们的技战术水平

#2.球员命中率和哪些因素有关
#球场上防守强度的高低决定了对手的投篮命中率
#选取投篮距离SHOT_DIST、防守人距离CLOSE_DEF_DIST、投篮结果
#SHOT_RESULT、运球次数DRIBBLES、触球时间TOUCH_TIME
ggplot(nba_shots,aes(SHOT_DIST,CLOSE_DEF_DIST))+
  geom_point(aes(color=factor(SHOT_RESULT)))+
  geom_vline(xintercept = c(15,22),color="blue")
#由上图可以看出，命中次数在近篮筐处有一个垂直分布，而防守人
#也不知所踪，这是由于防守反击造成的快攻上篮或者扣篮而通常
#防守人还在后场早已放弃防守所致，在罚球线（15英尺）和三分线
#（22英尺）处画了两条蓝线，篮下到罚球线距离之间明显有一个低谷
#这也反映了当前在NBA球队中距离投篮不受重视，而三分线附近则有
#一个投篮的密集分布，各支球队在三分线上的攻防也做足文章，
#显然，在大量的三分球战术下，各支球队在三分线外的命中率仍然不高
#当然，整体命中率依然是从篮下到三分线逐渐下降的分布趋势

ggplot(nba_shots,aes(DRIBBLES,TOUCH_TIME))+
  geom_point(aes(color=factor(SHOT_RESULT)))+ylim(-10,20)
#球员的投篮命中率与运球次数、触球时间并没有明显相关关系，
#接球就投（零运球）的情况下NBA球员通常都有一个较高的命中率
#因为通常战术跑出来之后，某位球员出现空位的几率比较大，无论是
#三分球远射还是飞起扣篮，命中率都是极高的。在长时间运球与触球
#的情形下，虽然防守人能做好针对性防守，但此时一半球星都能通过
#运球找到节奏，再想防住他们的投篮困难就比较大了

#3.主客场对球员表现和球队输赢影响大吗
#选取主客场Location、投篮命中次数FGM、通过FGM构造命中率
home_away<-nba_shots %>% group_by(LOCATION) %>% 
  summarise(PERCENTAGE=sum(FGM)/length(FGM)*100)
home_away
#主客场球队的命中率并无明显差别，但就是这0.8个投篮百分点的差异
#足以让胜负翻转

wins<-nba_shots %>% group_by(GAME_ID,LOCATION) %>% 
  filter(W=="W",FGM==1)
View(wins)
ggplot(data = wins,aes(LOCATION,fill=factor(W)))+geom_bar()
#对比到输赢上，查了几千场胜利

#4.现今联盟里有哪些关键先生
#通过dplyr里的filter函数筛选出PERIOD==1,SHOT_DIST>5,然后用
#group_by对球员姓名进行数据分组，summarise函数归纳技术统计，
#mutate函数变形数据框将命中率变量加入，arrange函数对变量重排序
#降序处理
first_quarter_guys<-nba_shots %>% filter(PERIOD==1,SHOT_DIST>5) %>% 
  group_by(player_name) %>% 
  summarise(made=sum(FGM),
            points=sum(PTS),
            total_attempts=length(FGM),
            ave_touch=mean(TOUCH_TIME),
            ave_distance=mean(SHOT_DIST)) %>% 
  mutate(percentage=made/total_attempts*100) %>% 
  arrange(desc(percentage)) %>% 
  filter(total_attempts>200)
best_1st<-data.frame(first_quarter_guys)
best_1st
first_quarter_guys
#第一节得分最多的是JJ.雷迪克？这跟快船队的战术有关啦，第一节的比赛保罗
#和全队都是找雷迪克的，各种三分出手

#如果说先赢不叫赢，第一节得分不关键的话，我们再来看看在决定球队胜负的第四节，
#联盟中又有哪些关键先生
fourth_quarter_guys<-nba_shots %>% filter(PERIOD==4,SHOT_DIST>5) %>%
  group_by(player_name) %>% 
  summarise(made=sum(FGM), 
            points=sum(PTS),
            total_attempts=length(FGM), 
            ave_touch=mean(TOUCH_TIME),
            ave_distance=mean(SHOT_DIST)) %>%
  mutate(percentage=made/total_attempts*100) %>%
  arrange(desc(percentage)) %>% filter(total_attempts > 150)
best_4th<-data.frame(fourth_quarter_guys)
best_4th

#5.最好、最差的防守球员是谁
#防守最好，即shot_result==missed
nba_shots %>% 
  filter(SHOT_RESULT=="missed") %>% 
  group_by(CLOSEST_DEFENDER) %>% 
  summarise(GoodDefense=n()) %>% 
  ungroup %>% 
  arrange(desc(GoodDefense)) %>% 
  head
#n():The number of observations in the current group

#防守最差，即shot_result==made
nba_shots %>% 
  filter(SHOT_RESULT=="made") %>% 
  group_by(CLOSEST_DEFENDER) %>%
  summarise(BadDefense=n()) %>% 
  ungroup %>% 
  arrange(desc(BadDefense)) %>% 
  head
  
#######################Done##############################