#A5 server.R
library(shiny)
library(lintr)
library(stringr)
library(ggplot2)
library(plotly)
library(dplyr)

#Read in data
co2_data <- read.csv("https://raw.githubusercontent.com/owid/co2-data/master/owid-co2-data.csv")


##### For Page 1 #####
#What is the average value of CO2 across all the countries in 2020?
avg_co2_in_2020 <- co2_data %>%
  group_by(year)%>%
  filter(year == 2020)%>%
  summarize(co2_all_avg = mean(co2, na.rm = TRUE))%>%
  pull(co2_all_avg)


#Which country has the highest sum of CO2 Value? Include the highest sum of C02 value too. (exclude "World" in country variable)
high_co2_country <- co2_data%>%
  group_by(country)%>%
  summarize(co2_all_avg = sum(co2, na.rm = TRUE))%>%
  filter(country != "World")%>%
  filter(co2_all_avg == max(co2_all_avg, na.rm = TRUE))%>%
  pull(country, co2_all_avg)

#Which country has the lowest sum of CO2 Value? Include the lowest sum of C02 value too. (exclude "World" in country variable, and 0 in CO2 variable)
low_co2_country <- co2_data%>%
  group_by(country)%>%
  filter(co2 != 0)%>%
  summarize(co2_all_avg = sum(co2, na.rm = TRUE))%>%
  filter(country != "World")%>%
  filter(co2_all_avg == min(co2_all_avg, na.rm = TRUE))%>%
  pull(country, co2_all_avg)


#Which country has the highest average of percentage growth of CO2? Include the highest average of C02 percentage growth value too.

high_sum_prct_co2 <- co2_data %>%
  group_by(country)%>%
  filter(co2_growth_prct != 0)%>%
  summarize(avg_co2_growth_prct = mean(co2_growth_prct, na.rm = TRUE))%>%
  filter(country != "World")%>%
  filter(avg_co2_growth_prct == max(avg_co2_growth_prct, na.rm = TRUE))%>%
  pull(country, avg_co2_growth_prct)



#What is the highest annual total production-based emissions of CO2 in a year?
high_co2_per_capita <- co2_data %>%
  filter(co2_per_capita == max(co2_per_capita, na.rm = TRUE))%>%
  pull(co2_per_capita)

  
##### For Page 2 #####

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  #render plotly
  output$co2plot <- renderPlotly({
    #wrangle the data for the bar graph using DPLYR
    data <- co2_data%>%
      filter(country == input$country, 
             year >= input$year[1], year <= input$year[2])%>%
      select(year, co2)

    # Render a barplot with ggplotly
    ggplotly(
      ggplot(data = data, aes(x = year, y = co2)) + 
        geom_bar(stat="identity", fill="firebrick") + 
        ggtitle(input$country) +
        xlab("Year") + 
        ylab("Total Production-Based Emissions of CO2 (in Million Tonnes)")

    )
  })
}

