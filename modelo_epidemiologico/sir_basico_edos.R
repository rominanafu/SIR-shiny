library(ggplot2)
library(deSolve)
library(ggiraph)
library(data.table)

# Modelo SIR básico con sistema de EDOs
sir_basico_edos <- function(input) { 
  
  # Función con las ecuaciones diferenciales
  sir.sol <- function(t, state, parms) {
    mu <- parms$mu
    beta <- parms$beta
    gamma <- parms$gamma
    
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
  S <- N * input$s_por
  I <- N - S
  R <- 0
  init <- c(S = S, I = I, R = R, N = N)
  
  # Solución de las ecuaciones diferenciales
  solucion <- ode(y = init, times = t, func = sir.sol, parms = input)
  solucion <- as.data.frame(solucion)
  
  # Preparar el gráfico
  plot <- ggplot() +
    xlab('Tiempo (días)') + ylab('Personas') +
    geom_line_interactive(
      aes(x = solucion[[1]], y = solucion$S, color = 'susceptibles', tooltip = 'Susceptibles', data_id = 'susceptibles'),
      size = 1
    ) +
    geom_line_interactive(
      aes(x = solucion[[1]], y = solucion$I, color = 'infectados', tooltip = 'Infectados', data_id = 'infectados'),
      size = 1
    ) +
    geom_line_interactive(
      aes(x = solucion[[1]], y = solucion$R, color = 'recuperados', tooltip = 'Recuperados', data_id = 'recuperados'),
      size = 1
    ) +
    ylim(0, N) +
    scale_color_manual(
      values = c(
        "susceptibles" = "#000066",
        "infectados" = "#CC0033",
        "recuperados" = "#FF6600"
      ),
      name = "Categoría"
    ) +
    ggtitle('Modelo SIR con ecuaciones diferenciales')
  
  # Convertir el gráfico en interactivo
  interactive_plot <- girafe(ggobj = plot)
  
  # Opciones de interacción
  interactive_plot <- girafe_options(
    interactive_plot,
    opts_hover(css = "stroke-width: 3px; transition: all 0.3s ease;"),
    opts_hover_inv(css = "opacity:0.5; filter:saturate(10%);"),
    opts_toolbar(saveaspng = FALSE)
  )
  
  return(interactive_plot)
}