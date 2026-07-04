transition3_4_ui <- function() {
  uiOutput("hx1_lines")
}

transition3_4_server <- function(input, output, session, current_page) {
  
  output$hx1_lines <- renderUI({
    req(current_page() == "transition3_4")
    
    tagList(
      tags$div(
        class = "landing-container",
        tags$h1(class = "game-title", "LEVEL 4"),
        tags$div(
          class = "intro-text",
          "De centrale databanken blijven vergrendeld totdat de juiste systeemmodules zijn geactiveerd.\n\nAlleen operators die de interface kunnen initialiseren en de structuur van binnenkomende data kunnen verifiëren, krijgen toegang tot de beveiligde archieven."
        ),
        actionButton("hx_continue_btn_4", "Doorgaan", class = "start-btn")
      )
    )
  })
  
  observeEvent(input$hx_continue_btn_4, {
    showModal(
      modalDialog(
        title = "LEVEL 4 — Introductie",
        tagList(
          p("De centrale databanken blijven vergrendeld totdat de juiste systeemmodules zijn geactiveerd. Alleen operators die de interface kunnen initialiseren en de structuur van binnenkomende data kunnen verifiëren, krijgen toegang tot de beveiligde archieven."),
          p("Aan jou de taak om de toegang tot de databases te herstellen."),
          br(),
          tags$b("Activeer alle drie beveiligingsmodules om toegang te krijgen tot de volgende onderzoeksruimte.")
        ),
        footer = tagList(
          actionButton("continue_level4", "Doorgaan", class = "start-btn")
        ),
        easyClose = FALSE,
        size = "l"
      )
    )
  }, ignoreInit = TRUE)
  
  observeEvent(input$continue_level4, {
    removeModal()
    current_page("level4_1")
  }, ignoreInit = TRUE)
  
  invisible(NULL)
}