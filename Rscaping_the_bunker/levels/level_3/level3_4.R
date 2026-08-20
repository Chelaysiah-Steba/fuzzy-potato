library(shiny)
library(ggplot2)
library(sortable)

tidy_scientists <- data.frame(
  Scientist = c(
    "sci01","sci02","sci03","sci04","sci05",
    "sci06","sci07","sci08","sci09","sci10",
    "sci11","sci12","sci13","sci14","sci15",
    "sci16","sci17","sci18","sci19","sci20"
  ),
  on_site = c(
    1,0,1,1,1,
    0,1,1,0,0,
    1,0,0,0,1,
    1,1,0,1,1
  ),
  symptom_onset_days = c(
    5,7,3,4,4,
    6,3,4,5,6,
    5,7,6,5,4,
    3,5,7,4,3
  )
)

level3_4_ui <- function() {
  fluidPage(
    tags$head(
      tags$style(HTML("
        body {
          background-color: #000000;
          color: #39FF14;
          font-family: 'Courier New';
        }

        .rank-list-item {
          background-color: #000000 !important;
          color: #39FF14 !important;
          border: 1px solid #39FF14 !important;
          padding: 8px;
          margin-bottom: 6px;
          font-family: 'Courier New';
        }

        .game-container {
          display: flex;
          gap: 20px;
          margin-top: 20px;
        }

        .editor, .console {
          width: 50%;
          padding: 15px;
          border: 2px solid #39FF14;
          text-align: left;
          background-color: #000000;
        }

        .editor {
          min-height: 200px;
        }

        .console {
          min-height: 200px;
          white-space: pre-wrap;
        }

        .next-btn {
          margin-top: 20px;
          background: #000000;
          color: #39FF14;
          border: 2px solid #39FF14;
          padding: 10px 20px;
          font-family: 'Courier New';
          cursor: pointer;
        }

        .plot-wrap {
          margin-top: 10px;
        }
      "))
    ),
    
    div(
      class = "game-container",
      
      div(
        class = "editor",
        h3("LEVEL 3.4 — Zet de barplot-code in de juiste volgorde"),
        p("Sleep de code-stukken hieronder in de juiste volgorde om een barplot met foutbalken te maken."),
        
        rank_list(
          text = "Versleep de code-stukken:",
          labels = c(
            'geom_bar(stat = "identity") +',
            'theme_minimal()',
            'labs(title = "symptom onset days per scientist") +',
            'ggplot(tidy_scientists, aes(x = Scientist, y = symptom_onset_days)) +'
          ),
          input_id = "ordered_code_l3_4"
        ),
        
        actionButton("check_l3_4", "Check code", class = "btn btn-success")
      ),
      
      div(
        class = "console",
        h3("Console"),
        verbatimTextOutput("feedback_l3_4"),
        br(),
        uiOutput("plot_ui_l3_4"),
        uiOutput("next_ui_l3_4")
      )
    )
  )
}

level3_4_server <- function(input, output, session, current_page) {
  
  output$feedback_l3_4 <- renderText("")
  output$plot_ui_l3_4 <- renderUI(NULL)
  output$next_ui_l3_4 <- renderUI(NULL)
  
  observeEvent(input$check_l3_4, {
    req(input$ordered_code_l3_4)
    
    if (identical(input$ordered_code_l3_4[1], 'ggplot(tidy_scientists, aes(x = Scientist, y = symptom_onset_days)) +')) {
      
      session$sendCustomMessage("greenFlash", TRUE)
      
      output$feedback_l3_4 <- renderText("✔ Correct! De ggplot-regel staat bovenaan.")
      
      output$plot_ui_l3_4 <- renderUI({
        div(
          class = "plot-wrap",
          plotOutput("plot_l3_4")
        )
      })
      
      output$plot_l3_4 <- renderPlot({
        ggplot(tidy_scientists, aes(x = Scientist, y = symptom_onset_days)) +
          geom_bar(stat = "identity") +
          labs(title = "symptom onset days per scientist") +
          theme_minimal()
      })
      
      output$next_ui_l3_4 <- renderUI({
        actionButton("next_level3_5", "Volgende", class = "next-btn")
      })
      
    } else {
      
      session$sendCustomMessage("redFlash", TRUE)
      
      output$feedback_l3_4 <- renderText("✖ Fout. De eerste regel moet de ggplot-regel zijn.")
      output$plot_ui_l3_4 <- renderUI(NULL)
      output$next_ui_l3_4 <- renderUI(NULL)
    }
  })
  
  observeEvent(input$next_level3_5, {
    current_page("level3_5")
  })
}