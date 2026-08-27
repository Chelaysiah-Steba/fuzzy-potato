dna_ct_clean <- data.frame(
  log10_concentration = c(1.2, 1.5, 1.8, 2.0, 2.3, 2.6, 2.9, 3.1, 3.4, 3.7),
  ct_value = c(33.1, 31.8, 30.2, 29.0, 27.5, 26.1, 24.8, 23.9, 22.4, 21.0)
)


level4_5_ui <- function() {
  
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
          gap: 10px;
          margin-top: 10px;
        }
        
        .editor,
        .console {
          width: 50%;
          padding: 10px;
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
        
        .code-box {
          background-color: #000000;
          border: 3px solid #24bb24;
          padding: 8px;
          margin-bottom: 5px;
          font-size: 1.05em;
          line-height: 1.1em;
        }
        
        select,
.form-control {
  background-color: #000000 !important;
  color: #24bb24 !important;
  border: 2px solid #24bb24 !important;
  margin-left: 3px;
  height: 30px;
  font-family: 'Courier New', monospace !important;
}

select option {
  background-color: #000000 !important;
  color: #24bb24 !important;
}

select:focus,
.form-control:focus {
  background-color: #000000 !important;
  color: #24bb24 !important;
  border-color: #24bb24 !important;
  outline: none !important;
  box-shadow: none !important;
}

.shiny-input-container select {
  background-color: #000000 !important;
  color: #24bb24 !important;
}

.shiny-input-container select option {
  background-color: #000000 !important;
  color: #24bb24 !important;
}
        
        button {
          background-color: #1c1c1c;
          color: #24bb24;
          border: 2px solid #24bb24;
          padding: 8px 16px;
          cursor: pointer;
        }
        
        button:hover {
          background-color: #24bb24;
          color: #1c1c1c;
        }
        
        .next-btn {
          margin-top: 20px;
          background: #1c1c1c;
          color: #24bb24;
          border: 2px solid #24bb24;
          padding: 10px 20px;
          font-family: 'Courier New';
          cursor: pointer;
        }
        
      "))
    ),
    
    div(
      class = "game-container",
      
      div(
        class = "editor",
        
        h3("Level 4.5: Voeg een regressielijn toe"),
        
        p(
          "Opdracht: kies de juiste regressielijn-functie."
        ),
        
        div(
          class = "code-box",
          
          tags$pre(
            style = "
      background-color:#000000;
      color:#24bb24;
      border:none;
      margin:0;
      padding:0;
      font-family:'Courier New', monospace;
      white-space:pre-wrap;
    ",
            
            "model <- lm(ct_value ~ log10_concentration, data = dna_ct_clean)

intercept <- round(coef(model)[1], 3)
slope <- round(coef(model)[2], 3)
r2 <- round(summary(model)$r.squared, 3)

ggplot(
  dna_ct_clean,
  aes(
    x = log10_concentration,
    y = ct_value
  )
) +
  geom_point() +"
          ),
          
          selectInput(
            "reg_choice",
            NULL,
            choices = c(
              "geom_smooth(method = 'lm')" = "lm",
              "geom_smooth(method = 'loess')" = "loess",
              "geom_smooth()" = "auto"
            ),
            width = "260px",
            selectize = FALSE
          ),
          
          tags$pre(
            style = "
      background-color:#000000;
      color:#24bb24;
      border:none;
      margin:0;
      padding:0;
      font-family:'Courier New', monospace;
      white-space:pre-wrap;
    ",
            
            "  labs(
    subtitle = paste0(
      \"ct_value = \",
      intercept,
      \" + \",
      slope,
      \" × log10_concentration\\n\",
      \"R² = \",
      r2
    )
  ) +
  theme_minimal()"
          )
        ),
        
        
        actionButton(
          "run45",
          "▶ RUN CODE"
        )
      ),
      
      
      div(
        class = "console",
        
        h3("Console"),
        
        uiOutput("console45_ui"),
        
        plotOutput(
          "plot45",
          height = "300px"
        ),
        
        uiOutput("next_ui45")
      )
    )
  )
}


level4_5_server <- function(input, output, session, current_page) {
  
  output$console45_ui <- renderUI({
    NULL
  })
  
  
  observeEvent(input$run45, {
    
    req(input$reg_choice)
    
    
    if (input$reg_choice == "lm") {
      
      session$sendCustomMessage("greenFlash", TRUE)
      
      
      model <- lm(
        ct_value ~ log10_concentration,
        data = dna_ct_clean
      )
      
      intercept <- round(
        coef(model)[1],
        3
      )
      
      slope <- round(
        coef(model)[2],
        3
      )
      
      r2 <- round(
        summary(model)$r.squared,
        3
      )
      
      
      subtitle_text <- paste0(
        "ct_value = ",
        intercept,
        " + ",
        slope,
        " × log10_concentration\n",
        "R² = ",
        r2
      )
      
      
      output$console45_ui <- renderUI({
        
        div(
          class = "console-message success",
          
          verbatimTextOutput(
            "console45",
            placeholder = FALSE
          )
        )
      })
      
      
      output$console45 <- renderText({
        
        paste0(
          "✔ Correct!\n",
          "Regressielijn toegevoegd met method = 'lm'.\n\n",
          "Formule:\n",
          subtitle_text
        )
      })
      
      
      output$plot45 <- renderPlot({
        
        ggplot(
          dna_ct_clean,
          aes(
            log10_concentration,
            ct_value
          )
        ) +
          geom_point(
            color = "#24bb24",
            size = 3
          ) +
          geom_smooth(
            method = "lm",
            color = "#24bb24"
          ) +
          labs(
            subtitle = subtitle_text,
            title = "Regressielijn Log10 DNA-concentraties van virus",
            x = "log10_concentration(ng/µl)",
            y = "mean_ct_value"
          ) +
          theme_minimal(
            base_family = "Courier New"
          ) +
          theme(
            plot.background = element_rect(fill = "black"),
            panel.background = element_rect(fill = "black"),
            text = element_text(color = "#24bb24"),
            axis.text = element_text(color = "#24bb24"),
            plot.subtitle = element_text(
              color = "#24bb24",
              size = 18,
              face = "bold",
              margin = margin(t = 10, b = 10)
            )
          )
      })
      
      
      output$next_ui45 <- renderUI({
        
        actionButton(
          "next_level4_6",
          "Volgende",
          class = "next-btn"
        )
      })
      
      
    } else {
      
      session$sendCustomMessage("redFlash", TRUE)
      
      
      output$console45_ui <- renderUI({
        
        div(
          class = "console-message error",
          
          verbatimTextOutput(
            "console45",
            placeholder = FALSE
          )
        )
      })
      
      
      output$console45 <- renderText({
        
        "✘ Fout.\nKies de juiste regressielijn.\n\nHint: gebruik geom_smooth(method = 'lm') voor een lineaire regressie."
        
      })
      
      
      output$plot45 <- renderPlot(NULL)
      
      
      output$next_ui45 <- renderUI(NULL)
    }
  })
  
  
  observeEvent(input$next_level4_6, {
    
    current_page("level4_6")
    
  })
}