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
select {
background-color: #000000;
color: #00FF00;
border: 2px solid #00FF00;
margin-left: 3px;
height: 30px;
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
        h3("Level 4.2: Detecteer outliers"),
        p("Opdracht: kies de juiste combinatie."),
        div(
          class = "code-box",
          HTML("library(\n"),
          tags$input(id = "library_input", type = "text", class = "inline-input"),
          HTML(")\n"),
          br(), br(),
          HTML("dna_ct_outlier <- dna_ct_dataset_outlier |> filter(log10_concentration == 1.50)\n"),
          br(), br(),
          tags$span(
            style = "display: inline-flex; align-items: center; gap: 6px;",
            div(
              style = "display: inline-block;",
              selectInput(
                "operator",
                NULL,
                choices = c("dixon.test", "outlier.check", "dixon.q", "pwr.t.test"),
                width = "150px",
                selectize = FALSE
              )
            ),
            HTML("(dna_ct_outlier$ct_value)")
          )
        ),
        actionButton("run42", "▶ RUN CODE")
      ),
      div(
        class = "console",
        h3("Console"),
        verbatimTextOutput("console42"),
        uiOutput("result42"),
        uiOutput("next_ui42")
      )
    )
  )
}

level4_2_server <- function(input, output, session, current_page) {
  observeEvent(input$run42, {
    correct <- (input$library_input == "outliers" && input$operator == "dixon.test")
    
    if (correct) {
      session$sendCustomMessage("greenFlash", TRUE)
      output$console42 <- renderText(paste0(
        "## \n",
        "## Dixon test for outliers\n",
        "## \n",
        "## data: dna_ct_outlier$ct_value\n",
        "## Q = 1, p-value < 2.2e-16\n",
        "## alternative hypothesis: lowest value 15.4 is an outlier\n"
      ))
      output$next_ui42 <- renderUI({
        actionButton("next_level4_3", "Volgende", class = "next-btn")
      })
    } else {
      session$sendCustomMessage("redFlash", TRUE)
      output$console42 <- renderText(
        paste0(
          "✖ Fout.\nKies de juiste combinatie.\n\n",
          "Hints:\n",
          "> upper_bound → hoge outliers\n",
          "< lower_bound → lage outliers"
        )
      )
      output$result42 <- renderUI({ NULL })
      output$next_ui42 <- renderUI({ NULL })
    }
  })
  
  observeEvent(input$next_level4_3, {
    current_page("level4_3")
  })
}