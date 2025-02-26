function(input, output, session){

  # highlight
  wbs_highlight <- reactive({ highlightServer("highlight") })
  highlight_fileServer("highlight", wbs = wbs_highlight())

  # pivotea
  data_in <- pivotea_uploadServer("pivotea")
  wb_pivotea <- pivoteaServer("pivotea", data_in())
  pivotea_downloadServer("pivotea", wb_pivotea())

}
