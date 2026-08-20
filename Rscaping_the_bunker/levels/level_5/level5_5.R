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
    155, 85
  )
)

level5_5_ui <- function() {
  fluidPage(
    useShinyjs(),
    tags$head(
      tags$style(HTML("
        body { background-color: #1c1c1c; color: #00FF00; font-family: 'Courier New', monospace; }
        .game-container { display: flex; gap: 20px; margin-top: 20px; }
        .editor, .console { width: 50%; padding: 15px; border: 2px solid #00FF00; font-family: 'Courier New', monospace; }
        .editor { background-color: #1c1c1c; }
        .console { background-color: #000000; white-space: pre-wrap; }
        .code-box { background-color: #000000; border: 2px solid #00FF00; padding: 10px; margin-top: 10px; }
        .inline-input { display: inline-block; width: 260px; background-color: #000000; color: #00FF00; border: 2px solid #00FF00; font-family: 'Courier New', monospace; margin-left: 5px; }
        .next-btn { margin-top: 20px; background: #1c1c1c; color: #00FF00; border: 2px solid #00FF00; padding: 10px 20px; font-family: 'Courier New'; cursor: pointer; }
      "))
    ),
    div(class = "game-container",
        div(class = "editor",
            h3("📉 Level 5.5: Sorteer de balken aflopend"),
            p("Gebruik reorder() om de x-as aflopend te sorteren op stock_concentration_mg."),
            p("Vul de ontbrekende functies in:"),
            div(class = "code-box",
                HTML("antiviral_library |> "),
                tags$input(id = "ggplot_input", type = "text", class = "inline-input", placeholder = "ggplot"),
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
                tags$input(id = "geom_input", type = "text", class = "inline-input", placeholder = "geom_bar"),
                HTML("(stat = "),
                tags$input(id = "stat_input", type = "text", class = "inline-input", placeholder = "\"identity\""),
                HTML(") + geom_hline(yintercept = 150)")
            ),
            actionButton("run_level55", "▶ RUN CODE")
        ),
        div(class = "console",
            h3("Console"),
            verbatimTextOutput("console55"),
            br(),
            plotOutput("plot55"),
            uiOutput("next_ui55")
        )
    )
  )
}

level5_5_server <- function(input, output, session, current_page) {
  observeEvent(input$run_level55, {
    req(input$ggplot_input, input$reorder_input, input$geom_input, input$stat_input)
    
    if (trimws(input$ggplot_input) == "ggplot" &&
        trimws(input$geom_input) == "geom_bar" &&
        trimws(input$stat_input) == "\"identity\"" &&
        trimws(input$reorder_input) == "reorder(antiviral_name, -stock_concentration_mg)") {
      session$sendCustomMessage("greenFlash", TRUE)
      output$console55 <- renderText("✔ Correct! De balken zijn aflopend gesorteerd en de horizontale lijn staat op 150 mg.")
      output$plot55 <- renderPlot({
        antiviral_library |>
          ggplot(aes(
            x = reorder(antiviral_name, -stock_concentration_mg),
            y = stock_concentration_mg
          )) +
          geom_bar(stat = "identity", fill = "#24bb24") +
          geom_hline(yintercept = 150, color = "#bb2424", linewidth = 1.2) +
          theme_minimal(base_family = "Courier New") +
          theme(
            plot.background = element_rect(fill = "black"),
            panel.background = element_rect(fill = "black"),
            text = element_text(color = "#00FF00"),
            axis.text = element_text(color = "#00FF00"),
            axis.title = element_text(color = "#00FF00")
          )
      })
      output$next_ui55 <- renderUI({
        actionButton("next_level5_6", "Volgende", class = "next-btn")
      })
    } else {
      session$sendCustomMessage("redFlash", TRUE)
      output$plot55 <- renderPlot({ NULL })
      output$next_ui55 <- renderUI({ NULL })
      output$console55 <- renderText({
        paste0(
          "✖ Fout.\nJe typte:\n",
          "ggplot(): ", input$ggplot_input, "\n",
          "reorder(): ", input$reorder_input, "\n",
          "geom_bar(): ", input$geom_input, "\n",
          "stat = : ", input$stat_input, "\n\n",
          "Hint: kies in de dropdown: reorder(antiviral_name, -stock_concentration_mg)."
        )
      })
    }
  })
  
  observeEvent(input$next_level5_6, {
    current_page("level5_6")
  })
}