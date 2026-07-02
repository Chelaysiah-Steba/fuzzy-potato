# modules.R
# ---------------------------------------------
# Dit bestand bevat alle vraagtypes voor de game.
# Elke vraagtype-functie maakt:
#   1) UI  (wat de speler ziet)
#   2) check-functie (TRUE/FALSE of het antwoord goed is)

# Dit zijn de packages die nodig zijn voor het gebruik van de functies.
library(shiny)
library(sortable)
library(shinyjs)

###############################################################
# 1. Multiple choice (één juist antwoord)
###############################################################
# Gebruik wanneer de speler precies één antwoord moet kiezen.
#
# id      = unieke naam van de vraag
# prompt  = de vraagtekst
# options = lijst met antwoordopties
# answer  = het juiste antwoord (één waarde)
###############################################################

q_mc_single <- function(id, prompt, options, answer) {
  list(
    ui = radioButtons(
      inputId = id,
      label = prompt,
      choices = options
    ),
    check = function(input) {
      input[[id]] == answer
    }
  )
}


###############################################################
# 2. Multiple choice (meerdere juiste antwoorden)
###############################################################
# Gebruik wanneer de speler meerdere antwoorden moet selecteren.
#
# id      = unieke naam van de vraag
# prompt  = de vraagtekst
# options = lijst met antwoordopties
# answers = vector met ALLE juiste antwoorden
#
# setequal() wordt gebruikt zodat volgorde niet uitmaakt.
###############################################################

q_mc_multi <- function(id, prompt, options, answers) {
  list(
    ui = checkboxGroupInput(
      inputId = id,
      label = prompt,
      choices = options
    ),
    check = function(input) {
      setequal(input[[id]], answers)
    }
  )
}


###############################################################
# 3. Dropdown (één juiste keuze)
###############################################################
# Gebruik wanneer de speler één optie moet kiezen uit een dropdown.
###############################################################

q_dropdown <- function(id, prompt, options, answer) {
  list(
    ui = selectInput(
      inputId = id,
      label = prompt,
      choices = options
    ),
    check = function(input) {
      
      value <- input[[id]]
      
      if (is.null(value) || value == "") {
        return(FALSE)
      }
      
      identical(value, answer)
    }
  )
}


###############################################################
# 4. Open vraag (tekst invoer)
###############################################################
# Gebruik wanneer de speler een tekst moet invullen.
#
# answers   = vector met mogelijke correcte antwoorden
# use_regex = TRUE als je regex wilt gebruiken
#
# De check-functie:
# - trimt spaties
# - vergelijkt case-insensitive
# - ondersteunt regex indien gewenst
###############################################################

q_open <- function(id, prompt, answers, use_regex = FALSE) {
  list(
    ui = textInput(
      inputId = id,
      label = prompt
    ),
    check = function(input) {
      
      user <- input[[id]]
      
      if (is.null(user) || trimws(user) == "") {
        return(FALSE)
      }
      
      user <- trimws(user)
      
      if (use_regex) {
        any(sapply(
          answers,
          function(pattern) grepl(pattern, user, ignore.case = TRUE)
        ))
      } else {
        tolower(user) %in% tolower(answers)
      }
    }
  )
}


###############################################################
# 5. Arrange / sorteer vraag
###############################################################
# Gebruik wanneer de speler items in de juiste volgorde moet zetten.
#
# items         = vector met items die gesorteerd moeten worden
# correct_order = vector met de juiste volgorde
#
# identical() checkt of de volgorde exact klopt.
###############################################################

q_arrange <- function(id, prompt, items, correct_order) {
  list(
    ui = orderInput(
      inputId = id,
      label = prompt,
      items = items,
      as_source = FALSE
    ),
    check = function(input) {
      identical(input[[id]], correct_order)
    }
  )
}


###############################################################
# 6. Combo-vraag (meerdere onderdelen in één vraag)
###############################################################
# Gebruik wanneer een vraag bestaat uit meerdere subvragen,
# zoals een dropdown + open vraag gecombineerd.
#
# parts = lijst met onderdelen, elk onderdeel heeft:
#   type    = "dropdown" of "open"
#   id      = inputId van dat onderdeel
#   prompt  = label
#   options = (alleen bij dropdown)
#   answer  = juiste antwoord (dropdown)
#   answers = juiste antwoorden (open)
###############################################################

q_combo <- function(id, prompt, parts) {
  
  # UI genereren voor alle onderdelen
  ui_elements <- tagList(
    h4(prompt),
    lapply(parts, function(p) {
      if (p$type == "dropdown") {
        selectInput(p$id, p$prompt, p$options)
      } else if (p$type == "open") {
        textInput(p$id, p$prompt)
      }
    })
  )
  
  # Check-functie voor alle onderdelen
  check_fun <- function(input) {
    all(sapply(parts, function(p) {
      if (p$type == "dropdown") {
        input[[p$id]] == p$answer
      } else if (p$type == "open") {
        tolower(trimws(input[[p$id]])) %in% tolower(p$answers)
      }
    }))
  }
  
  list(
    ui = ui_elements,
    check = check_fun
  )
}


###############################################################
# 7. Dispatcher: render_question()
###############################################################
# Deze functie kiest automatisch de juiste vraagmodule
# op basis van q$type.
#
# Hierdoor hoeft app.R nooit te weten welk vraagtype het is.
###############################################################

render_question <- function(q) {
  
  use_regex <- if (is.null(q$use_regex)) FALSE else q$use_regex
  
  switch(q$type,
         "mc_single" = q_mc_single(q$id, q$prompt, q$options, q$answer),
         "mc_multi"  = q_mc_multi(q$id, q$prompt, q$options, q$answers),
         "dropdown"  = q_dropdown(q$id, q$prompt, q$options, q$answer),
         "open"      = q_open(q$id, q$prompt, q$answers, use_regex),
         "arrange"   = q_arrange(q$id, q$prompt, q$items, q$correct_order),
         "combo"     = q_combo(q$id, q$prompt, q$parts)
  )
}