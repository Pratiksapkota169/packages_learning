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
#The O chunk tag is used for tokens which are not part of any chunk.
#NP:Noun chunk
#VP:Verb chunk


#Collecation and contingency tables
#When we look into a corpus,some words tend to appear in combination;
#Word combination that are considered collocations can be compound nouns,
#definition is defined by terms such as multi-word expressions,
#wulti-word units,bigrams双字母组 and idioms成语.

#Collocations can be observed in corpora and can be quantified.Multi-
#word expression have to be stored as units in order to understand
#their complete meaning.Three characteristic properties emerge as a
#common theme in the linguistic treatment of collocations:semantic语义
#non-compositionality非结构性,syntactic non-modifiability非可变性,and 
#the non-substitutability非可替代性 of components by semantically 
#similar words.Collocations are words that show mutual expectancy互相影响,
#in other words,a tendency to occur near each other.Collocations can 
#also be understood as statistically salient统计显著性 patterns that 
#can be exploited by language learners.


#Extracting co-occurrences
#There are basically three types of co-occurrences found in lexical
#data.The attraction or statistical association in words that co-occur
#is quantified by co-occurrence frequency.

#Surface Co-occurrence
#While extracting co-occurrences using this methodology,the criteria
#is that the surface distance is measured in word tokens.
#In the preceding span,umbrella is the node word,L stands for left,
#R's stand for right and numbers stand for distance.The words in the
#collocation that span around the node word can be symmetric对称(L2,R2)
#or asymmetric非对称(L2,R1).This is the traditional approach in corpus 
#linguistics语言学 and lexicography词典学.

#Textual co-occurrence
#While extracting co-occurrences using this methodology,some of the
#criteria we take into account are that words co-occur if they are in
#the same segment,for example in the same sentence,paragraph,or document.

#Syntactic co-occurrence
#In this type of co-occurrence,words have a specific syntactic relation.
#Usually,they are word combinations of a chosen syntactic pattern,
#like adjective+noun,or verb+preposition,depending on the preferred
#multi-word expression structural type.In order to do this,corpus is
#lemmatized归类,POS-tagged and parsed解析,since these steps are 
#independent of any language.Word w1 and w2 are said to co-occur only
#if there is a syntatic relation between them.This type of co-occurrence
#can help to cluster nouns that are used as objects of the same verb,
#such as tea,water,and cola,which are all used with the verb drink.


#Co-occurrence in a document
#If two words w1 and w2 are seen in the same document,they are usually
#related by topic.In this form of co-occurrence,how near or far away
#from each other the words are in the document or the order of their
#appearance is irrelevant.Document-wise co-occurrence has been successful
#used in NLP.

#Co-occurrence in a single document may talk about multiple topics,so
#we can investigate the word co-occurrence in a smaller segment of text
#such as sentence.In contrast to the document-wise model,sentence-wise
#co-occurrence does not consider the whole document,and only considers
#the number of times those two words occur in the same sentence.

#Quantifying the relation between words
#Incorpus linguistics,the statistical association or attraction between
#words is expressed in the form of a contingency table.Significance 
#testing is applied to estimate the degree of association or difference
#between two words.An independence model is hypothesized between the 
#words and is tested for a good fit.The worse the fit,the more
#associated the words are.

#Contingency tables
#Contigency tables are basically used to demonstrate the relationship
#between categorical variables.We can even call it a categorical
#equivalent of scatterplots.

#For measuring association in contingency tables,we can apply a statistical
#hypothesis test with null hypothesis H0:independence of rows and columns.
#H0 implies there is no association between w1 and w2 and the association
#score is equal to the test statistic or p-value



#Detailed analysis on textual collocations
text <- "Customer value proposition has become one of the most widely  used terms in business markets in recent years. Yet our managementpractice research reveals that there is no agreement as to what constitutes a customer value proposition—or what makes one persuasive. Moreover, we find that most value propositions make claims of savings and benefits to the customer without backing them up. An offering may actually provide superior value—but if the supplier doesn't demonstrate and document that claim, a customer manager will likely dismiss it as marketing puffery. Customer managers, increasingly held accountable for reducing costs, don't have the luxury of simply believing suppliers' assertions.Customer managers, increasingly held accountable for reducing costs, don't have the luxury of simply believing suppliers' assertions. Take the case of a company that makes integrated circuits (ICs). It hoped to supply 5 million units to an electronic device manufacturer for its next-generation product. In the course of negotiations, the supplier's salesperson learned that he was competing against a company whose price was 10 cents lower per unit. The customer asked each salesperson why his company's offering was superior. This salesperson based his value proposition on the service that he, personally, would provide. Unbeknownst to the salesperson, the customer had built a customer value model, which found that the company's offering, though 10 cents higher in price per IC, was actually worth 15.9 cents more. The electronics engineer who was leading the development project had recommended that the purchasing manager buy those ICs, even at the higher price. The service was, indeed, worth something in the model—but just 0.2 cents! Unfortunately, the salesperson had overlooked the two elements of his company's IC offering that were most valuable to the customer, evidently unaware how much they were worth to that customer and, objectively, how superior they made his company's offering to that of the competitor. Not surprisingly, when push came to shove, perhaps suspecting that his service was not worth the difference in price, the salesperson offered a 10-cent price concession to win the business—consequently leaving at least a half million dollars on the table. Some managers view the customer value proposition as a form of spin their marketing departments develop for advertising and promotional copy. This shortsighted view neglects the very real contribution of value propositions to superior business performance. Properly constructed, they force companies to rigorously focus on what their offerings are really worth to their customers. Once companies become disciplined about understanding customers, they can make smarter choices about where to allocate scarce company resources in developing new offerings."

library(tm)
# install.packages("SnowballC")
library(SnowballC)
text.corpus<-Corpus(VectorSource(text))


#Few standard text preprocessing:
text.corpus<-tm_map(text.corpus,stripWhitespace)
text.corpus<-tm_map(text.corpus,tolower)
text.corpus<-tm_map(text.corpus,removePunctuation)
text.corpus<-tm_map(text.corpus,removeWords,stopwords("english"))
text.corpus<-tm_map(text.corpus,stemDocument)
text.corpus<-tm_map(text.corpus,removeNumbers)

#Tokenizer for n-grams and passed on to the term-document matrix constructor:
library(RWeka)
length<-2 #how many words either side of word of interest
length1<-1+length*2
ngramTokenizer<-function(x) NGramTokenizer(x,Weka_control(min=length,
                                                          max=length1))
text.corpus<-tm_map(text.corpus,PlainTextDocument)
dtm<-TermDocumentMatrix(text.corpus,control = 
                          list(tokenize=ngramTokenizer))
inspect(dtm)


#Explore the term document matrix for all ngrams that have the node
#value in them:
word<-'value'
part_ngrams<-dtm$dimnames$Terms[grep(word,dtm$dimnames$Terms)]
part_ngrams

#Keep only the ngrams of interest:
part_ngrams <- part_ngrams[sapply(part_ngrams, function(i) {
  tmp <- unlist(strsplit(i, split=" "))
  tmp <- tmp[length(tmp) - length]
  tmp} == word)]

#Find the collocated word in the ngrams:
col_word<-'customer'
part_ngrams<-part_ngrams[grep(col_word,part_ngrams)]
part_ngrams

#Count the collocations:
length(part_ngrams)

#Find collocations on both sides of the collocation of interest within
#the span specified:
alwords<-paste(part_ngrams,collapse = " ")
uniques<-unique(unlist(strsplit(alwords,split = " ")))


#Feature extraction
#Feature extraction is a very important and valuable step in text
#mining.A system that can extract features from text has potential to
#be used in lots of applications.The initial step for feature extraction
#would be tagging the document;this tagged document is then processed
#to extract the required entities that are meaningful.

#The elements that can be extracted from the text are:
#Entities:These are some of the pieces of meaningful information that
#can be found in the document,for example,location,companies,people
#Attributes:These are the features of the extracted entities,for example
#the title of the person,type of organization
#Events:These are the activities in which the entities participate,for
#example,dates

#Textual Entailment Human communication is diverse in terms of the 
#useage of different expressions to communicate the same message.This
#proves to be quite a challenging problem in natural language processing.


#Semantic similarity based methods:语义相似性
#The synatactic similarity based approach:句法相似性
#The logic based method:逻辑相似性
#The vector space model approach:空间向量模型
#The surfaace string similarity based approach:字符串相似性
#Machine learning based methods


#Among the various approaches of textual entailment,semantic similarity
#is the most common.This method utilizes the similarity between concepts
#/sense to conclude whether the hypothesis can truly be inferred from
#the text.Similarity measures can quantify how alike the two concept
#are.An auto can be considered more like a car than a house,since auto
#and car share vehicle as a common ancestor with an is-a hierarchy层级.

#Synonymy and similarity:同义和相似
#The lexical unit S entails S' if they are synonyms as per WordNet,or if
#there is any association of similarity between them.


#Multiwords一词多义,negation反义词,and antonymy反义词组
#WordNet contains many multi-words which have useful semantic relations
#with other words,but it may require additional processing to normalize
#them in order to use them effectively.There can be variation due to 
#lemmatization,acronym首字母缩写 dot or different spellings.In order
#to accurately measure the similarity,fuzzy matching is implemented
#using levenshtein distance between the WordNet words and the candidate
#word.Matching is allowed if the two compared words differ by less than 10%

#In the dependency tree,if there is any negation relation between the
#leaves and the father,the negation is spread across the tree until
#the root node.

#Concept similarity
#In concept similarity we measure the similarity between two concepts,
#for example,if we consider car as one concept then it is more related
#to the concept vehicle than some other concept such as food.Similarity
#is measured by information contained in a is-a hierarchy.WordNet is 
#a lexical database that is well suited for this purpose,since nouns
#and verbs are organized in an is-a hierarchy.


#Path length
#The elementary idea of estimating similarity based on the path length
#is that the similarity between concepts can be expressed as a function
#of path length between concepts and concept position.There are different
#variants of path length calculation to quantify the concept similarity
#as a function of path length:

#Shortest Path length:The shorter the path between the words/senses in
#a hierarchy graph,the more similar the words are:
#Path length between two word S = number of edges in shortest path
#Shortest path length with depth:
#Similarity path(c1,c2)=2*deep_max-len(c1,c2)
#C1,C2 are the concepts
#len(C1,C2) is the shortest path function between two concepts C1,C2
#deep_max is a fixed value for the specific version of WordNet.

#This measure expresses the similarity between two words in terms of a
#linear combination of the shortest path and depth of the sub-tree,
#which holds very useful information about the features of the words.
#The lower the sub-tree is in the hierarchy层级,the lesser the abstract
#meaning shared by the two words:


#Resnik similarity
#Resnik similarity estimates the similarity between relatedness of
#words in terms of information content.The proportion of the amount
#of information content shared by two concept determines the semantic
#between them.Resnik considers the position of the nouns in the is-a
#hierarchy.Let C be the concepts in taxonomy分类,allowing several 
#inheritances.The key to finding similarity between concepts lies in
#the edge count of the hierarchy graph and the proportion of the 
#information shared between the concepts with respect to a highly
#specific concept,which is higher in the hierarchy and consumes both 
#of them.


#If P(concept) is the probability of encountering a councept,and entity
#A belongs to the is-a hierarchy under B,then P(A)<=P(B):
#Similarity resnik(c1,c2)=-log p(lso(c1,c2))=2IC(lso(c1,c2))

#C1,C2 are the concepts
#IC(C1) Information content based measure of concept C1
#IC(C2) Information content based measure of concept C2
#lso(C1,C2) is the lowest common subsume of C1 C2


#Lin similarity
#Lin similarity estimates the semantic association between two-concepts
#/senses in terms of the ratio of the amount of information shared 
#between two concepts to the total amount of information stored in the
#two concepts.It uses both the information required to describe the
#association between concepts and the information required to completely
#describe both of them:
#Similarity Lin(c1,c2) = 2*IC(lso(c1,c2)) / IC(c1)+IC(c2)


#Jiang-Conrath distance
#To calculate the distance between two concepts,Jiang-Conrath considers
#the information content of the concepts,along with the information
#content of the most specific subsumer:
#distance jiang(c1,c2) = (IC(c1)+IC(c2)) - 2IC(lso(c1,c2))


#Chapter 4 Dimensionality Reduction

#Data volume and high dimensions pose an astounding challenge in 
#text-mining tasks.Inherent内在的 noise and the computational cost of 
#processing huge amount of datasets make it even more arduous艰巨.
#The science of dimensionality reduction lies in the art of losing
#out on only a commensurately small numbers of information and
#still being able to reduce the high dimension space into a manageable
#proportion.


#For classification and clustering techniques to be applies to text
#data,for different natural language processing activities,we need
#to reduce the dimensions and noise in the data so that each document
#can be represented using fewer dimensions,thus significantly 
#reducing the noise that can hinder the performance.

#The curse of dimensionality:维度灾难
#Dimensionality reduction:降维
#Correspondence analysis:相关分析
#Singular vector decomposition:矩阵的奇异值分解
#ISOMAP-moving toward non-linearity:等距映射


#The curse of dimensionality
#Topic modeling and document clustering are common text mining activities,
#but the text data can be very high-dimensional,which can cause a 
#phenomenon called the curse of dimensionality.Some literature also
#calls it the concentration集中度 of measure:


#Distance is attributed to all the dimensions and assumes each of
#them to have the same effect on the distance.The higher the dimensions,
#the more similar things appear to each other.


#The similarity measures do not take into account the association of
#attributes which may result in inaccurate distance estimation.

#The number of samples required per attribute increases 
#exponentially指数 with the increase in dimensions.

#A lot of dimensions might be highly correlated with each other,thus
#causing multi-collinearity多重共线性.

#Extra dimensions cause a rapid volume increase that can result in
#high sparsity稀疏,which is a major issue in any method that requires
#statistical significance.Also,it causes huge variance in estimates,
#near duplicates,and poor predictors.

#Distance concentration and computational infeasibility
#Distance concentration is a phenomenon associated with high-dimensional
#space wherein pairwise distances or dissimilarity between points appear
#indistinguishable.All the vectors in high dimensions appear to be
#orthogonal正交 to each other.The distance between each datapoint to
#its neighbors,farthest or nearest,become equal.This totally 
#jeopardizes危害 the utility of methods that use distance based measures


#Let's consider that the number of samples is n and the number of 
#dimensions is d.If d is very large,the number of samples may prove
#to be insufficient to accurately estimate the parameters.For the 
#datasets with number of dimensions d,the number of parameters in
#the covariance matrix will be d^2.In an ideal scenario,n should be
#much larger than d^2,to avoid overfitting.

#In general,there is an optimal number of dimensions to use for a 
#given fixed number of samples.While it may feel like a good idea to
#engineer more features,if we are not able to solve a problem with
#less number of features.But the computational cost and model complexity
#increases with the rise in number of dimensions.for instance,if n
#number of samples look to be dense enough for a one-dimensional 
#feature space.For a k-dimensional feature space,n^k samples would
#be required.


#Dimensionality reduction
#Complex and noisy characteristics of textual data with high dimensions
#can be handled by dimensionality reduction techniques.These techniques
#reduce the dimension of the textual data while still preserving its
#underlying statistics.Though the dimensions are reduced,it is important
#to preserve the inter-document relationships.The idea is to have 
#minimum number of dimensions,which can preserve the intrinsic内在的
#dimensionality of the data.


#A textual collection is mostly represented in the form of a term
#document matrix wherein we have the importance of each term in a 
#document.The dimensionality of such a collection increases with
#the number of unique terms.If we were to suggest the simplest possible
#dimensionality reduction method,that would be to specify the limit
#or boundary on the distribution of different terms in the collection.
#Andy term that occurs with a significantly high frequency is not
#going to be informative for us,and the barely present terms can 
#undoubtedly be ignored and considered as noise.Some example of stop
#words are is ,was,then ,and the.

#Words that generally occur with high frequency and have no particular
#meaning are referred to as stop words.Words that occur just once or
#twice are more likely to be spelling errors or complicated words,and
#hence both these and stop words should not be considered for modeling
#the document in the Term Document Matrix(TDM).


#Principal component analysis:主成份分析
#Principal component analysis(PCA) reveals the internal structure of
#a dataset in a way that best explains the variance within the data.
#PCA identifies patterns to reduce the dimensions of the dataset
#without significant loss of information.
































































