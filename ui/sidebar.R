sidebar <- argonDashSidebar(
  vertical = TRUE,
  skin = "light",
  background = "white",
  size = "md",
  side = "left",
  id = "my_sidebar",
  argonSidebarHeader(title = "Menu"),
  argonSidebarMenu(
    argonSidebarItem(
      tabName = "pca",
      icon = argonIcon(name = "planet", color = "warning"),
      "PCA Scenario"
    ),
    #argonSidebarItem(
    #  tabName = "dashboard",
    #  icon = argonIcon(name = "tv-2", color = "blue"),
    #  "Dashboard"
    #),
    argonSidebarItem(
      tabName = "aboutus",
      icon = argonIcon(name = "circle-08", color = "green"),
      "About us"
    )
  )
)