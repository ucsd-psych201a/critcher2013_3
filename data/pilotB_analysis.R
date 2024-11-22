library(tidyverse)
library(dplyr)
library(car)
library(emmeans)


# Load the dataset
dat <- read.csv("cleaned_data_pilotB.csv")  # Read the dataset into a data frame

# Count how many participants had missing data
participants_with_missing <- sum(rowSums(is.na(dat)) > 0)  # Count rows with at least one NA value

# Drop rows with missing values
cleaned_data <- dat %>%
  filter(complete.cases(.))  # Retain only rows without missing values

# Calculate average scores for Justin and Nate's responses
avg_score <- dat %>% 
  mutate(
    # Calculate the average score for Justin across selected questions
    j_avg_score = rowMeans(select(., Justin_response_Q2, Justin_response_Q3, Justin_response_Q4)),
    # Calculate the average score for Nate across selected questions
    n_avg_score = rowMeans(select(., Nate_response_Q2, Nate_response_Q3, Nate_response_Q4))
  )

# Group data by condition and calculate the mean scores for Justin and Nate
grouped_data <- avg_score %>%
  group_by(condition) %>%  # Group data by the 'condition' column
  summarize(
    mean_justin = mean(j_avg_score, na.rm = TRUE),  # Mean of Justin's average scores
    mean_nate = mean(n_avg_score, na.rm = TRUE)     # Mean of Nate's average scores
  )

# Prepare data for ANOVA analysis
anova_data <- avg_score %>%
  pivot_longer(
    cols = c(j_avg_score, n_avg_score),  # Pivot Justin's and Nate's average scores into long format
    names_to = "justin_fast_nate_slow", # New column to indicate score type (Justin or Nate)
    values_to = "score"                 # New column for the score values
  )

# Perform a two-way ANOVA
anova_result <- aov(score ~ condition * justin_fast_nate_slow, data = anova_data)
summary(anova_result)  # Display ANOVA results

# Conduct post hoc pairwise comparisons using estimated marginal means
emmeans(anova_result, pairwise ~ condition * justin_fast_nate_slow)