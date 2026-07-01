library(shiny)
library(bslib)
library(shinyjs)
library(tidyverse)

untidy_df <- data.frame(
  Scientist = c(
    "sci01","sci01","sci02","sci02","sci03","sci03","sci04","sci04","sci05","sci05"
  ),
  MeasurementType = rep(c("on_site", "symptom_onset_days"), times = 5),
  MeasurementValue = c(
    # on_site, onset_days, etc
    "yes", 5, "no", 7,"yes", 3,"yes", 4,"yes", 4
  )
)

ui <- fluidPage(
  useShinyjs(),
  
  tags$head(
    tags$style(HTML("
      body {
        background-color: #1c1c1c;
        color: #00FF00;
        font-family: 'Courier New', monospace;
      }
      .game-container {
        display: flex;
        gap: 20px;
        margin-top: 20px;
      }
      .editor, .console {
        width: 50%;
        padding: 15px;
        border: 2px solid #00FF00;
        text-align: left;
      }
      .editor {
        background-color: #1c1c1c;
        min-height: 200px;
      }
      .console {
        background-color: #000000;
        min-height: 200px;
        white-space: pre-wrap;
      }
    "))
  ),
  
  # Start button
  div(
    id = "start_wrapper",
    style = "
      display: flex;
      justify-content: center;
      align-items: center;
      height: 60vh;
    ",
    actionButton(
      "start_level",
      "🔍 Start Level 3.2: Tidy herkenning",
      style = "
        font-size: 1.5em;
        padding: 20px 40px;
        background-color: #1c1c1c;
        color: #00FF00;
        border: 3px solid #00FF00;
        cursor: pointer;
        text-shadow: 0 0 5px #00FF00;
      "
    )
  ),
  
  uiOutput("game_ui")
)

server <- function(input, output, session) {
  
  output$untidy_table <- renderTable({
    untidy_df
  })
  
  observeEvent(input$start_level, {
    removeUI(selector = "#start_wrapper", immediate = TRUE)
    
    output$game_ui <- renderUI({
      div(class = "game-container",
          
          div(class = "editor",
              h3("🔍 Level 3.2: Tidy herkenning"),
              p("Hieronder is een deel van de zojuist ingeladen tabel te zien"),
              p("Is deze tabel tidy?"),
              
              tableOutput("untidy_table"),
              
              radioButtons(
                inputId = "tidy_answer",
                label = "Kies het juiste antwoord:",
                choices = list(
                  "a) ja, dit is tidy data" = "a",
                  "b) nee, de age en survival rate staan niet in aparte kolommen" = "b",
                  "c) nee, de kolommen zijn niet alfabetisch geordend" = "c",
                  "d) nee, want voor elke scientist zijn er meerdere metingen" = "d"
                )
              ),
              
              actionButton("submit_excel", "▶ RUN CODE")
          ),
          
          div(class = "console",
              h3("Console"),
              verbatimTextOutput("excel_console")
          )
      )
    })
  })
  
  observeEvent(input$submit_excel, {
    req(input$tidy_answer)
    
    correct <- "b"
    
    if (input$tidy_answer == correct) {
      output$excel_console <- renderText({
        "✔ Correct!\nDe variabelen staan niet in aparte kolommen."
      })
    } else {
      output$excel_console <- renderText({
        paste0(
          "✖ Fout.\nJe koos antwoord: ", input$tidy_answer, "\n\n",
          "Hint: Alle variabelen horen aparte kolommen te zijn."
        )
      })
    }
  })
}


shinyApp(ui, server)
