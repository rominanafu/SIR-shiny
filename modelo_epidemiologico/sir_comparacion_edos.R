library(ggplot2)
library(deSolve)
library(ggiraph)
library(data.table)

# Modelo SIR sistema de EDOs, comparación
sir_comparacion_edos <- function(input) {
  dias <- 200
  t <- 1:dias
  
  
  S <- rep(0, dias)
  I <- rep(0, dias)
  R <- rep(0, dias)
  
  N <- 10000
  I[1] <- 3
  S[1] <- N - I[1] - R[1]
  
  p_infeccion <- input$p_infeccion3
  p_recuperacion <- input$p_recuperacion3
  p_muerte <- input$p_muerte3
  
  
  for (i in seq(dias - 1)) {
    infected <- sum(rbinom(S[i], 1, p_infeccion))
    recovered <- sum(rbinom(I[i], 1, p_recuperacion))
    S[i + 1] <- S[i] - infected
    I[i + 1] <- I[i] + infected - recovered
    R[i + 1] <- R[i] + recovered
    muertos_S <- sum(rbinom(S[i + 1], 1, p_muerte))
    muertos_I <- sum(rbinom(I[i + 1], 1, p_muerte))
    muertos_R <- sum(rbinom(R[i + 1], 1, p_muerte))
    S[i + 1] <- S[i + 1] - muertos_S
    I[i + 1] <- I[i + 1] - muertos_I
    R[i + 1] <- R[i + 1] - muertos_R
    nacimientos <- muertos_S + muertos_I + muertos_R
    S[i + 1] <- S[i + 1] + nacimientos
  }
  
  
  data <- data.frame(
    Time = rep(t, 3),
    Population = c(S, I, R),
    Category = c(rep("Susceptibles", dias), rep("Infectados", dias), rep("Recuperados", dias))
  )
  
  
  p <- ggplot(data, aes(x = Time, y = Population, color = Category)) +
    geom_line_interactive(aes(
      tooltip = Category, data_id = Category
    ), size = 1) +
    xlab("Tiempo (días)") +
    ylab("Personas") +
    ggtitle("Modelo SIR estocástico básico") +
    scale_color_manual(
      values = c(
        "Susceptibles" = "#000066",
        "Infectados" = "#CC0033",
        "Recuperados" = "#FF6600"
      ),
      name = "Categoría"
    )
  
  
  interactive_plot <- girafe(ggobj = p)
  
  # Add interactive options
  interactive_plot <- girafe_options(
    interactive_plot,
    opts_hover(css = "stroke-width: 3px; transition: all 0.3s ease;"),
    opts_hover_inv(css = "opacity:0.5; filter:saturate(10%);"),
    opts_toolbar(saveaspng = FALSE)
  )
  
  return(interactive_plot)
}