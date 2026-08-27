dna_ct_dataset_outlier <- data.frame(
  log10_concentration = c(
    rep(1.2, 3),
    rep(1.5, 3),
    rep(1.8, 3),
    rep(2.0, 3),
    rep(2.3, 3),
    rep(2.6, 3),
    rep(2.9, 3),
    rep(3.1, 3),
    rep(3.4, 3),
    rep(3.7, 3)
  ),
  repeats = rep(1:3, 10),
  ct_value = c(
    33.1, 33.2, 33.0,
    31.8, 31.8, 15.4,
    30.2, 30.0, 30.4,
    29.0, 30.3, 28.0,
    27.5, 27.3, 27.2,
    26.1, 26.5, 26.0,
    24.8, 24.5, 24.6,
    23.9, 23.6, 24.0,
    22.4, 22.5, 22.4,
    21.0, 20.8, 21.9
  )
)

level4_2_ui <- function() {
  
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
        
        .inline-input {
          display: inline-block;
          width: 220px;
          background-color: #000000;
          color: #24bb24;
          border: 2px solid #24bb24;
          font-family: 'Courier New', monospace;
        }
        
        input {
          background-color: #000000 !important;
          color: #24bb24 !important;
          border: 2px solid #24bb24 !important;
          font-family: 'Courier New', monospace !important;
        }
        
        select,
        .form-control {
          background-color: #000000 !important;
          color: #24bb24 !important;
          border: 2px solid #24bb24 !important;
          font-family: 'Courier New', monospace !important;
        }
        
        select option {
          background-color: #000000 !important;
          color: #24bb24 !important;
        }
        
        select:focus,
        .form-control:focus {
          background-color: #000000 !important;
          color: #24bb24 !important;
          border-color: #24bb24 !important;
          outline: none !important;
          box-shadow: none !important;
        }
        
        .shiny-input-container select {
          background-color: #000000 !important;
          color: #24bb24 !important;
        }
        
        .shiny-input-container select option {
          background-color: #000000 !important;
          color: #24bb24 !important;
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
        
        #run42 {
          margin-top: 20px;
          background-color: #1c1c1c;
          color: #24bb24;
          border: 2px solid #24bb24;
          padding: 10px 20px;
          font-family: 'Courier New', monospace;
          cursor: pointer;
        }
        
        #run42:hover {
          background-color: #24bb24;
          color: #000000;
        }
      "))
    ),
    
    div(
      class = "game-container",
      
      div(
        class = "editor",
        
        h3("Level 4.2: Detecteer outliers"),
        
        p(
          "Laad de juiste library en kies de juiste functie om te testen of de waarde 15.4 een outlier is."
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
            "library("
          ),
          
          tags$input(
            id = "library_input",
            type = "text",
            class = "inline-input",
            placeholder = F
          ),
          
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
            ")

dna_ct_outlier <- dna_ct_dataset_outlier |>
  filter(log10_concentration == 1.50)"
          ),
          
          selectInput(
            "operator",
            NULL,
            choices = c(
              "dixon.test" = "dixon.test",
              "outlier.check" = "outlier.check",
              "dixon.q" = "dixon.q",
              "pwr.t.test" = "pwr.t.test"
            ),
            width = "220px",
            selectize = FALSE
          ),
          
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
            "(dna_ct_outlier$ct_value)"
          )
        ),
        
        actionButton(
          "run42",
          "▶ RUN CODE"
        )
      ),
      
      div(
        class = "console",
        
        h3("Console"),
        
        uiOutput("console42_ui"),
        
        uiOutput("result42"),
        
        uiOutput("next_ui42")
      )
    )
  )
}

level4_2_server <- function(input, output, session, current_page) {
  
  output$console42_ui <- renderUI({
    NULL
  })
  
  output$result42 <- renderUI({
    NULL
  })
  
  output$next_ui42 <- renderUI({
    NULL
  })
  
  observeEvent(input$run42, {
    
    library_answer <- tolower(trimws(input$library_input))
    operator_answer <- input$operator
    
    correct_library <- library_answer == "outliers"
    correct_operator <- operator_answer == "dixon.test"
    
    if (correct_library && correct_operator) {
      
      session$sendCustomMessage("greenFlash", TRUE)
      
      output$console42_ui <- renderUI({
        
        div(
          class = "console-message success",
          
          verbatimTextOutput(
            "console42",
            placeholder = FALSE
          )
        )
      })
      
      output$console42 <- renderText({
        
        paste0(
          "## \n",
          "## Dixon test for outliers\n",
          "## \n",
          "## data: dna_ct_outlier$ct_value\n",
          "## Q = 1, p-value < 2.2e-16\n",
          "## alternative hypothesis: lowest value 15.4 is an outlier\n"
        )
      })
      
      output$result42 <- renderUI({
        NULL
      })
      
      output$next_ui42 <- renderUI({
        
        actionButton(
          "next_level4_3",
          "Volgende",
          class = "next-btn"
        )
      })
      
    } else {
      
      session$sendCustomMessage("redFlash", TRUE)
      
      # Bepaal welke onderdelen fout zijn, zonder het concrete antwoord weg te geven.
      hint <- ""
      
      if (!correct_library && !correct_operator) {
        
        hint <- paste(
          "De library én de functie zijn nog niet juist.",
          "",
          "Library-hint:",
          "Zoek een package dat specifiek bedoeld is voor het opsporen van uitschieters in data.",
          "",
          "Functie-hint:",
          "Je hebt hier een toets nodig die kijkt of één extreme waarde afwijkt binnen een kleine reeks herhaalde metingen.",
          sep = "\n"
        )
        
      } else if (!correct_library) {
        
        hint <- paste(
          "De gekozen testfunctie klopt, maar de library nog niet.",
          "",
          "Hint:",
          "Zoek een package dat functies bevat voor het herkennen en testen van uitschieters.",
          sep = "\n"
        )
        
      } else if (!correct_operator) {
        
        hint <- paste(
          "De library klopt, maar de gekozen functie nog niet.",
          "",
          "Hint:",
          "Kies een functie voor een formele toets op één mogelijke uitschieter binnen een kleine steekproef.",
          sep = "\n"
        )
      }
      
      output$console42_ui <- renderUI({
        
        div(
          class = "console-message error",
          
          verbatimTextOutput(
            "console42",
            placeholder = FALSE
          )
        )
      })
      
      output$console42 <- renderText({
        
        paste(
          "✖ Fout.",
          "",
          hint,
          sep = "\n"
        )
      })
      
      output$result42 <- renderUI({
        NULL
      })
      
      output$next_ui42 <- renderUI({
        NULL
      })
    }
  })
  
  observeEvent(input$next_level4_3, {
    current_page("level4_3")
  })
}