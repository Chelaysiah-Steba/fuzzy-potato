library(shiny)
library(shinyjs)

ui <- fluidPage(
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
      .inline-input {
        width: 300px;
        background-color: #000000;
        color: #00FF00;
        border: 2px solid #00FF00;
        font-family: 'Courier New', monospace;
        padding: 5px;
      }
    "))
  ),
  
  div(
    id = "start_wrapper",
    style = "
      display: flex;
      justify-content: center;
      align-items: center;
      height: 60vh;
    ",
    actionButton(
      "start_level",
      "🔧 Start Level 1.3: Package fixen",
      style = "
        font-size: 1.5em;
        padding: 20px 40px;
        background-color: #1c1c1c;
        color: #00FF00;
        border: 3px solid #00FF00;
        cursor: pointer;
        text-shadow: 0 0 5px #00FF00;
      "
    )
  ),
  
  uiOutput("game_ui")
)

server <- function(input, output, session) {
  
  observeEvent(input$start_level, {
    
    removeUI(selector = "#start_wrapper", immediate = TRUE)
    
    output$game_ui <- renderUI({
      div(class = "landing-container",
          
          h2("Nieuwe opdracht"),
          p("Laad het juiste package zodat de code werkt."),
          
          div(class = "game-container",
              
              div(class = "editor",
                  verbatimTextOutput("code_block")
              ),
              
              div(class = "console",
                  textOutput("console_output")
              )
          ),
          
          br(),
          
          textInput("fix_input", "Typ je code:", "", placeholder = "library(bootSequenceR)"),
          actionButton("run_fix", "▶ RUN CODE")
      )
    })
    
    # Foutmelding die uit Level 1.2 komt
    output$code_block <- renderText({
      "boot_sequence()\n\nError: could not find function 'boot_sequence'"
    })
    
    output$console_output <- renderText({
      "System halted. Missing module detected: 'bootSequenceR'."
    })
  })
  
  observeEvent(input$run_fix, {
    req(input$fix_input)
    
    clean <- trimws(input$fix_input)
    
    if (clean == "library(bootSequenceR)") {
      
      output$console_output <- renderText({
        "✔ Module loaded successfully.\nSystem boot restored."
      })
      
    } else {
      
      output$console_output <- renderText({
        paste0(
          "✖ Incorrect command.\nYou typed: ", clean, "\n\n",
          "Hint: Load the missing module with:\n",
          "library(bootSequenceR)"
        )
      })
    }
  })
  
}   # ← THIS was missing

shinyApp(ui, server)


shinyApp(ui, server)
