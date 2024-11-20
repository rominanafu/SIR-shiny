
library(data.table)
library(ggplot2)

dias <- 365*2
t <- 1:dias

dias_incubacion <- 4
dias_infeccion <- 7
dias_inmunidad <- 60

N <- 3000
S <- rep(0, dias)
E <- rep(0, dias_incubacion+1)
I_sint <- rep(0, dias_infeccion+1)
IS_cuarentena <- rep(0, dias_infeccion+1)
I_asint <- rep(0, dias_infeccion+1)
I <- rep(0, dias) # E + I_sint + I_asint
R <- rep(0, dias_inmunidad+1)
total_recovered <- rep(0, dias)

E[1] <- 4
I[1] <- E[1] + I_sint[1] + I_asint[1]
S[1] <- N - I[1]

# probabilidades
prob_infectarse <- 0.05
prob_sintomatico <- 0.7
prob_cuarentena_sint <- 0.9
prob_recuperarse <- 0.95

# Rango de personas con las que alguien interactua
mean_interactions <- 5
stdDesv_interactions <- 2

for (i in seq(dias-1)) {
  
  # actualizacion de dias
  
  E <- shift(E, n=1, fill = 0)
  I_sint <- shift(I_sint, n=1, fill = 0)
  IS_cuarentena <- shift(IS_cuarentena, n=1, fill = 0)
  I_asint <- shift(I_asint, n=1, fill = 0)
  R <- shift(R, n=1, fill = 0)
  
  # pasar de recuperados a susceptibles
  
  S[i+1] <- S[i] + R[dias_inmunidad+1]
  
  # pasar de susceptibles a incubando
  
  p_encuentro <- (I[i]-sum(IS_cuarentena)) / (S[i]+I[i]+sum(R)-R[dias_inmunidad+1])
  
  if( S[i] != 0 ) {
    interacciones <- abs(floor(rnorm(S[i], mean_interactions, stdDesv_interactions)))
    contagios <- rep(0, S[i])
    for( j in seq(S[i]) ) {
      contagios[j] <- min(1, rbinom(1, interacciones[j], p_encuentro*prob_infectarse))
    }
    #cat("", fill = TRUE)
    infected <- sum(contagios)
  }
  else  {
    infected <- 0
  }
  
  #infected <- sum(rbinom(S[i], 1, prob_infectarse))
  S[i+1] <- S[i+1] - infected
  E[1] <- infected
  
  # pasar de incubando a mostrar o no sintomas
  
  muestran_sintomas <- sum(rbinom(E[dias_incubacion+1], 1, prob_sintomatico))
  I_sint[1] <- muestran_sintomas
  I_asint[1] <- E[dias_incubacion+1] - muestran_sintomas
  
  # ir a cuarentena teniendo sintomas
  
  entran_cuarentena <- sum(rbinom(muestran_sintomas, 1, prob_cuarentena_sint))
  IS_cuarentena[1] <- entran_cuarentena
  
  # pasar de infectados a recuperados
  
  recovered <- sum(rbinom(I_sint[dias_infeccion+1]+I_asint[dias_infeccion+1],
                          1, prob_recuperarse))
  R[1] <- recovered
  
  I[i+1] <- I[i] +
    infected -
    I_sint[dias_infeccion+1] -
    I_asint[dias_infeccion+1]
  total_recovered[i] <- sum(R)
}

p <- ggplot() +
  geom_line(aes(x=t, y=S, color='Susceptibles')) +
  geom_line(aes(x=t, y=I, color='Infectados')) +
  geom_line(aes(x=t, y=total_recovered, color='Recuperados')) +
  xlab('Tiempo (s)') +
  ylab('Personas') +
  labs(title = 'Modelo SIR')

p