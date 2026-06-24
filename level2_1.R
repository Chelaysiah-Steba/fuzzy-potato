# -------------------------
# Level 2.1 – Data + Vragen
# -------------------------

# Dataset die in dit level wordt getoond
untidy_df <- data.frame(
  Scientist = c("Sci01","Sci01","Sci02","Sci02","Sci03","Sci03"),
  Measurement = c("Age_years","Survival_days","Age_years","Survival_days","Age_years","Survival_days"),
  Value = c(34,82,29,91,41,77)
)

# Vraag: Is deze dataset tidy?
Q_tidy <- list(
  id = "tidy_answer",
  type = "mc_single",
  prompt = "Is deze dataset tidy?",
  options = list(
    "a) ja, dit is tidy data" = "a",
    "b) nee, de age en survival rate staan niet in aparte kolommen" = "b",
    "c) nee, de kolommen zijn niet alfabetisch geordend" = "c",
    "d) nee, want voor elke scientist zijn er meerdere metingen" = "d"
  ),
  answer = "b"
)

# Alle vragen van dit level
level2_1_questions <- list(
  Q_tidy
)
