bootsequence <- data.frame(
  step = 1:5,
  action = c("initiate", "load", "authenticate", "unlock", "boot"),
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
          border: 2px solid #24bb24;
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
        
        .console-message{
  background-color:#000000 !important;
  color:#24bb24 !important;
  border:2px solid #24bb24 !important;
  outline:none !important;
  box-shadow:none !important;
  padding:10px;
  margin-top:10px;
  min-height:80px;
}

.console-message.error{
  color:#bb2424 !important;
  border-color:#bb2424 !important;
}

.console-message.success{
  color:#24bb24 !important;
  border-color:#24bb24 !important;
}

.console-message pre{
  background-color:#000000 !important;
  color:inherit !important;
  border:none !important;
  outline:none !important;
  box-shadow:none !important;
  padding:0 !important;
  margin:0 !important;
  font-family:'Courier New',monospace !important;
  white-space:pre-wrap !important;
}

select,
.form-control,
.selectize-input,
.selectize-control.single .selectize-input,
.selectize-dropdown,
.selectize-dropdown .option,
.selectize-input.full{
  background-color:#000000 !important;
  color:#24bb24 !important;
  border:2px solid #24bb24 !important;
  font-family:'Courier New',monospace !important;
}

.selectize-input input{
  color:#24bb24 !important;
}

.selectize-dropdown-content{
  background-color:#000000 !important;
}

.selectize-dropdown .option{
  background-color:#000000 !important;
  color:#24bb24 !important;
}

.selectize-dropdown .active{
  background-color:#24bb24 !important;
  color:#000000 !important;
}

.selectize-control.single .selectize-input:after{
  border-top-color:#24bb24 !important;
}

        select,
        input {
          background-color: #000000;
          color: #24bb24;
          border: 2px solid #24bb24;
        }

        button {
          background-color: #1c1c1c;
          color: #24bb24;
          border: 2px solid #24bb24;
          padding: 8px 16px;
          font-family: 'Courier New', monospace;
          cursor: pointer;
        }

        button:hover {
          background-color: #24bb24;
          color: #1c1c1c;
        }

        .next-btn {
          margin-top: 20px;
          background: #1c1c1c;
          color: #24bb24;
          border: 2px solid #24bb24;
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
  
  output$console_ui <- renderUI({
    NULL
  })
  
  output$next_ui_1_4 <- renderUI({
    NULL
  })
  
  output$level_ui <- renderUI({
    
    div(
      class = "game-container",
      
      div(
        class = "editor",
        
        h3("Level 1.4 — Laad tidyverse en maak een tibble"),
        
        p("Kies de juiste functie om het tidyverse-pakket te laden."),
        
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
        
        br(),
        
        tags$div(
          style="
          background:#000000;
          border:2px solid #24bb24;
          padding:15px;
          margin-bottom:15px;
        ",
          HTML("tibble_bootsequence &lt;- as_tibble(bootsequence)")
        ),
        
        actionButton(
          "run_pkg",
          "▶ RUN CODE"
        )
        
      ),
      
      div(
        class = "console",
        
        h3("Console"),
        
        uiOutput("console_ui"),
        
        uiOutput("next_ui_1_4")
        
      )
      
    )
    
  })
  
  observeEvent(input$run_pkg, {
    
    req(input$package_choice)
    
    if (identical(input$package_choice, "library(tidyverse)")) {
      
      session$sendCustomMessage("greenFlash", TRUE)
      
      suppressPackageStartupMessages(
        library(tidyverse)
      )
      
      tib <- as_tibble(bootsequence)
      
      output$console_ui <- renderUI({
        
        div(
          class = "console-message success",
          
          verbatimTextOutput(
            "console_out",
            placeholder = FALSE
          )
        )
        
      })
      
      output$console_out <- renderText({
        
        paste0(
          "✔ Correct!\n\n",
          "> library(tidyverse)\n",
          "> as_tibble(bootsequence)\n\n",
          paste(
            capture.output(print(tib)),
            collapse = "\n"
          )
        )
        
      })
      
      output$next_ui_1_4 <- renderUI({
        
        tagList(
          
          br(),
          
          actionButton(
            "next_transition1_2",
            "Volgende",
            class = "next-btn"
          )
          
        )
        
      })
      
    } else {
      
      session$sendCustomMessage("redFlash", TRUE)
      
      output$console_ui <- renderUI({
        
        div(
          class = "console-message error",
          
          verbatimTextOutput(
            "console_out",
            placeholder = FALSE
          )
        )
        
      })
      
      output$console_out <- renderText({
        
        paste(
          "✖ Fout.",
          "",
          "Hint: gebruik de standaardfunctie om een package te laden.",
          "",
          sep = "\n"
        )
        
      })
      
      output$next_ui_1_4 <- renderUI({
        NULL
      })
      
    }
    
  })
  
  observeEvent(input$next_transition1_2, {
    
    current_page("transition1_2")
    
  })
  
}