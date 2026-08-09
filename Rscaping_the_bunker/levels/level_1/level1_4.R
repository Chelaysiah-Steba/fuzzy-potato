bootsequence <- data.frame(
  step = 1:5,
  action = c("init", "load", "verify", "unlock", "boot"),
  status = c("OK", "OK", "OK", "OK", "READY"),
  stringsAsFactors = FALSE
)

level1_4_ui <- function() {
  fluidPage(
    useShinyjs(),
    
    tags$head(
      tags$style(HTML("
        body { background-color:#1c1c1c; color:#00FF00; font-family:'Courier New', monospace; }
        .game-container { display:flex; gap:20px; margin-top:20px; }
        .editor, .console { width:50%; padding:15px; border:2px solid #00FF00; }
        .editor { background-color:#1c1c1c; min-height:260px; }
        .console { background-color:#000000; min-height:260px; white-space:pre-wrap; }
        select, input { background-color:#000000; color:#00FF00; border:2px solid #00FF00; }
        button { background-color:#1c1c1c; color:#00FF00; border:2px solid #00FF00; padding:8px 16px; }
        button:hover { background-color:#00FF00; color:#1c1c1c; }
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
    
    uiOutput("level_ui")
  )
}

level1_4_server <- function(input, output, session, current_page) {
  
  console <- reactiveVal("")
  
  output$console_out <- renderText(console())
  
  output$level_ui <- renderUI({
    
    div(class = "game-container",
        
        div(class = "editor",
            h3("Level 1.4 — Laad tidyverse en maak een tibble"),
            
            p("Kies het juiste script om het tidyverse‑pakket te laden."),
            
            selectInput(
              "package_choice",
              NULL,
              choices = c(
                "library(tidyverse)" = "library(tidyverse)",
                "load(tidyverse)" = "load(tidyverse)",
                "require_tidyverse()" = "require_tidyverse()",
                "import(tidyverse)" = "import(tidyverse)"
              )
            ),
            
            HTML("tibble_bootsequence <- as_tibble(bootsequence)"),
            
            actionButton("run_pkg", "▶ RUN CODE")
        ),
        
        div(class = "console",
            h3("Console"),
            verbatimTextOutput("console_out"),
            uiOutput("next_ui_1_4")
        )
    )
  })
  
  output$next_ui_1_4 <- renderUI({
    NULL
  })
  
  observeEvent(input$run_pkg, {
    
    req(input$package_choice)
    
    # Correct answer
    if (input$package_choice == "library(tidyverse)") {
      
      # Load tidyverse
      suppressPackageStartupMessages(library(tidyverse))
      
      # Create tibble
      tib <- as_tibble(bootsequence)
      
      console(
        paste0(
          "> library(tidyverse)\n",
          "> as_tibble(bootsequence)\n\n",
          paste(capture.output(print(tib)), collapse = "\n")
        )
      )
      
      # Toon 'Volgende'-button
      output$next_ui_1_4 <- renderUI({
        actionButton("next_transition1_2", "Volgende", class = "next-btn")
      })
      
    } else {
      
      console(
        paste0(
          "> ", input$package_choice, "\n\n",
          "✖ Incorrect.\n",
          "Hint: gebruik de standaardfunctie om een package te laden."
        )
      )
      
      # Verberg button bij fout
      output$next_ui_1_4 <- renderUI(NULL)
    }
  })
  
  observeEvent(input$next_transition1_2, {
    current_page("transition1_2")
  })
}