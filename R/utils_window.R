  # number of cols
cols_wb_sheet <- function(wb, sheet){
  openxlsx::readWorkbook(wb, sheet) |> 
    ncol() |> 
    seq()
}

  # auto filter
add_filter <- function(wb, sheet, rows = 1){
  cols <- cols_wb_sheet(wb, sheet)
  openxlsx::addFilter(wb, sheet, rows = rows, cols = cols)
}

  # auto width
set_col_width <- function(wb, sheet, widths = "auto", ...){
  cols <- cols_wb_sheet(wb, sheet)
  openxlsx::setColWidths(wb, sheet, cols = cols, widths = widths, ...)
}

  # freeze panel
freeze_pane <- function(wb, sheet, ...){
  openxlsx::freezePane(wb, sheet, ...)
}

  # examples
  # path <- "hoge.xlsx"
  # wb <- openxlsx::loadWorkbook(path)
  # 
  # walk_wb(wb, add_filter)
  # walk_wb(wb, set_col_width, widths = 3)
  # walk_wb(wb, set_col_width, widths = "auto") # not woking
  # walk_wb(wb, freeze_pane, firstRow = TRUE, firstCol = TRUE) # not working
  # 
  # openxlsx::saveWorkbook(wb, path, overwrite = TRUE)
  # shell.exec(path)
