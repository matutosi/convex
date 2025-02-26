## ui
pivoteaUI <- function(id){
  ns <- NS(id)
  tagList(

    # Choices
    selectInput(ns("row")  , "rows \u884c"                         , choices = character(0), multiple = TRUE),
    selectInput(ns("col")  , "cols \u5217"                         , choices = character(0), multiple = TRUE),
    selectInput(ns("value"), "value \u30bb\u30eb\u306e\u5024"      , choices = character(0), multiple = TRUE),
    selectInput(ns("split"), "split \u30b7\u30fc\u30c8\u5206\u5272", choices = character(0), multiple = TRUE),

    textInput(ns("sep"), "separator \u533a\u5207\u308a\u6587\u5b57", "_"),

    checkboxInput(ns("rm_empty_df"), 
     "Remove empty df \u7a7a\u306edf\u3092\u9664\u5916", 
     value = TRUE),
  )
}

## server
pivoteaServer <- function(id){
  moduleServer(id, function(input, output, session){

    df <- reactive({
      # req(input$upload)
      # openxlsx::read.xlsx(input$upload$datapath)
      pivotea::hogwarts
    })
    
    choices <- reactive({
      colnames(df())
    })

    # Update choices
    observeEvent(df(), updateSelectInput(session, inputId = "row"  , choices = choices(), selected = choices()[1]))
    observeEvent(df(), updateSelectInput(session, inputId = "col"  , choices = choices(), selected = choices()[2]))
    observeEvent(df(), updateSelectInput(session, inputId = "value", choices = choices(), selected = choices()[3]))
    observeEvent(df(), updateSelectInput(session, inputId = "split", choices = choices(), selected = choices()[4]))

    output$data <- reactable::renderReactable({
      reactable::reactable(df(), resizable = TRUE, filterable = TRUE)
    })

    table <- reactive({
      df() |>
        pivotea::pivot(row         = input$row        ,
                       col         = input$col        ,
                       value       = input$value      ,
                       split       = input$split      ,
                       sep         = input$sep        ,
                       rm_empty_df = input$rm_empty_df)
    })

    output$pivot <- renderTable({
      if(is.data.frame(table())){
        table()
      }else{
        table()[[1]]
      }
    })

  # create a workbook and add data into sheets
   pivot_wb <- reactive({
      wb <- openxlsx::createWorkbook()
      for(i in seq_along(table())){
        openxlsx::addWorksheet(wb, names(table())[i])
        openxlsx::writeData(wb, names(table())[i], table()[[i]])
      }
      wb
    })
  pivot_wb()

  })
}
