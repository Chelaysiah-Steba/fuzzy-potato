dna_ct_clean <- data.frame(
  log10_concentration = c(1.2, 1.5, 1.8, 2.0, 2.3, 2.6, 2.9, 3.1, 3.4, 3.7),
  ct_value = c(33.1, 31.8, 30.2, 29.0, 27.5, 26.1, 24.8, 23.9, 22.4, 21.0)
)

level4_6_ui <- function() {
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
          background-color: #000000;
          color: #00FF00;
          border: 2px solid #00FF00;
          width: 200px;
          margin-left: 5px;
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
        h3("Level 4.6: Bereken de log10‑concentratie"),
        p("Het vrijgekomen virus heeft een CT‑waarde van:"),
        h3("CT = 30.6"),
        p("Gebruik de formule om de log10‑concentratie te berekenen:"),
        
        div(
          class = "code-box",
          HTML("CT-value = 38.886 - 4.859 × log10_concentration")
        ),
        
        p("Vul hieronder de berekende log10‑concentratie in:"),
        
        textInput("log_input", label = NULL, placeholder = "1.00"),
        
        actionButton("run46", "▶ RUN CODE")
      ),
      
      div(
        class = "console",
        h3("Console"),
        verbatimTextOutput("console46"),
        plotOutput("plot46", height = "300px"),
        uiOutput("next_ui46")
      )
    )
  )
}

level4_6_server <- function(input, output, session, current_page) {
  
  observeEvent(input$run46, {
    req(input$log_input)
    
    ct_value <- 30.6
    intercept <- 38.886
    slope <- -4.859
    
    correct_log10 <- (ct_value - intercept) / slope
    
    student <- suppressWarnings(as.numeric(input$log_input))
    
    # Correct
    if (!is.na(student) && abs(student - correct_log10) < 0.05) {
      
      session$sendCustomMessage("greenFlash", TRUE)
      
      output$console46 <- renderText({
        paste0(
          "✔ Correct!\n",
          "De berekende log10‑concentratie is: ", round(correct_log10, 3)
        )
      })
      
      output$plot46 <- renderPlot({
        ggplot(dna_ct_clean, aes(log10_concentration, ct_value)) +
          geom_point(color = "#00FF00", size = 3) +
          geom_smooth(method = "lm", color = "#00FF00") +
          geom_point(aes(x = correct_log10, y = ct_value), color = "red", size = 4) +
          labs(subtitle = paste0("CT = ", ct_value, " → log10(conc) = ", round(correct_log10, 3))) +
          theme_minimal(base_family = "Courier New") +
          theme(
            plot.background = element_rect(fill = "black"),
            panel.background = element_rect(fill = "black"),
            text = element_text(color = "#00FF00"),
            axis.text = element_text(color = "#00FF00"),
            plot.subtitle = element_text(color = "#00FF00", size = 18, face = "bold")
          )
      })
      
      output$next_ui46 <- renderUI({
        actionButton("next_level4_7", "Volgende", class = "next-btn")
      })
      
    } else {
      
      session$sendCustomMessage("redFlash", TRUE)
      
      output$console46 <- renderText({
        paste0(
          "✘ Fout.\nJe invoer: ", input$log_input, "\n\n",
          "Hint: los op:\n",
          "log10_concentration = (CT - 38.886) / -4.859\n"
        )
      })
      
      output$plot46 <- renderPlot(NULL)
      output$next_ui46 <- renderUI(NULL)
    }
  })
  
  observeEvent(input$next_level4_7, {
    current_page("level4_7")
  })
}