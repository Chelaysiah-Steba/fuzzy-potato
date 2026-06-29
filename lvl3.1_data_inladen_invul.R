library(shiny)
library(shinyjs)

virus_dataset <- data.frame(
  virus = c(
    "VX-01", "CrimsonFlu", "OmegaSpore", "Nexavirus", "BlueAsh",
    "PyroVex", "SilentMoth", "Gravemind", "Solaris-7", "HollowFang"
  ),
  mean_onset_days = c(
    3.2, 1.8, 5.6, 2.4, 4.1,
    6.3, 7.8, 3.9, 2.1, 5.0
  ),
  sd_onset_days = c(
    0.8, 0.5, 1.2, 0.6, 1.0,
    1.4, 1.9, 0.7, 0.4, 1.1
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
      .code-box {
        background-color: #000000;
        border: 2px solid #00FF00;
        padding: 10px;
        margin-top: 10px;
      }
      .inline-input {
        display: inline-block;
        width: 160px;
        background-color: #000000;
        color: #00FF00;
        border: 2px solid #00FF00;
        font-family: 'Courier New', monospace;
        margin-left: 5px;
      }
    ")),
    
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
      "📂 Start Level 3.1: Virus dataset inladen",
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
              h3("📂 Level 3.1: Virus dataset inladen"),
              p("Gebruik read_excel() om het bestand virus.xlsx te laden."),
              p("Typ wat er tussen de haakjes moet staan:"),
              
              div(class = "code-box",
                  HTML("virus_dataset <- read_excel("),
                  tags$input(id = "excel_input", type = "text", class = "inline-input"),
                  HTML(")")
              ),
              
              actionButton("submit_excel", "▶ RUN CODE")
          ),
          
          div(class = "console",
              h3("Console"),
              verbatimTextOutput("excel_console"),
              br(),
              uiOutput("virus_table")
          )
      )
    })
  })
  
  observeEvent(input$submit_excel, {
    req(input$excel_input)
    
    # Laat ook zien wat er precies is ingevoerd
    cat("excel_input =", input$excel_input, "\n")
    
    # Sta zowel met als zonder quotes toe
    clean_input <- trimws(input$excel_input)
    
    if (clean_input %in% c("\"virus.xlsx\"", "virus.xlsx")) {
      
      output$excel_console <- renderText({
        paste0(
          "✔ Correct!\nHet bestand is (in deze game) geladen als 'virus_dataset'.\n",
          "Je invoer was: ", input$excel_input
        )
      })
      
      output$virus_table <- renderUI({
        tagList(
          h3("📊 Geladen dataset:"),
          tableOutput("virus_table_data")
        )
      })
      
      output$virus_table_data <- renderTable({
        virus_dataset
      })
      
      session$sendCustomMessage("confetti", TRUE)
      return()
    }
    
    # Wrong answer → hide table + hint
    output$virus_table <- renderUI({ NULL })
    
    output$excel_console <- renderText({
      paste0(
        "✖ Fout.\nJe typte: read_excel(", input$excel_input, ")\n\n",
        "Hint: Bestandsnamen zijn tekst. Gebruik aanhalingstekens én de .xlsx extensie."
      )
    })
  })
}

shinyApp(ui, server)
