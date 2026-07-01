#hoi Chelaysiah :)
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