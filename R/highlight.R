## ui
highlightUI <- function(id){
  ns <- NS(id)
  tagList(
    textInput(ns("bg_string"), 
      "Highlighting string \u5f37\u8abf\u6587\u5b57", 
      width = 500, 
      placeholder = "aaa;bbb;ccc (separate with ';' or ',' \u534a\u89d2\u306e\u30bb\u30df\u30b3\u30ed\u30f3\u304b\u30ab\u30f3\u30de\u533a\u5207\u308a)"),
    colourpicker::colourInput(ns("bg_color"), 
      "Highlighting color \u8272", 
      value = "yellow"),

    # Not working
    #          numericInput("freeze_row", 
    #            "Freeze rows \u56fa\u5b9a\u884c", 
    #            value = 1, min = 0, width = 150),
    #          numericInput("freeze_col", 
    #            "Freeze cols \u56fa\u5b9a\u5217",
    #            value = 1, min = 0, width = 150),

  #     checkboxInput(ns("set_col_width"), 
  #      "Auto col width \u81ea\u52d5\u5e45\u8a2d\u5b9a", 
  #      value = FALSE),
  # 
  #     checkboxInput(ns("set_auto_filter"), 
  #      "Set autofilter \u30aa\u30fc\u30c8\u30d5\u30a3\u30eb\u30bf", 
  #      value = FALSE)
  )
}

## server
highlightServer <- function(id){
  moduleServer(id, function(input, output, session){
    req(input$upload)

    wbs <- 
        input$upload$datapath |> 
        purrr::map(openxlsx::loadWorkbook)

    col <- reactive(input$bg_color)
    str <- reactive(input$bg_string)
    wid <- reactive(input$set_col_width)
    fil <- reactive(input$set_auto_filter)

    wbs |> 
      purrr::map(
        walk_wb, set_bg_color, 
        color = col(), 
        strings = stringr::str_split_1(str(), ";|,"))

    # Not working
    #     wbs |> 
    #       purrr::map(walk_wb, freeze_pane, 
    #       firstActiveRow = input$freeze_row + 1, # active: freeze + 1
    #       firstActiveCol = input$freeze_col + 1)

  #     if(wid()){
  #       wbs |> 
  #         purrr::map(walk_wb, set_col_width)
  #     }
  # 
  #     if(fil()){
  #       wbs |> 
  #         purrr::map(walk_wb, add_filter)
  #     }

    wbs

  })

}
