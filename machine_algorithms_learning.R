#learning from:https://www.analyticsvidhya.com/blog/2015/08/common-machine-learning-algorithms/

#Essentials of Machine Learning Algorithms

#Introduction
#We are probably living in the most defining period of human history.
#The period when computing moved from large mainframes to PCs to cloud.
#But what makes it defining is not what has happened,but what is coming
#our way in years to come.

#What makes this period exciting for some one like me is the democratization
#of the tools and techniques,which followed the boost in computing.
#Today,as a data scientist,I can build data crunching machines with complex
#algorithms for a few dollors per hour.But here wasn't easy!

#Who can benefit the most from this guide?
#The idea behind creating this guide is to simplify the journey of aspiring
#data scientists and machine learning enthusiasts across the world.
#Through this guide,I will enable you to work on machine learning problems
#and gain from experience.

#Broadly,there are 3 types of Machine Learning Algorithms..

#1.Supervised Learning
#How it works:This algorithm consist of a target/outcome variable
#(or deoendent variable) which is to be predicted from a given set
#of variables,we generate a function that map inputs to desired outputs.
#The training process continues until the model achieves a desired
#level of accuracy on the training data.Examples of Supervised Learning:
#Regression,Decision Tree,Random Forest,KNN,Logistic Regression etc.

#2.Unsupervised Learning
#How it works:In this algorithm,we do not have any target or outcome 
#variable to predict/estimate.It is used for clustering population in
#different groups,which is widely used for segmenting customers in 
#different groups for specific intervention.Examples of Unsupervised
#Learning:Apriori algorithm,K-means.

#Reinforcement Learning:
#How it works:Using this algorithm,the machine is trained to make specific
#decisions.It works this way:the machine is exposed to an environment
#where it trains itself continually using trial and error.This machine
#learns from past experience and tries to capture the best possible 
#knowledge to make accurate business decisions.Example of Reinforcement
#Learning:Markov Decision Process


#List of Common Machine Learning Algorithms

#1.Linear Regression
#It is used to estimate real values (cost of houses,number of calls,
#total sales etc.)based on continuous variable(s).Here,we establish 
#relationship between independent and dependent variables by fitting 
#a best line.This best fit line is known as regression line and represented
#by a linear equation Y=a*X+b.

#The best way to understand linear regression is to relive this experience
#of childhood.Let us say,you ask a child in fifth grade to arrange
#people in his class by increasing order of weight,without asking them
#their weights! What do you think the child will do?He/she would likely
#look (visually analyze)at the height and build of people and arrange
#them using a combination of these visible parameters.This is linear
#regression in real life! The child has actually figured out that
#height and build would be correlated to the weight by a relationship,
#which looks like the equation above.

#Y-Dependent Variable
#a-Slope
#X-Independent variable
#b-Intercept

#These coefficients a and b are derived based on minimizing the sum
#of squared difference of distance between data point and regression line.

#Linear Regression is of mainly two types:Simple Linear Regression
#and Multiple Linear Regression.Simple Linear Regression is charactered
#by one independent variable.And,Multiple Linear Regressions is charactered
#by multiple independent variables.While finding best fit line,you can
#fit a polynomial or curvilinear regression.

#Code:
#Load Train and Test datasets
#Identify feature and response variable(s) and values must be numeric
#and numpy arrays
x_train<-input_variables_values_training_datasets
y_train<-target_variables_values_training_datasets
x_test<-input_variables_values_test_datasets

x<-cbind(x_train,y_train)

#Train the model using the training sets and check score
linear<-lm(y_train ~ .,data = x)
summary(linear)

#Predict Output
predicted=predict(linear,x_test)


#
# x<-read.table("train.csv",header = TRUE,sep = ",")
# linear<-lm(x$SalePrice~x$LotArea,data = x)
# summary(linear)
# library(dplyr)
# y<-read.table("test.csv",header = TRUE,sep = ",") %>% select(Id,LotArea)
# predicted=predict(linear,y)
# predicted
#


#2.Logistic Regression
#Don't get confused by its name!It is a classification not a regression
#algorithm.It is used to estimate discrete values(Binary values like
#0/1,yes/no,true/false)based on given set of independent variable(s).
#In simple words,it predicts the probability of occurrence of an event
#by fitting data to a logit function.Hence,it is also known as logit
#regression.Since,it predicts the probability,its output values lies
#between 0 and 1 (as expected).

#Let's say your friend gives you a puzzle to solve.There are only 2
#outcome scenarios-either you solve it or you dont. Now imagine,that
#you are being given wide range of puzzles/quizzes in an attempt to 
#understand which subjects you are good at.The outcome to this study
#would be something like this-if you are given a trignometry based
#tenth grade problem,you are 70% likely to solve it.On the outher hand,
#if it is grade fifth history question,the probability of getting an
#answer is only 30%.This is what Logistic Regression provides you.


#Coming to the math,the log odds of the outcome is modeled as a linear
#combination of the predictor variables.

odds=p/(1-p) #=probability of event occurrence/probability of not event occurrence
ln(odds)=ln(p/(1-p))

logit(p)=ln(p/(1-p))=b0+b1x1+b2x2+...+bkxk


#Above,p is the probability of presence of the characteristic of interest.
#It chooses parameters that maximize the likelihood of observing the
#sample values rather than that minimize the sum of squared errors (
#like in ordinary regression).

x<-cbind(x_train,y_train)
#Train the model using the training sets and check score
logistic<-glm(y_train ~ .,data = x,family = "binomial")
summary(logistic)
#Predict Output
predicted=predict(logistic,x_test)


#
# x<-read.table("train.csv",header = TRUE,sep = ",")
# logistic<-glm(x$Street~x$PavedDrive,data = x,family = "binomial")
# summary(logistic)
# library(dplyr)
# y<-read.table("test.csv",header = TRUE,sep = ",") %>% select(Street)
# predicted=predict(logistic,y)
# predicted
#


#Furthermore:There are may different steps that could be tried in order
#to improve the model.
#including interaction terms
#removing features
#regularization techniques
#using a non-linear model


#3.Decision Tree
#It is a type of supervised learning algorithm that is mostly used for 
#classification problems.Suprisingly,it works for both categorical and
#continuous dependent variables.In this algoritm,we split the population
#into two or more homogeneous sets.This is done based on most significant
#attributes/independent variables to make as distinct groups as possible.


#Code:
library(rpart)

x<-cbind(x_train,y_train)
#grow tree
fit<-rpart(y_train ~ .,data = x,method = "class")
summary(git)
#Predict Output
predicted=predict(git,x_test)



#4.SVM(Support Vector Machine)
#It is a classification method.In this algorithm,we plot each data item as
#a point n-dimensional space (where n is number of features you have)
#with the value of each feature being the value of a particular coordinate.

#For example,if we only had two features like Height and Hair length of 
#an individual,we'd first plot these two variables in two dimensional
#space where each point has two co-ordinates (these co-ordinates are known
#as Support Vectors).

#Now,we will find some line that splits the data between the two differently
#classified groups of data.This will be the line such that the distances
#from the closest point in each of the two groups will be farthest away.

#In the example shown above,the line which splits the data into two differently
#classified groups is the black line,since the two closest point are the
#farthest apart from the line.This line is our classifier.Then,depending
#on where the testing data lands on either side of the line,that's what
#class what we can classify the new data as.

#install.packages("e1071")
library(e1071)

x<-cbind(x_train,y_train)
#Fitting model
fit<-svm(y_train ~.,data = x)
summary(fit)
#Predict Output
predicted=predict(fit,x_test)


#5.Naive Bayes
#It is a classification technique based on Bayes' theorem with an assumption
#of independence between predictors.In simple terms,a Navie Bayes classifier
#assumes that the presence of a particular feature in a class is unrelated
#to the presence of any other feature.For example,a fruit may be considered
#to be an apple if it is red,round,and about 3 inches in diameter.Even if
#these features depend on each other or upon the existence of the other
#features,a naive Bayes classifier would consider all of these properties 
#to independently contribute to the probability that this fruit is an apple.

#Navie Bayesian model is easy to build and particularly useful for very
#large sets.Along with simplicity,Navie Bayes is known to outperform even
#highly sophisticated classification methods.

#Bayes theorem provides a way of calculating posterior probability P(c|x)
#from P(c),P(x) and P(x|c)


library(e1071)
x<-cbind(x_train,y_train)
#Fitting model
fit<-navieBayes(y_train ~.,data=x)
summary(fit)
#Predict Output
predicted=predict(fit,x_test)



#6.KNN(K-Nearest Neighbors)
#It can be used for both classification and regression problems.
#However,it is more widely used in classification problems in
#the industry.K nearest neighbors is a simple algorithm that
#stores all available cases and classifies new cases by a majority
#vote of its k neighbors.The case being assigned to the class is 
#most common amongst its K nearest neighbors measured by a distance
#function.

#These distance functions can be Euclidean,Manhattan,Minkowski and
#Hamming distance.First three functions are used for continuous 
#function and fourth one (Hamming) for categorical variables.If K=1,
#then the case is simply assigned to the class of its nearest neighbor.
#At times,choosing K turns out to be a challenge while performing
#KNN modeling.

#KNN can easily be mapped to our real lives.If you want to learn
#about a person,of whom you have no information,you might like to
#find out about his close friends and the circles he moves in and
#gain access to his/her information.

#Things to consider before selecting KNN:
#KNN is computationally expensive
#Variables should be normalized else higher range variables can bias it.
#Works on pre-processing stage more before goning for KNN like
#outlier,noise removal.

install.packages("knn")
library(knn)

x<-cbind(x_train,y_train)
#Fitting model
fit<-knn(y_train ~ .,data=x,k=5)
summary(fit)
#Predict Output
predicted=predict(fit,x_test)



#7.K-Means
#It is a type of unsupervised algorithm which solves the clustering
#problem.Its procedure follows a simple and easy way to classify a 
#given data set through a certain number of clusters (assume k clusters).
#Data points inside a cluster are homogeneous and heterogeneous to
#peer groups.

#Remember figuring out shapes from ink blots? K means is somewhat similar
#this activity.You look at the shape and spread to decipher how many
#different clusters / population are present!

#How K-means forms cluster:
#1.K-means picks k number of points for each cluster known as centroids.
#2.Each data point forms a cluster with the closest centroids i.e. k clusters.
#3.Finds the centroid of each cluster based on existing cluster members.
#Here we have new centroids.
#4.As we have new centroids,repeat step 2 and 3.Find the closest distance
#with new k-clusters.Repeat this process until convergence occurs i.e.
#centroids does not change.

#How to determine value of K:
#In K-means, we have clusters and each cluster has its own centroid.
#Sum of difference between centroid and the data points within a 













#8.Random Forest

#9.Dimensionality Reduction Algorithms

#10.Gradient Boost & Adaboost



































































