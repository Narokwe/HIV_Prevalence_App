# HIV Prevalence Dashboard

## Overview
The HIV Prevalence Dashboard is an interactive Shiny app developed to visualize HIV prevalence across different countries and years. The dashboard allows users to select countries and years to view trends in HIV prevalence, enabling better data-driven insights. This app is built using R, Shiny, and `ggplot2` for interactive visualization.

## Features
- **Select Country:** View HIV prevalence for a specific country or all countries.
- **Select Year:** View HIV prevalence for a specific year or across multiple years.
- **Data Visualization:** Display HIV prevalence using bar and line charts.
  - Bar chart for comparing HIV prevalence across countries in a selected year.
  - Line chart for showing the trend of HIV prevalence in a specific country across years.

## Installation
To run the app, you need to install the following R packages:
```r
install.packages(c("shiny", "ggplot2", "dplyr", "tidyr", "flexdashboard"))
