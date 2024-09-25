fileUI <- function(id){
  ns <- NS(id)
  sidebarPanel(
    fileInput(ns("upload"), "Select xlsx or xls file(s)",
              accept = c(".xlsx"),
              multiple = TRUE),

    downloadButton(ns("dl"), "Download")
  )
}

fileServer <- function(id, wbs){
  moduleServer(id, function(input, output, session){

    now <- Sys.time() |> 
      format("%Y-%m-%d_%X") |> 
      stringr::str_replace_all(":", "_")

    output$dl <- downloadHandler(
      filename = function(){
        if(length(wbs) == 1){
          paste0(tools::file_path_sans_ext(input$upload$name), 
                 now, ".xlsx")
        }else{
          paste0("convex", now, ".zip")
        }
      },
      content = function(file){
        if(length(wbs) == 1){
          return(openxlsx::saveWorkbook(wbs[[1]], file = file, overwrite = TRUE))
        }else{
          files <- paste0(tools::file_path_sans_ext(input$upload$name), 
                          now, ".xlsx")
          purrr::walk2(wbs, files, openxlsx::saveWorkbook)
          files_ziped <- utils::zip(zipfile = file, files = files)
          unlink(files)
          return(files_ziped)
        }
      }
    )

  })
}
