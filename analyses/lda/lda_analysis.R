require(tm)
require(slam)
require(topicmodels)
require(ggplot2)

load("~/Dropbox/gh_projects/uk_govt_web_archive/data/sampledtm.Rdata")
load("~/Dropbox/gh_projects/uk_govt_web_archive/data/globalisation_corpus.Rdata")

ldamodel<-lda.models[[3]]
terms<-terms(ldamodel, 20)
terms
labels<-as.data.frame(terms[1,])
names(labels)<-"label"

#ldatopics <- posterior(ldamodel, sampledtm)$topics
#save(ldatopics, file="~/Dropbox/gh_projects/uk_govt_web_archive/data/ldatopics.Rdata")
load("~/Dropbox/gh_projects/uk_govt_web_archive/data/ldatopics.Rdata")


df.ldatopics <- as.data.frame(ldatopics)
df.ldatopics = cbind(webpages=as.character(rownames(df.ldatopics)), 
                     df.ldatopics, stringsAsFactors=F)


sample<-sample(as.numeric(df.ldatopics$webpages[df.ldatopics$"53" > .1]), 50) # "media"
sample<-as.numeric(df.ldatopics$webpages[df.ldatopics$"53"==max(df.ldatopics$"53")]) # "media"

for (i in sample) {
  print(meta(corpus[[i]], tag="Heading"))
}

sample<-sample(as.numeric(df.ldatopics$webpages[df.ldatopics$"17" > .1]), 50) # "Scotland"
sample<-as.numeric(df.ldatopics$webpages[df.ldatopics$"17"==max(df.ldatopics$"17")]) # "Scotland"


for (i in sample) {
  print(meta(corpus[[i]], tag="Heading"))
}

for (i in sample) {
  print(corpus[[i]])
}


