transition4_5_ui <- function() {
  uiOutput("hx5_lines")
}

transition4_5_server <- function(input, output, session, current_page) {
  
  output$hx5_lines <- renderUI({
    req(current_page() == "transition4_5")
    
    tagList(
      tags$div(
        class = "landing-container",
        tags$h1(class = "game-title", "LEVEL 5"),
        tags$div(
          class = "intro-text",
          "Het vrijgekomen virus is volledig geïdentificeerd.\n\nNu moet het juiste antiviral geselecteerd worden, zodat verdere verspreiding gestopt kan worden.\n\nAnalyseer de twee datasets over de aanwezige virussen en antivirals, om te bepalen welk antiviral gebruikt kan worden.\n\nDeze beslissing is van levensbelang, met het verkeerde antiviral zal het virus zich verder verspreiden."
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
          p("In de cursus is behandeld hoe je de functie distinct() gebruikt om unieke waarden uit een dataset te halen."),
          p("Daarnaast heb je geleerd hoe je met count() concrete aantallen kunt bepalen."),
          p("Ook kun je nu tabellen samenvoegen op basis van gemeenschappelijke variabelen met left_join(). Dit is noodzakelijk in de bunker voor het verkrijgen van complete datasets."),
          p("Verder weet je nu hoe je de x-as kunt sorteren met reorder(). Dit is belangrijk voor het overzichtelijk visualiseren van verkregen data.")
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