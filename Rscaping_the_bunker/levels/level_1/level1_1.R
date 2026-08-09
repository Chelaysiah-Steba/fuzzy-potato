bootsequence <- data.frame(
  step = 1:5,
  action = c("init", "load", "verify", "unlock", "boot"),
  status = c("OK", "OK", "OK", "OK", "READY"),
  stringsAsFactors = FALSE
)

level1_1_ui <- function() {
  fluidPage(
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

        .next-btn{
          margin-top:20px;
          background:#1c1c1c;
          color:#00FF00;
          border:2px solid #00FF00;
          padding:10px 20px;
          font-family:'Courier New';
          cursor:pointer;
        }
      "))
    ),
    
    div(
      class = "game-container",
      
      div(
        class = "editor",
        
        h3("📂 Level 1.1: laad het RDS-bestand"),
        
        p("Gebruik de juiste functie om het bestand 'bootsequence.rds' te laden."),
        
        selectInput(
          inputId = "rds_choice",
          label = NULL,
          choices = c(
            "read_excel('bootsequence.xlsx')" = "read_excel('bootsequence.rds')",
            "readRDS('bootsequence.rds')" = "readRDS('bootsequence.rds')",
            "read_csv('bootsequence.csv')" = "read_csv('bootsequence.rds')",
            "read_rds('bootsequence.rds')" = "read_rds('bootsequence.rds')"
          )
        ),
        
        actionButton("submit_rds", "▶ RUN CODE")
      ),
      
      div(
        class = "console",
        
        h3("Console"),
        
        verbatimTextOutput("rds_console"),
        
        uiOutput("boot_table")
      )
    )
  )
}

level1_1_server <- function(input, output, session, current_page) {
  
  output$rds_console <- renderText({
    ""
  })
  
  output$boot_table <- renderUI({
    NULL
  })
  
  observeEvent(input$submit_rds, {
    req(input$rds_choice)
    
    # Correct antwoord: B = readRDS('bootsequence.rds')
    if (identical(input$rds_choice, "readRDS('bootsequence.rds')")) {
      
      session$sendCustomMessage("greenFlash", TRUE)
      
      output$rds_console <- renderText({
        paste(
          "🟢 SECURITY PROTOCOL UPDATED",
          "",
          "Module 1/4 geactiveerd.",
          "",
          "Bootsequence Module",
          "STATUS: ONLINE",
          sep = "\n"
        )
      })
      
      output$boot_table <- renderUI({
        tagList(
          h3("📊 Geladen dataset: bootsequence"),
          tableOutput("boot_table_data"),
          br(),
          actionButton("next_level1_2", "Volgende", class = "next-btn")
        )
      })
      
      output$boot_table_data <- renderTable({
        bootsequence
      })
      
    } else {
      
      session$sendCustomMessage("redFlash", TRUE)
      
      output$boot_table <- renderUI(NULL)
      
      output$rds_console <- renderText({
        paste(
          "🔴 SECURITY PROTOCOL FAILED",
          "",
          "Module activation unsuccessful.",
          "",
          paste0("Je koos: ", input$rds_choice),
          "",
          "HINT",
          "Voor een .rds-bestand gebruik je readRDS().",
          sep = "\n"
        )
      })
    }
  })
  
  observeEvent(input$next_level1_2, {
    current_page("level1_2")
  })
}