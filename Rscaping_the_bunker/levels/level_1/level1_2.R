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
          color: #24bb24;
          font-family: 'Courier New', monospace;
        }

        .level12-game-container {
          display: flex;
          gap: 20px;
          margin-top: 20px;
          align-items: flex-start;
        }

        .level12-editor,
        .level12-console {
          width: 50%;
          padding: 15px;
          font-family: 'Courier New', monospace;
          border: 2px solid #24bb24;
          text-align: left;
          box-sizing: border-box;
        }

        .level12-editor {
          background-color: #1c1c1c !important;
          color: #24bb24 !important;
          min-height: 300px;
        }

        .level12-console {
          background-color: #000000 !important;
          color: #24bb24 !important;
          min-height: 300px;
          white-space: pre-wrap;
        }

        .level12-console h3 {
          color: #24bb24 !important;
        }

        .level12-console-message {
          background-color: #000000 !important;
          color: #24bb24 !important;
          border: 2px solid #24bb24 !important;
          outline: none !important;
          box-shadow: none !important;
          -webkit-box-shadow: none !important;
          text-shadow: none !important;
          padding: 10px;
          margin-top: 10px;
          min-height: 100px;
          font-family: 'Courier New', monospace !important;
          white-space: pre-wrap;
        }

        .level12-console-message.success {
          color: #24bb24 !important;
          border-color: #24bb24 !important;
        }

        .level12-console-message.error {
          color: #bb2424 !important;
          border-color: #bb2424 !important;
        }

        .level12-console-message pre {
          background-color: #000000 !important;
          color: inherit !important;
          border: none !important;
          outline: none !important;
          box-shadow: none !important;
          -webkit-box-shadow: none !important;
          text-shadow: none !important;
          padding: 0 !important;
          margin: 0 !important;
          font-family: 'Courier New', monospace !important;
          white-space: pre-wrap !important;
        }

        .level12-select-container {
          margin-top: 10px;
          margin-bottom: 15px;
        }

        .level12-select-container label {
          color: #24bb24 !important;
          font-family: 'Courier New', monospace !important;
        }

        .level12-select-container select,
        .level12-select-container .form-control,
        .level12-select-container .selectize-input,
        .level12-select-container .selectize-control.single .selectize-input,
        .level12-select-container .selectize-dropdown,
        .level12-select-container .selectize-dropdown .option,
        .level12-select-container .selectize-input.full {
          background-color: #000000 !important;
          color: #24bb24 !important;
          border: 2px solid #24bb24 !important;
          outline: none !important;
          box-shadow: none !important;
          -webkit-box-shadow: none !important;
          text-shadow: none !important;
          font-family: 'Courier New', monospace !important;
        }

        .level12-select-container select:focus,
        .level12-select-container .form-control:focus,
        .level12-select-container .selectize-input:focus,
        .level12-select-container .selectize-input.focus,
        .level12-select-container .selectize-input.input-active,
        .level12-select-container .selectize-control.single .selectize-input.focus,
        .level12-select-container .selectize-control.single .selectize-input.input-active {
          background-color: #000000 !important;
          color: #24bb24 !important;
          border: 2px solid #24bb24 !important;
          outline: none !important;
          box-shadow: none !important;
          -webkit-box-shadow: none !important;
          text-shadow: none !important;
        }

        .level12-select-container .selectize-input input {
          background-color: #000000 !important;
          color: #24bb24 !important;
          outline: none !important;
          box-shadow: none !important;
          -webkit-box-shadow: none !important;
          text-shadow: none !important;
        }

        .level12-select-container .selectize-input input:focus {
          background-color: #000000 !important;
          color: #24bb24 !important;
          outline: none !important;
          box-shadow: none !important;
          -webkit-box-shadow: none !important;
          text-shadow: none !important;
        }

        .level12-select-container .selectize-dropdown-content {
          background-color: #000000 !important;
          box-shadow: none !important;
          -webkit-box-shadow: none !important;
        }

        .level12-select-container .selectize-dropdown .option {
          background-color: #000000 !important;
          color: #24bb24 !important;
          border: none !important;
          outline: none !important;
          box-shadow: none !important;
        }

        .level12-select-container .selectize-dropdown .active {
          background-color: #24bb24 !important;
          color: #000000 !important;
          box-shadow: none !important;
          -webkit-box-shadow: none !important;
        }

        .level12-select-container .selectize-control.single .selectize-input:after {
          border-top-color: #24bb24 !important;
        }

        .level12-editor input:focus,
        .level12-editor select:focus,
        .level12-editor textarea:focus,
        .level12-editor button:focus {
          outline: none !important;
          box-shadow: none !important;
          -webkit-box-shadow: none !important;
        }

        .level12-run-btn,
        .level12-next-btn {
          margin-top: 20px;
          background: #1c1c1c !important;
          color: #24bb24 !important;
          border: 2px solid #24bb24 !important;
          outline: none !important;
          box-shadow: none !important;
          -webkit-box-shadow: none !important;
          padding: 10px 20px;
          font-family: 'Courier New', monospace !important;
          cursor: pointer;
        }

        .level12-run-btn:hover,
        .level12-next-btn:hover {
          background: #24bb24 !important;
          color: #1c1c1c !important;
        }

        .level12-run-btn:focus,
        .level12-next-btn:focus {
          outline: none !important;
          box-shadow: none !important;
          -webkit-box-shadow: none !important;
        }

        .level12-green-flash {
          position: fixed;
          inset: 0;
          pointer-events: none;
          z-index: 9999;
          background: rgba(0, 255, 0, 0);
        }

        .level12-green-flash.active {
          animation: level12GreenFlash 0.35s ease-out 1;
        }

        @keyframes level12GreenFlash {
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

        .level12-red-flash {
          position: fixed;
          inset: 0;
          pointer-events: none;
          z-index: 9999;
          background: rgba(255, 0, 0, 0);
        }

        .level12-red-flash.active {
          animation: level12RedFlash 0.35s ease-out 1;
        }

        @keyframes level12RedFlash {
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
        function level12EnsureFlash(id, className) {
          if (!document.getElementById(id)) {
            const flashElement = document.createElement('div');

            flashElement.id = id;
            flashElement.className = className;

            document.body.appendChild(flashElement);
          }
        }

        function level12ActivateFlash(id, className) {
          level12EnsureFlash(id, className);

          const flashElement = document.getElementById(id);

          flashElement.classList.remove('active');

          void flashElement.offsetWidth;

          flashElement.classList.add('active');
        }

        if (window.Shiny && Shiny.addCustomMessageHandler) {
          Shiny.addCustomMessageHandler(
            'level12GreenFlash',
            function(message) {
              level12ActivateFlash(
                'level12-green-flash-overlay',
                'level12-green-flash'
              );
            }
          );

          Shiny.addCustomMessageHandler(
            'level12RedFlash',
            function(message) {
              level12ActivateFlash(
                'level12-red-flash-overlay',
                'level12-red-flash'
              );
            }
          );
        }
      })();
    ")),
    
    div(
      class = "level12-game-container",
      
      div(
        class = "level12-editor",
        
        h3("Level 1.2: maak een tibble"),
        
        p(
          "Kies de juiste functie om een tibble te maken van de dataset 'bootsequence'."
        ),
        
        HTML("tibble_bootsequence &lt;- "),
        
        div(
          class = "level12-select-container",
          
          selectInput(
            inputId = "level12_tibble_choice",
            label = NULL,
            choices = c(
              "tibble(bootsequence)" =
                "tibble(bootsequence)",
              "as_tibble(bootsequence)" =
                "as_tibble(bootsequence)",
              "make_tibble(bootsequence)" =
                "make_tibble(bootsequence)",
              "tibble::create(bootsequence)" =
                "tibble::create(bootsequence)"
            ),
            selected = character(0)
          )
        ),
        
        actionButton(
          inputId = "level12_submit_tibble",
          label = "▶ RUN CODE",
          class = "level12-run-btn"
        )
      ),
      
      div(
        class = "level12-console",
        
        h3("Console"),
        
        uiOutput("level12_console_ui"),
        
        uiOutput("level12_next_ui")
      )
    )
  )
}


level1_2_server <- function(input, output, session, current_page) {
  
  output$level12_console_ui <- renderUI({
    NULL
  })
  
  output$level12_next_ui <- renderUI({
    NULL
  })
  
  
  observeEvent(input$level12_submit_tibble, {
    
    req(input$level12_tibble_choice)
    
    if (
      identical(
        input$level12_tibble_choice,
        "as_tibble(bootsequence)"
      )
    ) {
      
      session$sendCustomMessage(
        "level12GreenFlash",
        TRUE
      )
      
      output$level12_console_ui <- renderUI({
        
        div(
          class = "level12-console-message success",
          
          verbatimTextOutput(
            "level12_console_output",
            placeholder = FALSE
          )
        )
      })
      
      output$level12_console_output <- renderText({
        
        paste(
          "✔ Correct.",
          "",
          "> as_tibble(bootsequence)",
          "",
          "De dataset is succesvol omgezet naar een tibble.",
          sep = "\n"
        )
      })
      
      output$level12_next_ui <- renderUI({
        
        actionButton(
          inputId = "level12_next_level1_3",
          label = "Volgende",
          class = "level12-next-btn"
        )
      })
      
    } else {
      
      session$sendCustomMessage(
        "level12RedFlash",
        TRUE
      )
      
      output$level12_console_ui <- renderUI({
        
        div(
          class = "level12-console-message error",
          
          verbatimTextOutput(
            "level12_console_output",
            placeholder = FALSE
          )
        )
      })
      
      output$level12_console_output <- renderText({
        
        paste(
          "✖ Incorrect.",
          "",
          "Hint:",
          "Let goed op welke optie een standaardfunctie uit het tidyverse package gebruikt.",
          sep = "\n"
        )
      })
      
      output$level12_next_ui <- renderUI({
        NULL
      })
    }
  })
  
  
  observeEvent(
    input$level12_next_level1_3,
    {
      current_page("level1_3")
    },
    ignoreInit = TRUE
  )
}