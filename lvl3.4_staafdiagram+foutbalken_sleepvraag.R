library(shiny)
library(ggplot2)
library(sortable)

scientists_dataset <- data.frame(
  Scientist = c(
    "sci01","sci02","sci03","sci04","sci05",
    "sci06","sci07","sci08","sci09","sci10",
    "sci11","sci12","sci13","sci14","sci15",
    "sci16","sci17","sci18","sci19","sci20"
  ),
  age_years = c(
    34, 50, 41, 29, 46,
    38, 52, 44, 31, 57,
    36, 48, 40, 53, 28,
    39, 45, 32, 55, 37
  ),
  survival_days = c(
    88, 20, 77, 55, 12,
    91, 33, 67, 82, 14,
    73, 29, 95, 18, 64,
    87, 22, 79, 31, 70
  )
)

ui <- fluidPage(
  tags$head(
    tags$style(HTML("
      body { background-color: #000000; color: #39FF14; font-family: 'Courier New'; }
      .code-box { 
        background-color: #111111; 
        border: 1px solid #39FF14; 
        padding: 10px; 
        margin-bottom: 10px; 
        border-radius: 5px;
      }
      .correct { color: #39FF14; font-weight: bold; }
      .wrong { color: #FF3131; font-weight: bold; }
      #plot-area { border: 1px solid #39FF14; padding: 10px; margin-top: 20px; }
    "))
  ),
  
  titlePanel("LEVEL 3.3 — Zet de barplot‑code in de juiste volgorde"),
  
  h4("Sleep de code‑stukken hieronder in de juiste volgorde om een barplot met foutbalken te maken."),
  
  rank_list(
    text = "Versleep de code‑stukken:",
    labels = c(
      'geom_bar(stat = "identity") +',
      'geom_errorbar(aes(ymin = survival_days - age_years, ymax = survival_days + age_years), width = 0.2) +',
      'theme_minimal()',
      'labs(title = "Survival days per scientist") +',
      'ggplot(scientists_dataset, aes(x = Scientist, y = survival_days)) +'
    ),
    input_id = "ordered_code"
  ),
  
  actionButton("check", "Check code", class = "btn btn-success"),
  
  h4(textOutput("feedback")),
  plotOutput("plot")
)

server <- function(input, output, session) {
  
  required_first <- 'ggplot(scientists_dataset, aes(x = Scientist, y = survival_days)) +'
  
  observeEvent(input$check, {
    req(input$ordered_code)
    
    if (input$ordered_code[1] == required_first) {
      
      output$feedback <- renderText("✔ Correct! Het eerste stuk is ggplot — goed gedaan!")
      
      output$plot <- renderPlot({
        ggplot(scientists_dataset, aes(x = Scientist, y = survival_days)) +
          geom_bar(stat = "identity") +
          geom_errorbar(aes(
            ymin = survival_days - age_years,
            ymax = survival_days + age_years
          ), width = 0.2) +
          labs(title = "Survival days per scientist") +
          theme_minimal()
      })
      
      session$sendCustomMessage("confetti", list())
      
    } else {
      
      output$feedback <- renderText("✘ Niet helemaal goed. Het eerste stuk moet de ggplot‑regel zijn.")
      output$plot <- renderPlot(NULL)
      
    }
  })
}

shinyApp(ui, server)
