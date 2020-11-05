aboutus_tab <- argonTabItem(
  tabName = "aboutus",
  argonRow(
    argonCard(
      width = 12,
      src = NULL,
      icon = icon("cogs"),
      status = "success",
      shadow = TRUE,
      border_level = 2,
      hover_shadow = TRUE,
      title = "About Us",
      argonRow(
        argonColumn(
          width = 6,
          icon("users"),
          "STUDENT NAME : Suwaphit  Buabuthr",
          br(),
          icon("github"),
          "SOURCE CODE (1) :",
          a("assignment 2", href="https://github.com/Bellypoly/eigen_face_pca.git"),
          br(),
          icon("google-drive"),
          "SOURCE CODE (2) :",
          a("assignment 2", href="https://shorturl.at/cfCG4"),
          br(),
          icon("youtube"),
          "DEMO VIDEO :",
          a("Youtube", href="https://youtu.be/0TVNZ67xNdI")
        )
      )
    )
  )
)