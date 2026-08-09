bootsequence <- data.frame(
  step = 1:5,
  action = c("init", "load", "verify", "unlock", "boot"),
  status = c("OK", "OK", "OK", "OK", "READY"),
  stringsAsFactors = FALSE
)

level1_2_ui <- function() {
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
        
        h3("📂 Level 1.2: maak een tibble"),
        
        p("Kies de juiste functie om een tibble te maken van de dataset 'bootsequence'."),
        
        HTML("tibble_bootsequence <- "),
        
        selectInput(
          inputId = "tibble_choice",
          label = NULL,
          choices = c(
            "tibble(bootsequence)" = "tibble(bootsequence)",
            "as_tibble(bootsequence)" = "as_tibble(bootsequence)",
            "make_tibble(bootsequence)" = "make_tibble(bootsequence)",
            "tibble::create(bootsequence)" = "tibble::create(bootsequence)"
          )
        ),
        
        actionButton("submit_tibble", "▶ RUN CODE")
      ),
      
      div(
        class = "console",
        
        h3("Console"),
        
        verbatimTextOutput("tibble_console"),
        
        uiOutput("tibble_next")
      )
    )
  )
}

level1_2_server <- function(input, output, session, current_page) {
  
  # Console start leeg
  output$tibble_console <- renderText({ "" })
  
  # Geen next button bij start
  output$tibble_next <- renderUI({ NULL })
  
  observeEvent(input$submit_tibble, {
    req(input$tibble_choice)
    
    # Correct antwoord: as_tibble(bootsequence)
    if (identical(input$tibble_choice, "as_tibble(bootsequence)")) {
      
      session$sendCustomMessage("greenFlash", TRUE)
      
      output$tibble_console <- renderText({
        paste(
          "> as_tibble(bootsequence)",
          "",
          "Error in as_tibble(bootsequence) :",
          "  could not find function 'as_tibble'",
          "",
          "HINT:",
          "Laad eerst het tidyverse package.",
          sep = "\n"
        )
      })
      
      output$tibble_next <- renderUI({
        actionButton("next_level1_3", "Volgende", class = "next-btn")
      })
      
    } else {
      
      session$sendCustomMessage("redFlash", TRUE)
      
      output$tibble_next <- renderUI(NULL)
      
      output$tibble_console <- renderText({
        paste(
          "> ", input$tibble_choice,
          "",
          "✖ Incorrect.",
          "",
          "Hint:",
          "Dit is niet de functie waarmee tidyverse een data.frame omzet naar een tibble.",
          sep = "\n"
        )
      })
    }
  })
  
  observeEvent(input$next_level1_3, {
    current_page("level1_3")
  })
}