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

fileServer <- function(id, wbs){
  moduleServer(id, function(input, output, session){

    now <- 
      reactive(
        Sys.time() |> 
        format("%Y-%m-%d_%X") |> 
        stringr::str_replace_all(":", "_")
      )

    output$dl <- downloadHandler(
      filename = function(){
        if(length(wbs) == 1){
          paste0(tools::file_path_sans_ext(input$upload$name), 
                 now(), ".xlsx")
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
          files <- paste0(tools::file_path_sans_ext(input$upload$name), 
                          now(), ".xlsx")
          purrr::walk2(wbs, files, openxlsx::saveWorkbook)
          files_ziped <- utils::zip(zipfile = file, files = files)
          unlink(files)
          return(files_ziped)
        }
      }
    )

  })
}
