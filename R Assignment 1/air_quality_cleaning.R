# =============================================================
# Practical: Air-Quality Data Cleaning Using R
# Topic: Loops, Functions, Error Handling, Missing Data Handling
# Dataset: Beijing Multi-Site Air Quality Dataset (UCI ML Repository)
# =============================================================

# NOTE: Set your working directory to the folder containing the CSV file
# setwd("C:/Users/YourName/Documents/R_Assignment")   # <-- edit this path

# =============================================================
# TASK 1: Import and Inspect the Dataset
# =============================================================

file_name <- "PRSA_Data_Aotizhongxin_20130301-20170228.csv"  # change if using a different station

air_data <- tryCatch({
  data <- read.csv(file_name, stringsAsFactors = FALSE)
  if (ncol(data) <= 1) stop("File format looks incorrect (only 1 column read).")
  data
}, error = function(e) {
  message("ERROR while reading the file: ", conditionMessage(e))
  message("Please check that the file exists in your working directory and is a valid CSV.")
  NULL
})

if (is.null(air_data)) {
  stop("Dataset could not be loaded. Fix the file path/name and re-run the script.")
}

cat("\n===== TASK 1: Import and Inspect =====\n")

cat("\n--- First six records ---\n")
print(head(air_data))

cat("\n--- Structure of dataset ---\n")
str(air_data)

cat("\n--- Dimensions ---\n")
cat("Rows:", nrow(air_data), " | Columns:", ncol(air_data), "\n")

cat("\n--- Missing values check ---\n")
cat("Contains missing values? ", any(is.na(air_data)), "\n")
cat("Total missing values in dataset:", sum(is.na(air_data)), "\n")


# =============================================================
# TASK 2: Understand NA, NULL, and NaN
# =============================================================

cat("\n\n===== TASK 2: NA vs NULL vs NaN =====\n")

temperature <- c(28, 30, NA, 32)
cat("\nNA example -> temperature:", temperature, "\n")
cat("is.na(temperature):", is.na(temperature), "\n")

missing_object <- NULL
cat("\nNULL example -> missing_object is NULL\n")
cat("is.null(missing_object):", is.null(missing_object), "\n")

undefined_value <- 0 / 0
cat("\nNaN example -> undefined_value (0/0):", undefined_value, "\n")
cat("is.nan(undefined_value):", is.nan(undefined_value), "\n")


# =============================================================
# TASK 3: Missing-Value Summary Function
# =============================================================

missing_summary <- function(df, variables) {
  result <- data.frame(Variable = character(),
                        Total_Records = integer(),
                        Missing_Values = integer(),
                        Missing_Percentage = numeric(),
                        stringsAsFactors = FALSE)

  for (v in variables) {
    if (v %in% names(df)) {
      total_records <- nrow(df)
      missing_count  <- sum(is.na(df[[v]]))
      missing_pct    <- round((missing_count / total_records) * 100, 2)

      if (missing_pct > 20) {
        warning(paste0("Variable '", v, "' has more than 20% missing values (",
                        missing_pct, "%)."))
      }

      result <- rbind(result, data.frame(Variable = v,
                                          Total_Records = total_records,
                                          Missing_Values = missing_count,
                                          Missing_Percentage = missing_pct))
    } else {
      message("Column not found in dataset: ", v)
    }
  }
  return(result)
}

selected_vars <- c("PM2.5", "PM10", "SO2", "NO2", "TEMP", "WSPM", "wd")

cat("\n\n===== TASK 3: Missing Value Summary =====\n")
summary_table <- missing_summary(air_data, selected_vars)
print(summary_table)


# =============================================================
# TASK 4: Identify Invalid Numerical Results (pollution_ratio)
# =============================================================

cat("\n\n===== TASK 4: pollution_ratio =====\n")

air_data$pollution_ratio <- air_data$PM2.5 / air_data$PM10

cat("NA count:      ", sum(is.na(air_data$pollution_ratio)), "\n")
cat("NaN count:     ", sum(is.nan(air_data$pollution_ratio)), "\n")
cat("Infinite count:", sum(is.infinite(air_data$pollution_ratio)), "\n")

air_data$pollution_ratio[is.nan(air_data$pollution_ratio) |
                           is.infinite(air_data$pollution_ratio)] <- NA

cat("After replacing NaN/Inf with NA -> NA count:",
    sum(is.na(air_data$pollution_ratio)), "\n")


# =============================================================
# TASK 5: Handle Missing Numerical Values Using a Loop
# =============================================================

cat("\n\n===== TASK 5: Loop-based Numerical Cleaning =====\n")

numeric_variables <- c("PM2.5", "PM10", "SO2", "NO2", "TEMP", "WSPM")

missing_before_num <- setNames(numeric(length(numeric_variables)), numeric_variables)
missing_after_num  <- setNames(numeric(length(numeric_variables)), numeric_variables)

for (var in numeric_variables) {
  if (!(var %in% names(air_data))) {
    message("Column does not exist, skipping: ", var)
    next
  }

  before_count <- sum(is.na(air_data[[var]]))
  med_value    <- median(air_data[[var]], na.rm = TRUE)
  air_data[[var]][is.na(air_data[[var]])] <- med_value
  after_count  <- sum(is.na(air_data[[var]]))

  missing_before_num[var] <- before_count
  missing_after_num[var]  <- after_count

  cat("\nVariable:", var,
      "\n  Missing before:", before_count,
      "\n  Median used:   ", round(med_value, 2),
      "\n  Missing after: ", after_count, "\n")
}


# =============================================================
# TASK 6: Handle Missing Categorical Values (wd)
# =============================================================

cat("\n\n===== TASK 6: Categorical Cleaning (wd) =====\n")

calculate_mode <- function(x) {
  x <- x[!is.na(x) & x != ""]
  freq_table <- table(x)
  mode_value <- names(freq_table)[which.max(freq_table)]
  return(mode_value)
}

wd_before <- sum(is.na(air_data$wd) | air_data$wd == "")
wd_mode   <- calculate_mode(air_data$wd)
air_data$wd[is.na(air_data$wd) | air_data$wd == ""] <- wd_mode
wd_after  <- sum(is.na(air_data$wd) | air_data$wd == "")

cat("Mode of wd:", wd_mode, "\n")
cat("Missing before:", wd_before, " | Missing after:", wd_after, "\n")


# =============================================================
# TASK 7: Reusable clean_variable() Function with Error Handling
# =============================================================

cat("\n\n===== TASK 7: clean_variable() with tryCatch =====\n")

clean_variable <- function(df, var_name) {
  tryCatch({
    if (!(var_name %in% names(df))) {
      stop(paste0("Variable '", var_name, "' does not exist in the dataset."))
    }

    variable <- df[[var_name]]

    if (!is.numeric(variable)) {
      stop(paste0("'", var_name, "' is not a numerical variable."))
    }

    if (all(is.na(variable))) {
      stop(paste0("'", var_name, "' contains only missing values."))
    }

    med_value <- median(variable, na.rm = TRUE)

    if (is.na(med_value)) {
      stop(paste0("Median could not be calculated for '", var_name, "'."))
    }

    variable[is.na(variable)] <- med_value
    return(variable)

  }, error = function(e) {
    message("Could not clean '", var_name, "': ", conditionMessage(e))
    return(NULL)
  })
}

# Demonstration calls (deliberately include failing cases to show error handling)
cat("\n-- Valid numeric variable --\n")
test_valid <- clean_variable(air_data, "SO2")
cat("Returned vector length:", length(test_valid), "\n")

cat("\n-- Non-existent variable --\n")
test_missing_col <- clean_variable(air_data, "PM100")

cat("\n-- Categorical variable passed by mistake --\n")
test_categorical <- clean_variable(air_data, "wd")


# =============================================================
# TASK 8: Compare Missing Values Before and After Cleaning
# =============================================================

cat("\n\n===== TASK 8: Comparison Table =====\n")

comparison_vars <- c(numeric_variables, "wd")

missing_before_all <- c(missing_before_num, wd = wd_before)
missing_after_all  <- c(missing_after_num,  wd = wd_after)

comparison_table <- data.frame(
  Variable        = comparison_vars,
  Missing_Before  = as.numeric(missing_before_all[comparison_vars]),
  Missing_After   = as.numeric(missing_after_all[comparison_vars])
)
comparison_table$Values_Replaced <- comparison_table$Missing_Before - comparison_table$Missing_After

print(comparison_table)

cat("\nInterpretation: All selected variables show 0 missing values after cleaning,",
    "confirming median imputation (numeric columns) and mode imputation (categorical",
    "column 'wd') successfully handled the missing data.\n")


# =============================================================
# TASK 9: Visualization - Missing Values Before vs After
# =============================================================

cat("\n\n===== TASK 9: Visualization =====\n")

bar_matrix <- t(as.matrix(comparison_table[, c("Missing_Before", "Missing_After")]))
colnames(bar_matrix) <- comparison_table$Variable

barplot(bar_matrix,
        beside = TRUE,
        col = c("tomato", "seagreen"),
        main = "Missing Values: Before vs After Cleaning",
        xlab = "Variables",
        ylab = "Number of Missing Values",
        legend.text = c("Before Cleaning", "After Cleaning"),
        args.legend = list(x = "topright", bty = "n"))


# =============================================================
# TASK 10: Export the Cleaned Dataset
# =============================================================

cat("\n\n===== TASK 10: Export Cleaned Dataset =====\n")

write.csv(air_data, "cleaned_air_quality_data.csv", row.names = FALSE)

cat("Cleaned dataset exported as 'cleaned_air_quality_data.csv' in your working directory.\n")
cat("\n===== SCRIPT COMPLETE =====\n")
