dna_ct_clean <- data.frame(
  log10_concentration = c(1.2, 1.5, 1.8, 2.0, 2.3, 2.6, 2.9, 3.1, 3.4, 3.7),
  ct_value = c(33.1, 31.8, 30.2, 29.0, 27.5, 26.1, 24.8, 23.9, 22.4, 21.0)
)


level4_6_ui <- function() {
  
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
        }
        
        .next-btn,
        .retry-btn {
          margin-top: 20px;
          background: #1c1c1c;
          color: #24bb24;
          border: 2px solid #24bb24;
          padding: 10px 20px;
          font-family: 'Courier New', monospace;
          cursor: pointer;
        }
        
        .next-btn:hover,
        .retry-btn:hover {
          background-color: #24bb24;
          color: #000000;
        }
        
        #run46 {
          margin-top: 20px;
          background-color: #1c1c1c;
          color: #24bb24;
          border: 2px solid #24bb24;
          padding: 10px 20px;
          font-family: 'Courier New', monospace;
          cursor: pointer;
        }
        
        #run46:hover {
          background-color: #24bb24;
          color: #000000;
        }
        
        input {
          background-color: #000000 !important;
          color: #24bb24 !important;
          border: 2px solid #24bb24 !important;
          font-family: 'Courier New', monospace !important;
        }
        
      "))
    ),
    
    div(
      class = "game-container",
      
      div(
        class = "editor",
        
        h3("Level 4.6: Bereken de log10-concentratie"),
        
        p(
          "Het vrijgekomen virus heeft een CT-waarde van:"
        ),
        
        h3("CT = 30.6"),
        
        p(
          "Gebruik de formule om de log10-concentratie te berekenen \n(gebruik hiervoor R of een rekenmachine):"
        ),
        
        div(
          class = "code-box",
          HTML("CT-value = 38.886 - 4.859 × log10_concentration")
        ),
        
        p(
          "Vul hieronder de berekende log10-concentratie in \n(gebruik . als decimaalscheider:"
        ),
        
        textInput(
          "log_input",
          label = NULL,
          placeholder = F
        ),
        
        actionButton(
          "run46",
          "▶ RUN CODE"
        )
      ),
      
      
      div(
        class = "console",
        
        h3("Console"),
        
        uiOutput("console46_ui"),
        
        uiOutput("next_ui46")
      )
    )
  )
}


level4_6_server <- function(input, output, session, current_page) {
  
  output$console46_ui <- renderUI({
    NULL
  })
  
  
  output$next_ui46 <- renderUI({
    NULL
  })
  
  
  observeEvent(input$run46, {
    
    req(input$log_input)
    
    
    ct_value <- 30.6
    intercept <- 38.886
    slope <- -4.859
    
    correct_log10 <- (ct_value - intercept) / slope
    
    student <- suppressWarnings(as.numeric(input$log_input))
    
    
    if (!is.na(student) && abs(student - correct_log10) < 0.05) {
      
      session$sendCustomMessage("greenFlash", TRUE)
      
      
      output$console46_ui <- renderUI({
        
        div(
          class = "console-message success",
          
          verbatimTextOutput(
            "console46",
            placeholder = FALSE
          )
        )
      })
      
      
      output$console46 <- renderText({
        
        paste0(
          "✔ Correct!\n",
          "De berekende log10-concentratie is: ",
          round(correct_log10, 3)
        )
      })
      
      
      output$next_ui46 <- renderUI({
        
        actionButton(
          "next_level4_7",
          "Volgende",
          class = "next-btn"
        )
      })
      
      
    } else {
      
      session$sendCustomMessage("redFlash", TRUE)
      
      
      output$next_ui46 <- renderUI({
        NULL
      })
      
      
      output$console46_ui <- renderUI({
        
        div(
          class = "console-message error",
          
          verbatimTextOutput(
            "console46",
            placeholder = FALSE
          )
        )
      })
      
      
      output$console46 <- renderText({
        
        paste0(
          "✖ Fout.\n",
          "Je invoer: ",
          input$log_input,
          "\n\n",
          "Hint: los op:\n",
          "log10_concentration = (CT - 38.886) / -4.859"
        )
      })
    }
  })
  
  
  observeEvent(input$next_level4_7, {
    
    current_page("level4_7")
    
  })
}