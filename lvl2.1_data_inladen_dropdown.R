library(shiny)
library(shinyjs)

scientists_dataset <- data.frame(
  scientist = c(
    "sci01","sci02","sci03","sci04","sci05",
    "sci06","sci07","sci08","sci09","sci10",
    "sci11","sci12","sci13","sci14","sci15",
    "sci16","sci17","sci18","sci19","sci20"
  ),
  age_years = c(
    34, 50, 41, 29, 46,
    38, 52, 44, 31, 57,
    36, 48, 40, 53, 28,
    39, 45, 32, 55, 37
  ),
  survival_days = c(
    88, 20, 77, 55, 12,
    91, 33, 67, 82, 14,
    73, 29, 95, 18, 64,
    87, 22, 79, 31, 70
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
      .game-container {
        display: flex;
        gap: 20px;
        margin-top: 20px;
      }
      .editor, .console {
        width: 50%;
        padding: 15px;
        font-family: 'Courier New', monospace;
        border: 2px solid #00FF00;
        text-align: left;
      }
      .editor {
        background-color: #1c1c1c;
        min-height: 200px;
      }
      .console {
        background-color: #000000;
        min-height: 200px;
        white-space: pre-wrap;
      }
    ")),
    
    # Confetti script
    tags$script(HTML("
      Shiny.addCustomMessageHandler('confetti', function(message) {
        const colors = ['#ff3b3b', '#ffd93b', '#3bff57', '#3bd9ff', '#a93bff', '#ff8c3b'];

        for (let i = 0; i < 150; i++) {
          let conf = document.createElement('div');
          let size = Math.random() * 8 + 4;

          conf.style.position = 'fixed';
          conf.style.width = size + 'px';
          conf.style.height = size + 'px';
          conf.style.backgroundColor = colors[Math.floor(Math.random() * colors.length)];
          conf.style.left = Math.random() * 100 + 'vw';
          conf.style.top = '-10px';
          conf.style.opacity = Math.random();

          let duration = Math.random() * 3 + 2;
          let drift = (Math.random() - 0.5) * 200;

          conf.style.animation = `confettiFall ${duration}s linear forwards`;
          conf.style.setProperty('--drift', drift + 'px');
          conf.style.setProperty('--rotate', Math.random() * 360 + 'deg');

          document.body.appendChild(conf);
          setTimeout(() => conf.remove(), duration * 1000);
        }
      });

      const style = document.createElement('style');
      style.innerHTML = `
      @keyframes confettiFall {
        0% { transform: translateY(0) translateX(0) rotate(0deg); }
        100% { transform: translateY(100vh) translateX(var(--drift)) rotate(var(--rotate)); }
      }`;
      document.head.appendChild(style);
    "))
  ),
  
  # Centered start button
  div(
    id = "start_wrapper",
    style = "
      display: flex;
      justify-content: center;
      align-items: center;
      height: 60vh;
    ",
    actionButton(
      "start_level",
      "📂 Start Level 2.1: Load Scientists Dataset",
      style = "
        font-size: 1.5em;
        padding: 20px 40px;
        background-color: #1c1c1c;
        color: #00FF00;
        border: 3px solid #00FF00;
        cursor: pointer;
        text-shadow: 0 0 5px #00FF00;
      "
    )
  ),
  
  uiOutput("game_ui")
)

server <- function(input, output, session) {
  
  observeEvent(input$start_level, {
    
    removeUI(selector = "#start_wrapper", immediate = TRUE)
    
    output$game_ui <- renderUI({
      div(class = "game-container",
          
          div(class = "editor",
              h3("🧪 Level: Load the Scientists Dataset"),
              p("Gebruik read_excel() om het bestand scientists.xlsx te laden."),
              p("Kies wat er tussen de haakjes moet staan:"),
              
              selectInput(
                "excel_choice",
                "scientists_dataset <- read_excel( ... )",
                choices = c(
                  "\"scientists.xlsx\"" = "\"scientists.xlsx\"",
                  "scientists" = "scientists",
                  "scientists.xlsx" = "scientists.xlsx",
                  "\"data/scientists.xlsx\"" = "\"data/scientists.xlsx\""
                )
              ),
              
              actionButton("submit_excel", "▶ RUN CODE")
          ),
          
          div(class = "console",
              h3("Console"),
              verbatimTextOutput("excel_console"),
              br(),
              uiOutput("scientists_table")
          )
      )
    })
  })
  
  observeEvent(input$submit_excel, {
    req(input$excel_choice)
    
    # Correct answer
    if (input$excel_choice == "\"scientists.xlsx\"") {
      
      output$excel_console <- renderText({
        "✔ Correct!\nHet bestand is succesvol geladen in R als 'scientists_dataset'."
      })
      
      output$scientists_table <- renderUI({
        tagList(
          h3("📊 Geladen dataset:"),
          tableOutput("scientists_table_data")
        )
      })
      
      output$scientists_table_data <- renderTable({
        scientists_dataset
      })
      
      session$sendCustomMessage("confetti", TRUE)
      return()
    }
    
    # Wrong answer → hide table + hint
    output$scientists_table <- renderUI({ NULL })
    
    output$excel_console <- renderText({
      paste0(
        "✖ Fout.\nJe koos: read_excel(", input$excel_choice, ")\n\n",
        "Hint: Bestandsnamen zijn tekst. Gebruik aanhalingstekens én de .xlsx extensie."
      )
    })
  })
}

shinyApp(ui, server)
