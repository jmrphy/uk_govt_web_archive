findFreqTerms(dtm, 500000)
findAssocs(dtm, 'inflat', 0.40)
findAssocs(dtm, 'wage', 0.40)
findAssocs(dtm, 'global', 0.50)

meta(corpus[[1]], tag="Heading")

headings<-unlist(lapply(corpus, function(x) meta(x, tag="Heading")))
headings<-as.factor(headings)
headings<-as.data.frame(table(headings))