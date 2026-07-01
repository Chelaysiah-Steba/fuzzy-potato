# laden van packages
library(shiny)
library(shinyjs)
library(tidyverse)
library(later)

# laden van source materiaal (level scripts en vraagtypefuncties)
source("modules.R")
source("levels/level_2/level2_1.R")
source("levels/level_2/level2_2.R")
source("levels/level_2/level2_3.R")
source("levels/level_2/level2_4.R")


# ---------------------------------------------------------
# STATE MACHINE
# ---------------------------------------------------------
current_page <- reactiveVal("intro")   # startpagina

# ---------------------------------------------------------
# INTRO TEKST (typing effect)
# ---------------------------------------------------------
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
      actionButton("start_game", "Start Missie", class = "start-btn", style = "display:none;")
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
  
  level2_1_server(input, output, session, current_page)
  level2_2_server(input, output, session, current_page)
  level2_3_server(input, output, session, current_page)
  level2_4_server(input, output, session, current_page)
  
  # ROUTER
  output$main_ui <- renderUI({
    if (current_page() == "intro") {
      
      start_page_ui()
      
    } else if (current_page() == "level2_1") {
      
      level2_1_ui()
      
    } else if (current_page() == "level2_2") {
      
      level2_2_ui()
      
    } else if (current_page() == "level2_3") {
      
      level2_3_ui()
      
    } else if (current_page() == "level2_4") {
      
      level2_4_ui()
      
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
  # START GAME → INFO POP-UP
  # ---------------------------------------------------------
  observeEvent(input$start_game, {
    showModal(modalDialog(
      title = "LEVEL 2 — Introductie",
      "Tijdens het stabiliseren van het beveiligingssysteem is vastgesteld dat correcte data‑invoer essentieel is. Ruwe laboratoriumbestanden worden aangeleverd als TSV‑data, die alleen veilig verwerkt kan worden wanneer het juiste scheidingsteken en decimaalformaat worden ingesteld. Na het inlezen moet de onderzoeker controleren of alle variabelen correct zijn geïnterpreteerd, omdat foutieve kolomtypes het virusmonitoringsysteem kunnen verstoren. Voor het analyseren van verspreidingspatronen gebruikt het systeem visualisaties: scatterplots om relaties tussen metingen te detecteren, histogrammen om verdelingen te beoordelen en boxplots om afwijkingen en mogelijke besmettingspieken te identificeren. Heldere labels zijn noodzakelijk om snel beslissingen te nemen. Deze kennis is vereist om de volgende beveiligingslaag te activeren.",
      footer = tagList(
        modalButton("Sluiten"),
        actionButton("continue_btn", "Ga verder")
      ),
      easyClose = TRUE
    ))
  })
  
  # ---------------------------------------------------------
  # INFO POP-UP → level 2.1
  # ---------------------------------------------------------
  observeEvent(input$continue_btn, {
    current_page("level2_1")
    removeModal()
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
