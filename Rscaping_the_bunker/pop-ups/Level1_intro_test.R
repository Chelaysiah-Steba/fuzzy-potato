level1_intro_test_server <- function(input, output, session, current_page) {
  
  observeEvent(input$start_game, {
    
    showModal(
      modalDialog(
        title = "LEVEL 1 — Introductie",
        
        tagList(
          
          p(
            "De centrale databanken blijven vergrendeld totdat de juiste systeemmodules zijn geactiveerd. Alleen operators die de interface kunnen initialiseren en de structuur van binnenkomende data kunnen verifiëren, krijgen toegang tot de beveiligde archieven.."
          ),
          
          p(
            "Aan jou de taak om de toegang tot de databases te herstellen."
          ),
         
          br(),
          
          tags$b(
            "Activeer alle drie beveiligingsmodules om toegang te krijgen tot de volgende onderzoeksruimte."
          )
          
        ),
        
        footer = tagList(
          
          actionButton(
            "continue_level1",
            "Doorgaan",
            class = "start-btn"
          )
          
        ),
        
        easyClose = FALSE,
        size = "l"
      )
    )
    
  })
  
  observeEvent(input$continue_level1, {
    
    removeModal()
    
    current_page("level1_1")
    
  })
  
}