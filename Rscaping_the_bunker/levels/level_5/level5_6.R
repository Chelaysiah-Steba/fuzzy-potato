level5_6_ui <- function() {
  fluidPage(
    useShinyjs(),
    
    tags$head(
      tags$style(HTML("
        body { background-color:#1c1c1c; color:#00FF00; font-family:'Courier New', monospace; }
        .game-container { display:flex; gap:20px; margin-top:20px; }
        .editor, .console { width:50%; padding:15px; border:2px solid #00FF00; }
        .editor { background-color:#1c1c1c; }
        .console { background-color:#000000; white-space:pre-wrap; }
        .choice-btn {
          background-color:#1c1c1c;
          color:#00FF00;
          border:2px solid #00FF00;
          padding:8px 16px;
          margin:5px 0;
          width:260px;
          text-align:left;
          font-family:'Courier New';
          cursor:pointer;
        }
        .choice-btn:hover {
          background-color:#00FF00;
          color:#1c1c1c;
        }
        .next-btn {
          margin-top:20px;
          background:#1c1c1c;
          color:#00FF00;
          border:2px solid #00FF00;
          padding:10px 20px;
          font-family:'Courier New';
          cursor:pointer;
        }
      "))
    ),
    
    div(
      class="game-container",
      
      div(
        class="editor",
        h3("📡 Level 5.6: Kies het juiste antiviral"),
        p("Op basis van de analyse uit Level 5.5 moet je nu bepalen welk antiviral het meest geschikt is."),
        p("Klik op het juiste antiviral:"),
        
        actionButton("choice_vira", "ViraBloc", class="choice-btn"),
        actionButton("choice_helix", "HelixStop", class="choice-btn"),
        actionButton("choice_capsid", "CapsidCrush", class="choice-btn"),
        actionButton("choice_fuse", "FuseAway", class="choice-btn"),
        actionButton("choice_poly", "PolymeraseX", class="choice-btn"),
        actionButton("choice_prot", "ProteaseMax", class="choice-btn"),
        actionButton("choice_break", "CapsidBreaker", class="choice-btn")
      ),
      
      div(
        class="console",
        h3("Console"),
        verbatimTextOutput("console56"),
        uiOutput("next_ui56")
      )
    )
  )
}

level5_6_server <- function(input, output, session, current_page) {
  
  output$console56 <- renderText({ "" })
  output$next_ui56 <- renderUI(NULL)
  
  # Correct answer
  correct <- "CapsidCrush"
  
  observeEvent(input$choice_capsid, {
    session$sendCustomMessage("greenFlash", TRUE)
    
    output$console56 <- renderText({
      paste0(
        "✔ Correct!\n",
        "CapsidCrush is het juiste antiviral voor deze situatie.\n",
        "Het destabiliseert de virale capsid precies zoals vereist."
      )
    })
    
    output$next_ui56 <- renderUI({
      actionButton("next_transition5_end", "Volgende", class="next-btn")
    })
  })
  
  # All incorrect answers
  lapply(
    c("choice_vira", "choice_helix", "choice_fuse", "choice_poly", "choice_prot", "choice_break"),
    function(btn) {
      observeEvent(input[[btn]], {
        session$sendCustomMessage("redFlash", TRUE)
        
        output$console56 <- renderText({
          paste0(
            "✖ Fout.\n",
            "Dit antiviral is niet geschikt.\n\n",
            "Hint: kies het middel dat de virale capsid het meest effectief destabiliseert."
          )
        })
        
        output$next_ui56 <- renderUI(NULL)
      })
    }
  )
  
  observeEvent(input$next_transition5_end, {
    current_page("end")
  })
}