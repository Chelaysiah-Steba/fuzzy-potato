untidy_df <- data.frame(
  Scientist = c(
    "sci01","sci01","sci02","sci02","sci03","sci03","sci04","sci04","sci05","sci05"
  ),
  MeasurementType = rep(c("on_site", "symptom_onset_days"), times = 5),
  MeasurementValue = c(
    "yes", 5, "no", 7, "yes", 3, "yes", 4, "yes", 4
  )
)

level3_2_ui <- function() {
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
        
        actionButton("submit_excel_l3_2", "▶ RUN CODE")
      ),
      
      div(
        class = "console",
        h3("Console"),
        verbatimTextOutput("excel_console_l3_2"),
        uiOutput("game_next_l3_2")
      )
    )
  )
}

level3_2_server <- function(input, output, session, current_page) {
  
  output$untidy_table_l3_2 <- renderTable({
    untidy_df
  }, rownames = FALSE)
  
  output$game_next_l3_2 <- renderUI({
    NULL
  })
  
  output$excel_console_l3_2 <- renderText({
    ""
  })
  
  observeEvent(input$submit_excel_l3_2, {
    req(input$tidy_answer_l3_2)
    
    correct <- "b"
    
    if (identical(input$tidy_answer_l3_2, correct)) {
      
      session$sendCustomMessage("greenFlash", TRUE)
      
      output$excel_console_l3_2 <- renderText({
        paste(
          "🟢 CORRECT",
          "",
          "De variabelen staan niet in aparte kolommen.",
          "",
          "STATUS: ONLINE",
          sep = "\n"
        )
      })
      
      output$game_next_l3_2 <- renderUI({
        actionButton("next_level3_3", "Volgende", class = "next-btn")
      })
      
    } else {
      
      session$sendCustomMessage("redFlash", TRUE)
      
      output$excel_console_l3_2 <- renderText({
        paste(
          "🔴 FOUT",
          "",
          paste0("Je koos antwoord: ", input$tidy_answer_l3_2),
          "",
          "HINT",
          "Alle variabelen horen aparte kolommen te zijn.",
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