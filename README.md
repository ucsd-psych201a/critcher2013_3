# Replication of "How Quick Decisions Illuminate Moral Character" (Critcher, Inbar, & Pizarro, 2013)

This repository contains materials, data, and analysis code for our replication of the study *"How Quick Decisions Illuminate Moral Character"* by Clayton R. Critcher, Yoel Inbar, and David A. Pizarro, originally published in *Social Psychological and Personality Science* (2013). The replication focuses on Experiment 1, investigating how decision speed influences judgments of moral character.

## Overview

The original study found that decision speed amplifies moral evaluations. Quick moral decisions were judged more favorably, while quick immoral decisions were judged more harshly. Our replication closely follows the methodology of Experiment 1 to test the robustness of these findings.

## Repository Structure

- **`data/`**: Contains the combined dataset used for our analysis (`quick_decisions_combined.csv`).
- **`original_paper/`**: Includes the original paper, references and supplementary materials related to the original study.
- **`writeup/`**: Contains the main replication report and supplementary files, including:
  - `master_write_up.qmd`: Quarto Markdown file for the full report, excluding personal Results and Discussion portion (each contributor has a personal report).
  - `master_analysis.Rmd`: RMarkdown file for the full analysis.

## Data Collection

Participants (N = 298) were recruited through Prolific, an online participant pool, and were screened for:
- Residency in the United States
- Fluency in English

Participants were randomly assigned to one of two conditions:
1. **Moral Condition**: Both agents returned a lost wallet.
2. **Immoral Condition**: Both agents kept the wallet.

Each participant read scenarios describing two agents, one making a quick decision (Justin) and the other making a deliberative decision (Nate). After reading the scenarios, participants completed a questionnaire assessing:
- **Decision Speed** (manipulation check)
- **Moral Character Evaluation**
- **Certainty**
- **Emotional Impulsivity**

## Analysis

The analysis followed the methodology of the original study and included:
1. **Descriptive Statistics**: Summarizing participant ratings across conditions.
2. **Manipulation Check**: A t-test confirming that participants perceived the intended differences in decision speed.
3. **2x2 ANOVA**: Examining the effects of moral condition (moral vs. immoral) and decision speed (quick vs. deliberative) on:
   - Moral character evaluations
4. **Post-Hoc Analyses**: Pairwise comparisons to explore differences between specific conditions.

The main analysis code is in `master_write_up.Rmd` and the full data wrangling and analysis is in `master_analysis.Rmd`.

## Results Summary

- **Quick Moral Decisions**: Judged significantly more favorably than slow moral decisions.
- **Quick Immoral Decisions**: Judged significantly more harshly than slow immoral decisions.

These results replicate the original study’s finding that decision speed amplifies moral evaluations.

## Contributors

This project was completed collaboratively by:
- **Emily Han**
- **Erika Garza-Elorduy**
- **Asad Tariq**
- **Luna Bellitto**

## Citation

If you use this repository or its contents, please cite the original study:

Critcher, C. R., Inbar, Y., & Pizarro, D. A. (2013). How Quick Decisions Illuminate Moral Character. *Social Psychological and Personality Science, 4*(3), 308–315. [https://doi.org/10.1177/1948550612457688](https://doi.org/10.1177/1948550612457688)
