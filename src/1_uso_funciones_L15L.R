library(ProjectTemplate)
load.project()



colnames(output.2011) <- c('funcion','frec.2011')
colnames(output.2012) <- c('funcion','frec.2012')

datos <- join(output.2012, output.2011, by="funcion", type='full')
names(datos) <- c("funcion","frec.2012","frec.2011")

#Calcular frecuencias 2011 y 2012 para las más usadas en 2011

ambas.3 <- arrange(datos, -frec.2011)
ambas.3$prop.2011 <- ambas.3$frec.2011/sum(ambas.3$frec.2011, na.rm=TRUE)
ambas.3$prop.2012 <- ambas.3$frec.2012/sum(ambas.3$frec.2012, na.rm=TRUE)

mis.ops <- opts(panel.background = theme_rect(colour = 'gray80')) # or theme_blank()

pdf(file='./graphs/frecuencias_2011vs2012.pdf')
ggplot(ambas.3[3:100,], aes(x=prop.2011, y=prop.2012,label=funcion,group=1)) + 
    geom_abline(xintercept=0, slope=1, colour="gray50") + 
    geom_point(col='salmon') + 
    scale_x_sqrt() + scale_y_sqrt() +
    geom_text(size=3.5, hjust= -0.1, colour='gray20') +
    xlab('Frecuencia 2011') + ylab('Frecuencia 2012') +
    opts(title="100 funciones más usadas en 2011 (excluyendo function y names)") + mis.ops
dev.off()
# ================================
# = Gráficas de rango-frecuencia =
# ================================
datos.m <- melt(datos, id.vars = 'funcion')
datos.m <- ddply(datos.m, c('variable'), function(df){
    df.1 <- arrange(df, -value)
    df.1$rank <- 1:nrow(df.1)
    df.1
})

pdf(file='./graphs/rango_frecuencia.pdf')
ggplot(datos.m, aes(x = log(rank), y = log(value), colour = variable)) +
    geom_point() + mis.ops
dev.off()




