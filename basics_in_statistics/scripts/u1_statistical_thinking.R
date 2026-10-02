# Basics in Statistics -- Unit 1: Statistical Thinking

# install.packages(c("palmerpenguins", "dplyr", "ggplot2"))
library(palmerpenguins)
library(dplyr)
library(ggplot2)


# 1.1 Describing and visualizing data ------------------------------------------

## Demo: Centre and spread ----
head(penguins)
help(penguins, "palmerpenguins")
x <- penguins$body_mass_g
mean(x)  # NA: Two values are missing
mean(x, na.rm = TRUE)
median(x, na.rm = TRUE)
sd(x, na.rm = TRUE)
quantile(x, c(0.25, 0.75), na.rm = TRUE)
IQR(x, na.rm = TRUE)
range(x, na.rm = TRUE)

# Task: Between which values lies the middle half of the birds? Is the mean
# above or below the median, and what does that say about the shape?




## Demo: Summaries by group ----
penguins |>
  group_by(species) |>
  summarise(
    n = n(),
    mean = mean(body_mass_g, na.rm = TRUE),
    median = median(body_mass_g, na.rm = TRUE),
    sd = sd(body_mass_g, na.rm = TRUE),
    iqr = IQR(body_mass_g, na.rm = TRUE)
  )

# Task: Which species is the heaviest, and by how much? Which two species are
# hard to tell apart? Which one varies most?




## Demo: Boxplots by group ----
ggplot(penguins, aes(x = species, y = body_mass_g)) +
  geom_boxplot(outlier.shape = NA) +
  geom_jitter(width = 0.15, alpha = 0.5) +
  labs(x = "Species", y = "Body mass (g)")

# Task: The same for flipper length. Is the heaviest species also the one
# with the longest flippers? Which species overlap?




## Demo: Scatterplot and correlation ----
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(alpha = 0.6) +
  labs(x = "Flipper length (mm)", y = "Body mass (g)")
cor(penguins$flipper_length_mm, penguins$body_mass_g, use = "complete.obs")

# Task: Do bill length or bill depth go with body mass more closely than
# flipper length?




# 1.2 Binomial, Poisson, and normal distributions ------------------------------

# d: P(X = x) or density, p: P(X <= x), q: Quantile, r: Random numbers

# 180 seats, 188 tickets, show-up probability 0.95: X ~ Bin(188, 0.95)

## Demo: Simulated flights ----
set.seed(2026)
rbinom(10, size = 188, prob = 0.95)  # ten flights
flights <- rbinom(10000, size = 188, prob = 0.95)
mean(flights > 180)                  # share of overbooked flights


## Demo: Exact probabilities ----
0.95^181                              # all 181 show up
dbinom(181, size = 181, prob = 0.95)  # the same
1 - pbinom(180, size = 188, prob = 0.95)  # 188 tickets: More than 180 show up
sum(dbinom(181:188, size = 188, prob = 0.95))  # the same
# mean and sd of the number showing up
188 * 0.95
sqrt(188 * 0.95 * 0.05)


## Demo: Binomial ----
# multiple-choice test, 8 questions with 4 options each, all answers guessed:
# Each answer is correct with probability 1/4
dbinom(0, size = 8, prob = 0.25)  # no correct answer
dbinom(0:8, size = 8, prob = 0.25)
pbinom(2, size = 8, prob = 0.25)  # at most 2
1 - pbinom(2, size = 8, prob = 0.25)
8 * 0.25
set.seed(2026)
rbinom(5, size = 8, prob = 0.25)  # five guessing students

# Task: 50 seeds, each germinates with probability 0.8. How likely are at
# least 45 germinated seeds? How many germinate on average?




## Demo: Poisson ----
# colonies per agar plate, 3 on average
dpois(0, lambda = 3)  # empty plate
1 - ppois(6, lambda = 3)
set.seed(2026)
plates <- rpois(1000, lambda = 3)
c(mean = mean(plates), var = var(plates))

# Task: A rare disease has 2 new cases per year on average. How likely is a
# year without a case, and a year with 5 or more?




## Demo: Normal ----
# body mass in g, N(4200, 800^2)
dnorm(4200, mean = 4200, sd = 800)
pnorm(3400, mean = 4200, sd = 800)  # P(X <= 3400)
qnorm(0.975, mean = 4200, sd = 800)
set.seed(2026)
rnorm(3, mean = 4200, sd = 800)
pnorm(3400, mean = 4200, sd = 800^2)  # wrong: sd, not variance

# Task: P(3400 <= X <= 5000)? The share within two sd of the mean? Below
# which value lie 2.5 %?




## Demo: Drawing a discrete distribution ----
# the guessed test again, one bar per possible number of correct answers
x <- 0:8
barplot(dbinom(x, size = 8, prob = 0.25), names.arg = x,
        xlab = "Correct answers out of 8", ylab = "Probability")

# Task: Draw the distribution of the 50 seeds (p = 0.8) and of the yearly
# cases of the rare disease (lambda = 2). Which values carry almost all the
# probability?




## Demo: Drawing a density ----
# the normal density of the body mass, the middle 95 % shaded
curve(dnorm(x, mean = 4200, sd = 800), from = 1800, to = 6600,
      xlab = "Body mass (g)", ylab = "Density")
lo <- qnorm(0.025, mean = 4200, sd = 800)
hi <- qnorm(0.975, mean = 4200, sd = 800)
xs <- seq(lo, hi, length.out = 200)
polygon(c(xs, rev(xs)), c(dnorm(xs, mean = 4200, sd = 800), rep(0, 200)),
        col = "grey80", border = NA)
curve(dnorm(x, mean = 4200, sd = 800), add = TRUE)
# the same density over the histogram of the real body masses
ggplot(penguins, aes(x = body_mass_g)) +
  geom_histogram(aes(y = after_stat(density)), binwidth = 200) +
  stat_function(fun = dnorm, args = list(mean = 4200, sd = 800))

# Task: The same histogram with a normal curve for flipper length, using the
# mean and sd of the data. Does the normal distribution fit?
