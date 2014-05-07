require(tm)
require(slam)
require(topicmodels)
require(ggplot2)

load("~/Dropbox/gh_projects/uk_govt_web_archive/data/lda_models.Rdata")
load("~/Dropbox/gh_projects/uk_govt_web_archive/data/sampledtm.Rdata")
load("~/Dropbox/gh_projects/uk_govt_web_archive/data/globalisation_corpus.Rdata")

options(scipen=999)
perplexity <- as.data.frame(as.matrix(lapply(lda.models, perplexity)))
perplexity$Perplexity<-as.numeric(perplexity$V1)
perplexity$K<-c(5, 50, 100, 400, 1000)
ggplot(perplexity, aes(x=K, y=Perplexity)) + geom_line() + theme_bw()


ldamodel<-lda.models[[3]]
terms<-terms(ldamodel, 10)
terms[1,]
