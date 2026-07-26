dna_ct_clean <- data.frame(
  log10_concentration = c(1.2, 1.5, 1.8, 2.0, 2.3, 2.6, 2.9, 3.1, 3.4, 3.7),
  ct_value = c(33.1, 31.8, 30.2, 29.0, 27.5, 26.1, 24.8, 23.9, 22.4, 21.0)
)

level4_5_ui <- function() {
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
        h3("Level 4.5: Voeg een regressielijn toe"),
        p("Opdracht: kies de juiste regressielijn-functie."),
        div(
          class = "code-box",
          HTML("model <- lm(ct_value ~ log10_concentration, data = dna_ct_clean)\n"),
          HTML("intercept <- round(coef(model)[1], 3)\n"),
          HTML("slope <- round(coef(model)[2], 3)\n"),
          HTML("r2 <- round(summary(model)$r.squared, 3)\n\n"),
          HTML("ggplot(dna_ct_clean, aes(x = log10_concentration, y = ct_value)) +\n"),
          HTML("  geom_point() +\n"),
          selectInput(
            "reg_choice",
            NULL,
            choices = c(
              "geom_smooth(method = 'lm')" = "lm",
              "geom_smooth(method = 'loess')" = "loess",
              "geom_smooth()" = "auto"
            ),
            width = "260px",
            selectize = FALSE
          ),
          HTML("\n  labs(\n"),
          HTML("    subtitle = paste0(\n"),
          HTML("      \"ct_value = \", intercept, \" + \", slope, \" × log10_concentration\\n\",\n"),
          HTML("      \"R² = \", r2\n"),
          HTML("    )\n"),
          HTML("  ) +\n"),
          HTML("  theme_minimal()")
        ),
        actionButton("run45", "▶ RUN CODE")
      ),
      div(
        class = "console",
        h3("Console"),
        verbatimTextOutput("console45"),
        plotOutput("plot45", height = "300px"),
        uiOutput("next_ui45")
      )
    )
  )
}

level4_5_server <- function(input, output, session, current_page) {
  observeEvent(input$run45, {
    req(input$reg_choice)
    
    if (input$reg_choice == "lm") {
      session$sendCustomMessage("greenFlash", TRUE)
      
      model <- lm(ct_value ~ log10_concentration, data = dna_ct_clean)
      intercept <- round(coef(model)[1], 3)
      slope <- round(coef(model)[2], 3)
      r2 <- round(summary(model)$r.squared, 3)
      
      subtitle_text <- paste0(
        "ct_value = ", intercept, " + ", slope, " × log10_concentration\n",
        "R² = ", r2
      )
      
      output$console45 <- renderText(paste0(
        "✔ Correct!\nRegressielijn toegevoegd met method = 'lm'.\n\n",
        "Formule:\n", subtitle_text
      ))
      
      output$plot45 <- renderPlot({
        ggplot(dna_ct_clean, aes(log10_concentration, ct_value)) +
          geom_point(color = "#00FF00", size = 3) +
          geom_smooth(method = "lm", color = "#00FF00") +
          labs(subtitle = subtitle_text) +
          theme_minimal(base_family = "Courier New") +
          theme(
            plot.background = element_rect(fill = "black"),
            panel.background = element_rect(fill = "black"),
            text = element_text(color = "#00FF00"),
            axis.text = element_text(color = "#00FF00"),
            plot.subtitle = element_text(color = "#00FF00", size = 18, face = "bold", margin = margin(t = 10, b = 10))
          )
      })
      
      output$next_ui45 <- renderUI({
        actionButton("next_transition4_5", "Volgende", class = "next-btn")
      })
      
    } else {
      session$sendCustomMessage("redFlash", TRUE)
      output$console45 <- renderText(
        "✘ Fout.\nKies de juiste regressielijn.\n\nHint: gebruik geom_smooth(method = 'lm') voor een lineaire regressie."
      )
      output$plot45 <- renderPlot(NULL)
      output$next_ui45 <- renderUI(NULL)
    }
  })
  
  observeEvent(input$next_transition4_5, {
    current_page("transition4_5")
  })
}