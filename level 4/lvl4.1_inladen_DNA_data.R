library(shiny)
library(shinyjs)

dna_ct_dataset_outlier <- data.frame(
  log10_concentration = c(
    1.2, 1.5, 1.8, 2.0, 2.3,
    2.6, 2.8, 2.9, 3.1, 3.4, 3.7
  ),
  ct_value = c(
    33.1, 31.8, 30.2, 29.0, 27.5,
    26.1, 10.2, 24.8, 23.9, 22.4, 21.0
  )
)

ui <- fluidPage(
  useShinyjs(),
  
  tags$head(
    tags$style(HTML("
      body { background-color: #1c1c1c; color: #00FF00; font-family: 'Courier New', monospace; }

      .game-container { 
        display: flex; 
        gap: 20px; 
        margin-top: 20px; 
      }

      .editor, .console {
        width: 50%; 
        padding: 15px; 
        border: 2px solid #00FF00;
        font-family: 'Courier New', monospace; 
        text-align: left;
      }

      .editor { background-color: #1c1c1c; }
      .console { background-color: #000000; white-space: pre-wrap; }

      pre, pre * { 
        color: #00FF00 !important; 
        font-family: 'Courier New', monospace !important; 
      }

      /* REMOVE WHITE BOX COMPLETELY */
      input {
        background: none !important;
        color: #00FF00 !important;
        border: none !important;
        border-radius: 0 !important;
        padding: 0 !important;
        margin: 0 !important;
        outline: none !important;
        box-shadow: none !important;
        font-family: 'Courier New', monospace !important;
        font-size: 16px;
        width: 420px;
      }

      button {
        background-color: #000000 !important; 
        color: #00FF00 !important;
        border: 2px solid #00FF00 !important; 
        font-family: 'Courier New', monospace !important;
      }
    "))
  ),
  
  uiOutput("game_ui")
)

server <- function(input, output, session) {
  
  output$game_ui <- renderUI({
    div(class = "game-container",
        
        div(class = "editor",
            h3("📂 Level 4.1 — Laad de DNA concentratie dataset"),
            
            tags$pre(
              "dna_ct_dataset <- ",
              tags$input(
                id = "file_input", 
                type = "text",
                placeholder = 'read_excel("DNA_concentrations.xlsx")'
              )
            ),
            
            actionButton("run", "▶ RUN CODE")
        ),
        
        div(class = "console",
            h3("Console"),
            verbatimTextOutput("console_out"),
            uiOutput("result_table")
        )
    )
  })
  
  observeEvent(input$run, {
    
    correct <- input$file_input == 'read_excel("DNA_concentrations.xlsx")'
    
    if (correct) {
      output$console_out <- renderText("✔ Correct! Dataset loaded.")
      
      output$result_table <- renderUI({
        tableOutput("tbl")
      })
      
      output$tbl <- renderTable({
        dna_ct_dataset_outlier
      })
      
      session$sendCustomMessage("confetti", TRUE)
      
    } else {
      output$console_out <- renderText(
        "✘ Fout. Typ de volledige functie: read_excel(\"DNA_concentrations.xlsx\")"
      )
      output$result_table <- renderUI({ NULL })
    }
  })
}

shinyApp(ui, server)
