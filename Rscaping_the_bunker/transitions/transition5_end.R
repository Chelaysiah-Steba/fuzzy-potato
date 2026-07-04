transition_5_ending_ui <- function() {
  uiOutput("hx1_lines")
}

transition_5_ending_server <- function(input, output, session, current_page) {
  
  output$hx1_lines <- renderUI({
    req(current_page() == "transition_5_ending")
    
    tagList(
      tags$div(
        class = "landing-container",
        tags$h1(class = "game-title", "..."),
        tags$div(
          class = "intro-text",
          "De centrale databanken blijven vergrendeld totdat de juiste systeemmodules zijn geactiveerd.\n\nAlleen operators die de interface kunnen initialiseren en de structuur van binnenkomende data kunnen verifiëren, krijgen toegang tot de beveiligde archieven."
        ),
        actionButton("hx_continue_btn_end", "Doorgaan", class = "start-btn")
      )
    )
  })
  
  observeEvent(input$hx_continue_btn_end, {
    showModal(
      modalDialog(
        title = "AFSLUITING",
        tagList(
          p("De centrale databanken blijven vergrendeld totdat de juiste systeemmodules zijn geactiveerd. Alleen operators die de interface kunnen initialiseren en de structuur van binnenkomende data kunnen verifiëren, krijgen toegang tot de beveiligde archieven."),
          p("Aan jou de taak om de toegang tot de databases te herstellen."),
          br(),
          tags$b("Activeer alle drie beveiligingsmodules om toegang te krijgen tot de volgende onderzoeksruimte.")
        ),
        footer = tagList(
          actionButton("continue_end", "Doorgaan", class = "start-btn")
        ),
        easyClose = FALSE,
        size = "l"
      )
    )
  }, ignoreInit = TRUE)
  
  observeEvent(input$continue_end, {
    removeModal()
    current_page("end")
  }, ignoreInit = TRUE)
  
  invisible(NULL)
}