library(ProjectTemplate)
load.project()

wordcloud(frecs.2011[1:250,"funcion"], sqrt(frecs.2011[1:250,"frec.2011"]), 
    random.order=FALSE, colors=c('Black','Brown','Orange'), rot.per=0.1)
    
wordcloud(frecs.2012[1:250,"funcion"], sqrt(frecs.2012[1:250,"frec.2012"]), 
    random.order=FALSE, colors=c('Black','Brown','Orange'), rot.per=0.1)