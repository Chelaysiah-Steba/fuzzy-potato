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
  stock_concentration_mg = c(100, 150, 180, 120, 160, 130, 190)
)

level5_3_ui <- function() {
  fluidPage(
    useShinyjs(),
    tags$head(
      tags$style(HTML("
        body { background-color: #1c1c1c; color: #24bb24; font-family: 'Courier New', monospace; }
        .game-container { display: flex; gap: 20px; margin-top: 20px; }
        .editor, .console { width: 50%; padding: 15px; border: 2px solid #24bb24; font-family: 'Courier New', monospace; }
        .editor { background-color: #1c1c1c; }
        .console { background-color: #000000; white-space: pre-wrap; }
        .console-message { background-color: #000000 !important; color: #24bb24 !important;
        border: 2px solid #24bb24; padding: 10px; margin-top: 10px; min-height: 120px }
        .console-message.error { color: #bb2424 !important; border-color: #bb2424; }
        .console-message.success { color: #24bb24 !important; border-color: #24bb24; }
        .console-message pre { background-color: #000000 !important; color: inherit !important;
        border: none !important; box-shadow: none !important; padding: 0 !important;
        margin: 0 !important; font-family: 'Courier New', monospace !important; white-space: pre-wrap !important; }
        .code-box { background-color: #000000; border: 2px solid #24bb24; padding: 10px; margin-top: 10px; }
        .inline-input { display: inline-block; width: 260px; background-color: #000000; color: #24bb24; border: 2px solid #24bb24; font-family: 'Courier New', monospace; margin-left: 5px; }
        .next-btn { margin-top: 20px; background: #1c1c1c; color: #24bb24; border: 2px solid #24bb24; padding: 10px 20px; font-family: 'Courier New'; cursor: pointer; }
      "))
    ),
    div(class = "game-container",
        div(class = "editor",
            h3("Level 5.3: Staafdiagram met horizontale lijn"),
            p("Gebruik ggplot() en geom_bar() om een staafdiagram te maken van de stock_concentration_mg per antiviral_name."),
            p("Vul de ontbrekende functies in:"),
            div(class = "code-box",
                HTML("antiviral_library |> "),
                tags$input(id = "ggplot_input", type = "text", class = "inline-input", placeholder = "ggplot"),
                HTML("(aes(x = antiviral_name, y = stock_concentration_mg)) + "),
                tags$input(id = "geom_input", type = "text", class = "inline-input", placeholder = "geom_bar"),
                HTML("(stat = "),
                tags$input(id = "stat_input", type = "text", class = "inline-input", placeholder = "\"identity\""),
                HTML(") + geom_hline(yintercept = 150)")
            ),
            actionButton("run_level53", "▶ RUN CODE")
        ),
        div(class = "console",
            h3("Console"),
            uiOutput("console53_ui"),
            br(),
            plotOutput("plot53"),
            uiOutput("next_ui53")
        )
    )
  )
}

level5_3_server <- function(input, output, session, current_page) {
  
  output$console53_ui <- renderUI({
    NULL
  })
  
  
  observeEvent(input$run_level53, {
    
    req(
      input$ggplot_input,
      input$geom_input,
      input$stat_input
    )
    
    
    if (
      trimws(input$ggplot_input) == "ggplot" &&
      trimws(input$geom_input) == "geom_bar" &&
      trimws(input$stat_input) == "\"identity\""
    ) {
      
      session$sendCustomMessage("greenFlash", TRUE)
      
      
      output$console53_ui <- renderUI({
        div(
          class = "console-message success",
          
          verbatimTextOutput(
            "console53",
            placeholder = FALSE
          )
        )
      })
      
      
      output$console53 <- renderText({
        "✔ Correct!\nJe hebt een staafdiagram gemaakt met een horizontale lijn op 150 mg."
      })
      
      
      output$plot53 <- renderPlot({
        
        antiviral_library |>
          ggplot(
            aes(
              x = antiviral_name,
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
            ),
            axis.title = element_text(
              color = "#24bb24"
            )
          )
      })
      
      
      output$next_ui53 <- renderUI({
        actionButton(
          "next_level5_4",
          "Volgende",
          class = "next-btn"
        )
      })
      
      
    } else {
      
      session$sendCustomMessage("redFlash", TRUE)
      
      
      output$console53_ui <- renderUI({
        div(
          class = "console-message error",
          
          verbatimTextOutput(
            "console53",
            placeholder = FALSE
          )
        )
      })
      
      
      output$console53 <- renderText({
        paste0(
          "✖ Fout.\n",
          "Je typte:\n",
          "ggplot(): ", input$ggplot_input, "\n",
          "geom_bar(): ", input$geom_input, "\n",
          "stat = : ", input$stat_input, "\n\n",
          "Hint: gebruik ggplot, geom_bar en stat = \"identity\"."
        )
      })
      
      
      output$plot53 <- renderPlot({
        NULL
      })
      
      
      output$next_ui53 <- renderUI({
        NULL
      })
    }
  })
  
  
  observeEvent(input$next_level5_4, {
    current_page("level5_4")
  })
}