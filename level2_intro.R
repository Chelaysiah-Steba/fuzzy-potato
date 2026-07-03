level1_intro_ui <- function() {
  div(
    class = "popup-container",
    h2("Level 1 — Intro"),
    p("Welkom bij Level 1!"),
    actionButton("go_level1_1", "Ga verder", class = "start-btn")
  )
}


level1_intro_server <- function(input, output, session, current_page) {
  observeEvent(current_page(), {
    req(current_page() == "level1_intro")
    
    showModal(
      modalDialog(
        title = "LEVEL 1 — Introductie",
        tagList(
          p("De centrale databanken blijven vergrendeld ..."),
          p("Aan jou de taak om de toegang tot de databases te herstellen."),
          br(),
          tags$b("Activeer alle drie beveiligingsmodules om toegang te krijgen tot de volgende onderzoeksruimte.")
        ),
        footer = tagList(
          actionButton("continue_level1", "Doorgaan", class = "start-btn")
        ),
        easyClose = FALSE,
        size = "l"
      )
    )
  }, ignoreInit = TRUE)
  
  observeEvent(input$continue_level1, {
    removeModal()
    current_page("level1_1")
  })
}