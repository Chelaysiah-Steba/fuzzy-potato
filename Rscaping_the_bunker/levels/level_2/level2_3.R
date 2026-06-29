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

color_question <- list(
  id = "color_input",
  type = "open",
  prompt = "Vul de variabele in:",
  answers = c("scientist")
)

level2_3_ui <- function() {
  
  fluidPage(
    
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
        padding: 20px;
        margin-bottom: 20px;
        white-space: pre-wrap;
        font-size: 1.1em;
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
        padding: 10px 20px;
        cursor: pointer;
        font-size: 1.2em;
      }

      button:hover {
        background-color: #00FF00;
        color: #1c1c1c;
      }
      "))
    ),
    
    div(
      class = "game-container",
      
      div(
        class = "editor",
        
        h3("Level 2.3: Voeg kleur toe met as.factor()"),
        
        p("Opdracht: Pas de kleur van de dots aan zodat zichtbaar wordt welke scientist het is."),
        
        div(
          class = "code-box",
          
          HTML(
            "ggplot(scientists_dataset, aes(
  x = age_years,
  y = survival_days,
  color = as.factor("
          ),
          
          render_question(color_question)$ui,
          
          HTML(
            ")
)) +
  geom_point() +
  theme_minimal()"
          )
          
        ),
        
        actionButton("run_colour", "▶ RUN CODE")
      ),
      
      div(
        class = "console",
        
        h3("Console"),
        
        verbatimTextOutput("colour_console"),
        
        plotOutput("colour_plot")
      )
    )
    
  )
  
}

level2_3_server <- function(input, output, session, current_page) {
  
  question <- render_question(color_question)
  
  observeEvent(input$run_colour, {
    
    if (question$check(input)) {
      
      output$colour_console <- renderText({
        
        paste0(
          "✔ Correct!\nJe hebt de kleur aesthetic goed ingevuld.\n\n",
          "Volledige code:\n",
          "ggplot(scientists_dataset, aes(\n",
          "  x = age_years,\n",
          "  y = survival_days,\n",
          "  color = as.factor(scientist)\n",
          ")) +\n",
          "  geom_point() +\n",
          "  theme_minimal()"
        )
        
      })
      
      output$colour_plot <- renderPlot({
        
        ggplot(
          scientists_dataset,
          aes(
            age_years,
            survival_days,
            color = as.factor(scientist)
          )
        ) +
          geom_point(size = 3) +
          theme_minimal(base_family = "Courier New") +
          theme(
            plot.background = element_rect(fill = "black", color = NA),
            panel.background = element_rect(fill = "black"),
            text = element_text(color = "#00FF00"),
            axis.text = element_text(color = "#00FF00")
          )
        
      })
      
      session$sendCustomMessage("confetti", TRUE)
      
      current_page("level2_4")
      
      return()
      
    }
    
    output$colour_console <- renderText({
      
      "✖ Fout.\nVul alleen in wat er tussen de haakjes moet staan."
      
    })
    
    output$colour_plot <- renderPlot(NULL)
    
  })
  
}