#learn from:http://mp.weixin.qq.com/s?__biz=MzA3MTM3NTA5Ng==&mid=2651056984&idx=1&sn=93684ecea988960a9c7ed6a2517296d7&chksm=84d9cacfb3ae43d9114fc16e4279c3603e2d6310e31d2787ce4adcfb8f133516282748eacef0&mpshare=1&scene=1&srcid=1114P8PhUh66unUOgZzYVQGP#rd

#第一步：数据导入
library(readr)
loandata<-read_csv("F:/workspace_r/prosperLoanData.csv")
View(loandata)
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
View(newloandata)


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
ggplot(newloandata,aes(x=CreditScore,))+
  geom_density(fill="pink",alpha=0.4)+
  geom_vline(aes(xintercept=median(CreditScore,na.rm = T)),colour="red",linetype="dashed",lwd=1)+
  theme_few()+ggtitle("The density of CreditScore")

#从图中可以看出数值大部分集中在500到750之间，因此可以用中位数补充缺失值：
newloandata$CreditScore[which(newloandata$CreditScore %in% NA)] <- median(newloandata$CreditScore,na.rm = T)
  
sapply(newloandata, function(x) sum(is.na(x)))  


#用中位数补全InquiriesLast6Months
ggplot(newloandata,aes(x=InquiriesLast6Months,))+
  geom_density(fill="skyblue",alpha=0.4)+
  geom_vline(aes(xintercept=median(InquiriesLast6Months,na.rm = T)),
             colour="red",linetype="dashed",lwd=1)+
  theme_few()+ggtitle("The density of InquiriesLast6Months")

#从图中可以看出数值大部分集中在0到20之间，因此可以用中位数补充缺失值：
newloandata$InquiriesLast6Months[which(newloandata$InquiriesLast6Months %in% NA)] <- median(newloandata$InquiriesLast6Months,na.rm = T)

sapply(newloandata, function(x) sum(is.na(x)))


#DekubqyebcuesLast7Years补全数值
#绘图查看是否可用中位数补全数值
ggplot(newloandata,aes(x=DelinquenciesLast7Years,))+
  geom_density(fill="blue",alpha=0.4)+
  geom_vline(aes(xintercept=median(DelinquenciesLast7Years,na.rm = T)),
             colour="red",linetype="dashed",lwd=1)+
  theme_few()+ggtitle("The density of DelinquenciesLast7Years")

#从图中可以看出数值大部分集中在0到10之间，因此可以用中位数补充缺失值
newloandata$DelinquenciesLast7Years[which(newloandata$DelinquenciesLast7Years %in% NA)] <- median(newloandata$DelinquenciesLast7Years,na.rm = T)

sapply(newloandata,function(x) sum(is.na(x)))


#绘图查看是否可以用中位数补充BankcardUtilization数值
ggplot(newloandata,aes(x=BankcardUtilization,))+
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











































