library(shiny)
library(shinyjs)

untidy_scientists <- data.frame(
  Scientist = c(
    "sci01","sci01","sci02","sci02","sci03","sci03","sci04","sci04","sci05","sci05",
    "sci06","sci06","sci07","sci07","sci08","sci08","sci09","sci09","sci10","sci10",
    "sci11","sci11","sci12","sci12","sci13","sci13","sci14","sci14","sci15","sci15",
    "sci16","sci16","sci17","sci17","sci18","sci18","sci19","sci19","sci20","sci20"
  ),
  MeasurementType = rep(c("on_site", "symptom_onset_days"), times = 20),
  MeasurementValue = c(
    # on_site, onset_days, etc
    "yes", 5, "no", 7,"yes", 3,"yes", 4,"yes", 4,
    "no", 6, "yes", 3, "yes", 4, "no", 5, "no", 6,
    "yes", 5, "no", 7, "no", 6, "no", 5, "yes", 4,
    "yes", 3, "yes", 5, "no", 7, "yes", 4, "yes", 3
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
        font-family: 'Courier New', monospace;
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
      .code-box {
        background-color: #000000;
        border: 2px solid #00FF00;
        padding: 10px;
        margin-top: 10px;
      }
      .inline-input {
        display: inline-block;
        width: 160px;
        background-color: #000000;
        color: #00FF00;
        border: 2px solid #00FF00;
        font-family: 'Courier New', monospace;
        margin-left: 5px;
      }
    "))
  ),
  
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
      "📂 Start Level 3.1: Scientists dataset inladen",
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
  
  observeEvent(input$start_level, {
    
    removeUI(selector = "#start_wrapper", immediate = TRUE)
    
    output$game_ui <- renderUI({
      div(class = "game-container",
          
          div(class = "editor",
              h3("📂 Level 3.1: Scientists dataset inladen"),
              p("Gebruik read_excel() om het bestand scientists.xlsx te laden."),
              p("Typ wat er tussen de haakjes moet staan:"),
              
              div(class = "code-box",
                  HTML("scientists_dataset <- read_excel("),
                  tags$input(id = "excel_input", type = "text", class = "inline-input"),
                  HTML(")")
              ),
              
              actionButton("submit_excel", "▶ RUN CODE")
          ),
          
          div(class = "console",
              h3("Console"),
              verbatimTextOutput("excel_console"),
              br(),
              uiOutput("scientists_table")
          )
      )
    })
  })
  
  observeEvent(input$submit_excel, {
    req(input$excel_input)
    
    clean_input <- trimws(input$excel_input)
    
    if (clean_input %in% c("\"scientists.xlsx\"", "scientists.xlsx")) {
      
      output$excel_console <- renderText({
        paste0(
          "✔ Correct!\nHet bestand is geladen als 'scientists_dataset'.\n"
        )
      })
      
      output$scientists_table <- renderUI({
        tagList(
          h3("📊 Geladen dataset:"),
          tableOutput("scientists_table_data")
        )
      })
      
      output$scientists_table_data <- renderTable({
        untidy_scientists
      })
      
      session$sendCustomMessage("confetti", TRUE)
      return()
    }
    
    output$scientists_table <- renderUI({ NULL })
    
    output$excel_console <- renderText({
      paste0(
        "✖ Fout.\nJe typte: read_excel(", input$excel_input, ")\n\n",
        "Hint: Bestandsnamen zijn tekst. Gebruik aanhalingstekens én de .xlsx extensie."
      )
    })
  })
}

shinyApp(ui, server)
