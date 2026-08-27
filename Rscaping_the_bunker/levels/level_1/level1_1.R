bootsequence <- data.frame(
  step = 1:5,
  action = c(
    "initiate",
    "load",
    "authenticate",
    "unlock",
    "boot"
  ),
  status = c(
    "OK",
    "OK",
    "OK",
    "OK",
    "READY"
  ),
  stringsAsFactors = FALSE
)


level1_1_ui <- function() {
  
  fluidPage(
    
    useShinyjs(),
    
    tags$head(
      tags$style(HTML("

        body {
          background-color: #1c1c1c;
          color: #24bb24;
          font-family: 'Courier New', monospace;
        }

        .level11-game-container {
          display: flex;
          gap: 20px;
          margin-top: 20px;
          align-items: flex-start;
        }

        .level11-editor,
        .level11-console {
          width: 50%;
          padding: 15px;
          font-family: 'Courier New', monospace;
          border: 2px solid #24bb24;
          text-align: left;
          box-sizing: border-box;
        }

        .level11-editor {
          background-color: #1c1c1c !important;
          color: #24bb24 !important;
          min-height: 300px;
        }

        .level11-console {
          background-color: #000000 !important;
          color: #24bb24 !important;
          min-height: 300px;
          white-space: pre-wrap;
        }

        .level11-editor h3,
        .level11-console h3 {
          color: #24bb24 !important;
        }

        .level11-console-message {
          background-color: #000000 !important;
          color: #24bb24 !important;
          border: 2px solid #24bb24 !important;
          outline: none !important;
          box-shadow: none !important;
          -webkit-box-shadow: none !important;
          text-shadow: none !important;
          padding: 10px;
          margin-top: 10px;
          min-height: 100px;
          font-family: 'Courier New', monospace !important;
          white-space: pre-wrap;
        }

        .level11-console-message.success {
          color: #24bb24 !important;
          border-color: #24bb24 !important;
        }

        .level11-console-message.error {
          color: #bb2424 !important;
          border-color: #bb2424 !important;
        }

        .level11-console-message pre {
          background-color: #000000 !important;
          color: inherit !important;
          border: none !important;
          outline: none !important;
          box-shadow: none !important;
          -webkit-box-shadow: none !important;
          text-shadow: none !important;
          margin: 0 !important;
          padding: 0 !important;
          white-space: pre-wrap !important;
          font-family: 'Courier New', monospace !important;
        }

        .level11-rds-select {
          margin-top: 10px;
          margin-bottom: 15px;
        }

        .level11-rds-select select,
        .level11-rds-select .form-control,
        .level11-rds-select .selectize-input,
        .level11-rds-select .selectize-control.single .selectize-input,
        .level11-rds-select .selectize-dropdown,
        .level11-rds-select .selectize-dropdown .option,
        .level11-rds-select .selectize-input.full {
          background-color: #000000 !important;
          color: #24bb24 !important;
          border: 2px solid #24bb24 !important;
          outline: none !important;
          box-shadow: none !important;
          -webkit-box-shadow: none !important;
          text-shadow: none !important;
          font-family: 'Courier New', monospace !important;
        }

        .level11-rds-select select:focus,
        .level11-rds-select .form-control:focus,
        .level11-rds-select .selectize-input:focus,
        .level11-rds-select .selectize-input.focus,
        .level11-rds-select .selectize-input.input-active,
        .level11-rds-select .selectize-control.single .selectize-input.focus,
        .level11-rds-select .selectize-control.single .selectize-input.input-active {
          background-color: #000000 !important;
          color: #24bb24 !important;
          border: 2px solid #24bb24 !important;
          outline: none !important;
          box-shadow: none !important;
          -webkit-box-shadow: none !important;
          text-shadow: none !important;
        }

        .level11-rds-select .selectize-input input {
          background-color: #000000 !important;
          color: #24bb24 !important;
          outline: none !important;
          box-shadow: none !important;
          -webkit-box-shadow: none !important;
          text-shadow: none !important;
        }

        .level11-rds-select .selectize-input input:focus {
          background-color: #000000 !important;
          color: #24bb24 !important;
          outline: none !important;
          box-shadow: none !important;
          -webkit-box-shadow: none !important;
        }

        .level11-rds-select .selectize-dropdown-content {
          background-color: #000000 !important;
          box-shadow: none !important;
          -webkit-box-shadow: none !important;
        }

        .level11-rds-select .selectize-dropdown .option {
          background-color: #000000 !important;
          color: #24bb24 !important;
          border: none !important;
          outline: none !important;
          box-shadow: none !important;
        }

        .level11-rds-select .selectize-dropdown .active {
          background-color: #24bb24 !important;
          color: #000000 !important;
          box-shadow: none !important;
          -webkit-box-shadow: none !important;
        }

        .level11-rds-select .selectize-control.single .selectize-input:after {
          border-top-color: #24bb24 !important;
        }

        .level11-editor input:focus,
        .level11-editor select:focus,
        .level11-editor textarea:focus,
        .level11-editor button:focus {
          outline: none !important;
          box-shadow: none !important;
          -webkit-box-shadow: none !important;
        }

        .level11-run-btn,
        .level11-next-btn {
          margin-top: 20px;
          background: #1c1c1c !important;
          color: #24bb24 !important;
          border: 2px solid #24bb24 !important;
          outline: none !important;
          box-shadow: none !important;
          -webkit-box-shadow: none !important;
          padding: 10px 20px;
          font-family: 'Courier New', monospace !important;
          cursor: pointer;
        }

        .level11-run-btn:hover,
        .level11-next-btn:hover {
          background: #24bb24 !important;
          color: #1c1c1c !important;
        }

        .level11-run-btn:focus,
        .level11-next-btn:focus {
          outline: none !important;
          box-shadow: none !important;
          -webkit-box-shadow: none !important;
        }

        #level11-boot-table {
          width: 100%;
          margin-top: 15px;
          border-collapse: collapse;
          background-color: #000000 !important;
          color: #24bb24 !important;
          font-family: 'Courier New', monospace !important;
        }

        #level11-boot-table table {
          width: 100%;
          border-collapse: collapse;
          background-color: #000000 !important;
          color: #24bb24 !important;
          font-family: 'Courier New', monospace !important;
        }

        #level11-boot-table th,
        #level11-boot-table td {
          background-color: #000000 !important;
          color: #24bb24 !important;
          border: 1px solid #24bb24 !important;
          padding: 6px;
          text-align: left;
        }

        #level11-boot-table th {
          background-color: #1c1c1c !important;
        }

      "))
    ),
    
    div(
      class = "level11-game-container",
      
      div(
        class = "level11-editor",
        
        h3("Level 1.1: laad het RDS-bestand"),
        
        p(
          "Gebruik de juiste functie om het bestand 'bootsequence.rds' te laden."
        ),
        
        div(
          class = "level11-rds-select",
          
          selectInput(
            inputId = "level11_rds_choice",
            label = NULL,
            choices = c(
              "read_excel('bootsequence.xlsx')" =
                "read_excel('bootsequence.rds')",
              "readRDS('bootsequence.rds')" =
                "readRDS('bootsequence.rds')",
              "read_csv('bootsequence.csv')" =
                "read_csv('bootsequence.rds')",
              "read_rds('bootsequence.rds')" =
                "read_rds('bootsequence.rds')"
            ),
            selected = character(0)
          )
        ),
        
        actionButton(
          inputId = "level11_submit_rds",
          label = "▶ RUN CODE",
          class = "level11-run-btn"
        )
      ),
      
      div(
        class = "level11-console",
        
        h3("Console"),
        
        uiOutput("level11_rds_console_ui"),
        
        uiOutput("level11_boot_table")
      )
    )
  )
}


level1_1_server <- function(
    input,
    output,
    session,
    current_page
) {
  
  output$level11_rds_console_ui <- renderUI({
    NULL
  })
  
  output$level11_boot_table <- renderUI({
    NULL
  })
  
  
  observeEvent(
    input$level11_submit_rds,
    {
      
      req(input$level11_rds_choice)
      
      if (
        identical(
          input$level11_rds_choice,
          "readRDS('bootsequence.rds')"
        )
      ) {
        
        session$sendCustomMessage(
          "greenFlash",
          TRUE
        )
        
        output$level11_rds_console_ui <- renderUI({
          
          div(
            class = "level11-console-message success",
            
            verbatimTextOutput(
              "level11_rds_console_output",
              placeholder = FALSE
            )
          )
        })
        
        output$level11_rds_console_output <- renderText({
          
          paste(
            "✔ Correct.",
            "",
            "> readRDS('bootsequence.rds')",
            "",
            "Het RDS-bestand is succesvol geladen.",
            "",
            "Bootsequence Module",
            "STATUS: ONLINE",
            sep = "\n"
          )
        })
        
        output$level11_boot_table <- renderUI({
          
          tagList(
            
            h3("Geladen dataset: bootsequence"),
            
            div(
              id = "level11-boot-table",
              
              tableOutput(
                "level11_boot_table_data"
              )
            ),
            
            br(),
            
            actionButton(
              inputId = "level11_next_level1_2",
              label = "Volgende",
              class = "level11-next-btn"
            )
          )
        })
        
        output$level11_boot_table_data <- renderTable({
          
          bootsequence
          
        },
        striped = FALSE,
        bordered = TRUE,
        hover = FALSE,
        spacing = "xs",
        rownames = FALSE
        )
        
      } else {
        
        session$sendCustomMessage(
          "redFlash",
          TRUE
        )
        
        output$level11_boot_table <- renderUI({
          NULL
        })
        
        output$level11_rds_console_ui <- renderUI({
          
          div(
            class = "level11-console-message error",
            
            verbatimTextOutput(
              "level11_rds_console_output",
              placeholder = FALSE
            )
          )
        })
        
        output$level11_rds_console_output <- renderText({
          
          paste(
            "✖ Incorrect.",
            "",
            "Hint:",
            "Kijk goed welke functie speciaal ontworpen is voor bestanden waarin een volledig R-object is opgeslagen.",
            sep = "\n"
          )
        })
      }
    }
  )
  
  
  observeEvent(
    input$level11_next_level1_2,
    {
      current_page("level1_2")
    },
    ignoreInit = TRUE
  )
}