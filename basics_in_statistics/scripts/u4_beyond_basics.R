# Basics in Statistics -- Unit 4: Looking Beyond the Basics

# install.packages(c("palmerpenguins", "dplyr", "rpart", "ggplot2", "broom",
#                    "knitr", "rmarkdown"))
library(palmerpenguins)
library(dplyr)
library(rpart)

# four measurements of 342 penguins; the species is kept aside
pen <- penguins |>
  select(species, bill_length_mm, bill_depth_mm, flipper_length_mm,
         body_mass_g) |>
  na.omit()
d <- pen |> select(-species)


# 4.1 Principal components -----------------------------------------------------

## Demo: Correlations and variances ----
round(cor(d), 2)
round(apply(d, 2, var), 1)  # variance of each column

# Task: Store the four iris measurements (in cm) as ir <- iris[, 1:4] and
# compute their correlations with round(cor(ir), 2). Is a PCA worth doing?




## Demo: prcomp() ----
pca <- prcomp(d, scale. = TRUE)
summary(pca)
round(pca$rotation, 3)  # loadings
head(round(pca$x, 2))   # scores
summary(prcomp(d))      # unscaled: Body mass takes over

# Task: Run pca_ir <- prcomp(ir, scale. = TRUE) and summary(pca_ir), then
# summary(prcomp(ir)) without scaling. Share of the first component in each
# case (row Proportion of Variance)?




## Demo: How many components? ----
screeplot(pca)  # bars: Variance of each component
summary(pca)    # rows Proportion of Variance and Cumulative Proportion

# Task: Draw screeplot(pca_ir) and read the row Cumulative Proportion in
# summary(pca_ir). How many components do you need for 80 %?




## Demo: Biplot ----
biplot(pca, xlabs = rep(".", nrow(d)))  # each bird as a dot
# scores by species: Black Adelie, red Chinstrap, green Gentoo
plot(pca$x[, 1:2], col = pen$species, pch = 19)


# 4.2 Decision trees -----------------------------------------------------------

# diabetes (type) in women of Pima heritage: 200 for training, 332 for testing
train <- MASS::Pima.tr
test <- MASS::Pima.te

## Demo: One tree ----
fit <- rpart(type ~ glu + bmi, data = train, maxdepth = 2)
fit
plot(fit, margin = 0.1)
text(fit, use.n = TRUE)

# Task: Fit a tree with all seven predictors with
# fit_all <- rpart(type ~ ., data = train) and print fit_all. The dot stands
# for all other columns. Which variables does the tree use?




## Demo: Training error, test error, baseline ----
# err(): Share of misclassified women in data
err <- function(fit, data) mean(predict(fit, data, type = "class") != data$type)
err(fit, train)
err(fit, test)
mean(test$type == "Yes")  # baseline error: Always "No"

# Task: Compute err(fit_all, train) and err(fit_all, test). Is the test error
# lower than err(fit, test) of the small tree?




## Demo: Confusion matrix ----
table(predicted = predict(fit, test, type = "class"), true = test$type)

# Task: Print the confusion matrix of fit_all on the test data with table(),
# as in the demo. Sensitivity and specificity?
