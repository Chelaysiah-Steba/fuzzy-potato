library(shiny)
library(shinyjs)
library(ggplot2)

scientists_dataset <- data.frame(
  scientist = c(
    "sci01","sci02","sci03","sci04","sci05",
    "sci06","sci07","sci08","sci09","sci10",
    "sci11","sci12","sci13","sci14","sci15",
    "sci16","sci17","sci18","sci19","sci20"
  ),
  age_years = c(
    34, 50, 41, 29, 46,
    38, 52, 44, 31, 57,
    36, 48, 40, 53, 28,
    39, 45, 32, 55, 37
  ),
  survival_days = c(
    88, 20, 77, 55, 12,
    91, 33, 67, 82, 14,
    73, 29, 95, 18, 64,
    87, 22, 79, 31, 70
  )
)

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
        border: 2px solid #00FF00;
      }
      .editor { background-color: #1c1c1c; }
      .console { background-color: #000000; white-space: pre-wrap; }
      .code-box {
        background-color: #000000;
        border: 3px solid #00FF00;
        padding: 20px;
        margin-bottom: 20px;
        white-space: pre-wrap;
      }
    "))
  ),
  
  # ---------------------------
  # START BUTTON FOR LEVEL 2.4
  # ---------------------------
  div(
    id = "start_wrapper_level24",
    style = "
      display: flex;
      justify-content: center;
      align-items: center;
      height: 60vh;
    ",
    actionButton(
      "start_level24",
      "📝 Start Level 2.4: Kies de juiste titel en labels",
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
  
  # ---------------------------
  # LOAD LEVEL 2.4
  # ---------------------------
  observeEvent(input$start_level24, {
    
    removeUI(selector = "#start_wrapper_level24", immediate = TRUE)
    
    output$game_ui <- renderUI({
      div(class = "game-container",
          
          div(class = "editor",
              h3("📝 Level 2.4: Kies de juiste titel en labels"),
              p("Kies de correcte titel, x-as label en y-as label."),
              
              div(class = "code-box",
                  HTML("ggplot(scientists_dataset, aes(age_years, survival_days)) +
  geom_point() +
  labs(
    title = "),
                  selectInput("title_choice", NULL,
                              choices = c(
                                "\"Scatterplot\"" = "\"Scatterplot\"",
                                "\"Survival vs Age\"" = "\"Survival vs Age\"",
                                "\"Age and Days\"" = "\"Age and Days\""
                              )
                  ),
                  HTML(",\n    x = "),
                  selectInput("xlabel_choice", NULL,
                              choices = c(
                                "\"Age (years)\"" = "\"Age (years)\"",
                                "\"age_years\"" = "\"age_years\"",
                                "\"Scientist Age\"" = "\"Scientist Age\""
                              )
                  ),
                  HTML(",\n    y = "),
                  selectInput("ylabel_choice", NULL,
                              choices = c(
                                "\"Survival (days)\"" = "\"Survival (days)\"",
                                "\"survival_days\"" = "\"survival_days\"",
                                "\"Days alive\"" = "\"Days alive\""
                              )
                  ),
                  HTML("\n  )")
              ),
              
              actionButton("run_level24", "▶ RUN CODE")
          ),
          
          div(class = "console",
              h3("Console"),
              verbatimTextOutput("console_level24"),
              plotOutput("plot_level24")
          )
      )
    })
  })
  
  # ---------------------------
  # CHECK ANSWERS FOR LEVEL 2.4
  # ---------------------------
  observeEvent(input$run_level24, {
    
    correct_title  <- input$title_choice  == "\"Survival vs Age\""
    correct_xlabel <- input$xlabel_choice == "\"Age (years)\""
    correct_ylabel <- input$ylabel_choice == "\"Survival (days)\""
    
    if (correct_title && correct_xlabel && correct_ylabel) {
      
      output$console_level24 <- renderText({
        "✔ Correct! Je hebt de juiste titel en labels gekozen."
      })
      
      output$plot_level24 <- renderPlot({
        ggplot(scientists_dataset, aes(age_years, survival_days)) +
          geom_point(color = "#00FF00", size = 3) +
          labs(
            title = "Survival vs Age",
            x = "Age (years)",
            y = "Survival (days)"
          ) +
          theme_minimal(base_family = "Courier New") +
          theme(
            plot.background = element_rect(fill = "black", color = NA),
            panel.background = element_rect(fill = "black"),
            text = element_text(color = "#00FF00"),
            axis.text = element_text(color = "#00FF00")
          )
      })
      
      session$sendCustomMessage("confetti", TRUE)
      return()
    }
    
    # WRONG ANSWER
    output$console_level24 <- renderText({
      "✖ Fout. Controleer je titel en labels.\nHint: Denk aan duidelijke, beschrijvende labels."
    })
    
    output$plot_level24 <- renderPlot(NULL)
  })
}

shinyApp(ui, server)
