#Modelo con ecuaciones diferenciales 

#Librerias necesarias
library(ggplot2) #grafico estático
library(deSolve) #solución numérica
library(ggiraph) #gráficos interactivos
library(tidyr) #manipulación de datos 

#Función para calcular derivadas en cada punto
diff_eq.sol <- function(t, state, parms) {
  with(as.list(state), 
       {
         dxdt = rep(0, length(state))
         dxdt[1] = parms$mu*N - parms$beta*I*S/N - parms$mu*S - parms$mu*N*parms$p #- mu*N*p para vacunación
         dxdt[2] = parms$beta*I*S/N - parms$gamma*I - parms$mu*I
         dxdt[3] = parms$gamma*I - parms$mu*R + parms$mu*N*parms$p # + mu*N*p para vacunación
         dxdt[4] = dxdt[1] + dxdt[2] + dxdt[3]
         return(list(dxdt))
       })
}

#Parámetros iniciales
mu = 0.001 
beta = 0.5 
gamma = 0.04
p = 0.7

#Condiciones iniciales
S = 997 
I = 3
R = 0 
N = S + I + R 
t_max = 30

#Solución ecuación diferencial usando ode()
t = seq(0, t_max, 0.1)
init = c(S = S, I = I, R = R, N = N)
params = data.frame(mu = mu, beta = beta, gamma = gamma, p = p)

Output = ode(y = init, times = t, func = diff_eq.sol, parms = params)

#Dataframe de solución
solution = data.frame(time = Output[, 1], 
                      susceptibles = Output[, 2],
                      infectados = Output[, 3], 
                      recuperados = Output[, 4], 
                      poblacion = Output[, 5])

#reformatear los datos en formato largo para uso en ggplot
solution_long = pivot_longer(solution, cols = c(susceptibles, infectados, recuperados, poblacion), 
                             names_to = 'variable', 
                             values_to = 'value')

#generación de gráfica estática 
plot = ggplot(solution_long, aes(x = time, y = value, 
                                 color = variable, #diferenciar por variable 
                                 tooltip = variable, #mostrar variable en el tooltip
                                 data_id = variable )) + 
  
  geom_line_interactive() + 
  labs(title = 'Modelo SIR con Ecuaciones diferenciales', 
       x = 'Tiempo', 
       y = 'Población', 
       color = 'Compartimentos') #Etiquetas del gráfico

#Convertir plot en objeto interactivo
interactive_plot = girafe(ggobj = plot)

#Ajuste de opciones de interacción y estilo del gráfico interactivo
interactive_plot = girafe_options(
  interactive_plot, 
  opts_hover(css = "stroke-width: 3px; transition: all 0.3s ease;"), 
  opts_hover_inv("opacity:0.5;filter:saturate(10%);"), 
  opts_toolbar(saveaspng = FALSE)
)

#Mostrar gráfico interactivo
interactive_plot