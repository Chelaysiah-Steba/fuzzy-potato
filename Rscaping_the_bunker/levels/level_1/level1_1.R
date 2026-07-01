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
      .code-box {
        background-color: #000000;
        border: 2px solid #00FF00;
        padding: 10px;
        margin-top: 10px;
      }
      .inline-input {
        display: inline-block;
        width: 200px;
        background-color: #000000;
        color: #00FF00;
        border: 2px solid #00FF00;
        font-family: 'Courier New', monospace;
        margin-left: 5px;
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
      "🦠 Start Level 1: Detecteer geïnfecteerde sectoren",
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
          
          h2("Opdracht"),
          p("Run the code to start the system."),
          
          div(class = "game-container",
              
              div(class = "editor",
                  h3("🦠 Level 1: System Boot"),
                  p("Run the code to initialize the system."),
                  
                  div(class = "code-box",
                      HTML("boot_sequence()")
                  ),
                  
                  actionButton("run_code", "▶ RUN CODE")
              ),
              
              div(class = "console",
                  h3("Console"),
                  verbatimTextOutput("console_output"),
                  br(),
                  uiOutput("sector_table")
              )
          )
      )
    })
  })
  
  observeEvent(input$run_code, {
    
    output$sector_table <- renderUI({ NULL })
    
    output$console_output <- renderText({
      paste0(
        "✖ System error.\n",
        "Module 'bootSequenceR' is missing.\n\n",
        
      )
    })
  })
}


shinyApp(ui, server)
