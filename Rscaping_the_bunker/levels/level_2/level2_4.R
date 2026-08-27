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
          color: #24bb24;
          font-family: 'Courier New', monospace;
        }
        
        .game-container {
          display: flex;
          gap: 20px;
          margin-top: 20px;
        }
        
        .editor,
        .console {
          width: 50%;
          padding: 15px;
          border: 2px solid #24bb24;
          font-family: 'Courier New', monospace;
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
          border: 2px solid #24bb24;
          padding: 20px;
          margin-bottom: 20px;
          white-space: pre-wrap;
          font-size: 1.1em;
        }
        
        .console-message {
          background-color: #000000 !important;
          color: #24bb24 !important;
          border: 2px solid #24bb24 !important;
          outline: none !important;
          box-shadow: none !important;
          padding: 10px;
          margin-top: 10px;
          min-height: 80px;
        }
        
        .console-message.error {
          color: #bb2424 !important;
          border-color: #bb2424 !important;
        }
        
        .console-message.success {
          color: #24bb24 !important;
          border-color: #24bb24 !important;
        }
        
        .console-message pre {
          background-color: #000000 !important;
          color: inherit !important;
          border: none !important;
          outline: none !important;
          box-shadow: none !important;
          padding: 0 !important;
          margin: 0 !important;
          font-family: 'Courier New', monospace !important;
          white-space: pre-wrap !important;
        }
        
        select,
        .form-control,
        .selectize-input,
        .selectize-control.single .selectize-input,
        .selectize-dropdown,
        .selectize-dropdown .option,
        .selectize-input.full {
          background-color: #000000 !important;
          color: #24bb24 !important;
          border: 2px solid #24bb24 !important;
          font-family: 'Courier New', monospace !important;
        }
        
        .selectize-input input {
          color: #24bb24 !important;
        }
        
        .selectize-dropdown-content {
          background-color: #000000 !important;
        }
        
        .selectize-dropdown .option {
          background-color: #000000 !important;
          color: #24bb24 !important;
        }
        
        .selectize-dropdown .active {
          background-color: #24bb24 !important;
          color: #000000 !important;
        }
        
        .selectize-control.single .selectize-input:after {
          border-top-color: #24bb24 !important;
        }
        
        button,
        .btn,
        #run_label {
          background-color: #1c1c1c;
          color: #24bb24;
          border: 2px solid #24bb24;
          padding: 10px 20px;
          cursor: pointer;
          font-family: 'Courier New', monospace;
        }
        
        button:hover,
        .btn:hover,
        #run_label:hover {
          background-color: #24bb24;
          color: #000000;
        }
        
        .next-btn {
          margin-top: 20px;
          background: #1c1c1c;
          color: #24bb24;
          border: 2px solid #24bb24;
          padding: 10px 20px;
          font-family: 'Courier New', monospace;
          cursor: pointer;
        }
        
        .next-btn:hover {
          background-color: #24bb24;
          color: #000000;
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
          
          HTML(
            "ggplot(virus_dataset, aes(
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
title = "
          ),
          
          title_q$ui,
          
          HTML(
            ",
subtitle = "
          ),
          
          subtitle_q$ui,
          
          HTML(
            ",
x = "
          ),
          
          x_q$ui,
          
          HTML(
            ",
y = "
          ),
          
          y_q$ui,
          
          HTML(
            "
) +
theme(
axis.text.x = element_text(angle = 45, hjust = 1)
)"
          )
        ),
        
        actionButton(
          "run_label",
          "▶ RUN CODE"
        )
      ),
      
      div(
        class = "console",
        
        h3("Console"),
        
        uiOutput("label_console_ui"),
        
        br(),
        
        # Bij het starten van dit level staat hier de grafiek uit level 2.3.
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
  
  output$label_console_ui <- renderUI({
    NULL
  })
  
  # Toon dezelfde grafiek als de succesvolle grafiek van level 2.3.
  output$label_content <- renderUI({
    plotOutput("previous_level_plot", height = "400px")
  })
  
  output$previous_level_plot <- renderPlot({
    
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
      
      theme(
        plot.background = element_rect(
          fill = "black",
          color = "black"
        ),
        panel.background = element_rect(
          fill = "black",
          color = "black"
        ),
        panel.grid.major = element_line(
          color = "#555555"
        ),
        panel.grid.minor = element_line(
          color = "#333333"
        ),
        text = element_text(
          color = "#24bb24"
        ),
        axis.text = element_text(
          color = "#24bb24"
        ),
        axis.title = element_text(
          color = "#24bb24"
        ),
        legend.text = element_text(
          color = "#24bb24"
        ),
        legend.title = element_text(
          color = "#24bb24"
        ),
        legend.background = element_rect(
          fill = "black",
          color = "black"
        ),
        panel.border = element_blank(),
        axis.text.x = element_text(
          angle = 45,
          hjust = 1
        )
      ) +
      
      labs(
        title = NULL,
        subtitle = NULL,
        x = NULL,
        y = NULL,
        color = "Onset groep"
      )
  })
  
  observeEvent(input$run_label, {
    
    title_q <- render_question(plot_title_question)
    subtitle_q <- render_question(plot_subtitle_question)
    x_q <- render_question(plot_xlab_question)
    y_q <- render_question(plot_ylab_question)
    
    x_answer <- trimws(as.character(input$plot_xlab))
    x_ok <- x_answer %in% c("Virus", "Virusnaam")
    
    if (
      isTRUE(title_q$check(input)) &&
      isTRUE(subtitle_q$check(input)) &&
      isTRUE(x_ok) &&
      isTRUE(y_q$check(input))
    ) {
      
      session$sendCustomMessage("greenFlash", TRUE)
      
      output$label_console_ui <- renderUI({
        
        div(
          class = "console-message success",
          
          verbatimTextOutput(
            "label_console",
            placeholder = FALSE
          )
        )
      })
      
      output$label_console <- renderText({
        
        paste(
          "✔ Correct!",
          "",
          "De grafiek is nu voorzien van de juiste titel, subtitel en assenlabels.",
          sep = "\n"
        )
      })
      
      # De oude plot uit level 2.3 wordt vervangen door de nieuwe gemaakte plot.
      output$label_content <- renderUI({
        
        tagList(
          
          plotOutput("label_plot", height = "400px"),
          
          br(),
          
          actionButton(
            "next_transition2_3",
            "Volgende",
            class = "next-btn"
          )
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
          
          theme(
            plot.background = element_rect(
              fill = "black",
              color = "black"
            ),
            panel.background = element_rect(
              fill = "black",
              color = "black"
            ),
            panel.grid.major = element_line(
              color = "#555555"
            ),
            panel.grid.minor = element_line(
              color = "#333333"
            ),
            text = element_text(
              color = "#24bb24"
            ),
            axis.text = element_text(
              color = "#24bb24"
            ),
            axis.title = element_text(
              color = "#24bb24"
            ),
            plot.title = element_text(
              color = "#24bb24"
            ),
            plot.subtitle = element_text(
              color = "#24bb24"
            ),
            legend.text = element_text(
              color = "#24bb24"
            ),
            legend.title = element_text(
              color = "#24bb24"
            ),
            legend.background = element_rect(
              fill = "black",
              color = "black"
            ),
            panel.border = element_blank(),
            axis.text.x = element_text(
              angle = 45,
              hjust = 1
            )
          ) +
          
          labs(
            title = "Gemiddelde onsettijd per virus",
            subtitle = "Foutbalken tonen de standaarddeviatie",
            x = "Virus",
            y = "Gemiddelde onsettijd (dagen)",
            color = "Onset groep"
          )
      })
      
    } else {
      
      session$sendCustomMessage("redFlash", TRUE)
      
      output$label_console_ui <- renderUI({
        
        div(
          class = "console-message error",
          
          verbatimTextOutput(
            "label_console",
            placeholder = FALSE
          )
        )
      })
      
      output$label_console <- renderText({
        
        paste(
          "✖ Fout.",
          "",
          "Een of meerdere labels zijn nog niet correct.",
          "",
          "Controleer de titel, subtitel en assenlabels opnieuw.",
          sep = "\n"
        )
      })
      
      # Bij een fout blijft de grafiek uit level 2.3 zichtbaar.
      output$label_content <- renderUI({
        plotOutput("previous_level_plot", height = "400px")
      })
    }
  })
  
  observeEvent(input$next_transition2_3, {
    current_page("transition2_3")
  })
}