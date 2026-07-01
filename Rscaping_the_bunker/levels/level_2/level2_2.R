# level2_2.R
virus_dataset <- virus_dataset[order(virus_dataset$mean_onset_days), ]

x_question <- list(
  id="x_input",
  type="open",
  prompt="X-as",
  answers=c("virus")
)

y_question <- list(
  id="y_input",
  type="open",
  prompt="Y-as",
  answers=c("mean_onset_days")
)

geom_question <- list(
  id="geom_choice",
  type="dropdown",
  prompt="Geom",
  options=c(
    "geom_point()"="geom_point()",
    "geom_line()"="geom_line()",
    "geom_bar()"="geom_bar()",
    "geom_histogram()"="geom_histogram()"
  ),
  answer="geom_point()"
)

level2_2_ui <- function(){
  
  x_q <- render_question(x_question)
  y_q <- render_question(y_question)
  geom_q <- render_question(geom_question)
  
  fluidPage(
    
    useShinyjs(),
    
    tags$head(tags$style(HTML("
body{background:#1c1c1c;color:#00FF00;font-family:'Courier New',monospace;}
.game-container{display:flex;gap:20px;margin-top:20px;}
.editor,.console{width:50%;padding:15px;border:2px solid #00FF00;}
.editor{background:#1c1c1c;}
.console{background:#000;white-space:pre-wrap;}
.code-box{background:#000;border:1px solid #00FF00;padding:10px;}
.next-btn{margin-top:20px;background:#1c1c1c;color:#00FF00;border:2px solid #00FF00;}
"))),
    
    div(class="game-container",
        
        div(class="editor",
            h3("📊 Level 2.2: Visualiseer de virusgegevens"),
            p("Maak een scatterplot waarin je de virussen uitzet tegen hun mean onset day. Kies een geschikte geom om de punten te tonen. De foutbalken worden automatisch toegevoegd."),
            
            div(class="code-box",
                HTML("ggplot(virus_dataset, aes(x = "),
                x_q$ui,
                HTML(", y = "),
                y_q$ui,
                HTML(")) +"),
                geom_q$ui,
                HTML("
+ geom_errorbar(
    aes(
      ymin = mean_onset_days - sd_onset_days,
      ymax = mean_onset_days + sd_onset_days
    ),
    width = 0.2
  ) +
  labs(
    title = 'Gemiddelde onsettijd per virus',
    subtitle = 'Foutbalken geven de standaarddeviatie (SD) weer',
    x = 'Virus',
    y = 'Gemiddelde onsettijd (dagen)'
  ) +
  theme_minimal()")
            ),
            actionButton("submit_scatter","▶ RUN CODE")
        ),
        
        div(class="console",
            h3("Console"),
            verbatimTextOutput("scatter_console"),
            uiOutput("console_content")
        )
    )
  )
}

level2_2_server <- function(input,output,session,current_page){
  
  x_q <- render_question(x_question)
  y_q <- render_question(y_question)
  geom_q <- render_question(geom_question)
  
  output$console_content <- renderUI({
    tagList(
      h3("📊 Geladen dataset"),
      tableOutput("virus_table_data")
    )
  })
  
  output$virus_table_data <- renderTable({
    virus_dataset
  })
  
  observeEvent(input$submit_scatter,{
    
    x_answer <- trimws(input$x_input)
    y_answer <- trimws(input$y_input)
    geom_answer <- input$geom_choice
    
    correct_x <- tolower(x_answer) == "virus"
    correct_y <- tolower(y_answer) == "mean_onset_days"
    correct_geom <- geom_answer == "geom_point()"
    
    if(correct_x && correct_y && correct_geom){
      
      session$sendCustomMessage("greenFlash",TRUE)
      
      output$scatter_console <- renderText({
        paste("🟢 SECURITY PROTOCOL UPDATED","","Module 2/4 geactiveerd.","","Virus Database Module","STATUS: ONLINE",sep="\n")
      })
      
      output$console_content <- renderUI({
        tagList(
          plotOutput("scatter_plot",height="400px"),
          br(),
          actionButton("next_level2_3","Volgende",class="next-btn")
        )
      })
      
      output$scatter_plot <- renderPlot({
        ggplot(virus_dataset,
               aes(x=virus,y=mean_onset_days))+
          geom_point(size=3,color="#00FF00")+
          geom_errorbar(aes(ymin=mean_onset_days-sd_onset_days,
                            ymax=mean_onset_days+sd_onset_days),width=.2,color="#00FF00")+
          labs(title="Gemiddelde onsettijd per virus",
               subtitle="Foutbalken geven de standaarddeviatie (SD) weer",
               x="Virus",
               y="Gemiddelde onsettijd (dagen)")+
          theme_minimal() +
          theme(
            axis.text.x = element_text(angle = 45, hjust = 1)
          )
      })
      
    } else {
      
      session$sendCustomMessage("redFlash",TRUE)
      
      output$console_content <- renderUI(NULL)
      
      hint <- ""
      
      if(!correct_geom){
        
        hint <- "Een scatterplot gebruikt punten. Kies de juiste geom()."
        
      } else if(
        x_answer %in% c('"virus"', "'virus'")
      ){
        
        hint <- "Kolomnamen gebruik je zonder aanhalingstekens."
        
      } else if(
        tolower(x_answer) == "mean_onset_days" &&
        tolower(y_answer) == "virus"
      ){
        
        hint <- "Een bekende categorie hoort op de x-as. De gemeten variabele hoort op de y-as."
        
      } else if(
        tolower(y_answer) == "sd_onset_days"
      ){
        
        hint <- "Lees de opdracht nog eens goed. Welke variabele moet op de y-as?"
        
      } else if(
        tolower(x_answer) == "sd_onset_days"
      ){
        
        hint <- "Lees de opdracht nog eens goed. Welke variabele moet op de x-as?"
        
      } else {
        
        hint <- paste(
          "X-as: virus",
          "Y-as: mean_onset_days",
          "Gebruik een scatterplot met geom_point().",
          sep="\n"
        )
        
      }
      
      output$scatter_console <- renderText({
        paste(
          "🔴 SECURITY PROTOCOL FAILED",
          "",
          "Module activation unsuccessful.",
          "",
          "HINT",
          hint,
          sep="\n"
        )
      })
    }
  })
  
  observeEvent(input$next_level2_3,{
    current_page("level2_3")
  })
}
