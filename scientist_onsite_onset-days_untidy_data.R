untidy_scientists <- data.frame(
  Scientist = c(
    "sci01","sci01","sci02","sci02","sci03","sci03","sci04","sci04","sci05","sci05",
    "sci06","sci06","sci07","sci07","sci08","sci08","sci09","sci09","sci10","sci10",
    "sci11","sci11","sci12","sci12","sci13","sci13","sci14","sci14","sci15","sci15",
    "sci16","sci16","sci17","sci17","sci18","sci18","sci19","sci19","sci20","sci20"
  ),
    MeasurementType = rep(c("on_site", "symptom_onset_days"), times = 20),
    MeasurementValue = c(
      # age_years
      yes, no, yes, yes, yes,
      no, yes, yes, no, no,
      yes, no, no, no, yes,
      yes, yes, no, yes, yes,
      # symptom_onset_days
      5, 7, 3, 4, 4,
      6, 3, 4, 5, 6,
      5, 7, 6, 5, 4,
      3, 5, 7, 4, 3
    )
  )
  