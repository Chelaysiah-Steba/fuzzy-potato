untidy_df <- data.frame(
  Scientist = c(
    "sci01", "sci01", "sci02", "sci02", "sci03",
    "sci03", "sci04", "sci04", "sci05", "sci05"
  ),
  MeasurementType = rep(
    c("on_site", "symptom_onset_days"),
    times = 5
  ),
  MeasurementValue = c(
    "yes", 5, "no", 7, "yes",
    3, "yes", 4, "yes", 4
  )
)

level3_2_ui <- function() {
  
  fluidPage(
    
    useShinyjs(),
    
    tags$head(
      tags$style(HTML("
        
        body {
          background-color: #1c1c1c;
          color: #24bb24;
          font-family: 'Courier New', monospace;
        }
        
        .game-container {
          display: flex;
          gap: 20px;
          margin-top: 20px;
        }
        
        .editor,
        .console {
          width: 50%;
          padding: 15px;
          border: 2px solid #24bb24;
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
        
        .console-message {
          background-color: #000000 !important;
          color: #24bb24 !important;
          border: 2px solid #24bb24 !important;
          outline: none !important;
          box-shadow: none !important;
          padding: 10px;
          margin-top: 10px;
          min-height: 80px;
        }
        
        .console-message.error {
          color: #bb2424 !important;
          border-color: #bb2424 !important;
        }
        
        .console-message.success {
          color: #24bb24 !important;
          border-color: #24bb24 !important;
        }
        
        .console-message pre {
          background-color: #000000 !important;
          color: inherit !important;
          border: none !important;
          outline: none !important;
          box-shadow: none !important;
          padding: 0 !important;
          margin: 0 !important;
          font-family: 'Courier New', monospace !important;
          white-space: pre-wrap !important;
        }
        
        /* Tabel: zwarte achtergrond, groene tekst en groene lijnen */
        #untidy_table_l3_2 table {
          width: 100%;
          background-color: #000000 !important;
          color: #24bb24 !important;
          border-collapse: collapse !important;
          border: 2px solid #24bb24 !important;
          font-family: 'Courier New', monospace !important;
        }
        
        #untidy_table_l3_2 table thead,
        #untidy_table_l3_2 table tbody,
        #untidy_table_l3_2 table tr {
          background-color: #000000 !important;
        }
        
        #untidy_table_l3_2 table th,
        #untidy_table_l3_2 table td {
          background-color: #000000 !important;
          color: #24bb24 !important;
          border: 1px solid #24bb24 !important;
          padding: 6px 10px !important;
          font-family: 'Courier New', monospace !important;
        }
        
        #untidy_table_l3_2 table th {
          font-weight: bold !important;
          border-bottom: 2px solid #24bb24 !important;
        }
        
        input[type='radio'] {
          accent-color: #24bb24;
        }
        
        button {
          background-color: #1c1c1c;
          color: #24bb24;
          border: 2px solid #24bb24;
          padding: 8px 16px;
          cursor: pointer;
          font-family: 'Courier New', monospace;
        }
        
        button:hover {
          background-color: #24bb24;
          color: #1c1c1c;
        }
        
        .next-btn {
          margin-top: 20px;
          background: #1c1c1c;
          color: #24bb24;
          border: 2px solid #24bb24;
          padding: 10px 20px;
          font-family: 'Courier New', monospace;
          cursor: pointer;
        }
        
        .next-btn:hover {
          background-color: #24bb24;
          color: #1c1c1c;
        }
      "))
    ),
    
    div(
      class = "game-container",
      
      div(
        class = "editor",
        
        h3("🔍 Level 3.2: Tidy herkenning"),
        
        p("Hieronder is een deel van de zojuist ingeladen tabel te zien."),
        
        p("Is deze tabel tidy?"),
        
        tableOutput("untidy_table_l3_2"),
        
        radioButtons(
          inputId = "tidy_answer_l3_2",
          label = "Kies het juiste antwoord:",
          choices = list(
            "a) ja, dit is tidy data" = "a",
            "b) nee, de variabelen staan niet in aparte kolommen." = "b",
            "c) nee, de kolommen zijn niet alfabetisch geordend" = "c",
            "d) nee, want voor elke scientist zijn er meerdere metingen" = "d"
          )
        ),
        
        actionButton(
          "submit_excel_l3_2",
          "▶ RUN CODE"
        )
      ),
      
      div(
        class = "console",
        
        h3("Console"),
        
        uiOutput("excel_console_ui_l3_2"),
        
        uiOutput("game_next_l3_2")
      )
    )
  )
}

level3_2_server <- function(input, output, session, current_page) {
  
  output$untidy_table_l3_2 <- renderTable({
    untidy_df
  },
  rownames = FALSE,
  striped = FALSE,
  bordered = TRUE,
  hover = FALSE
  )
  
  output$excel_console_ui_l3_2 <- renderUI({
    NULL
  })
  
  output$game_next_l3_2 <- renderUI({
    NULL
  })
  
  observeEvent(input$submit_excel_l3_2, {
    
    req(input$tidy_answer_l3_2)
    
    correct <- "b"
    
    if (identical(input$tidy_answer_l3_2, correct)) {
      
      session$sendCustomMessage("greenFlash", TRUE)
      
      output$excel_console_ui_l3_2 <- renderUI({
        
        div(
          class = "console-message success",
          
          verbatimTextOutput(
            "excel_console_l3_2",
            placeholder = FALSE
          )
        )
      })
      
      output$excel_console_l3_2 <- renderText({
        
        paste(
          "✔ CORRECT",
          "",
          "De variabelen staan niet in aparte kolommen.",
          "",
          "STATUS: ONLINE",
          sep = "\n"
        )
      })
      
      output$game_next_l3_2 <- renderUI({
        
        actionButton(
          "next_level3_3",
          "Volgende",
          class = "next-btn"
        )
      })
      
    } else {
      
      session$sendCustomMessage("redFlash", TRUE)
      
      output$excel_console_ui_l3_2 <- renderUI({
        
        div(
          class = "console-message error",
          
          verbatimTextOutput(
            "excel_console_l3_2",
            placeholder = FALSE
          )
        )
      })
      
      output$excel_console_l3_2 <- renderText({
        
        paste(
          "✖ FOUT",
          "",
          paste0("Je koos antwoord: ", input$tidy_answer_l3_2),
          "",
          "HINT",
          "Alle variabelen horen in aparte kolommen te staan.",
          sep = "\n"
        )
      })
      
      output$game_next_l3_2 <- renderUI({
        NULL
      })
    }
  })
  
  observeEvent(input$next_level3_3, {
    current_page("level3_3")
  })
}