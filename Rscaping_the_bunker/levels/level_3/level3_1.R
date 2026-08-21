untidy_scientists <- data.frame(
  Scientist = c(
    "sci01","sci01","sci02","sci02","sci03","sci03","sci04","sci04","sci05","sci05",
    "sci06","sci06","sci07","sci07","sci08","sci08","sci09","sci09","sci10","sci10",
    "sci11","sci11","sci12","sci12","sci13","sci13","sci14","sci14","sci15","sci15",
    "sci16","sci16","sci17","sci17","sci18","sci18","sci19","sci19","sci20","sci20"
  ),
  MeasurementType = rep(c("on_site", "symptom_onset_days"), times = 20),
  MeasurementValue = c(
    "yes", 5, "no", 7, "yes", 3, "yes", 4, "yes", 4,
    "no", 6, "yes", 3, "yes", 4, "no", 5, "no", 6,
    "yes", 5, "no", 7, "no", 6, "no", 5, "yes", 4,
    "yes", 3, "yes", 5, "no", 7, "yes", 4, "yes", 3
  )
)


level3_1_ui <- function() {
  
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
          font-family: 'Courier New', monospace;
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
          color: #24bb24;
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
        
        .code-box {
          background-color: #000000;
          border: 2px solid #24bb24;
          padding: 10px;
          margin-top: 10px;
        }
        
        .inline-input {
          display: inline-block;
          width: 160px;
          background-color: #000000;
          color: #24bb24;
          border: 2px solid #24bb24;
          font-family: 'Courier New', monospace;
          margin-left: 5px;
        }
        
        .table-title {
          color: #24bb24;
          font-family: 'Courier New', monospace;
          margin-top: 10px;
          margin-bottom: 5px;
        }
        
        .table-scroll {
          background-color: #000000 !important;
          border: 2px solid #24bb24 !important;
          padding: 10px;
          margin-top: 10px;
          max-height: 300px;
          overflow-y: auto;
          overflow-x: auto;
        }
        
        .table-scroll table {
          background-color: #000000 !important;
          color: #24bb24 !important;
          border-collapse: collapse !important;
          font-family: 'Courier New', monospace !important;
          width: max-content !important;
          min-width: 100% !important;
        }
        
        .table-scroll table th,
        .table-scroll table td {
          background-color: #000000 !important;
          color: #24bb24 !important;
          border: 1px solid #24bb24 !important;
          padding: 6px 10px !important;
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
          color: #000000;
        }
        
        #submit_excel_l3_1 {
          margin-top: 20px;
          background-color: #1c1c1c;
          color: #24bb24;
          border: 2px solid #24bb24;
          padding: 10px 20px;
          font-family: 'Courier New', monospace;
          cursor: pointer;
        }
        
        #submit_excel_l3_1:hover {
          background-color: #24bb24;
          color: #000000;
        }
        
      "))
    ),
    
    
    div(
      class = "game-container",
      
      
      div(
        class = "editor",
        
        h3("Level 3.1: Scientists dataset inladen"),
        
        p(
          "Gebruik read_excel() om het bestand scientists.xlsx te laden."
        ),
        
        p(
          "Typ wat er tussen de haakjes moet staan:"
        ),
        
        div(
          class = "code-box",
          
          HTML("scientists_dataset &lt;- read_excel("),
          
          tags$input(
            id = "excel_input",
            type = "text",
            class = "inline-input"
          ),
          
          HTML(")")
        ),
        
        actionButton(
          "submit_excel_l3_1",
          "▶ RUN CODE"
        )
      ),
      
      
      div(
        class = "console",
        
        h3("Console"),
        
        uiOutput("excel_console_ui_l3_1"),
        
        br(),
        
        uiOutput("scientists_table_l3_1")
      )
    )
  )
}


level3_1_server <- function(input, output, session, current_page) {
  
  output$excel_console_ui_l3_1 <- renderUI({
    NULL
  })
  
  
  output$scientists_table_l3_1 <- renderUI({
    NULL
  })
  
  
  output$scientists_table_data_l3_1 <- renderTable({
    
    untidy_scientists
    
  }, rownames = FALSE)
  
  
  observeEvent(input$submit_excel_l3_1, {
    
    req(input$excel_input)
    
    
    clean_input <- trimws(input$excel_input)
    
    
    if (clean_input %in% c("\"scientists.xlsx\"", "scientists.xlsx")) {
      
      session$sendCustomMessage("greenFlash", TRUE)
      
      
      output$excel_console_ui_l3_1 <- renderUI({
        
        div(
          class = "console-message success",
          
          verbatimTextOutput(
            "excel_console_l3_1",
            placeholder = FALSE
          )
        )
      })
      
      
      output$excel_console_l3_1 <- renderText({
        
        paste(
          "✔ Correct!",
          "",
          "Het bestand is geladen als 'scientists_dataset'.",
          "",
          "STATUS: ONLINE",
          sep = "\n"
        )
      })
      
      
      output$scientists_table_l3_1 <- renderUI({
        
        tagList(
          
          h4(
            "Geladen dataset:",
            class = "table-title"
          ),
          
          div(
            class = "table-scroll",
            tableOutput("scientists_table_data_l3_1")
          ),
          
          br(),
          
          actionButton(
            "next_level3_2",
            "Volgende",
            class = "next-btn"
          )
        )
      })
      
      
    } else {
      
      session$sendCustomMessage("redFlash", TRUE)
      
      
      output$scientists_table_l3_1 <- renderUI({
        NULL
      })
      
      
      output$excel_console_ui_l3_1 <- renderUI({
        
        div(
          class = "console-message error",
          
          verbatimTextOutput(
            "excel_console_l3_1",
            placeholder = FALSE
          )
        )
      })
      
      
      output$excel_console_l3_1 <- renderText({
        
        msg <- if (grepl("\\.xlsx", clean_input)) {
          
          "Gebruik aanhalingstekens rond de bestandsnaam."
          
        } else {
          
          "Bestandsnamen zijn tekst. Gebruik aanhalingstekens én de .xlsx-extensie."
          
        }
        
        
        paste(
          "✖ Fout",
          "",
          paste0(
            "Je typte: read_excel(",
            input$excel_input,
            ")"
          ),
          "",
          "Hint:",
          msg,
          sep = "\n"
        )
      })
    }
  })
  
  
  observeEvent(input$next_level3_2, {
    
    current_page("level3_2")
    
  })
}