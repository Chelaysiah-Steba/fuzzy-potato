transition4_5_ui <- function() {
  uiOutput("hx1_lines")
}

transition4_5_server <- function(input, output, session, current_page) {
  
  output$hx1_lines <- renderUI({
    req(current_page() == "transition4_5")
    
    tagList(
      tags$div(
        class = "landing-container",
        tags$h1(class = "game-title", "LEVEL 5"),
        tags$div(
          class = "intro-text",
          "De centrale databanken blijven vergrendeld totdat de juiste systeemmodules zijn geactiveerd.\n\nAlleen operators die de interface kunnen initialiseren en de structuur van binnenkomende data kunnen verifiëren, krijgen toegang tot de beveiligde archieven."
        ),
        actionButton("hx_continue_btn_5", "Doorgaan", class = "start-btn")
      )
    )
  })
  
  observeEvent(input$hx_continue_btn_5, {
    showModal(
      modalDialog(
        title = "LEVEL 5 — Introductie",
        tagList(
          p("De centrale databanken blijven vergrendeld totdat de juiste systeemmodules zijn geactiveerd. Alleen operators die de interface kunnen initialiseren en de structuur van binnenkomende data kunnen verifiëren, krijgen toegang tot de beveiligde archieven."),
          p("Aan jou de taak om de toegang tot de databases te herstellen."),
          br(),
          tags$b("Activeer alle drie beveiligingsmodules om toegang te krijgen tot de volgende onderzoeksruimte.")
        ),
        footer = tagList(
          actionButton("continue_level5", "Doorgaan", class = "start-btn")
        ),
        easyClose = FALSE,
        size = "l"
      )
    )
  }, ignoreInit = TRUE)
  
  observeEvent(input$continue_level5, {
    removeModal()
    current_page("level5_1")
  }, ignoreInit = TRUE)
  
  invisible(NULL)
}