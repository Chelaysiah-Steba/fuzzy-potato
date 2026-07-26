antiviral_effectiveness_dataset <- data.frame(
  virus = c(
    "Livo-01", "CrimsonFlu", "Sperion Spore", "Remnox-05", "Siah-V Complex",
    "Subel-X", "SilentMoth", "Avron Pathogen", "Solaris-7", "HollowFang"
  ),
  antiviral_class = c(
    "Protease Inhibitor", "RNA Polymerase Blocker", "Capsid Destabilizer",
    "Fusion Inhibitor", "RNA Polymerase Blocker",
    "Protease Inhibitor", "Capsid Destabilizer",
    "Fusion Inhibitor", "RNA Polymerase Blocker", "Protease Inhibitor"
  ),
  concentration_required_mg = c(
    120, 90, 150, 80, 110,
    140, 160, 100, 95, 130
  )
)

level5_2_ui <- function() {
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
        .inline-input { display: inline-block; width: 200px; background-color: #000000; color: #00FF00; border: 2px solid #00FF00; font-family: 'Courier New', monospace; margin-left: 5px; }
        .next-btn { margin-top: 20px; background: #1c1c1c; color: #00FF00; border: 2px solid #00FF00; padding: 10px 20px; font-family: 'Courier New'; cursor: pointer; }
      "))
    ),
    div(class = "game-container",
        div(class = "editor",
            h3("🧪 Level 5.2: Unieke antivirale klassen tellen"),
            p("Gebruik distinct() en count() om te bepalen hoeveel unieke antivirale klassen er zijn."),
            p("Vul de ontbrekende functies in:"),
            div(class = "code-box",
                HTML("antiviral_effectiveness_dataset |> "),
                tags$input(id = "distinct_input", type = "text", class = "inline-input", placeholder = "functie voor unieke waarden"),
                HTML("(antiviral_class) |> "),
                tags$input(id = "count_input", type = "text", class = "inline-input", placeholder = "functie om te tellen"),
                HTML("(antiviral_class)")
            ),
            actionButton("run_level52", "▶ RUN CODE")
        ),
        div(class = "console",
            h3("Console"),
            verbatimTextOutput("console52"),
            br(),
            tableOutput("table52"),
            uiOutput("next_ui52")
        )
    )
  )
}

level5_2_server <- function(input, output, session, current_page) {
  observeEvent(input$run_level52, {
    req(input$distinct_input, input$count_input)
    
    if (trimws(input$distinct_input) == "distinct" && trimws(input$count_input) == "count") {
      session$sendCustomMessage("greenFlash", TRUE)
      result <- antiviral_effectiveness_dataset |>
        distinct(antiviral_class) |>
        count(antiviral_class)
      
      output$console52 <- renderText("✔ Correct!\nJe hebt de unieke antivirale klassen geteld.")
      output$table52 <- renderTable({ result })
      output$next_ui52 <- renderUI({
        actionButton("next_level5_3", "Volgende", class = "next-btn")
      })
    } else {
      session$sendCustomMessage("redFlash", TRUE)
      output$table52 <- renderTable({ NULL })
      output$next_ui52 <- renderUI({ NULL })
      output$console52 <- renderText({
        paste0(
          "✖ Fout.\nJe typte:\n",
          "distinct(): ", input$distinct_input, "\n",
          "count(): ", input$count_input, "\n\n",
          "Hint: beide functies bestaan in dplyr en hebben geen aanhalingstekens nodig."
        )
      })
    }
  })
  
  observeEvent(input$next_level5_3, {
    current_page("level5_3")
  })
}