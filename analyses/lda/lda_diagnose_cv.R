require(tm)
require(slam)
require(topicmodels)

load("data/globalisation_dtm.Rdata")

sampledtm<-dtm[sample(nrow(dtm),size=(dim(dtm)[1]/10),replace=FALSE),]
rm(dtm)

### Cross-validation to determine number of topics (k)

fold <- 1

range(col_sums(sampledtm))

set.seed(666)
folding <- 
  sample(rep(seq_len(10), 
             ceiling(nrow(sampledtm)))[seq_len(nrow(sampledtm))])

testing <- which(folding == fold)
training <- which(folding != fold)



topics <- 20 * c(1:10)
SEED <- 666
D <- nrow(sampledtm)
folding <- sample(rep(seq_len(10), ceiling(D))[seq_len(D)])
for (k in topics) {
for (chain in seq_len(10)) {
FILE <- paste("VEM_", k, "_", chain, ".rda", sep = "")
training <- LDA(dtm[folding != chain,], k = k,
control = list(seed = SEED))
testing <- LDA(dtm[folding == chain,], model = training,
control = list(estimate.beta = FALSE, seed = SEED))
save(training, testing, file = file.path("~/Dropbox/gh_projects/uk_govt_web_archive/data", FILE))
}
}


### Work from this
k <- 40

DF <- data.frame(logLik = unlist(lapply(c("VEM","VEM_fixed"), 
                                        function(x) AP_test[[x]][seq_along(topics),])),
                 k = topics,
                 Fold = rep(1:10, each = length(topics)),
                 Method = factor(rep(c("estimated", "fixed"), each = 10 * length(topics))))
print(xyplot(logLik ~ k | Method, group = Fold, data = DF, type = "b", 
             xlab = "Number of topics", ylab = "Perplexity", col = 1, lty = 1))

print(xyplot(as.vector(AP_alpha[["VEM"]][seq_along(topics),]) ~ rep(topics, 10), 
             groups = rep(1:10, each = length(topics)), 
             type = "b", xlab = "Number of topics", ylab = expression(alpha), col = 1, lty = 1),
      split = c(1, 1, 2, 1), more = TRUE)
mllh <- apply(AP_test[["Gibbs"]], 2, sapply, max)
print(xyplot(as.vector(mllh[seq_along(topics),]) ~ rep(topics, 10), groups = rep(1:10, each = length(topics)), 
             type = "b", xlab = "Number of topics", ylab = "Perplexity", col = 1, lty = 1),
      split = c(2, 1, 2, 1), more = FALSE)
