library(colourpicker)
library(openxlsx)
library(shiny)

source("convex.R")

ui <- 
  fluidPage(
    titlePanel("convex: for Convenient Excel"),
    sidebarLayout(
      sidebarPanel(
        # uplaod
        fileInput("upload", 
                  "Select xlsx or xls file(s)",
                  accept = c(".xlsx", "xls"),
                  multiple = TRUE),
         # download
         downloadButton("dl", "Download")
      ),

            mainPanel(
        textInput("bg_string", 
          "Highlighting string \u5f37\u8abf\u6587\u5b57", 
          width = 500, 
          placeholder = "aaa;bbb;ccc (separate with ';' or ',' \u534a\u89d2\u306e\u30bb\u30df\u30b3\u30ed\u30f3\u304b\u30ab\u30f3\u30de\u533a\u5207\u308a)"),
        colourpicker::colourInput("bg_color", 
          "Highlighting color \u8272", 
          value = "yellow"),

         numericInput("freeze_row", 
           "Freeze rows \u56fa\u5b9a\u884c", 
           value = 1, min = 0, width = 150),
         numericInput("freeze_col", 
           "Freeze cols \u56fa\u5b9a\u5217",
           value = 1, min = 0, width = 150),

         checkboxInput("set_col_width", 
           "Auto col width \u81ea\u52d5\u5e45\u8a2d\u5b9a", 
           value = TRUE),

         checkboxInput("set_auto_filter", 
           "Set autofilter \u30aa\u30fc\u30c8\u30d5\u30a3\u30eb\u30bf", 
           value = TRUE)
       )
    )
  )

server <- function(input, output){
  workbooks <- reactive({
    req(input$upload)
    wbs <- 
      input$upload$datapath |> 
      purrr::map(openxlsx::loadWorkbook)

    wbs |> 
      purrr::map(
        walk_wb, set_bg_color, 
        color = input$bg_color, 
        strings = stringr::str_split_1(input$bg_string, ";|,"))

    if(input$set_auto_filter){
      wbs |> 
        purrr::map(walk_wb, add_filter)
    }

    if(input$set_col_width){
      wbs |> 
        purrr::map(walk_wb, set_col_width)
    }

    wbs |> 
      purrr::map(walk_wb, freeze_pane, 
      firstActiveRow = input$freeze_row + 1, # active: freeze + 1
      firstActiveCol = input$freeze_col + 1)

    wbs
  })

  now <- 
    Sys.time() |> 
    format("%Y-%m-%d_%X") |> 
    stringr::str_replace_all(":", "_")
  
  output$dl <- downloadHandler(
    filename = function(){
      wbs <- workbooks()
      if(length(wbs) == 1){
        paste0(tools::file_path_sans_ext(input$upload$name), 
               now, ".xlsx")
      }else{
        paste0("convex", now, ".zip")
      }
    },
    content = function(file){
      wbs <- workbooks()
      if(length(wbs) == 1){
        return(openxlsx::saveWorkbook(wbs[[1]], file = file, overwrite = TRUE))
      }else{
        files <- paste0(tools::file_path_sans_ext(input$upload$name), 
                        now, ".xlsx")
        purrr::walk2(wbs, files, openxlsx::saveWorkbook)
        return(utils::zip(zipfile = file, files = files))
      }
    }
  )
}

shinyApp(ui, server)

  # freeze_paneが2シート目以降が駄目・駄目・駄目・駄目・駄目
  # wb <- openxlsx::loadWorkbook(fs::path_home("desktop/temp.xlsx"))
  # walk_wb(wb, freeze_pane)
  # out <- fs::path_home("desktop/a.xlsx")
  # openxlsx::saveWorkbook(wb, out)
  # shell.exec(out)