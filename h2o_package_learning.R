#learning from:https://mp.weixin.qq.com/s?__biz=MzU3MTEwMDU4Mg==&mid=2247484144&idx=1&sn=03f99bd16c4c0b8d76318bb50822cbec&chksm=fce41e39cb93972ff087fd79e2d2300eadf26a3e56ba938f74247a1bd76663a83c87cffafcf0&scene=0#rd

#在使用H2O前需要：
#1.安装java环境
#2.install.packages("h2o")

library(h2o)

#h2o类似于python中的sklearn,提供各种机器学习算法接口：
#1.提供统一的接口，代码更加清晰简单
#2.不需要一个模型一个数据格式
#3.计算速度较快

#在R中推荐使用data.table包进行数据清洗，然后使用as.h2o变成h2o包
#所接受的格式，再用h2o包进行数据建模

h2o.init(nthreads = -1,max_mem_size = "8G")
#-1表示使用机器上所有的核
#max_mem_size参数表示允许h2o使用的最大内存

#导入关于贷款的数据集，目的是用来预测这个贷款能否按时偿还（二分类问题）
#响应变量bad_loan，1表示未能偿还，0表示已经偿还
loan_csv<-"https://raw.githubusercontent.com/h2oai/app-consumer-loan/master/data/loan.csv"

data<-h2o.importFile(loan_csv)

dim(data)


#由于是一个二分类问题，必须指定响应变量为一个因子类型（factor）
#若响应变量为0/1，H2O会认为是一个数值，那将意味着H2O会训练一个
#回归模型:

#编码为因子类型
data$bad_loan<-as.factor(data$bad_loan)

#查看因子levels
h2o.levels(data$bad_loan)


#将数据拆分为训练集，验证集，测试集
#按比例分为70%，15%，15%
#h2o.splitFrame()为了运行效率采用的是近似拆分方法而不是精确拆分
splits<-h2o.splitFrame(data=data,
                      ratios=c(0.7,0.15),
                      seed=1 #设定种子保证可重复性
                      )
train<-splits[[1]]
valid<-splits[[2]]
test<-splits[[3]]


nrow(train) #114908
nrow(valid) #24498
nrow(test) #24581


#指定因变量与自变量
y<-"bad_loan"
x<-setdiff(names(data),c(y,"int_rate"))


#特征工程：数据准备工作
#训练模型：H2O监督算法

#1.广义线性回归模型（GLM）
#默认情况下h2o.glm采用一个带正则项的弹性网模型（Elastic Net Model）
glm_fit1<-h2o.glm(x=x,
                  y=y,
                  training_frame = train,
                  model_id = "glm_fit1",
                  family = "binomial")

#通过验证集来进行一些自动调参工作，需要设置lambda_search=True
#因为GLM模型是带正则项的，所以需要找到一个合适的正则项大小来
#防止过拟合。这个模型参数lambda是控制GLM模型的正则项大小，通过
#设定lambda_search=TRUE，我们能自动找到一个lambda的最优值，这个
#自动自动寻找的方法是通过在【验证集】上指定一个lambda，验证集上
#的最优lambda即我们要找的lambda













#2.随机森林模型（RF）
#3.GBM（GBDT）
#4.深度学习（DL）
#5.朴素贝叶斯（NB）






























