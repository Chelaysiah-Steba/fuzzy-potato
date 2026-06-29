untidy_scientists <- data.frame(
  Scientist = c(
    "sci01","sci01","sci02","sci02","sci03","sci03","sci04","sci04","sci05","sci05",
    "sci06","sci06","sci07","sci07","sci08","sci08","sci09","sci09","sci10","sci10",
    "sci11","sci11","sci12","sci12","sci13","sci13","sci14","sci14","sci15","sci15",
    "sci16","sci16","sci17","sci17","sci18","sci18","sci19","sci19","sci20","sci20"
  ),
    MeasurementType = rep(c("age_years", "symptom_onset_days"), times = 20),
    MeasurementValue = c(
      # age_years
      34, 50, 41, 29, 46,
      38, 52, 44, 31, 57,
      36, 48, 40, 53, 28,
      39, 45, 32, 55, 37,
      # symptom_onset_days
      3, 2, 6, 2, 4,
      7, 8, 4, 2, 5,
      3, 2, 6, 2, 4,
      7, 8, 4, 2, 5
    )
  )
  