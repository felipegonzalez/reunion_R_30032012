library(ProjectTemplate)
library(ggplot2)
library(arm)

## Inspirado en ejemplo de Hadley en Split Apply Combine (ver referencias)
set.seed(280572)
diamonds.2 <- subset(diamonds, cut!='Fair' & clarity!='I1' & clarity!='IF')
head(diamonds.2)


# datos por modelo
dats.mod <- ddply(diamonds.2, c("cut", "color", "clarity"), nrow)
dats.mod.2 <- arrange(dats.mod, V1, decreasing = TRUE)


## dlply - de tabla de datos a lista de modelos
modelos <- dlply(diamonds.2, c('cut','color', 'clarity'), 
    function(df){
        if(nrow(df) > 1){
            mod.1 <- bayesglm(log(carat) ~ log(price/2500) , data = df,
                prior.mean = 0, prior.scale = 4)
                mod.1
        }    
    })   
class(modelos)
length(modelos)


## graficar todos los coeficientes.
coeficientes <- ldply(modelos, coef)
head(coeficientes)


ggplot(coeficientes, aes(x = exp(`(Intercept)`), y = `log(price/2500)`, colour = clarity)) +
    geom_point(size = 3) + ylab("Elasticidad Precio del Quilates") +
    xlab("Quilates por 2500 dólares")

 

## usamos sim para simular de posteriores de los coeficientes.
coefs.simular <- ldply(modelos, function(mod){
    if(!is.null(mod)){
        simular <- sim(mod, n.sims = 500)
        data.frame(simular@coef, sigma = simular@sigma)
    }    
})


## gráfica de resumen para coeficientes
coefs.resumen <- ddply(coefs.simular, c('cut', 'clarity', 'color'), 
    summarise,
    elast.precio = mean(log.price.2500.),
    elast.precio.975 = quantile(log.price.2500., 0.975),
    elast.precio.025 = quantile(log.price.2500., 0.025),
    sigma = mean(sigma)
)



# GRÁFICAS
ggplot(subset(coefs.resumen, clarity!='I1'), aes(x = color, y = elast.precio,
    ymax = elast.precio.975, ymin = elast.precio.025, colour=cut, group=cut)) + 
    geom_linerange() + geom_point(aes(size=sigma)) +  facet_wrap(~clarity)  + geom_line() +
    ylab("Elasticidad precio de quilates") 


ggplot(subset(coefs.resumen, clarity!='I1'), aes(x = cut, y = elast.precio,
    ymax = elast.precio.975, ymin = elast.precio.025, colour=color, group=color)) + 
    geom_linerange() + geom_point(aes(size=sigma)) +  facet_wrap(~clarity)  + geom_line() +
    ylab("Elasticidad precio de quilates") 
