library(shiny)
library(ggplot2)
library(sortable)

virus_dataset <- data.frame(
  virus = c(
    "VX-01", "CrimsonFlu", "OmegaSpore", "Nexavirus", "BlueAsh",
    "PyroVex", "SilentMoth", "Gravemind", "Solaris-7", "HollowFang"
  ),
  mean_onset_days = c(
    3.2, 1.8, 5.6, 2.4, 4.1,
    6.3, 7.8, 3.9, 2.1, 5.0
  ),
  sd_onset_days = c(
    0.8, 0.5, 1.2, 0.6, 1.0,
    1.4, 1.9, 0.7, 0.4, 1.1
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
      'geom_errorbar(aes(ymin = mean_onset_days - sd_onset_days, ymax = mean_onset_days + sd_onset_days), width = 0.2) +',
      'theme_minimal()',
      'labs(title = "Gemiddelde tijd tot symptomen per virus") +',
      'ggplot(virus_dataset, aes(x = virus, y = mean_onset_days)) +'
    ),
    input_id = "ordered_code"
  ),
  
  actionButton("check", "Check code", class = "btn btn-success"),
  
  h4(textOutput("feedback")),
  plotOutput("plot")
)

server <- function(input, output, session) {
  
  correct_order <- c(
    'ggplot(virus_dataset, aes(x = virus, y = mean_onset_days)) +',
    'geom_bar(stat = "identity") +',
    'geom_errorbar(aes(ymin = mean_onset_days - sd_onset_days, ymax = mean_onset_days + sd_onset_days), width = 0.2) +',
    'labs(title = "Gemiddelde tijd tot symptomen per virus") +',
    'theme_minimal()'
  )
  
  observeEvent(input$check, {
    if (is.null(input$ordered_code)) return()
    
    if (identical(input$ordered_code, correct_order)) {
      output$feedback <- renderText("✔ Correct! Goed gedaan!")
      output$plot <- renderPlot({
        ggplot(virus_dataset, aes(x = virus, y = mean_onset_days)) +
          geom_bar(stat = "identity") +
          geom_errorbar(aes(
            ymin = mean_onset_days - sd_onset_days,
            ymax = mean_onset_days + sd_onset_days
          ), width = 0.2) +
          labs(title = "Gemiddelde tijd tot symptomen per virus") +
          theme_minimal()
      })
      
      session$sendCustomMessage("confetti", list())
      
    } else {
      output$feedback <- renderText("✘ Niet helemaal goed. Probeer opnieuw.")
      output$plot <- renderPlot(NULL)
    }
  })
  
  session$onFlushed(function() {
    session$sendCustomMessage("confetti", list())
  })
  
}

shinyApp(ui, server)

