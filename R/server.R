function(input, output, session){

  # pivotea
  fileServer("pivotea", wbs = workbooks())
  pivoteaServer("pivotea")

  # highlight
  workbooks <- reactive({ highlightServer("highlight") })
  fileServer("highlight", wbs = workbooks())

}
