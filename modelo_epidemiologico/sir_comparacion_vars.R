library(ggplot2)
library(deSolve)
library(ggiraph)
library(data.table)

# Modelo SIR variables aleatorias, comparación
sir_comparacion_vars <- function(input) {
  dias <- 365
  t <- 1:dias
  
  dias_incubacion <- 4
  dias_infeccion <- 7
  dias_inmunidad <- input$dias_inmunidad_6
  
  N <- 10000
  S <- rep(0, dias)
  E <- rep(0, dias_incubacion+1)
  I_sint <- rep(0, dias_infeccion+1)
  IS_cuarentena <- rep(0, dias_infeccion+1)
  I_asint <- rep(0, dias_infeccion+1)
  I <- rep(0, dias) # E + I_sint + I_asint
  R <- rep(0, dias_inmunidad+1)
  total_deads <- rep(0, dias)
  
  E[1] <- 4
  I[1] <- E[1] + I_sint[1] + I_asint[1]
  S[1] <- N - I[1]
  
  # probabilidades
  prob_infectarse_sin_cubrebocas <- 0.05  # sin cubrebocas
  prob_infectarse_cubrebocas <- 0.02 # con cubrebocas
  
  prob_cuarentena_sint <- input$prob_cuarentena_sintomatico_6
  prob_recuperarse <- input$prob_recuperarse_6
  
  prob_sintomatico <- 0.559
  
  bool_cubrebocas = TRUE
  dias_cubrebocas = input$dias_cubrebocas_6
  
  # Rango de personas con las que alguien interactua
  mean_interactions <- input$promedio_interacciones_6
  stdDesv_interactions <- 2
  
  for (i in seq(dias-1)) {
    
    # actualizacion de dias
    
    E <- shift(E, n=1, fill = 0)
    I_sint <- shift(I_sint, n=1, fill = 0)
    IS_cuarentena <- shift(IS_cuarentena, n=1, fill = 0)
    I_asint <- shift(I_asint, n=1, fill = 0)
    R <- shift(R, n=1, fill = 0)
    
    if( bool_cubrebocas && i >= dias_cubrebocas ) {
      prob_infectarse <- prob_infectarse_cubrebocas
    }
    else {
      prob_infectarse <- prob_infectarse_sin_cubrebocas
    }
    
    # pasar de recuperados a susceptibles
    
    S[i+1] <- S[i] + R[dias_inmunidad+1]
    
    # pasar de susceptibles a incubando
    
    # revisar si los que están en E también pueden contagiar (investigar)
    p_encuentro <- (I[i]-sum(IS_cuarentena)) / (S[i]+I[i]+sum(R)-R[dias_inmunidad+1])
    
    if( S[i] != 0 ) {
      interacciones <- abs(floor(rnorm(S[i], mean_interactions, stdDesv_interactions)))
      interacciones[interacciones < 0] <- 0
      probabilities <- (1-p_encuentro*prob_infectarse)^interacciones
      contagios <- 1-rbinom(S[i], 1, probabilities)
      infected <- sum(contagios)
    }
    else  {
      infected <- 0
    }
    
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
    total_deads[i+1] <- total_deads[i]+I_sint[dias_infeccion+1]+I_asint[dias_infeccion+1]-
      recovered
    
    I[i+1] <- I[i] +
      infected -
      I_sint[dias_infeccion+1] -
      I_asint[dias_infeccion+1]
    
  }
  
  S2 = S
  I2 = I
  total_deads2 = total_deads
  
  dias <- 365
  t <- 1:dias
  
  dias_incubacion <- 4
  dias_infeccion <- 7
  dias_inmunidad <- input$dias_inmunidad_6
  
  N <- 10000
  S <- rep(0, dias)
  E <- rep(0, dias_incubacion+1)
  I_sint <- rep(0, dias_infeccion+1)
  IS_cuarentena <- rep(0, dias_infeccion+1)
  I_asint <- rep(0, dias_infeccion+1)
  I <- rep(0, dias) # E + I_sint + I_asint
  R <- rep(0, dias_inmunidad+1)
  total_deads <- rep(0, dias)
  
  E[1] <- 4
  I[1] <- E[1] + I_sint[1] + I_asint[1]
  S[1] <- N - I[1]
  
  # probabilidades
  prob_infectarse_sin_cubrebocas <- 0.05  # sin cubrebocas
  prob_infectarse_cubrebocas <- 0.02 # con cubrebocas
  
  prob_cuarentena_sint <- input$prob_cuarentena_sintomatico_6
  prob_recuperarse <- input$prob_recuperarse_6
  
  prob_sintomatico <- 0.559
  
  bool_cubrebocas = FALSE
  dias_cubrebocas = input$dias_cubrebocas_6
  
  # Rango de personas con las que alguien interactua
  mean_interactions <- input$promedio_interacciones_6
  stdDesv_interactions <- 2
  
  for (i in seq(dias-1)) {
    
    # actualizacion de dias
    
    E <- shift(E, n=1, fill = 0)
    I_sint <- shift(I_sint, n=1, fill = 0)
    IS_cuarentena <- shift(IS_cuarentena, n=1, fill = 0)
    I_asint <- shift(I_asint, n=1, fill = 0)
    R <- shift(R, n=1, fill = 0)
    
    if( bool_cubrebocas && i >= dias_cubrebocas ) {
      prob_infectarse <- prob_infectarse_cubrebocas
    }
    else {
      prob_infectarse <- prob_infectarse_sin_cubrebocas
    }
    
    # pasar de recuperados a susceptibles
    
    S[i+1] <- S[i] + R[dias_inmunidad+1]
    
    # pasar de susceptibles a incubando
    
    # revisar si los que están en E también pueden contagiar (investigar)
    p_encuentro <- (I[i]-sum(IS_cuarentena)) / (S[i]+I[i]+sum(R)-R[dias_inmunidad+1])
    
    if( S[i] != 0 ) {
      interacciones <- abs(floor(rnorm(S[i], mean_interactions, stdDesv_interactions)))
      interacciones[interacciones < 0] <- 0
      probabilities <- (1-p_encuentro*prob_infectarse)^interacciones
      contagios <- 1-rbinom(S[i], 1, probabilities)
      infected <- sum(contagios)
    }
    else  {
      infected <- 0
    }
    
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
    total_deads[i+1] <- total_deads[i]+I_sint[dias_infeccion+1]+I_asint[dias_infeccion+1]-
      recovered
    
    I[i+1] <- I[i] +
      infected -
      I_sint[dias_infeccion+1] -
      I_asint[dias_infeccion+1]
    
  }
  
  p <- ggplot() +
    geom_line(aes(x=t, y=S2, color='Susceptibles', linetype = "Con cubrebocas")) +
    geom_line(aes(x=t, y=I2, color='Infectados', linetype = "Con cubrebocas")) +
    geom_line(aes(x=t, y=total_deads2, color='Muertes acumuladas', linetype = "Con cubrebocas")) +
    geom_line(aes(x=t, y=S, color='Susceptibles', linetype = "Sin cubrebocas")) +
    geom_line(aes(x=t, y=I, color='Infectados', linetype = "Sin cubrebocas")) +
    geom_line(aes(x=t, y=total_deads, color='Muertes acumuladas', linetype = "Sin cubrebocas")) +
    xlab('Tiempo (s)') +
    ylab('Personas') +
    labs(title = 'Modelo SIR estocástico')
  
  
  p <- p +
    scale_linetype_manual(values=c("Con cubrebocas" = "solid", "Sin cubrebocas" = "dashed"))
  
  p
}