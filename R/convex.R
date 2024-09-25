  # map for wb
walk_wb <- function(wb, fun, ...){
  openxlsx::sheets(wb) |>       # sheet names
    purrr::walk(fun, wb = wb, ...) # fun(wb = wb, sheet = sheet)
}

  # wrapper for freezePane()
freeze_pane <- function(wb, sheet, ...){
  openxlsx::freezePane(wb, sheet, ...)
  # openxlsx::freezePane(wb, sheet, firstRow = TRUE, firstCol = TRUE)
}

  # wrapper for addFilter()
add_filter <- function(wb, sheet, rows = 1){
  cols <- cols_wb_sheet(wb, sheet)
  openxlsx::addFilter(wb, sheet, rows = rows, cols = cols)
}

  # wrapper for setColWidths()
set_col_width <- function(wb, sheet, width = "auto", ...){
  cols <- cols_wb_sheet(wb, sheet)
  openxlsx::setColWidths(wb, sheet, cols = cols, width = width, ...)
}

  # ncol
cols_wb_sheet <- function(wb, sheet){
  cols <- 
    openxlsx::readWorkbook(wb, sheet) |>
    ncol() |>
    seq()
  return(cols)
}

  # nrow
rows_wb_sheet <- function(wb, sheet){
  rows <- 
    openxlsx::readWorkbook(wb, sheet) |> 
    nrow() |> 
    `+`(e1 = _, e2 = 1) |> # add 1 for colnames row
    seq()
  return(rows)
}

  # wrapper for conditionalFormatting()
set_bg_color <- function(wb, sheet, color = "#FFFF00", strings){
  bg_color <- openxlsx::createStyle(bgFill = color)
  for(str in strings){
    openxlsx::conditionalFormatting(wb, sheet, 
      rows = rows_wb_sheet(wb, sheet), 
      cols = cols_wb_sheet(wb, sheet), 
      rule = str, style = bg_color, type = "contains")
  }
}
