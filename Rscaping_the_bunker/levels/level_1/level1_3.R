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

@keyframes redFlash {
0% { background: rgba(255,0,0,0); }
20% { background: rgba(255,0,0,0.18); }
100% { background: rgba(255,0,0,0); }
}
"))
    ),
    
    tags$script(HTML("
(function() {
function ensureFlash() {
if (!document.getElementById('red-flash-overlay')) {
const d = document.createElement('div');
d.id = 'red-flash-overlay';
d.className = 'red-flash';
document.body.appendChild(d);
}
}

if (window.Shiny && Shiny.addCustomMessageHandler) {
Shiny.addCustomMessageHandler('redFlash', function(message) {
ensureFlash();
const flash = document.getElementById('red-flash-overlay');
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
        
        uiOutput("editor_ui")
      ),
      
      div(
        class = "console",
        
        h3("Console"),
        
        verbatimTextOutput("console_output"),
        
        shinyjs::hidden(
          actionButton(
            "next_level1_4",
            "Volgende",
            class = "next-btn"
          )
        )
      )
    )
  )
}

level1_3_server <- function(input, output, session, current_page) {
  
  output$console_output <- renderText({
    paste(
      "✖ System error.",
      "Module 'bootSequenceR' is missing.",
      "",
      "boot_sequence()",
      "Error: could not find function 'boot_sequence'",
      sep = "\n"
    )
  })
  
  output$editor_ui <- renderUI({
    tagList(
      h3("level 1.3: Error analyseren"),
      
      p("Wat betekent deze foutmelding?"),
      
      radioButtons(
        inputId = "q1",
        label = NULL,
        choices = c(
          "De data bestaat niet" = "A",
          "De functie komt uit een package dat niet geladen is" = "B",
          "Er zit een typefout in de code" = "C"
        )
      ),
      
      actionButton("submit_q1", "Submit", class = "start-btn")
    )
  })
  
  observeEvent(input$submit_q1, {
    req(input$q1)
    
    if (input$q1 == "B") {
      
      output$console_output <- renderText({
        paste(
          "✔ Correct.",
          "De functie 'boot_sequence()' komt uit een package die nog niet geladen is.",
          sep = "\n"
        )
      })
      
      shinyjs::show("next_level1_4")
      
    } else {
      
      session$sendCustomMessage("redFlash", TRUE)
      
      output$console_output <- renderText({
        paste(
          "✖ Incorrect.",
          "Probeer opnieuw.",
          sep = "\n"
        )
      })
      
      shinyjs::hide("next_level1_4")
    }
  })
  
  observeEvent(input$next_level1_4, {
    current_page("level1_4")
  })
}