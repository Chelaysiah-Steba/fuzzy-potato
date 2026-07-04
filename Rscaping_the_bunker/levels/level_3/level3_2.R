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
        
        tableOutput("untidy_table"),
        
        radioButtons(
          inputId = "tidy_answer",
          label = "Kies het juiste antwoord:",
          choices = list(
            "a) ja, dit is tidy data" = "a",
            "b) nee, de age en survival rate staan niet in aparte kolommen" = "b",
            "c) nee, de kolommen zijn niet alfabetisch geordend" = "c",
            "d) nee, want voor elke scientist zijn er meerdere metingen" = "d"
          )
        ),
        
        actionButton("submit_excel", "▶ RUN CODE")
      ),
      
      div(
        class = "console",
        h3("Console"),
        verbatimTextOutput("excel_console")
      )
    )
  )
}

level3_2_server <- function(input, output, session, current_page) {
  
  output$untidy_table <- renderTable({
    untidy_df
  })
  
  observeEvent(input$submit_excel, {
    req(input$tidy_answer)
    
    correct <- "b"
    
    if (input$tidy_answer == correct) {
      
      session$sendCustomMessage("greenFlash", TRUE)
      
      output$excel_console <- renderText({
        paste(
          "🟢 CORRECT",
          "",
          "De variabelen staan niet in aparte kolommen.",
          "",
          "STATUS: ONLINE",
          sep = "\n"
        )
      })
      
      output$untidy_table <- renderTable({
        untidy_df
      })
      
      output$game_next <- renderUI({
        actionButton("next_level3_3", "Volgende", class = "next-btn")
      })
      
    } else {
      
      session$sendCustomMessage("redFlash", TRUE)
      
      output$excel_console <- renderText({
        paste(
          "🔴 FOUT",
          "",
          paste0("Je koos antwoord: ", input$tidy_answer),
          "",
          "HINT",
          "Alle variabelen horen aparte kolommen te zijn.",
          sep = "\n"
        )
      })
    }
  })
  
  observeEvent(input$next_level3_3, {
    current_page("3_3")
  })
}