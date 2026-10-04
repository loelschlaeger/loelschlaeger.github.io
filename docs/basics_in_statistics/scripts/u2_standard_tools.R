# Basics in Statistics -- Unit 2: Standard Tools

# install.packages(c("palmerpenguins", "dplyr", "ggplot2"))
library(palmerpenguins)
library(dplyr)
library(ggplot2)


# 2.1 Estimation and confidence intervals --------------------------------------

## Demo: Sampling variation ----
mu <- 4200; sigma <- 800; n <- 30
set.seed(2026)
x <- rnorm(n, mean = mu, sd = sigma)  # one sample of 30 birds
c(mean = mean(x), sd = sd(x))
set.seed(2026)
means <- replicate(10000, mean(rnorm(n, mean = mu, sd = sigma)))
c(sd_means = sd(means), sigma_sqrt_n = sigma / sqrt(n))
ggplot(data.frame(means), aes(x = means)) +
  geom_histogram(binwidth = 20, fill = "grey70", colour = "white") +
  labs(x = "Sample mean of 30 birds (g)", y = "Count")

# Task: Run the simulation again with n = 120. Is sd(means) again close to
# sigma / sqrt(n)?




## Demo: Estimate and standard error ----
gentoo <- penguins |>
  filter(species == "Gentoo", !is.na(body_mass_g)) |>
  pull(body_mass_g)
n <- length(gentoo)
xbar <- mean(gentoo)
s <- sd(gentoo)
se <- s / sqrt(n)
c(n = n, mean = xbar, sd = s, se = se)

# Task: The same four numbers for the Adelie penguins: Copy the demo and
# replace "Gentoo" by "Adelie".




## Demo: t quantiles ----
n_obs <- c(3, 5, 10, 30)
qt(0.975, df = n_obs - 1)
qnorm(0.975)

# Task: Compute the 97.5 % quantile of the t distribution for a sample of
# size n = 3 and for a sample of size n = 100 (degrees of freedom: n - 1).




## Demo: 95 % confidence interval ----
q <- qt(0.975, df = n - 1)
xbar + c(-1, 1) * q * se  # by hand
t.test(gentoo)$conf.int
t.test(gentoo, conf.level = 0.99)$conf.int

# Task: The 95 % and the 99 % confidence interval for the Adelie penguins
# with t.test(). Which one is wider?




## Demo: Maximum likelihood ----
fit <- MASS::fitdistr(gentoo, "normal")
fit
logLik(fit)
c(mean = mean(gentoo), sd = sd(gentoo))
# the fitted normal distribution over the histogram of the data
ggplot(data.frame(body_mass_g = gentoo), aes(x = body_mass_g)) +
  geom_histogram(aes(y = after_stat(density)), binwidth = 200) +
  stat_function(fun = dnorm, args = list(mean = fit$estimate[["mean"]],
                                         sd = fit$estimate[["sd"]]))

# Task: Fit a normal distribution to the Adelie body mass with
# MASS::fitdistr(adelie, "normal").




# 2.2 Testing step by step -----------------------------------------------------

# Do Adelie and Chinstrap penguins differ in mean flipper length?
# Step 1: H0: mu_A = mu_C, H1: mu_A != mu_C, alpha = 0.05

## Demo: Step 2, data and assumptions ----
d <- penguins |>
  filter(species %in% c("Adelie", "Chinstrap"), !is.na(flipper_length_mm)) |>
  droplevels()
grp <- d |>
  group_by(species) |>
  summarise(n = n(), mean = mean(flipper_length_mm),
            sd = sd(flipper_length_mm))
grp
ggplot(d, aes(x = species, y = flipper_length_mm)) +
  geom_boxplot() +
  labs(x = "Species", y = "Flipper length (mm)")
ggplot(d, aes(sample = flipper_length_mm)) +
  stat_qq() +
  stat_qq_line() +
  facet_wrap(~ species) +
  labs(x = "Normal quantiles", y = "Flipper length (mm)")

# Task: ToothGrowth: Draw the boxplot of tooth length (len) by supplement
# (supp). Which hypotheses would you test?




## Demo: Steps 3 to 5, t and p-value ----
n1 <- grp$n[1]; m1 <- grp$mean[1]; s1 <- grp$sd[1]
n2 <- grp$n[2]; m2 <- grp$mean[2]; s2 <- grp$sd[2]
se_diff <- sqrt(s1^2 / n1 + s2^2 / n2)
t_obs <- (m1 - m2) / se_diff
c(difference = m1 - m2, se = se_diff, t = t_obs)
t.test(flipper_length_mm ~ species, data = d)

# Task: Run t.test(len ~ supp, data = ToothGrowth). What are the difference
# of the means, t, and the p-value?




## Demo: Step 6, effect size and power ----
s_pooled <- sqrt(((n1 - 1) * s1^2 + (n2 - 1) * s2^2) / (n1 + n2 - 2))
(m2 - m1) / s_pooled  # Cohen's d
power.t.test(n = 68, delta = 2, sd = s_pooled)  # power for 2 mm
power.t.test(delta = 2, sd = s_pooled, power = 0.8)

# Task: Step 6 for ToothGrowth in one sentence: Estimate, confidence interval,
# and p-value.




# 2.3 Choosing a test ----------------------------------------------------------

## Demo: One sample against a reference value ----
gentoo <- penguins |>
  filter(species == "Gentoo", !is.na(body_mass_g)) |>
  pull(body_mass_g)
t.test(gentoo)$conf.int
t.test(gentoo, mu = 5200)
t.test(gentoo, mu = 5100)$p.value

# Task: Test the Adelie penguins against 3600 g and against 3700 g with
# t.test(adelie, mu = ...).




## Demo: Paired or not paired ----
set.seed(2026)
first <- round(rnorm(12, mean = 250, sd = 30))  # 12 runners, two races
second <- round(first - 6 + rnorm(12, sd = 8))
t.test(first, second)  # ignores the pairs
t.test(first, second, paired = TRUE)

# Task: The sleep data: Ten patients, each with drug 1 and with drug 2. Run
# the paired t-test on x1 <- sleep$extra[sleep$group == 1] and
# x2 <- sleep$extra[sleep$group == 2].




## Demo: More than two groups ----
PlantGrowth |>
  group_by(group) |>
  summarise(n = n(), mean = mean(weight), sd = sd(weight))
fit <- aov(weight ~ group, data = PlantGrowth)
summary(fit)
TukeyHSD(fit)
pairwise.t.test(PlantGrowth$weight, PlantGrowth$group,
                p.adjust.method = "holm")
kruskal.test(weight ~ group, data = PlantGrowth)

# Task: ToothGrowth: Compare tooth length between the three doses with aov()
# and TukeyHSD(). First make the dose a factor:
# tg <- ToothGrowth |> mutate(dose = factor(dose)).




## Demo: Binary outcome in two groups ----
# Low birth weight (< 2500 g) by smoking, 189 births
bw <- MASS::birthwt
tab <- table(smoker = bw$smoke, low_weight = bw$low)  # 1 = yes
tab
prop.table(tab, margin = 1)
chisq.test(tab)$expected  # all at least 5?
chisq.test(tab)
prop.test(c(30, 29), c(74, 115))

# Task: 1 of 20 positive under protocol A, 7 of 20 under protocol B. Enter the
# table with tab_ab <- matrix(c(1, 19, 7, 13), nrow = 2, byrow = TRUE) and run
# fisher.test(tab_ab), the test for small 2 x 2 tables.




## Demo: Two factors ----
pen <- na.omit(penguins[, c("body_mass_g", "species", "sex")])
with(pen, tapply(body_mass_g, list(species, sex), mean))
fit2 <- aov(body_mass_g ~ species * sex, data = pen)
summary(fit2)
interaction.plot(pen$species, pen$sex, pen$body_mass_g,
                 xlab = "Species", ylab = "Mean body mass (g)",
                 trace.label = "Sex")

# Task: ToothGrowth with supplement and dose: Fit aov(len ~ supp * dose,
# data = tg) and draw the interaction plot. Is the supplement effect the same
# at every dose?




## Demo: Checking normality ----
gentoo <- penguins |>
  filter(species == "Gentoo", !is.na(body_mass_g)) |>
  pull(body_mass_g)
ggplot(data.frame(gentoo), aes(sample = gentoo)) +
  stat_qq() +
  stat_qq_line() +
  labs(x = "Normal quantiles", y = "Body mass of Gentoo penguins (g)")
shapiro.test(gentoo)
shapiro.test(penguins$body_mass_g)  # three species pooled
# Pooled over species the test rejects: Normality is checked within groups,
# not for the pooled outcome.


## Demo: Many tests ----
p <- c(0.001, 0.008, 0.012, 0.030, 0.041, 0.200)
p.adjust(p, method = "bonferroni")
p.adjust(p, method = "holm")
p.adjust(p, method = "BH")

# 10 000 genes, 5 vs 5 samples, no true difference
set.seed(2026)
p_genes <- replicate(10000, t.test(rnorm(5), rnorm(5))$p.value)
sum(p_genes < 0.05)
sum(p.adjust(p_genes, method = "BH") < 0.05)
hist(p_genes, breaks = 20)
# Of the 5 raw hits, Bonferroni keeps 2, Holm 3, and BH 5. Of the 10 000 null
# genes, 478 pass 0.05 without adjustment and none with BH.
