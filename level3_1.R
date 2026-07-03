level1_1_ui <- function() {
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

.next-btn{
margin-top:20px;
background:#1c1c1c;
color:#00FF00;
border:2px solid #00FF00;
padding:10px 20px;
font-family:'Courier New';
cursor:pointer;
}
"))
    ),
    
    div(
      class = "game-container",
      
      div(
        class = "editor",
        
        h3("Level 1: System Boot"),
        
        p("Run de code om het systeem op te starten."),
        
        div(
          class = "code-box",
          HTML("boot_sequence()")
        ),
        
        actionButton("run_code", "▶ RUN CODE")
      ),
      
      div(
        class = "console",
        
        h3("Console"),
        
        verbatimTextOutput("console_output"),
        
        br(),
        
        uiOutput("sector_table")
      )
    )
  ) }

level1_1_server <- function(input, output, session, current_page) {
  
  output$console_output <- renderText({
    ""
  })
  
  output$sector_table <- renderUI({
    NULL
  })
  
  observeEvent(input$run_code, {
    
    output$sector_table <- renderUI({
      tagList(
        actionButton("next_level1_2", "Volgende", class = "next-btn")
      )
    })
    
    output$console_output <- renderText({
      
      paste0(
        "✖ System error.\n",
        "Module 'bootSequenceR' is missing.\n\n"
      )
      
    })
    
  })
  
  observeEvent(input$next_level1_2, {
    current_page("level1_2")
  })
  
}