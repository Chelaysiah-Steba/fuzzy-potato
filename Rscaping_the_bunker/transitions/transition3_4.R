transition3_4_ui <- function() {
  uiOutput("hx4_lines")
}

transition3_4_server <- function(input, output, session, current_page) {
  
  output$hx4_lines <- renderUI({
    req(current_page() == "transition3_4")
    
    tagList(
      tags$div(
        class = "landing-container",
        tags$h1(class = "game-title", "LEVEL 4"),
        tags$div(
          class = "intro-text",
          style = "max-width: 800px; margin: 0 auto; text-align: center;",
          "Er zijn meerdere virussen die overeenkomen.\n\nHet is noodzakelijk dat het vrijgekomen virus 100% geïdentificeerd wordt voordat er een antiviral ingezet kan worden.\n\nHet virus kan geïdentificeerd worden aan de hand van de DNA-concentratie.\n\nIn de database staat een dataset met de CT-waarde van het vrijgekomen virus.\n\nGebruik deze om de concentratie te bepalen en zo vast te stellen welk virus is vrijgekomen."
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
          p("Tijdens de cursus heb je geleerd hoe je dixon.test() gebruikt om te bepalen of extreme waarden statistisch gezien een outlier zijn."),
          p("Ook heb je geleerd dat een datapunt enkel verwijderd mag worden als de p-value kleiner is dan 0.05."),
          p("Daarnaast weet je nu dat je geom_smooth(method = \"lm\") gebruikt om een lineaire regressielijn toe te voegen aan een scatterplot. Dit is een belangrijke skill voor het interpoleren van onbekende datapunten.")
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