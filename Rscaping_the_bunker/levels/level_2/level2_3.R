color_question <- list(
  id = "color_input",
  type = "open",
  prompt = "Vul de variabele in:",
  answers = c("onset_group")
)

level2_3_ui <- function() {
  
  fluidPage(
    
    useShinyjs(),
    
    tags$head(
      tags$style(HTML("

      body {
        background-color: #1c1c1c;
        color: #24bb24;
        font-family: 'Courier New', monospace;
      }
      
      input[type='text'],
.form-control {
  background-color: #1c1c1c !important;
  color: #24bb24 !important;
  border: 2px solid #24bb24 !important;
  font-family: 'Courier New', monospace !important;
}

input[type='text']:focus,
.form-control:focus {
  background-color: #1c1c1c !important;
  color: #24bb24 !important;
  border: 2px solid #24bb24 !important;
  outline: none !important;
  box-shadow: none !important;
}

      .code-box {
        background-color: #000000;
        border: 3px solid #24bb24;
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

      .editor,
      .console {
        width: 50%;
        padding: 15px;
        border: 2px solid #24bb24;
      }

      .editor {
        background-color: #1c1c1c;
      }

      .console {
        background-color: #000000;
        white-space: pre-wrap;
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

      button,
      .btn,
      #run_colour {
        background-color: #1c1c1c;
        color: #24bb24;
        border: 2px solid #24bb24;
        padding: 10px 20px;
        cursor: pointer;
        font-family: 'Courier New', monospace;
      }

      button:hover,
      .btn:hover,
      #run_colour:hover {
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
        
        h3("Level 2.3: Categoriseer de virussen"),
        
        p(
          "Het systeem heeft automatisch een nieuwe kolom toegevoegd (onset_group) waarin de gemiddelde onsettijd is ingedeeld in categorieën."
        ),
        
        p(
          "Gebruik deze nieuwe kolom in as.factor() zodat iedere onsetcategorie een eigen kleur krijgt."
        ),
        
        div(
          
          class = "code-box",
          
          HTML(
            "ggplot(virus_dataset, aes(
  x = mean_onset_days,
  y = sd_onset_days,
  color = as.factor("
          ),
          
          render_question(color_question)$ui,
          
          HTML(
            ")
)) +
  geom_point(size = 3) +
  theme_minimal()"
          )
          
        ),
        
        actionButton(
          "run_colour",
          "▶ RUN CODE"
        )
        
      ),
      
      div(
        
        class = "console",
        
        h3("Console"),
        
        uiOutput("colour_console_ui"),
        
        uiOutput("colour_content")
        
      )
      
    )
    
  )
  
}

level2_3_server <- function(input, output, session, current_page) {
  
  question <- render_question(color_question)
  
  if (!"onset_group" %in% names(virus_dataset)) {
    
    virus_dataset$onset_group <- cut(
      virus_dataset$mean_onset_days,
      breaks = c(0, 2, 4, 6, 8),
      labels = c("0-2", "2-4", "4-6", "6-8")
    )
    
  }
  
  output$colour_console_ui <- renderUI({
    NULL
  })
  
  output$colour_content <- renderUI({
    NULL
  })
  
  observeEvent(input$run_colour, {
    
    answer <- trimws(input$color_input)
    
    if (isTRUE(question$check(input))) {
      
      session$sendCustomMessage("greenFlash", TRUE)
      
      output$colour_console_ui <- renderUI({
        
        div(
          class = "console-message success",
          
          verbatimTextOutput(
            "colour_console",
            placeholder = FALSE
          )
        )
        
      })
      
      output$colour_console <- renderText({
          
          paste(
            "✔ Correct!",
            "",
            "Iedere onsetcategorie krijgt nu automatisch een eigen kleur.",
            "",
            "De grafiek is succesvol bijgewerkt.",
            sep = "\n"
          )
          
        })
      
      output$colour_content <- renderUI({
        
        tagList(
          
          plotOutput("colour_plot"),
          
          br(),
          
          actionButton(
            "next_level2_4",
            "Volgende",
            class = "next-btn"
          )
          
        )
        
      })
      
      output$colour_plot <- renderPlot({
        
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
            panel.border = element_blank()
          ) +
          
          labs(
            title = NULL,
            subtitle = NULL,
            x = NULL,
            y = NULL,
            color = "Onset groep"
          ) +
          
          theme(
            axis.text.x = element_text(
              angle = 45,
              hjust = 1
            )
          )
        
      })
      
      return()
      
    }
    
    session$sendCustomMessage("redFlash", TRUE)
    
    hint <- if (answer == "") {
      
      "✖ Er ontbreekt nog een variabele."
      
    } else if (tolower(answer) == "virus") {
      
      "✖ Dat geeft iedere virusnaam een eigen kleur. Het systeem wil juist de nieuwe categorieën gebruiken."
      
    } else if (tolower(answer) == "mean_onset_days") {
      
      "✖ Dat is een numerieke variabele. Kijk welke nieuwe kolom het systeem heeft aangemaakt."
      
    } else if (tolower(answer) == "sd_onset_days") {
      
      "✖ Deze kolom bevat de spreiding. Gebruik de kolom met de onsetcategorieën."
      
    } else {
      
      "✖ Bijna. Gebruik de nieuwe kolom die de virussen indeelt in de categorieën 0-2, 2-4, 4-6 en 6-8 dagen."
      
    }
    
    output$colour_console_ui <- renderUI({
      
      div(
        class = "console-message error",
        
        verbatimTextOutput(
          "colour_console",
          placeholder = FALSE
        )
      )
      
    })
    
    output$colour_console <- renderText({
        
        paste(
          "✖ Fout.",
          "",
          hint,
          sep = "\n"
        )
        
      })
    
    output$colour_content <- renderUI({
      NULL
    })
    
  })
  
  observeEvent(input$next_level2_4, {
    
    current_page("level2_4")
    
  })
  
}