library(ggplot2)
library(deSolve)
library(ggiraph)
library(data.table)

# Modelo SIR básico con variables aleatorias
sir_basico_vars <- function(input) {
  
  sir.sol <- function(t, state, parms) {
    mu <- parms$mu_5
    beta <- parms$beta_5
    gamma <- parms$gamma_5
    
    with(as.list(state), {
      dndt <- rep(0, length(state))
      dndt[1] <- mu * N - beta * I * S / N - mu * S
      dndt[2] <- beta * I * S / N - gamma * I - mu * I
      dndt[3] <- gamma * I - mu * R
      dndt[4] <- mu * (N - S - I - R)
      return(list(dndt))
    })
  }
  
  # Parámetros iniciales
  t <- seq(0, 365, 1)
  N <- 10000
  S <- N * input$s_por_5
  I <- N - S
  R <- 0
  init <- c(S = S, I = I, R = R, N = N)
  
  # Solución de las ecuaciones diferenciales
  solucion1 <- ode(y = init, times = t, func = sir.sol, parms = input)
  solucion1 <- as.data.frame(solucion1)
  
  #funcion con las ecuaciones diferenciales 
  sir.sol.2 <- function(t, state, parms) {
    with(as.list(state), 
         {
           dxdt = rep(0, length(state))
           dxdt[1] = parms$mu_5*N - parms$beta_5*I*S/N - parms$mu_5*S - parms$u_5
           dxdt[2] = parms$beta_5*I*S/N - parms$gamma_5*I - parms$mu_5*I
           dxdt[3] = parms$gamma_5*I - parms$mu_5*R
           dxdt[4] = parms$u_5
           dxdt[5] = dxdt[1] + dxdt[2] + dxdt[3] + dxdt[4] 
           return(list(dxdt))
         })
  }
  
  t = seq(0, 365, 0.1) 
  N = 10000
  S = N * input$s_por_5
  I = N - S 
  R = 0 
  V = 0
  init = c(S = S, I = I, R = R, V = V, N = N)
  
  Output <- ode(y = init, times = t, func = sir.sol.2, parms = input)
  solucion <- as.data.frame(Output)
  
  p <- ggplot() +
    geom_line(aes(x = solucion1[[1]], y = solucion1$S, color = 'susceptibles', linetype = 'Sin vacunación')) +
    geom_line(aes(x = solucion1[[1]], y = solucion1$I, color = 'infectados', linetype = 'Sin vacunación')) +
    geom_line(aes(x = solucion1[[1]], y = solucion1$R, color = 'recuperados', linetype = 'Sin vacunación')) +
    geom_line(aes(x = solucion[[1]], y = solucion$S, color = 'susceptibles', linetype = 'Con vacunación')) +
    geom_line(aes(x = solucion[[1]], y = solucion$I, color = 'infectados', linetype = 'Con vacunación')) +
    geom_line(aes(x = solucion[[1]], y = solucion$R, color = 'recuperados', linetype = 'Con vacunación')) +
    geom_line(aes(x = solucion[[1]], y = solucion$V, color = 'vacunados', linetype = 'Con vacunación')) +
    xlab("Tiempo (días)") +
    ylab("Población") +
    ggtitle("Modelo SIR Determinista") +
    scale_color_manual(
      values = c(
        "susceptibles" = "#000066",
        "infectados" = "#CC0033",
        "recuperados" = "#FF6600",
        "vacunados" = "purple"
      ),
      name = "Categoría"
    ) +
    scale_linetype_manual(values=c("Con vacunación" = "solid", "Sin vacunación" = "dashed")) +
    ylim(0, N)
  
  p
  
}