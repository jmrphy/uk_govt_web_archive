### The raw data scraped from the API is too large for github. Download yourself using /scrape/scrape.r or email me.
### This script cleans the raw scraped data and saves the cleaned data to /data.
### Analyses in the analyses directory use that data, so everything in that directory is reproducible from this repo.

require(XML)
require(tm)
require(SnowballC)
require(lubridate)

load("~/large_data/api_globalisation.Rdata") # load the api scrape from local directory outside of this repo

globalisationdata<-lapply(DF.globalisation, function(x) try(xmlParse(x))) # parse each list item as an XML doc
rm(DF.globalisation)  # remove the original from workspace

globalisation_content <- lapply(globalisationdata, function(x) try(xpathSApply(x,'//item/nutch:content',xmlValue))) # extract each item's content
globalisation_title <- lapply(globalisationdata, function(x) try(xpathSApply(x,'//item/title',xmlValue))) # extract each item's title
globalisation_site <- lapply(globalisationdata, function(x) try(xpathSApply(x,'//item/nutch:site',xmlValue))) # extract each item's website
globalisation_desc <- lapply(globalisationdata, function(x) try(xpathSApply(x,'//item/description',xmlValue))) # extract each item's description
globalisation_date <- lapply(globalisationdata, function(x) try(xpathSApply(x,'//item/nutch:date',xmlValue))) # extract each item's date


### Clean contents and make dataframe
contentdf<-as.data.frame(unlist(globalisation_content))  #67,395 entries
rm(globalisation_content)
contents <- as.data.frame(contentdf[-grep("UseMethod",contentdf[,1]),])  # About 1k were errors; 66,414 remaining
rm(contentdf)
names(contents)<-"item"
contents$item<-as.character(contents$item)

### Clean titles and make dataframe
titledf<-as.data.frame(unlist(globalisation_title)) 
rm(globalisation_title)
titles <- as.data.frame(titledf[-grep("UseMethod",titledf[,1]),])  # 66,414 remaining
rm(titledf)
names(titles)<-"item"
titles$item<-as.character(titles$item)

### Clean sites and make dataframe
sitedf<-as.data.frame(unlist(globalisation_site))  #67,395 entries
rm(globalisation_site)
sites <- as.data.frame(sitedf[-grep("UseMethod",sitedf[,1]),])  # 132,828 remaining
rm(sitedf)
names(sites)<-"item"
sites$item<-as.character(sites$item)

### Clean dates and make dataframe
datedf<-as.data.frame(unlist(globalisation_date))  #67,395 entries
rm(globalisation_date)
dates <- as.data.frame(datedf[-grep("UseMethod",datedf[,1]),])  # 66,414 remaining
rm(datedf)
names(dates)<-"item"
dates$item<-as.character(dates$item)

### Clean descriptions and make dataframe
descdf<-as.data.frame(unlist(globalisation_desc))  #67,395 entries
rm(globalisation_desc)
descs <- as.data.frame(descdf[-grep("UseMethod",descdf[,1]),])  # 66,414 remaining
rm(descdf)
names(descs)<-"item"
descs$item<-as.character(descs$item)

globalisation<-data.frame(contents,dates,descs,titles)
names(globalisation)<-c("contents", "dates", "descriptions", "titles")
globalisation$dates<-ymd_hms(head(globalisation$dates), tz="GMT")

save(globalisation, file="~/large_data/globalisation_cleaned.Rdata")
# load("~/large_data/globalisation_cleaned.Rdata")

# globalisation$dates<-as.character(globalisation$dates)

corpus<-Corpus(VectorSource(globalisation$contents))


### Basic pre-processing of the corpus for text analysis
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, tolower)
corpus <- tm_map(corpus, stripWhitespace)
corpus <- tm_map(corpus, removeWords, stopwords("english"))


corpus <- tm_map(corpus, stemDocument, language = "english")


headings <- paste0('Heading',seq(66414))
i <- 0
corpus = tm_map(corpus, function(x) {
  i <<- i +1
  meta(x, "Heading") <- globalisation[i,4]
  x
})

descriptions <- paste0('Description',seq(66414))
i <- 0
corpus = tm_map(corpus, function(x) {
  i <<- i +1
  meta(x, "Description") <- globalisation[i,3]
  x
})

dates <- paste0('DateTimeStamp',seq(66414))
i <- 0
corpus = tm_map(corpus, function(x) {
  i <<- i +1
  meta(x, "DateTimeStamp") <- globalisation[i,2]
  x
})

rm(headings, dates, descriptions,i)

summary(corpus)

save("corpus", file="data/globalisation_corpus.Rdata") # save for future use

load("data/globalisation_corpus.Rdata")

dtm <- DocumentTermMatrix(corpus)

dtm <- removeSparseTerms(dtm, 0.9)  # keep only terms present in more than 10% of docs

save("dtm", file="data/globalisation_dtm.Rdata") # save for future use



findFreqTerms(dtm, 500000)
findAssocs(dtm, 'globalis', 0.50)

options(scipen=999)
hist(apply(dtm, 1, sum), xlab="Number of Terms in Term-Document Matrix",
     main="Number of Terms Per Paper in Participant Articles Corpus", breaks=100)

rowtotals <- apply(dtm, 1, sum) # find the sum of words in each document
standarddtm <- dtm/rowtotals  # Thanks to Brandon Stewart for this and the code below here http://faculty.washington.edu/jwilker/tft/Stewart.LabHandout.pdf

set.seed(666) # very satanic
kclusters <- kmeans(standarddtm, #Our input term document matrix
                  centers=5, #The number of clusters)
                  
for (i in 1:length(kclusters$withinss)) {       
#For each cluster, this defines the documents in that cluster
    inGroup <- which(kclusters$cluster==i)
    within <- standarddtm[inGroup,]
    if(length(inGroup)==1) within <- t(as.matrix(within))
    out <- standarddtm[-inGroup,]
    words <- apply(within,2,mean) - apply(out,2,mean) #Take the difference in means for each term
    print(c("Cluster", i), quote=F)
    labels <- order(words, decreasing=T)[1:20] #Take the top 20 Labels
    print(names(words)[labels], quote=F) #From here down just labels
    if(i==length(kclusters$withinss)) {
      print("Cluster Membership")
      print(table(kclusters$cluster))
      print("Within cluster sum of squares by cluster")
      print(kclusters$withinss)
    }
}

clusterNum <- 1 #Set the Cluster Number you want to look at
#See list of all documents
filenames[which(kclusters$cluster==clusterNum)]
#See a random sample of one document
filenames[which(results$cluster==clusterNum)][sample(sum(results$cluster==clusterNum),1)]