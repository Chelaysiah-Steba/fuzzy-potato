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
          color: #24bb24;
          font-family: 'Courier New', monospace;
        }
        
        .rank-list-item {
          background-color: #000000 !important;
          color: #24bb24 !important;
          border: 1px solid #24bb24 !important;
          padding: 8px;
          margin-bottom: 6px;
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
  text-align: left;
}

.editor {
  background-color: #1c1c1c;
  min-height: 200px;
}

.console {
  background-color: #000000;
  min-height: 200px;
  white-space: pre-wrap;
}
        
        .editor {
          min-height: 200px;
        }
        
        .console {
          min-height: 200px;
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
        
        .next-btn {
          margin-top: 20px;
          background: #000000;
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
        
        .plot-wrap {
          margin-top: 10px;
        }
        
        #check_l3_4 {
  margin-top: 20px;
  background-color: #1c1c1c;
  color: #24bb24;
  border: 2px solid #24bb24;
  padding: 10px 20px;
  font-family: 'Courier New', monospace;
  cursor: pointer;
}

#check_l3_4:hover {
  background-color: #24bb24;
  color: #000000;
}
        
      "))
    ),
    
    
    div(
      class = "game-container",
      
      div(
        class = "editor",
        
        h3("Level 3.4 — Zet de barplot-code in de juiste volgorde"),
        
        p(
          "Sleep de code-stukken hieronder in de juiste volgorde om een barplot te maken."
        ),
        
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
        
        actionButton(
          "check_l3_4",
          "▶ RUN CODE"
        )
      ),
      
      
      div(
        class = "console",
        
        h3("Console"),
        
        uiOutput("feedback_ui_l3_4"),
        
        br(),
        
        uiOutput("plot_ui_l3_4"),
        
        uiOutput("next_ui_l3_4")
      )
    )
  )
}


level3_4_server <- function(input, output, session, current_page) {
  
  output$feedback_ui_l3_4 <- renderUI({
    NULL
  })
  
  output$plot_ui_l3_4 <- renderUI({
    NULL
  })
  
  output$next_ui_l3_4 <- renderUI({
    NULL
  })
  
  
  observeEvent(input$check_l3_4, {
    
    req(input$ordered_code_l3_4)
    
    
    if (
      identical(
        input$ordered_code_l3_4[1],
        'ggplot(tidy_scientists, aes(x = Scientist, y = symptom_onset_days)) +'
      )
    ) {
      
      session$sendCustomMessage("greenFlash", TRUE)
      
      
      output$feedback_ui_l3_4 <- renderUI({
        
        div(
          class = "console-message success",
          
          verbatimTextOutput(
            "feedback_l3_4",
            placeholder = FALSE
          )
        )
      })
      
      
      output$feedback_l3_4 <- renderText({
        
        "✔ Correct! De ggplot-regel staat bovenaan."
        
      })
      
      
      output$plot_ui_l3_4 <- renderUI({
        
        div(
          class = "plot-wrap",
          plotOutput("plot_l3_4")
        )
      })
      
      
      output$plot_l3_4 <- renderPlot({
        
        ggplot(
          tidy_scientists,
          aes(
            x = Scientist,
            y = symptom_onset_days
          )
        ) +
          geom_bar(
            stat = "identity",
            fill = "#24bb24",
            color = "#24bb24"
          ) +
          labs(
            title = "symptom onset days per scientist"
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
            )
          )
      })
      
      
      output$next_ui_l3_4 <- renderUI({
        
        actionButton(
          "next_level3_5",
          "Volgende",
          class = "next-btn"
        )
      })
      
    } else {
      
      session$sendCustomMessage("redFlash", TRUE)
      
      
      output$feedback_ui_l3_4 <- renderUI({
        
        div(
          class = "console-message error",
          
          verbatimTextOutput(
            "feedback_l3_4",
            placeholder = FALSE
          )
        )
      })
      
      
      output$feedback_l3_4 <- renderText({
        
        "✖ Fout. De eerste regel moet de ggplot-regel zijn."
        
      })
      
      
      output$plot_ui_l3_4 <- renderUI({
        NULL
      })
      
      
      output$next_ui_l3_4 <- renderUI({
        NULL
      })
    }
  })
  
  
  observeEvent(input$next_level3_5, {
    
    current_page("level3_5")
    
  })
}