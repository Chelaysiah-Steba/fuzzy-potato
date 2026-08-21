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
          "Van het vrijgekomen virus is voor iedere onderzoeker geregistreerd hoelang de onset-tijd was.\n\nDoor deze gegevens te vergelijken met de gegevens van de aanwezige virussen kan vastgesteld worden welk virus is vrijgekomen.\n\nHoudt rekening met alle beschikbare informatie."
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
          p("In de cursus heb je geleerd hoe je .xlsx-bestanden opent met read_excel(). Deze skill zal je toegang geven tot nieuwe datasets in de bunker."),
          p("Ook heb je geleerd hoe 'tidy' data eruitziet. Het is noodzakelijk dat je dit kunt herkennen en toepassen zodat de data betrouwbaar geanalyseerd kan worden."),
          p("Daarnaast moet je weten hoe je data kunt filteren. Hiervoor gebruik je de functie filter()."),
          p("Naast filteren heb je ook geleerd hoe je summarise() toe kunt passen om kernstatistieken te berekenen, zoals gemiddelden en standaarddeviatie.")
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