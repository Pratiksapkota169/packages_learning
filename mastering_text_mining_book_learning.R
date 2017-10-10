#mastering text mining with R

#Capter 1:Statistical Linguistics with R

x<-rnorm(1000,99.2,1.2)
y<-rnorm(1000,97.3,0.85)
z<-rnorm(1000,98.1,0.4)

#Create a chart with all 3 Conditional distribution plots
# ecdf:概率分布函数
plot(ecdf(x),col=rgb(1,0,0),main=NA)
plot(ecdf(y),col=rgb(0,1,0),add=T)
plot(ecdf(z),col=rgb(0,0,1),add=T)

#Adding legend to the chart.
legend('right',c("x","y","z"),fill = c(rgb(1,0,0),rgb(0,1,0),rgb(0,0,1)))


install.packages("zipfR")
#在自然语言的语料库里，一个单词出现的频率与它在频率表里的排名成反比。
library(zipfR)
data("Dickens.spc")
data("Brown.spc")
N(Brown.spc)#Sample size
V(Brown.spc)#distinct type
Vm(Brown.spc,1)#occur just once

plot(log(BrownVer.spc$m),log(BrownVer.spc$Vm))



#Compute binomially interpolated growth curves:
#计算二项式差值的生长曲线
di.vgc<-vgc.interp(Dickens.spc,(1:100)*28170)

br.vgc<-vgc.interp(BrownVer.spc,(1:100)*1662)

plot(di.vgc,br.vgc,legend = c("Dickens","Brown"))


zm<-lnre("zm",Dickens.spc)
zm.spc<-lnre.spc(zm,N(Dickens.spc))


#Heap's law:
#在给定的语料中，其独立的term数（vocabulary的size）v（n）大致是语料大小（n）的一个指数函数。

#Benford law：
#在自然形成的十进制数据中，任何一个数据的第一个数字d出现的概率大致log10(1+1/d)


install.packages("tm")
library(tm)
data("acq")
termdoc<-DocumentTermMatrix(acq)
Heaps_plot(termdoc)

#Lexical richness:
#1.Lexical variation:multi-dimensional
#2.Lexical density:grammatical words,lexical tokens
#3.Lexical originality:unique words
#4.Lexical sophistication:advanced words

#If we discard the sequence of words in all sentences of a text
#corpus and basically treat it like a bag of words,then the 
#efficiency of different language models can be estimated by how
#accurately a model restored the order of strings in sentences.


#N-gram models:语法模型
#part-of-speech(POS):词性
#pointwise mutual information(PMI):点间交互信息
#Unigram model:一元语法模型
#Bigram model:二元语法模型


#Markov assumption
#Hidden Markov models


#Quantitative methods in linguistics

#The first step is we assume a document is a collection of words
#where order doesn't influence our analysis.
#Next,we simplify the vocabulary by passing the document through
#a stemming process;here,we reduce the words to their root.
#A better/advanced approach would be lemmatization.
#Then we discard punctuation,capitalization,stop words,and very
#common words.

#Document term matrix
#rows represent documents,columns represent terms
#each cell value is the term frequency count for a document

#When a term occurs in a lot of documents,it tends to make notably
#less difference the terms that occur few times.
#In order to address this problem,we use inverse document frequency


#Inverse document frequency(IDF)
# idf(term)=log(N/df(term))
#N:the number of documents in the corpus
#df(term):the number of documents in which the term appears

#The weight of a term's appearance in a document is calculated
#by combining the term frequency(TF) in the document with its IDF:
#w(t,d)=tfd(t)*idf(t)

#This is used by a lot of search platforms/APIs,such as SOLR,Elasticsearch and lucene.
#When we look at the entries in this term-document matrix,most of
#the cells will be empty because only a few terms appear in each
#document;storing all the empty cells requires a lot of memory and 
#it contibutes no value to the dot product(similarity computation).
#Various sparse matrix(稀疏矩阵) representatons are possible and these
#are used to for optimized query processing.


#Words similarity and edit-distance functions
#In order to find a similarity between words in case of fuzzy searches(模糊搜索)
#we need to quantify the similarity between words
install.packages("stringdist")
library(stringdist)

#One way of finding the similarity between two words is by edit distance.
#Edit distance refers to the number of operations(操作步数) required to transform
#one string into another.


#Euclidean distance
#e<-sqrt((x1-x2)^2+(y1-y2)^2)


#Cosine similarity
#Euclidean distance has its own pitfalls,documents with lots of terms
#are far from origin,we will find small documents relatively similar
#even if it's unrelated because of short distance.

#To avoid length issues,we can use the angular distance and measure
#the similarity by the angle between the vectors;we measure the cosine
#of the angle.The larger the cosine value,the more similar the ducuments are.

#cos(A,B)=A.B / |A|.|B|


#create two random matrices matrix A and matrix B
ncol<-5
nrow<-5
matrixA<-matrix(runif(ncol*nrow),ncol=ncol)
matrixB<-matrix(runif(ncol*nrow),ncol=ncol)

#function for estimating cosine similarity in R:
cosine_sim<-function(matrixA,matrixB){
  m=tcrossprod(matrixA,matrixB)#A %*% B
  c1=sqrt(apply(matrixA,1,crossprod))# |A|
  c2=sqrt(apply(matrixB,1,crossprod))# |B|
  m/outer(c1,c2) #cosine
}

#Estimate the cosine similarity between the two matrices initiated earlier
cosine_sim(matrixA,matrixB)

#Alternately,cosine similarity can also be estimated by functions
#available in the packages lsa,proxy,and so on.


#Levenshtein distance
#The Levenshtein distance between two words,x and y, is the minimal number
#of insertions,deletions,and replacements needed for transforming word
#x into word y.

library(stringdist)
stringdist('我是小明','你是小红',method = "lv")#2:replace c with d,replace d with c
stringdist('abcd','badc',method = "lv")#3


#Damerau-Levenshtein distance
#The Damerau-Levenshtein distance is the minimal number of insertions,
#deletions,replacement,and adjacent transpositions(相邻互换) needed for 
#transforming word x into word y.
stringdist('abcd','abdc',method = 'dl')


#Hamming distance
#The hamming distance between two words is the number of positions at
#which the characters are different.It is the minimum number of 
#substitutions(替换) required to change into word into another.In order 
#to use the Hamming distance,the words must be of the same length.
stringdist('abcd','abdc',method = "hamming")#substitute c with d and d with c


#Jaro-Winkler distance
#The Jaro_Winkler distance measure is best suited for short strings such
#as name comparison or record linkage.It is designed to compare surnames
#and names.The higher the distance,the more similar the strings in comparison are.

#Compute the number of matches:匹配个数
#Compute the number of transpositions:转置次数

#The Winkler adjustment involves a final rescoring based on an exact
#match score for the initial characters of both words.It uses a 
#constant scaling factor P:(常规比例因子)

#Error: p <= 0.25 is not TRUE,p越大,值越小
stringdist('abcd','abdc',method = 'jw',p=0.25)


#Measuring readability of a text:衡量文本的可读性
#Readability is the ease with which a text can be read by a reader.
#The readability of a text depends on its content and the complexity
#of its vocabulary and syntax.There are a number of methods to measures
#the readability of a text.Most of them are based on correlation
#analysis,where researchers have selected a number of text properties
#(such as words per sentence,average number of syllables音节 per word)
#and then asked test subjects to grade the readability of various texts
#various texts on a scale.By looking at the text properties of these
#texts,it is possible to correlate how much "words per sentence"
#influences readability.


#The koRpus package in R provides a hyphen function to estimate
#the readability of a given text.


#Gunning frog index:迷雾指数
#The Gunning fog index is one of the best-known methods that 
#measure the level of reading difficulty of any document.The 
#fog index level translates the number of years of education
#a reader needs in order to understand the given material.The
#ideal score is 7 or 8;anything above 12 is too hard for most
#people to read.

#steps:
#1.Slect all the sentences in a passage of approximately 100 words.
#2.We need to calculate the average sentence length by doing a 
#simple math of dividing number of words by number of sentences.
#3.Count all the words with three or more syllables.Generally,words
#with more than three syllables are considered to be complex.
#4.Sum up the average sentence length and the percentage of complex words.
#Multiply the result by 0.4.

#0.4 [ (words / sentences) + 100(complex words / words) ]


#R packages for text mining 

#1.OpenNLP
#OpenNLP is an R package which provides an interface,Apache OpenNLP,
#which is a machine-learning-based toolkit written in Java for
#natural language processing activities.Apache OpenNLP is widely
#used for most common tasks in NLP,such as tokenization,POS词性tagging,
#named entity recognition(NER)命名实体识别,chunking组块,parsing句法分析,
#It provides wrappers for Maxent entropy models (最大熵模型)
#using the Maxent Java package.

#It provides function for sentence annotation,word annotation,POS tag
#annotation,and annotation parsing using the Apache OpenNLP chunking
#parser.The Maxent Chunk annotator(块注释器) function computes the chunk
#annotation using the Maxent chunker provided by OpenNLP.

#Rweka
#










