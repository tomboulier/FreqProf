# module UI function
shinyUI <- function(id){
  ns <- NS(id)
  
  fillCol(flex=1, width = "100%", height = "100%")

    inputPanel(
      fileInput('file', 'Choose File',
                accept=c('.csv','.bin','.fpw')),
      tags$hr(),
      checkboxGroupInput("selected.behaviors", "Behaviors:",
                         c(), selected = c()),
      
      
      tags$hr(),
      checkboxInput('ggplot', 'ggplot', FALSE),
      helpText('Note: packages "ggplot2", "reshape2", and "grid" are required.'),
      checkboxInput('panel.in', 'Show left panel', TRUE),
      checkboxInput('panel.out', 'Show right panel', TRUE),
      checkboxInput('multiplot', 'Multiplots', FALSE),
      tags$hr(),
      radioButtons('which', 'Moving function',
                   c('Sum'='sum',
                     'Proportion'='proportion'),
                   'proportion'),
      numericInput("window", "Window length:", min=1, max=100, value=25, step=1),
      radioButtons('unit_length', 'length unit:',
                   c('%'='percent',
                     'bins'='bins')),
      numericInput("step", "Step:", min=1, max=100, value=1,
                   step=1),
      numericInput("resolution", "Resolution:", min=1, max=10, value=1,
                   step=1),
      textInput("units", "Time units:", value = "sec", width = NULL),
      numericInput("tick.every", "Tick every:", min=1, max=10, value=1,
                   step=1),
      numericInput("label.every", "Label every:", min=1, max=10, value=1,
                   step=1),
      tags$hr(),
      downloadButton('downloadData', 'Download Data'),
      tags$hr(),
      downloadButton('downloadPlotPDF', 'Download Plot as PDF'),
      downloadButton('downloadPlotPNG', 'Download Plot as PNG'),
      numericInput("graphWidth", "Width (inches):", min=1, max=20, value=10, step=1),
      numericInput("graphHeight", "Height (inches):", min=1, max=20, value=8, step=1)
    )
  
    plotOutput("distPlot",height = "500px")
}      


# server function
shiny <-function(input, output, session, stringsAsFactors) {
  
  getDataFromShiny = function(inFile){
    
    if (is.null(inFile)){
      filename = "S58-1-1.bin"
      filepath = "../extdata/S58-1-1.bin"
    } else {
      filename = inFile$name
      filepath = inFile$datapath
    }
    
    
    # reading a file, whose extension is either csv, bin or fpw,
    # and importing it as a data.frame
    
    
    file.extension = tolower(substr(filename,nchar(filename)-2,nchar(filename)))
    
    data.behavior = switch(file.extension,
                           csv = read.csv(filepath),
                           bin = read.bin(filepath),
                           fpw = read.fpw(filepath))
    
    if(is.null(data.behavior)) stop("file extension must be either csv, fpw, or bin")
    
    # update selected behaviors(by default select all options)
    if (is.null(input$selected.behaviors)){
      checkboxGroupInput("selected.behaviors", 
                         label = names(data.behavior), 
                         choices = names(data.behavior),
                         selected = names(data.behavior))
    }
    
    updateCheckboxGroupInput(session, "selected.behaviors",
                             choices = names(data.behavior),
                             selected = input$selected.behaviors)
    
    #         updateCheckboxGroupInput(session, "selected.behaviors",
    #                              choices = names(data.behavior),
    #                              selected = input$selected.behaviors)
    
    #     if (is.null(input$selected.behaviors)){
    #       behaviors_selected <- names(data.behavior) %in% input$selected.behaviors
    #     } else {
    #       behaviors_selected <- input$selected.behaviors
    #     }
    #     
    data.behavior_1 = data.behavior[,names(data.behavior) %in% input$selected.behaviors]
    
    if(is.null(ncol(data.behavior_1))){
      # this means that only one behavior is selected
      dat = as.data.frame(data.behavior_1)
      names(dat) = input$selected.behaviors
      return(dat)
    }
    
    if(ncol(data.behavior_1)>1) return(data.behavior_1)
    
    return(NULL)
  }
  
  getWindowLength = function(unit,window,data){
    if(unit == "bins")
      return(window)
    else
      return(round(window/100*nrow(data)))
  }
  
  output$distPlot <- renderPlot({
    data.behavior_1 <- reactive({
      getDataFromShiny(input$file)
    })
    if(is.null(data.behavior_1)) return(NULL)
    
    data.freqprof = freqprof(data.behavior_1,
                             window = getWindowLength(input$unit_length,input$window,data.behavior_1),
                             step = input$step,
                             resolution = input$resolution,
                             which = input$which)
    
    # plotting
    plot_freqprof(data.freqprof,
                  gg=input$ggplot,
                  panel.in = input$panel.in,
                  panel.out = input$panel.out,
                  multiPlot = input$multiplot,
                  xAxisUnits = input$units,
                  tick.every = input$tick.every,
                  label.every = input$label.every)
  })
  
  observe({
    data.behavior_1 = getDataFromShiny(input$file)
    if(is.null(data.behavior_1)) return(NULL)
    
    # update range for window length
    if(input$unit_length == "bins"){
      win = round(.25*nrow(data.behavior_1))
      updateSliderInput(session, "window", value = win,
                        min = 1, max = 4*win, step = 1)
    }
    if(input$unit_length == "percent"){
      updateSliderInput(session, "window", value = 25,
                        min = 1, max = 100, step = 1)
    }
    
    # update tick.every and label.every
    t.every = round(nrow(data.behavior_1)/31)
    updateSliderInput(session, "tick.every", value = t.every,
                      min = 1, max = nrow(data.behavior_1), step = 1)
    updateSliderInput(session, "label.every", value = 3,
                      min = 1, max = 100, step = 1)
  })
  
  output$downloadData <- downloadHandler(
    filename = "freqprof.csv",
    content = function(file) {
      data.behavior_1 = getDataFromShiny(input$file)
      if(is.null(data.behavior_1)) return(NULL)
      
      data.freqprof = freqprof(data.behavior_1,
                               window = input$window,
                               step = input$step,
                               resolution = input$resolution,
                               which = input$which)
      
      # which panels will be downloaded?
      panels = c(2)
      if(input$panel.in) panels = c(1,panels)
      if(input$panel.out) panels = c(panels,3)
      
      write.csv(data.freqprof$data[ data.freqprof$data$panels %in% panels, ], file,row.names=F)
    }
  )
  
  output$downloadPlotPDF <- downloadHandler(
    filename = function() { paste0("ShinyPlot.pdf") },
    content = function(file) {
      pdf(file,width = input$graphWidth, height = input$graphHeight)
      data.behavior_1 = getDataFromShiny(input$file)
      data.freqprof = freqprof(data.behavior_1,
                               getWindowLength(input$unit_length,input$window,data.behavior_1),
                               step = input$step,
                               resolution = input$resolution,
                               which = input$which)
      plot.freqprof(data.freqprof,
                    gg=input$ggplot,
                    panel.in = input$panel.in,
                    panel.out = input$panel.out,
                    multiPlot = input$multiplot,
                    xAxisUnits = input$units)
      dev.off()
      
      if (file.exists(paste0(file, ".pdf")))
        file.rename(paste0(file, ".pdf"), file)
    })
  
  output$downloadPlotPNG <- downloadHandler(
    filename = function() { paste0("ShinyPlot.png") },
    content = function(file) {
      png(file,width = input$graphWidth, height = input$graphHeight, units = 'in', res = 100)
      data.behavior_1 = getDataFromShiny(input$file)
      data.freqprof = freqprof(data.behavior_1,
                               window = getWindowLength(input$unit_length,input$window,data.behavior_1),
                               step = input$step,
                               resolution = input$resolution,
                               which = input$which)
      plot.freqprof(data.freqprof,
                    gg=input$ggplot,
                    panel.in = input$panel.in,
                    panel.out = input$panel.out,
                    multiPlot = input$multiplot,
                    xAxisUnits = input$units)
      dev.off()
      
      if (file.exists(paste0(file, ".png")))
        file.rename(paste0(file, ".png"), file)
    })
  
}


