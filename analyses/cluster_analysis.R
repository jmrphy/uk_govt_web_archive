require(tm)

load("~/Dropbox/gh_projects/uk_govt_web_archive/data/globalisation_corpus.Rdata")

# K = whatever was determined to be optimal
# k<-200
# cl<-kmeans(kdata, centers=k)
# summary(kclusters)
# save(cl, file="~/Dropbox/gh_projects/uk_govt_web_archive/data/cluster_model.Rdata")

load("~/Dropbox/gh_projects/uk_govt_web_archive/data/cluster_model.Rdata")



table(cl$cluster)



dfor (i in 1:k) {
  cat(paste("cluster ", i, ": ", sep=""))
  s <- sort(kclusters$centers[i,], decreasing=T)
  cat(names(s)[1:15], "\n")
  # print the tweets of every cluster + # 
  print(corpus[which(kclusters$cluster==i)])
}



clusterNum <- 2 #Set the Cluster Number you want to look at
corpus[which(kclusters$cluster==clusterNum)]  # Get documents in that cluster
 
#See a random sample of one document
inspect(corpus[which(kclusters$cluster==clusterNum)][sample(sum(kclusters$cluster==clusterNum),1)])


