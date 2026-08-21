level4_3_ui <- function() {
  
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
          font-family: 'Courier New', monospace;
          border: 2px solid #24bb24;
          text-align: left;
        }
        
        .editor {
          background-color: #1c1c1c;
          min-height: 200px;
        }
        
        .console {
          background-color: #000000;
          min-height: 200px;
          color: #24bb24;
          white-space: pre-wrap;
        }
        
        .console-message {
          background-color: #000000 !important;
          color: #24bb24 !important;
          border: 2px solid #24bb24 !important;
          outline: none !important;
          box-shadow: none !important;
          padding: 10px;
          margin-top: 10px;
          min-height: 80px;
        }
        
        .console-message.error {
          color: #bb2424 !important;
          border-color: #bb2424 !important;
        }
        
        .console-message.success {
          color: #24bb24 !important;
          border-color: #24bb24 !important;
        }
        
        .console-message pre {
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
        
        .code-box {
          background-color: #000000;
          border: 2px solid #24bb24;
          padding: 10px;
          margin-top: 10px;
          font-family: 'Courier New', monospace;
        }
        
        .mcq {
          margin-top: 10px;
          margin-bottom: 10px;
        }
        
        input[type='radio'] {
          accent-color: #24bb24;
        }
        
        button {
          background-color: #1c1c1c;
          color: #24bb24;
          border: 2px solid #24bb24;
          padding: 8px 16px;
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
        
        .next-btn:hover {
          background-color: #24bb24;
          color: #000000;
        }
        
      "))
    ),
    
    
    div(
      class = "game-container",
      
      
      div(
        class = "editor",
        
        h3("Level 4.3: Moeten outliers worden verwijderd?"),
        
        p(
          "Opdracht: kies het beste antwoord."
        ),
        
        div(
          class = "code-box",
          
          tags$pre(
            style = "
              background-color:#000000;
              color:#24bb24;
              border:none;
              margin:0;
              padding:0;
              font-family:'Courier New', monospace;
              white-space:pre-wrap;
            ",
            
            "# Volgens de dixon.x test is er een outlier gevonden:
# ct_value = 15,4 (veel lager dan de rest)

# Wat moet je doen met deze outlier?"
          )
        ),
        
        
        div(
          class = "mcq",
          
          radioButtons(
            "choice43",
            label = NULL,
            choices = list(
              "Verwijderen - het is waarschijnlijk een meetfout." = "remove_error",
              "Behouden - het kan een echte biologische variatie zijn." = "keep_real",
              "Controleren - je moet de bron raadplegen voordat je beslist." = "check_source"
            ),
            selected = character(0)
          )
        ),
        
        
        actionButton(
          "run43",
          "▶ CHECK ANSWER"
        )
      ),
      
      
      div(
        class = "console",
        
        h3("Console"),
        
        uiOutput("console43_ui"),
        
        uiOutput("next_ui43")
      )
    )
  )
}


level4_3_server <- function(input, output, session, current_page) {
  
  output$console43_ui <- renderUI({
    NULL
  })
  
  
  output$next_ui43 <- renderUI({
    NULL
  })
  
  
  observeEvent(input$run43, {
    
    req(input$choice43)
    
    
    if (input$choice43 == "remove_error") {
      
      session$sendCustomMessage("greenFlash", TRUE)
      
      
      output$console43_ui <- renderUI({
        
        div(
          class = "console-message success",
          
          verbatimTextOutput(
            "console43",
            placeholder = FALSE
          )
        )
      })
      
      
      output$console43 <- renderText({
        
        paste0(
          "✔ Correct!\n",
          "Je hebt de waarden al gecontroleerd met de dixon.x test dus nu mag deze verwijderd worden."
        )
      })
      
      
      output$next_ui43 <- renderUI({
        
        actionButton(
          "next_level4_4",
          "Volgende",
          class = "next-btn"
        )
      })
      
      
    } else if (input$choice43 == "check_source") {
      
      session$sendCustomMessage("redFlash", TRUE)
      
      
      output$console43_ui <- renderUI({
        
        div(
          class = "console-message error",
          
          verbatimTextOutput(
            "console43",
            placeholder = FALSE
          )
        )
      })
      
      
      output$console43 <- renderText({
        
        paste0(
          "✘ Niet helemaal.\n",
          "Het controleren van de waarden heb je al gedaan, dit is dus niet meer nodig."
        )
      })
      
      
      output$next_ui43 <- renderUI({
        NULL
      })
      
      
    } else if (input$choice43 == "keep_real") {
      
      session$sendCustomMessage("redFlash", TRUE)
      
      
      output$console43_ui <- renderUI({
        
        div(
          class = "console-message error",
          
          verbatimTextOutput(
            "console43",
            placeholder = FALSE
          )
        )
      })
      
      
      output$console43 <- renderText({
        
        paste0(
          "✘ Niet helemaal.\n",
          "Je hebt met de dixon.x test al aangetoond dat het geen biologische variatie kan zijn."
        )
      })
      
      
      output$next_ui43 <- renderUI({
        NULL
      })
    }
  })
  
  
  observeEvent(input$next_level4_4, {
    
    current_page("level4_4")
    
  })
}