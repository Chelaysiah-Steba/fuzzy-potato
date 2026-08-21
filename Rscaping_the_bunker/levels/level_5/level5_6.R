level5_6_ui <- function() {
  
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
          align-items: flex-start;
        }

        .editor,
        .console {
          width: 50%;
          padding: 15px;
          border: 2px solid #24bb24;
          font-family: 'Courier New', monospace;
          box-sizing: border-box;
        }

        .editor {
          background-color: #1c1c1c;
        }

        .console {
          background-color: #000000;
          color: #24bb24;
          min-height: 900px;
          max-height: 95vh;
          overflow-y: auto;
          box-sizing: border-box;
        }

        .console h3 {
          color: #24bb24;
          margin-top: 0;
        }

        .console-section-title {
          color: #24bb24;
          font-weight: bold;
          margin-top: 20px;
          margin-bottom: 10px;
        }

        .console-message {
          background-color: #000000 !important;
          color: #24bb24 !important;
          border: 2px solid #24bb24;
          padding: 10px;
          margin-top: 20px;
          min-height: 120px;
        }

        .console-message.success {
          color: #24bb24 !important;
          border-color: #24bb24;
        }

        .console-message.error {
          color: #bb2424 !important;
          border-color: #bb2424;
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

        #plot56 {
          width: 100%;
          min-height: 420px;
          margin-bottom: 25px;
        }

        #table56 {
          width: 100%;
          overflow-x: auto;
          margin-bottom: 20px;
        }

        #table56 table {
          width: 100%;
          border-collapse: collapse;
          background-color: #000000 !important;
          color: #24bb24 !important;
          font-family: 'Courier New', monospace;
          font-size: 12px;
        }

        #table56 th {
          background-color: #1c1c1c !important;
          color: #24bb24 !important;
          border: 1px solid #24bb24 !important;
          padding: 6px;
          text-align: left;
        }

        #table56 td {
          background-color: #000000 !important;
          color: #24bb24 !important;
          border: 1px solid #24bb24 !important;
          padding: 6px;
          text-align: left;
        }

        #table56 tr:nth-child(even) td {
          background-color: #101010 !important;
        }

        .choice-btn {
          display: block;
          background-color: #1c1c1c;
          color: #24bb24;
          border: 2px solid #24bb24;
          padding: 8px 16px;
          margin: 5px 0;
          width: 260px;
          text-align: left;
          font-family: 'Courier New', monospace;
          cursor: pointer;
        }

        .choice-btn:hover {
          background-color: #24bb24;
          color: #1c1c1c;
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

      "))
    ),
    
    div(
      class = "game-container",
      
      div(
        class = "editor",
        
        h3("Level 5.6: Kies het juiste antiviral"),
        
        p(
          "Op basis van de analyse uit Level 5.5 moet je nu bepalen welk antiviral het meest geschikt is."
        ),
        
        p(
          "Bekijk de grafiek en de tabel in de console."
        ),
        
        p(
          "Klik daarna op het juiste antiviral:"
        ),
        
        actionButton(
          "choice_vira",
          "ViraBloc",
          class = "choice-btn"
        ),
        
        actionButton(
          "choice_helix",
          "HelixStop",
          class = "choice-btn"
        ),
        
        actionButton(
          "choice_capsid",
          "CapsidCrush",
          class = "choice-btn"
        ),
        
        actionButton(
          "choice_fuse",
          "FuseAway",
          class = "choice-btn"
        ),
        
        actionButton(
          "choice_poly",
          "PolymeraseX",
          class = "choice-btn"
        ),
        
        actionButton(
          "choice_prot",
          "ProteaseMax",
          class = "choice-btn"
        ),
        
        actionButton(
          "choice_break",
          "CapsidBreaker",
          class = "choice-btn"
        )
      ),
      
      div(
        class = "console",
        
        h3("Console"),
        
        uiOutput("console_content56"),
        
        uiOutput("next_ui56")
      )
    )
  )
}


level5_6_server <- function(input, output, session, current_page) {
  
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
      "Livo-01", "CrimsonFlu", "Sperion Spore", "Remnox-05",
      "Siah-V Complex", "Subel-X", "SilentMoth", "Avron Pathogen",
      "Solaris-7", "HollowFang"
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
  
  
  joined_data <- antiviral_library |>
    left_join(
      antiviral_effectiveness,
      by = "antiviral_class"
    )
  
  
  # De beginweergave met grafiek en tabel.
  output$console_content56 <- renderUI({
    
    tagList(
      
      div(
        class = "console-section-title",
        "Grafiek uit Level 5.5"
      ),
      
      plotOutput(
        "plot56",
        height = "420px"
      ),
      
      div(
        class = "console-section-title",
        "Tabel uit Level 5.3"
      ),
      
      div(
        id = "table56",
        tableOutput("table56")
      )
    )
  })
  
  
  # Grafiek uit Level 5.5.
  output$plot56 <- renderPlot({
    
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
      labs(
        x = "Antiviral",
        y = "Stock concentration (mg)"
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
        ),
        axis.text.x = element_text(
          angle = 45,
          hjust = 1,
          color = "#24bb24"
        )
      )
  })
  
  
  # Tabel uit Level 5.3.
  output$table56 <- renderTable({
    
    joined_data
    
  },
  striped = FALSE,
  bordered = TRUE,
  hover = FALSE,
  spacing = "xs",
  rownames = FALSE
  )
  
  
  output$next_ui56 <- renderUI({
    NULL
  })
  
  
  # Correct antwoord.
  observeEvent(input$choice_capsid, {
    
    session$sendCustomMessage("greenFlash", TRUE)
    
    # Grafiek en tabel verdwijnen.
    output$console_content56 <- renderUI({
      
      div(
        class = "console-message success",
        
        verbatimTextOutput(
          "console56",
          placeholder = FALSE
        )
      )
    })
    
    
    output$console56 <- renderText({
      
      paste0(
        "✔ Correct!\n",
        "CapsidCrush is het juiste antiviral voor deze situatie.\n",
        "Het destabiliseert de virale capsid precies zoals vereist."
      )
    })
    
    
    output$next_ui56 <- renderUI({
      
      actionButton(
        "next_transition5_end",
        "Volgende",
        class = "next-btn"
      )
    })
  })
  
  
  # Alle foute antwoorden.
  lapply(
    c(
      "choice_vira",
      "choice_helix",
      "choice_fuse",
      "choice_poly",
      "choice_prot",
      "choice_break"
    ),
    function(btn) {
      
      observeEvent(input[[btn]], {
        
        session$sendCustomMessage("redFlash", TRUE)
        
        # Grafiek en tabel verdwijnen.
        output$console_content56 <- renderUI({
          
          div(
            class = "console-message error",
            
            verbatimTextOutput(
              "console56",
              placeholder = FALSE
            )
          )
        })
        
        
        output$console56 <- renderText({
          
          paste0(
            "✖ Fout.\n",
            "Dit antiviral is niet geschikt.\n\n",
            "Hint: kies het middel dat de virale capsid ",
            "het meest effectief destabiliseert."
          )
        })
        
        
        output$next_ui56 <- renderUI({
          
          actionButton(
            "retry_level56",
            "Probeer opnieuw",
            class = "retry-btn"
          )
        })
      })
    }
  )
  
  
  # Met deze knop verschijnen grafiek en tabel opnieuw.
  observeEvent(input$retry_level56, {
    
    output$console_content56 <- renderUI({
      
      tagList(
        
        div(
          class = "console-section-title",
          "Antiviral grafiek"
        ),
        
        plotOutput(
          "plot56",
          height = "420px"
        ),
        
        div(
          class = "console-section-title",
          "Antiviral tabel"
        ),
        
        div(
          id = "table56",
          tableOutput("table56")
        )
      )
    })
    
    
    output$next_ui56 <- renderUI({
      NULL
    })
  })
  
  
  observeEvent(input$next_transition5_end, {
    current_page("end")
  })
}