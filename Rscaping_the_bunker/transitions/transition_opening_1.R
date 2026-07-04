# ui
transition_opening_1_ui <- function() {
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

.progress-shell {
height: 14px;
border-radius: 999px;
background: rgba(0, 255, 120, 0.10);
border: 1px solid rgba(0, 255, 120, 0.25);
overflow: hidden;
box-shadow: 0 0 16px rgba(0, 255, 120, 0.10);
margin-top: 12px;
}

.progress-fill {
height: 100%;
width: 0%;
background: linear-gradient(90deg, #00ff88, #9affc8);
box-shadow: 0 0 12px rgba(0, 255, 120, 0.45);
transition: width 0.12s linear;
}

.progress-label {
color: #66ff99;
font-family: 'IBM Plex Mono', 'Courier New', monospace;
font-size: 0.8rem;
margin-top: 6px;
opacity: 0.85;
}

.alert-flash {
animation: redflash 0.16s infinite alternate;
}

@keyframes redflash {
from { background: #020403; }
to { background: #5a0000; }
}

.modal-content {
background: #050807 !important;
color: #66ff99 !important;
border: 1px solid rgba(0, 255, 120, 0.28) !important;
box-shadow: 0 0 40px rgba(0, 255, 120, 0.15) !important;
}

.modal-header, .modal-footer {
border-color: rgba(0, 255, 120, 0.15) !important;
}

.modal-title {
color: #66ff99 !important;
font-family: 'IBM Plex Mono', 'Courier New', monospace;
}

.modal-body {
color: #66ff99 !important;
font-family: 'IBM Plex Mono', 'Courier New', monospace;
}

.btn-default, .btn-primary {
background: #07110b !important;
color: #66ff99 !important;
border: 1px solid rgba(0, 255, 120, 0.35) !important;
box-shadow: none !important;
}

.btn-default:hover, .btn-primary:hover {
background: #0b1a11 !important;
color: #9affc8 !important;
}
"))
    ),
    
    uiOutput("hx_lines"),
    
    tags$script(HTML("
Shiny.addCustomMessageHandler('hx_progress', function(msg) {
var v = Math.max(0, Math.min(100, msg.value || 0));
var fill = document.getElementById('hx_pb_fill');
var label = document.getElementById('hx_pb_label');
if (fill) fill.style.width = v + '%';
if (label) label.textContent = (msg.label || 'BOOT SEQUENCE') + ' ' + Math.round(v) + '%';
});

Shiny.addCustomMessageHandler('hx_flash_red', function(msg) {
document.body.classList.add('alert-flash');
setTimeout(function() {
document.body.classList.remove('alert-flash');
}, 2200);
});
"))
  ) }

# server

transition_opening_1_server <- function(input, output, session, current_page) {
  rv <- reactiveValues(
    started = FALSE,
    running = FALSE,
    mode = "boot",
    char_idx = 1,
    current_line = "",
    lines = character(),
    progress = 0,
    hold = 0,
    retry_count = 0,
    noise_idx = 1,
    modal_queue = character(),
    modal_active = FALSE,
    boot_done = FALSE
  )
  
  boot_texts <- c(
    "REBOOT SEQUENCE INITIATED...",
    "RESTORING KERNEL ACCESS...",
    "LOADING CONTAINMENT MAPS..."
  )
  
  noise_texts <- c(
    "ERROR: MEMORY LEAK DETECTED.",
    "ERROR: SIGNAL DROPPED.",
    "ERROR: CORE THREAD UNSTABLE.",
    "ERROR: ACCESS ROUTE CORRUPTED.",
    "ERROR: FALLBACK BUFFER OVERFLOW.",
    "ERROR: SECURITY LAYER COMPROMISED.",
    "ERROR: WATCHDOG FAILURE.",
    "ERROR: SYSTEM DESYNCHRONIZED."
  )
  
  output$hx_lines <- renderUI({
    req(current_page() == "transition_opening_1")
    tagList(
      tags$div(
        class = "terminal-window",
        tags$div(
          class = "terminal-screen",
          tags$div(
            class = "terminal-log",
            lapply(rv$lines, function(x) tags$div(class = "terminal-line", HTML(x))),
            tags$div(
              class = "terminal-line",
              HTML(paste0(rv$current_line, '<span class="cursor">▍</span>'))
            )
          ),
          tags$div(
            tags$div(class = "progress-shell",
                     tags$div(id = "hx_pb_fill", class = "progress-fill")),
            tags$div(id = "hx_pb_label", class = "progress-label", "BOOT SEQUENCE 0%")
          )
        )
      )
    )
  })
  
  set_progress <- function(v, label) {
    rv$progress <- max(0, min(100, v))
    session$sendCustomMessage("hx_progress", list(value = rv$progress, label = label))
  }
  
  show_next_modal <- function() {
    if (rv$modal_active || length(rv$modal_queue) == 0) return()
    rv$modal_active <- TRUE
    msg <- rv$modal_queue
    
    rv$modal_queue <- rv$modal_queue[-1]
    
    if (rv$retry_count == 0) {
      showModal(modalDialog(
        title = "SYSTEM WARNING",
        msg,
        easyClose = FALSE,
        footer = actionButton("hx_retry_btn", "RETRY")
      ))
    } else {
      showModal(modalDialog(
        title = "CRITICAL WARNING",
        msg,
        easyClose = FALSE,
        footer = tagList(
          actionButton("hx_continue_btn", "CONTINUE"),
          actionButton("hx_logout_btn", "LOGOUT")
        )
      ))
    }
  }
  
  push_modal <- function(msgs) {
    rv$modal_queue <- c(rv$modal_queue, msgs)
    show_next_modal()
  }
  
  start_boot <- function() {
    rv$running <- TRUE
    rv$mode <- "boot"
    rv$char_idx <- 1
    rv$current_line <- ""
    rv$hold <- 0
    rv$boot_done <- FALSE
    if (rv$retry_count == 0) {
      rv$progress <- 79
      session$sendCustomMessage("hx_progress",
                                list(value = 79, label = "BOOT SEQUENCE"))
    } else {
      rv$progress <- 0
      session$sendCustomMessage("hx_progress",
                                list(value = 0, label = "RETRY SEQUENCE"))
    }
  }
  
  observeEvent(current_page(), {
    if (current_page() == "transition_opening_1" && !rv$started) {
      rv$started <- TRUE
      rv$lines <- character()
      rv$progress <- 0
      rv$retry_count <- 0
      start_boot()
    }
    if (current_page() != "transition_opening_1") {
      rv$started <- FALSE
      rv$running <- FALSE
    }
  }, ignoreInit = FALSE)
  
  observe({
    req(current_page() == "transition_opening_1")
    invalidateLater(60, session)
    
    if (rv$hold > 0) {
      rv$hold <- rv$hold - 1
      return()
    }
    
    if (rv$running && rv$mode == "boot") {
      txt <- boot_texts[min(length(boot_texts), length(rv$lines) + 1)]
      
      if (rv$char_idx <= nchar(txt)) {
        rv$current_line <- substr(txt, 1, rv$char_idx)
        rv$char_idx <- rv$char_idx + 1
      } else {
        rv$lines <- c(rv$lines, txt)
        rv$current_line <- ""
        rv$char_idx <- 1
        rv$hold <- 10
        if (length(rv$lines) >= length(boot_texts)) {
          rv$mode <- "boot_wait"
          rv$hold <- 12
        }
      }
      
      set_progress(rv$progress + 0.35, if (rv$retry_count == 0) "BOOT SEQUENCE" else "RETRY SEQUENCE")
      if (rv$progress >= 79) {
        rv$running <- FALSE
        rv$modal_queue <- character()
        push_modal("Unable to complete reboot sequence. Core recovery has failed.")
      }
      return()
    }
    
    if (rv$mode == "boot_wait") {
      rv$progress <- 78
      session$sendCustomMessage("hx_progress", list(value = 78, label = if (rv$retry_count == 0) "BOOT SEQUENCE" else "RETRY SEQUENCE"))
      rv$running <- FALSE
      push_modal("Unable to complete reboot sequence. Core recovery has failed.")
      rv$mode <- "waiting_retry"
      return()
    }
    
    if (rv$mode == "noise") {
      
      if (rv$progress < 39) {
        set_progress(min(rv$progress + 0.6, 39), "FAILOVER")
      }
      rv$lines <- c(rv$lines, noise_texts[(rv$noise_idx - 1) %% length(noise_texts) + 1])
      rv$noise_idx <- rv$noise_idx + 1
      
      if (rv$noise_idx <= 8) {
        push_modal(noise_texts[(rv$noise_idx - 2) %% length(noise_texts) + 1])
      }
      
      if (rv$noise_idx > 8) {
        session$sendCustomMessage("hx_flash_red", list())
        rv$modal_queue <- character()
        rv$modal_active <- FALSE
        showModal(modalDialog(
          title = "CRITICAL WARNING",
          "MANUAL OVERRIDE REQUIRED.",
          easyClose = FALSE,
          footer = tagList(
            actionButton("hx_continue_btn", "CONTINUE"),
            actionButton("hx_logout_btn", "LOGOUT")
          )
        ))
        rv$mode <- "critical"
      }
      return()
    }
  })
  
  observeEvent(input$hx_retry_btn, {
    removeModal()
    rv$modal_active <- FALSE
    rv$modal_queue <- character()
    rv$retry_count <- rv$retry_count + 1
    rv$lines <- character()
    rv$current_line <- ""
    rv$progress <- 0
    rv$noise_idx <- 1
    rv$mode <- "noise"
    rv$running <- TRUE
    set_progress(0, "RETRY SEQUENCE")
  }, ignoreInit = TRUE)
  
  observeEvent(input$hx_continue_btn, {
    removeModal()
    rv$modal_active <- FALSE
    # navigate using the host app's current_page reactiveVal
    current_page("level1_intro")
  }, ignoreInit = TRUE)
  
  observeEvent(input$hx_logout_btn, {
    removeModal()
    rv$modal_active <- FALSE
    current_page("logout")
  }, ignoreInit = TRUE)
  
  invisible(NULL)
}
