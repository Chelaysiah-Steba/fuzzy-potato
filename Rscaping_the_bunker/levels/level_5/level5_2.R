antiviral_effectiveness <- data.frame(
  virus = c(
    "Livo-01", "CrimsonFlu", "Sperion Spore", "Remnox-05", "Siah-V Complex",
    "Subel-X", "SilentMoth", "Avron Pathogen", "Solaris-7", "HollowFang"
  ),
  antiviral_class = c(
    "Protease Inhibitor", "RNA Polymerase Blocker", "Fusion Inhibitor",
    "Capsid Destabilizer", "RNA Polymerase Blocker",
    "Protease Inhibitor", "Fusion Inhibitor", "Capsid Destabilizer",
    "RNA Polymerase Blocker", "Protease Inhibitor"
  ),
  concentration_required_mg = c(
    120, 90, 140, 80, 110,
    125, 160, 150, 95, 130
  )
)


level5_2_ui <- function() {
  
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
        }
        
        .editor {
          background-color: #1c1c1c;
        }
        
        .console {
          background-color: #000000;
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
          min-height: 120px;
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
        
        .inline-input {
          display: inline-block;
          width: 200px;
          background-color: #000000;
          color: #24bb24;
          border: 2px solid #24bb24;
          font-family: 'Courier New', monospace;
          margin-left: 5px;
        }
        
        .r-output-container {
          background-color: #000000 !important;
          border: 2px solid #24bb24 !important;
          outline: none !important;
          box-shadow: none !important;
          padding: 10px;
          margin-top: 10px;
          max-height: 250px;
          overflow-y: auto;
          overflow-x: auto;
        }
        
        .r-output {
          color: #24bb24 !important;
          background-color: #000000 !important;
          border: none !important;
          outline: none !important;
          box-shadow: none !important;
          font-family: 'Courier New', monospace !important;
          font-size: 14px !important;
          line-height: 1.4 !important;
          white-space: pre !important;
          margin: 0 !important;
          padding: 0 !important;
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
        
        #run_level52 {
          margin-top: 20px;
          background-color: #1c1c1c;
          color: #24bb24;
          border: 2px solid #24bb24;
          padding: 10px 20px;
          font-family: 'Courier New', monospace;
          cursor: pointer;
        }
        
        #run_level52:hover {
          background-color: #24bb24;
          color: #000000;
        }
        
      "))
    ),
    
    
    div(
      class = "game-container",
      
      div(
        class = "editor",
        
        h3("Level 5.2: Unieke antivirale klassen tellen"),
        
        p(
          "Gebruik distinct() en count() om te bepalen hoeveel unieke antivirale klassen er zijn."
        ),
        
        p("Vul de ontbrekende functies in:"),
        
        div(
          class = "code-box",
          
          HTML("antiviral_effectiveness |> "),
          
          tags$input(
            id = "distinct_input",
            type = "text",
            class = "inline-input",
            placeholder = F
          ),
          
          HTML("(antiviral_class) |> "),
          
          tags$input(
            id = "count_input",
            type = "text",
            class = "inline-input",
            placeholder = F
          ),
          
          HTML("(antiviral_class)")
        ),
        
        actionButton(
          "run_level52",
          "▶ RUN CODE"
        )
      ),
      
      
      div(
        class = "console",
        
        h3("Console"),
        
        uiOutput("console52_ui"),
        
        br(),
        
        uiOutput("result52_ui"),
        
        uiOutput("next_ui52")
      )
    )
  )
}


level5_2_server <- function(input, output, session, current_page) {
  
  output$console52_ui <- renderUI({
    NULL
  })
  
  output$result52_ui <- renderUI({
    NULL
  })
  
  
  observeEvent(input$run_level52, {
    
    req(
      input$distinct_input,
      input$count_input
    )
    
    
    correct_answer <- (
      trimws(input$distinct_input) == "distinct" &&
        trimws(input$count_input) == "count"
    )
    
    
    if (correct_answer) {
      
      session$sendCustomMessage("greenFlash", TRUE)
      
      
      output$console52_ui <- renderUI({
        
        div(
          class = "console-message success",
          
          verbatimTextOutput(
            "console52",
            placeholder = FALSE
          )
        )
      })
      
      
      output$console52 <- renderText({
        
        paste0(
          "✔ Correct!\n",
          "Je hebt de unieke antivirale klassen geteld."
        )
      })
      
      
      output$result52_ui <- renderUI({
        
        div(
          class = "r-output-container",
          
          tags$pre(
            class = "r-output",
            
            HTML(
              paste0(
                "# A tibble: 4 × 2\n",
                "  antiviral_class             n\n",
                "  &lt;chr&gt;                      &lt;int&gt;\n",
                "1 Capsid Destabilizer          2\n",
                "2 Fusion Inhibitor             2\n",
                "3 Protease Inhibitor           3\n",
                "4 RNA Polymerase Blocker       3"
              )
            )
          )
        )
      })
      
      
      output$next_ui52 <- renderUI({
        
        actionButton(
          "next_level5_3",
          "Volgende",
          class = "next-btn"
        )
      })
      
      
    } else {
      
      session$sendCustomMessage("redFlash", TRUE)
      
      
      output$result52_ui <- renderUI({
        NULL
      })
      
      
      output$console52_ui <- renderUI({
        
        div(
          class = "console-message error",
          
          verbatimTextOutput(
            "console52",
            placeholder = FALSE
          )
        )
      })
      
      
      output$console52 <- renderText({
        
        paste0(
          "✖ Fout.\n",
          "Je typte:\n",
          "distinct(): ", input$distinct_input, "\n",
          "count(): ", input$count_input, "\n\n",
          "Hint: beide functies bestaan in dplyr en hebben geen aanhalingstekens nodig."
        )
      })
      
      
      output$next_ui52 <- renderUI({
        NULL
      })
    }
  })
  
  
  observeEvent(input$next_level5_3, {
    current_page("level5_3")
  })
}