transition2_3_ui <- function() {
  uiOutput("hx3_lines")
}

transition2_3_server <- function(input, output, session, current_page) {
  
  output$hx3_lines <- renderUI({
    req(current_page() == "transition2_3")
    
    tagList(
      tags$div(
        class = "landing-container",
        tags$h1(class = "game-title", "LEVEL 3"),
        tags$div(
          class = "intro-text",
          "De centrale databanken blijven vergrendeld totdat de juiste systeemmodules zijn geactiveerd.\n\nAlleen operators die de interface kunnen initialiseren en de structuur van binnenkomende data kunnen verifiëren, krijgen toegang tot de beveiligde archieven."
        ),
        actionButton("hx3_continue_btn_3", "Doorgaan", class = "start-btn")
      )
    )
  })
  
  observeEvent(input$hx3_continue_btn_3, {
    showModal(
      modalDialog(
        title = "LEVEL 3 — Introductie",
        tagList(
          p("De centrale databanken blijven vergrendeld totdat de juiste systeemmodules zijn geactiveerd. Alleen operators die de interface kunnen initialiseren en de structuur van binnenkomende data kunnen verifiëren, krijgen toegang tot de beveiligde archieven."),
          p("Aan jou de taak om de toegang tot de databases te herstellen."),
          br(),
          tags$b("Activeer alle drie beveiligingsmodules om toegang te krijgen tot de volgende onderzoeksruimte.")
        ),
        footer = tagList(
          actionButton("continue_level3", "Doorgaan", class = "start-btn")
        ),
        easyClose = FALSE,
        size = "l"
      )
    )
  }, ignoreInit = TRUE)
  
  observeEvent(input$continue_level3, {
    removeModal()
    current_page("level3_1")
  }, ignoreInit = TRUE)
  
  invisible(NULL)
}