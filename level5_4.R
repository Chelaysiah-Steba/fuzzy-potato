library(shiny)
library(ggplot2)
library(sortable)

tidy_scientists <- data.frame(
  Scientist = c(
    "sci01","sci02","sci03","sci04","sci05",
    "sci06","sci07","sci08","sci09","sci10",
    "sci11","sci12","sci13","sci14","sci15",
    "sci16","sci17","sci18","sci19","sci20"
  ),
  on_site = c(
    1,0,1,1,1,
    0,1,1,0,0,
    1,0,0,0,1,
    1,1,0,1,1
  ),
  symptom_onset_days = c(
    5,7,3,4,4,
    6,3,4,5,6,
    5,7,6,5,4,
    3,5,7,4,3
  )
)
ui <- fluidPage(
  tags$head(
    tags$style(HTML("
      body { background-color: #000000; color: #39FF14; font-family: 'Courier New'; }

      .rank-list-item {
        background-color: #000000 !important;
        color: #39FF14 !important;
        border: 1px solid #39FF14 !important;
        padding: 8px;
        margin-bottom: 6px;
        font-family: 'Courier New';
      }

      #plot-area { 
        border: 1px solid #39FF14; 
        padding: 10px; 
        margin-top: 20px; 
      }
    "))
  ),
  
  titlePanel("LEVEL 3.4 — Zet de barplot‑code in de juiste volgorde"),
  
  h4("Sleep de code‑stukken hieronder in de juiste volgorde om een barplot met foutbalken te maken."),
  
  rank_list(
    text = "Versleep de code‑stukken:",
    labels = c(
      'geom_bar(stat = \"identity\") +',
      'geom_errorbar(aes(ymin = symptom_onset_days - on_site, ymax = symptom_onset_days + on_site), width = 0.2) +',
      'theme_minimal()',
      'labs(title = \"symptom onset days per scientist\") +',
      'ggplot(tidy_scientists, aes(x = Scientist, y = symptom_onset_days)) +'
    ),
    input_id = "ordered_code"
  ),
  
  actionButton("check", "Check code", class = "btn btn-success"),
  
  h4(textOutput("feedback")),
  plotOutput("plot")
)


server <- function(input, output, session) {
  
  required_first <- 'ggplot(tidy_scientists, aes(x = Scientist, y = symptom_onset_days)) +'
  
  observeEvent(input$check, {
    req(input$ordered_code)
    
    if (input$ordered_code[1] == required_first) {
      
      output$feedback <- renderText("✔ Correct! Het eerste stuk is ggplot — goed gedaan!")
      
      output$plot <- renderPlot({
        ggplot(tidy_scientists, aes(x = Scientist, y = symptom_onset_days)) +
          geom_bar(stat = "identity") +
          geom_errorbar(aes(
            ymin = symptom_onset_days - on_site,
            ymax = symptom_onset_days + on_site
          ), width = 0.2) +
          labs(title = "Symptom onset days per scientist") +
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
