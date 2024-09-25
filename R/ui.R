navbarPage("convex: for Convenient Excel",

  # # # highlight # # #
  tabPanel("highlight",
    sidebarLayout(
      fileUI("highlight"),
      highlightUI("highlight"),
    )
  ),

  # # # pivotea # # #
  tabPanel("pivotea",
    sidebarLayout(
      fileUI("pivotea"),
      highlightUI("pivotea"),
      #       pivoteaUI("pivotea"),
    )
  ),

)
