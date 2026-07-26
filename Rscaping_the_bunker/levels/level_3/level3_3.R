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

level3_3_ui <- function() {
  fluidPage(
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
        .next-btn {
          margin-top: 20px;
          background: #1c1c1c;
          color: #00FF00;
          border: 2px solid #00FF00;
          padding: 10px 20px;
          font-family: 'Courier New';
          cursor: pointer;
        }
      "))
    ),
    
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
            verbatimTextOutput("console_output_l3_3"),
            uiOutput("next_ui_l3_3")
        )
    )
  )
}

level3_3_server <- function(input, output, session, current_page) {
  
  output$console_output_l3_3 <- renderText({
    ""
  })
  
  output$next_ui_l3_3 <- renderUI({
    NULL
  })
  
  observeEvent(input$run_code, {
    
    compare_value <- trimws(input$compare_value %||% "")
    mean_value <- trimws(input$mean_value %||% "")
    sd_value <- trimws(input$sd_value %||% "")
    
    correct <- (
      identical(input$compare_op, "==") &&
        identical(compare_value, "yes") &&
        identical(mean_value, "symptom_onset_days") &&
        identical(sd_value, "symptom_onset_days") &&
        identical(input$count_func, "count()")
    )
    
    if (!isTRUE(correct)) {
      session$sendCustomMessage("redFlash", TRUE)
      
      hints <- c(
        if (!identical(input$compare_op, "==")) "- Gebruik == voor vergelijking" else NULL,
        if (!identical(compare_value, "yes")) "- Vergelijk met 'yes'" else NULL,
        if (!identical(mean_value, "symptom_onset_days")) "- mean() moet symptom_onset_days gebruiken" else NULL,
        if (!identical(sd_value, "symptom_onset_days")) "- sd() moet symptom_onset_days gebruiken" else NULL,
        if (!identical(input$count_func, "count()")) "- Gebruik count() voor n" else NULL
      )
      
      output$console_output_l3_3 <- renderText({
        paste(c("🔴 FOUT", "", "Hints:", hints), collapse = "\n")
      })
      
      output$next_ui_l3_3 <- renderUI(NULL)
      return()
    }
    
    session$sendCustomMessage("greenFlash", TRUE)
    
    code <- paste0(
      "tidy_scientists |> ",
      "filter(on_site == 'yes') |> ",
      "summarise(mean = mean(symptom_onset_days), ",
      "SD = sd(symptom_onset_days), ",
      "n = count())"
    )
    
    output$console_output_l3_3 <- renderText({
      paste(
        "🟢 CORRECT",
        "",
        "Volledige code:",
        code,
        "",
        "Output in R:",
        "",
        "# A tibble: 1 × 3",
        "mean     SD     n",
        "3.9167 0.9965   12",
        sep = "\n"
      )
    })
    
    output$next_ui_l3_3 <- renderUI({
      actionButton("next_level3_4", "Volgende", class = "next-btn")
    })
  })
  
  observeEvent(input$next_level3_4, {
    current_page("level3_4")
  })
}