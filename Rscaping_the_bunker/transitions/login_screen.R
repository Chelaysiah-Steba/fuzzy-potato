login_screen_ui <- function() {
  fluidPage(
    tags$head(
      tags$style(HTML("
        body {
          background: #020403;
          overflow: hidden;
        }

        .terminal-window {
          width: min(920px, 94vw);
          height: min(560px, 76vh);
          margin: 5vh auto;
          padding: 18px;
          background: radial-gradient(circle at top, #0f1f18 0%, #040607 72%);
          border: 1px solid rgba(0, 255, 120, 0.28);
          border-radius: 12px;
          box-shadow: 0 0 0 1px rgba(0, 255, 120, 0.08), 0 0 50px rgba(0, 255, 120, 0.12);
          position: relative;
          overflow: hidden;
        }

        .terminal-window::before {
          content: '';
          position: absolute;
          inset: 0;
          background: linear-gradient(rgba(255,255,255,0.02), rgba(0,0,0,0.04));
          pointer-events: none;
        }

        .terminal-window::after {
          content: '';
          position: absolute;
          inset: 0;
          background: repeating-linear-gradient(
            to bottom,
            rgba(255,255,255,0.03) 0px,
            rgba(255,255,255,0.03) 1px,
            transparent 2px,
            transparent 4px
          );
          pointer-events: none;
          opacity: 0.26;
        }

        .terminal-screen {
          position: relative;
          z-index: 1;
          height: 100%;
          display: flex;
          flex-direction: column;
          justify-content: space-between;
          color: #66ff99;
          font-family: 'IBM Plex Mono', 'Courier New', monospace;
          font-size: 1.05rem;
          line-height: 1.65;
          text-shadow: 0 0 6px rgba(102, 255, 153, 0.35);
        }

        .terminal-log {
          white-space: pre-wrap;
          overflow: hidden;
          flex: 1;
        }

        .terminal-line {
          min-height: 1.65em;
        }

        .cursor {
          display: inline-block;
          margin-left: 2px;
          animation: blink 0.9s steps(1) infinite;
        }

        @keyframes blink {
          50% { opacity: 0; }
        }
      "))
    ),
    tags$div(
      class = "terminal-window",
      tags$div(
        class = "terminal-screen",
        tags$div(
          class = "terminal-log",
          tags$div(
            class = "terminal-line",
            HTML("<span id='login_typed'></span><span class='cursor'>▍</span>")
          )
        )
      )
    ),
    tags$script(HTML("
      Shiny.addCustomMessageHandler('login_screen_type', function(message) {
        var el = document.getElementById('login_typed');
        if (el) el.innerHTML = message.text || '';
      });
    "))
  )
}

login_screen_server <- function(input, output, session, current_page) {
  lines <- c(
    "HELIX-9 RESEARCH NETWORK v4.8",
    "",
    "Username: research_operator_27",
    "Password: ************",
    "",
    "Authenticating...",
    "",
    "Authentication successful.",
    "",
    "Employee ID : R-027",
    "Clearance   : Level 2",
    "Department  : Pathogen Research",
    "",
    "Loading daily assignments...",
    "Connecting to internal network...",
    "Session established.",
    "",
    "Redirecting..."
  )
  
  rv <- reactiveValues(
    line_idx = 1,
    char_idx = 0,
    pause = 0,
    finished = FALSE
  )
  
  output$main_ui <- NULL
  
  observe({
    req(current_page() == "login_screen")
    invalidateLater(35, session)
    
    if (rv$finished) return()
    
    if (rv$pause > 0) {
      rv$pause <- rv$pause - 1
      return()
    }
    
    if (rv$line_idx > length(lines)) {
      rv$finished <- TRUE
      current_page("transition_opening_1")
      return()
    }
    
    line <- lines[rv$line_idx]
    
    if (nchar(line) == 0) {
      rv$line_idx <- rv$line_idx + 1
      rv$char_idx <- 0
      session$sendCustomMessage(
        "login_screen_type",
        list(text = paste(lines[1:(rv$line_idx - 1)], collapse = "\\n"))
      )
      return()
    }
    
    if (rv$char_idx < nchar(line)) {
      rv$char_idx <- rv$char_idx + 1
      typed_line <- substr(line, 1, rv$char_idx)
      previous_lines <- if (rv$line_idx > 1) lines[1:(rv$line_idx - 1)] else character(0)
      full_text <- paste(c(previous_lines, typed_line), collapse = "\\n")
      session$sendCustomMessage(
        "login_screen_type",
        list(text = full_text)
      )
    } else {
      full_text <- paste(lines[1:rv$line_idx], collapse = "\\n")
      session$sendCustomMessage(
        "login_screen_type",
        list(text = full_text)
      )
      
      if (line %in% c("Authenticating...", "Redirecting...")) {
        rv$pause <- 28
      }
      
      rv$line_idx <- rv$line_idx + 1
      rv$char_idx <- 0
    }
  })
}