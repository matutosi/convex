navbarPage("convex: for Convenient Excel",

  # # # highlight # # #
  tabPanel("highlight",
    sidebarLayout(
      sidebarPanel(
        fileUI("highlight", multiple = TRUE),
      ),
      mainPanel(
        highlightUI("highlight"),
        reactable::reactableOutput(NS("highlight", "data")),
      )
    )
  ),

  # # # pivotea # # #
  tabPanel("pivotea",
    sidebarLayout(
      sidebarPanel(
        fileUI("pivotea", multiple = FALSE),
        pivoteaUI("pivotea"),
      ),
      mainPanel(
        tabsetPanel(type = "tabs",
          tabPanel("data",  reactable::reactableOutput(NS("pivotea", "data"))),
          tabPanel("pivot", tableOutput(NS("pivotea", "pivot"))),
        )
      )
    )
  ),

)
