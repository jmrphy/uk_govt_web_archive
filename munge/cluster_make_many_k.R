require(tm)
require(vegan)
require(ggplot2)
require(psych)
require(cluster)
require(reshape2)

load("data/globalisation_dtm.Rdata")

rowtotals <- apply(dtm, 1, sum) # find the sum of words in each document
standarddtm <- dtm/rowtotals  # Thanks to Brandon Stewart for this and the code below here http://faculty.washington.edu/jwilker/tft/Stewart.LabHandout.pdf

### Use euclidean distances
m <- as.matrix(standarddtm)
rownames(m) <- 1:nrow(m)

### don't forget to normalize the vectors so Euclidean makes sense
norm_eucl <- function(m) m/apply(m, MARGIN=1, FUN=function(x) sum(x^2)^.5)
kdata <- norm_eucl(m)


# Calculate the within groups sum of squared error (SSE) for the number of cluster solutions selected by the user
set.seed(666)
n.lev<-seq(100,700,100)
wss <- rnorm(10)
while (prod(wss==sort(wss,decreasing=T))==0) {
  wss <- (nrow(kdata)-1)*sum(apply(kdata,2,var))
  for (i in n.lev) wss[i] <- sum(kmeans(kdata, centers=i)$withinss)}

wss.df<-as.data.frame(wss[!is.na(wss)])

# 
# # Calculate the within groups SSE for 250 randomized data sets (based on the original input data)
# k.rand <- function(x){
#   km.rand <- matrix(sample(x),dim(x)[1],dim(x)[2])
#   rand.wss <- as.matrix(dim(x)[1]-1)*sum(apply(km.rand,2,var))
#   for (i in 2:n.lev) rand.wss[i] <- sum(kmeans(km.rand, centers=i)$withinss)
#   rand.wss <- as.matrix(rand.wss)
#   return(rand.wss)}
# 
# rand.mat <- matrix(0,n.lev,250)
# 
# k.1 <- function(x) { 
#   for (i in 1:250) {
#     r.mat <- as.matrix(suppressWarnings(k.rand(kdata)))
#     rand.mat[,i] <- r.mat}
#   return(rand.mat)}
# 
# rand.mat <- k.1(kdata)


save(wss.df, kdata, standarddtm, file="data/k_clusters.Rdata")
