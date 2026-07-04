# laden van packages
library(shiny)
library(shinyjs)
library(tidyverse)
library(later)
library(htmltools)

# laden van source materiaal (level scripts en vraagtypefuncties)
source("modules.R")

source("transitions/transition_opening_1.R")
source("levels/level_1/level1_1.R")
source("levels/level_1/level1_2.R")
source("levels/level_1/level1_3.R")
source("levels/level_1/level1_4.R")

source("transitions/transition1_2.R")
source("levels/level_2/level2_1.R")
source("levels/level_2/level2_2.R")
source("levels/level_2/level2_3.R")
source("levels/level_2/level2_4.R")

source("transitions/transition2_3.R")
source("levels/level_3/level3_1.R")
source("levels/level_3/level3_2.R")
source("levels/level_3/level3_3.R")
source("levels/level_3/level3_4.R")
source("levels/level_3/level3_5.R")

source("transitions/transition3_4.R")
source("levels/level_4/level4_1.R")
source("levels/level_4/level4_2.R")
source("levels/level_4/level4_3.R")
source("levels/level_4/level4_4.R")
source("levels/level_4/level4_5.R")

source("transitions/transition4_5.R")
source("levels/level_5/level5_1.R")
source("levels/level_5/level5_2.R")
source("levels/level_5/level5_3.R")
source("levels/level_5/level5_4.R")
source("levels/level_5/level5_5.R")

source("transitions/transition5_end.R")


# ---------------------------------------------------------
# STATE MACHINE
# ---------------------------------------------------------
current_page <- reactiveVal("transition_opening_1")   # startpagina

# ---------------------------------------------------------
# INTRO TEKST (typing effect)
# ---------------------------------------------------------
lines <- c(
  "Welkom bij Helix-9 Onderzoeksbunker.",
  "Je bent ingepland voor een reguliere onderzoeksdienst.",
  "Na het inloggen worden de werkzaamheden voor vandaag geladen.",
  "Controleer de planning en voer de toegewezen onderzoekstaken in de aangegeven volgorde uit.",
  "Voltooi alle taken volgens de geldende laboratoriumprotocollen.",
  "Meld eventuele afwijkingen via het interne registratiesysteem.",
  "Wij wensen je een prettige en productieve werkdag."
)

rv <- reactiveValues(
  current_line = 1,
  current_char = 0,
  is_pausing   = FALSE,
  char_delay   = 20,
  line_pause   = 200
)

# ---------------------------------------------------------
# UI COMPONENTS
# ---------------------------------------------------------

# STARTPAGINA
start_page_ui <- function() {
  div(class = "landing-container",
      
      h1(class = "game-title", "Rscaping the Bunker"),
      
      div(id = "typed_text", class = "intro-text", ""),
      
      actionButton("skip_intro", "Skip", class = "start-btn"),
      br(),
      actionButton("start_game", "Login", class = "start-btn", style = "display:none;")
  )
}

# EINDSCHERM
end_page_ui <- function() {
  
  div(
    class = "landing-container",
    
    h1("MISSION COMPLETE"),
    
    div(
      
      id = "ending_text",
      
      class = "terminal-output",
      
      tags$pre(
        "",
        id = "ending_terminal",
        style="
          color:#00FF00;
          background:none;
          border:none;
          font-family:'Courier New', monospace;
          font-size:18px;
          text-align:left;
          white-space:pre-wrap;
          min-height:320px;
          margin:25px auto;
          text-shadow:0 0 8px #00FF00;
        "
      )
      
    ),
    
    div(
      style="
      overflow:hidden;
      white-space:nowrap;
      border-top:2px solid #00FF00;
      border-bottom:2px solid #00FF00;
      padding:12px;
      margin-top:20px;
      ",
      
      tags$div(
        style="
        display:inline-block;
        padding-left:100%;
        animation:ticker 25s linear infinite;
        ",
        
        "DEVELOPERS • OLIVE OPREL • CHELAYSIAH STEBA • SUPERVISOR • BAS VAN GESTEL • PLAYTESTERS • TO BE DETERMINED • BUILT WITH R & SHINY • THANK YOU FOR PLAYING RSCAPING THE BUNKER •"
      )
      
    ),
    
    br(),
    br(),
    
    actionButton(
      "confetti_btn",
      "CELEBRATE",
      class = "start-btn"
    ),
    
    actionButton(
      "end_transmission",
      "END TRANSMISSION",
      class = "start-btn"
    )
    
  )
  
}

# ---------------------------------------------------------
# ROOT UI
# ---------------------------------------------------------
ui <- fluidPage(
  useShinyjs(),
  
  # ---------- CSS ----------
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
        font-size: 1.2em;
        padding: 10px 30px;
        background-color: #1c1c1c;
        color: #00FF00;
        border: 2px solid #00FF00;
        cursor: pointer;
        transition: all 0.3s ease;
      }
      .start-btn:hover {
        background-color: #00FF00;
        color: #1c1c1c;
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
      @keyframes ticker{

  from{
    transform:translateX(0%);
  }

  to{
    transform:translateX(-100%);
  }
  

}
    ")),
    
    # ---------- JS ----------
    tags$script(HTML("

Shiny.addCustomMessageHandler('updateText', function(message) {
  document.getElementById('typed_text').innerHTML = message;
});

Shiny.addCustomMessageHandler('showStartButton', function(message) {
  document.getElementById('start_game').style.display = 'inline-block';
});

Shiny.addCustomMessageHandler('skipIntroText', function(message) {
  document.getElementById('typed_text').innerHTML = message;
});

Shiny.addCustomMessageHandler('confetti', function(message) {

  const chars = [
    '0','1',
    '#','+','*',
    '[',']',
    '{','}',
    '<','>',
    '/',
    '\\\\',
    '=',
    'A','F','C','9'
  ];

  for(let i = 0; i < 220; i++){

    const p = document.createElement('div');

    p.innerHTML = chars[Math.floor(Math.random()*chars.length)];

    p.style.position = 'fixed';
    p.style.left = Math.random()*100 + 'vw';
    p.style.top = '-30px';

    p.style.color = '#00ff66';
    p.style.fontFamily = 'Courier New, monospace';
    p.style.fontWeight = 'bold';
    p.style.fontSize = (Math.random()*12 + 10) + 'px';

    p.style.textShadow = '0 0 10px #00ff00';
    p.style.pointerEvents = 'none';
    p.style.zIndex = '99999';

    const drift = (Math.random()-0.5)*180;
    const rotate = (Math.random()*720)-360;
    const duration = 2000 + Math.random()*3000;

    p.animate(
      [
        {
          transform:'translate(0px,0px) rotate(0deg)',
          opacity:1
        },
        {
          transform:'translate('+drift+'px,110vh) rotate('+rotate+'deg)',
          opacity:0
        }
      ],
      {
        duration:duration,
        easing:'linear'
      }
    );

    document.body.appendChild(p);

    setTimeout(function(){
      p.remove();
    }, duration);

  }

});

Shiny.addCustomMessageHandler('greenFlash', function(message){

  document.body.style.transition = 'background-color 0.2s';
  document.body.style.backgroundColor = '#003300';

  setTimeout(function(){
    document.body.style.backgroundColor = '#1c1c1c';
  },2000);

});

Shiny.addCustomMessageHandler('redFlash', function(message){

  document.body.style.transition = 'background-color 0.2s';
  document.body.style.backgroundColor = '#4a0000';

  setTimeout(function(){
    document.body.style.backgroundColor = '#1c1c1c';
  },2000);

});

Shiny.addCustomMessageHandler('endingType', function(message){

  const terminal = document.getElementById('ending_terminal');

  if(!terminal) return;

  terminal.innerHTML = '';

  let i = 0;

  function type(){

    if(i < message.length){

      terminal.innerHTML += message.charAt(i);

      i++;

      setTimeout(type,20);

    }

  }

  type();

});

"))
  ),
  
  uiOutput("main_ui")
)

# ---------------------------------------------------------
# SERVER
# ---------------------------------------------------------
start_page_server <- function(input, output, session, current_page) {
  
  # Skip: toon volledige tekst + startknop
  observeEvent(input$skip_intro, {
    
    # 1. Stop type-effect door een custom message naar JS te sturen
    session$sendCustomMessage("updateText", paste(lines, collapse = "\n"))
    
    # 2. Startknop zichtbaar maken
    session$sendCustomMessage("showStartButton", TRUE)
  })
  
  # Start Missie → transition
  observeEvent(input$start_game, {
    current_page("transition_opening_1")
  })
}


ending_text <- paste(
  
  "> INITIALIZING FINAL REPORT...",
  "> RESTORING SECURITY MODULES...",
  "> VERIFYING CONTAINMENT...",
  "> OPENING BUNKER DOORS...",
  "> CONNECTION STABLE",
  "",
  "MISSION SUCCESSFUL",
  "",
  "SYSTEM STATUS        : STABLE",
  "VIRUS CONTAINMENT    : SUCCESS",
  "ALL SECURITY MODULES : ONLINE",
  "BUNKER STATUS        : UNLOCKED",
  "",
  "> READY FOR TERMINATION? █",
  
  sep = "\n"
  
)

server <- function(input, output, session) {
  
  observe({
    print(current_page())
  })
  
  start_page_server(input, output, session, current_page)
  transition_opening_1_server(input, output, session, current_page)
  
  level1_1_server(input, output, session, current_page)
  level1_2_server(input, output, session, current_page)
  level1_3_server(input, output, session, current_page)
  level1_4_server(input, output, session, current_page)
  
  transition1_2_server(input, output, session, current_page)
  
  level2_1_server(input, output, session, current_page)
  level2_2_server(input, output, session, current_page)
  level2_3_server(input, output, session, current_page)
  level2_4_server(input, output, session, current_page)
  
  
  transition2_3_server(input, output, session, current_page)
  
  level3_1_server(input, output, session, current_page)
  level3_2_server(input, output, session, current_page)
  level3_3_server(input, output, session, current_page)
  level3_4_server(input, output, session, current_page)
  
  transition3_4_server(input, output, session, current_page)
  
  level4_1_server(input, output, session, current_page)
  level4_2_server(input, output, session, current_page)
  level4_3_server(input, output, session, current_page)
  level4_4_server(input, output, session, current_page)
  level4_5_server(input, output, session, current_page)
  
  transition4_5_server(input, output, session, current_page)
  
  level5_1_server(input, output, session, current_page)
  level5_2_server(input, output, session, current_page)
  level5_3_server(input, output, session, current_page)
  level5_4_server(input, output, session, current_page)
  level5_5_server(input, output, session, current_page)
  
  transition5_end_server(input, output, session, current_page)
  
  # ROUTER
  output$main_ui <- renderUI({
    if (current_page() == "intro") {
      
      start_page_ui()
      
    } else if (current_page() == "transition_opening_1") {
      
      transition_opening_1_ui()
      
    } else if (current_page() == "level1_1") {
      
      level1_1_ui()
      
    } else if (current_page() == "level1_2") {
      
      level1_2_ui()
      
    } else if (current_page() == "level1_3") {
      
      level1_3_ui()
      
    } else if (current_page() == "level1_4") {
      
      level1_4_ui()
      
    } else if (current_page() == "transition1_2") {
      
      transition1_2_ui()
      
    } else if (current_page() == "level2_1") {
      
      level2_1_ui()
      
    } else if (current_page() == "level2_2") {
      
      level2_2_ui()
      
    } else if (current_page() == "level2_3") {
      
      level2_3_ui()
      
    } else if (current_page() == "level2_4") {
      
      level2_4_ui()
      
    } else if (current_page() == "transition_2_3") {
      
      transition_2_3_ui()
      
    } else if (current_page() == "level3_1") {
      
      level3_1_ui()
      
    } else if (current_page() == "level3_2") {
      
      level3_2_ui()
      
    } else if (current_page() == "level3_3") {
      
      level3_3_ui()
      
    } else if (current_page() == "level3_4") {
      
      level3_4_ui()
      
    } else if (current_page() == "transition_3_4") {
      
      transition_3_4_ui()
      
    } else if (current_page() == "level4_1") {
      
      level4_1_ui()
      
    } else if (current_page() == "level4_2") {
      
      level4_2_ui()
      
    } else if (current_page() == "level4_3") {
      
      level4_3_ui()
      
    } else if (current_page() == "level4_4") {
      
      level4_4_ui()
      
    } else if (current_page() == "level4_5") {
      
      level4_5_ui()
      
    } else if (current_page() == "transition_4_5") {
      
      transition_4_5_ui()
      
    } else if (current_page() == "level5_1") {
      
      level5_1_ui()
      
    } else if (current_page() == "level5_2") {
      
      level5_2_ui()
      
    } else if (current_page() == "level5_3") {
      
      level5_3_ui()
      
    } else if (current_page() == "level5_4") {
      
      level5_4_ui()
      
    } else if (current_page() == "level5_5") {
      
      level5_5_ui()
      
    } else if (current_page() == "transition5_end") {
      
      transition5_end_ui()
      
    } else if (current_page() == "end") {
      
      end_page_ui()
    }
  })
  
  # ---------------------------------------------------------
  # TYPEWRITER EFFECT EINDSCHERM
  # ---------------------------------------------------------
  observeEvent(current_page(), {
    
    req(current_page() == "end")
    
    later::later(function(){
      
      session$sendCustomMessage(
        "endingType",
        ending_text
      )
      
    }, delay = 0.3)
    
  }, ignoreInit = TRUE)
  
  # ---------------------------------------------------------
  # TYPING EFFECT
  # ---------------------------------------------------------
  observe({
    if (current_page() != "intro") return()
    
    current_line <- isolate(rv$current_line)
    current_char <- isolate(rv$current_char)
    is_pausing   <- isolate(rv$is_pausing)
    
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
  
  # ---------------------------------------------------------
  # SKIP INTRO
  # ---------------------------------------------------------
  observeEvent(input$skip_intro, {
    rv$current_line <- length(lines) + 1
    rv$current_char <- 0
    rv$is_pausing   <- FALSE
    
    final_text <- paste(lines, collapse = "\n")
    final_text <- paste0(final_text, "\n<span class='caret'></span>")
    
    session$sendCustomMessage("skipIntroText", final_text)
    session$sendCustomMessage("showStartButton", TRUE)
    
    shinyjs::hide("skip_intro")
  })
  
  # ---------------------------------------------------------
  # EINDSCHERM -> INTRO (restart)
  # ---------------------------------------------------------
  observeEvent(input$restart_game, {
    current_page("intro")
    rv$current_line <- 1
    rv$current_char <- 0
    rv$is_pausing   <- FALSE
    session$sendCustomMessage("updateText", "")
    shinyjs::show("skip_intro")
    shinyjs::hide("start_game")
  })
  
  # ---------------------------------------------------------
  # CONFETTI en stop app
  # ---------------------------------------------------------
  observeEvent(input$confetti_btn, {
    session$sendCustomMessage("confetti", TRUE)
  })
  
  # ---------------------------------------------------------
  # END TRANSMISSION
  # ---------------------------------------------------------
  observeEvent(input$end_transmission, {
    
    showModal(
      modalDialog(
        title = "Terminate connection?",
        "Are you sure you want to terminate the connection?",
        footer = tagList(
          actionButton("play_again", "Play Again"),
          actionButton("terminate_yes", "Terminate")
        ),
        easyClose = TRUE
      )
    )
    
  })
  
  observeEvent(input$play_again, {
    
    removeModal()
    
    current_page("intro")
    
    rv$current_line <- 1
    rv$current_char <- 0
    rv$is_pausing <- FALSE
    
    session$sendCustomMessage("updateText", "")
    
    shinyjs::show("skip_intro")
    shinyjs::hide("start_game")
    
  })
  
  observeEvent(input$terminate_yes, {
    
    stopApp()
    
  })
}

# ---------------------------------------------------------
# RUN APP
# ---------------------------------------------------------
shinyApp(ui, server)