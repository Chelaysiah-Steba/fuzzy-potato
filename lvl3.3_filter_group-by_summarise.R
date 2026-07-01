library(shiny)
library(shinyjs)
library(dplyr)

tidy_scientists <- data.frame(
  Scientist = paste0("sci", sprintf("%02d", 1:20)),
  on_site = c(
    "yes","no","yes","yes","yes",
    "no","yes","yes","no","no",
    "yes","no","no","no","yes",
    "yes","yes","no","yes","yes"
  ),
  symptom_onset_days = c(
    5,7,3,4,4,
    6,3,4,5,6,
    5,7,6,5,4,
    3,5,7,4,3
  )
)

ui <- fluidPage(
  useShinyjs(),
  
  tags$head(
    tags$style(HTML("
      body {
        background-color: #1c1c1c;
        color: #00FF00;
        font-family: 'Courier New', monospace;
      }

      .code-box {
        background-color: #000000;
        border: 3px solid #00FF00;
        padding: 8px;
        margin-bottom: 5px;
        font-size: 1.05em;
        line-height: 1.1em;
      }

      .inline-input {
        width: 140px;
        background-color: #000000;
        color: #00FF00;
        border: 2px solid #00FF00;
        margin: 0 3px;
        height: 26px;
      }

      .inline-dropdown {
        background-color: #000000;
        color: #00FF00;
        border: 2px solid #00FF00;
        margin-left: 3px;
        height: 30px;
      }

      .game-container {
        display: flex;
        gap: 10px;
        margin-top: 10px;
      }

      .editor, .console {
        width: 50%;
        padding: 10px;
        border: 2px solid #00FF00;
      }

      .console {
        background-color: #000000;
        white-space: pre-wrap;
        font-size: 1.05em;
      }

      button {
        background-color: #1c1c1c;
        color: #00FF00;
        border: 2px solid #00FF00;
        padding: 8px 16px;
        cursor: pointer;
      }

      button:hover {
        background-color: #00FF00;
        color: #1c1c1c;
      }
    "))
  ),
  
  uiOutput("game_ui")
)

server <- function(input, output, session) {
  
  output$game_ui <- renderUI({
    div(class = "game-container",
        
        div(class = "editor",
            h3("Level 3.3: Analyse van tidy data (zonder group_by)"),
            p("Opdracht: vul alle velden correct in."),
            
            div(class = "code-box",
                
                HTML("tidy_scientists |> filter(on_site "),
                
                selectInput(
                  "compare_op",
                  NULL,
                  choices = c("==", "!=", ">", "<"),
                  width = "80px",
                  selectize = FALSE
                ),
                
                tags$input(
                  id = "compare_value",
                  type = "text",
                  class = "inline-input",
                  placeholder = "yes"
                ),
                
                HTML(") |> summarise("),
                
                HTML("mean = mean("),
                tags$input(
                  id = "mean_value",
                  type = "text",
                  class = "inline-input",
                  placeholder = "symptom_onset_days"
                ),
                HTML("),"),
                
                HTML("SD = sd("),
                tags$input(
                  id = "sd_value",
                  type = "text",
                  class = "inline-input",
                  placeholder = "symptom_onset_days"
                ),
                HTML("),"),
                
                HTML("n = "),
                selectInput(
                  "count_func",
                  NULL,
                  choices = c("n()", "count()"),
                  width = "120px",
                  selectize = FALSE
                ),
                
                HTML(")")
            ),
            
            actionButton("run_code", "▶ RUN CODE")
        ),
        
        div(class = "console",
            h3("Console"),
            verbatimTextOutput("console_output")
        )
    )
  })
  
  observeEvent(input$run_code, {
    
    # Check correctness
    correct <- (
      input$compare_op == "==" &&
        input$compare_value == "yes" &&
        input$mean_value == "symptom_onset_days" &&
        input$sd_value == "symptom_onset_days" &&
        input$count_func == "count()"
    )
    
    if (!correct) {
      output$console_output <- renderText({
        paste0(
          "✖ Fout.\n\nHints:\n",
          "- Gebruik == voor vergelijking\n",
          "- Vergelijk met 'yes'\n",
          "- mean() moet symptom_onset_days gebruiken\n",
          "- sd() moet symptom_onset_days gebruiken\n",
          "- Gebruik count() voor n\n"
        )
      })
      return()
    }
    
    # Build correct code
    code <- paste0(
      "tidy_scientists |> ",
      "filter(on_site == 'yes') |> ",
      "summarise(mean = mean(symptom_onset_days), ",
      "SD = sd(symptom_onset_days), ",
      "n = count())"
    )
    
    result <- tidy_scientists |>
      filter(on_site == "yes") |>
      summarise(
        mean = mean(symptom_onset_days),
        SD = sd(symptom_onset_days),
        n = dplyr::count()
      )
    
    output$console_output <- renderText({
      paste(
        "✔ Correct!\n\nVolledige code:\n",
        code,
        "\n\nOutput in R:\n",
        capture.output(print(result)),
        collapse = "\n"
      )
    })
  })
}

shinyApp(ui, server)
