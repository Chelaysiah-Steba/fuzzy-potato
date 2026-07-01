library(shiny)
library(bslib)
library(shinyjs)

# UI
ui <- fluidPage(
  useShinyjs(),
  title = "Rscaping the Bunker",
  
  tags$head(
    tags$style(HTML("
      body {
        background-color: #1c1c1c;
        color: #00FF00;
        font-family: 'Courier New', monospace;
      }
      .landing-container {
        border: 3px solid #00FF00;
        padding: 30px;
        margin: 50px auto;
        max-width: 800px;
        text-align: center;
        background-color: #1c1c1c;
      }
      .game-title {
        font-size: 3em;
        font-weight: bold;
        margin-bottom: 20px;
        text-shadow: 0 0 5px #00FF00;
      }
      .intro-text {
        font-size: 1.2em;
        text-align: left;
        white-space: pre-wrap;
        min-height: 150px;
      }
      .start-btn {
        margin-top: 40px;
        font-size: 1.5em;
        padding: 15px 40px;
        background-color: #1c1c1c;
        color: #00FF00;
        border: 2px solid #00FF00;
        cursor: pointer;
        transition: all 0.3s ease;
        display:none;
      }
      .start-btn:hover {
        background-color: #00FF00;
        color: #1c1c1c;
      }
      .caret {
        display: inline-block;
        width: 10px;
        background-color: #00FF00;
        animation: blink 0.8s infinite;
      }
      @keyframes blink {
        0%, 50%, 100% { background-color: transparent; }
        25%, 75% { background-color: #00FF00; }
      }
      .modal-content {
        background-color: #1c1c1c !important;
        color: #00FF00;
        border: 2px solid #00FF00;
      }
      .modal-header, .modal-footer {
        background-color: #1c1c1c !important;
        border-color: #00FF00;
      }
      .modal-title {
        color: #00FF00;
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
  0% {
    transform: translateY(0) translateX(0) rotate(0deg);
  }
  100% {
    transform: translateY(100vh) translateX(var(--drift)) rotate(var(--rotate));
  }
}
`;
document.head.appendChild(style);
"))
  ),
  
  div(id = "landing", class = "landing-container",
      div(class = "game-title", "Rscaping the Bunker"),
      div(id = "intro-text", class = "intro-text"),
      
      actionButton("skip_intro", "⏭ OVERSLAAN", class = "start-btn", style = "display:inline-block; margin-top:10px;"),
      br(),
      actionButton("start_game", "▶ START MISSIIE", class = "start-btn")
  ),
  
  tags$script(HTML("
    Shiny.addCustomMessageHandler('updateText', function(message) {
      document.getElementById('intro-text').innerHTML = message;
    });
  ")),
  
  tags$script(HTML("
    Shiny.addCustomMessageHandler('showStartButton', function(message) {
      if (message === true) {
        var btn = document.getElementById('start_game');
        if (btn) {
          btn.style.display = 'inline-block';
        }
      }
    });
  ")),
  
  uiOutput("game_ui")
)

# server
server <- function(input, output, session) {
  
  lines <- c(
    "Je betreedt de Helix-9 Onderzoeksbunker in de veronderstelling dat je een routine-trainingssessie ingaat...",
    "Plotseling flikkeren de lichten — een schelle alarmtoon galmt door de gangen.",
    "Een experimenteel biotechnologisch project is misgegaan.",
    "Een prototypevirus is per ongeluk geactiveerd en verspreidt zich door de faciliteit.",
    "Als het de oppervlakte bereikt, kunnen de gevolgen catastrofaal zijn.",
    "Het geautomatiseerde beveiligingssysteem heeft alle uitgangen vergrendeld.",
    "Het onderzoeksteam zit opgesloten… en jij ook.",
    "Jouw missie: krijg toegang tot het centrale controlesysteem.",
    "Herstel de beveiligingsprotocollen, houd de uitbraak onder controle en red de faciliteit — voordat de tijd om is."
  )
  
  # reactiveValues = opslag voor variabelen die tijdens de app veranderen
  rv <- reactiveValues(
    current_line = 1,
    current_char = 0,
    is_pausing = FALSE,
    char_delay = 20,
    line_pause = 200,
    
    stage = "intro" # bepaalt welk scherm de gebruiker ziet
  )
  
  # typing effect
  observe({
    if (rv$stage != "intro") return()
    
    current_line <- isolate(rv$current_line)
    current_char <- isolate(rv$current_char)
    is_pausing <- isolate(rv$is_pausing)
    
    if (current_line > length(lines)) {
      final_text <- paste(lines, collapse = "\n")
      final_text <- paste0(final_text, "\n<span class='caret'></span>")
      session$sendCustomMessage("updateText", final_text)
      session$sendCustomMessage("showStartButton", TRUE)
      
      shinyjs::hide("skip_intro")
      return()
    }
    
    if (is_pausing) {
      rv$is_pausing <- FALSE
      invalidateLater(rv$line_pause, session)
      return()
    }
    
    line <- lines[current_line]
    
    if (current_char < nchar(line)) {
      rv$current_char <- current_char + 1
      
      typed_line <- substr(line, 1, rv$current_char)
      previous_lines <- if (current_line > 1) lines[1:(current_line - 1)] else character(0)
      
      full_text <- paste(c(previous_lines, typed_line), collapse = "\n")
      full_text <- paste0(full_text, "\n<span class='caret'></span>")
      
      session$sendCustomMessage("updateText", full_text)
      invalidateLater(rv$char_delay, session)
      
    } else {
      rv$current_line <- current_line + 1
      rv$current_char <- 0
      rv$is_pausing <- TRUE
      invalidateLater(rv$line_pause, session)
    }
  })
  
  # skip button
  observeEvent(input$skip_intro, {
    rv$current_line <- length(lines) + 1
    
    final_text <- paste(lines, collapse = "\n")
    final_text <- paste0(final_text, "\n<span class='caret'></span>")
    
    session$sendCustomMessage("updateText", final_text)
    session$sendCustomMessage("showStartButton", TRUE)
    
    shinyjs::hide("skip_intro")
  })
  
  # start game popup
  observeEvent(input$start_game, {
    showModal(modalDialog(
      title = "SPEL STARTEN...",
      "Spel omgeving inladen...",
      footer = actionButton("continue_btn", "Volgende"),
      easyClose = TRUE
    ))
  })
  
  # continue naar game
  observeEvent(input$continue_btn, {
    removeModal()
    shinyjs::hide("landing")
    rv$stage <- "welcome"
  })
  
  # Dit bepaalt welk scherm wordt getoond op basis van de "stage"
  # Je kunt hier nieuwe levels toevoegen met: else if (...)
  output$game_ui <- renderUI({
    
    if (rv$stage == "welcome") {
      div(class = "landing-container",
          h1("Welkom, Analist in wording"),
          p("De Helix‑9 bunker zit in volledige lockdown, maar het virus verspreid zich sneller dan de protocollen aankunnen."),
          p("Er is geen ondersteuning van buitenaf, Het is aan jouw om de wereld te redden."),
          p("Gebruik de kennis die je hebt opgedaan in Prgrammeren in R om de datasets te ontcijferen, beveiligingslagen te herstellen en kritieke modules te herstarten"),
          p("Elke opdracht brengt je dichter bij de uitgang"),
          actionButton("next_step", "Volgende")
      )
    }
    
    else if (rv$stage == "level_1") {
      div(class = "landing-container",
          h1("Level 1: Packages"),
          p("In deze bunker zijn packages essentieel."),
          p("Ze bevatten functies die je nodig hebt om te overleven."),
          p("Maar… ze werken alleen als je ze laadt."),
          actionButton("to_run", "Volgende")
      )
    }
    
    else if (rv$stage == "level_1_run") {
      div(class = "landing-container",
          
          h2("Opdracht"),
          p("Voer de code uit om geïnfecteerde sectoren te detecteren."),
          
          div(class = "game-container",
              
              div(class = "editor",
                  verbatimTextOutput("code_block")
              ),
              
              div(class = "console",
                  textOutput("console_output")
              )
          ),
          
          br(),
          actionButton("run_code", "▶ Run Code")
      )
    }
    
    else if (rv$stage == "level_1_error") {
      div(class = "landing-container",
          
          h2("Resultaat"),
          
          div(class = "game-container",
              
              div(class = "editor",
                  verbatimTextOutput("code_block")
              ),
              
              div(class = "console",
                  textOutput("console_output")
              )
          ),
          
          br(),
          
          radioButtons("q1", "Wat betekent deze foutmelding?",
                       choices = c(
                         "De data bestaat niet",
                         "De functie komt uit een package dat niet geladen is",
                         "Er zit een typefout in de code"
                       )),
          
          actionButton("submit_q1", "Submit")
      )
    }
    
    else if (rv$stage == "level_1_fix") {
      div(class = "landing-container",
          
          h2("Nieuwe opdracht"),
          p("Laad het juiste package zodat de code werkt."),
          
          div(class = "game-container",
              
              div(class = "editor",
                  verbatimTextOutput("code_block")
              ),
              
              div(class = "console",
                  textOutput("console_output")
              )
          ),
          
          br(),
          textInput("fix_input", "Typ je code:", ""),
          actionButton("run_fix", "▶ Run Code")
      )
    }
    
    else if (rv$stage == "level_1_success") {
      div(class = "landing-container",
          h1("Goed gedaan"),
          p("Foutmeldingen lijken eng, maar ze helpen je juist."),
          p("Lees ze altijd goed, ze vertellen je wat er mis is."),
          actionButton("next_level", "Volgende")
      )
    }
    
    else if (rv$stage == "end_screen") {
      div(class = "landing-container",
          
          h1("MISSIE VOLTOOID"),
          
          p("Het beveiligingssysteem is succesvol hersteld."),
          p("Het virus is gestopt voordat het de oppervlakte kon bereiken."),
          p("Tegen alle verwachtingen in heb jij de bunker gered."),
          
          br(),
          h2("🌍 De wereld is veilig... voor nu."),
          
          br(),
          
          actionButton("confetti_btn", "🎉 Vier overwinning"),
          actionButton("restart_game", "🔄 Opnieuw spelen")
      )
    }
    
  })
  
  # Dit regelt de overgang tussen schermen (game flow)
  # Wanneer de knop wordt ingedrukt verandert de stage
  observeEvent(input$next_step, {
    rv$stage <- "level_1"
  })
  
  # van intro naar run
  observeEvent(input$to_run, {
    rv$stage <- "level_1_run"
  })
  
  # run naar error
  observeEvent(input$run_code, {
    rv$stage <- "level_1_error"
  })
  
  # check antwoord
  observeEvent(input$submit_q1, {
    
    if (input$q1 == "De functie komt uit een package dat niet geladen is") {
      
      showModal(modalDialog(
        title = "Correct",
        "Juist! De functie zit in een package dat nog niet geladen is.",
        easyClose = TRUE,
        footer = actionButton("to_fix", "Ga verder")
      ))
      
    } else {
      
      showModal(modalDialog(
        title = "Onjuist",
        "Niet helemaal. Lees de foutmelding goed opnieuw.",
        easyClose = TRUE,
        footer = modalButton("Probeer opnieuw")
      ))
      
    }
  })
  
  observeEvent(input$next_level, {
    rv$stage <- "end_screen"
  })
  
  observeEvent(input$to_fix, {
    removeModal()
    rv$stage <- "level_1_fix"
  })
  
  # fix code check
  observeEvent(input$run_fix, {
    
    user_input <- input$fix_input
    
    # check correcte tidyverse
    correct1 <- grepl("library\\(tidyverse\\)", user_input)
    correct2 <- grepl("library\\(\"tidyverse\"\\)", user_input)
    
    # check of user überhaupt library() gebruikt
    uses_library <- grepl("library\\(", user_input)
    
    if (correct1 || correct2) {
      
      rv$stage <- "level_1_success"
      
    } else if (uses_library) {
      
      showModal(modalDialog(
        title = "Bijna goed",
        "Je gebruikt de juiste functie, maar dit is niet het juiste package.",
        easyClose = TRUE,
        footer = modalButton("Probeer opnieuw")
      ))
      
    } else {
      
      showModal(modalDialog(
        title = "Fout",
        "Dit is niet de juiste manier om een package te laden.",
        easyClose = TRUE,
        footer = modalButton("Probeer opnieuw")
      ))
      
    }
  })
  
  observeEvent(input$confetti_btn, {
    session$sendCustomMessage("confetti", TRUE)
  })
  
  observeEvent(input$restart_game, {
    rv$stage <- "intro"
    shinyjs::show("landing")
  })
  
  # tekst/code voor in level 1
  output$code_block <- renderText({
    "bunker_logs |>
  filter(status == 'infected') |>
  select(id, sector)"
  })
  
  output$console_output <- renderText({
    
    if (rv$stage == "level_1_run") {
      return("> ")
    }
    
    if (rv$stage == "level_1_error") {
      return("> bunker_logs |>
  filter(status == \"infected\") |>
  select(id, sector)

Error in filter(status == \"infected\") : 
  could not find function \"filter\"")
    }
    
    if (rv$stage == "level_1_fix") {
      return("> bunker_logs |>
  filter(status == \"infected\") |>
  select(id, sector)

Error in filter(status == \"infected\") : 
  could not find function \"filter\"")
    }
    
    if (rv$stage == "level_1_success") {
      return("> library(tidyverse)
> bunker_logs |>
  filter(status == \"infected\") |>
  select(id, sector)

[1] Scan succesvol uitgevoerd")
    }
    
  })
}

shinyApp(ui = ui, server = server)