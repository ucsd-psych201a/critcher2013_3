# Load necessary libraries
library(tidyverse)

# Define the directory containing your CSV files
directory_path <- "../data/pilotB"

# Initialize an empty tibble to store all cleaned data
cleaned_data <- tibble()

# Get a list of all CSV files in the directory
file_list <- list.files(path = directory_path, pattern = "\\.csv$", full.names = TRUE)

# Loop through each file in the directory
for (file in file_list) {
  
  # Read the CSV file
  data <- read_csv(file)
  
  # Select relevant columns (do not drop NAs here)
  temp_cleaned <- data %>%
    select(condition, scenario, starts_with("response_Q"))
  
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
    # Ensure no NA in 'scenario' or 'question' before combining
    filter(!is.na(scenario)) %>%
    pivot_longer(cols = starts_with("response_Q"),
                 names_to = "question",
                 values_to = "response") %>%
    # Remove rows where both 'question' and 'response' are NA
    filter(!is.na(question) & !is.na(response)) %>%
    unite("question_scenario", scenario, question, sep = "_") %>%
    pivot_wider(names_from = question_scenario, values_from = response)
  
  
  # Append the cleaned data from this file to the main cleaned_data tibble
  # Ensure rows with NAs are retained by not filtering them out
  cleaned_data <- bind_rows(cleaned_data, temp_cleaned)
}

# View the final combined cleaned_data tibble
print(cleaned_data)

# Define the output path for the final cleaned CSV file
output_path <- "../data/cleaned_data_pilotB.csv"

# Save the final combined cleaned_data tibble as a CSV file
write_csv(cleaned_data, output_path)