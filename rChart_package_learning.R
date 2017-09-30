require(devtools)
install_github("rCharts","ramnathv")
library(rCharts)

head(iris)
names(iris)=gsub("\\.","",names(iris))
p1<-rPlot(SepalLength~SepalWidth|Species,data = iris,
          color="Species",type="point")
p1


library(rCharts)
hair_eye_male<-subset(as.data.frame(HairEyeColor),Sex=="Male")
hair_eye_male[,1]<-paste0("Hair",hair_eye_male[,1])
hair_eye_male[,2]<-paste0("Eye",hair_eye_male[,2])
n1<-nPlot(Freq~Hair,group="Eye",data = hair_eye_male,
          type="multiBarChart")
n1

n2<-nPlot(Freq~Hair,group="Eye",data = hair_eye_male,
          type="Stacked")
n2


