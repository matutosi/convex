## 
  # map for Workbook
walk_wb <- function(wb, fun, ...){
  openxlsx::sheets(wb) |>
    purrr::walk(fun, wb = wb, ...) # apply function
}

## borders

new_categ_rows <- function(df, col_name, include_end = FALSE){
  old_categ <- df[[col_name]] != dplyr::lag(df[[col_name]])
  old_categ <- c(1, which(old_categ)) # 1: title
  if(include_end){
    old_categ <- c(old_categ, nrow(df) + 1) # nrow(df)+1: last row
  }
  new_categ <- old_categ + 1 # +1 for title
  return(new_categ)
}

new_categ_cols <- function(df, sep = "_", include_end = FALSE, layer = 1){
   categ <- 
    colnames(df) |>
    stringr::str_split(pattern = sep) |>
    purrr::map_chr(`[`, layer)
  new_categ <- categ != dplyr::lag(categ)
  new_categ <- which(new_categ)
  if(include_end){
    new_categ <- c(new_categ, ncol(df) + 1) # ncol(df)+1: last row
  }
  return(new_categ)
}

add_row_borders <- function(wb, sheet = 1, ncol = 3, border_sty = c("thick", "double", "thin", "dotted")){
  df <- openxlsx::readWorkbook(wb, sheet)
  cols <- colnames(df)[seq(ncol)]
  for(i in sort(seq(cols), decreasing = TRUE)){
    border_rows <- new_categ_rows(df, cols[i])
    sty <- openxlsx::createStyle(border = "top", borderStyle = border_sty[i])
    openxlsx::addStyle(wb, sheet, 
      style = sty, 
      rows = border_rows, 
      cols = seq(ncol(df)), 
      gridExpand = TRUE, 
      stack = TRUE)
  }
  wb
}

add_col_borders <- function(wb, sheet = 1, n_layer = 1, border_sty = c("thick", "double", "thin", "dotted")){
  df <- openxlsx::readWorkbook(wb, sheet)
  for(i in sort(seq(n_layer), decreasing = TRUE)){
    border_cols <- new_categ_cols(df, layer = i)
    sty <- openxlsx::createStyle(border = "left", borderStyle = border_sty[i])
    openxlsx::addStyle(wb, sheet, 
      style = sty, 
      rows = seq(nrow(df) + 1), # +1: title
      cols = border_cols, 
      gridExpand = TRUE, 
      stack = TRUE)
  }
  wb
}
