
```r
### Assumes that cleaned data ending in '_corpus.Rdata' is in /data
require(tm)
```

```
## Loading required package: tm
```

```r
load("data/globalisation_corpus.Rdata")
```

```
## Warning: cannot open compressed file 'data/globalisation_corpus.Rdata',
## probable reason 'No such file or directory'
```

```
## Error: cannot open the connection
```

```r
dtm <- DocumentTermMatrix(corpus)
```

```
## Error: object 'corpus' not found
```

```r
dtm <- removeSparseTerms(dtm, 0.9)  # keep only terms present in more than 10% of docs
```

```
## Error: object 'dtm' not found
```

```r

summary(dtm)
```

```
## Error: object 'dtm' not found
```


