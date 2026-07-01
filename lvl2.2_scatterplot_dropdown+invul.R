library(shiny)
library(shinyjs)
library(ggplot2)

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

ui <- fluidPage(
  useShinyjs(),
  
  tags$head(
    tags$style(HTML("
      body {
        background-color: #1c1c1c;
        color: #00FF00;
        font-family: 'Courier New', monospace;
      }

      .code-box {
        background-color: #000000;
        border: 3px solid #00FF00;
        padding: 8px;
        margin-bottom: 5px;
        font-size: 1.05em;
        line-height: 1.1em;
      }

      .inline-input {
        width: 120px;
        background-color: #000000;
        color: #00FF00;
        border: 2px solid #00FF00;
        margin: 0 3px;
        height: 26px;
      }

      .inline-dropdown {
        background-color: #000000;
        color: #00FF00;
        border: 2px solid #00FF00;
        margin-left: 3px;
        height: 30px;
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

      .console {
        background-color: #000000;
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
    "))
  ),
  
  uiOutput("game_ui")
)

server <- function(input, output, session) {
  
  output$game_ui <- renderUI({
    div(class = "game-container",
        
        div(class = "editor",
            h3("Level 2.2: Maak een scatterplot"),
            p("Opdracht: vul alle velden correct in."),
            
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
                  width = "160px",
                  selectize = FALSE
                ),
                
                HTML(" + theme_minimal()")
            ),
            
            actionButton("run_scatter", "▶ RUN CODE")
        ),
        
        div(class = "console",
            h3("Console"),
            verbatimTextOutput("scatter_console"),
            plotOutput("scatter_plot", height = "300px")
        )
    )
  })
  
  observeEvent(input$run_scatter, {
    req(input$x_input, input$y_input, input$geom_choice)
    
    correct_x <- input$x_input == "age_years"
    correct_y <- input$y_input == "symptom_onset_days"
    correct_geom <- input$geom_choice == "geom_point()"
    
    if (correct_x && correct_y && correct_geom) {
      
      output$scatter_console <- renderText({
        paste0(
          "✔ Correct!\nAlles klopt.\n\n",
          "Volledige code:\n",
          "ggplot(tidy_scientists, aes(x = age_years, y = symptom_onset_days)) +\n",
          "  geom_point() +\n",
          "  theme_minimal()"
        )
      })
      
      output$scatter_plot <- renderPlot({
        ggplot(tidy_scientists, aes(age_years, symptom_onset_days)) +
          geom_point(color = "#00FF00", size = 3) +
          theme_minimal(base_family = "Courier New") +
          theme(
            plot.background = element_rect(fill = "black"),
            panel.background = element_rect(fill = "black"),
            text = element_text(color = "#00FF00"),
            axis.text = element_text(color = "#00FF00")
          )
      })
      
      return()
    }
    
    output$scatter_console <- renderText({
      paste0(
        "✖ Fout.\nAlle drie velden moeten correct zijn.\n\n",
        "Hints:\n",
        "X = age_years\n",
        "Y = symptom_onset_days\n",
        "Gebruik geom_point() voor een scatterplot."
      )
    })
    
    output$scatter_plot <- renderPlot(NULL)
  })
}

shinyApp(ui, server)
