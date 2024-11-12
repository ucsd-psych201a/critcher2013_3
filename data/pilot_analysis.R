library(tidyverse)
library(dplyr)
library(car)
library(emmeans)


dat <- read.csv("cleaned_data.csv")







avg_score <- dat %>% 
  mutate(
    j_avg_score = rowMeans(select(., Justin_response_Q2, Justin_response_Q3, Justin_response_Q4)),
    n_avg_score = rowMeans(select(., Nate_response_Q2, Nate_response_Q3, Nate_response_Q4))
  )

grouped_data <- avg_score %>%
  group_by(condition) %>%
  summarize(
    mean_justin = mean(j_avg_score, na.rm = TRUE),
    mean_nate = mean(n_avg_score, na.rm = TRUE)
  )



# Assuming `avg_score` is your data frame
anova_data <- avg_score %>%
  pivot_longer(
    cols = c(j_avg_score, n_avg_score),           # Columns to pivot (Justin's and Nate's scores)
    names_to = "justin_fast_nate_slow",                  # New column to indicate source (Justin or Nate)
    values_to = "score"                   # New column for the score values
  )


anova_result <- aov(score ~ condition * justin_fast_nate_slow, data = anova_data)
summary(anova_result)


emmeans(anova_result, pairwise ~ condition * justin_fast_nate_slow)
