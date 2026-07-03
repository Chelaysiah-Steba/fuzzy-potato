security_database <- data.frame(
  sample_id = c("GO1", "GO2", "GO3", "GO4", "GO5", "GO6", "GO7", "GO8", "GO9", "GO10"),
  sector = c("Alpha", "Beta", "Gamma", "Alpha", "Delta", "Beta", "Gamma", "Alpha", "Delta", "Beta"),
  terminal = c("T01", "T02", "T03", "T04", "T05", "T06", "T07", "T08", "T09", "T10"),
  status = c("Online", "Offline", "Online", "Offline", "Online", "Online", "Offline", "Online", "Offline", "Online"),
  stringsAsFactors = FALSE
)

saveRDS(security_database, "security_database.rds")

level1_4_ui <- function() {
  question <- render_question(
    list(
      id = "security_database_file",
      type = "dropdown",
      prompt = "security_database <- readRDS( ... )",
      options = c(
        "\"security_database.rds\"" = "\"security_database.rds\"",
        "security_database.rds" = "security_database.rds",
        "\"security_database\"" = "\"security_database\"",
        "\"database_security.rds\"" = "\"database_security.rds\""
      ),
      answer = "\"security_database.rds\""
    )
  )
  
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
display: inline-block;
width: 200px;
background-color: #000000;
color: #00FF00;
border: 2px solid #00FF00;
font-family: 'Courier New', monospace;
margin-left: 5px;
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

.green-flash {
position: fixed;
inset: 0;
pointer-events: none;
z-index: 9999;
background: rgba(0, 255, 0, 0);
}

.red-flash.active {
animation: redFlash 0.35s ease-out 1;
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
        
        uiOutput("editor_ui")
      ),
      
      div(
        class = "console",
        
        h3("Console"),
        
        verbatimTextOutput("console_output"),
        
        uiOutput("auth_ui")
      )
    )
  )
}

level1_4_server <- function(input, output, session, current_page) {
  
  question <- render_question(
    list(
      id = "security_database_file",
      type = "dropdown",
      prompt = "security_database <- readRDS( ... )",
      options = c(
        "\"security_database.rds\"" = "\"security_database.rds\"",
        "security_database.rds" = "security_database.rds",
        "\"security_database\"" = "\"security_database\"",
        "\"database_security.rds\"" = "\"database_security.rds\""
      ),
      answer = "\"security_database.rds\""
    )
  )
  
  db <- reactiveVal(NULL)
  step <- reactiveVal(1)
  auth_ready <- reactiveVal(FALSE)
  auth_done <- reactiveVal(FALSE)
  
  output$console_output <- renderText({
    ""
  })
  
  output$auth_ui <- renderUI({
    NULL
  })
  
  output$editor_ui <- renderUI({
    if (!auth_done()) {
      tagList(
        h3("🔐 Level 1.4: Security Database"),
        p("De Security Database is succesvol hersteld."),
        p("Om de centrale beveiligingssystemen opnieuw te activeren moet een authenticatiecode worden gegenereerd."),
        p("Lees eerst het bestand in met readRDS()."),
        if (step() == 1) {
          tagList(
            question$ui,
            actionButton("load_db", "▶ RUN CODE")
          )
        } else if (step() == 2) {
          tagList(
            h4("Geladen dataset"),
            tableOutput("security_database_table"),
            br(),
            h4("Opdracht 1"),
            p("Voer deze code uit:"),
            div(class = "code-box", HTML("nrow(security_database)")),
            textInput("answer_1", NULL, "", placeholder = "Voer de output in"),
            actionButton("run_1", "▶ RUN")
          )
        } else if (step() == 3) {
          tagList(
            h4("Geladen dataset"),
            tableOutput("security_database_table"),
            br(),
            h4("Opdracht 2"),
            p("Voer deze code uit:"),
            div(class = "code-box", HTML("ncol(security_database)")),
            textInput("answer_2", NULL, "", placeholder = "Voer de output in"),
            actionButton("run_2", "▶ RUN")
          )
        } else if (step() == 4) {
          tagList(
            h4("Geladen dataset"),
            tableOutput("security_database_table"),
            br(),
            h4("Opdracht 3"),
            p("Voer deze code uit:"),
            div(class = "code-box", HTML("colnames(security_database)")),
            textInput("answer_3", NULL, "", placeholder = "Voer de output in"),
            actionButton("run_3", "▶ RUN")
          )
        } else if (step() == 5) {
          tagList(
            h4("Geladen dataset"),
            tableOutput("security_database_table"),
            br(),
            h4("Opdracht 4"),
            p("Voer deze code uit:"),
            div(class = "code-box", HTML("count(security_database, sector)")),
            textInput("answer_4", NULL, "", placeholder = "Voer de output in"),
            actionButton("run_4", "▶ RUN")
          )
        } else if (step() == 6 && auth_ready()) {
          tagList(
            h4("Authenticatiecode"),
            textInput("auth_code_input", "Voer de authenticatiecode in:", "", placeholder = "Authenticatiecode"),
            actionButton("activate_security", "ACTIVATE SECURITY", class = "start-btn")
          )
        }
      )
    } else {
      tagList(
        h4("Authenticatiecode"),
        textInput("auth_code_input", "Voer de authenticatiecode in:", "", placeholder = "Authenticatiecode"),
        actionButton("activate_security", "ACTIVATE SECURITY", class = "start-btn")
      )
    }
  })
  
  observeEvent(input$load_db, {
    if (question$check(input)) {
      session$sendCustomMessage("greenFlash", TRUE)
      db(readRDS("security_database.rds"))
      output$console_output <- renderText({
        paste(
          "🟢 SECURITY DATABASE RESTORED",
          "",
          "Database status:",
          "ONLINE",
          sep = "\n"
        )
      })
      step(2)
    } else {
      session$sendCustomMessage("redFlash", TRUE)
      output$console_output <- renderText({
        paste(
          "🔴 DATABASE LOAD FAILED",
          "",
          "The Security Database could not be restored.",
          "",
          "HINT",
          "",
          "The filename must be provided as text and include the .rds extension.",
          sep = "\n"
        )
      })
    }
  })
  
  observeEvent(input$run_1, {
    req(db())
    ans <- trimws(gsub('"', '', input$answer_1))
    if (ans == "[1] 10") {
      session$sendCustomMessage("greenFlash", TRUE)
      output$console_output <- renderText({
        paste(
          "> nrow(security_database)",
          "",
          "[1] 10",
          sep = "\n"
        )
      })
      step(3)
    } else {
      session$sendCustomMessage("redFlash", TRUE)
      output$console_output <- renderText({
        "❌ Incorrect.\n\nControleer de output opnieuw."
      })
    }
  })
  
  observeEvent(input$run_2, {
    req(db())
    ans <- trimws(gsub('"', '', input$answer_2))
    if (ans == "[1] 4") {
      session$sendCustomMessage("greenFlash", TRUE)
      output$console_output <- renderText({
        paste(
          "> ncol(security_database)",
          "",
          "[1] 4",
          sep = "\n"
        )
      })
      step(4)
    } else {
      session$sendCustomMessage("redFlash", TRUE)
      output$console_output <- renderText({
        "❌ Incorrect.\n\nControleer de output opnieuw."
      })
    }
  })
  
  observeEvent(input$run_3, {
    req(db())
    expected <- capture.output(colnames(db()))
    ans <- trimws(gsub('"', '', input$answer_3))
    ok <- identical(ans, paste(expected, collapse = "\n")) || identical(ans, paste0(expected, collapse = "\n"))
    if (ok) {
      session$sendCustomMessage("greenFlash", TRUE)
      output$console_output <- renderText({
        paste(
          "> colnames(security_database)",
          "",
          "[1] \"sample_id\"",
          "[2] \"sector\"",
          "[3] \"terminal\"",
          "[4] \"status\"",
          sep = "\n"
        )
      })
      step(5)
    } else {
      session$sendCustomMessage("redFlash", TRUE)
      output$console_output <- renderText({
        "❌ Incorrect.\n\nControleer de output opnieuw."
      })
    }
  })
  
  observeEvent(input$run_4, {
    req(db())
    counts <- count(db(), sector)
    ans <- trimws(gsub('"', '', input$answer_4))
    ok <- identical(ans, paste(capture.output(counts), collapse = "\n")) || identical(ans, paste0(capture.output(counts), collapse = "\n"))
    if (ok) {
      session$sendCustomMessage("greenFlash", TRUE)
      output$console_output <- renderText({
        paste(
          "> count(security_database, sector)",
          "",
          "# A tibble: 4 x 2",
          "",
          "  sector     n",
          "  <chr>  <int>",
          "1 Alpha      3",
          "2 Beta       3",
          "3 Delta      2",
          "4 Gamma      2",
          sep = "\n"
        )
      })
      auth_ready(TRUE)
      step(6)
    } else {
      session$sendCustomMessage("redFlash", TRUE)
      output$console_output <- renderText({
        "❌ Incorrect.\n\nControleer de output opnieuw."
      })
    }
  })
  
  observeEvent(input$activate_security, {
    req(input$auth_code_input)
    dbx <- db()
    row_count <- nrow(dbx)
    col_count <- ncol(dbx)
    sector_counts <- count(dbx, sector)
    alpha_count <- sector_counts$n[sector_counts$sector == "Alpha"]
    beta_count <- sector_counts$n[sector_counts$sector == "Beta"]
    delta_count <- sector_counts$n[sector_counts$sector == "Delta"]
    gamma_count <- sector_counts$n[sector_counts$sector == "Gamma"]
    correct_code <- paste0(row_count, col_count, alpha_count, beta_count, delta_count, gamma_count)
    entered_code <- trimws(gsub('"', '', input$auth_code_input))
    if (entered_code == correct_code) {
      session$sendCustomMessage("greenFlash", TRUE)
      output$console_output <- renderText({
        paste(
          "🟢 AUTHENTICATION SUCCESSFUL",
          "",
          "Security Module 3/3 activated.",
          "",
          "Central Security Network",
          "STATUS: ONLINE",
          sep = "\n"
        )
      })
      auth_done(TRUE)
      output$auth_ui <- renderUI({
        actionButton("continue_level1_4", "Continue", class = "next-btn")
      })
    } else {
      session$sendCustomMessage("redFlash", TRUE)
      output$console_output <- renderText({
        paste(
          "🔴 AUTHENTICATION FAILED",
          "",
          "Activation code invalid.",
          "",
          "Verify:",
          "",
          "- dataset dimensions",
          "- column names",
          "- sector counts",
          sep = "\n"
        )
      })
    }
  })
  
  observeEvent(input$continue_level1_4, {
    current_page("transition1_2")
  })
  
}