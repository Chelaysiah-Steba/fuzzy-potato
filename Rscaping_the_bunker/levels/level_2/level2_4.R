plot_title_question <- list(
  id = "plot_title",
  type = "dropdown",
  prompt = "Grafiektitel",
  options = c(
    "Verspreiding van virussen in de populatie",
    "Aantal besmettingen per virus",
    "Variatie in onsetgroepen",
    "onsetttijd per virus",
    "Gemiddelde onsettijd per virus"
  ),
  answer = "Gemiddelde onsettijd per virus"
)

plot_subtitle_question <- list(
  id = "plot_subtitle",
  type = "dropdown",
  prompt = "Subtitel",
  options = c(
    "Foutbalken tonen het aantal metingen",
    "Foutbalken geven de maximale waarde weer",
    "Foutbalken tonen het 95%-betrouwbaarheidsinterval",
    "Foutbalken tonen de standaarddeviatie"
  ),
  answer = "Foutbalken tonen de standaarddeviatie"
)

plot_xlab_question <- list(
  id = "plot_xlab",
  type = "dropdown",
  prompt = "X-as label",
  options = c(
    "Onsetgroep",
    "Aantal patiënten",
    "Gemiddelde SD-waarde",
    "Gemiddelde onsettijd",
    "Virus",
    "Virusnaam"
  ),
  answer = c("Virus", "Virusnaam")
)

plot_ylab_question <- list(
  id = "plot_ylab",
  type = "dropdown",
  prompt = "Y-as label",
  options = c(
    "Totale duur van infectie ((dagen)",
    "Aantal dagen tot herstel",
    "Variatie in onset (SD)",
    "Gemiddelde onsettijd (dagen)"
  ),
  answer = "Gemiddelde onsettijd (dagen)"
)

level2_4_ui <- function() {
  
  title_q <- render_question(plot_title_question)
  subtitle_q <- render_question(plot_subtitle_question)
  x_q <- render_question(plot_xlab_question)
  y_q <- render_question(plot_ylab_question)
  
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
        
        h3("Level 2.4: Geef de grafiek de juiste labels"),
        
        p("Vul de grafiektitel, subtitel, x-as label en y-as label in."),
        
        p("Kies steeds het juiste antwoord uit de dropdowns in de code."),
        
        div(
          class = "code-box",
      HTML("ggplot(virus_dataset, aes(
  x = virus,
  y = mean_onset_days,
  color = onset_group
)) +
  geom_point(size = 3) +
  geom_errorbar(
    aes(
      ymin = mean_onset_days - sd_onset_days,
      ymax = mean_onset_days + sd_onset_days
    ),
    width = 0.2
  ) +
  theme_minimal() +
  labs(
    title = "),
      title_q$ui,
      HTML(",
    subtitle = "),
      subtitle_q$ui,
      HTML(",
    x = "),
      x_q$ui,
      HTML(",
    y = "),
      y_q$ui,
      HTML("
  ) +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1)
  )")
        ),
      
      actionButton("run_label", "▶ RUN CODE"),
      
      ),
      
      div(
        class = "console",
        
        h3("Console"),
        
        verbatimTextOutput("label_console"),
        
        uiOutput("label_content")
      
    )
  )
  
  )
}

level2_4_server <- function(input, output, session, current_page) {
  
  if (!"onset_group" %in% names(virus_dataset)) {
    
    virus_dataset$onset_group <- cut(
      virus_dataset$mean_onset_days,
      breaks = c(0, 2, 4, 6, 8),
      labels = c("0-2", "2-4", "4-6", "6-8")
    )
    
  }
  
  output$label_content <- renderUI(NULL)
  
  observeEvent(input$run_label, {
    
    title_q <- render_question(plot_title_question)
    subtitle_q <- render_question(plot_subtitle_question)
    x_q <- render_question(plot_xlab_question)
    y_q <- render_question(plot_ylab_question)
    
    if (
      isTRUE(title_q$check(input)) &&
      isTRUE(subtitle_q$check(input)) &&
      isTRUE(x_q$check(input)) &&
      isTRUE(y_q$check(input))
    ) {
      
      session$sendCustomMessage("greenFlash", TRUE)
      
      output$label_console <- renderText({
        paste(
          "🟢 SECURITY PROTOCOL UPDATED",
          "",
          "Module 4/4 geactiveerd.",
          "",
          "Graph Label Module",
          "STATUS: ONLINE",
          "",
          "De grafiek is nu voorzien van de juiste titel, subtitel en assenlabels.",
          sep = "\n"
        )
      })
      
      output$label_content <- renderUI({
        tagList(
          plotOutput("label_plot"),
          br(),
          actionButton("next_level2_5", "Volgende", class = "next-btn")
        )
      })
      
      output$label_plot <- renderPlot({
        ggplot(
          virus_dataset,
          aes(
            x = virus,
            y = mean_onset_days,
            color = onset_group
          )
        ) +
          geom_point(size = 3) +
          geom_errorbar(
            aes(
              ymin = mean_onset_days - sd_onset_days,
              ymax = mean_onset_days + sd_onset_days
            ),
            width = 0.2
          ) +
          theme_minimal() +
          labs(
            title = "Gemiddelde onsettijd per virus",
            subtitle = "Foutbalken tonen de standaarddeviatie",
            x = "Virus",
            y = "Gemiddelde onsettijd (dagen)",
            color = "Onset groep"
          ) +
          theme(
            axis.text.x = element_text(angle = 45, hjust = 1)
          )
      })
      
      return()
    }
    
    session$sendCustomMessage("redFlash", TRUE)
    
    output$label_console <- renderText({
      paste(
        "🔴 SECURITY PROTOCOL FAILED",
        "",
        "Eén of meerdere labels zijn nog fout.",
        "",
        "Controleer of je de juiste titel, subtitel en assenlabels hebt gekozen.",
        sep = "\n"
      )
    })
    
    output$label_content <- renderUI(NULL)
  })
  
  observeEvent(input$next_level2_5, {
    current_page("transition_level2_3")
  })
}