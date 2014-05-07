require(tm)
require(ggplot2)

#load("~/Dropbox/gh_projects/uk_govt_web_archive/data/globalisation_dtm.Rdata")

#meta(corpus[[1]], tag="Heading")
#meta(corpus[[1]])

## Unique websites
#headings<-unlist(lapply(corpus, function(x) meta(x, tag="Heading")))
#NROW(unique(headings))

#headings<-as.factor(headings)
#headings<-as.data.frame(table(headings))
#headings

# Plot simple frequencies
frequencies<-head(sort(colSums(inspected), decreasing=TRUE), n=50) # list terms in order of frequency, with counts
terms<-names(frequencies)
freqs<-data.frame(terms,frequencies)
freqs$terms <- factor(freqs$terms, levels=freqs$terms[order(frequencies)], ordered=TRUE)
options(scipen=999)
freq.plot<-ggplot(data=freqs, aes(x=terms, y=frequencies)) +
  geom_point(stat="identity") +
  coord_flip() +
  theme_bw()


global<-as.data.frame(findAssocs(dtm, 'global', 0.0))
global<-data.frame(row.names(global), global$global)
names(global)<-c("global","r")

capit<-as.data.frame(findAssocs(dtm, 'capit', 0))
capit<-data.frame(row.names(capit), capit$capit)
names(capit)<-c("capit","r")

wage<-as.data.frame(findAssocs(dtm, 'wage', 0))
wage<-data.frame(row.names(wage), wage$wage)
names(wage)<-c("wage","r")

inflat<-as.data.frame(findAssocs(dtm, 'inflat', 0))
inflat<-data.frame(row.names(inflat), inflat$inflat)
names(inflat)<-c("inflat","r")

unemploy<-as.data.frame(findAssocs(dtm, 'unemploy', 0))
unemploy<-data.frame(row.names(unemploy), unemploy$unemploy)
names(unemploy)<-c("unemploy","r")

econ.correlations<-data.frame(global[1:30,], capit[1:30,], wage[1:30,], inflat[1:30,], unemploy[1:30,], row.names=NULL)


requir<-as.data.frame(findAssocs(dtm, 'requir', 0))
requir<-data.frame(row.names(requir), requir$requir)
names(requir)<-c("requir","r")

necessarili<-as.data.frame(findAssocs(dtm, 'necessarili', 0))
necessarili<-data.frame(row.names(necessarili), necessarili$necessarili)
names(necessarili)<-c("necessarili","r")

system<-as.data.frame(findAssocs(dtm, 'system', 0))
system<-data.frame(row.names(system), system$system)
names(system)<-c("system","r")

threat<-as.data.frame(findAssocs(dtm, 'threat', 0))
threat<-data.frame(row.names(threat), threat$threat)
names(threat)<-c("threat","r")

threat.correlations<-data.frame(requir[1:30,], necessarili[1:30,], system[1:30,], threat[1:30,], row.names=NULL)



