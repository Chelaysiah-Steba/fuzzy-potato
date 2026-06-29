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

x_question <- list(
  id = "x_input",
  type = "open",
  prompt = "X-as",
  answers = c("age_years")
)

y_question <- list(
  id = "y_input",
  type = "open",
  prompt = "Y-as",
  answers = c("survival_days")
)

geom_question <- list(
  id = "geom_choice",
  type = "dropdown",
  prompt = "Kies de juiste geom",
  options = c(
    "geom_point()" = "geom_point()",
    "geom_line()" = "geom_line()",
    "geom_bar()" = "geom_bar()",
    "geom_histogram()" = "geom_histogram()"
  ),
  answer = "geom_point()"
)

level2_2_ui <- function() {
  
  fluidPage(
    
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
        margin-bottom: 5px;
        font-family: 'Courier New', monospace;
        white-space: pre-wrap;
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
        background-color: #1c1c1c;
      }

      .console {
        background-color: #000000;
      }
      "))
    ),
    
    div(
      id = "start_wrapper",
      actionButton("start_scatter", "📊 Start Level 2.2: Maak een scatterplot")
    ),
    
    uiOutput("game_ui")
    
  )
  
}

level2_2_server <- function(input, output, session, current_page) {
  
  x_q <- render_question(x_question)
  y_q <- render_question(y_question)
  geom_q <- render_question(geom_question)
  
  observeEvent(input$start_scatter, {
    
    removeUI(selector = "#start_wrapper", immediate = TRUE)
    
    output$game_ui <- renderUI({
      
      div(class = "game-container",
          
          div(class = "editor",
              
              h3("Level 2.2: Maak een scatterplot"),
              
              p("Opdracht: kies de juiste functie en vul de lege plekken in."),
              
              div(class = "code-box",
                  
                  HTML("ggplot(tidy_scientists, aes(x = "),
                  
                  x_q$ui,
                  
                  HTML(", y = "),
                  
                  y_q$ui,
                  
                  HTML(")) +"),
                  
                  geom_q$ui,
                  
                  HTML("+ theme_minimal()")
                  
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
    
  })
  
  observeEvent(input$run_scatter, {
    
    if (x_q$check(input) &&
        y_q$check(input) &&
        geom_q$check(input)) {
      
      output$scatter_console <- renderText({
        
        paste0(
          "✔ Correct!\nJe hebt de juiste functie gekozen en alle velden correct ingevuld.\n\n",
          "Volledige code:\n",
          "ggplot(tidy_scientists, aes(x = age_years, y = survival_days)) +\n",
          "geom_point() +\n",
          "theme_minimal()"
        )
        
      })
      
      output$scatter_plot <- renderPlot({
        
        ggplot(tidy_scientists,
               aes(age_years, survival_days)) +
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
      
      current_page("level2_3")
      
      return()
      
    }
    
    output$scatter_console <- renderText({
      
      paste0(
        "✖ Fout.\nControleer je invoer.\n\n",
        "Hint: Een scatterplot gebruikt punten → geom_point().\n",
        "X = age_years\n",
        "Y = survival_days"
      )
      
    })
    
    output$scatter_plot <- renderPlot(NULL)
    
  })
  
}