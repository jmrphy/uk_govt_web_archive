require(tm)
require(ggplot2)
require(psych)
require(cluster)
require(reshape2)
require(gridExtra)

load("~/Dropbox/gh_projects/uk_govt_web_archive/data/k_clusters.Rdata")
load("~/Dropbox/gh_projects/uk_govt_web_archive/data/globalisation_dtm.Rdata")


options(scipen=999)
doc.length.plot<-qplot(apply(dtm, 1, sum)) +
  geom_bar() +
  theme_bw() +
  labs(x="Count", y="Number of Terms in Document", title="The Distribution of Document Lengths")

n.lev<-15
K<-1:n.lev
wss.df<-data.frame(wss,1:n.lev)
names(wss.df)<-c("WSS", "K")

wss.plot<-ggplot(wss.df, aes(x=K, y=WSS)) +
  geom_line() +
  theme_bw() +
  labs(y="Within Sum of Squares", x="Clusters (k)", title="Within Sum of Squares by Number of Clusters")


# Calculate the mean and standard deviation of difference between SSE of actual data and SSE of 250 randomized datasets
r.sse <- matrix(0,dim(rand.mat)[1],dim(rand.mat)[2])
wss.1 <- as.matrix(wss)
for (i in 1:dim(r.sse)[2]) {
  r.temp <- abs(rand.mat[,i]-wss.1[,1])
  r.sse[,i] <- r.temp}
r.sse.m <- apply(r.sse,1,mean)
r.sse.sd <- apply(r.sse,1,sd)
r.sse.plus <- r.sse.m + r.sse.sd
r.sse.min <- r.sse.m - r.sse.sd
K<-1:n.lev

sse<-data.frame(K, r.sse.plus, r.sse.m, r.sse.min)
sse<-melt(sse, id="K")

sse.plot<-ggplot(sse, aes(x=K, y=value, colour=variable)) +
  geom_line() +
  theme_bw() +
  theme(legend.position = "none") +
  labs(y="Absolute Difference of Sum of Squared Error", x="Clusters (k)", title="Difference of Error Between Random and Actual Data by K") +
  scale_color_manual(values=c("#000000","#CC6666", "#000000"))




# # Plot within groups SSE against all tested cluster solutions for actual and randomized data - 1st: Log scale, 2nd: Normal scale

# par()
# xrange <- range(1:n.lev)
# yrange <- range(log(rand.mat),log(wss))
# plot(xrange,yrange, type='n', xlab='Cluster Solution', ylab='Log of Within Group SSE', main='Cluster Solutions against Log of SSE')
# for (i in 1:250) lines(log(rand.mat[,i]),type='l',col='red')
# lines(log(wss), type="b", col='blue')
# legend('bottomleft',c('Actual Data', '250 Random Runs'), col=c('blue', 'red'), lty=1)

# par(ask=FALSE)
# yrange <- range(rand.mat,wss)
# plot(xrange,yrange, type='n', xlab="Cluster Solution", ylab="Within Groups SSE", main="Cluster Solutions against SSE")
# for (i in 1:250) lines(rand.mat[,i],type='l',col='red')
# lines(1:n.lev, wss, type="b", col='blue')
# legend('bottomleft',c('Actual Data', '250 Random Runs'), col=c('blue', 'red'), lty=1)

