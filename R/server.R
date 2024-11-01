function(input, output, session){

  # highlight
  wbs_highlight <- reactive({ highlightServer("highlight") })
  fileServer("highlight", wbs = wbs_highlight())

  # pivotea
  #   downloadを押さないと，colなどが表示されない
  #     -> reactive がうまくいっていない
  # pivotしたものがダウンロードできない

  #   wb_pivotea <- reactive({ pivoteaServer("pivotea") })
  #   fileServer("pivotea", wbs = wb_pivotea())


}
