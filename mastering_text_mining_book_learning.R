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
#Different data-mining activities,such as data processing,supervised
#and unsupervised learning,association mining
#For natural language processing,RWeka provides tokenization(词语切分)
#and stemming(词干提取)functions.


#RcmdrPlugin.temis
#The Import function in this package processes the corpus and generates
#a term-document matrix.(文档矩阵)
#The package provides differnet functions to summarize and visualize the
#corpus statistics.
#Correspondence analysis and hierarchical clustering (分层聚类)
#can be performed on the corpus.

#tm
#It has methods for importing data,handling corpus,metadata(原数据)
#management,creation of term document matrices,and preprocessing methods.
#There are two types of implementation,volatile corpus(VCorpus不稳定语料库)
#and permanent corpus(PCropus永久语料库)。


#languageR
#This package contains functions for vocabulary richness,vocabulary
#growth,frequency spectrum(频率光谱)
#this package can also be used for correlation,collinearity 
#diagnostic(共线性诊断),diagnostic visualization of logistic models


#koRpus
#The koRpus package is a versatile(多功能的)tool for text mining which
#implements many functions for text readability and lexical 
#variation(词汇多样性).


#RKEA
#The RKEA package provides an interface to KEA,which is a tool for
#keyword extraction(关键词提取) from texts.REKA requires a keyword
#extraction model,which can be created by manually indexing a small
#set of texts,using which it extracts keywords from the document.


#maxent
#The maxent package provides tools for low-memory implementation of 
#multinomial(多项式) logistic regression,which is also called the 
#maximum entropy model.(最大熵模型)
#This package is quite helpful for classification processes involving 
#sparse term-document matrices,and low memory consumption on huge datasets.


#Isa
#Truncated singular vector decomposition (截断的奇异向量分解)can help
#overcome the variability in a term-document matrix by deriving the 
#latent features statistically.(潜在特征统计)
#The Isa package provides an implementation of latent semantic
#analysis.(潜在语义分析)



#Chapter 2:Processing Text

#A significant part of the time spent on any modeling or analysis
#activity goes into accessing,preprocessing and cleaning data.We
#should have the capability to access data from diverse sources,load
#them in our statistical analysis environment and process them in a
#manner conducive for advanced analysis.

#Accessing texts from diverse sources
#Processing texts using regular expressions
#Normalizing texts
#Lexical diversity
#Language detection


#Accessing text from diverse sources
#JSON,XML,HTTP,HTTPS

#File system
#.doc,.txt,.pdf,.csv,.xml
#The tm package provides a framework to access and perform a wide
#variety of analysis on text.

install.packages("tm")
library(tm)


#PDF documents

#install.packages("pdftools") 支持中文！
library(pdftools)

info<-pdf_text("E:/workspace_r/test/test1.pdf")
info

write(info,"E:/workspace_r/test/result.txt")


#HTML
library(RCurl)
library(XML)
library(selectr)


URL <- "http://www.w3schools.com/html/html_tables.asp"
webpage<-getURL(URL)
table <- querySelector(pagetree, '.reference')

name <- xpathApply(table, "./tr/td[2]")


#JSON
library(jsonlite)
library(curl)
hadley_orgs<-fromJSON("https://api.github.com/users/hadley/orgs")
View(hadley_orgs)

json<-toJSON(hadley_orgs)
json


#Processing text using regular expressions

#Word tokenization
#When we do quantitative analysis on the text we consider it a bag of
#words and extract the key words,frequency of occurrence,and the 
#importance of each word in the text.
#Tokenizing provides various kind of information about text,like the 
#number of words or tokens in a text,the vocabulary or the type of words.

#Sentence:Unit of written language
#Utterance:Unit of spoken language
#Word form:The inflected form as it actually appears in the corpus
#Lemma:An abstract form,shared by word forms having the same stem and part of speech
#Word Sense:Stands for the class of words with stem
#Type:Number of distinct words in a corpus(vocabulary size)
#Tokens:Total number of words

#all the data sets available in:
data(package=.packages(all.available = TRUE))


library(tm)
data("acq")
tdm<-TermDocumentMatrix(acq)
tdm

Docs(tdm)
nDocs(tdm)
nTerms(tdm)
Terms(tdm)


#Operations on a document-term matrix
#Frequent terms:From the document-term matrix created in previous section,
#try to find out the number of terms occuring more than or equal 30 times.
findFreqTerms(tdm,30)


#Term association:Correlation is a quantitative measure of the co-occurrence
#of words in multiple documents,so we need to provide a term document
#matrix as the input to the function and a correlation limit;for 
#example if we provide cottelation limit as 0.70 that function will 
#return terms that have a search term co-occurance of at least 70% and more.

findAssocs(tdm,"stock",0.70)


#Sentence segmentation
#Sentence segmentation is the process of determining the longest until
#of words.This task involves determining sentence boundaries,and we know
#most languages have punctuation to define the end of sentence.Sentence
#segmentation is also referred as sentence boundary disambiguation,
#sentence boundary detection.Some of the factors that effects Sentence
#segmentation is language,character set,algorithm,application,data
#source.Sentence in most of the languages are delimited by punctuation
#marks(标点符号),but the rules for punctuation can vary drammatically.
#Sentences and sub sentences are punctuated differently in differently
#languages.So for successful sentence segmentation understanding uses
#of punctuation in that language is important.

#Let's consider english as the language,recognizing boundaries must
#be fairly simple since it has a rich punctuation system like periods,
#question marks,exclamation(感叹词).But a period can become quite
#ambiguous since period can also be used for abbreviations(缩写词)
#like Mr.,representing decimal(小数) numbers like 1.2.


install.packages("openNLP")
library(openNLP)

s <- "I am learning text mining. This is exciting.lot to explore Mr.Paul!"
# s<-"你好!我是A.你真好." 不支持中文
sentence.boundaries <- annotate(s,Maxent_Sent_Token_Annotator(language =
    "en", probs = FALSE, model = NULL))
sentence.boundaries


#Normalizing texts
#Normalization in text basically refers to standardization or 
#canonicalization(规范化) of tokens,which we derived from documents in the 
#previous step.The simplest scenario(情景) possible could be the case
#where query tokens are an exact match to the list of tokens in the 
#document,however there can be cases when that is not true.The intent
#of normalization is to have the query and index terms in the same
#form.For instance,if you query U.K.,you might also be expecting U.K.

#Token normalization can be performed either by implicitly(隐藏的)
#creating equivalence classes or by maintaining the relations 
#between unnormalized tokens.There might be cases where we find
#superficial(表面的) differences in character sequences of tokens,
#in such cases query and index term matching becomes difficult.
#If both theses words get mapped into one term named after one of the
#members of the set for example anti-disciplinary,text retrieval(检索)
#would become so efficient.Query on one of the terms would fetch the 
#documents containing either of the terms.


#Lemmatization and stemming:词形还原，词干提取
#Grammar in every language allows usage of derivationally related
#words with similar meaning, which are nothing but different forms
#of the same word.Such as develop,developing,developed.The intent of
#performing lemmatization and stemming revolves around a similar
#objective of reducing inflectional forms and map derived words
#to the common base form.

#Stemming is a process of chopping off(切掉) the ends of words,
#mostly derivational affixes(派生词缀).Lemmatization is a more
#efficient process,which uses vocabulary and morphological(形态学)
#analysis of words and removes only the inflectional endings to
#return the base form of word as output.


#Stemming
#RWeka provides stemming functions to remove the common derivational affixes:
install.packages("RWeka")
library(RWeka)
IteratedLovinsStemmer("cars",control = NULL)
IteratedLovinsStemmer("ponies",control = NULL)


#Lemmatization词形还原
install.packages("wordnet")
library(wordnet)


#Synonyms:同义词


#Lexical diversity
#Lexical diversity is widely believed to be an important parameter to
#rate a document in terms of textual richness and effectiveness.


#Analyse lexical diversity

#Language detection:语言识别

install.packages("textcat")
library(textcat)
my.profiles<-TC_byte_profiles[names(TC_byte_profiles)]
my.profiles

my.text<-c("This book is in English language",
           "Das ist ein deutscher Satz.",
           "Il s'agit d'une phrase française.",
           "Esta es una frase en espa~nol.")
textcat(my.text,p=my.profiles)



#Chapter 3 Categorizing and Tagging Text

#In corpus linguistics,text categorization or tagging into various word
#classes or lexical categories is considered to be the second step in
#NLP pipeline after tokenization.

#Parts of speech tagging
#Hidden Markov Models for POS tagging
#Collection and contigency tables：固定搭配和偶然表
#Feature extraction
#Log-linear models
#Textual entailment:文字蕴含


#Parts of speech tagging:词性标记
#In text mining we tend to view free text as a bag of tokens.In order
#to do various quantitative analyses,searching and information 
#retrieval(检索),this approach is quite useful.However,when we take a
#bag of tokens approach,we tend to lose lots of information contained
#in the free text,such as sentence structure,word order,and context.
#These are some of the attributes of natural language processing which
#humans use to interpret(翻译) the meaning of given text.NLP is a field
#focused on understanding free text.It attempts to understand a document
#completely like a human reader.

#POS tagging is a prerequisite and one of the most important steps in
#text analysis.POS tagging is the annotation of the words with the 
#right POS tags,based on the context in which they appear,POS taggers
#categorize words based on what they mean in a sentence or in the order
#they appear.POS taggers provide information about the semantic meaning
#of the word.POS taggers use some basic categories to tag different
#words——some basic tags are noun,verb,adjective,number and proper noun.
#POS tagging is also important for information extraction and sentiment analysis.


#POS tagging with R packages
#The parts of speech Tagger tags each token with their corresponding
#parts of speech,utilizing lexical statistics,context,meaning,and their
#relative position with respect to adjacent相邻的 tokens.The same token
#may be labeled with multiple syntactic语法 labels based on the context.
#Or some word tokens may be labeled with X POS tag to denote short-hand
#for common words or misspelled words.POS tagging helps a great deal
#in resolving lexical ambiguity.R has an OpenNLP package that provides
#POS tagger functions,leveraging maximum entropy model:利用最大熵模型

library("NLP")
library("openNLP")
library("openNLPdata")

s <- "Pierre Vinken , 61 years old , will join the board as a nonexecutive director Nov. 29 .Mr. Vinken is chairman of Elsevier N.V., the Dutch publishing group ."
str<-as.String(s)
str

#First,we will annotate the sentence using the function 
#Maxent_Sent_Token_Annottor();we can use different models for different
#language.The default language used by the function is en language="en",
#which will use the default model under the language en that is under
#OpenNLPdata,that is ,en-sent.bin:

sentAnnotator<-Maxent_Sent_Token_Annotator(language = "en",probs = TRUE,
                                           model = NULL)

#The value for the model is a character string giving the path to the
#Maxent model file to be used,NULL indicating the use of a default
#model file for the given language.


annotated_sentence<-annotate(s,sentAnnotator)
annotated_sentence

#The features columns tells us the confidence level or the probability
#of the detected sentences.

actualSentence<-str
actualSentence[annotated_sentence]


#Once we have annotated the sentence we can go to the next step of 
#annotating the words.We can annotate each word by passing the annotated
#sentence to a word annotator Maxent_Word_Token_Annotator() as shown
#in the following code.We can use different models for different languages.
#The default language is en.This uses the model that is under OpenNLPdata,

wordAnnotator<-Maxent_Word_Token_Annotator(language = "en",probs = TRUE,
                                           model = NULL)
annotated_word<-annotate(s,wordAnnotator,annotated_sentence)
annotated_word


#Hidden Markov Models for POS tagging
#Hidden Markov Models(HMM) are conducive to solving classification 
#problems with generative sequences.In natural language processing,
#HMM can be used for a variety of tasks such as phrase chunking,parts
#of speech tagging,and information extraction from documents.If we
#consider words as input,while any prior information on the input can be
#considered as states,and estimated conditional probabilities can be
#considered as the output,then POS tagging can be categorized as a 
#typical sequence classification problem that can be solved using HMM.


#Basic definitions and notations

#Implementing HMMs
#When implementing an HMM,floating-point underflow浮点下溢 is a significant
#problem.When we apply the Viterbi or forward algorithms to long 
#sequences,the resultant probability values are very small,which can
#underflow on most machines.We solve this problem differently for 
#each algorithm

#Viterbi underflow维特比下溢
#As the Viterbi algorithm only multiplies probilities,a simple solution
#to underflow is to log all the probability values and then add values
#instead of multiplying. In fact,if all the values in the model matrices
#are logged,then at runtime only addition operations are needed.

#Forward algorithm underflow
#The forward algorithm sums probability values,so it is not a viable
#soltuion to log the values in order to avoid underflow.The most common
#solution to this problem is to scaling coefficients that keep the 
#probability values in the dynamic range of the machine,and that are
#dependent only on t.The coefficient ct is defined as:


#OpenNLP chunking
#The process of chunking consists of dividing a text into syntactically
#correlated parts of words,like noun groups,and verb groups,but does
#not specify their internal structure,or their role in the main sentence.
#We can use Maxent_Chunk_Annotator() for the OpenNLP R package to accomplish this.

#Before we can use this method,we have to POS tag the sentence.We can use
#the same steps performed previously for POS tagging:

chunkAnnotator<-Maxent_Chunk_Annotator(language = "en",probs = FALSE,model=NULL)
annotate(s,chunkAnnotator,posTaggedSentence)
head(annotate(s,chunkAnnotator,posTaggedSentence))


#Chunk tags块标记
#The chunk tags contain the name of the chunk type,for example,I-NP for
#noun phrase words and I-VP for verb phrase words.Most chunk types has
#two types of chunk tags:B-CHUNK for the first word of the chunk and 
#I-CHUNK for each other word in th chunk.A chunk tag like B-NP is made
#up of two parts:

#1.First part:
#B:Marks the beginning of a chunk
#I:Marks the continuation of a chunk
#E:Marks the end of a chunk

#A chunk may be only one word long or may contain multiple words



















