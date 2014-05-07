setwd("~/Dropbox/gh_projects/uk_govt_web_archive")
require(tm)
require(slam)
require(topicmodels)

load("data/globalisation_dtm.Rdata")

sampledtm<-dtm[sample(nrow(dtm),size=(dim(dtm)[1]/10),replace=FALSE),]
rm(dtm)

dim(sampledtm) # check, reduced

# Deciding best K value using Log-likelihood method
set.seed(666)
lda.models <- lapply(c(5, 50, 100, 400, 1000), function(d){LDA(sampledtm, d)})
save(lda.models, file="~/Dropbox/gh_projects/uk_govt_web_archive/data/lda_models.Rdata")
save(sampledtm, file="~/Dropbox/gh_projects/uk_govt_web_archive/data/sampledtm.Rdata")
