## ui
pivoteaUI <- function(id){
  ns <- NS(id)
  tagList(

    # Choices
    checkboxGroupInput(ns("row")  , "行"        , inline = TRUE),
    checkboxGroupInput(ns("col")  , "列"        , inline = TRUE),
    checkboxGroupInput(ns("value"), "セルの値"  , inline = TRUE),
    checkboxGroupInput(ns("split"), "シート分割", inline = TRUE),

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
    observeEvent(df(), updateCheckboxGroupInput(session, inputId = "row"  , choices = choices(), inline = TRUE))
    observeEvent(df(), updateCheckboxGroupInput(session, inputId = "col"  , choices = choices(), inline = TRUE))
    observeEvent(df(), updateCheckboxGroupInput(session, inputId = "value", choices = choices(), inline = TRUE))
    observeEvent(df(), updateCheckboxGroupInput(session, inputId = "split", choices = choices(), inline = TRUE))

    df <- reactive({
  #       openxlsx::read.xlsx(input$upload$datapath)
      pivotea::hogwarts
    })

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
        table()[[1]]
    })

  })
}
