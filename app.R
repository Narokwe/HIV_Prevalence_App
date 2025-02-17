---
title: "HIV Prevalence Dashboard"
output: flexdashboard::flex_dashboard
runtime: shiny
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

# 1. Loading the required Libraries

```{r}
library(shiny)
library(ggplot2)
library(dplyr)
library(tidyr)
```

# 2. Loading the Dataset

```{r}
data <- read.csv("C:\\Users\\DELL\\Downloads\\HIV Prevalence.csv")
```

# 3. Data Wrangling

## 3.1 Checking the columns' names

```{r}
colnames(data)
```

## 3.2 Removing 'X' prefix from the numeric columns

```{r}
colnames(data) <- gsub("^X", "", colnames(data))
```

## 3.3 Convert dataset into long format for easier visualization, while Handling missing values

```{r}
for (year in c("2016", "2010", "2005", "2000")) {
  data[[year]][data[[year]] == ""] <- NA  # Replace blank cells with NA
  data[[year]] <- as.numeric(data[[year]]) # Convert to numeric
}
```

## 3.4 Transform Data into Long format for easier visualization

```{r}
data_long <- data %>%
  pivot_longer(cols = c("2016", "2010", "2005", "2000"), names_to = "Year", values_to = "Prevalence")
```

## 3.5 Check results

```{r}
head(data_long)
```

# 4. Building the Shiny Dashboard

## 4.1 User Interface (UI)

```{r}
library(shiny)

ui <- fluidPage(
  titlePanel("HIV Prevalence Dashboard"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("country", "Select Country:", choices = c("All Countries", unique(data_long$Country))),
      selectInput("year", "Select Year:", choices = c("All Years", sort(unique(data_long$Year)))),
      actionButton("generate", "Generate Visualization")
    ),
    
    mainPanel(
      plotOutput("hiv_plot")
    )
  )
)
```

## 4.2 Server Logic

```{r}
library(ggplot2)
library(dplyr)

server <- function(input, output, session) {
  filtered_data <- reactive({
    req(input$generate)  # Ensure button click
    
    df <- data_long
    
    if (input$country != "All Countries") {
      df <- df %>% filter(Country == input$country)
    }
    
    if (input$year != "All Years") {
      df <- df %>% filter(Year == as.numeric(input$year))
    }
    
    df
  })

  output$hiv_plot <- renderPlot({
    df <- filtered_data()
    
    if (nrow(df) == 0) {
      return(NULL)  # Prevent errors when no data is available
    }
    
    if (input$country == "All Countries" & input$year != "All Years") {
      # Bar chart for all countries in a selected year
      ggplot(df, aes(x = reorder(Country, -Prevalence, na.rm = TRUE), y = Prevalence, fill = Country)) +
        geom_col() +
        theme_minimal() +
        labs(title = paste("HIV Prevalence in", input$year),
             x = "Country", y = "Prevalence Rate") +
        theme(axis.text.x = element_text(angle = 45, hjust = 1))
      
    } else {
      # Line chart for a country's HIV trend across years OR single bar if one year is selected
      ggplot(df, aes(x = Year, y = Prevalence, group = Country, color = Country)) +
        geom_line(size = 1.2) +
        geom_point(size = 3) +
        theme_minimal() +
        labs(title = paste("HIV Prevalence in", input$country),
             x = "Year", y = "Prevalence Rate")
    }
  })
}
```

## 4.3 Running the App

```{r}
shinyApp(ui = ui, server = server)
```

# 
