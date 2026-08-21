antiviral_effectiveness <- data.frame(
  virus = c(
    "Livo-01", "CrimsonFlu", "Sperion Spore", "Remnox-05", "Siah-V Complex",
    "Subel-X", "SilentMoth", "Avron Pathogen", "Solaris-7", "HollowFang"
  ),
  antiviral_class = c(
    "Protease Inhibitor", "RNA Polymerase Blocker", "Fusion Inhibitor",
    "Capsid Destabilizer", "RNA Polymerase Blocker",
    "Protease Inhibitor", "Fusion Inhibitor", "Capsid Destabilizer",
    "RNA Polymerase Blocker", "Protease Inhibitor"
  ),
  concentration_required_mg = c(
    120, 90, 140, 80, 110,
    125, 160, 150, 95, 130
  )
)


antiviral_library <- data.frame(
  antiviral_name = c(
    "ViraBloc", "HelixStop", "CapsidCrush", "FuseAway", "PolymeraseX",
    "ProteaseMax", "CapsidBreaker"
  ),
  antiviral_class = c(
    "Protease Inhibitor", "RNA Polymerase Blocker", "Capsid Destabilizer",
    "Fusion Inhibitor", "RNA Polymerase Blocker",
    "Protease Inhibitor", "Capsid Destabilizer"
  ),
  stock_concentration_mg = c(
    120, 100, 180, 120, 160,
    155, 85
  )
)


level5_1_ui <- function() {
  
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
          width: 260px;
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
          outline: none !important;
          box-shadow: none !important;
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
          margin: 0 !important;
        }
        
        .table-scroll table thead {
          background-color: #000000 !important;
        }
        
        .table-scroll table tbody {
          background-color: #000000 !important;
        }
        
        .table-scroll table th,
        .table-scroll table td {
          background-color: #000000 !important;
          color: #24bb24 !important;
          border: 1px solid #24bb24 !important;
          padding: 6px 10px !important;
          white-space: nowrap !important;
        }
        
        .table-scroll table th {
          font-weight: bold !important;
        }
        
        .table-scroll .table {
          background-color: #000000 !important;
        }
        
        .next-btn,
        .retry-btn {
          margin-top: 20px;
          background: #1c1c1c;
          color: #24bb24;
          border: 2px solid #24bb24;
          padding: 10px 20px;
          font-family: 'Courier New', monospace;
          cursor: pointer;
        }
        
        .next-btn:hover,
        .retry-btn:hover {
          background-color: #24bb24;
          color: #000000;
        }
        
        #submit_excel {
          margin-top: 20px;
          background-color: #1c1c1c;
          color: #24bb24;
          border: 2px solid #24bb24;
          padding: 10px 20px;
          font-family: 'Courier New', monospace;
          cursor: pointer;
        }
        
        #submit_excel:hover {
          background-color: #24bb24;
          color: #000000;
        }
        
      "))
    ),
    
    
    div(
      class = "game-container",
      
      div(
        class = "editor",
        
        h3("Level 5.1: Antiviral datasets inladen"),
        
        p(
          "Laad de volgende twee bestanden in:"
        ),
        
        tags$ul(
          tags$li("antiviral_effectiveness.xlsx"),
          tags$li("antiviral_library.xlsx")
        ),
        
        p(
          "Typ beide functies volledig:"
        ),
        
        div(
          class = "code-box",
          
          HTML("antiviral_effectiveness_dataset <- "),
          
          tags$input(
            id = "excel_input_1",
            type = "text",
            class = "inline-input",
            placeholder = "read_excel(...)"
          )
        ),
        
        div(
          class = "code-box",
          
          HTML("antiviral_library_dataset <- "),
          
          tags$input(
            id = "excel_input_2",
            type = "text",
            class = "inline-input",
            placeholder = "read_excel(...)"
          )
        ),
        
        actionButton(
          "submit_excel",
          "▶ RUN CODE"
        )
      ),
      
      
      div(
        class = "console",
        
        h3("Console"),
        
        uiOutput("excel_console_ui"),
        
        br(),
        
        uiOutput("effectiveness_table"),
        
        br(),
        
        uiOutput("library_table"),
        
        uiOutput("next_ui51")
      )
    )
  )
}


level5_1_server <- function(input, output, session, current_page) {
  
  output$excel_console_ui <- renderUI({
    NULL
  })
  
  output$effectiveness_table <- renderUI({
    NULL
  })
  
  output$library_table <- renderUI({
    NULL
  })
  
  
  observeEvent(input$submit_excel, {
    
    req(
      input$excel_input_1,
      input$excel_input_2
    )
    
    
    clean1 <- trimws(input$excel_input_1)
    clean2 <- trimws(input$excel_input_2)
    
    
    correct1 <- "read_excel(\"antiviral_effectiveness.xlsx\")"
    correct2 <- "read_excel(\"antiviral_library.xlsx\")"
    
    
    if (clean1 == correct1 && clean2 == correct2) {
      
      session$sendCustomMessage("greenFlash", TRUE)
      
      
      output$excel_console_ui <- renderUI({
        
        div(
          class = "console-message success",
          
          verbatimTextOutput(
            "excel_console",
            placeholder = FALSE
          )
        )
      })
      
      
      output$excel_console <- renderText({
        
        paste0(
          "✔ Correct!\n",
          "Beide bestanden zijn succesvol geladen."
        )
      })
      
      
      output$effectiveness_table <- renderUI({
        
        tagList(
          
          h4(
            "antiviral_effectiveness dataset:",
            class = "table-title"
          ),
          
          div(
            class = "table-scroll",
            
            tableOutput("effectiveness_table_data")
          )
        )
      })
      
      
      output$library_table <- renderUI({
        
        tagList(
          
          h4(
            "antiviral_library dataset:",
            class = "table-title"
          ),
          
          div(
            class = "table-scroll",
            
            tableOutput("library_table_data")
          )
        )
      })
      
      
      output$effectiveness_table_data <- renderTable({
        
        antiviral_effectiveness
        
      }, striped = FALSE, bordered = TRUE, hover = FALSE)
      
      
      output$library_table_data <- renderTable({
        
        antiviral_library
        
      }, striped = FALSE, bordered = TRUE, hover = FALSE)
      
      
      output$next_ui51 <- renderUI({
        
        actionButton(
          "next_level5_2",
          "Volgende",
          class = "next-btn"
        )
      })
      
      
    } else {
      
      session$sendCustomMessage("redFlash", TRUE)
      
      
      output$effectiveness_table <- renderUI({
        NULL
      })
      
      
      output$library_table <- renderUI({
        NULL
      })
      
      
      output$next_ui51 <- renderUI({
        
        actionButton(
          "retry_level51",
          "Probeer opnieuw",
          class = "retry-btn"
        )
      })
      
      
      output$excel_console_ui <- renderUI({
        
        div(
          class = "console-message error",
          
          verbatimTextOutput(
            "excel_console",
            placeholder = FALSE
          )
        )
      })
      
      
      output$excel_console <- renderText({
        
        paste0(
          "✖ Fout.\n",
          "Je typte:\n",
          "effectiveness: ", input$excel_input_1, "\n",
          "library: ", input$excel_input_2, "\n\n",
          "Hint: Gebruik de hele functie, en vergeet de aanhalingstekens én de .xlsx extensie niet."
        )
      })
    }
  })
  
  
  observeEvent(input$retry_level51, {
    
    updateTextInput(
      session,
      "excel_input_1",
      value = ""
    )
    
    updateTextInput(
      session,
      "excel_input_2",
      value = ""
    )
    
    output$excel_console_ui <- renderUI({
      NULL
    })
    
    output$effectiveness_table <- renderUI({
      NULL
    })
    
    output$library_table <- renderUI({
      NULL
    })
    
    output$next_ui51 <- renderUI({
      NULL
    })
  })
  
  
  observeEvent(input$next_level5_2, {
    current_page("level5_2")
  })
}