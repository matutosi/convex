function(input, output, session){

  # highlight
  workbooks <- reactive({ highlightServer("highlight") })
  fileServer("highlight", wbs = workbooks())

  # highlight


}
