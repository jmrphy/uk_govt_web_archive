require(tm)
require(slam)
require(topicmodels)
require(ggplot2)

load("~/Dropbox/gh_projects/uk_govt_web_archive/data/lda_models.Rdata")

options(scipen=999)
logliks <- as.data.frame(as.matrix(lapply(lda.models, logLik)))
logliks$LogLikelihood<-as.numeric(logliks$V1)
logliks$K<-c(50, 100, 200, 300, 400, 500)
ggplot(logliks, aes(x=K, y=LogLikelihood)) + geom_line() + theme_bw()


perplexity <- as.data.frame(as.matrix(lapply(lda.models, perplexity)))
logliks$Perplexity<-as.numeric(perplexity$V1)
ggplot(logliks, aes(x=K, y=Perplexity)) + geom_line() + theme_bw()

# compute optimum number of topics
logliks$K[diff(logliks$LogLikelihood)<=0]

k <- 30
SEED <- 2010

VEM <- LDA(dtm, k = k, control = list(seed = SEED))

VEM_fixed <- LDA(dtm, k = k, control = list(estimate.alpha = FALSE, seed = SEED)
                 
                 
                 Gibbs = LDA(dtm, k = k, method = "Gibbs",
                             control = list(seed = SEED, burnin = 1000, 
                                            thin = 100, iter = 1000)),
                 CTM = CTM(dtm, k = k, 
                           control = list(seed = SEED, 
                                          var = list(tol = 10^-4), em = list(tol = 10^-3))))

#To compare the fitted models we first investigate the values of the models fitted with VEM and estimated and with VEM andfixed 
sapply(CSC_TM[1:2], slot, "alpha")
sapply(CSC_TM, function(x) mean(apply(posterior(x)$topics, 1, function(z) - sum(z * log(z)))))
Topic <- topics(CSC_TM[["VEM"]], 1)
Terms <- terms(CSC_TM[["VEM"]], 8)
Terms
```