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

        .editor,
        .console {
          width: 50%;
          padding: 15px;
          border: 2px solid #00FF00;
          font-family: 'Courier New', monospace;
          text-align: left;
        }

        .editor {
          background-color: #1c1c1c;
          min-height: 260px;
        }

        .console {
          background-color: #000000;
          min-height: 260px;
          white-space: pre-wrap;
        }

        select,
        input {
          background-color: #000000;
          color: #00FF00;
          border: 2px solid #00FF00;
        }

        button {
          background-color: #1c1c1c;
          color: #00FF00;
          border: 2px solid #00FF00;
          padding: 8px 16px;
          font-family: 'Courier New', monospace;
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
          font-family: 'Courier New', monospace;
          cursor: pointer;
        }

        .green-flash {
          position: fixed;
          inset: 0;
          pointer-events: none;
          z-index: 9999;
          background: rgba(0, 255, 0, 0);
        }

        .green-flash.active {
          animation: greenFlash 0.35s ease-out 1;
        }

        @keyframes greenFlash {
          0% {
            background: rgba(0, 255, 0, 0);
          }

          20% {
            background: rgba(0, 255, 0, 0.18);
          }

          100% {
            background: rgba(0, 255, 0, 0);
          }
        }

        .red-flash {
          position: fixed;
          inset: 0;
          pointer-events: none;
          z-index: 9999;
          background: rgba(255, 0, 0, 0);
        }

        .red-flash.active {
          animation: redFlash 0.35s ease-out 1;
        }

        @keyframes redFlash {
          0% {
            background: rgba(255, 0, 0, 0);
          }

          20% {
            background: rgba(255, 0, 0, 0.18);
          }

          100% {
            background: rgba(255, 0, 0, 0);
          }
        }
      "))
    ),
    
    tags$script(HTML("
      (function() {
        function ensureFlash(id, className) {
          if (!document.getElementById(id)) {
            const d = document.createElement('div');
            d.id = id;
            d.className = className;
            document.body.appendChild(d);
          }
        }

        function activateFlash(id, className) {
          ensureFlash(id, className);

          const flash = document.getElementById(id);

          flash.classList.remove('active');

          void flash.offsetWidth;

          flash.classList.add('active');
        }

        if (window.Shiny && Shiny.addCustomMessageHandler) {
          Shiny.addCustomMessageHandler('greenFlash', function(message) {
            activateFlash('green-flash-overlay', 'green-flash');
          });

          Shiny.addCustomMessageHandler('redFlash', function(message) {
            activateFlash('red-flash-overlay', 'red-flash');
          });
        }
      })();
    ")),
    
    uiOutput("level_ui")
  )
}


level1_4_server <- function(input, output, session, current_page) {
  
  console <- reactiveVal("")
  
  output$console_out <- renderText({
    console()
  })
  
  output$level_ui <- renderUI({
    
    div(
      class = "game-container",
      
      div(
        class = "editor",
        
        h3("Level 1.4 — Laad tidyverse en maak een tibble"),
        
        p("Kies het juiste script om het tidyverse-pakket te laden."),
        
        selectInput(
          inputId = "package_choice",
          label = NULL,
          choices = c(
            "library(tidyverse)" = "library(tidyverse)",
            "load(tidyverse)" = "load(tidyverse)",
            "require_tidyverse()" = "require_tidyverse()",
            "import(tidyverse)" = "import(tidyverse)"
          )
        ),
        
        HTML("tibble_bootsequence <- as_tibble(bootsequence)"),
        
        actionButton(
          inputId = "run_pkg",
          label = "▶ RUN CODE"
        )
      ),
      
      div(
        class = "console",
        
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
    
    if (identical(input$package_choice, "library(tidyverse)")) {
      
      session$sendCustomMessage("greenFlash", TRUE)
      
      suppressPackageStartupMessages(
        library(tidyverse)
      )
      
      tib <- as_tibble(bootsequence)
      
      console(
        paste0(
          "> library(tidyverse)\n",
          "> as_tibble(bootsequence)\n\n",
          paste(
            capture.output(print(tib)),
            collapse = "\n"
          )
        )
      )
      
      output$next_ui_1_4 <- renderUI({
        tagList(
          br(),
          
          actionButton(
            inputId = "next_transition1_2",
            label = "Volgende",
            class = "next-btn"
          )
        )
      })
      
    } else {
      
      session$sendCustomMessage("redFlash", TRUE)
      
      console(
        paste0(
          "> ", input$package_choice, "\n\n",
          "✖ Incorrect.\n",
          "Hint: gebruik de standaardfunctie om een package te laden."
        )
      )
      
      output$next_ui_1_4 <- renderUI({
        NULL
      })
    }
  })
  
  observeEvent(input$next_transition1_2, {
    current_page("transition1_2")
  })
}