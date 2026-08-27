virus_table <- data.frame(
  VIRUS = c(
    "LIVO-01", "CRIMSONFLU", "SPERION SPORE", "REMNOX-5", "SIAH V COMPLEX",
    "SUBEL X", "SILENTMOTH", "AVRON PATHOGEN", "SOLARIS-7", "HOLLOWFANG"
  ),
  CONCENTRATIE = c(28, 135, 80, 30, 50, 300, 1200, 50, 780, 666),
  LOG10 = c(1.4, 2.1, 1.9, 1.5, 1.7, 2.5, 3.1, 1.7, 2.9, 2.8)
)


level4_7_ui <- function() {
  
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
        
        #run47 {
          margin-top: 20px;
          background-color: #1c1c1c;
          color: #24bb24;
          border: 2px solid #24bb24;
          padding: 10px 20px;
          font-family: 'Courier New', monospace;
          cursor: pointer;
        }
        
        #run47:hover {
          background-color: #24bb24;
          color: #000000;
        }
        
        select {
          background-color: #000000 !important;
          color: #24bb24 !important;
          border: 2px solid #24bb24 !important;
          width: 260px;
          font-family: 'Courier New', monospace !important;
        }
        
      "))
    ),
    
    div(
      class = "game-container",
      
      div(
        class = "editor",
        
        h3("Level 4.7: Identificeer het vrijgekomen virus"),
        
        p(
          "Het vrijgekomen virus heeft een berekende log10-concentratie van:"
        ),
        
        h3("log10 = 1.7"),
        
        p(
          "Bekijk de tabel hieronder en kies welk virus overeenkomt met deze waarde."
        ),
        
        h4(
          "virus_table dataset:",
          class = "table-title"
        ),
        
        div(
          class = "table-scroll",
          tableOutput("virus_table_47")
        ),
        
        br(),
        
        selectInput(
          "virus_choice_47",
          "Welk virus is vrijgekomen?",
          choices = c(
            "LIVO-01",
            "CRIMSONFLU",
            "SPERION SPORE",
            "REMNOX-5",
            "SIAH V COMPLEX",
            "SUBEL X",
            "SILENTMOTH",
            "AVRON PATHOGEN",
            "SOLARIS-7",
            "HOLLOWFANG"
          )
        ),
        
        actionButton(
          "run47",
          "▶ RUN CODE"
        )
      ),
      
      
      div(
        class = "console",
        
        h3("Console"),
        
        uiOutput("console47_ui"),
        
        uiOutput("next_ui47")
      )
    )
  )
}


level4_7_server <- function(input, output, session, current_page) {
  
  output$virus_table_47 <- renderTable({
    
    virus_table
    
  }, striped = FALSE, bordered = TRUE, hover = FALSE)
  
  
  output$console47_ui <- renderUI({
    NULL
  })
  
  
  output$next_ui47 <- renderUI({
    NULL
  })
  
  
  observeEvent(input$run47, {
    
    req(input$virus_choice_47)
    
    
    correct <- "AVRON PATHOGEN"
    
    
    if (input$virus_choice_47 == correct) {
      
      session$sendCustomMessage("greenFlash", TRUE)
      
      
      output$console47_ui <- renderUI({
        
        div(
          class = "console-message success",
          
          verbatimTextOutput(
            "console47",
            placeholder = FALSE
          )
        )
      })
      
      
      output$console47 <- renderText({
        
        paste0(
          "✔ Correct!\n",
          "Het vrijgekomen virus is: ",
          correct,
          "\n\n",
          "De log10-concentratie (1.7) komt exact overeen met \nde waarde in de tabel."
        )
      })
      
      
      output$next_ui47 <- renderUI({
        
        actionButton(
          "next_transition4_5",
          "Volgende",
          class = "next-btn"
        )
      })
      
      
    } else {
      
      session$sendCustomMessage("redFlash", TRUE)
      
      
      output$next_ui47 <- renderUI({
        NULL
      })
      
      
      output$console47_ui <- renderUI({
        
        div(
          class = "console-message error",
          
          verbatimTextOutput(
            "console47",
            placeholder = FALSE
          )
        )
      })
      
      
      output$console47 <- renderText({
        
        paste0(
          "✖ Fout.\n",
          "Je koos: ",
          input$virus_choice_47,
          "\n\n",
          "Hint: zoek het virus met log10-waarde 1.7 \nen bekijk je eerdere aantekeningen."
        )
      })
    }
  })
  
  
  observeEvent(input$next_transition4_5, {
    
    current_page("transition4_5")
    
  })
}