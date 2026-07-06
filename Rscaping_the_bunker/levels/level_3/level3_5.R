library(shiny)
library(shinyjs)

# --- Data ---
virus_dataset <- data.frame(
  virus = c(
    "Livo-01", "CrimsonFlu", "Sperion Spore", "Remnox-5", "Siah-V Complex",
    "Subel-X", "SilentMoth", "Avron Pathogen", "Solaris-7", "HollowFang"
  ),
  mean_onset_days = c(3.2, 1.8, 5.6, 2.4, 4.1, 6.3, 7.8, 3.9, 2.1, 5.0),
  sd_onset_days = c(0.8, 0.5, 1.2, 0.6, 1.0, 1.4, 1.9, 0.8, 0.4, 1.1)
)

escaped_virus_dataset <- data.frame(
  virus = "Unknown Virus",
  mean_onset_days = 3.92,
  sd_onset_days = 0.9
)

# --- UI ---
level3_5_ui <- function() {
  fluidPage(
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
    
    div(class = "game-container",
        
        div(class = "editor",
            h3("🔍 Level 3.5: Virus lokalisatie"),
            p("Hiernaast zijn de gemiddelden en SD waarden van de virussen te zien."),
            p("Kijkend naar deze informatie, welk virus is vrijgekomen in de bunker?"),
            
            radioButtons(
              inputId = "virus_answer_3_5",
              label = "Kies het juiste antwoord:",
              choices = list(
                "a) Livo-01" = "a",
                "b) CrimsonFlu" = "b",
                "c) Sperion Spore" = "c",
                "d) Remnox-5" = "d",
                "e) Siah-V Complex" = "e",
                "f) Subel-X" = "f",
                "g) SilentMoth" = "g",
                "h) Avron Pathogen" = "h",
                "i) Solaris-7" = "i",
                "j) HollowFang" = "j"
              )
            ),
            
            actionButton("submit_excel_3_5", "▶ RUN CODE")
        ),
        
        div(class = "console",
            h3("Console"),
            verbatimTextOutput("excel_console"),
            h3("Virus Dataset:"),
            tableOutput("virus_table_data"),
            h3("Escaped Virus Dataset:"),
            tableOutput("escaped_virus_table_data"),
            uiOutput("next_ui")
        )
    )
  )
}

# --- Server ---
level3_5_server <- function(input, output, session, current_page) {
  
  output$virus_table_data <- renderTable({
    virus_dataset
  })
  
  output$escaped_virus_table_data <- renderTable({
    escaped_virus_dataset
  })
  
  observeEvent(input$submit_excel_3_5, {
    req(input$virus_answer_3_5)
    
    correct <- "h"  # Avron Pathogen
    
    if (input$virus_answer_3_5 == correct) {
      session$sendCustomMessage("greenFlash", TRUE)
      
      output$excel_console <- renderText({
        "✔ Correct!\nDe mean_onset_days en SD komen het best overeen met die van Avron Pathogen."
      })
      
      output$next_ui <- renderUI({
        actionButton("next_transition3_4", "Volgende", class = "next-btn")
      })
      
    } else {
      session$sendCustomMessage("redFlash", TRUE)
      
      output$excel_console <- renderText({
        paste0(
          "✖ Fout.\nJe koos antwoord: ", input$virus_answer_3_5, "\n\n",
          "Hint: Kijk nog eens goed naar de mean_onset_days en SD van het vrijgekomen virus."
        )
      })
      
      output$next_ui <- renderUI(NULL)
    }
  })
  
  observeEvent(input$next_transition3_4, {
    current_page("transition3_4")
  })
}
