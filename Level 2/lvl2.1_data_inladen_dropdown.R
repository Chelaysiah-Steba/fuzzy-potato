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
    "))
  ),
  
  uiOutput("game_ui")
)

server <- function(input, output, session) {
  
  output$game_ui <- renderUI({
    div(class = "game-container",
        
        div(class = "editor",
            h3("📂 Level 2.1: Load the Virus Dataset"),
            p("Gebruik read_excel() om het bestand virus.xlsx te laden."),
            p("Kies wat er tussen de haakjes moet staan:"),
            
            selectInput(
              "excel_choice",
              "virus_dataset <- read_excel( ... )",
              choices = c(
                "\"virus.xlsx\"" = "\"virus.xlsx\"",
                "virus" = "virus",
                "virus.xlsx" = "virus.xlsx",
                "\"data/virus.xlsx\"" = "\"data/virus.xlsx\""
              )
            ),
            
            actionButton("submit_excel", "▶ RUN CODE")
        ),
        
        div(class = "console",
            h3("Console"),
            verbatimTextOutput("excel_console"),
            br(),
            uiOutput("virus_table")
        )
    )
  })
  
  observeEvent(input$submit_excel, {
    req(input$excel_choice)
    
    if (input$excel_choice == "\"virus.xlsx\"") {
      
      output$excel_console <- renderText({
        "✔ Correct!\nHet bestand is succesvol geladen in R als 'virus_dataset'."
      })
      
      output$virus_table <- renderUI({
        tagList(
          h3("📊 Geladen dataset:"),
          tableOutput("virus_table_data")
        )
      })
      
      output$virus_table_data <- renderTable({
        virus_dataset
      })
      
      session$sendCustomMessage("confetti", TRUE)
      return()
    }
    
    output$virus_table <- renderUI({ NULL })
    
    output$excel_console <- renderText({
      paste0(
        "✖ Fout.\nJe koos: read_excel(", input$excel_choice, ")\n\n",
        "Hint: Bestandsnamen zijn tekst. Gebruik aanhalingstekens én de .xlsx extensie."
      )
    })
  })
}

shinyApp(ui, server)
