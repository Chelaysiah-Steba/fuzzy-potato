virus_dataset <- data.frame(
  virus = c(
    "Livo-01", "CrimsonFlu", "Sperion Spore", "Remnox-5", "Siah-V Complex",
    "Subel-X", "SilentMoth", "Avron Pathogen", "Solaris-7", "HollowFang"
  ),
  mean_onset_days = c(
    3.2, 1.8, 5.6, 2.4, 4.1,
    6.3, 7.8, 3.9, 2.1, 5.0
  ),
  sd_onset_days = c(
    0.8, 0.5, 1.2, 0.6, 1.0,
    1.4, 1.9, 0.7, 0.4, 1.1
  )
)

tsv_question <- list(
  id = "tsv_choice",
  type = "dropdown",
  prompt = "virus_dataset <- read.tsv( ... )",
  options = c(
    "\"virus.tsv\"" = "\"virus.tsv\"",
    "virus" = "virus",
    "virus.tsv" = "virus.tsv",
    "\"data/virus.tsv\"" = "\"data/virus.tsv\""
  ),
  answer = "\"virus.tsv\""
)

level2_1_ui <- function() {
  
  question <- render_question(tsv_question)
  
  fluidPage(
    
    useShinyjs(),
    
    tags$head(
      tags$style(HTML("
        
        body{
          background-color:#1c1c1c;
          color:#24bb24;
          font-family:'Courier New', monospace;
        }
        
        .game-container{
          display:flex;
          gap:20px;
          margin-top:20px;
        }
        
        .editor,
        .console{
          width:50%;
          padding:15px;
          font-family:'Courier New', monospace;
          border:2px solid #24bb24;
          text-align:left;
        }
        
        .editor{
          background-color:#1c1c1c;
          min-height:200px;
        }
        
        .console{
          background-color:#000000;
          min-height:200px;
          white-space:pre-wrap;
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
          font-family:'Courier New', monospace !important;
          white-space:pre-wrap !important;
        }
        
        select,
        .form-control,
        .selectize-input,
        .selectize-control.single .selectize-input,
        .selectize-dropdown,
        .selectize-dropdown .option,
        .selectize-input.full{
          background-color:#1c1c1c !important;
          color:#24bb24 !important;
          border:2px solid #24bb24 !important;
          font-family:'Courier New', monospace !important;
        }
        
        .selectize-input input{
          color:#24bb24 !important;
        }
        
        .selectize-dropdown-content{
          background-color:#1c1c1c !important;
        }
        
        .selectize-dropdown .option{
          background-color:#1c1c1c !important;
          color:#24bb24 !important;
        }
        
        .selectize-dropdown .active{
          background-color:#24bb24 !important;
          color:#000000 !important;
        }
        
        .selectize-control.single .selectize-input:after{
          border-top-color:#24bb24 !important;
        }
        
        button,
        .btn,
        #submit_tsv{
          background-color:#1c1c1c;
          color:#24bb24;
          border:2px solid #24bb24;
          padding:10px 20px;
          cursor:pointer;
          font-family:'Courier New', monospace;
        }
        
        button:hover,
        .btn:hover,
        #submit_tsv:hover{
          background-color:#24bb24;
          color:#000000;
        }
        
        .next-btn{
          margin-top:20px;
          background:#1c1c1c;
          color:#24bb24;
          border:2px solid #24bb24;
          padding:10px 20px;
          font-family:'Courier New', monospace;
          cursor:pointer;
        }
        
        .next-btn:hover{
          background-color:#24bb24;
          color:#000000;
        }
        
      "))
    ),
    
    div(
      class = "game-container",
      
      div(
        class = "editor",
        
        h3("Level 2.1: Load the Virus Dataset"),
        
        p("Gebruik de juiste functie om het bestand virus.tsv te laden."),
        
        p("Kies wat er tussen de haakjes moet staan:"),
        
        question$ui,
        
        actionButton(
          "submit_tsv",
          "▶ RUN CODE"
        )
      ),
      
      div(
        class = "console",
        
        h3("Console"),
        
        uiOutput("tsv_console_ui"),
        
        br(),
        
        uiOutput("virus_table")
      )
    )
  )
}

level2_1_server <- function(input, output, session, current_page) {
  
  question <- render_question(tsv_question)
  
  output$tsv_console_ui <- renderUI({
    NULL
  })
  
  observeEvent(input$submit_tsv, {
    
    if (question$check(input)) {
      
      session$sendCustomMessage("greenFlash", TRUE)
      
      output$tsv_console_ui <- renderUI({
        
        div(
          class = "console-message success",
          
          verbatimTextOutput(
            "tsv_console",
            placeholder = FALSE
          )
        )
      })
      
      output$tsv_console <- renderText({
        
        paste(
          "✔ Correct!",
          "",
          "Het bestand virus.tsv is succesvol geladen.",
          "",
          "De dataset is beschikbaar voor analyse.",
          sep = "\n"
        )
      })
      
      output$virus_table <- renderUI({
        
        tagList(
          
          h3("Geladen dataset"),
          
          tableOutput("virus_table_data"),
          
          br(),
          
          actionButton(
            "next_level2_2",
            "Volgende",
            class = "next-btn"
          )
        )
      })
      
      output$virus_table_data <- renderTable({
        virus_dataset
      })
      
    } else {
      
      session$sendCustomMessage("redFlash", TRUE)
      
      output$virus_table <- renderUI(NULL)
      
      output$tsv_console_ui <- renderUI({
        
        div(
          class = "console-message error",
          
          verbatimTextOutput(
            "tsv_console",
            placeholder = FALSE
          )
        )
      })
      
      output$tsv_console <- renderText({
        
        paste(
          "✖ Fout.",
          "",
          "Hint: Bestandsnamen zijn tekst.",
          "Gebruik daarom aanhalingstekens én de .tsv-extensie.",
          sep = "\n"
        )
      })
    }
  })
  
  observeEvent(input$next_level2_2, {
    current_page("level2_2")
  })
}