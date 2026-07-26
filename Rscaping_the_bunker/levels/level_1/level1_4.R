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
      prompt = "Het RDS-bestand security_database zal je toegang geven tot alle databses in de bunker. 
      Welk bestand moet je kiezen om de Security Database in te lezen?",
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
  min-height: 220px;
}

.console {
  background-color: #000000;
  min-height: 220px;
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
  width: 260px;
  background-color: #000000;
  color: #00FF00;
  border: 2px solid #00FF00;
  font-family: 'Courier New', monospace;
  margin-left: 5px;
}

.next-btn, .start-btn {
  margin-top: 20px;
  background: #1c1c1c;
  color: #00FF00;
  border: 2px solid #00FF00;
  padding: 10px 20px;
  font-family: 'Courier New';
  cursor: pointer;
}

.red-flash, .green-flash {
  position: fixed;
  inset: 0;
  pointer-events: none;
  z-index: 9999;
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
      prompt = "Het RDS-bestand security_database zal je toegang geven tot alle databses in de bunker. 
      Welk bestand moet je kiezen om de Security Database in te lezen?",
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
  auth_done <- reactiveVal(FALSE)
  last_output <- reactiveVal("")
  
  output$console_output <- renderText({
    last_output()
  })
  
  output$auth_ui <- renderUI({
    if (step() == 5 && !auth_done()) {
      tagList(
        h4("Activatiecode"),
        p("De activatiecode is opgebouwd uit: ncol, ncol, nrow, ncol, nrow."),
        textInput("auth_code_input", "Voer de activatiecode in:", "", placeholder = "Bijv. 22302"),
        actionButton("activate_security", "ACTIVATE SECURITY", class = "start-btn")
      )
    }
  })
  
  output$editor_ui <- renderUI({
    if (!auth_done()) {
      tagList(
        h3("🔐 Level 1.4: Security Database"),
        if (step() == 1) {
          tagList(
            p("Kies het juiste bestand om de Security Database in te lezen."),
            question$ui,
            actionButton("load_db", "▶ RUN CODE", class = "start-btn")
          )
        } else if (step() == 2) {
          tagList(
            p("Hoeveel rijen heeft de dataset?"),
            textInput("answer_1", NULL, "", placeholder = "Typ de output, bijvoorbeeld [1] 10"),
            actionButton("run_1", "▶ RUN", class = "start-btn")
          )
        } else if (step() == 3) {
          tagList(
            p("Hoeveel kolommen heeft de dataset?"),
            textInput("answer_2", NULL, "", placeholder = "Typ de output, bijvoorbeeld [1] 4"),
            actionButton("run_2", "▶ RUN", class = "start-btn")
          )
        } else if (step() == 4) {
          tagList(
            p("Welke kolomnamen heeft de dataset?"),
            textInput("answer_3", NULL, "", placeholder = "Plak de volledige output"),
            actionButton("run_3", "▶ RUN", class = "start-btn")
          )
        } else if (step() == 5) {
          tagList(
            p("Geef de activatiecode in."),
            textInput("auth_code_input", "Voer de activatiecode in:", "", placeholder = "Bijv. 44104"),
            actionButton("activate_security", "ACTIVATE SECURITY", class = "start-btn")
          )
        }
      )
    } else {
      tagList(
        h4("✅ Toegang verleend"),
        p("Je hebt nu toegang tot de databases."),
        p("De nieuwe kamer is unlocked."),
        actionButton("continue_level1_4", "Continue", class = "next-btn")
      )
    }
  })
  
  observeEvent(input$load_db, {
    if (question$check(input)) {
      session$sendCustomMessage("greenFlash", TRUE)
      loaded_db <- readRDS("security_database.rds")
      db(loaded_db)
      last_output(paste(
        "> security_database <- readRDS(\"security_database.rds\")",
        "",
        "🟢 SECURITY DATABASE RESTORED",
        "",
        paste(capture.output(print(loaded_db)), collapse = "\n"),
        sep = "\n"
      ))
      step(2)
    } else {
      session$sendCustomMessage("redFlash", TRUE)
      last_output(paste(
        "🔴 DATABASE LOAD FAILED",
        "",
        "Kies exact: \"security_database.rds\"",
        sep = "\n"
      ))
    }
  })
  
  observeEvent(input$run_1, {
    req(db())
    ans <- trimws(input$answer_1)
    correct <- capture.output(print(nrow(db())))[1]
    if (ans == correct) {
      session$sendCustomMessage("greenFlash", TRUE)
      last_output(paste(
        "> nrow(security_database)",
        "",
        correct,
        sep = "\n"
      ))
      step(3)
    } else {
      session$sendCustomMessage("redFlash", TRUE)
      last_output(paste(
        "❌ Incorrect.",
        "",
        "Hint: kijk naar het aantal rijen.",
        sep = "\n"
      ))
    }
  })
  
  observeEvent(input$run_2, {
    req(db())
    ans <- trimws(input$answer_2)
    correct <- capture.output(print(ncol(db())))[1]
    if (ans == correct) {
      session$sendCustomMessage("greenFlash", TRUE)
      last_output(paste(
        "> ncol(security_database)",
        "",
        correct,
        sep = "\n"
      ))
      step(4)
    } else {
      session$sendCustomMessage("redFlash", TRUE)
      last_output(paste(
        "❌ Incorrect.",
        "",
        "Hint: kijk naar het aantal kolommen.",
        sep = "\n"
      ))
    }
  })
  
  observeEvent(input$run_3, {
    req(db())
    ans <- trimws(input$answer_3)
    correct <- paste(capture.output(colnames(db())), collapse = "\n")
    if (identical(ans, correct)) {
      session$sendCustomMessage("greenFlash", TRUE)
      last_output(paste(
        "> colnames(security_database)",
        "",
        correct,
        sep = "\n"
      ))
      step(5)
    } else {
      session$sendCustomMessage("redFlash", TRUE)
      last_output(paste(
        "❌ Incorrect.",
        "",
        "Hint: gebruik colnames(security_database).",
        sep = "\n"
      ))
    }
  })
  
  observeEvent(input$activate_security, {
    req(db())
    entered_code <- trimws(input$auth_code_input)
    correct_code <- paste0(ncol(db()), ncol(db()), nrow(db()), ncol(db()), nrow(db()))
    
    if (entered_code == correct_code) {
      session$sendCustomMessage("greenFlash", TRUE)
      last_output(paste(
        "🟢 AUTHENTICATION SUCCESSFUL",
        "",
        "Je hebt nu toegang tot de databases.",
        "De nieuwe kamer is unlocked.",
        sep = "\n"
      ))
      auth_done(TRUE)
    } else {
      session$sendCustomMessage("redFlash", TRUE)
      last_output(paste(
        "🔴 AUTHENTICATION FAILED",
        "",
        paste0("Je vulde in: ", entered_code),
        "",
        "Hint: de code is ncol, ncol, nrow, ncol, nrow.",
        sep = "\n"
      ))
    }
  })
  
  observeEvent(input$continue_level1_4, {
    current_page("transition1_2")
  })
}