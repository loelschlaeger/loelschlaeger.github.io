# Basics in Statistics -- Unit 3: Regression Analysis

# install.packages(c("ggplot2", "dplyr"))
library(ggplot2)
library(dplyr)

# 500 diamonds drawn at random from ggplot2::diamonds
set.seed(2026)
d <- diamonds[sample(nrow(diamonds), 500), ]
# Plain factors, so that lm() compares each category with the first one
d$cut <- factor(d$cut, ordered = FALSE)
d$color <- factor(d$color, ordered = FALSE)
d$clarity <- factor(d$clarity, ordered = FALSE)


# 3.1 Simple regression --------------------------------------------------------

## Demo: Look, then fit ----
ggplot(d, aes(x = carat, y = price)) +
  geom_point(alpha = 0.5) +
  labs(x = "Carat", y = "Price (USD)")
cor(d$carat, d$price)
m <- lm(price ~ carat, data = d)
summary(m)
confint(m)

# Task: Copy the demo and replace carat by the length x (in mm). Call the
# model mx. Report the slope with its unit and its confidence interval.




## Demo: Fitted values, residuals, predictions ----
head(fitted(m))
head(resid(m))
d[which.max(resid(m)), ]  # largest residual
predict(m, data.frame(carat = c(0.5, 1, 2)))
ggplot(d, aes(x = carat, y = price)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm", formula = y ~ x, se = FALSE) +
  labs(x = "Carat", y = "Price (USD)")

# Task: Use predict() with mx for a length of 6 mm and of 4 mm, as in the
# demo. What is wrong at 4 mm?




# 3.2 Multiple regression ------------------------------------------------------

## Demo: A confounder ----
d |>
  group_by(color) |>
  summarise(n = n(), price = mean(price), carat = mean(carat))
summary(lm(price ~ color, data = d))  # without adjustment
m_add <- lm(price ~ carat + color, data = d)
summary(m_add)
confint(m_add)

# Task: Copy the demo and replace color by cut (Fair to Ideal). Call the
# model with carat m_cut. Which cut is the cheapest without adjustment, and
# which at equal weight? Why?




## Demo: Interaction ----
m_int <- lm(price ~ carat * color, data = d)
summary(m_int)
anova(m_add, m_int)
ggplot(d, aes(x = carat, y = price, colour = color)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm", formula = y ~ x, se = FALSE)

# Task: Copy the demo and replace color by cut: Fit m_cut_int with carat * cut
# and compare it with m_cut by anova(). Is the interaction needed?




# 3.3 Diagnostics and prediction -----------------------------------------------

## Demo: Diagnostic plots ----
# If R reports "figure margins too large", enlarge the Plots pane
par(mfrow = c(2, 2))
plot(m_add)
par(mfrow = c(1, 1))
sum(fitted(m_add) < 0)  # negative prices

# Task: Fit m_cl <- lm(price ~ carat + clarity, data = d) and copy the demo
# with m_cl instead of m_add. Which assumptions are violated?




## Demo: The log model ----
m_log <- lm(log(price) ~ log(carat) + color, data = d)
summary(m_log)
exp(cbind(factor = coef(m_log), confint(m_log)))  # factors, not differences
par(mfrow = c(2, 2))
plot(m_log)
par(mfrow = c(1, 1))

# Task: Copy the demo and replace color by clarity. Call the model m_cl_log.
# By which factor does the price change from I1 to IF at equal weight?




## Demo: Confidence and prediction interval ----
m_loglog <- lm(log(price) ~ log(carat), data = d)
new <- data.frame(carat = 1)
exp(predict(m_loglog, new, interval = "confidence"))
exp(predict(m_loglog, new, interval = "prediction"))

# Task: Copy the last line of the demo, with m_cl_log instead of m_loglog and
# data.frame(carat = 0.5, clarity = "VS1") instead of new.




# 3.4 Logistic regression ------------------------------------------------------

## Demo: Logistic regression ----
bw <- MASS::birthwt
bw$smoke <- factor(bw$smoke, labels = c("no", "yes"))
g1 <- glm(low ~ smoke + lwt, family = binomial, data = bw)
summary(g1)
# confint() may first print a message on profiling; that is not an error
exp(cbind(OR = coef(g1), confint(g1)))  # odds ratios

# Task: Add hypertension (ht, 1 = yes) to the model and call it g2. Compute
# its odds ratios as in the demo.




## Demo: Predicted probabilities ----
predict(g1, data.frame(smoke = c("no", "yes"), lwt = 130), type = "response")

# Task: Use predict() with g2 as in the demo, for a smoker of 120 pounds
# without and with hypertension: data.frame(smoke = "yes", lwt = 120,
# ht = c(0, 1)).
