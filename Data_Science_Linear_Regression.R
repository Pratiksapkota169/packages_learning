#learn from:http://www.listendata.com/2015/09/linear-regression-with-r.html

#Linear Regression
#It is a way of finding a relationship between a single,continuous
#variable called Dependent or Target variable and one or more other
#variables(continuous or not) called Independent Variables.

#It's a straight line curve.In the above figure,diagonal red line
#is a regression line which is also called best-fitting straight
#line.The distance between dots and regression line is errors.Linear
#regression aims at finding best fitting straight line by minimizing
#the sum of squared vertical distance between dots and regression line.

#Variable Type
#Linear regression requires the dependent variables to be continuous


#Simple vs. Multiple Linear Regression
#Linear regression can be simple linear regression when you have
#only one independent variable.Whereas Multiple linear regression
#will have more than one indepnedent variable.


#Regression Equation
#Y=b0+b1X1+b2X2+b3X3+......+bkXk

#Interpretation:
#b0 is the intercept the expected mean value of dependent variable
#(Y) when all independent variables (Xs) are equal to 0.and b1 is 
#the slope.
#b1 represents the amount by which dependent variable (Y) changes
#if we change X1 by one unit keeping other variables constant.


#Important Term:Residual
#The difference between an observed (actual) value of the dependent
#variable and the value of the dependent variable predicted from
#the regression line.

#Algorithm
#Linear regression is based on least square estimation which says
#regression coefficients (estimates) should be chosen in such a 
#way that it minimizes the sum of the squared distances of each
#observed response to its fitted value.

#Minimum Sample Size
#Linear regression requires 5 cases per independent variable variable
#in the analysis.

#Assumptions of Linear Regression Analysis

#1.Linear Relationship:Linear regression needs a linear relationship
#between the dependent and independent variables.

#2.Normality of Residual:Linear regression requires residuals should
#be normally distributed.

#3.Homoscedasticity:Linear regression assumes that residuals are
#approximately equal for all predicted dependent variable values.
#In other words,it means constant variance of errors.

#4.No Outlier Problem

#5.Multicollinearity:It means there is a high correlation between
#independent variables.The linear regression model MUST NOT be faced
#with problem of multicollinearity.

#6.Independence of error terms - No Autocorrelation
#It states that the errors associated with one observation are not
#correlated with the errors of any other observation. It is a problem
#when you use time series data.Suppose you have collected data from
#labors in eight different districts.It is likely that the labors 
#within each district will tend to be more like one another that
#labors from different districts,that is,their errors are notindependent.


#Distirbution of Linear Regression
#Linear regression assumes target or dependent variable to be
#normally distributed.Normal Distribution is same as Gaussian
#distribution.It uses identity link function of gaussian family.

#Standardized Coefficients
#The concept of standardization or standardized coefficients
#comes into pictures are expressed in different units.Suppose you
#have 3 independent variables - age,height and weight.The variable
#'age' is expressed in years,height in cm,weight in kg.If we need
#to rank these predictors based on the unstandardized coefficient,
#it would not be a fair comparison as the unit of these variable
#is not same.


#Interpretation of Standardized coefficient
#A standardized coefficient value of 1.25 indicates that a change of
#one standard deviation in the independent variable result in a
#1.25 standard deviations increase in the dependent variable.


#Measures of Model Performance
#1.R-squared
#It measures the proportion of the variation in your dependent
#variable explained by all of your independent variables in the
#model.It assumes that every independent variable in the model
#helps to explain variation in the dependent variable.In reality,
#some variables don't affect dependent variable and they don't help
#building a good model.

# r^2=1-SS Error/SS Total


#Rule:
#Higher the R-squared,the better the model fits your data.In
#psychological surveys or studies,we generally found low R-squared
#values lower than 0.5.It is because we are trying to predict 
#human behavior and it is not easy to predict humans.In these cases,
#if your R-squared value is low but you have statistically significant
#independent variables,you can still generate insights about how
#changes in the predictor values are associated with changes in
#the reponse value.


#Can R-Squared be negative?
#Yes,it is when horizontal line explains the data better than your
#model.It mostly happens when you do not include intercept.Without 
#an intercept,the regression could do worse than the sample mean
#in terms of predicting the target variable.It is not only because
#of exclusion of intercept.It can be negative even with inclusion of
#intercept.

#Mathematically,it is possible when error sum-of-squares from the 
#model is larger than the total sum-of-squares from the horizontal
#line.

#R-squared=1-[(Sum of Square Error)/(Total Sum of Square)]


#











































