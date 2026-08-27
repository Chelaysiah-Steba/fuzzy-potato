transition_opening_1_ui <- function() {
  uiOutput("hx1_lines")
}

transition_opening_1_server <- function(input, output, session, current_page) {
  
  output$hx1_lines <- renderUI({
    req(current_page() == "transition_opening_1")
    
    tagList(
      tags$div(
        class = "landing-container",
        tags$h1(class = "game-title", "LEVEL 1"),
        tags$div(
          class = "intro-text",
          style = "max-width: 800px; margin: 0 auto; text-align: center;",
          "Het lijkt erop dat je nog geen toegang hebt tot de database van de bunker.\n\nZonder deze toegang is het onmogelijk om vast te stellen welk virus is vrijgekomen.\n\nOm verder te kunnen zal je eerst geauthoriseerd moeten worden om de database van de bunker te openen.\n\nLaad de benodigde bestanden om toegang te krijgen."
        ),
        actionButton("hx_continue_btn_1", "Doorgaan", class = "start-btn")
      )
    )
  })
  
  observeEvent(input$hx_continue_btn_1, {
    showModal(
      modalDialog(
        title = "LEVEL 1 — Introductie",
        tagList(
          p("Tijdens de cursus heb je geleerd hoe je packages activeert met library(). Dit is een cruciale stap bij het programmeren in R."),
          p("Ook heb je geleerd hoe je RDS-bestanden opent met readRDS(). Dit is noodzakelijk voor je missie in de bunker om toegang te krijgen tot benodigde datasets."),
          p("Naast het uitvoeren van functies is het ook belangrijk om te begrijpen wat R probeert te vertellen zodat je fouten kunt corrigeren. Hiervoor moet je de errors die je krijgt goed lezen.")
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
  }, ignoreInit = TRUE)
  
  invisible(NULL)
}