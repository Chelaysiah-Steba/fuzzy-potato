library(shiny)
library(bslib)
library(shinyjs)
library(tidyverse)


ui <- fluidPage(
  
  h3("Is deze dataset tidy?"),
  
  tableOutput("untidy_table"),
  
  radioButtons(
    inputId = "tidy_answer",
    label = "Kies het juiste antwoord:",
    choices = list(
      "a) ja, dit is tidy data" = "a",
      "b) nee, de age en survival rate staan niet in aparte kolommen" = "b",
      "c) nee, de kolommen zijn niet alfabetisch geordend" = "c",
      "d) nee, want voor elke scientist zijn er meerdere metingen" = "d"
    )
  ),
  
  actionButton("submit", "Bevestigen"),
  br(), br(),
  
  uiOutput("feedback")
)

server <- function(input, output, session) {
  
  # The untidy dataset shown to the player
  untidy_df <- data.frame(
    Scientist = c("Sci01","Sci01","Sci02","Sci02","Sci03","Sci03"),
    Measurement = c("Age_years","Survival_days","Age_years","Survival_days","Age_years","Survival_days"),
    Value = c(34,82,29,91,41,77)
  )
  
  output$untidy_table <- renderTable({
    untidy_df
  })
  
  observeEvent(input$submit, {
    correct <- "b"
    
    if (is.null(input$tidy_answer)) {
      output$feedback <- renderUI({
        tags$span(style="color:orange; font-weight:bold;",
                  "Selecteer eerst een antwoord.")
      })
      return()
    }
    
    if (input$tidy_answer == correct) {
      output$feedback <- renderUI({
        tags$span(style="color:green; font-weight:bold;",
                  "Correct! De variabelen staan niet in aparte kolommen.")
      })
    } else {
      output$feedback <- renderUI({
        tags$span(style="color:red; font-weight:bold;",
                  "Helaas, dat is niet correct.")
      })
    }
  })
}

shinyApp(ui, server)
