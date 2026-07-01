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
        width: 120px;
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
            h3("Level 3.3: Analyse van tidy data"),
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
                
                HTML(") |> "),
                
                selectInput(
                  "group_func",
                  NULL,
                  choices = c("group_by()", "rowwise()"),
                  width = "160px",
                  selectize = FALSE
                ),
                
                HTML("(symptom_onset_days) |> summarise("),
                
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
                  choices = c("count()", "n()"),
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
    req(input$compare_op, input$compare_value,
        input$group_func, input$mean_value, input$sd_value, input$count_func)
    
    code <- paste0(
      "tidy_scientists |> ",
      "filter(on_site ", input$compare_op, " '", input$compare_value, "') |> ",
      sub("\\(\\)", "", input$group_func), "(symptom_onset_days) |> ",
      "summarise(mean = mean(", input$mean_value, "), ",
      "SD = sd(", input$sd_value, "), ",
      "n = ", input$count_func, ")"
    )
    
    result <- tryCatch(
      eval(parse(text = code)),
      error = function(e) e$message
    )
    
    output$console_output <- renderText({
      paste("▶ Code uitgevoerd:\n", code, "\n\nResultaat:\n", capture.output(print(result)))
    })
  })
}

shinyApp(ui, server)
