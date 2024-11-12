# Load necessary libraries
library(tidyverse)

# Define the directory containing your CSV files
directory_path <- "osfstorage-archive"

# Initialize an empty tibble to store all cleaned data
cleaned_data <- tibble()

# Get a list of all CSV files in the directory
file_list <- list.files(path = directory_path, pattern = "\\.csv$", full.names = TRUE)

# Loop through each file in the directory
for (file in file_list) {
  
  # Read the CSV file
  data <- read_csv(file)
  
  # Select and clean relevant columns
  temp_cleaned <- data %>%
    select(condition, scenario, starts_with("response_Q")) %>%
    drop_na() # Remove rows with NA values in selected columns
  
  # Determine who came first based on the first non-NA scenario entry
  temp_cleaned <- temp_cleaned %>%
    group_by(condition) %>%
    mutate(
      first_scenario = first(na.omit(scenario))  # Identify the first scenario for each participant
    ) %>%
    ungroup()
  
  # Convert condition to a factor for easier interpretation
  temp_cleaned <- temp_cleaned %>%
    mutate(
      condition = factor(condition, levels = c(0, 1), labels = c("immoral", "moral")),
      scenario = factor(scenario)
    ) %>%
    # Rearrange columns to place first_scenario after condition
    select(condition, first_scenario, scenario, starts_with("response_Q"))
  
  # Rename response columns to include scenario information
  temp_cleaned <- temp_cleaned %>%
    pivot_longer(cols = starts_with("response_Q"),
                 names_to = "question",
                 values_to = "response") %>%
    unite("question_scenario", scenario, question, sep = "_") %>%
    pivot_wider(names_from = question_scenario, values_from = response)
  
  # Append the cleaned data from this file to the main cleaned_data tibble
  cleaned_data <- bind_rows(cleaned_data, temp_cleaned)
}

# View the final combined cleaned_data tibble
print(cleaned_data)
