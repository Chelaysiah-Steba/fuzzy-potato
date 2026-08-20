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
          color: #00FF00;
          font-family: 'Courier New', monospace;
        }
        .game-container {
          display: flex;
          gap: 10px;
          margin-top: 10px;
        }
        .editor, .console {
          width: 50%;
          padding: 10px;
          border: 2px solid #00FF00;
        }
        .editor { background-color: #1c1c1c; }
        .console { background-color: #000000; white-space: pre-wrap; }
        table {
          color: #00FF00;
          font-family: 'Courier New';
        }
        select {
          background-color: #000000;
          color: #00FF00;
          border: 2px solid #00FF00;
          width: 260px;
        }
        button {
          background-color: #1c1c1c;
          color: #00FF00;
          border: 2px solid #00FF00;
          padding: 8px 16px;
          cursor: pointer;
        }
        button:hover {
          background-color: #00FF00;
          color: #1c1c1c;
        }
        .next-btn {
          margin-top: 20px;
          background: #1c1c1c;
          color: #00FF00;
          border: 2px solid #00FF00;
          padding: 10px 20px;
          font-family: 'Courier New';
          cursor: pointer;
        }
      "))
    ),
    
    div(
      class = "game-container",
      
      div(
        class = "editor",
        h3("Level 4.7: Identificeer het vrijgekomen virus"),
        p("Het vrijgekomen virus heeft een berekende log10‑concentratie van:"),
        h3("log10 = 1.7"),
        p("Bekijk de tabel hieronder en kies welk virus overeenkomt met deze waarde."),
        
        tableOutput("virus_table_47"),
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
        
        actionButton("run47", "▶ RUN CODE")
      ),
      
      div(
        class = "console",
        h3("Console"),
        verbatimTextOutput("console47"),
        uiOutput("next_ui47")
      )
    )
  )
}

level4_7_server <- function(input, output, session, current_page) {
  
  output$virus_table_47 <- renderTable({
    virus_table
  })
  
  output$console47 <- renderText({ "" })
  output$next_ui47 <- renderUI(NULL)
  
  observeEvent(input$run47, {
    req(input$virus_choice_47)
    
    correct <- "AVRON PATHOGEN"
    
    if (input$virus_choice_47 == correct) {
      
      session$sendCustomMessage("greenFlash", TRUE)
      
      output$console47 <- renderText({
        paste0(
          "✔ Correct!\n",
          "Het vrijgekomen virus is: ", correct, "\n\n",
          "De log10‑concentratie (1.7) komt exact overeen met de waarde in de tabel."
        )
      })
      
      output$next_ui47 <- renderUI({
        actionButton("next_transition4_5", "Volgende", class = "next-btn")
      })
      
    } else {
      
      session$sendCustomMessage("redFlash", TRUE)
      
      output$console47 <- renderText({
        paste0(
          "✘ Fout.\nJe koos: ", input$virus_choice_47, "\n\n",
          "Hint: zoek het virus met log10‑waarde 1.7."
        )
      })
      
      output$next_ui47 <- renderUI(NULL)
    }
  })
  
  observeEvent(input$next_transition4_5, {
    current_page("transition4_5")
  })
}