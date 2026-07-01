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

title_question <- list(
  id = "title_choice",
  type = "dropdown",
  prompt = "Titel",
  options = c(
    "\"Scatterplot\"" = "\"Scatterplot\"",
    "\"Survival vs Age\"" = "\"Survival vs Age\"",
    "\"Age and Days\"" = "\"Age and Days\""
  ),
  answer = "\"Survival vs Age\""
)

xlabel_question <- list(
  id = "xlabel_choice",
  type = "dropdown",
  prompt = "X-as label",
  options = c(
    "\"Age (years)\"" = "\"Age (years)\"",
    "\"age_years\"" = "\"age_years\"",
    "\"Scientist Age\"" = "\"Scientist Age\""
  ),
  answer = "\"Age (years)\""
)

ylabel_question <- list(
  id = "ylabel_choice",
  type = "dropdown",
  prompt = "Y-as label",
  options = c(
    "\"Survival (days)\"" = "\"Survival (days)\"",
    "\"survival_days\"" = "\"survival_days\"",
    "\"Days alive\"" = "\"Days alive\""
  ),
  answer = "\"Survival (days)\""
)

level2_4_ui <- function() {
  
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
        gap: 20px;
        margin-top: 20px;
      }
      .editor, .console {
        width: 50%;
        padding: 15px;
        border: 2px solid #00FF00;
      }
      .editor {
        background-color: #1c1c1c;
      }
      .console {
        background-color: #000000;
        white-space: pre-wrap;
      }
      .code-box {
        background-color: #000000;
        border: 3px solid #00FF00;
        padding: 20px;
        margin-bottom: 20px;
        white-space: pre-wrap;
      }
      "))
    ),
    
    div(
      id = "start_wrapper_level24",
      style = "
        display:flex;
        justify-content:center;
        align-items:center;
        height:60vh;
      ",
      
      actionButton(
        "start_level24",
        "📝 Start Level 2.4: Kies de juiste titel en labels"
      )
    ),
    
    uiOutput("game_ui")
    
  )
  
}

level2_4_server <- function(input, output, session, current_page) {
  
  title_q <- render_question(title_question)
  xlabel_q <- render_question(xlabel_question)
  ylabel_q <- render_question(ylabel_question)
  
  observeEvent(input$start_level24, {
    
    removeUI(selector = "#start_wrapper_level24", immediate = TRUE)
    
    output$game_ui <- renderUI({
      
      div(
        class = "game-container",
        
        div(
          class = "editor",
          
          h3("📝 Level 2.4: Kies de juiste titel en labels"),
          
          p("Kies de correcte titel, x-as label en y-as label."),
          
          div(
            class = "code-box",
            
            HTML(
              "ggplot(scientists_dataset, aes(age_years, survival_days)) +
geom_point() +
labs("
            ),
            
            title_q$ui,
            
            xlabel_q$ui,
            
            ylabel_q$ui
            
          ),
          
          actionButton("run_level24", "▶ RUN CODE")
          
        ),
        
        div(
          class = "console",
          
          h3("Console"),
          
          verbatimTextOutput("console_level24"),
          
          plotOutput("plot_level24")
        )
        
      )
      
    })
    
  })
  
  observeEvent(input$run_level24, {
    
    if (title_q$check(input) &&
        xlabel_q$check(input) &&
        ylabel_q$check(input)) {
      
      output$console_level24 <- renderText({
        "✔ Correct! Je hebt de juiste titel en labels gekozen."
      })
      
      output$plot_level24 <- renderPlot({
        
        ggplot(scientists_dataset,
               aes(age_years, survival_days)) +
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
      
      current_page("level2_5")
      
      return()
      
    }
    
    output$console_level24 <- renderText({
      "✖ Fout. Controleer je titel en labels.\nHint: Denk aan duidelijke, beschrijvende labels."
    })
    
    output$plot_level24 <- renderPlot(NULL)
    
  })
  
}