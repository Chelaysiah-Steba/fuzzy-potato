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
      "⚠️ Start Level 1.2: Error analyseren",
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
          
          h2("Resultaat"),
          
          div(class = "game-container",
              
              div(class = "editor",
                  verbatimTextOutput("code_block")
              ),
              
              div(class = "console",
                  textOutput("console_output")
              )
          ),
          
          br(),
          
          radioButtons("q1", "Wat betekent deze foutmelding?",
                       choices = c(
                         "De data bestaat niet",
                         "De functie komt uit een package dat niet geladen is",
                         "Er zit een typefout in de code"
                       )),
          
          actionButton("submit_q1", "Submit")
      )
    })
    
    # Foutmelding tonen
    output$code_block <- renderText({
      "boot_sequence()\n\nError: could not find function 'boot_sequence'"
    })
    
    output$console_output <- renderText({
      paste0(
        "✖ System error.\n",
        "Module 'bootSequenceR' is missing."
      )
    })
  })
  
  observeEvent(input$submit_q1, {
    req(input$q1)
    
    if (input$q1 == "De functie komt uit een package dat niet geladen is") {
      showNotification("✔ Correct!", type = "message")
      session$sendCustomMessage("confetti", TRUE)
    } else {
      showNotification("✖ Incorrect. Probeer opnieuw.", type = "error")
    }
  })
}

shinyApp(ui, server)
