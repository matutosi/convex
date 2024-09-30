## ui
pivoteaUI <- function(id){
  ns <- NS(id)
  tagList(

    # Choices
    selectInput(ns("row"), "行"          , choices = character(0), multiple = TRUE),
    selectInput(ns("col"), "列"          , choices = character(0), multiple = TRUE),
    selectInput(ns("value"), "セルの値"  , choices = character(0), multiple = TRUE),
    selectInput(ns("split"), "シート分割", choices = character(0), multiple = TRUE),

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
    observeEvent(df(), updateSelectInput(session, inputId = "row"  , choices = choices(), selected = choices()[1]))
    observeEvent(df(), updateSelectInput(session, inputId = "col"  , choices = choices(), selected = choices()[2]))
    observeEvent(df(), updateSelectInput(session, inputId = "value", choices = choices(), selected = choices()[3]))
    observeEvent(df(), updateSelectInput(session, inputId = "split", choices = choices(), selected = choices()[4]))

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
