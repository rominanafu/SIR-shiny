library(ggplot2)
library(deSolve)
library(ggiraph)
library(data.table)

# Modelo SIR modificado con sistema de EDOs
sir_modificado_edos <- function(input) {
  
  #funcion con las ecuaciones diferenciales 
  sir.sol.2 <- function(t, state, parms) {
    with(as.list(state), 
         {
           dxdt = rep(0, length(state))
           dxdt[1] = parms$mu_2*N - parms$beta_2*I*S/N - parms$mu_2*S - parms$u_2
           dxdt[2] = parms$beta_2*I*S/N - parms$gamma_2*I - parms$mu_2*I
           dxdt[3] = parms$gamma_2*I - parms$mu_2*R
           dxdt[4] = parms$u_2
           dxdt[5] = dxdt[1] + dxdt[2] + dxdt[3] + dxdt[4] 
           return(list(dxdt))
         })
  }
  
  t = seq(0, 365, 0.1) 
  N = 10000
  S = N * input$s_por_2
  I = N - S 
  R = 0 
  V = 0
  init = c(S = S, I = I, R = R, U = V, N = N)
  
  Output <- ode(y = init, times = t, func = sir.sol.2, parms = input)
  solution = data.frame(time = Output[, 1], 
                        susceptibles = Output[, 2],
                        infectados = Output[, 3], 
                        recuperados = Output[, 4], 
                        vacunados = Output[, 5], 
                        poblacion = Output[, 6])
  solution_long <- tidyr::pivot_longer(
    solution, 
    cols = c(susceptibles, infectados, recuperados, vacunados, poblacion),
    names_to = "category",
    values_to = "value"
  )
  
  plot <- ggplot(data = solution_long, aes(
    x = time, y = value, color = category,
    tooltip = category, data_id = category
  )) +
    geom_line_interactive(size = 1) +
    xlab("Tiempo (días)") +
    ylab("Población") +
    ggtitle("Modelo SIR con Ecuaciones Diferenciales y Vacunación") +
    scale_color_manual(
      values = c(
        "susceptibles" = "#000066",
        "infectados" = "#CC0033",
        "recuperados" = "#FF6600",
        "vacunados" = "purple",
        "poblacion" = "black"
      ),
      name = "Categoría"
    ) +
    ylim(0, N)
  
  interactive_plot <- girafe(ggobj = plot)
  interactive_plot <- girafe_options(
    interactive_plot,
    opts_hover(css = "stroke-width: 3px; transition: all 0.3s ease;"),
    opts_hover_inv(css = "opacity:0.5; filter:saturate(10%);"),
    opts_toolbar(saveaspng = FALSE)
  )
  
  return(interactive_plot)
  
}