dna_ct_dataset_outlier <- data.frame(
  log10_concentration = c(
    rep(1.2, 3),
    rep(1.5, 3),
    rep(1.8, 3),
    rep(2.0, 3),
    rep(2.3, 3),
    rep(2.6, 3),
    rep(2.9, 3),
    rep(3.1, 3),
    rep(3.4, 3),
    rep(3.7, 3)
  ),
  herhaling = rep(1:3, 10),
  ct_value = c(
    33.1, 33.2, 33.0,
    31.8, 31.8, 15.4,
    30.2, 30.0, 30.4,
    29.0, 30.3, 28.0,
    27.5, 27.3, 27.2,
    26.1, 26.5, 26.0,
    24.8, 24.5, 24.6,
    23.9, 23.6, 24.0,
    22.4, 22.5, 22.4,
    21.0, 20.8, 21.9
  )
)

level4_1_ui <- function() {
  
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
          max-height: 220px;
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
          white-space: nowrap !important;
        }
        
        .code-box {
          background-color: #000000;
          border: 2px solid #24bb24;
          padding: 10px;
          margin-top: 10px;
        }
        
        .inline-input {
          display: inline-block;
          width: 260px;
          background-color: #000000;
          color: #24bb24;
          border: 2px solid #24bb24;
          font-family: 'Courier New', monospace;
          margin-left: 5px;
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
        
        #level4_1_submit_load {
          margin-top: 20px;
          background-color: #1c1c1c;
          color: #24bb24;
          border: 2px solid #24bb24;
          padding: 10px 20px;
          font-family: 'Courier New', monospace;
          cursor: pointer;
        }
        
        #level4_1_submit_load:hover {
          background-color: #24bb24;
          color: #000000;
        }
      "))
    ),
    
    div(
      class = "game-container",
      
      div(
        class = "editor",
        
        h3("Level 4.1: DNA concentratie dataset inladen"),
        
        p(
          "Gebruik read_excel() om het bestand dna_concentrations.xlsx te laden."
        ),
        
        p(
          "Typ de volledige functie die nodig is:"
        ),
        
        div(
          class = "code-box",
          
          HTML("DNA_concentrations_dataset <- "),
          
          tags$input(
            id = "level4_1_excel_input",
            type = "text",
            class = "inline-input"
          )
        ),
        
        actionButton(
          "level4_1_submit_load",
          "▶ RUN CODE"
        )
      ),
      
      div(
        class = "console",
        
        h3("Console"),
        
        uiOutput("level4_1_console_ui"),
        
        br(),
        
        uiOutput("level4_1_dataset_table_ui"),
        
        uiOutput("level4_1_next_ui")
      )
    )
  )
}

level4_1_server <- function(input, output, session, current_page) {
  
  output$level4_1_console_ui <- renderUI({
    NULL
  })
  
  output$level4_1_dataset_table_ui <- renderUI({
    NULL
  })
  
  output$level4_1_next_ui <- renderUI({
    NULL
  })
  
  observeEvent(input$level4_1_submit_load, {
    
    req(input$level4_1_excel_input)
    
    clean_input <- trimws(input$level4_1_excel_input)
    
    if (clean_input == "read_excel(\"dna_concentrations.xlsx\")") {
      
      session$sendCustomMessage("greenFlash", TRUE)
      
      output$level4_1_console_ui <- renderUI({
        
        div(
          class = "console-message success",
          
          verbatimTextOutput(
            "level4_1_console_text",
            placeholder = FALSE
          )
        )
      })
      
      output$level4_1_console_text <- renderText({
        "✔ Correct!\nHet bestand is geladen als 'DNA_concentrations_dataset'."
      })
      
      output$level4_1_dataset_table_ui <- renderUI({
        
        tagList(
          
          h4(
            "Geladen dataset:",
            class = "table-title"
          ),
          
          div(
            class = "table-scroll",
            
            tableOutput(
              "level4_1_dataset_table"
            )
          )
        )
      })
      
      output$level4_1_dataset_table <- renderTable({
        dna_ct_dataset_outlier
      }, striped = FALSE, bordered = TRUE, hover = FALSE)
      
      output$level4_1_next_ui <- renderUI({
        
        actionButton(
          "level4_1_next_level4_2",
          "Volgende",
          class = "next-btn"
        )
      })
      
    } else {
      
      session$sendCustomMessage("redFlash", TRUE)
      
      output$level4_1_dataset_table_ui <- renderUI({
        NULL
      })
      
      output$level4_1_next_ui <- renderUI({
        NULL
      })
      
      output$level4_1_console_ui <- renderUI({
        
        div(
          class = "console-message error",
          
          verbatimTextOutput(
            "level4_1_console_text",
            placeholder = FALSE
          )
        )
      })
      
      output$level4_1_console_text <- renderText({
        
        paste0(
          "✖ Fout.\n",
          "Je typte: ",
          input$level4_1_excel_input,
          "\n\n",
          "Hint: Gebruik de hele functie, en vergeet de aanhalingstekens én de extensie niet."
        )
      })
    }
  })
  
  observeEvent(input$level4_1_next_level4_2, {
    current_page("level4_2")
  })
}