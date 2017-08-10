#learn from:https://www.analyticsvidhya.com/blog/2017/03/beginners-guide-on-web-scraping-in-r-using-rvest-with-hands-on-knowledge/
#install.packages("rvest")
#install.packages("downloader")

rm(list=ls())
gc();gc();gc()

library(rvest)

# IMDb website for the 100 most popular feature films released in 2016
url<-"http://www.imdb.com/search/title?count=100&release_date=2016,2016&title_type=feature"
webpage<-read_html(url)
webpage


# Rank: The rank of the film from 1 to 100 on the list of 100 most popular feature films released in 2016.
# Title: The title of the feature film.
# Description: The description of the feature film.
# Runtime: The duration of the feature film.
# Genre: The genre of the feature film,
# Rating: The IMDb rating of the feature film.
# Metascore: The metascore on IMDb website for the feature film.
# Votes: Votes cast in favor of the feature film.
# Gross_Earning_in_Mil: The gross earnings of the feature film in millions.
# Director: The main director of the feature film. Note, in case of multiple directors, I’ll take only the first.
# Actor: The main actor of the feature film. Note, in case of multiple actors, I’ll take only the first.

#Step 1:
#Now,we will start with scraping the Rank field.For that,we'll
#use the selector gadget to get the specific CSS selectors that
#encloses the rankings.You can click on the extenstion in your
#browser and select the rankings field with cursor.

#Make sure that all the rankings are selected.You can select some
#ranking sections in case you are not able to get all of them
#and you can also de-select them by clicking

#Step 2:
#Once you are sure that you have made the right selections,you
#need to copy the corresponding CSS selector that you can view
#in the bottom center.


#Step 3:
#Once you know the CSS selector that contains the rankings,you 
#can use the simple R code to get all the rankings

rank_data_html<-html_nodes(webpage,".text-primary")
rank_data<-html_text(rank_data_html)
head(rank_data)


#Step 4:
#Once you have the data,make sure that it looks in the desired format.
#I am preprocessing my data to convert it to numerical format.

rank_data<-as.numeric(rank_data)
head(rank_data)


#Step 5:
#Now you can clear the selector section and select all the titles.
#You can visually inspect that all the titles are selected.
#Make any required additions and deletions with the help of your curser

#Step 6:
#Again,I have the corresponding CSS selector for the titles
#-.lister-item-header a.

title_data_html<-html_nodes(webpage,".lister-item-header a")

title_data<-html_text(title_data_html)

head(title_data)


#Step 7:
#In the following code,I have done the same thing for scrapping
#-Description,Runtime,Genre,Rating,Metascore,Votes,Gross_EarningIn_Mil,
#Director and Actor data.

description_data_html<-html_nodes(webpage,".ratings-bar+ .text-muted")
description_data<-html_text(description_data_html)
head(description_data)

#removing "\n"
description_data<-gsub("\n","",description_data)


runtime_data_html<-html_nodes(webpage,".text-muted .runtime")
runtime_data<-html_text(runtime_data_html)
head(runtime_data)

#removing mins and converting it to numerical
runtime_data<-gsub(" min","",runtime_data)
runtime_data<-as.numeric(runtime_data)
head(runtime_data)


genre_data_html<-html_nodes(webpage,".genre")
genre_data<-html_text(genre_data_html)
head(genre_data)

#removing "\n"
genre_data<-gsub("\n","",genre_data)

#removing excess spaces
genre_data<-gsub(" ","",genre_data)

#taking only the first genre of each movie
genre_data<-gsub(",.*","",genre_data)

#Convering each genre from text to factor
genre_data<-as.factor(genre_data)


rating_data_html<-html_nodes(webpage,".ratings-imdb-rating strong")
rating_data<-html_text(rating_data_html)
head(rating_data)

rating_data<-as.numeric(rating_data)


votes_data_html<-html_nodes(webpage,".sort-num_votes-visible span:nth-child(2)")
votes_data<-html_text(votes_data_html)
head(votes_data)


#removing commas
votes_data<-gsub(",","",votes_data)

votes_data<-as.numeric(votes_data)


directors_data_html<-html_nodes(webpage,".text-muted+ p a:nth-child(1)")
directors_data<-html_text(directors_data_html)
head(directors_data)

directors_data<-as.factor(directors_data)


actors_data_html<-html_nodes(webpage,".lister-item-content .ghost~ a")
actors_data<-html_text(actors_data_html)
head(actors_data)

actors_data<-as.factor(actors_data)


metascore_data_html<-html_nodes(webpage,".metascore")
metascore_data<-html_text(metascore_data_html)
head(metascore_data)


#removing extra space in metascore
metascore_data<-gsub(" ","",metascore_data)
length(metascore_data)


#Step 8:
#The length of meta score data is 94 while we are scrapping
#the data for 100 movies.The reason this happen is because
#there are 4 movies which don't have the correspinding Metascore fields.


#Step 9:
#It is a practical situation which can arise while scrapping
#any website.Unfortunately, if we simply add NA's to last 6
#entries it will map NA as Metascore for movies 94 to 100 while
#in reality,the data is missing for some other movies.After a
#visual inspection,I found that the Metascore is missing for movies
#3,22,34,40,92,98.

for(i in c(3,22,34,40,92,98)){
  a<-metascore_data[1:(i-1)]
  b<-metascore_data[i:length(metascore_data)]
  metascore_data<-append(a,list("NA"))
  metascore_data<-append(metascore_data,b)
}

metascore_data<-as.numeric(metascore_data)

length(metascore_data)

summary(metascore_data)


#Step 10:
#The same ting happens with the Gross variable which represents
#gross eranings of that movie in millions.
gross_data_html<-html_nodes(webpage,".ghost~ .text-muted+ span")
gross_data<-html_text(gross_data_html)
head(gross_data)


gross_data<-gsub("M","",gross_data)

gross_data<-substring(gross_data,2,6)

length(gross_data)


#filling missing entries with NA
#3,22,33,34,40,52,64,78,79,86,92,93,96,98,99

for(i in c(3,22,33,34,40,52,64,78,79,86,92,93,96,98,99)){
  a<-gross_data[1:(i-1)]
  b<-gross_data[i:length(gross_data)]
  gross_data<-append(a,list("NA"))
  gross_data<-append(gross_data,b)
}

gross_data<-as.numeric(gross_data)

length(gross_data)

summary(gross_data)


#Step 11:
#Now we have successfully scrapped all the 11 features for
#the 100 most popular feature films released in 2016.
#Let's combine them to create a dataframe and inspect its structure.


#Comining all the lists to from a data frame
movies_df<-data.frame(Rank=rank_data,
                      Title=title_data,
                      Description=description_data,
                      Runtime=runtime_data,
                      Genre=genre_data,
                      Rating=rating_data,
                      Metascore=metascore_data,
                      Votes=votes_data,
                      Gross_Earning_in_Mil=gross_data,
                      Director=directors_data,
                      Actor=actors_data
                      )
str(movies_df)

View(movies_df)



#Analyzing scrapped data from the web
#Once you have the data, you can perform several tasks like analyzing
#the data,drawing inferences from it,training machine learning
#models over this data,etc.I have gone on to create some interesting
#visualization out of the data we have just scrapped.

library(ggplot2)

qplot(data = movies_df,Runtime,fill=Genre,bins=30)

ggplot(movies_df,aes(x=Runtime,y=Rating))+
  geom_point(aes(size=Votes,col=Genre))


ggplot(movies_df,aes(x=Runtime,y=Gross_Earning_in_Mil))+
  geom_point(aes(size=Rating,col=Genre))

