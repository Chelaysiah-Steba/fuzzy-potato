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

        actionButton("run_colour", "▶ RUN CODE")

      ),

      div(

        class = "console",

        h3("Console"),

        verbatimTextOutput("colour_console"),
        
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
  
  output$colour_content <- renderUI(NULL)

  observeEvent(input$run_colour, {

    answer <- trimws(input$color_input)

    if (isTRUE(question$check(input))) {
      
      session$sendCustomMessage("greenFlash", TRUE)

      output$colour_console <- renderText({
        
        paste(
          
          "🟢 SECURITY PROTOCOL UPDATED",
          "",
          "Module 3/4 geactiveerd.",
          "",
          "Virus Classification Module",
          "STATUS: ONLINE",
          "",
          "Iedere onsetcategorie krijgt nu automatisch een eigen kleur.",
          
          sep="\n"
          
        )
        
      })

      output$colour_content <- renderUI({
        
        tagList(
          
          plotOutput("colour_plot"),
          
          br(),
          
          actionButton(
            "next_level2_4",
            "Volgende",
            class="next-btn"
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
          
          labs(
            title = NULL,
            subtitle = NULL,
            x = NULL,
            y = NULL,
            color = "Onset groep"
          ) +
          
          theme(
            axis.text.x = element_text(angle = 45, hjust = 1)
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

    output$colour_console <- renderText({
      
      paste(
        
        "🔴 SECURITY PROTOCOL FAILED",
        "",
        "Module activation unsuccessful.",
        "",
        "HINT",
        hint,
        
        sep="\n"
        
      )
      
    })

    output$colour_content <- renderUI(NULL)

  })
  
  observeEvent(input$next_level2_4,{
    
    current_page("level2_4")
    
  })

}