transition1_2_ui <- function() {
  uiOutput("hx2_lines")
}

transition1_2_server <- function(input, output, session, current_page) {
  
  output$hx2_lines <- renderUI({
    req(current_page() == "transition1_2")
    
    tagList(
      tags$div(
        class = "landing-container",
        tags$h1(class = "game-title", "LEVEL 2"),
        tags$div(
          class = "intro-text",
          style = "max-width: 800px; margin: 0 auto; text-align: center;",
          "AUTHORISATIE SUCCESVOL\n\nHet is gelukt om de database te openen.\n\nNu is het tijd om bekend te worden met de virussen die aanwezig zijn in de bunker, en hun individuele onset-tijden.\n\nDeze informatie is noodzakelijk om te identificeren welk virus is vrijgekomen."
        ),
        actionButton("hx2_continue_btn_2", "Doorgaan", class = "start-btn")
      )
    )
  })
  
  observeEvent(input$hx2_continue_btn_2, {
    showModal(
      modalDialog(
        title = "LEVEL 2 — Introductie",
        tagList(
          p("In de cursus is behandeld hoe je TSV-bestanden opent met read_tsv(). Dit moet je onder de knie hebben om bestanden uit de database van de bunker te kunnen openen."),
          p("Daarnaast heb je geleerd hoe je verschillende grafieken moet maken met ggplot(). Voor dit level is het van belang dat je geom_point() kunt gebruiken voor het maken van een scatterplot."),
          p("Ook moet je variabelen kunnen omzetten naar factoren. Hiervoor gebruik je as.factor(). Dit is belangrijk voor het bewaren van overzicht in grafieken."),
          p("Naast het maken van grafieken moet je ook duidelijke titels, subtitels en aslabels kunnen toevoegen aan je grafiek. Dit doe je met labs().")
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
  }, ignoreInit = TRUE)
  
  invisible(NULL)
}