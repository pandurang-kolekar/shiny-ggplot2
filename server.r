library(DT)
library(shiny)
library(ggplot2)

shinyServer(function(input, output) {
  
  #This function is repsonsible for loading in the selected CSV file
  filedata <- reactive({
    infile <- input$datafile
    if (is.null(infile)) {
      # User has not uploaded a file yet
      return(NULL)
    }
    dataframe <- read.csv(infile$datapath)
    return(dataframe)
    
  })
  
  
  #The following set of functions dynamically populate the column selectors
  output$yvar <- renderUI({
    df <-filedata()
    if (is.null(df)) return(NULL)
    
    items=names(df)
    names(items)=items
    selectInput("yvar", "Y variable:",items)
    
  })
  
  output$xvar <- renderUI({
    df <-filedata()
    if (is.null(df)) return(NULL)
    
    items=names(df)
    names(items)=items
    renderText({h2("Choose variables to plot:")})
    selectInput("xvar", "X variable:",items)    
    
  })
  
  #The checkbox selector is used to determine whether we wish to color by categorical variable
  output$colflag <- renderUI({
    df <-filedata()
    if (is.null(df)) return(NULL)
    
    checkboxInput("colflag", "Color by", TRUE)
  })
  
  #If we do want to color by category, this is where categorical variables gets created
  output$colby <- renderUI({
    df <-filedata()
    if (is.null(df)) return(NULL)
    #Let's only show numeric columns
    nums <- sapply(df, is.factor)
    items=names(nums[nums])
    names(items)=items
    selectInput("category", "Category:",items)
  })
  
  output$getPlot <- renderUI({
    df <-filedata()
    if (is.null(df)) return(NULL)
    #Let's only show numeric columns
    actionButton("getPlot", "Plot the variables")
  })
  
  output$msg <- renderUI({
    df <-filedata()
    if (is.null(df)) return(NULL)
    p(h3("The uploaded data is as following:"),br(),p("Note: Select variables from sidebar panel and press the Plot button at bottom to compute their summary and draw scatterplot"), br())
        
  })
  
  
  
  #This previews the CSV data file
  
  output$filetable <- DT::renderDataTable(DT::datatable(filedata()))
  
  
  #This function is the one that is triggered when the action button is pressed
  getdata <- reactive({
    if (input$getPlot == 0) return(NULL)
    df=filedata()
    if (is.null(df)) return(NULL)    
        
      #Get the CSV file data
      dummy=filedata()
      #Which from/to columns did the user select?
      xv=input$xvar
      yv=input$yvar
      cat=input$category
      xy <- as.data.frame(dummy[,c(xv,yv,cat)])
      #names(xy)=c("X","Y","cat")
      return(xy)    
    
  })

  # Generate a summary of the dataset
  output$summary <- renderPrint({
    dataset <- getdata()
    names(dataset)<-c(input$xvar,input$yvar)
    output$summary_msg <- renderUI({
      df <-filedata()
      if (input$getPlot == 0) return(NULL)
      p(h3("Summary of ",input$xvar," and ",input$yvar),br())
      
    })
    summary(dataset)
    
  })
  
  output$plot_msg <- renderUI({
    df <-filedata()
    if (input$getPlot == 0) return(NULL)
    p(h3("Scatterplot of ",input$xvar," and ",input$yvar))
    
  })
  
  output$plot <- renderPlot({
    
    p <- ggplot(getdata(), aes_string(x=input$xvar, y=input$yvar)) + geom_point()
        
    if (input$category != 'None')
      p <- p + aes_string(color=input$category)
    p <- p + geom_point(size = 3)
    
    print(p)
    
  })
  
})