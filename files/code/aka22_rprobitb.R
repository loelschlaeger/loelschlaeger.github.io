
# Load {RprobitB} ---------------------------------------------------------

# install.packages("RprobitB")
library("RprobitB")
stopifnot(packageVersion("RprobitB") == "1.1.2")

# Define Setting ----------------------------------------------------------

form <- opinion ~ age + income
# re <- "income"
alternatives <- c("very bad", "bad", "indifferent", "good", "very good")
J <- length(alternatives)
N <- 100
T <- sample.int(n = 10, size = 100, replace = TRUE)

# Overview Effects --------------------------------------------------------

overview_effects(
  form = form, alternatives = alternatives, ordered = TRUE
)

# Simulation Parameters ---------------------------------------------------

true_parameter <- list(
  "alpha" = c(-1, 1),
  "Sigma" = 1
)

# Simulate Choices --------------------------------------------------------

data <- simulate_choices(
  form = form, N = N, T = T, J = J, alternatives = alternatives,
  ordered = TRUE, true_parameter = true_parameter, seed = 1
)
plot(data)

# Fit Model ---------------------------------------------------------------

fit <- fit_model(
  data = data, R = 4000, seed = 1
)

# Analyze Results ---------------------------------------------------------

par(mfrow = c(1,2))
plot(fit, "trace")
summary(fit)
coef(fit)


