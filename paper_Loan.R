#learn from:http://mp.weixin.qq.com/s?__biz=MzA3MTM3NTA5Ng==&mid=2651056984&idx=1&sn=93684ecea988960a9c7ed6a2517296d7&chksm=84d9cacfb3ae43d9114fc16e4279c3603e2d6310e31d2787ce4adcfb8f133516282748eacef0&mpshare=1&scene=1&srcid=1114P8PhUh66unUOgZzYVQGP#rd

#第一步：数据导入
library(readr)
loandata<-read_csv("F:/workspace_r/prosperLoanData.csv")
# View(loandata)
sapply(loandata,class)
str(loandata)#113937 obs. of  81 variables


#第二步：理解数据
#ListingCreationDate:表创建时间
#LoanStatus:贷款状态(Completed、Current、Defaulted、Chargedoff等)
#EmploymentStatus:受雇佣状态(Self-employed、Employed等)
#EmploymentStatusDuration:受雇佣状态持续时间(以月为计算单位)
#IsBorrowHomeowner:借款人是否拥有房屋
#CreditScoreRangeLower/CreditScoreRangeUpper:消费信用最低/最高分
#InquiriesLast6Months:最近6个月查过多少次征信记录
#BorrowerRate:借款标利率(作为P2P平台资金借贷价格的代理变量，BorrowRate不包含
#其他费用，是筹资者付给投资人的报酬，也是融资最直接和最重要的成本，其体现了资金
#供求双方在综合考虑各种因素情况下所认可的资金使用成本)
#Term:期限(筹资者通过网贷平台进行借款时所承诺的最终偿还期限，借款期限体现该
#资产的流动性，期限较长的资产应存在着流动性溢价(利率上涨))
#CreditGrade/ProsperRating(Alpha):信用等级(前者反映的是2009年7月1日前客户的
#信用等级，后者反映的是2009年7月1日后的信用等级，信用等级越高，其偿债能力越强)
#CreditScore:由消费信用公司提供的消费信用评分，类似于国内的芝麻信用分
#StatedMonthlyIncome:客户月收入(月收入越高，投资者对该借款本息按时回流越有信心)
#DelinquenciesLast7Years:信用资料提交时借款人过去7年违约次数(该指标在一定程度
#上可以体现借款标的发布者的信用状况)
#BankcardUtilization:信用资料提交时借款人信用卡使用额度和信用卡总透支额度的百分比
#LoanOriginalAmount:借款人在借款时已经向prosper借入的资金，如果没有历史记录则为0，
#(借入的本金越多，其还款压力越大，但是这项指标大的话也可能说明该客户对prosper依赖性较强)
#DebtToIncomeRatio:借款人的债务收入比(债务收入比越高说明筹资者财务状况越差，还款能力
#较低，其向P2P平台借款时，投资者应要求有更高的回报)
#Occupation:贷款人职业
#IncomeRange:贷款人年收入范围
#BorrowerState:贷款人所在州
#基于上述数据对贷款状态LoanStatus进行预测模型建立


#第三步：数据预处理
#选择子集
library(dplyr)
#对变量重新命名
names(loandata)#字段名带括号，改为点
names(loandata)[c(14,15,17)]<-c("ProsperRating.numeric",
                                "ProsperRating.Alpha",
                                "ListingCategory.numeric")

#筛选子集
newloandata<-select(loandata,
                    ListingCreationDate,LoanStatus,EmploymentStatus,EmploymentStatusDuration,
                    IsBorrowerHomeowner,CreditScoreRangeLower,CreditScoreRangeUpper,
                    InquiriesLast6Months,BorrowerRate,Term,CreditGrade,ProsperRating.Alpha,
                    StatedMonthlyIncome,DelinquenciesLast7Years,BankcardUtilization,
                    LoanOriginalAmount,DebtToIncomeRatio,Occupation,IncomeRange,BorrowerState,LoanOriginalAmount
                    )
# View(newloandata)


#数据重编码
#主要是对LoanStatus进行重编码，定义"已还款"为"1"，"未还款"为"0"
table(newloandata$LoanStatus)
# Cancelled             Chargedoff              Completed 
#  5                     11992                   38074 
# Current               Defaulted               FinalPaymentInProgress 
#  56576                 5018                    205 
# Past Due (>120 days)  Past Due (1-15 days)    Past Due (16-30 days) 
#  16                    806                     265 
# Past Due (31-60 days) Past Due (61-90 days)   Past Due (91-120 days) 
#  363                   313                     304 


#标签为Past Due的统一归类为PastDue
PastDue <- c("Past Due (1-15 days)","Past Due (16-30 days)",
             "Past Due (31-60 days)","Past Due (61-90 days)",
             "Past Due (91-120 days)","Past Due (>120 days)")

newloandata$LoanStatus[newloandata$LoanStatus %in% PastDue] <- "PastDue"

#Cancelled归类到Current中
newloandata$LoanStatus[newloandata$LoanStatus == "Cancelled"] <- "Current"

#Defaulted归类到Chargedoff中
newloandata$LoanStatus[newloandata$LoanStatus == "Defaulted"] <- "Chargedoff"

#FinalPaymentInProgress归类为Completed
newloandata$LoanStatus[newloandata$LoanStatus == "FinalPaymentInProgress"] <- "Completed"

#查看数据
table(newloandata$LoanStatus)


#将PastDue归类到completed中，属于还款状态
newloandata$LoanStatus[newloandata$LoanStatus=="PastDue"]<-"Completed"

#将正在进行中的数据删除，也就是current数据删除
newloandata <- newloandata[!(newloandata$LoanStatus=="Current"),]

#再次查看数据
table(newloandata$LoanStatus)


#将LoanStatus用0和1表示未还款、已还款：
#将Completed赋值为1，属于已还款状态
newloandata$LoanStatus[newloandata$LoanStatus == "Completed"]<-"1"

#将Chargedoff赋值为0，属于未还款状态
newloandata$LoanStatus[newloandata$LoanStatus == "Chargedoff"]<-"0"

#再次查看数据
table(newloandata$LoanStatus)


#查看是否有缺失值
data<-sapply(newloandata, function(x) sum(is.na(x)))
data1<-data[data!=0]
data1

#install.packages("Amelia")
library(Amelia)
missmap(newloandata,main="Missing Value of Loandata")

#缺失值排在前三的是CreditGrade、ProsperRating.Alpha、EmploymentStatusDuration
#其中前两个是信用等级，是由于2009年7月后prosper平台对评级名词产生了变化，第三个
#是受雇佣状态保持时间，这三个指标都对贷款状态有影响，所以需要对缺失值进行补全


#补全缺失值
#EmploymentStatusDuration补全数值
#首先找到缺失值的位置：
which(newloandata$EmploymentStatusDuration %in% NA)

#查看相对应的EmploymentStatus的情况
newloandata$EmploymentStatus[which(newloandata$EmploymentStatusDuration %in% NA)]

#此处的EmploymentStatus不是"NA"，就是"Not available"，因此可以将缺失的
#EmploymentStatusDuration以"0"补全：
newloandata$EmploymentStatusDuration[which(newloandata$EmploymentStatusDuration %in% NA)] <- "0"

#查找EmploymentStatusDuration是否有缺失值
sapply(newloandata,function(x) sum(is.na(x)))
#EmploymentStatusDuration为0，说明缺失值已完全补充


#EmploymentStatus补全数值
table(loandata$EmploymentStatus)

#用"Not available"补全EmploymentStatus数值:
newloandata$EmploymentStatus[which(newloandata$EmploymentStatus %in% NA)]<-"Not available"
#查找EmploymentStatus是否有缺失值
sapply(newloandata,function(x) sum(is.na(x)))

#将CreditScoreRangeLower/CreditScoreRangeUpper取两者平均值作为一个新的变量
newloandata$CreditScore<-(newloandata$CreditScoreRangeLower+newloandata$CreditScoreRangeUpper)/2

#查看CreditScore的缺失值：
sapply(newloandata, function(x) sum(is.na(x)))
#返回590
#缺失值还是存在，由于属于消费评分，因此可以考虑用中位数补充缺失值

#首先绘图查看是否可以用中位数补充数值：
library(ggplot2)
#install.packages("ggthemes")
library(ggthemes)
ggplot(newloandata,aes(x=CreditScore))+
  geom_density(fill="pink",alpha=0.4)+
  geom_vline(aes(xintercept=median(CreditScore,na.rm = T)),colour="red",linetype="dashed",lwd=1)+
  theme_few()+ggtitle("The density of CreditScore")

#从图中可以看出数值大部分集中在500到750之间，因此可以用中位数补充缺失值：
newloandata$CreditScore[which(newloandata$CreditScore %in% NA)] <- median(newloandata$CreditScore,na.rm = T)
  
sapply(newloandata, function(x) sum(is.na(x)))  


#用中位数补全InquiriesLast6Months
ggplot(newloandata,aes(x=InquiriesLast6Months))+
  geom_density(fill="skyblue",alpha=0.4)+
  geom_vline(aes(xintercept=median(InquiriesLast6Months,na.rm = T)),
             colour="red",linetype="dashed",lwd=1)+
  theme_few()+ggtitle("The density of InquiriesLast6Months")

#从图中可以看出数值大部分集中在0到20之间，因此可以用中位数补充缺失值：
newloandata$InquiriesLast6Months[which(newloandata$InquiriesLast6Months %in% NA)] <- median(newloandata$InquiriesLast6Months,na.rm = T)

sapply(newloandata, function(x) sum(is.na(x)))


#DekubqyebcuesLast7Years补全数值
#绘图查看是否可用中位数补全数值
ggplot(newloandata,aes(x=DelinquenciesLast7Years))+
  geom_density(fill="blue",alpha=0.4)+
  geom_vline(aes(xintercept=median(DelinquenciesLast7Years,na.rm = T)),
             colour="red",linetype="dashed",lwd=1)+
  theme_few()+ggtitle("The density of DelinquenciesLast7Years")

#从图中可以看出数值大部分集中在0到10之间，因此可以用中位数补充缺失值
newloandata$DelinquenciesLast7Years[which(newloandata$DelinquenciesLast7Years %in% NA)] <- median(newloandata$DelinquenciesLast7Years,na.rm = T)

sapply(newloandata,function(x) sum(is.na(x)))


#绘图查看是否可以用中位数补充BankcardUtilization数值
ggplot(newloandata,aes(x=BankcardUtilization))+
  geom_density(fill="grey",alpha=0.4)+
  geom_vline(aes(xintercept=median(BankcardUtilization,na.rm = T)),
             colour="red",linetype="dashed",lwd=1)+
  theme_few()+ggtitle("The density of BankcardUtilization")

newloandata$BankcardUtilization[which(newloandata$BankcardUtilization %in% NA)] <- median(newloandata$BankcardUtilization,na.rm = T)

sapply(newloandata,function(x) sum(is.na(x)))

table(newloandata$BankcardUtilization)
#对BankcardUtilization的数值进行分类：
newloandata$BankcardUse[newloandata$BankcardUtilization < quantile(newloandata$BankcardUtilization, 0.25,"na.rm"=TRUE)]<-"Mild Use"

newloandata$BankcardUse[(newloandata$BankcardUtilization>=quantile(newloandata$BankcardUtilization,0.25,na.rm = TRUE))&
                         (newloandata$BankcardUtilization<quantile(newloandata$BankcardUtilization,0.5,na.rm = TRUE))]<-"Medium Use"

newloandata$BankcardUse[(newloandata$BankcardUtilization>=quantile(newloandata$BankcardUtilization,0.5,na.rm = TRUE))&
                         (newloandata$BankcardUtilization<1)]<-"Heavy Use"
newloandata$BankcardUse[newloandata$BankcardUtilization>=1]<-"Super Use"

newloandata$BankcardUse<-as.factor(newloandata$BankcardUse)
table(newloandata$BankcardUse)


#DebtToIncomeRatio补全
loandata_1<-newloandata[which(newloandata$DebtToIncomeRatio %in% NA),]
names(loandata_1)
loandata_1<-loandata_1[,c(2,17)]
table(loandata_1$LoanStatus)
#0:1496  1:2960

#未还款的比例比较大，可以考虑用四分位对缺失值进行补充
summary(newloandata$DebtToIncomeRatio,na.rm=T)
#Q1是0.13，Q3是0.3
#四分位补充缺失值
newloandata$DebtToIncomeRatio[which(newloandata$DebtToIncomeRatio %in% NA)]<-
  runif(nrow(loandata_1),0.13,0.3)
sapply(newloandata, function(x) sum(is.na(x)))


#Occupation补全数值
table(newloandata$EmploymentStatus[which(newloandata$Occupation %in% NA)])
#Not available:2252   Other:29
#可用Other补充

newloandata$Occupation[which(newloandata$Occupation %in% NA)]<-"Other"
sapply(newloandata, function(x) sum(is.na(x)))


#BorrowerState补全数值
loandata_2<-newloandata[which(newloandata$BorrowerState %in% NA),]
names(loandata_2)
loandata_2<-loandata_2[,c(2,20)]
table(loandata_2$LoanStatus)
#0:1629  1:3883

#未还款占的比例较大，且这是贷款人所在州的标签，因此可以用一个因子代替缺失值
#以"None"补全
newloandata$BorrowerState[which(newloandata$BorrowerState %in% NA)]<-"None"
sapply(newloandata, function(x) sum(is.na(x)))


#CreditGrade/ProsperRating.Alpha补全
#由于这两个值是2009年7月1日前后客户信用等级，因此需要对数据按照2009年7月1日来分割

#CreditGrade缺失值补充，按照2009年7月1日将数据进行分割
newloandata$ListingCreationDate<-as.Date(newloandata$ListingCreationDate)
loandata_before<-newloandata[newloandata$ListingCreationDate<"2009-7-1",]
sapply(loandata_before, function(x) sum(is.na(x)))
#CreditGrade:131

#共有131个缺失值，由于数据量较小，可以忽略不计，因此删除缺失值:
loandata_before<-filter(loandata_before,!is.na(CreditGrade))
sapply(loandata_before, function(x) sum(is.na(x)))


#ProsperRating.Alpha缺失值补充
#按照2009年7月1日将数据进行分割
loandata_after<-newloandata[newloandata$ListingCreationDate>="2009-7-1",]
sapply(loandata_after, function(x) sum(is.na(x)))

##########全部缺失值处理好##########


#第四步：数据计算&显示
#1.受雇佣状态持续时间与贷款状态的关系？
#2.借款人是否有房屋和贷款状态的关系？
#3.消费信用分与贷款状态的关系？
#4.征信记录查询次数与贷款状态的关系？
#5.信用等级与贷款状态的关系？
#6.客户的职业、月收入、年收入与贷款状态的关系？
#7.客户7年内违约次数与贷款状态的关系？
#8.信用卡使用情况与贷款状态的关系？
#9.在Prosper平台是否借款与贷款状态的关系？
#10.债务收入比例与贷款状态的关系？
#11.借款标利率与贷款状态的关系？


#1.受雇佣状态持续时间与贷款状态的关系？
#雇佣时间越长，是不是具备还款能力越好
library(ggplot2)
newloandata$EmploymentStatusDuration<-as.integer(newloandata$EmploymentStatusDuration)
ggplot(data=newloandata,aes(x=EmploymentStatusDuration,color=LoanStatus))+
  geom_line(aes(label=..count..),stat='bin')+
  labs(title="The LoanStatus By EmploymentStatusDuration",
       x="EmploymentStatusDuration",
       y="Count",
       fill="LoanStatus")

#从图中可以看出随着受雇佣时间越长，贷款未还款率降低，到了后期，基本上不存在毁约
#现象，也就是说，一个有稳定工作收入的人，不容易出现贷款毁约，不还款


#2.借款人是否有房屋和贷款状态的关系？
mosaicplot(table(newloandata$IsBorrowerHomeowner,newloandata$LoanStatus),
           main = "The Loanstatus By IsBorrowerHomeowner",
           color = c("pink","skyblue"))

#从图中可以看出当贷款人拥有房的时候，还款率较无房的贷款人稍高一点，但是这个因素
#对是否还款影响不大


#3.消费信用分与贷款状态的关系？
options(digits=1)#位数最小的数值的有效数字
newloandata$CreditScore<-newloandata$CreditScore

class(newloandata$CreditScore)

ggplot(data=newloandata,aes(x=CreditScore,color=LoanStatus))+
  geom_line(aes(label=..count..),stat = "bin")+
  labs(title="The LoanStatus By CreditScore",
       x="CreditScore",
       y="Count",
       fill="LoanStatus")

#从图中可以看出，随着消费信用分越高，还款率越高，因此个人的消费信用分会对
#最终还款状态有一定的影响


#4.征信记录查询次数与贷款状态的关系？
ggplot(data = newloandata[newloandata$InquiriesLast6Months<20,],
       aes(x=InquiriesLast6Months,color=LoanStatus))+
  geom_line(aes(label=..count..),stat = "bin")+
  labs(title="The LoanStatus By InquiriesLast6Months",
       x="InquiriesLast6Months",
       y="Count",
       fill="LoanStatus")

#当征信记录查询次数小于10的时候，还可以看出来对贷款状态有些影响，但是大于10
#之后，还款与未还款的曲线基本趋于一致，所以可以大胆猜测这个对贷款人是否有能力
#还款影响不大


#5.信用等级与贷款状态的关系？
par(mfrow=c(2,1))

#考虑2009年7月1日之前的信用等级对贷款状态的影响：CreditGrade
mosaicplot(table(loandata_before$CreditGrade,loandata_before$LoanStatus),
           main = "The Loanstatus By CreditGrade",
           color = c("pink","skyblue"))

#考虑2009年7月1日之后的信用等级对贷款状态的影响：ProsperRating.Alpha
mosaicplot(table(loandata_after$ProsperRating.Alpha,loandata_after$LoanStatus),
           main = "The Loanstatus By ProsperRating.Alpha",
           color=c("pink","skyblue"))

#马赛克图中可以看出，信用等级越高还款率越高，因此AA等级还款率最高，NC最低
#而且大部分人的等级集中在C、D等级，AA等级还款率和NC等级还款率相差较大，因此
#信用等级对贷款状态有一定的影响


#6.客户的职业、月收入、年收入与贷款状态的关系？
ggplot(data = newloandata,aes(x=Occupation))+
  geom_bar()+
  theme(axis.text.x = element_text(angle = 90,vjust = 0.5,hjust = 1))

#职业中，选择"Other"的人数更多，跟之前数据处理得出的结果一样，说明很多人在申请
#贷款的时候会不选择自己的职业，或者是有欺骗的可能性

#月收入与贷款状态的关系
summary(newloandata$StatedMonthlyIncome)
newloandata$Monthly[newloandata$StatedMonthlyIncome<3000]<-c("0-3000")
newloandata$Monthly[newloandata$StatedMonthlyIncome>=3000 &
                      newloandata$StatedMonthlyIncome<6000]<-c("3000-6000")
newloandata$Monthly[newloandata$StatedMonthlyIncome>=6000 &
                      newloandata$StatedMonthlyIncome<9000]<-c("6000-9000")
newloandata$Monthly[newloandata$StatedMonthlyIncome>=9000 &
                      newloandata$StatedMonthlyIncome<12000]<-c("9000-12000")
newloandata$Monthly[newloandata$StatedMonthlyIncome>=12000 &
                      newloandata$StatedMonthlyIncome<15000]<-c("12000-15000")
newloandata$Monthly[newloandata$StatedMonthlyIncome>=15000 &
                      newloandata$StatedMonthlyIncome<20000]<-c("15000-20000")
newloandata$Monthly[newloandata$StatedMonthlyIncome>=20000]<-c(">20000")

newloandata$Monthly<-factor(newloandata$Monthly,
      levels = c("0-3000","3000-6000","6000-9000",
                 "9000-12000","12000-15000","15000-20000"))


p1<-ggplot(data = newloandata,
           aes(x=Monthly,fill=LoanStatus))+
  geom_bar(position = "fill")+
  ggtitle("The Loanstatus By MonthlyIncome")+
  theme(axis.text.x = element_text(angle = 90,vjust = 0.5,hjust = 1))

p1

#年收入对贷款状态的关系
table(newloandata$IncomeRange)
newloandata$IncomeRange<-factor(newloandata$IncomeRange,
    levels = c("Not employed","Not displayed","$0",
               "$1-24,999","$25,000-49,999","$50,000-74,999",
               "75,000-99,999","$100,000+"))

p2<-ggplot(data = newloandata,
           aes(x=IncomeRange,fill=LoanStatus))+
  geom_bar(position = "fill")+
  ggtitle("The Loanstatus By IncomeRange")+
  theme(axis.text.x = element_text(angle = 90,vjust = 0.5,hjust = 1))

p2

#install.packages("gridExtra")
library(gridExtra)
grid.arrange(p1,p2,ncol=2)

#从图中可以看出，月收入越高，还款率相对来说也高一点，但是区别不大，年收入也是
#高收入的相对来说还款率大，但是一样是区别不大，无法单凭收入判断一个人的还款情况



#7.客户7年内违约次数与贷款状态的关系？
ggplot(data = newloandata,aes(x=DelinquenciesLast7Years,color=LoanStatus))+
  geom_line(aes(label=..count..),stat = "bin")+
  labs(title="The LoanStatus By DelinquenciesLast7Years",
       x="DelinquencisLast7Years",
       y="Count",
       fill="LoanStatus")

#过去7年一次也没有违约的客户还款率更高，而违约次数越高，还款率越低


#8.信用卡使用情况与贷款状态的关系？
table(newloandata$BankcardUse)
ggplot(data = newloandata,
       aes(x=BankcardUse,fill=LoanStatus))+
  geom_bar(position = "fill")+
  ggtitle("The Loanstatus By BankCardUse")+
  theme(axis.text.x = element_text(angle = 90,vjust = 0.5,hjust = 1))

#贷款人的信用卡使用情况为"Mild Use"和"Medium Use"的还款率相对较大，而"Super Use"
#还款率最低，因此可以根据使用信用卡的状况初步确定贷款人的还款能力


#9.在Prosper平台是否借款与贷款状态的关系？
newloandata$LoanOriginal[newloandata$LoanOriginalAmount>=1000 &
                         newloandata$LoanOriginalAmount<4000]<-c("1000-4000")
newloandata$LoanOriginal[newloandata$LoanOriginalAmount>=4000 &
                         newloandata$LoanOriginalAmount<7000]<-c("4000-7000")
newloandata$LoanOriginal[newloandata$LoanOriginalAmount>=7000 &
                         newloandata$LoanOriginalAmount<10000]<-c("7000-10000")
newloandata$LoanOriginal[newloandata$LoanOriginalAmount>=10000 &
                         newloandata$LoanOriginalAmount<13000]<-c("10000-13000")
newloandata$LoanOriginal[newloandata$LoanOriginalAmount>=13000]<-c(">13000")

newloandata$LoanOriginal<-factor(newloandata$LoanOriginal,
      levels = c("1000-4000","4000-7000","7000-10000",
                 "10000-13000",">13000"))

ggplot(data = newloandata,aes(x=LoanOriginal,fill=LoanStatus))+
  geom_bar(position = "fill")+
  ggtitle("The Loanstatus By LoanOriginalAmount")

#在Prosper平台有借款对贷款状态影响不大，还款率大致上趋于一致



#10.债务收入比例与贷款状态的关系？
summary(newloandata$DebtToIncomeRatio)
#DebtToIncomeRatio的四分位数都是0，而最大值是10，也就是说大部分的数值是在小于1的范围内

ggplot(data = newloandata[newloandata$DebtToIncomeRatio<1,],
       aes(x=DebtToIncomeRatio,color=LoanStatus))+
  geom_line(aes(label=..count..),stat = "bin")+
  labs(title="The LoanStatus By DebtToIncomeRatio",
       x="DebtToIncomeRatio",
       y="Count",
       fill="LoanStatus")

#债务比越低，还款率越高，也就是说贷款人本身的债务不高的情况下，具备还款能力越高


#11.借款标利率与贷款状态的关系？
ggplot(data = newloandata,aes(x=BorrowerRate,color=LoanStatus))+
  geom_line(aes(label=..count..),stat = "bin")+
  labs(title="The LoanStatus By BorrowerRate",
       x="BorrowerRate",
       y="Count",
       fill="LoanStatus")

#借款标的利率越高，还款率越低，也就是说这个会影响贷款状态



#第五步：建模，做预测分析
#通过上述的分析，可以知道EmploymentStatusDuration、CreditScore、ProsperRating.Alpha
#DelinquenciesLast7Years、BankCardUse、DebtToIncomeRatio、BorrowerRate
#对贷款状态有一定的影响，所以建模时将这几个选择为影响因子

#建模
#训练集和测试集，以2009年7月1日为分界点
#从loandata_before数据集中随机抽70%定义为训练数据集，30%为测试数据集
loandata_before<-newloandata[newloandata$ListingCreationDate<"2009-7-1",]
loandata_after<-newloandata[newloandata$ListingCreationDate>="2009-7-1",]

set.seed(156)
tain_before1<-sample(nrow(loandata_before),0.7*nrow(loandata_before))#随机选行号
set.seed(156)

tain_before<-loandata_before[tain_before1,]
test_before<-loandata_before[-tain_before1,]


#利用随机森林建立模型
library(randomForest)
before_mode <- randomForest(LoanStatus~EmploymentStatusDuration+CreditScore+
        CreditGrade+DelinquenciesLast7Years+BankcardUse+
        DebtToIncomeRatio+BorrowerRate,
        data=tain_before,importance=TRUE,na.action=na.omit)

#由于建模的变量需要因子化，且因子水平不宜很多，所以对各个因子进行分组，减少因子水平
#数量。对EmploymentStatusDuration、CreditScore、DelinquenciesLast7Years、
#DebtToIncomeRatio、BorrowerRate进行分组

#显示模型误差
plot(before_mode,ylim = c(0,1))
legend("topright",colnames(before_mode$err.rate),col=1:3,fill = 1:3)

#从图中可以看出相对于预测不还款的情况，这个模型对于还款预测误差较低，
#比较容易预测谁更可能还款

#对因子的重要性进行分析
importance<-importance(before_mode)
varImportance<-data.frame(variables=row.names(importance),
        importance=round(importance[,"MeanDecreaseGini"],2))

#对于变量根据重要系数进行排列
library(dplyr)
rankImportance<-varImportance %>% 
  mutate(Ranke=paste0("#",dense_rank(desc(Importance))))

#使用ggplot绘制重要变量相关系图
ggplot(rankImportance,aes(x=reorder()))











































