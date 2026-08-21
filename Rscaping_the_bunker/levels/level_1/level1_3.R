level1_3_ui <- function() {
  
  fluidPage(
    
    useShinyjs(),
    
    tags$head(
      tags$style(HTML("

        body {
          background-color: #1c1c1c;
          color: #24bb24;
          font-family: 'Courier New', monospace;
        }

        .level13-game-container {
          display: flex;
          gap: 20px;
          margin-top: 20px;
        }

        .level13-editor,
        .level13-console {
          width: 50%;
          padding: 15px;
          font-family: 'Courier New', monospace;
          border: 2px solid #24bb24;
          text-align: left;
          box-sizing: border-box;
        }

        .level13-editor {
          background-color: #1c1c1c !important;
          color: #24bb24 !important;
          min-height: 260px;
        }

        .level13-console {
          background-color: #000000 !important;
          color: #24bb24 !important;
          min-height: 260px;
          white-space: pre-wrap;
        }

        .level13-console h3 {
          color: #24bb24 !important;
        }

        .level13-console-message {
          background-color: #000000 !important;
          color: #24bb24 !important;
          border: 2px solid #24bb24 !important;
          outline: none !important;
          box-shadow: none !important;
          padding: 10px;
          margin-top: 10px;
          min-height: 80px;
          font-family: 'Courier New', monospace !important;
          white-space: pre-wrap;
        }

        .level13-console-message.error {
          color: #bb2424 !important;
          border-color: #bb2424 !important;
        }

        .level13-console-message.success {
          color: #24bb24 !important;
          border-color: #24bb24 !important;
        }

        .level13-console-message pre {
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

        .level13-warning-message {
          background-color: #000000 !important;
          color: #24bb24 !important;
          border: 2px solid #24bb24 !important;
          outline: none !important;
          box-shadow: none !important;
          padding: 15px;
          margin-bottom: 15px;
          font-family: 'Courier New', monospace !important;
          white-space: pre-wrap;
        }

        .level13-warning-message pre {
          background-color: #000000 !important;
          color: #24bb24 !important;
          border: none !important;
          outline: none !important;
          box-shadow: none !important;
          padding: 0 !important;
          margin: 0 !important;
          font-family: 'Courier New', monospace !important;
          white-space: pre-wrap !important;
        }

        .level13-radio label {
          color: #24bb24 !important;
          font-family: 'Courier New', monospace !important;
        }

        .level13-radio input[type='radio'] {
          accent-color: #24bb24;
        }

        .level13-start-btn,
        .level13-next-btn {
          margin-top: 20px;
          background: #1c1c1c !important;
          color: #24bb24 !important;
          border: 2px solid #24bb24 !important;
          padding: 10px 20px;
          font-family: 'Courier New', monospace !important;
          cursor: pointer;
        }

        .level13-start-btn:hover,
        .level13-next-btn:hover {
          background: #24bb24 !important;
          color: #1c1c1c !important;
        }

        .level13-red-flash {
          position: fixed;
          inset: 0;
          pointer-events: none;
          z-index: 9999;
          background: rgba(255, 0, 0, 0);
        }

        .level13-red-flash.active {
          animation: level13RedFlash 0.35s ease-out 1;
        }

        @keyframes level13RedFlash {
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
        function level13EnsureFlash() {
          if (!document.getElementById('level13-red-flash-overlay')) {
            const flashElement = document.createElement('div');

            flashElement.id = 'level13-red-flash-overlay';
            flashElement.className = 'level13-red-flash';

            document.body.appendChild(flashElement);
          }
        }

        if (window.Shiny && Shiny.addCustomMessageHandler) {
          Shiny.addCustomMessageHandler(
            'level13RedFlash',
            function(message) {
              level13EnsureFlash();

              const flashElement =
                document.getElementById('level13-red-flash-overlay');

              flashElement.classList.remove('active');

              void flashElement.offsetWidth;

              flashElement.classList.add('active');
            }
          );
        }
      })();
    ")),
    
    uiOutput("level13_level_ui")
  )
}


level1_3_server <- function(input, output, session, current_page) {
  
  output$level13_console_ui <- renderUI({
    NULL
  })
  
  output$level13_next_ui <- renderUI({
    NULL
  })
  
  output$level13_level_ui <- renderUI({
    
    div(
      class = "level13-game-container",
      
      div(
        class = "level13-editor",
        
        h3("Level 1.3: Error analyseren"),
        
        p("Wat betekent deze foutmelding?"),
        
        div(
          class = "level13-warning-message",
          
          HTML(
            paste(
              "✖ System error.",
              "Module 'bootSequenceR' is missing.",
              "",
              "boot_sequence()",
              "Error: could not find function 'boot_sequence'",
              sep = "<br>"
            )
          )
        ),
        
        div(
          class = "level13-radio",
          
          radioButtons(
            inputId = "level13_q1",
            label = NULL,
            choices = c(
              "De data bestaat niet" = "A",
              "De functie komt uit een package dat niet geladen is" = "B",
              "Er zit een typefout in de code" = "C"
            )
          )
        ),
        
        actionButton(
          inputId = "level13_submit_q1",
          label = "Submit",
          class = "level13-start-btn"
        )
      ),
      
      div(
        class = "level13-console",
        
        h3("Console"),
        
        uiOutput("level13_console_ui"),
        
        uiOutput("level13_next_ui")
      )
    )
  })
  
  
  observeEvent(input$level13_submit_q1, {
    
    req(input$level13_q1)
    
    if (identical(input$level13_q1, "B")) {
      
      session$sendCustomMessage(
        "greenFlash",
        TRUE
      )
      
      output$level13_console_ui <- renderUI({
        
        div(
          class = "level13-console-message success",
          
          verbatimTextOutput(
            "level13_console_output",
            placeholder = FALSE
          )
        )
      })
      
      output$level13_console_output <- renderText({
        
        paste(
          "✔ Correct.",
          "De functie 'boot_sequence()' komt uit een package die nog niet geladen is.",
          "",
          sep = "\n"
        )
      })
      
      output$level13_next_ui <- renderUI({
        
        tagList(
          
          br(),
          
          actionButton(
            inputId = "level13_next_level1_4",
            label = "Volgende",
            class = "level13-next-btn"
          )
        )
      })
      
    } else {
      
      session$sendCustomMessage(
        "level13RedFlash",
        TRUE
      )
      
      output$level13_console_ui <- renderUI({
        
        div(
          class = "level13-console-message error",
          
          verbatimTextOutput(
            "level13_console_output",
            placeholder = FALSE
          )
        )
      })
      
      output$level13_console_output <- renderText({
        
        paste(
          "✖ Incorrect.",
          "",
          "Hint: R kan de functie op dit moment niet vinden.",
          "Denk na over wat er eerst moet gebeuren voordat je een functie uit een package kunt gebruiken.",
          sep = "\n"
        )
      })
      
      output$level13_next_ui <- renderUI({
        NULL
      })
    }
  })
  
  
  observeEvent(
    input$level13_next_level1_4,
    {
      current_page("level1_4")
    },
    ignoreInit = TRUE
  )
}