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
    120, 100, 180, 120, 160, 155, 85
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
    "Protease Inhibitor", "Fusion Inhibitor", "Capsid Destabilizer",
    "RNA Polymerase Blocker", "Protease Inhibitor"
  ),
  concentration_required_mg = c(
    120, 90, 140, 80, 110,
    125, 160, 150, 95, 130
  )
)


level5_5_ui <- function() {
  
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
        
        /* =========================
           CONSOLE MESSAGE
           ========================= */
        
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
        
        /* =========================
           CODE BOX
           ========================= */
        
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
        
        /* =========================
           TABEL
           ========================= */
        
        .table-container {
          background-color: #000000 !important;
          border: 2px solid #24bb24;
          padding: 10px;
          margin-top: 10px;
          max-height: 300px;
          overflow-y: auto;
          overflow-x: auto;
        }
        
        .table-container .table {
          background-color: #000000 !important;
          color: #24bb24 !important;
          font-family: 'Courier New', monospace !important;
          border-collapse: collapse !important;
          margin: 0 !important;
          width: 100%;
        }
        
        .table-container .table thead {
          background-color: #1c1c1c !important;
        }
        
        .table-container .table thead th {
          background-color: #1c1c1c !important;
          color: #24bb24 !important;
          border: 1px solid #24bb24 !important;
          font-family: 'Courier New', monospace !important;
          font-weight: normal !important;
          white-space: nowrap;
          padding: 8px;
        }
        
        .table-container .table tbody {
          background-color: #000000 !important;
        }
        
        .table-container .table tbody tr {
          background-color: #000000 !important;
        }
        
        .table-container .table tbody tr:nth-child(even) {
          background-color: #000000 !important;
        }
        
        .table-container .table tbody td {
          background-color: #000000 !important;
          color: #24bb24 !important;
          border: 1px solid #333333 !important;
          font-family: 'Courier New', monospace !important;
          padding: 8px;
          white-space: nowrap;
        }
        
        .table-container .table tbody tr:hover td {
          background-color: #1c1c1c !important;
          color: #24bb24 !important;
        }
        
        /* =========================
           VOLGENDE KNOP
           ========================= */
        
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
        
        /* =========================
           RUN KNOP
           ========================= */
        
        #run_level55 {
          margin-top: 20px;
          background-color: #1c1c1c;
          color: #24bb24;
          border: 2px solid #24bb24;
          padding: 10px 20px;
          font-family: 'Courier New', monospace;
          cursor: pointer;
        }
        
        #run_level55:hover {
          background-color: #24bb24;
          color: #000000;
        }
        
      "))
    ),
    
    
    div(
      class = "game-container",
      
      div(
        class = "editor",
        
        h3("Level 5.5: Twee datasets samenvoegen met left_join()"),
        
        p(
          "Gebruik left_join() om de antiviral datasets samen te voegen adhv antiviral_class."
        ),
        
        p("Vul de ontbrekende functies in:"),
        
        div(
          class = "code-box",
          
          HTML("antiviral_library |> "),
          
          tags$input(
            id = "join_func",
            type = "text",
            class = "inline-input",
            placeholder = "functie om te joinen"
          ),
          
          HTML("(antiviral_effectiveness, "),
          
          tags$input(
            id = "join_by",
            type = "text",
            class = "inline-input",
            placeholder = "by = \"...\""
          ),
          
          HTML(")")
        ),
        
        actionButton(
          "run_level55",
          "▶ RUN CODE"
        )
      ),
      
      
      div(
        class = "console",
        
        h3("Console"),
        
        uiOutput("console55_ui"),
        
        br(),
        
        uiOutput("table55_ui"),
        
        uiOutput("next_ui55")
      )
    )
  )
}


level5_5_server <- function(input, output, session, current_page) {
  
  output$console55_ui <- renderUI({
    NULL
  })
  
  output$table55_ui <- renderUI({
    NULL
  })
  
  
  observeEvent(input$run_level55, {
    
    req(
      input$join_func,
      input$join_by
    )
    
    
    correct_answer <- (
      trimws(input$join_func) == "left_join" &&
        trimws(input$join_by) == "by = \"antiviral_class\""
    )
    
    
    if (correct_answer) {
      
      session$sendCustomMessage("greenFlash", TRUE)
      
      
      result <- antiviral_library |>
        left_join(
          antiviral_effectiveness,
          by = "antiviral_class"
        )
      
      
        
        output$console55_ui <- renderUI({
          
          div(
            class = "console-message success",
            
            verbatimTextOutput(
              "console55",
              placeholder = FALSE
            )
          )
        })
      
      
      output$console55 <- renderText({
        
        paste0(
          "✔ Correct!\n",
          "Je hebt de datasets succesvol samengevoegd met left_join()."
        )
      })
      
        
        output$table55_ui <- renderUI({
          
          div(
            class = "table-container",
            
            tableOutput("table55")
          )
        })
      
      
      output$table55 <- renderTable({
        result
      })
      
        
        output$next_ui55 <- renderUI({
          
          actionButton(
            "next_level5_6",
            "Volgende",
            class = "next-btn"
          )
        })
      
      
    } else {
      
      session$sendCustomMessage("redFlash", TRUE)
      
        
        output$table55_ui <- renderUI({
          NULL
        })
        
          
          output$console55_ui <- renderUI({
            
            div(
              class = "console-message error",
              
              verbatimTextOutput(
                "console55",
                placeholder = FALSE
              )
            )
          })
          
          
          output$console55 <- renderText({
            
            paste0(
              "✖ Fout.\n",
              "Je typte:\n",
              "left_join(): ", input$join_func, "\n",
              "by = : ", input$join_by, "\n\n",
              "Hint: de functie heet left_join en het join-argument is by = \"antiviral_class\"."
            )
          })
          
          
          output$next_ui55 <- renderUI({
            NULL
          })
    }
  })
  
  
  observeEvent(input$next_level5_6, {
    current_page("level5_6")
  })
}