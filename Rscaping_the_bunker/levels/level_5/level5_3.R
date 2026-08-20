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

antiviral_effectiveness <- data.frame(
  virus = c(
    "Livo-01", "CrimsonFlu", "Sperion Spore", "Remnox-05", "Siah-V Complex",
    "Subel-X", "SilentMoth", "Avron Pathogen", "Solaris-7", "HollowFang"
  ),
  antiviral_class = c(
    "Protease Inhibitor", "RNA Polymerase Blocker", "Fusion Inhibitor",
    "Capsid Destabilizer", "RNA Polymerase Blocker",
    "Protease Inhibitor","Fusion Inhibitor", "Capsid Destabilizer", "RNA Polymerase Blocker", "Protease Inhibitor"
  ),
  concentration_required_mg = c(
    120, 90, 140, 80, 110,
    125, 160, 150, 95, 130
  )
)

level5_3_ui <- function() {
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
            h3("🧬 Level 5.3: Twee datasets samenvoegen met left_join()"),
            p("Gebruik left_join() om de antiviral datasets samen te voegen adhv antiviral_class."),
            p("Vul de ontbrekende functies in:"),
            div(class = "code-box",
                HTML("antiviral_library |> "),
                tags$input(id = "join_func", type = "text", class = "inline-input", placeholder = "functie om te joinen"),
                HTML("(antiviral_effectiveness, "),
                tags$input(id = "join_by", type = "text", class = "inline-input", placeholder = "by = \"...\""),
                HTML(")")
            ),
            actionButton("run_level53", "▶ RUN CODE")
        ),
        div(class = "console",
            h3("Console"),
            verbatimTextOutput("console53"),
            br(),
            tableOutput("table53"),
            uiOutput("next_ui53")
        )
    )
  )
}

level5_3_server <- function(input, output, session, current_page) {
  observeEvent(input$run_level53, {
    req(input$join_func, input$join_by)
    
    if (trimws(input$join_func) == "left_join" && trimws(input$join_by) == "by = \"antiviral_class\"") {
      session$sendCustomMessage("greenFlash", TRUE)
      result <- antiviral_library |>
        left_join(antiviral_effectiveness, by = "antiviral_class")
      
      output$console53 <- renderText("✔ Correct!\nJe hebt de datasets succesvol samengevoegd met left_join().")
      output$table53 <- renderTable({ result })
      output$next_ui53 <- renderUI({
        actionButton("next_level5_4", "Volgende", class = "next-btn")
      })
    } else {
      session$sendCustomMessage("redFlash", TRUE)
      output$table53 <- renderTable({ NULL })
      output$next_ui53 <- renderUI({ NULL })
      output$console53 <- renderText({
        paste0(
          "✖ Fout.\nJe typte:\n",
          "left_join(): ", input$join_func, "\n",
          "by = : ", input$join_by, "\n\n",
          "Hint: de functie heet left_join en het join-argument is by = \"antiviral_class\"."
        )
      })
    }
  })
  
  observeEvent(input$next_level5_4, {
    current_page("level5_4")
  })
}