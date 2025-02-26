## common UI
fileUI <- function(id, multiple = TRUE){
  ns <- NS(id)
  label <- dplyr::if_else(multiple,
                          "Select xlsx file(s)",
                          "Select an xlsx file")
  tagList(
    fileInput(ns("upload"), label,
              accept = c(".xlsx"),
              multiple = multiple),

    tags$hr(),

    downloadButton(ns("dl"), "Download"),

    tags$hr(),
  )
}

## Server for highlight
now <- function(){
  Sys.time() |> 
    format("%Y-%m-%d_%X") |> 
     stringr::str_replace_all(":", "_")
}

highlight_fileServer <- function(id, wbs){
  moduleServer(id, function(input, output, session){

    # output
    output$dl <- downloadHandler(
      filename = function(){
        if(length(wbs) == 1){
          paste0(fs::path_ext_remove(input$upload$name), "_", now(), ".xlsx")
        }else{
          paste0("convex", now(), ".zip")
        }
      },
      content = function(file){
        if(inherits(wbs, "workbook")){
          return(openxlsx::saveWorkbook(wbs, file = file, overwrite = TRUE))
        }
        if(length(wbs) == 1){
          return(openxlsx::saveWorkbook(wbs[[1]], file = file, overwrite = TRUE))
        }else{
          files <- paste0(fs::path_ext_remove(input$upload$name),  "_", now(), ".xlsx")
          purrr::walk2(wbs, files, openxlsx::saveWorkbook)
          files_ziped <- utils::zip(zipfile = file, files = files)
          unlink(files)
          return(files_ziped)
        }
      }
    )

  })
}

## Server for pivotea
pivotea_uploadServer <- function(id){
  moduleServer(id, function(input, output, session){

    # input
    data_in <- reactive({
      req(input$upload)
      openxlsx::read.xlsx(input$upload$datapath, sheet = 1)
    })

    # show table
    output$data <- reactable::renderReactable({
        reactable::reactable(data_in(), resizable = TRUE, filterable = TRUE)
    })

    # update choices
    observeEvent(data_in(), {
      choices <- colnames(data_in())
      updateSelectInput(session, inputId = "row"  , choices = choices, selected = choices[1])
      updateSelectInput(session, inputId = "col"  , choices = choices, selected = choices[2])
      updateSelectInput(session, inputId = "value", choices = choices, selected = choices[3])
      updateSelectInput(session, inputId = "split", choices = choices, selected = choices[4])
    })
    # Return data
    reactive(data_in)

  })
}

pivotea_downloadServer <- function(id, wb){
  moduleServer(id, function(input, output, session){

    # output
    output$dl <- downloadHandler(
      filename = function(){
          paste0(fs::path_ext_remove(input$upload$name),  "_", now(), ".xlsx")
      },
      content = function(file){
        openxlsx::saveWorkbook(wb(), file = file, overwrite = TRUE)
      }
    )

  })
}
