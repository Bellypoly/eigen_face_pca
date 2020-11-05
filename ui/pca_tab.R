tabText1 <- "In this homework, I would present Principal Component Analysis (PCA) as a scenario. 
            The data that I use in this project was provided in"
tabText2 <- "We try to find the directions where the data sample is the most variance, 
            the directions where the data is most spread out. 
            So, we try to find the best straight line that the data can project along it.

            To derive new variables from the original variables 
            that preserve most of the information given by their variances, 
            we will find a covariance matrix from the data sample to perform PCA. 
            Then we will get eigenvalues and eigenvector from these covariance matrix “S”."

tabText3 <- "The picture below represent eigenvector that we receive from data. 
            These eigenvector are called “Eigen Face” "

tabText4 <- "To do face recognition, I use a component to reconstruct to observe and compare with the original face data"

tabText5 <- "I improve the result by subtracting each image with the mean value of the data. "

tabText6 <- "We apply method in ⑤  to reconstruct face data back again."


pca_tab <- argonTabItem(
  tabName = "pca",
  argonRow(
    # Horizontal Tabset
    argonColumn(
      width = 12,
      argonH1("Principal Component Analysis : Scenario", display = 6),
      argonTabSet(
        id = "tab-1",
        card_wrapper = TRUE,
        horizontal = TRUE,
        circle = FALSE,
        size = "sm",
        width = 12,
        #iconList = lapply(X = 1:6, FUN = argonIcon, name = "atom"),
        argonTab(
          tabName = "① Raw Data",
          active = TRUE,
          tabText1,
          a("Kaggle", href=paste("https://www.kaggle.com/c/facial-keypoints-detection/data"), target="_blank"),
          "which consists of 7049 images for training and 1783 images for testing. I pick the first 100 pictures to do PCA.",
          br(),
          "The pictures below represent the first 12 pictures in training data sample",
          br(),br(),
          imageOutput("og_img"),
        ),
        argonTab(
          tabName = "② Graph",
          active = FALSE,
          tabText2,
          br(),br(),
          "The eigenvectors represent the principal components of “S”. 
          The eigenvalues of “S” are used to find the proportion of 
          the total variance explained by the components.",
          br(),br(),
          "So, we use 2 graphs below to represent that “How many components 
          that can be used to explain a variance of the population?”",
          br(),br(),
          imageOutput("graph"),
          "From the graph, you would see that if we use 100 components, 
          we can use it to explain our data almost 100%"
        ),
        argonTab(
          tabName = "③ Eigen Faces",
          active = FALSE,
          tabText3,
          br(),br(),
          imageOutput("eigenface")
        ),
        argonTab(
          tabName = "④ Face recognition",
          active = FALSE,
          tabText4,
          br(),br(),
          imageOutput("recog"),
          br(),br(),
          "You would see that even I use PCA100, the face still not smooth enough. 
          So, I come up with the question that “Can we improve it?”"
        ),
        argonTab(
          tabName = "⑤ Tuning",
          active = FALSE,
          tabText5,
          br(),br(),
          imageOutput("tune")
        ),
        argonTab(
          tabName = "⑥ Reconstruct again",
          active = FALSE,
          tabText6,
          br(),br(),
          imageOutput("recon_after_tune")
        )
      )
    )
  )
)