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
          width: 300px;
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
        
        .table-scroll table thead,
        .table-scroll table tbody,
        .table-scroll .table {
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
        
        #level5_1_submit_csv {
          margin-top: 20px;
          background-color: #1c1c1c;
          color: #24bb24;
          border: 2px solid #24bb24;
          padding: 10px 20px;
          font-family: 'Courier New', monospace;
          cursor: pointer;
        }
        
        #level5_1_submit_csv:hover {
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
        
        p("Laad de volgende twee CSV-bestanden in:"),
        
        tags$ul(
          tags$li("antiviral_effectiveness.csv"),
          tags$li("antiviral_library.csv")
        ),
        
        p("Typ beide functies volledig:"),
        
        div(
          class = "code-box",
          
          HTML("antiviral_effectiveness_dataset <- "),
          
          tags$input(
            id = "level5_1_csv_input_effectiveness",
            type = "text",
            class = "inline-input",
            placeholder = F
          )
        ),
        
        div(
          class = "code-box",
          
          HTML("antiviral_library_dataset <- "),
          
          tags$input(
            id = "level5_1_csv_input_library",
            type = "text",
            class = "inline-input",
            placeholder = F
          )
        ),
        
        actionButton(
          "level5_1_submit_csv",
          "▶ RUN CODE"
        )
      ),
      
      div(
        class = "console",
        
        h3("Console"),
        
        uiOutput("level5_1_console_ui"),
        
        br(),
        
        uiOutput("level5_1_effectiveness_table_ui"),
        
        br(),
        
        uiOutput("level5_1_library_table_ui"),
        
        uiOutput("level5_1_next_ui")
      )
    )
  )
}

level5_1_server <- function(input, output, session, current_page) {
  
  output$level5_1_console_ui <- renderUI({
    NULL
  })
  
  output$level5_1_effectiveness_table_ui <- renderUI({
    NULL
  })
  
  output$level5_1_library_table_ui <- renderUI({
    NULL
  })
  
  output$level5_1_next_ui <- renderUI({
    NULL
  })
  
  observeEvent(input$level5_1_submit_csv, {
    
    input_1 <- trimws(input$level5_1_csv_input_effectiveness)
    input_2 <- trimws(input$level5_1_csv_input_library)
    
    correct_1 <- "read_csv(\"antiviral_effectiveness.csv\")"
    correct_2 <- "read_csv(\"antiviral_library.csv\")"
    
    first_correct <- identical(input_1, correct_1)
    second_correct <- identical(input_2, correct_2)
    
    if (first_correct && second_correct) {
      
      session$sendCustomMessage("greenFlash", TRUE)
      
      output$level5_1_console_ui <- renderUI({
        
        div(
          class = "console-message success",
          
          verbatimTextOutput(
            "level5_1_console_text",
            placeholder = FALSE
          )
        )
      })
      
      output$level5_1_console_text <- renderText({
        paste(
          "✔ Correct!",
          "",
          "Beide CSV-bestanden zijn succesvol geladen.",
          sep = "\n"
        )
      })
      
      output$level5_1_effectiveness_table_ui <- renderUI({
        
        tagList(
          
          h4(
            "antiviral_effectiveness dataset:",
            class = "table-title"
          ),
          
          div(
            class = "table-scroll",
            tableOutput("level5_1_effectiveness_table")
          )
        )
      })
      
      output$level5_1_library_table_ui <- renderUI({
        
        tagList(
          
          h4(
            "antiviral_library dataset:",
            class = "table-title"
          ),
          
          div(
            class = "table-scroll",
            tableOutput("level5_1_library_table")
          )
        )
      })
      
      output$level5_1_effectiveness_table <- renderTable({
        antiviral_effectiveness
      }, striped = FALSE, bordered = TRUE, hover = FALSE)
      
      output$level5_1_library_table <- renderTable({
        antiviral_library
      }, striped = FALSE, bordered = TRUE, hover = FALSE)
      
      output$level5_1_next_ui <- renderUI({
        
        actionButton(
          "level5_1_next_level5_2",
          "Volgende",
          class = "next-btn"
        )
      })
      
    } else {
      
      session$sendCustomMessage("redFlash", TRUE)
      
      output$level5_1_effectiveness_table_ui <- renderUI(NULL)
      output$level5_1_library_table_ui <- renderUI(NULL)
      
      hint_first <- ""
      hint_second <- ""
      
      if (!first_correct) {
        
        hint_first <- paste(
          "Eerste dataset:",
          "Gebruik de leesfunctie die bedoeld is voor komma-gescheiden tekstbestanden.",
          "De bestandsnaam moet als tekst tussen aanhalingstekens staan.",
          sep = "\n"
        )
      }
      
      if (!second_correct) {
        
        hint_second <- paste(
          "Tweede dataset:",
          "Gebruik dezelfde CSV-leesfunctie als bij de eerste dataset.",
          "Controleer of je verwijst naar het bestand met de juiste extensie.",
          sep = "\n"
        )
      }
      
      hint_message <- paste(
        c(hint_first, hint_second),
        collapse = "\n\n"
      )
      
      output$level5_1_console_ui <- renderUI({
        
        div(
          class = "console-message error",
          
          verbatimTextOutput(
            "level5_1_console_text",
            placeholder = FALSE
          )
        )
      })
      
      output$level5_1_console_text <- renderText({
        
        paste(
          "✖ Fout.",
          "",
          hint_message,
          sep = "\n"
        )
      })
      
      output$level5_1_next_ui <- renderUI({
        
        actionButton(
          "level5_1_retry",
          "Probeer opnieuw",
          class = "retry-btn"
        )
      })
    }
  })
  
  observeEvent(input$level5_1_retry, {
    
    # tags$input is een gewone HTML-input. Daarom werkt updateTextInput()
    # hier niet betrouwbaar; maak de velden leeg met JavaScript.
    session$sendCustomMessage(
      type = "resetLevel5_1Inputs",
      message = TRUE
    )
    
    output$level5_1_console_ui <- renderUI(NULL)
    output$level5_1_effectiveness_table_ui <- renderUI(NULL)
    output$level5_1_library_table_ui <- renderUI(NULL)
    output$level5_1_next_ui <- renderUI(NULL)
  })
  
  observeEvent(input$level5_1_next_level5_2, {
    current_page("level5_2")
  })
}