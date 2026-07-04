level2_intro_server <- function(input, output, session, current_page) {
  observeEvent(current_page(), {
    req(current_page() == "level2_intro")
    
    showModal(
      modalDialog(
        title = "LEVEL 2 — Introductie",
        tagList(
          p("Tijdens het stabiliseren van het beveiligingssysteem ..."),
          p("Ruwe laboratoriumbestanden worden aangeleverd als TSV-data ..."),
          p("Na het inlezen controleer je ..."),
          p("Vervolgens worden verschillende grafieken gebruikt ..."),
          p("Tot slot moeten grafieken duidelijke titels en assenlabels bevatten ..."),
          br(),
          tags$b("Activeer alle vier beveiligingsmodules om toegang te krijgen tot de volgende onderzoeksruimte.")
        ),
        footer = tagList(
          actionButton("continue_level2", "Doorgaan", class = "start-btn")
        ),
        easyClose = FALSE,
        size = "l"
      )
    )
  }, ignoreInit = TRUE)
  
  observeEvent(input$continue_level2, {
    removeModal()
    current_page("level2_1")
  })
}