library(colourpicker)
library(openxlsx)
library(shiny)

source("D:/matu/work/ToDo/convex/R/convex.R")

ui <- 
  fluidPage(
    titlePanel("convex: for Convenient Excel"),
    sidebarLayout(
      sidebarPanel(
        # uplaod
        fileInput("upload", 
                  "Select a xlsx or xls file",
                  accept = c(".xlsx", "xls")),
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

         numericInput("f_row", 
           "Freeze rows \u56fa\u5b9a\u884c", 
           value = 1, min = 0, width = 150),
         numericInput("f_col", 
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

server <- function(input, output) {
  workbook <- reactive({
    req(input$upload)
    wb <- openxlsx::loadWorkbook(input$upload$datapath)

    walk_wb(wb, set_bg_color, 
      color = input$bg_color, 
      strings = stringr::str_split_1(input$bg_string, ";|,"))

    if(input$set_auto_filter){
      walk_wb(wb, add_filter)
    }

    if(input$set_col_width){
      walk_wb(wb, set_col_width)
    }

    walk_wb(wb, freeze_pane, 
      firstActiveRow = input$f_row + 1, # active: freeze + 1
      firstActiveCol = input$f_col + 1)

    wb
  })

  output$dl <- downloadHandler(
    filename = function(){ 
      paste0(tools::file_path_sans_ext(input$upload$name), 
             Sys.time() |> 
               format("%Y-%m-%d_%X") |> 
               stringr::str_replace_all(":", "_"), 
             ".xlsx")
    },
    content = function(file){
      openxlsx::saveWorkbook(workbook(), 
                             file = file, 
                             overwrite = TRUE)
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
