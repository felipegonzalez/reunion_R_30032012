library(ProjectTemplate)
#load.project()

pdf(file='./graphs/nube_2011.pdf', width=8, height=8)
wordcloud(output.2011[1:250,"funcion"], sqrt(output.2011[1:250,"frec.2011"]), 
    random.order=FALSE, colors=c('Black','Brown','Orange'), rot.per=0.1)
dev.off()

pdf(file='./graphs/nube_2012.pdf', width=8, height=8)
wordcloud(output.2012[1:250,"funcion"], sqrt(output.2012[1:250,"frec.2012"]), 
    random.order=FALSE, colors=c('Black','Brown','Orange'), rot.per=0.1)
dev.off()