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

    checkboxInput(ns("borders"), 
     "Draw borders \u7f6b\u7dda", 
     value = TRUE),

    checkboxInput(ns("auto_filter"), 
     "Auto filter \u30aa\u30fc\u30c8\u30d5\u30a3\u30eb\u30bf", 
     value = TRUE),

  )
}

## server
pivoteaServer <- function(id, data_in){
  moduleServer(id, function(input, output, session){

    # pivot table
    table <- reactive({
        pivotea::pivot(data_in(), 
                       row         = input$row        ,
                       col         = input$col        ,
                       value       = input$value      ,
                       split       = input$split      ,
                       sep         = input$sep        ,
                       rm_empty_df = input$rm_empty_df)
    })

    # show table
    output$pivot <- renderTable({
      if(is.data.frame(table())){
        table()
      }else{
        table()[[1]]
      }
    })

    # create a workbook and add data into sheets
    wb_pivotea <- reactive({
      wb <- openxlsx::createWorkbook()
      if(is.data.frame(table())){ # no split
        openxlsx::addWorksheet(wb, "sheet1")
        openxlsx::writeData(wb, "sheet1", table())
      }else{
        for(i in seq_along(table())){
          openxlsx::addWorksheet(wb, names(table())[i])
          openxlsx::writeData(wb, names(table())[i], table()[[i]])
        }
      }
      if(input$borders){
        walk_wb(wb, add_row_borders)
        walk_wb(wb, add_col_borders)
      }
      if(input$auto_filter){
        walk_wb(wb, add_filter)
      }
      wb
    })

    # return pivoted workbook
    reactive(wb_pivotea)

  })
}
