
library(data.table)
library(ggplot2)

dias <- 200
t <- 1:dias

S <- rep(0, dias)
I <- rep(0, dias)
R <- rep(0, dias)

N <- 10000
I[1] <- 3
S[1] <- N-I[1]-R[1]

p_infeccion <- 0.05
p_recuperacion <- 0.5
p_muerte <- 0.04

for( i in seq(dias-1) ) {
  infected <- sum(rbinom(S[i], 1, p_infeccion))
  recovered <- sum(rbinom(I[i], 1, p_recuperacion))
  S[i+1] <- S[i]-infected
  I[i+1] <- I[i]+infected-recovered
  R[i+1] <- R[i]+recovered
  muertos_S <- sum(rbinom(S[i+1], 1, p_muerte))
  muertos_I <- sum(rbinom(I[i+1], 1, p_muerte))
  muertos_R <- sum(rbinom(R[i+1], 1, p_muerte))
  S[i+1] <- S[i+1]-muertos_S
  I[i+1] <- I[i+1]-muertos_I
  R[i+1] <- R[i+1]-muertos_R
  nacimientos <- muertos_S+muertos_I+muertos_R
  S[i+1] <- S[i+1]+nacimientos
}

p <- ggplot() +
  geom_line(aes(x=t, y=S, color='Susceptibles')) +
  geom_line(aes(x=t, y=I, color='Infectados')) +
  geom_line(aes(x=t, y=R, color='Recuperados')) +
  xlab('Tiempo (s)') +
  ylab('Personas') +
  labs(title = 'Modelo SIR')

p