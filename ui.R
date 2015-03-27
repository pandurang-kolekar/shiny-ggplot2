library(DT)
library(shiny)
library(ggplot2)

shinyUI(pageWithSidebar(
  h4(" Interactive CSV file data analysis and visualization using ggplot2: Statistical summary and Scatter Plot",br()),
  
  sidebarPanel(
    #File upload and selector window
    fileInput('datafile', 'Choose CSV file',
              accept=c('text/csv', 'text/comma-separated-values,text/plain')),
    
    #These column selectors will be dynamically created after the file is loaded
    uiOutput("xvar"),
    uiOutput("yvar"),
    uiOutput("colflag"),
    
    #The conditional panel is triggered by the preceding checkbox
    conditionalPanel(
      condition="input.colflag==true",
      uiOutput("colby")
    ),
    #The action button to plot selected variables
    uiOutput("getPlot")
    
    
  ),
  mainPanel(
    #Prevent errors on the output panel
    tags$style(type="text/css",
               ".shiny-output-error { visibility: hidden; }",
               ".shiny-output-error:before { visibility: hidden; }"),
    p(h4("Developed by Pandurang Kolekar"),br(), 
      "Contact: ",
      a("pandurang.kolekar@gmail.com", href = "mailto:pandurang.kolekar@gmail.com"),br(),
      a("Visit my webpage.", href = "http://biosakshat.wix.com/pandurang-kolekar")
    ),
    
    uiOutput("msg"),
        
    #To visualize tabular data
    dataTableOutput('filetable'),
    
    uiOutput("summary_msg"),
    verbatimTextOutput("summary"),
    
    #To plot the selected variables
    uiOutput("plot_msg"),
    plotOutput('plot')
  )
))