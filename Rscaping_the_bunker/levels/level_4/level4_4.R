dna_ct_clean <- data.frame(
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
    31.8, 31.8, NA,
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

level4_4_ui <- function() {
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
        input {
          width: 140px;
          background-color: #000000;
          color: #00FF00;
          border: 2px solid #00FF00;
          margin: 0 3px;
          height: 26px;
          font-family: 'Courier New', monospace;
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
        h3("Level 4.4: Maak een scatterplot van de opgeschoonde dataset"),
        p("Opdracht: vul alle velden correct in."),
        div(
          class = "code-box",
          HTML("dna_ct_clean |>\n"),
          br(),
          HTML("summarise(\n"),
          br(),
          HTML("mean = mean(ct_value)\n"),
          br(),
          HTML("sd = sd(ct_value, na.rm = FALSE)) |> \n"),
          br(),
          HTML("ggplot(dna_ct_clean, aes(x = "),
          tags$input(id = "x_input44", type = "text", placeholder = "log10_concentration"),
          HTML(", y = "),
          tags$input(id = "y_input44", type = "text", placeholder = "ct_value"),
          HTML(")) + "),
          selectInput(
            "geom_choice44",
            NULL,
            choices = c("geom_point()" = "geom_point()", "geom_line()" = "geom_line()", "geom_bar()" = "geom_bar()"),
            width = "160px",
            selectize = FALSE
          ),
          HTML(" + theme_minimal()")
        ),
        actionButton("run44", "▶ RUN CODE")
      ),
      div(
        class = "console",
        h3("Console"),
        verbatimTextOutput("console44"),
        plotOutput("plot44", height = "300px"),
        uiOutput("next_ui44")
      )
    )
  )
}

level4_4_server <- function(input, output, session, current_page) {
  observeEvent(input$run44, {
    req(input$x_input44, input$y_input44, input$geom_choice44)
    
    correct_x <- input$x_input44 == "log10_concentration"
    correct_y <- input$y_input44 == "ct_value"
    correct_geom <- input$geom_choice44 == "geom_point()"
    
    if (correct_x && correct_y && correct_geom) {
      session$sendCustomMessage("greenFlash", TRUE)
      output$console44 <- renderText(paste0(
        "✔ Correct!\nScatterplot gemaakt met opgeschoonde dataset.\n\n",
        "Volledige code:\n",
        "ggplot(dna_ct_clean, aes(x = log10_concentration, y = ct_value)) +\n",
        "  geom_point() +\n",
        "  theme_minimal()"
      ))
      output$plot44 <- renderPlot({
        stats <- dna_ct_clean |>
          group_by(log10_concentration) |>
          summarise(
            mean = mean(ct_value, na.rm = TRUE),
            sd = sd(ct_value, na.rm = TRUE)
          )
        ggplot(stats, aes(x = log10_concentration, y = mean)) +
          geom_errorbar(aes(ymin = mean - sd, ymax = mean + sd), color = "#FF5CAD", width = 0.12, linewidth = 1.2) +
          geom_point(color = "#00FF00", size = 4) +
          theme_minimal(base_family = "Courier New") +
          theme(
            plot.background = element_rect(fill = "black"),
            panel.background = element_rect(fill = "black"),
            text = element_text(color = "#00FF00"),
            axis.text = element_text(color = "#00FF00")
          )
      })
      output$next_ui44 <- renderUI({
        actionButton("next_level4_5", "Volgende", class = "next-btn")
      })
    } else {
      session$sendCustomMessage("redFlash", TRUE)
      output$console44 <- renderText(paste0(
        "✘ Fout.\nAlle drie velden moeten correct zijn.\n\n",
        "Hints:\n",
        "X = log10_concentration\n",
        "Y = ct_value\n",
        "Gebruik geom_point() voor een scatterplot."
      ))
      output$plot44 <- renderPlot(NULL)
      output$next_ui44 <- renderUI(NULL)
    }
  })
  
  observeEvent(input$next_level4_5, {
    current_page("level4_5")
  })
}