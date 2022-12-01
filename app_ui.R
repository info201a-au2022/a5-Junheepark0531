#A5 ui.R
library(shiny)
library(lintr)
library(stringr)
library(ggplot2)
library(plotly)
library(dplyr)

####Format Introduction page with image and texts####
co2_data <- read.csv("https://raw.githubusercontent.com/owid/co2-data/master/owid-co2-data.csv")

intro_page <- tabPanel(
  "Introduction", 
  h1("Global CO₂ Emission Rates are Causing Climate Change"), 
  img(src = "https://iea.imgix.net/69f767b9-6676-4345-a1ea-9dc410ae5990/GettyImages-1303511343.png?auto=compress%2Cformat&fit=min&q=80&rect=0%2C0%2C3991%2C2245&w=1220&h=686&fit=crop&fm=jpg&q=70&auto=format", width = "77%", height = "77%"),
  h2("Introduction"),
  p("Have you known that the Global average temperatures have increased by more than 1℃ since pre-industrial times? These temperature changes are significant because the increase of 1℃ in Global average temperature can have significant impacts on climate and natural systems. These increases in global average temperature are mostly caused by CO₂ emissions. For this report, I used a dataset called ‘owid-co2-data.csv’ and will use a variable called ‘year,’ ‘country,’ and ‘co2’ to provide interactive visualization of the growth of annual total production-based emissions of CO₂ in million tonnes for every country in the world. But before heading to the second page to access interactive visualization, there are four helpful values from the dataset to let you have a glimpse of the information this data set includes."),
  br(),
  h5("What is the Average Value of CO₂ Across All the Countries in 2020?"),
  p("The average value of annual total production-based emissions of carbon dioxide (CO₂) without land-use change (variable “co2”), is 922.46 million tonnes."),
  br(),
  h5("Which Country has the Highest and Lowest Sum of CO₂ Value? (exclude 'World' in 'country' variable, and '0' in 'co2' variable)"),
  p("The country with the highest sum of annual total production-based emissions of carbon dioxide (CO₂) without land-use change (variable 'co2'), is “High-income-countries” with the value of 979685.13 million tonnes, and the lowest is Antarctica with the value of 0.16 million tonnes. The reason why the highest-income countries have the highest sum of annual total production-based emissions of CO₂ is that they use more technology, meaning more energy, which will cause the CO₂ emission rate to rise. Similarly, the reason why Antarctica has the lowest sum of annual total production-based emissions of CO₂ is that there are not many technologies being used, meaning less energy, which will cause the CO₂ emission rate to not increase a lot."),
  br(),
  h5("What is the Highest Annual Total Production-based Emissions of CO₂ in a Year?"),
  p("The value of the highest annual total production-based emissions of carbon dioxide (CO₂) without land-use change(variable 'co2_per_capita'), is 824.46 tonnes per person."),
  br()
)




####Format the Fluid Page with texts, bar plot, and the features of widgets####

page2_datas <- fluidPage(    
  
  # Give the page a title
  titlePanel("Growth of Total Production-based Emissions of CO₂ in Selected Country by Selected Year"),
  
  # Generate a row with a sidebar
  sidebarLayout(      
    
    # Define the sidebar with a box of selections of countries, and the slider for the adjustments of year in bar plot
    sidebarPanel(
      selectInput("country", "Country:", 
                  choices = unique(co2_data$country)),

      sliderInput("year", "Year:",
                  min = 1930, max = max(co2_data$year),
                  value = c(1970, 2008)),
      helpText("Data from 'owid-co2-data.csv'")
    ),
    
    # Create a spot for the bar plot and the chart
    mainPanel(
      plotlyOutput("co2plot"),
      br(),
      div(tags$em(strong("Caption:"), "The chart of Growth of Total Production-based Emissions of CO₂ in Selected Countries by Selected Year is included to provide interactive visualization of the CO₂ emission rates of every country in the world. This chart informs that most of the country has a pattern of the significant increase in annual total production-based emissions of CO₂ between the years 2004 and 2020. But in some of the countries, such as Ukraine, annual total production-based emissions of CO₂ rate is decreasing between the year 1990 to 2021."),
          style = "text-align: left;")

    )
    
  )
)




####Tab Panel for Page 2####

page2 <- tabPanel(
  "Interactive Visualization", 
  page2_datas
)




####ui####
ui <- navbarPage(
  "INFO 201 A5",
  intro_page,
  page2
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)

