require(tm)
require(vegan)
require(ggplot2)
require(psych)
require(cluster)
require(reshape2)

load("data/globalisation_dtm.Rdata")

rowtotals <- apply(dtm, 1, sum) # find the sum of words in each document
standarddtm <- dtm/rowtotals  # Thanks to Brandon Stewart for this and the code below here http://faculty.washington.edu/jwilker/tft/Stewart.LabHandout.pdf


sampledtm<-standarddtm[sample(nrow(standarddtm),size=(dim(standarddtm)[1]/70),replace=FALSE),]
rm(dtm)

dim(sampledtm) # check, reduced

kdata<-as.matrix(sampledtm)

# Calculate the within groups sum of squared error (SSE) for the number of cluster solutions selected by the user
set.seed(666)
n.lev<-15
wss <- rnorm(10)
while (prod(wss==sort(wss,decreasing=T))==0) {
  wss <- (nrow(kdata)-1)*sum(apply(kdata,2,var))
  for (i in 2:n.lev) wss[i] <- sum(kmeans(kdata, centers=i)$withinss)}


# Calculate the within groups SSE for 250 randomized data sets (based on the original input data)
k.rand <- function(x){
  km.rand <- matrix(sample(x),dim(x)[1],dim(x)[2])
  rand.wss <- as.matrix(dim(x)[1]-1)*sum(apply(km.rand,2,var))
  for (i in 2:n.lev) rand.wss[i] <- sum(kmeans(km.rand, centers=i)$withinss)
  rand.wss <- as.matrix(rand.wss)
  return(rand.wss)}

rand.mat <- matrix(0,n.lev,250)

k.1 <- function(x) { 
  for (i in 1:250) {
    r.mat <- as.matrix(suppressWarnings(k.rand(kdata)))
    rand.mat[,i] <- r.mat}
  return(rand.mat)}

rand.mat <- k.1(kdata)


save(wss, kdata, rand.mat, file="data/k_clusters.Rdata")
