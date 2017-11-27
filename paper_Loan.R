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

newloandata$LoanStatus[newloandata$LoanStatus %in% PastDue] %>% "PastDue"

#Cancelled归类到Current中



#Defaulted归类到Chargedoff中

#FinalPaymentInProgress归类为Completed
























