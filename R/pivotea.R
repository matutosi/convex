## ui
pivoteaUI <- function(id){
  ns <- NS(id)
  tagList(

    # Choices
    checkboxGroupInput(ns("row_1")  , "行1"        , inline = TRUE),
    checkboxGroupInput(ns("row_2")  , "行2"        , inline = TRUE),
    checkboxGroupInput(ns("row_3")  , "行3"        , inline = TRUE),
    checkboxGroupInput(ns("col_1")  , "列1"        , inline = TRUE),
    checkboxGroupInput(ns("col_2")  , "列2"        , inline = TRUE),
    checkboxGroupInput(ns("col_3")  , "列3"        , inline = TRUE),
    checkboxGroupInput(ns("value_1"), "セルの値1"  , inline = TRUE),
    checkboxGroupInput(ns("value_2"), "セルの値2"  , inline = TRUE),
    checkboxGroupInput(ns("value_3"), "セルの値3"  , inline = TRUE),
    checkboxGroupInput(ns("split_1"), "シート分割1", inline = TRUE),
    checkboxGroupInput(ns("split_2"), "シート分割2", inline = TRUE),
    checkboxGroupInput(ns("split_3"), "シート分割3", inline = TRUE),

    textInput(ns("sep"), "区切り文字", "_"),

    checkboxInput(ns("rm_empty_df"), 
     "Remove empty df", 
     value = TRUE),
  )
}


## server
pivoteaServer <- function(id){
  moduleServer(id, function(input, output, session){

    choices <- reactive({
  #       req(input$upload)
      colnames(df())
    })

    # Update choices
    observeEvent(df(), updateCheckboxGroupInput(session, inputId = "row_1"  , choices = choices(), inline = TRUE))
    observeEvent(df(), updateCheckboxGroupInput(session, inputId = "row_2"  , choices = choices(), inline = TRUE))
    observeEvent(df(), updateCheckboxGroupInput(session, inputId = "row_3"  , choices = choices(), inline = TRUE))
    observeEvent(df(), updateCheckboxGroupInput(session, inputId = "col_1"  , choices = choices(), inline = TRUE))
    observeEvent(df(), updateCheckboxGroupInput(session, inputId = "col_2"  , choices = choices(), inline = TRUE))
    observeEvent(df(), updateCheckboxGroupInput(session, inputId = "col_3"  , choices = choices(), inline = TRUE))
    observeEvent(df(), updateCheckboxGroupInput(session, inputId = "value_1", choices = choices(), inline = TRUE))
    observeEvent(df(), updateCheckboxGroupInput(session, inputId = "value_2", choices = choices(), inline = TRUE))
    observeEvent(df(), updateCheckboxGroupInput(session, inputId = "value_3", choices = choices(), inline = TRUE))
    observeEvent(df(), updateCheckboxGroupInput(session, inputId = "split_1", choices = choices(), inline = TRUE))
    observeEvent(df(), updateCheckboxGroupInput(session, inputId = "split_2", choices = choices(), inline = TRUE))
    observeEvent(df(), updateCheckboxGroupInput(session, inputId = "split_3", choices = choices(), inline = TRUE))

    df <- reactive({
  #       openxlsx::read.xlsx(input$upload$datapath)
      pivotea::hogwarts
    })

    output$data <- reactable::renderReactable({
      reactable::reactable(df(), resizable = TRUE, filterable = TRUE)
    })

    table <- reactive({
      df() |>
        pivotea::pivot(row         = c(input$row_1  , input$row_2  , input$row_3  ),
                       col         = c(input$col_1  , input$col_2  , input$col_3  ),
                       value       = c(input$value_1, input$value_2, input$value_3),
                       split       = c(input$split_1, input$split_2, input$split_3),
                       sep         = input$sep        ,
                       rm_empty_df = input$rm_empty_df)
    })

    output$pivot <- renderTable({
        table()[[1]]
    })

  })
}
