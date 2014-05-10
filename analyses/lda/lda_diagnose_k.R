require(tm)
require(slam)
require(topicmodels)
require(ggplot2)

load("~/Dropbox/gh_projects/uk_govt_web_archive/data/lda_models.Rdata")

options(scipen=999)
perplexity <- as.data.frame(as.matrix(lapply(lda.models, perplexity)))
perplexity$Perplexity<-as.numeric(perplexity$V1)
perplexity$K<-c(5, 50, 100, 400, 1000)
perplexity.plot<-ggplot(perplexity, aes(x=Topics (k), y=Perplexity)) + geom_line() + theme_bw(base_size = 22)


