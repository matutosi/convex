navbarPage("convex: for Convenient Excel",

  # # # pivotea # # #
  tabPanel("pivotea",
    sidebarLayout(
      sidebarPanel(
        fileUI("pivotea", multiple = FALSE, use_example = TRUE),
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

  # # # highlight # # #
  tabPanel("highlight",
    sidebarLayout(
      sidebarPanel(
        fileUI("highlight", multiple = TRUE, use_example = FALSE),
      ),
      mainPanel(
        highlightUI("highlight"),
        reactable::reactableOutput(NS("highlight", "data")),
      )
    )
  ),

)
