level2_intro_server <- function(input, output, session, current_page) {
  
  observeEvent(input$start_game, {
    
    showModal(
      modalDialog(
        title = "LEVEL 2 — Introductie",
        
        tagList(
          
          p(
            "Tijdens het stabiliseren van het beveiligingssysteem is vastgesteld dat correcte data-invoer essentieel is."
          ),
          
          p(
            "Ruwe laboratoriumbestanden worden aangeleverd als TSV-data. Om deze correct in R in te lezen moeten het juiste scheidingsteken en het juiste decimaalteken worden gebruikt."
          ),
          
          p(
            "Na het inlezen controleer je of iedere variabele het juiste datatype heeft gekregen. Onjuist ingelezen gegevens kunnen leiden tot fouten tijdens de analyse."
          ),
          
          p(
            "Vervolgens worden verschillende grafieken gebruikt om de gegevens te verkennen. Een scatterplot laat de relatie tussen twee numerieke variabelen zien. Een histogram toont de verdeling van één variabele en een boxplot helpt bij het herkennen van uitschieters."
          ),
          
          p(
            "Tot slot moeten grafieken duidelijke titels en assenlabels bevatten zodat onderzoeksresultaten correct kunnen worden geïnterpreteerd."
          ),
          
          br(),
          
          tags$b(
            "Activeer alle vier beveiligingsmodules om toegang te krijgen tot de volgende onderzoeksruimte."
          )
          
        ),
        
        footer = tagList(
          
          modalButton("Sluiten"),
          
          actionButton(
            "continue_btn",
            "Start Level 2",
            class = "start-btn"
          )
          
        ),
        
        easyClose = TRUE,
        size = "l"
      )
    )
    
  })
  
  observeEvent(input$continue_btn, {
    
    removeModal()
    
    current_page("level2_1")
    
  })
  
}