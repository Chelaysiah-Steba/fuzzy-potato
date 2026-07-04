antiviral_effectiveness <- data.frame(
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
    100, 150, 180, 120, 160,
    130, 190
  )
)

level5_1_ui <- function() {
  fluidPage(
    useShinyjs(),
    tags$head(
      tags$style(HTML("
        body { background-color: #1c1c1c; color: #00FF00; font-family: 'Courier New', monospace; }
        .game-container { display: flex; gap: 20px; margin-top: 20px; }
        .editor, .console { width: 50%; padding: 15px; font-family: 'Courier New', monospace; border: 2px solid #00FF00; text-align: left; }
        .editor { background-color: #1c1c1c; min-height: 200px; }
        .console { background-color: #000000; min-height: 200px; white-space: pre-wrap; }
        .code-box { background-color: #000000; border: 2px solid #00FF00; padding: 10px; margin-top: 10px; }
        .inline-input { display: inline-block; width: 260px; background-color: #000000; color: #00FF00; border: 2px solid #00FF00; font-family: 'Courier New', monospace; margin-left: 5px; }
        .next-btn { margin-top: 20px; background: #1c1c1c; color: #00FF00; border: 2px solid #00FF00; padding: 10px 20px; font-family: 'Courier New'; cursor: pointer; }
      "))
    ),
    div(class = "game-container",
        div(class = "editor",
            h3("📂 Level 5.1: Antiviral datasets inladen"),
            p("Laad de volgende twee bestanden in:"),
            tags$ul(
              tags$li("antiviral_effectiveness.xlsx"),
              tags$li("antiviral_library.xlsx")
            ),
            p("Typ beide functies volledig:"),
            div(class = "code-box",
                HTML("antiviral_effectiveness_dataset <- "),
                tags$input(id = "excel_input_1", type = "text", class = "inline-input")
            ),
            div(class = "code-box",
                HTML("antiviral_library_dataset <- "),
                tags$input(id = "excel_input_2", type = "text", class = "inline-input")
            ),
            actionButton("submit_excel", "▶ RUN CODE")
        ),
        div(class = "console",
            h3("Console"),
            verbatimTextOutput("excel_console"),
            br(),
            uiOutput("effectiveness_table"),
            br(),
            uiOutput("library_table"),
            uiOutput("next_ui51")
        )
    )
  )
}

level5_1_server <- function(input, output, session, current_page) {
  observeEvent(input$submit_excel, {
    req(input$excel_input_1, input$excel_input_2)
    
    clean1 <- trimws(input$excel_input_1)
    clean2 <- trimws(input$excel_input_2)
    
    correct1 <- "read_excel(\"antiviral_effectiveness.xlsx\")"
    correct2 <- "read_excel(\"antiviral_library.xlsx\")"
    
    if (clean1 == correct1 && clean2 == correct2) {
      session$sendCustomMessage("greenFlash", TRUE)
      output$excel_console <- renderText("✔ Correct!\nBeide bestanden zijn succesvol geladen.")
      output$effectiveness_table <- renderUI({
        tagList(h3("📊 antiviral_effectiveness dataset:"), tableOutput("effectiveness_table_data"))
      })
      output$library_table <- renderUI({
        tagList(h3("📚 antiviral_library dataset:"), tableOutput("library_table_data"))
      })
      output$effectiveness_table_data <- renderTable({ antiviral_effectiveness })
      output$library_table_data <- renderTable({ antiviral_library })
      output$next_ui51 <- renderUI({
        actionButton("next_level5_2", "Volgende", class = "next-btn")
      })
    } else {
      session$sendCustomMessage("redFlash", TRUE)
      output$effectiveness_table <- renderUI({ NULL })
      output$library_table <- renderUI({ NULL })
      output$next_ui51 <- renderUI({ NULL })
      output$excel_console <- renderText({
        paste0(
          "✖ Fout.\nJe typte:\n",
          "effectiveness: ", input$excel_input_1, "\n",
          "library: ", input$excel_input_2, "\n\n",
          "Hint: Gebruik de hele functie, en vergeet de aanhalingstekens én de .xlsx extensie niet."
        )
      })
    }
  })
  
  observeEvent(input$next_level5_2, {
    current_page("level5_2")
  })
}