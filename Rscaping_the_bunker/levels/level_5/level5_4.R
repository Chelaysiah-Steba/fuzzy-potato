antiviral_library <- data.frame(
  antiviral_name = c(
    "ViraBloc", "HelixStop", "CapsidCrush", "FuseAway", "PolymeraseX",
    "ProteaseMax", "CapsidBreaker"
  ),
  antiviral_class = c(
    "Protease Inhibitor", "RNA Polymerase Blocker", "Capsid Destabilizer",
    "Fusion Inhibitor", "RNA Polymerase Blocker",
    "Protease Inhibitor", "Capsid Destabilizer"
  ),
  stock_concentration_mg = c(
    120, 100, 180, 120, 160,
    154, 85
  )
)


level5_4_ui <- function() {
  
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
          color: #24bb24;
          white-space: pre-wrap;
        }

        .console-message {
          background-color: #000000 !important;
          color: #24bb24 !important;
          border: 2px solid #24bb24;
          padding: 10px;
          margin-top: 10px;
          min-height: 120px;
        }

        .console-message.error {
          color: #bb2424 !important;
          border-color: #bb2424;
        }

        .console-message.success {
          color: #24bb24 !important;
          border-color: #24bb24;
        }

        .console-message pre {
          background-color: #000000 !important;
          color: inherit !important;
          border: none !important;
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
        }

        .inline-input {
          display: inline-block;
          width: 260px;
          background-color: #000000;
          color: #24bb24;
          border: 2px solid #24bb24;
          font-family: 'Courier New', monospace;
          margin-left: 5px;
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

        #run_level54 {
          margin-top: 20px;
          background-color: #1c1c1c;
          color: #24bb24;
          border: 2px solid #24bb24;
          padding: 10px 20px;
          font-family: 'Courier New', monospace;
          cursor: pointer;
        }

        #run_level54:hover {
          background-color: #24bb24;
          color: #000000;
        }

      "))
    ),
    
    div(
      class = "game-container",
      
      div(
        class = "editor",
        
        h3("Level 5.4: Sorteer de balken aflopend"),
        
        p(
          "Gebruik reorder() om de x-as aflopend te sorteren op stock_concentration_mg."
        ),
        
        p("Vul de ontbrekende functies in:"),
        
        div(
          class = "code-box",
          
          HTML("antiviral_library |> "),
          
          tags$input(
            id = "ggplot_input",
            type = "text",
            class = "inline-input",
            placeholder = F
          ),
          
          HTML("(aes(x = "),
          
          selectInput(
            inputId = "reorder_input",
            label = NULL,
            choices = c(
              "reorder(antiviral_name, -stock_concentration_mg)",
              "reorder(antiviral_name, stock_concentration_mg)",
              "antiviral_name"
            ),
            selected = NULL,
            selectize = FALSE
          ),
          
          HTML(", y = stock_concentration_mg)) + "),
          
          tags$input(
            id = "geom_input",
            type = "text",
            class = "inline-input",
            placeholder = F
          ),
          
          HTML("(stat = "),
          
          tags$input(
            id = "stat_input",
            type = "text",
            class = "inline-input",
            placeholder = "\"identity\""
          ),
          
          HTML(") + geom_hline(yintercept = 150)")
        ),
        
        actionButton(
          "run_level54",
          "▶ RUN CODE"
        )
      ),
      
      div(
        class = "console",
        
        h3("Console"),
        
          uiOutput("console54_ui"),
        
        br(),
        
        plotOutput("plot54"),
        
        uiOutput("next_ui54")
      )
    )
  )
}


level5_4_server <- function(input, output, session, current_page) {
    output$console54_ui <- renderUI({
      NULL
    })
    
    
    observeEvent(input$run_level54, {
      
      req(
        input$ggplot_input,
        input$reorder_input,
        input$geom_input,
        input$stat_input
      )
      
      correct_answer <- (
        trimws(input$ggplot_input) == "ggplot" &&
          trimws(input$geom_input) == "geom_bar" &&
          trimws(input$stat_input) == "\"identity\"" &&
          trimws(input$reorder_input) ==
          "reorder(antiviral_name, -stock_concentration_mg)"
      )
      
      
      if (correct_answer) {
        
        session$sendCustomMessage("greenFlash", TRUE)
        
          output$console54_ui <- renderUI({
            
            div(
              class = "console-message success",
              
              verbatimTextOutput(
                "console54",
                placeholder = FALSE
              )
            )
          })
          
          output$console54 <- renderText({
            
            paste0(
              "✔ Correct! De balken zijn aflopend gesorteerd\n",
              "en de horizontale lijn staat op 150 mg."
            )
          })
          
          
          output$plot54 <- renderPlot({
            
            antiviral_library |>
              ggplot(
                aes(
                  x = reorder(
                    antiviral_name,
                    -stock_concentration_mg
                  ),
                  y = stock_concentration_mg
                )
              ) +
              geom_bar(
                stat = "identity",
                fill = "#24bb24"
              ) +
              geom_hline(
                yintercept = 150,
                color = "#bb2424",
                linewidth = 1.2
              ) +
              theme_minimal(
                base_family = "Courier New"
              ) +
              theme(
                plot.background = element_rect(
                  fill = "black",
                  color = "black"
                ),
                panel.background = element_rect(
                  fill = "black",
                  color = "black"
                ),
                panel.grid = element_line(
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
                )
              )
          })
          
          
          output$next_ui54 <- renderUI({
            
            actionButton(
              "next_level5_5",
              "Volgende",
              class = "next-btn"
            )
          })
          
          
      } else {
        
        session$sendCustomMessage("redFlash", TRUE)
          output$console54_ui <- renderUI({
            
            div(
              class = "console-message error",
              
              verbatimTextOutput(
                "console54",
                placeholder = FALSE
              )
            )
          })
          
          
          output$plot54 <- renderPlot({
            NULL
          })
          
          
          output$next_ui54 <- renderUI({
            NULL
          })
          
          
          output$console54 <- renderText({
            
            paste0(
              "✖ Fout.\n",
              "Je typte:\n",
              "ggplot(): ", input$ggplot_input, "\n",
              "reorder(): ", input$reorder_input, "\n",
              "geom_bar(): ", input$geom_input, "\n",
              "stat = : ", input$stat_input, "\n\n",
              "Hint: kies in de dropdown:\n",
              "reorder(antiviral_name, -stock_concentration_mg)."
            )
          })
      }
    })
    
    
    observeEvent(input$next_level5_5, {
      current_page("level5_5")
    })
}