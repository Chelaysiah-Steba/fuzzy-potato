library(shiny)
library(shinyjs)
library(ggplot2)

# ---------------------------
# DATASET
# ---------------------------
tidy_scientists <- data.frame(
  Scientist = c(
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

# ---------------------------
# UI
# ---------------------------
ui <- fluidPage(
  useShinyjs(),
  
  tags$head(
    tags$style(HTML("
      body {
        background-color: #1c1c1c;
        color: #00FF00;
        font-family: 'Courier New', monospace;
      }

      #start_wrapper {
        display: flex;
        justify-content: center;
        align-items: center;
        height: 60vh;
      }

      .code-box {
        background-color: #000000;
        border: 3px solid #00FF00;
        padding: 10px;
        margin-bottom: 5px;   /* SMALLER SPACING */
        font-family: 'Courier New', monospace;
        white-space: pre-wrap;
        font-size: 1.05em;
        line-height: 1.2em;   /* TIGHTER LINE SPACING */
      }

      .inline-input {
        display: inline-block;
        width: 120px;
        background-color: #000000;
        color: #00FF00;
        border: 2px solid #00FF00;
        font-family: 'Courier New', monospace;
        margin-left: 3px;
        margin-right: 3px;
        height: 28px;         /* SMALLER HEIGHT */
      }

      .inline-dropdown {
        display: inline-block;
        background-color: #000000;
        color: #00FF00;
        border: 2px solid #00FF00;
        font-family: 'Courier New', monospace;
        margin-left: 3px;
        height: 32px;         /* SMALLER HEIGHT */
      }

      .game-container {
        display: flex;
        gap: 10px;            /* SMALLER GAP */
        margin-top: 10px;
      }

      .editor, .console {
        width: 50%;
        padding: 10px;        /* SMALLER PADDING */
        border: 2px solid #00FF00;
        background-color: #1c1c1c;
      }

      .console {
        background-color: #000000;
        white-space: pre-wrap;
      }

      button {
        background-color: #1c1c1c;
        color: #00FF00;
        border: 2px solid #00FF00;
        padding: 8px 16px;    /* SMALLER BUTTON */
        cursor: pointer;
        font-size: 1.1em;
      }

      button:hover {
        background-color: #00FF00;
        color: #1c1c1c;
      }
    "))
  ),
  
  div(
    id = "start_wrapper",
    actionButton("start_scatter", "📊 Start Level 2.2: Maak een scatterplot")
  ),
  
  uiOutput("game_ui")
)

# ---------------------------
# SERVER
# ---------------------------
server <- function(input, output, session) {
  
  observeEvent(input$start_scatter, {
    
    removeUI(selector = "#start_wrapper", immediate = TRUE)
    
    output$game_ui <- renderUI({
      div(class = "game-container",
          
          div(class = "editor",
              h3("Level 2.2: Maak een scatterplot"),
              p("Opdracht: kies de juiste functie en vul de lege plekken in."),
              
              div(class = "code-box",
                  
                  HTML("ggplot(tidy_scientists, aes(x = "),
                  tags$input(id = "x_input", type = "text", class = "inline-input"),
                  HTML(", y = "),
                  tags$input(id = "y_input", type = "text", class = "inline-input"),
                  HTML(")) + "),
                  
                  selectInput(
                    "geom_choice",
                    NULL,
                    choices = c(
                      "geom_point()" = "geom_point()",
                      "geom_line()" = "geom_line()",
                      "geom_bar()" = "geom_bar()",
                      "geom_histogram()" = "geom_histogram()"
                    ),
                    width = "180px",
                    selectize = FALSE
                  ),
                  
                  HTML(" + theme_minimal()")
              ),
              
              actionButton("run_scatter", "▶ RUN CODE")
          ),
          
          div(class = "console",
              h3("Console"),
              verbatimTextOutput("scatter_console"),
              plotOutput("scatter_plot", height = "300px")   # SMALLER PLOT
          )
      )
    })
  })
  
  observeEvent(input$run_scatter, {
    req(input$geom_choice, input$x_input, input$y_input)
    
    correct_geom <- input$geom_choice == "geom_point()"
    correct_x <- input$x_input == "age_years"
    correct_y <- input$y_input == "survival_days"
    
    if (correct_geom && correct_x && correct_y) {
      
      output$scatter_console <- renderText({
        paste0(
          "✔ Correct!\nJe hebt de juiste functie gekozen en alle velden correct ingevuld.\n\n",
          "Volledige code:\n",
          "ggplot(tidy_scientists, aes(x = age_years, y = survival_days)) +\n",
          "  geom_point() +\n",
          "  theme_minimal()"
        )
      })
      
      output$scatter_plot <- renderPlot({
        ggplot(tidy_scientists, aes(age_years, survival_days)) +
          geom_point(color = "#00FF00", size = 3) +
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
    
    output$scatter_console <- renderText({
      paste0(
        "✖ Fout.\nControleer je invoer.\n\n",
        "Hint: Een scatterplot gebruikt punten → geom_point().\n",
        "X = age_years\nY = survival_days"
      )
    })
    
    output$scatter_plot <- renderPlot(NULL)
  })
}

shinyApp(ui, server)
