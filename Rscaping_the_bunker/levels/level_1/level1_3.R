level1_3_ui <- function() {
  fluidPage(
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
width: 300px;
background-color: #000000;
color: #00FF00;
border: 2px solid #00FF00;
font-family: 'Courier New', monospace;
padding: 5px;
}

.next-btn{
margin-top:20px;
background:#1c1c1c;
color:#00FF00;
border:2px solid #00FF00;
padding:10px 20px;
font-family:'Courier New';
cursor:pointer;
}

.start-btn{
margin-top:20px;
background:#1c1c1c;
color:#00FF00;
border:2px solid #00FF00;
padding:10px 20px;
font-family:'Courier New';
cursor:pointer;
}

.red-flash {
position: fixed;
inset: 0;
pointer-events: none;
z-index: 9999;
background: rgba(255, 0, 0, 0);
}

.red-flash.active {
animation: redFlash 0.35s ease-out 1;
}

.green-flash {
position: fixed;
inset: 0;
pointer-events: none;
z-index: 9999;
background: rgba(0, 255, 0, 0);
}

.green-flash.active {
animation: greenFlash 0.35s ease-out 1;
}

@keyframes redFlash {
0% { background: rgba(255,0,0,0); }
20% { background: rgba(255,0,0,0.18); }
100% { background: rgba(255,0,0,0); }
}

@keyframes greenFlash {
0% { background: rgba(0,255,0,0); }
20% { background: rgba(0,255,0,0.14); }
100% { background: rgba(0,255,0,0); }
}
"))
    ),
    
    tags$script(HTML("
(function() {
function ensureFlash(id, cls) {
if (!document.getElementById(id)) {
const d = document.createElement('div');
d.id = id;
d.className = cls;
document.body.appendChild(d);
}
}

if (window.Shiny && Shiny.addCustomMessageHandler) {
Shiny.addCustomMessageHandler('redFlash', function(message) {
ensureFlash('red-flash-overlay', 'red-flash');
const flash = document.getElementById('red-flash-overlay');
flash.classList.remove('active');
void flash.offsetWidth;
flash.classList.add('active');
});

Shiny.addCustomMessageHandler('greenFlash', function(message) {
ensureFlash('green-flash-overlay', 'green-flash');
const flash = document.getElementById('green-flash-overlay');
flash.classList.remove('active');
void flash.offsetWidth;
flash.classList.add('active');
});
}
})();
")),
    
    div(
      class = "game-container",
      
      div(
        class = "editor",
        
        h3("🔧 Level 1.3: Package fixen"),
        
        p("Laad het juiste package zodat de code werkt."),
        
        div(
          class = "code-box",
          HTML("boot_sequence()")
        ),
        
        textInput("fix_input", "Typ je code:", "", placeholder = "type je code"),
        
        actionButton("run_fix", "▶ RUN CODE")
      ),
      
      div(
        class = "console",
        
        h3("Console"),
        
        verbatimTextOutput("console_output"),
        
        br(),
        
        uiOutput("answer_ui")
      )
    )
  ) }

level1_3_server <- function(input, output, session, current_page) {
  
  output$console_output <- renderText({
    ""
  })
  
  output$answer_ui <- renderUI({
    NULL
  })
  
  observeEvent(input$run_fix, {
    
    req(input$fix_input)
    
    clean <- gsub('^"|"$', '', trimws(input$fix_input))
    
    if (clean == "library(bootSequenceR)") {
      
      session$sendCustomMessage("greenFlash", TRUE)
      
      output$console_output <- renderText({
        paste(
          "✔ Module loaded successfully.",
          "System boot restored.",
          sep = "\n"
        )
      })
      
      output$answer_ui <- renderUI({
        tagList(
          actionButton("next_level1_4", "Volgende", class = "next-btn")
        )
      })
      
    } else {
      
      session$sendCustomMessage("redFlash", TRUE)
      
      output$console_output <- renderText({
        paste0(
          "✖ Incorrect command.\n",
          "You typed: ", clean, "\n\n",
          "Hint: Load the missing module with:\n",
          "library(bootSequenceR)"
        )
      })
      
    }
    
  })
  
  observeEvent(input$next_level1_4, {
    current_page("level1_4")
  })
  
}