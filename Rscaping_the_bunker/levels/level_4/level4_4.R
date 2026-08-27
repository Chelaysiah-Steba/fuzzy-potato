dna_ct_clean <- data.frame(
  log10_concentration = c(
    rep(1.2, 3),
    rep(1.5, 3),
    rep(1.8, 3),
    rep(2.0, 3),
    rep(2.3, 3),
    rep(2.6, 3),
    rep(2.9, 3),
    rep(3.1, 3),
    rep(3.4, 3),
    rep(3.7, 3)
  ),
  repeats = rep(1:3, 10),
  ct_value = c(
    33.1, 33.2, 33.0,
    31.8, 31.8, NA,
    30.2, 30.0, 30.4,
    29.0, 30.3, 28.0,
    27.5, 27.3, 27.2,
    26.1, 26.5, 26.0,
    24.8, 24.5, 24.6,
    23.9, 23.6, 24.0,
    22.4, 22.5, 22.4,
    21.0, 20.8, 21.9
  )
)


level4_4_ui <- function() {
  
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
          font-family: 'Courier New', monospace;
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
          color: #24bb24;
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
          border: 2px solid #24bb24;
          padding: 10px;
          margin-top: 10px;
          font-family: 'Courier New', monospace;
          line-height: 1.8;
        }
        
        .inline-input {
          display: inline-block;
          width: 220px;
          background-color: #000000;
          color: #24bb24;
          border: 2px solid #24bb24;
          font-family: 'Courier New', monospace;
          margin-left: 5px;
          margin-right: 5px;
        }
        
        input {
          background-color: #000000 !important;
          color: #24bb24 !important;
          border: 2px solid #24bb24 !important;
          font-family: 'Courier New', monospace !important;
        }
        
        select {
          background-color: #000000 !important;
          color: #24bb24 !important;
          border: 2px solid #24bb24 !important;
          font-family: 'Courier New', monospace !important;
        }
        
        .form-control {
          background-color: #000000 !important;
          color: #24bb24 !important;
          border: 2px solid #24bb24 !important;
        }
        
        .next-btn,
        .retry-btn {
          margin-top: 20px;
          background: #1c1c1c;
          color: #24bb24;
          border: 2px solid #24bb24;
          padding: 10px 20px;
          font-family: 'Courier New', monospace;
          cursor: pointer;
        }
        
        .next-btn:hover,
        .retry-btn:hover {
          background-color: #24bb24;
          color: #000000;
        }
        
        #run44 {
          margin-top: 20px;
          background-color: #1c1c1c;
          color: #24bb24;
          border: 2px solid #24bb24;
          padding: 10px 20px;
          font-family: 'Courier New', monospace;
          cursor: pointer;
        }
        
        #run44:hover {
          background-color: #24bb24;
          color: #000000;
        }
        
      "))
    ),
    
    
    div(
      class = "game-container",
      
      
      div(
        class = "editor",
        
        h3("Level 4.4: Maak een scatterplot van de opgeschoonde dataset"),
        
        p(
          "Maak een scatterplot waarin de log10-concentratie \nwordt uitgezet tegen de CT-waarde."
        ),
        
        
        div(
          class = "code-box",
          
          HTML(
            "
dna_ct_clean |&gt;<br>
ggplot(<br>
&nbsp;&nbsp;aes(<br>
&nbsp;&nbsp;&nbsp;&nbsp;x = "
          ),
          
          tags$input(
            id = "x_input44",
            type = "text",
            class = "inline-input",
            placeholder = F
          ),
          
          HTML(
            ",<br>
&nbsp;&nbsp;&nbsp;&nbsp;y = "
          ),
          
          tags$input(
            id = "y_input44",
            type = "text",
            class = "inline-input",
            placeholder = F
          ),
          
          HTML(
            "<br>
&nbsp;&nbsp;)<br>
) + "
          ),
          
          selectInput(
            "geom_choice44",
            NULL,
            choices = c(
              "geom_point()" = "geom_point()",
              "geom_line()" = "geom_line()",
              "geom_bar()" = "geom_bar()"
            ),
            width = "220px",
            selectize = FALSE
          ),
          
          HTML(
            "<br>
+ theme_minimal()
"
          )
        ),
        
        
        actionButton(
          "run44",
          "▶ RUN CODE"
        )
      ),
      
      
      div(
        class = "console",
        
        h3("Console"),
        
        uiOutput("console44_ui"),
        
        plotOutput(
          "plot44",
          height = "300px"
        ),
        
        uiOutput("next_ui44")
      )
    )
  )
}


level4_4_server <- function(input, output, session, current_page) {
  
  output$console44_ui <- renderUI({
    NULL
  })
  
  
  output$next_ui44 <- renderUI({
    NULL
  })
  
  
  observeEvent(input$run44, {
    
    req(
      input$x_input44,
      input$y_input44,
      input$geom_choice44
    )
    
    
    correct_x <- trimws(input$x_input44) == "log10_concentration"
    correct_y <- trimws(input$y_input44) == "ct_value"
    correct_geom <- input$geom_choice44 == "geom_point()"
    
    
    if (correct_x && correct_y && correct_geom) {
      
      session$sendCustomMessage("greenFlash", TRUE)
      
      
      output$console44_ui <- renderUI({
        
        div(
          class = "console-message success",
          
          verbatimTextOutput(
            "console44",
            placeholder = FALSE
          )
        )
      })
      
      
      output$console44 <- renderText({
        
        paste0(
          "✔ Correct!\n",
          "Scatterplot gemaakt met opgeschoonde dataset.\n\n",
          "Volledige code:\n\n",
          "ggplot(dna_ct_clean,\n",
          "       aes(x = log10_concentration,\n",
          "           y = ct_value)) +\n",
          "  geom_point() +\n",
          "  theme_minimal()"
        )
      })
      
      
      output$plot44 <- renderPlot({
        
        stats <- dna_ct_clean |>
          group_by(log10_concentration) |>
          summarise(
            mean = mean(ct_value, na.rm = TRUE),
            sd = sd(ct_value, na.rm = TRUE)
          )
        
        
        ggplot(
          stats,
          aes(
            x = log10_concentration,
            y = mean
          )
        ) +
          geom_errorbar(
            aes(
              ymin = mean - sd,
              ymax = mean + sd
            ),
            color = "#FF5CAD",
            width = 0.12,
            linewidth = 1.2
          ) +
          geom_point(
            color = "#24bb24",
            size = 4
          ) +
          theme_minimal(
            base_family = "Courier New"
          ) +
          labs(
            title = "Regressielijn Log10 DNA-concentraties van virus",
            x = "log10_concentration (ng/µl)",
            y = "mean_ct_value"
          ) +
          theme(
            plot.background = element_rect(
              fill = "black"
            ),
            panel.background = element_rect(
              fill = "black"
            ),
            text = element_text(
              color = "#24bb24"
            ),
            axis.text = element_text(
              color = "#24bb24"
            )
          )
      })
      
      
      output$next_ui44 <- renderUI({
        
        actionButton(
          "next_level4_5",
          "Volgende",
          class = "next-btn"
        )
      })
      
      
    } else {
      
      session$sendCustomMessage("redFlash", TRUE)
      
      
      output$console44_ui <- renderUI({
        
        div(
          class = "console-message error",
          
          verbatimTextOutput(
            "console44",
            placeholder = FALSE
          )
        )
      })
      
      
      output$console44 <- renderText({
        
        paste0(
          "✖ Fout.\n",
          "Alle drie velden moeten correct zijn.\n\n",
          "Hints:\n",
          "X = log10_concentration\n",
          "Y = ct_value\n",
          "Gebruik geom_point() voor een scatterplot."
        )
      })
      
      
      output$plot44 <- renderPlot({
        NULL
      })
      
      
      output$next_ui44 <- renderUI({
        NULL
      })
    }
  })
  
  
  observeEvent(input$next_level4_5, {
    
    current_page("level4_5")
    
  })
}