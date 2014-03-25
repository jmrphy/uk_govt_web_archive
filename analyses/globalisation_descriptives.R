### All scripts in /analyses assume that cleaned data ending in "_corpus.Rdata" are in /data

load("data/globalisation_corpus.Rdata")
dtm <- DocumentTermMatrix(corpus)
dtm <- removeSparseTerms(dtm, 0.9)  # keep only terms present in more than 10% of docs

summary(dtm)