
library(shiny)
library(shinydashboard)
library(shinyjs)
library(ggplot2)
library(deSolve)

customCSS <- HTML({"
html, body {
    font-family: 'Montserrat', sans-serif;
    background-color: #023d54;
    color: #ffffff;
    position: relative;
    /*
    background-position: center center;
    background-attachment: fixed;
    */
}
.card {
    background-color: #1c667a; /* rgba(255, 255, 255, 0.15) */
    border-radius: 15px;
    padding: 20px;
    margin: 15px;
    text-align: center;
    cursor: pointer;
    transition: transform 0.3s, box-shadow 0.3s;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.3);
}
.card:hover {
    transform: scale(1.05);
    box-shadow: 0 8px 16px rgba(0, 0, 0, 0.5);
}
.image-banner img {
  width: 100%;
  opacity: 0.8;
}
.image-banner {
    position: relative;
    /* box-shadow: 0 8px 16px rgba(0, 0, 0, 0.5); */
    width: 100%;
    height: 300px;
    background-image: url('https://www.paho.org/sites/default/files/2021-06/banner-coronavirus_0.jpg');
    background-color: rgba(0, 0, 0, 0.5);
    background-blend-mode: darken;
    background-size: cover;
    background-position: center center;
    display: flex;
    align-items: center;
    justify-content: center;
    text-shadow: 2px 2px 4px rgba(255, 255, 255, 0.8);
}

.banner-title {
    position: absolute;
    text-align: center;
    color: #ffffff;
    font-size: 6rem;
    z-index: 2;
}

.return-button {
    display: block !important;
    margin: 20px auto !important;
    padding: 10px 20px !important;
    background-color: #00cbcc !important;
    border: none !important;
    border-radius: 5px !important;
    color: #023d54 !important;
    font-weight: bold !important;
    text-align: center !important;
    cursor: pointer !important;
    font-size: 1.5rem !important;
}
.return-button:hover {
    background-color: #00b2b2 !important;
}

.subtitulo {
    text-align: left;
    color: white;
    width: 100%;
    font-size: 2.5rem;
    font-weight: 500;
    padding-left: 20px;
    background-color: rgba(255, 255, 255, 0.15);
}

.author-row {
    display: flex;
    justify-content: center;
    gap: 20px;
    margin-top: 20px;
    margin-x: 150px;
}

.author-card {
    text-align: center;
    color: white;
}

.author-card img {
    width: 220px;
    height: 220px;
    border-radius: 50%; /* Hace las imágenes redondas */
    border: 3px solid #00cbcc;
    transition: transform 0.3s;
}

.author-card p {
    margin-top: 10px;
    font-size: 1.2rem;
    font-weight: bold;
}

.close-btn {
    position: absolute;
    top: 20px;
    right: 30px;
    font-size: 30px;
    color: #ffffff;
    cursor: pointer;
}

/* botón de regresar */
.return-button-icon {
    cursor: pointer;
    box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.3);
}
.return-button-icon:hover {
    background-color: #00b2b2 !important;
}
.return-button-icon i {
    font-size: 18px; /* Tamaño del icono */
}

"})

# UI
ui <- fluidPage(
  useShinyjs(),
  tags$head(tags$style(customCSS)),
  
  withMathJax(),
  tags$style(HTML(
    "p.eqtext div.MathJax_Display{color: white;
    font-size: 1.5rem;
    padding-bottom: 5px;
    padding-top: 10px;}",
    "p.mjleft div.MathJax_Display{text-align: left !important;}",
    "p.eqcenter div.MathJax_Display{text-align: center !important;}"
  )),
  
  uiOutput("main_ui")
)

server <- function(input, output, session) {
  
  # Página principal
  output$main_ui <- renderUI({
    div(
      div(
        class = "image-banner",
        div(class = "banner-title", "COVID-19")
      ),
      div(
        class="subtitulo",
        style = "margin-top: 20px;",
        "Introducción"
      ),
      div(
        style = "color: white; font-size: 1.5rem; padding-top: 20px;
        padding-bottom: 20px;",
        "La modelación matemática de enfermedades infecciosas es una herramienta 
        fundamental para comprender, predecir y controlar la propagación de epidemias. 
        Desde los primeros modelos simples hasta enfoques más complejos, estas 
        herramientas permiten analizar dinámicas de transmisión, evaluar estrategias 
        de intervención y anticipar el impacto de decisiones en salud pública. 
        Durante la pandemia de COVID-19, los modelos matemáticos demostraron su 
        importancia al guiar políticas de distanciamiento social, campañas de 
        vacunación y otras medidas preventivas."
      ),
      div(
        style = "color: white; font-size: 1.5rem; padding-bottom: 30px;",
        "Los modelos clásicos, como el SIR, proporcionan una base sólida para explorar 
        la evolución de enfermedades en una población, mientras que las extensiones, 
        como la inclusión de vacunación o el uso de variables aleatorias, permiten 
        ajustar los análisis a escenarios más realistas. Por otro lado, los modelos 
        estocásticos y aquellos con múltiples categorías introducen un nivel adicional 
        de complejidad que refleja mejor la incertidumbre inherente y las variaciones 
        en las interacciones humanas, la inmunidad y la respuesta a las intervenciones."
      ),
      div(
        style = "color: white; font-size: 1.5rem; padding-bottom: 30px;",
        "En esta página, presentamos diferentes enfoques para modelar la pandemia, 
        desde el clásico modelo SIR hasta variantes más avanzadas que incluyen 
        vacunación, elementos aleatorios y modelos estocásticos con mayor nivel de 
        detalle. Estos enfoques destacan cómo la evolución de los modelos matemáticos 
        mejora nuestra capacidad para interpretar datos y diseñar respuestas más 
        efectivas ante enfermedades infecciosas, asegurando que los recursos y 
        esfuerzos se destinen de manera eficiente."
      ),
      div(
        class="subtitulo",
        "Sobre los autores"
      ),
      div(
        class = "author-row",
        div(
          class = "author-card",
          img(src = "jp.jpg", alt = "Juan Pablo"),
          p("Juan Pablo Guerrero Escudero"),
          p(style="font-weight: normal;", "A01706810"),
          p(style="font-weight: normal;", "Campus Querétaro")
        ),
        div(
          class = "author-card",
          img(src = "romi.jpg", alt = "Romina"),
          p("Romina Nájera Fuentes"),
          p(style="font-weight: normal;", "A01424411"),
          p(style="font-weight: normal;", "Campus Querétaro")
        ),
        div(
          class = "author-card",
          img(src = "brau.jpg", alt = "Braulio"),
          p("Juan Braulio Olivares Rodríguez"),
          p(style="font-weight: normal;", "A01706880"),
          p(style="font-weight: normal;", "Campus Querétaro")
        )
      ),
      div(
        actionButton(
          inputId = "back_to_main",
          label = "Más...",
          class = "return-button"
        )
      )
    )
  })
  
  # Navegación entre páginas
  observeEvent(input$page, {
    if (input$page$id == "inicio") { # Inicio
      
      output$main_ui <- renderUI({
        div(
          div(
            class = "image-banner",
            div(class = "banner-title", "COVID-19")
          ),
          div(
            class="subtitulo",
            style = "margin-top: 20px;",
            "Introducción"
          ),
          div(
            style = "color: white; font-size: 1.5rem; padding-top: 20px;
        padding-bottom: 20px;",
            "La modelación matemática de enfermedades infecciosas es una herramienta 
        fundamental para comprender, predecir y controlar la propagación de epidemias. 
        Desde los primeros modelos simples hasta enfoques más complejos, estas 
        herramientas permiten analizar dinámicas de transmisión, evaluar estrategias 
        de intervención y anticipar el impacto de decisiones en salud pública. 
        Durante la pandemia de COVID-19, los modelos matemáticos demostraron su 
        importancia al guiar políticas de distanciamiento social, campañas de 
        vacunación y otras medidas preventivas."
          ),
          div(
            style = "color: white; font-size: 1.5rem; padding-bottom: 30px;",
            "Los modelos clásicos, como el SIR, proporcionan una base sólida para explorar 
        la evolución de enfermedades en una población, mientras que las extensiones, 
        como la inclusión de vacunación o el uso de variables aleatorias, permiten 
        ajustar los análisis a escenarios más realistas. Por otro lado, los modelos 
        estocásticos y aquellos con múltiples categorías introducen un nivel adicional 
        de complejidad que refleja mejor la incertidumbre inherente y las variaciones 
        en las interacciones humanas, la inmunidad y la respuesta a las intervenciones."
          ),
          div(
            style = "color: white; font-size: 1.5rem; padding-bottom: 30px;",
            "En esta página, presentamos diferentes enfoques para modelar la pandemia, 
        desde el clásico modelo SIR hasta variantes más avanzadas que incluyen 
        vacunación, elementos aleatorios y modelos estocásticos con mayor nivel de 
        detalle. Estos enfoques destacan cómo la evolución de los modelos matemáticos 
        mejora nuestra capacidad para interpretar datos y diseñar respuestas más 
        efectivas ante enfermedades infecciosas, asegurando que los recursos y 
        esfuerzos se destinen de manera eficiente."
          ),
          div(
            class="subtitulo",
            "Sobre los autores"
          ),
          div(
            class = "author-row",
            div(
              class = "author-card",
              img(src = "jp.jpg", alt = "Juan Pablo"),
              p("Juan Pablo Guerrero Escudero"),
              p(style="font-weight: normal;", "A01706810"),
              p(style="font-weight: normal;", "Campus Querétaro")
            ),
            div(
              class = "author-card",
              img(src = "romi.jpg", alt = "Romina"),
              p("Romina Nájera Fuentes"),
              p(style="font-weight: normal;", "A01424411"),
              p(style="font-weight: normal;", "Campus Querétaro")
            ),
            div(
              class = "author-card",
              img(src = "brau.jpg", alt = "Braulio"),
              p("Juan Braulio Olivares Rodríguez"),
              p(style="font-weight: normal;", "A01706880"),
              p(style="font-weight: normal;", "Campus Querétaro")
            )
          ),
          div(
            actionButton(
              inputId = "back_to_main",
              label = "Más...",
              class = "return-button"
            )
          )
        )
      })
      
    }
    else if (input$page$id == "info") { # Antecedentes
      
      output$main_ui <- renderUI({
        fluidPage(
          div(
            class = "image-banner",
            style = "background-image: url(https://observatorio.tec.mx/wp-content/uploads/2024/04/ChatGPT-como-fuente-de-informacion-preliminar-en-la-investigacion-dirigida.jpg);",
            div(class = "banner-title", "Antecedentes")
          ),
          div(
            class="subtitulo",
            style = "margin-top: 20px;",
            "COVID-19"
          ),
          div(
            style = "color: white; font-size: 1.5rem; padding-bottom: 5px;
            padding-top: 10px;",
            "La pandemia de COVID-19, causada por el virus SARS-CoV-2, comenzó a 
            finales de 2019 en la ciudad de Wuhan, China, y rápidamente se convirtió 
            en una crisis de salud global. Este virus pertenece a la familia de los 
            coronavirus, conocidos por causar enfermedades que van desde resfriados 
            comunes hasta infecciones respiratorias graves, como el SARS en 2002 
            y el MERS en 2012. Aunque se cree que el SARS-CoV-2 se originó en 
            animales, su transición exacta a humanos sigue siendo objeto de debate."
          ),
          div(
            style = "color: white; font-size: 1.5rem; padding-bottom: 5px;
            padding-top: 10px;",
            "En marzo de 2020, la Organización Mundial de la Salud (OMS) declaró al 
            COVID-19 como una pandemia, lo que llevó a medidas sin precedentes para 
            contener su propagación, incluyendo cuarentenas, restricciones de viaje 
            y el uso obligatorio de mascarillas. A pesar de los esfuerzos globales, 
            la enfermedad se extendió rápidamente, causando millones de muertes y un 
            impacto devastador en los sistemas de salud, la economía y las dinámicas 
            sociales a nivel mundial."
          ),
          div(
            style = "color: white; font-size: 1.5rem; padding-bottom: 20px;
            padding-top: 10px;",
            "El desarrollo y distribución de vacunas en tiempo récord representó un 
            hito científico que logró reducir significativamente las tasas de mortalidad 
            y casos graves en muchos países. Sin embargo, la aparición de variantes 
            del virus, como Delta y Ómicron, planteó desafíos continuos en la lucha 
            contra la enfermedad. A medida que la pandemia avanzaba, quedó claro 
            que su impacto iba más allá de la salud física, afectando la salud mental, 
            la educación y las desigualdades sociales en todo el mundo."
          ),
          div(
            class="subtitulo",
            style = "margin-top: 10px;",
            "Modelo SIR"
          ),
          div(
            style = "color: white; font-size: 1.5rem; padding-bottom: 5px;
            padding-top: 10px;",
            "El modelo SIR (Susceptible-Infectados-Recuperados) es una herramienta 
            matemática que se originó en 1927 gracias al trabajo de Kermack y McKendrick,
            quienes lo emplearon para estudiar epidemias como la peste y el cólera. 
            A pesar de haber sido formulado hace casi un siglo, este modelo sigue 
            siendo una pieza clave en la epidemiología matemática, ya que permite 
            analizar cómo una enfermedad se propaga dentro de una población cerrada 
            y homogénea."
          ),
          div(
            style = "color: white; font-size: 1.5rem; padding-bottom: 5px;
            padding-top: 10px;",
            withMathJax(),
            tags$p(
              "El modelo divide a la población en tres grupos: los susceptibles (S), 
            los infectados (I) y los recuperados (R). Los parámetros clave son la 
            tasa de transmisión (\\(\\gamma\\)) y la tasa de recuperación (\\(\\beta\\)), de los cuales 
            se deriva el número reproductivo básico (\\(R_0\\)), una medida crítica 
            para determinar si una enfermedad puede generar un brote. Además de 
            su aplicación en epidemiología, el modelo SIR también se utiliza en 
            áreas como redes sociales, marketing viral y ciberseguridad, para estudiar 
            la propagación de ideas, productos o virus informáticos.", class = "eqtext"
            )
          ),
          div(
            style = "color: white; font-size: 1.5rem; padding-bottom: 5px;
            padding-top: 10px;",
            "Este modelo puede extenderse mediante la incorporación de nuevos estados, 
            como un periodo de latencia en los modelos SEIR o inmunidad temporal 
            en los modelos SIRS. Estas extensiones lo hacen adaptable a diversos 
            escenarios reales, como se demuestra en su aplicación para analizar 
            brotes históricos y recientes, incluyendo la pandemia de COVID-19.",
          ),
          div(
            actionButton(
              inputId = "back_to_main",
              label = "Regresar",
              class = "return-button"
            )
          )
        )
      })
      
    }
    else if (input$page$id == "modelos") { # Modelos
      
      output$main_ui <- renderUI({
        
        dashboardPage(
          
          dashboardHeader(
            title = tagList(
              actionButton(
                inputId = "back_to_main", 
                class = "return-button-icon",
                label = tags$i(class = "fa fa-arrow-left"),
                style = "margin-right: 25px; background-color: #00cbcc; border: none; cursor: pointer;"
              ),
              span("Lorem ipsum", style = "color: #00cbcc; font-weight: bold;") ######################################### CAMBIAR NOMBRE
            )
          ),
          
          dashboardSidebar(
            sidebarMenu(
              id = "sidebar",
              style = "position: relative; overflow: visible;",
              menuItem("Ecuaciones Diferenciales", tabName = "edos", icon = icon("chart-line")),
              menuItem("Variables Aleatorias", tabName = "vars", icon = icon("random")),
              menuItem("Comparación", tabName = "comp", icon = icon("columns"))
            )
          ),
          
          dashboardBody(
            
            tags$head(
              tags$style(HTML("
                .main-header { background-color: #023d54 !important; }
                .main-header .logo { background-color: #023d54 !important; }
                .main-header .navbar { background-color: #023d54 !important; }
                .main-sidebar { background-color: #000000 !important; }
                .sidebar-menu > li.active > a {
                  background-color: #00cbcc !important; /* Fondo del menú activo */
                  color: white !important; /* Texto del menú activo */
                }
                .sidebar-menu > li > a { color: #00cbcc !important; }
                .sidebar-menu .fa { padding-right: 30px; }
                .content-wrapper, .right-side {
                  background-color: #1c667a !important; /* Fondo del contenido
                  084d6e 0a5768 1c667a 52788d */
                  color: white;
                }
                .content {
                  padding: 20px;
                }
              "))
            ),
            tabItems(
              
              ##################################################################
              tabItem(
                tabName = "edos",
                
                tabsetPanel(
                  
                  # Pestaña de modelo 1 con EDOs
                  tabPanel(
                    title = "SIR",
                    
                    div(
                      class = "title-section",
                      style = "font-size: 2rem; color: #00cbcc; font-weight: bold; margin-bottom: 15px;
                      margin-top: 10px;",
                      "Modelo SIR con ecuaciones diferenciales"
                    ),
                    
                    div(
                      style = "display: flex; justify-content: space-between; align-items: flex-start;",
                      
                      # Sección de Información (a la izquierda de la tabla de parámetros)
                      div(
                        class = "info-section",
                        style = "color: #ffffff;",
                        withMathJax(),
                        tags$p("El modelo más simple de SIR simplifica la dinámica de transmisión 
                               de enfermedades infecciosas al asumir una población cerrada donde todos 
                               los individuos interactúan de la misma manera. Divide a la población 
                               entre Susceptibles (S), Infectados (I) y Removidos (R). Las siguientes 
                               simplificaciones son utilizadas:",
                               class = "eqtext"),
                        tags$ul(
                          tags$li("Los individuos de la población interactúan 
                                 de manera uniforme, lo que permite calcular la tasa de nuevos contagios 
                                 igual a \\(\\beta S \\frac{I}{N}\\), donde \\(\\boldsymbol{\\beta}\\) es la tasa de 
                                 transmisión y \\(\\textbf{N}\\) el tamaño total de la población",
                                  class = "eqtext"),
                          tags$li("Hay una recuperación 
                                 constante a una tasa \\(\\boldsymbol{\\gamma} \\)",
                                  class = "eqtext"),
                          tags$li("Los recuperados no pueden volver 
                                 a infectarse ni transmitir la enfermedad",
                                  class = "eqtext"),
                          tags$li("Se considera una 
                                 tasa de mortalidad \\(\\boldsymbol{\\mu} \\) que es igual a la tasa de nacimientos, 
                                 por lo que la población se mantiene constante en todo momento",
                                  class = "eqtext")
                        ),
                        tags$p("En este modelo, 
                               el número reproductivo básico \\(R_0\\) puede ser escrito en términos de los 
                               otros parámetros de la siguiente forma \\(R_0=\\frac{\\beta}{\\gamma}\\).",
                               class = "eqtext")
                      ),
                      
                      # Parámetros
                      div(
                        class = "parameters-section",
                        style = "background-color: #2c3e50; padding: 10px; border-radius: 8px;
                        padding-left: 30px; padding-right: 30px; margin-left: 20px; margin-right: 10px;",
                        
                        h4(style = "color: #fff; text-align: center; font-weight: bold; ", "Parámetros SIR"),
                        
                        # Tabla de parámetros
                        tags$table(
                          style = "color: white; width: 100%;",
                          
                          tags$tbody(
                            tags$tr(
                              tags$td("uno", style = "padding-right: 20px; text-align: right;"),
                              tags$td(textOutput("param_uno"), style = "text-align: left;")
                            ),
                            tags$tr(
                              tags$td("dos", style = "padding-right: 20px; text-align: right;"),
                              tags$td(textOutput("param_dos"), style = "text-align: left;")
                            ),
                            tags$tr(
                              tags$td("tres", style = "padding-right: 20px; text-align: right;"),
                              tags$td(textOutput("param_tres"), style = "text-align: left;")
                            ),
                            tags$tr(
                              tags$td("cuatro", style = "padding-right: 20px; text-align: right;"),
                              tags$td(textOutput("param_cuatro"), style = "text-align: left;")
                            ),
                            tags$tr(
                              tags$td("cinco", style = "padding-right: 20px; text-align: right;"),
                              tags$td(textOutput("param_cinco"), style = "text-align: left;")
                            ),
                            tags$tr(
                              tags$td("seis", style = "padding-right: 20px; text-align: right;"),
                              tags$td(textOutput("param_seis"), style = "text-align: left;")
                            )
                          )
                        )
                      )
                    ),
                    
                    # Sección de información (debajo de la tabla de parámetros)
                    div(
                      class = "info-section",
                      style = "color: #ffffff; margin-top: 20px; margin-bottom: 20px;",
                      withMathJax(),
                      tags$p("Todas estas simplificaciones permiten modelar las interacciones 
                             entre los distintos grupos mediante las siguientes ecuaciones:",
                             class = "eqtext"),
                      tags$p("$$\\frac{dS}{dt}=\\mu N - \\beta I \\frac{S}{N} - \\mu S\\\\
                             \\frac{dI}{dt}=\\beta I \\frac{S}{N} - \\gamma I - \\mu I \\\\
                             \\frac{dR}{dt}=\\gamma I - \\mu R$$"
                             ,class = "eqcenter"),
                      tags$p("Estas ecuaciones pueden también ser representadas con el 
                             siguiente diagrama:",
                             class = "eqtext")
                    ),
                    
                    div(
                      class = "diagram-section",
                      style = "margin-top: 40px; display: flex; align-items: center;
                      justify-content: center; margin-bottom: 50px;",
                      img(src = "diagram_image.jpg", alt = "Diagrama del Modelo SIR",
                          style = "width: 80%; border-radius: 8px;")
                    ),
                    
                    div(
                      style = "display: flex;",
                      div(
                        style = "flex: 1; margin-right: 20px;
                                 display: flex; align-items: flex-start;",
                        div(
                          style = "background-color: #2c3e50;
                           padding: 15px;
                           border-radius: 8px;
                           box-shadow: 0 2px 4px rgba(0, 0, 0, 0.4);
                           max-width: 250px;
                           color: #fff;",
                          numericInput(inputId = "N",
                                       label = tags$span(style = "font-weight: bold; color: #fff;",
                                                         "Población"),
                                       value = 1000,
                                       min = 1000,
                                       max = 5000),
                          sliderInput(
                            inputId = 's_por',
                            label = tags$span(style = "font-weight: bold; color: #fff;",
                                              "Porcentaje de población inicial susceptible"),
                            min = 0.001,
                            max = 0.999,
                            value = 0.999
                          ),
                          sliderInput(
                            inputId = 'mu',
                            label = tags$span(style = "font-weight: bold; color: #fff;",
                                              "Mu"),
                            min = 0.0,
                            max = 0.05,
                            value = 0.001
                          ),
                          sliderInput(
                            inputId = 'beta',
                            label = tags$span(style = "font-weight: bold; color: #fff;",
                                              "Beta"),
                            min = 0.01,
                            max = 0.99,
                            value = 0.3
                          ),
                          sliderInput(
                            inputId = 'gamma',
                            label = tags$span(style = "font-weight: bold; color: #fff;",
                                              "Gamma"),
                            min = 0.01,
                            max = 0.99,
                            value = 0.15
                          ),
                          sliderInput(
                            inputId = 'dias',
                            label = tags$span(style = "font-weight: bold; color: #fff;",
                                              "Días a graficar"),
                            min = 1,
                            max = 1500,
                            value = 365
                          )
                        )
                      ),
                      div(
                        style = "flex: 3;",
                        plotOutput("sir_basico_edos", height = "550px")
                      )
                    )
                  ),
                  
                  # Pestaña de modelo 2 con EDOs
                  tabPanel(
                    title = "SIR modificado",
                    
                    div(
                      class = "title-section",
                      style = "font-size: 2rem; color: #00cbcc; font-weight: bold; margin-bottom: 15px;
                      margin-top: 10px;",
                      "Modelo SIR modificado con ecuaciones diferenciales"
                    ),
                    div(
                      style = "display: flex; justify-content: space-between; align-items: flex-start;",
                      
                      # Sección de Información (a la izquierda de la tabla de parámetros)
                      div(withMathJax(),
                          class = "info-section",
                          style = "color: #ffffff;",
                          p('Ahora, el modelo SIRV se basa en el modelo SIR tradicional, 
                        pero añadiendo un grupo de V (vacunados), donde u es el número de 
                        individuos susceptibles que han sido vacunados. En éste modelo, la 
                        vacunación se da de dos maneras. En primer lugar, se da eliminando 
                        un número u de individuos del grupo de susceptibles, y 
                        en segundo lugar, dentro del grupo de Vacunados se suman, y 
                        después se resta la fracción de muertes en la población vacunada. 
                        '),
                        p('Éste modelo está basado en el modelo de Hernandez-Cervantes et al. (2022), en el 
                        cuál el parametro u representa, con un mismo número, la intensidad de los esfuerzos de vacunación
                        por medio del número de susceptibles vacunados por unidad de tiempo. Si u es bajo, significa que la 
                        epidemia no está controlada significativamente, y en cambio si u es alto, significa un rápido lanzamiento 
                        de la vacunación sobre la población, lo cuál reduce los infectados (I) de manera más rápida. 
                        ')
                      ),
                      
                      # Parámetros
                      div(
                        class = "parameters-section",
                        style = "background-color: #2c3e50; padding: 10px; border-radius: 8px;
                        padding-left: 30px; padding-right: 30px; margin-left: 20px; margin-right: 10px;",
                        
                        h4(style = "color: #fff; text-align: center; font-weight: bold; ", "Parámetros SIR"),
                        
                        # Tabla de parámetros
                        tags$table(
                          style = "color: white; width: 100%;",
                          
                          tags$tbody(
                            tags$tr(
                              tags$td("uno", style = "padding-right: 20px; text-align: right;"),
                              tags$td(textOutput("param_uno"), style = "text-align: left;")
                            ),
                            tags$tr(
                              tags$td("dos", style = "padding-right: 20px; text-align: right;"),
                              tags$td(textOutput("param_dos"), style = "text-align: left;")
                            ),
                            tags$tr(
                              tags$td("tres", style = "padding-right: 20px; text-align: right;"),
                              tags$td(textOutput("param_tres"), style = "text-align: left;")
                            ),
                            tags$tr(
                              tags$td("cuatro", style = "padding-right: 20px; text-align: right;"),
                              tags$td(textOutput("param_cuatro"), style = "text-align: left;")
                            ),
                            tags$tr(
                              tags$td("cinco", style = "padding-right: 20px; text-align: right;"),
                              tags$td(textOutput("param_cinco"), style = "text-align: left;")
                            ),
                            tags$tr(
                              tags$td("seis", style = "padding-right: 20px; text-align: right;"),
                              tags$td(textOutput("param_seis"), style = "text-align: left;")
                            )
                          )
                        )
                      )
                    ),
                    
                    # Sección de información (debajo de la tabla de parámetros)
                    div(
                      class = "info-section",
                      style = "color: #ffffff; margin-top: 20px; margin-bottom: 20px;",
                      withMathJax(), 
                      tags$p("Finalmente, éstos nuevos cambios dan lugar al siguiente sistema de ecuaciones: ", 
                             class = 'eqtext'), 
                      tags$p("$$\\frac{dS}{dt}=\\mu N - \\beta I \\frac{S}{N} - \\mu S - u\\\\
                             \\frac{dI}{dt}=\\beta I \\frac{S}{N} - \\gamma I - \\mu I \\\\
                             \\frac{dR}{dt}=\\gamma I - \\mu R\\\\
                             \\frac{dV}{dt} = u - uV$$"
                             ,class = "eqcenter")
                    ),
                    div('Estas ecuaciones pueden ser representadas con el siguiente diagrama: 
'), 
                    div(
                      class = "diagram-section",
                      style = "margin-top: 40px; display: flex; align-items: center;
                      justify-content: center; margin-bottom: 50px;",
                      img(src = "diagram_image.jpg", alt = "Diagrama del Modelo SIR",
                          style = "width: 80%; border-radius: 8px;")
                    ),
                    
                    div(
                      style = "display: flex;",
                      div(
                        style = "flex: 1; margin-right: 20px;
                                 display: flex; align-items: flex-start;",
                        div(
                          style = "background-color: #2c3e50;
                           padding: 15px;
                           border-radius: 8px;
                           box-shadow: 0 2px 4px rgba(0, 0, 0, 0.4);
                           max-width: 250px;
                           color: #fff;",
                          sliderInput(
                            inputId = "n2",
                            label = tags$span(style = "font-weight: bold; color: #fff;",
                                              "Bins number"),
                            min = 20,
                            max = 50,
                            value = 50
                          ),
                          sliderInput(
                            inputId = "_",
                            label = tags$span(style = "font-weight: bold; color: #fff;",
                                              "Ejemplo 2"),
                            min = 20,
                            max = 50,
                            value = 50
                          )
                        )
                      ),
                      div(
                        style = "flex: 3;",
                        plotOutput("plot2", height = "550px")
                      )
                    )
                  )
                )
              ),
              
              ##################################################################
              tabItem(
                tabName = "vars",
                
                tabsetPanel(
                  
                  id = "tabs",
                  
                  # Pestaña de modelo 1 con variables aleatorias
                  tabPanel(
                    title = "SIR",
                    
                    div(
                      class = "title-section",
                      style = "font-size: 2rem; color: #00cbcc; font-weight: bold; margin-bottom: 15px;
                      margin-top: 10px;",
                      "Modelo SIR estocástico"
                    ),
                    
                    div(
                      style = "display: flex; justify-content: space-between; align-items: flex-start;",
                      
                      # Sección de Información (a la izquierda de la tabla de parámetros)
                      div(
                        class = "info-section",
                        style = "color: #ffffff;",
                        withMathJax(),
                        tags$p("Pueden hacerse modificaciones al modelo SIR para agregar incertidumbre 
                               con el uso de variables aleatorias, en este caso, se utilizan variables 
                               aleatorias de Bernoulli para saber si una personan contrajo o no la 
                               enfermedad. En este modelo se hacen las mismas simplificaciones que en 
                               el modelado con ecuaciones diferenciales con la diferencia en que este 
                               es un modelo estocástico, por lo que las mismas condiciones iniciales 
                               pueden llevar a resultados finales distintos. Para este modelado, 
                               requerimos definir:",
                               class = "eqtext"),
                        tags$ul(
                          tags$li("Una probabilidad de infección \\(p_i\\)que tendrá cada persona 
                                   en el grupo de Susceptibles (S)",
                                  class = "eqtext"),
                          tags$li("Una probabilidad de recuperación \\(p_r\\)que 
                                   tendrá una persona Infectada (I)",
                                  class = "eqtext")
                        ),
                        tags$p("Así, en cada día se utilizan variables 
                               aleatorias binomiales para calcular el nuevo número de infectados y el 
                               nuevo número de recuperados, actualizando cada uno de estos grupos.",
                               class = "eqtext")
                        #tags$p("$$$$",class = "eqcenter")
                      ),
                      
                      # Parámetros
                      div(
                        class = "parameters-section",
                        style = "background-color: #2c3e50; padding: 10px; border-radius: 8px;
                        padding-left: 30px; padding-right: 30px; margin-left: 20px; margin-right: 10px;",
                        
                        h4(style = "color: #fff; text-align: center; font-weight: bold; ", "Parámetros SIR"),
                        
                        # Tabla de parámetros
                        tags$table(
                          style = "color: white; width: 100%;",
                          
                          tags$tbody(
                            tags$tr(
                              tags$td("uno", style = "padding-right: 20px; text-align: right;"),
                              tags$td(textOutput("param_uno"), style = "text-align: left;")
                            ),
                            tags$tr(
                              tags$td("dos", style = "padding-right: 20px; text-align: right;"),
                              tags$td(textOutput("param_dos"), style = "text-align: left;")
                            ),
                            tags$tr(
                              tags$td("tres", style = "padding-right: 20px; text-align: right;"),
                              tags$td(textOutput("param_tres"), style = "text-align: left;")
                            ),
                            tags$tr(
                              tags$td("cuatro", style = "padding-right: 20px; text-align: right;"),
                              tags$td(textOutput("param_cuatro"), style = "text-align: left;")
                            ),
                            tags$tr(
                              tags$td("cinco", style = "padding-right: 20px; text-align: right;"),
                              tags$td(textOutput("param_cinco"), style = "text-align: left;")
                            ),
                            tags$tr(
                              tags$td("seis", style = "padding-right: 20px; text-align: right;"),
                              tags$td(textOutput("param_seis"), style = "text-align: left;")
                            )
                          )
                        )
                      )
                    ),
                    
                    # Sección de información (debajo de la tabla de parámetros)
                    div(
                      class = "info-section",
                      style = "color: #ffffff; margin-top: 20px; margin-bottom: 20px;",
                      p("Todas estas interacciones pueden ser visualizadas con el siguiente 
                        diagrama:")
                    ),
                    
                    div(
                      class = "diagram-section",
                      style = "margin-top: 40px; display: flex; align-items: center;
                      justify-content: center; margin-bottom: 50px;",
                      img(src = "diagrama-sir-probabilistico.jpg", alt = "Diagrama del Modelo SIR",
                          style = "width: 80%; border-radius: 8px;")
                    ),
                    
                    div(
                      style = "display: flex;",
                      div(
                        style = "flex: 1; margin-right: 20px;
                                 display: flex; align-items: flex-start;",
                        div(
                          style = "background-color: #2c3e50;
                           padding: 15px;
                           border-radius: 8px;
                           box-shadow: 0 2px 4px rgba(0, 0, 0, 0.4);
                           max-width: 250px;
                           color: #fff;",
                          sliderInput(
                            inputId = "n3",
                            label = tags$span(style = "font-weight: bold; color: #fff;",
                                              "Bins number"),
                            min = 20,
                            max = 50,
                            value = 50
                          ),
                          sliderInput(
                            inputId = "_",
                            label = tags$span(style = "font-weight: bold; color: #fff;",
                                              "Ejemplo 2"),
                            min = 20,
                            max = 50,
                            value = 50
                          )
                        )
                      ),
                      div(
                        style = "flex: 3;",
                        plotOutput("plot3", height = "550px")
                      )
                    )
                  ),
                  
                  # Pestaña de modelo 2 con variables aleatorias
                  tabPanel(
                    title = "SIR modificado",
                    
                    div(
                      class = "title-section",
                      style = "font-size: 2rem; color: #00cbcc; font-weight: bold; margin-bottom: 15px;
                      margin-top: 10px;",
                      "Modelo SIR estocástico modificado"
                    ),
                    
                    div(
                      style = "display: flex; justify-content: space-between; align-items: flex-start;",
                      
                      # Sección de Información (a la izquierda de la tabla de parámetros)
                      div(
                        class = "info-section",
                        style = "color: #ffffff;",
                        withMathJax(),
                        tags$p("Con el uso de variables estocásticas podemos agregar mayor número de 
                               parámetros con los que modelar la evolución de la pandemia, agregando 
                               nuevos grupos dentro de la población y usando probabilidades para modelar 
                               los cambios dentro de estos. En nuestro caso, decidimos utilizar los 
                               siguientes grupos:",
                               class = "eqtext"),
                        tags$ul(
                          tags$li("Susceptibles (S), son las personas que no tienen la 
                               enfermedad y pueden contraerla",
                                  class = "eqtext"),
                          tags$li("Expuestos o en proceso de incubación (E), 
                               las personas que contrajeron el virus pero siguen en la etapa de incubación 
                               y por lo tanto no han mostrado síntomas de la enfermedad",
                                  class = "eqtext"),
                          tags$li("Infectados 
                               Sintomáticos (\\(I_S\\)), las personas con el virus que muestran síntomas de la 
                               enfermedad",
                                  class = "eqtext"),
                          tags$li("Infectados Asintomáticos (\\(I_A\\)), personas que a pesar de tener el 
                               virus no muestran síntomas y por lo tanto pueden no darse cuenta de que la 
                               han contraído",
                                  class = "eqtext"),
                          tags$li("Cuarentena (Q), personas que al mostrar síntomas deciden 
                               aislarse de la población para no contagiar más personas",
                                  class = "eqtext"),
                          tags$li("Recuperados (R), 
                               personas que han sobrevivido a la enfermedad y tienen una inmunidad temporal ",
                                  class = "eqtext"),
                          tags$li("Muertos (D), personas que después de contraer la enfermedad no han 
                               sobrevivido a ella",
                                  class = "eqtext")
                        )
                        #tags$p("$$$$",class = "eqcenter")
                      ),
                      
                      # Parámetros
                      div(
                        class = "parameters-section",
                        style = "background-color: #2c3e50; padding: 10px; border-radius: 8px;
                        padding-left: 30px; padding-right: 30px; margin-left: 20px; margin-right: 10px;",
                        
                        h4(style = "color: #fff; text-align: center; font-weight: bold; ", "Parámetros SIR"),
                        
                        # Tabla de parámetros
                        tags$table(
                          style = "color: white; width: 100%;",
                          
                          tags$tbody(
                            tags$tr(
                              tags$td("uno", style = "padding-right: 20px; text-align: right;"),
                              tags$td(textOutput("param_uno"), style = "text-align: left;")
                            ),
                            tags$tr(
                              tags$td("dos", style = "padding-right: 20px; text-align: right;"),
                              tags$td(textOutput("param_dos"), style = "text-align: left;")
                            ),
                            tags$tr(
                              tags$td("tres", style = "padding-right: 20px; text-align: right;"),
                              tags$td(textOutput("param_tres"), style = "text-align: left;")
                            ),
                            tags$tr(
                              tags$td("cuatro", style = "padding-right: 20px; text-align: right;"),
                              tags$td(textOutput("param_cuatro"), style = "text-align: left;")
                            ),
                            tags$tr(
                              tags$td("cinco", style = "padding-right: 20px; text-align: right;"),
                              tags$td(textOutput("param_cinco"), style = "text-align: left;")
                            ),
                            tags$tr(
                              tags$td("seis", style = "padding-right: 20px; text-align: right;"),
                              tags$td(textOutput("param_seis"), style = "text-align: left;")
                            )
                          )
                        )
                      )
                    ),
                    
                    # Sección de información (debajo de la tabla de parámetros)
                    div(
                      class = "info-section",
                      style = "color: #ffffff; margin-top: 20px; margin-bottom: 20px;",
                      p("Duis ut nulla id tellus sodales tempor in sit amet risus.
                          Fusce ac pulvinar ipsum, id commodo risus. Nunc rutrum mi ipsum,
                          ac faucibus elit dapibus vitae. Integer est enim, finibus ac pretium in,
                          ullamcorper vel est. Nulla in est quis arcu maximus dictum et non metus.
                          Donec tempor suscipit risus. Quisque accumsan, tortor eu sagittis
                          tincidunt, lacus leo suscipit nisl, id lobortis nulla sapien nec nulla.
                          Vestibulum faucibus vel dui nec dignissim. Etiam aliquam egestas justo,
                          nec egestas nunc. Fusce faucibus egestas tempor. Morbi faucibus augue
                          varius tincidunt pretium. Aliquam tempor, tellus non fringilla viverra,
                          turpis nibh fringilla massa, sit amet congue ex neque posuere risus.
                          Aliquam dignissim ex et purus mattis imperdiet. Integer mauris risus,
                          porta nec pulvinar sit amet, viverra sit amet ex.")
                    ),
                    
                    div(
                      class = "diagram-section",
                      style = "margin-top: 40px; display: flex; align-items: center;
                      justify-content: center; margin-bottom: 50px;",
                      img(src = "diagrama-sir-probabilistico.jpg", alt = "Diagrama del Modelo SIR",
                          style = "width: 80%; border-radius: 8px;")
                    ),
                    
                    div(
                      style = "display: flex;",
                      div(
                        style = "flex: 1; margin-right: 20px;
                                 display: flex; align-items: flex-start;",
                        div(
                          style = "background-color: #2c3e50;
                           padding: 15px;
                           border-radius: 8px;
                           box-shadow: 0 2px 4px rgba(0, 0, 0, 0.4);
                           max-width: 250px;
                           color: #fff;",
                          sliderInput(
                            inputId = "n4",
                            label = tags$span(style = "font-weight: bold; color: #fff;",
                                              "Bins number"),
                            min = 20,
                            max = 50,
                            value = 50
                          ),
                          sliderInput(
                            inputId = "_",
                            label = tags$span(style = "font-weight: bold; color: #fff;",
                                              "Ejemplo 2"),
                            min = 20,
                            max = 50,
                            value = 50
                          )
                        )
                      ),
                      div(
                        style = "flex: 3;",
                        plotOutput("plot4", height = "550px")
                      )
                    )
                  )
                  
                ),
                
                tags$head(
                  tags$style(HTML("
                      .nav-tabs > li > a {
                        color: white !important;  /* Título blanco cuando no está seleccionado */
                        background-color: transparent;  /* Fondo transparente por defecto */
                      }
                      .nav-tabs > li.active > a {
                        color: black !important;  /* Título negro cuando está seleccionado */
                        background-color: #f5f5f5 !important;  /* Fondo gris claro para la pestaña activa */
                        font-weight: bold;  /* Opcional: hace que el texto activo sea más destacado */
                      }
                      .nav-tabs > li > a:hover {
                        color: black !important;  /* Título negro cuando está en hover */
                        background-color: #e8e8e8 !important;  /* Fondo más claro al pasar el mouse */
                      }
                    "))
                )
                
              ),
              
              ##################################################################
              tabItem( # pros-contras de edos y vars
                # imagenes de comparacion sir simple entre edos y vars
                tabName = "comp"
              )
              
            )
          )
        )
        
      })
      
      # PARÁMETROS DE EJEMPLO
      params2 <- list(
        R0 = 3.5,
        beta = 0.3,
        gamma = 0.1,
        sigma = 0.15,
        omega = 0.05,
        mu = 0.01
      )
      
      # Output de cada parámetro
      output$param_uno <- renderText({ sprintf("%.1f", params2$R0) })
      output$param_dos <- renderText({ sprintf("%.3f", params2$beta) })
      output$param_tres <- renderText({ sprintf("%.3f", params2$gamma) })
      output$param_cuatro <- renderText({ sprintf("%.3f", params2$sigma) })
      output$param_cinco <- renderText({ sprintf("%.3f", params2$omega) })
      output$param_seis <- renderText({ sprintf("%.3f", params2$mu) })
      
      # Output de plots
      output$sir_basico_edos <- renderPlot({ # Modelo SIR básico con sistema de EDOs
        
        # funcion con las ecuaciones diferenciales
        sir.sol <- function(t, state, parms) {
          mu <- parms$mu
          beta <- parms$beta
          gamma <- parms$gamma
          
          with(as.list(state), {
            dndt = rep(0, length(state))
            dndt[1] = mu * N - beta * I * S / N - mu * S
            dndt[2] = beta * I * S / N - gamma * I - mu * I
            dndt[3] = gamma * I - mu * R
            dndt[4] = mu * (N - S - I - R)
            return(list(dndt))
          })
        }
        
        t <- seq(0, input$dias, 1)
        N <- input$N
        S <- N * input$s_por
        I <- N - S
        R <- 0
        init <- c(S = S, I = I, R = R, N = N)
        
        solucion <- ode(y = init, times = t, func = sir.sol, parms = input)
        solucion <- as.data.frame(solucion)
        
        p <- ggplot() + xlab('Tiempo (dias)') + ylab('y') +
          geom_line(aes(x = solucion[[1]], y = solucion$S, color = 'susceptibles')) +
          geom_line(aes(x = solucion[[1]], y = solucion$I, color = 'infectados')) +
          geom_line(aes(x = solucion[[1]], y = solucion$R, color = 'recuperados')) +
          ylim(0, input$N)
        
        p <- p +
          scale_color_manual(values = c("susceptibles" = "#000066",
                                        "infectados" = "#CC0033",
                                        "recuperados" = "#FF6600")) +
          ggtitle('Modelo SIR con ecuaciones diferenciales') +
          xlab('Tiempo (días)') +
          ylab('Personas')
        p
      })
      output$plot2 <- renderPlot({
        data <- rnorm(500) 
        hist(data, breaks=input$n2)
      })
      output$plot3 <- renderPlot({
        data <- rnorm(500) 
        hist(data, breaks=input$n3)
      })
      output$plot4 <- renderPlot({
        data <- rnorm(500) 
        hist(data, breaks=input$n4)
      })
      
    }
    # else if (input$page$id == "comp") { # Variables aleatorias
    #   
    #   output$main_ui <- renderUI({
    #     div(
    #       p("próximamente")
    #     )
    #   })
    #   
    # }
    else if (input$page$id == "ref") { # Referencias
      
      output$main_ui <- renderUI({
        fluidPage(
          div(
            class = "image-banner",
            style = "background-image: url(https://tesisdoctoralesonline.com/wp-content/uploads/2021/11/header_bibliografia-trabajo-universitario.jpg);",
            div(class = "banner-title", "Referencias")
          ),
          div(style="height: 20px;"),
          div(
            style = "color: white; font-size: 1.5rem; padding-bottom: 10px;",
            "Prodanov D. (2022). Analytical solutions and parameter estimation of 
            the SIR epidemic model. Mathematical Analysis of Infectious Diseases, 
            163–189. https://doi.org/10.1016/B978-0-32-390504-6.00015-2"
          ),
          div(
            style = "color: white; font-size: 1.5rem; padding-bottom: 10px;",
            "Sheposh, R. (2024). Coronavirus Disease 2019 (COVID-19). Salem Press Encyclopedia of Health. "
          ),
          div(
            actionButton(
              inputId = "back_to_main",
              label = "Regresar",
              class = "return-button"
            )
          )
        )
      })
      
    }
  })
  
  # Página con tarjetas
  observeEvent(input$back_to_main, {
    output$main_ui <- renderUI({
      div(
        
        h1("Modelación epidemiológica COVID-19", style = "text-align: center;
           color: #00cbcc; margin-top: 20px;"),
        
        div(
          class = "cards-container",
          
          # Inicio
          div(class = "card", onclick = "Shiny.setInputValue('page',
              {id: 'inicio', timestamp: new Date().getTime()});",
              h2("Página principal")
          ),
          
          # Antecedentes
          div(class = "card", onclick = "Shiny.setInputValue('page',
              {id: 'info', timestamp: new Date().getTime()});",
              h2("Antecedentes"),
              p("Sobre las ecuaciones, los parámetros y el modelo")
          ),
          
          # Modelos (edos, vars, comp)
          div(class = "card", onclick = "Shiny.setInputValue('page',
              {id: 'modelos', timestamp: new Date().getTime()});",
              h2("Modelos"),
              p("Modelación del COVID-19 con ecuaciones diferenciales y
                varibles aleatorias")
          ),
          
          # # Comparación
          # div(class = "card", onclick = "Shiny.setInputValue('page',
          #     {id: 'comp', timestamp: new Date().getTime()});",
          #     h2("Comparación"),
          #     p("")
          # ),
          
          # Referencias
          div(class = "card", onclick = "Shiny.setInputValue('page',
              {id: 'ref', timestamp: new Date().getTime()});",
              h2("Referencias"),
              p("")
          )
        )
        
      )
    })
  })
  
}

shinyApp(ui, server)
