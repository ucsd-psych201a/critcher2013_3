# Load necessary libraries
library(tidyverse)
library(readr)


# Define the directory containing your CSV files
directory_path <- "../data/final-data"

# Initialize an empty tibble to store all cleaned data
cleaned_data <- tibble()

# Get a list of all CSV files in the directory
file_list <- list.files(path = directory_path, pattern = "\\.csv$", full.names = TRUE)

# Loop through each file in the directory
for (file in file_list) {
  # Read the CSV file
  data <- read_csv(file)
  
  # Flag to track if the attention check passes
  attention_check_passed <- FALSE
  
  # Check attention check questions
  attention_check_row <- data %>%
    filter(trial_type == "survey-html-form")
  
  # Validate attention check
  if (nrow(attention_check_row) > 0) {
    # Parse the JSON string in the response column
    attention_responses <- jsonlite::fromJSON(attention_check_row$response)
    
    # Define correct answers for attention check
    correct_answers <- list(
      "q1" = "Justin and Nate",
      "q2" = "A wallet"
    )
    
    # Check if all attention check answers are correct
    attention_check_passed <- all(
      attention_responses$q1 == correct_answers$q1 &&
        attention_responses$q2 == correct_answers$q2
    )
  }
  
  # Process data only if attention check passes
  if (attention_check_passed) {
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
  } else {
    # If attention check fails, log the file name (optional)
    message(paste("Attention check failed for file:", file))
  }
}

# View the final combined cleaned_data tibble
print(cleaned_data)

# Define the output path for the final cleaned CSV file
output_path <- "../data/cleaned_data_final.csv"

# Save the final combined cleaned_data tibble as a CSV file
write_csv(cleaned_data, output_path)