level4_3_ui <- function() {
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
          gap: 10px;
          margin-top: 10px;
        }
        .editor, .console {
          width: 50%;
          padding: 10px;
          border: 2px solid #00FF00;
        }
        .editor { background-color: #1c1c1c; }
        .console { background-color: #000000; white-space: pre-wrap; }
        .code-box {
          background-color: #000000;
          border: 3px solid #00FF00;
          padding: 8px;
          margin-bottom: 5px;
          font-size: 1.05em;
          line-height: 1.1em;
        }
        .mcq {
          margin-top: 10px;
          margin-bottom: 10px;
        }
        input[type='radio'] {
          accent-color: #00FF00;
        }
        button {
          background-color: #1c1c1c;
          color: #00FF00;
          border: 2px solid #00FF00;
          padding: 8px 16px;
          cursor: pointer;
        }
        button:hover {
          background-color: #00FF00;
          color: #1c1c1c;
        }
        .next-btn {
          margin-top: 20px;
          background: #1c1c1c;
          color: #00FF00;
          border: 2px solid #00FF00;
          padding: 10px 20px;
          font-family: 'Courier New';
          cursor: pointer;
        }
      "))
    ),
    div(
      class = "game-container",
      div(
        class = "editor",
        h3("Level 4.3: Moeten outliers worden verwijderd?"),
        p("Opdracht: kies het beste antwoord."),
        div(
          class = "code-box",
          HTML("# Volgens de dixon.x test is er een outlier gevonden:\n"),
          HTML("# ct_value = 15,4 (veel lager dan de rest)\n\n"),
          HTML("# Wat moet je doen met deze outlier?")
        ),
        div(
          class = "mcq",
          radioButtons(
            "choice43",
            label = NULL,
            choices = list(
              "Verwijderen — het is waarschijnlijk een meetfout." = "remove_error",
              "Behouden — het kan een echte biologische variatie zijn." = "keep_real",
              "Controleren — je moet de bron raadplegen voordat je beslist." = "check_source"
            ),
            selected = character(0)
          )
        ),
        actionButton("run43", "▶ CHECK ANSWER")
      ),
      div(
        class = "console",
        h3("Console"),
        verbatimTextOutput("console43"),
        uiOutput("next_ui43")
      )
    )
  )
}

level4_3_server <- function(input, output, session, current_page) {
  observeEvent(input$run43, {
    req(input$choice43)
    
    if (input$choice43 == "remove_error") {
      session$sendCustomMessage("greenFlash", TRUE)
      output$console43 <- renderText(
        "✔ Correct!\nJe hebt de waarden al gecontroleerd met de dixon.x test dus nu mag deze verwijderd worden.\n"
      )
      output$next_ui43 <- renderUI({
        actionButton("next_level4_4", "Volgende", class = "next-btn")
      })
    } else if (input$choice43 == "check_source") {
      session$sendCustomMessage("redFlash", TRUE)
      output$console43 <- renderText(
        "✘ Niet helemaal.\nHet controleren van de waarden heb je al gedaan, dit is dus niet meer nodig.\n"
      )
      output$next_ui43 <- renderUI({ NULL })
    } else if (input$choice43 == "keep_real") {
      session$sendCustomMessage("redFlash", TRUE)
      output$console43 <- renderText(
        "✘ Niet helemaal.\nJe hebt met de dixon.x test al aangetoond dat het geen biologische variatie kan zijn.\n"
      )
      output$next_ui43 <- renderUI({ NULL })
    }
  })
  
  observeEvent(input$next_level4_4, {
    current_page("level4_4")
  })
}