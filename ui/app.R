library(shiny)
library(argonR)
library(argonDash)
library(magrittr)

# template
source("sidebar.R")
source("header.R")
source("footer.R")

# elements
source("aboutus_tab.R")
source("pca_tab.R")


# App
shiny::shinyApp(
  ui = argonDashPage(
    title = "HW II : The one-stop PCA Center",
    author = "Suwaphit Buabuthr",
    sidebar = sidebar,
    header = header,
    body = argonDashBody(
      argonTabItems(
        pca_tab,
        #dashboard_tab,
        aboutus_tab
      )
    ),
    footer = footer
  ),
  server = function(input, output) {
    output$distPlot <- renderPlot({
      hist(rnorm(input$obs))
    })
    
    output$plot <- renderPlot({
      dist <- switch(
        input$dist,
        norm = rnorm,
        unif = runif,
        lnorm = rlnorm,
        exp = rexp,
        rnorm
      )
      hist(dist(500))
    })
    
    
    output$og_img <- renderPlot({
      picture <- read.csv("../dataset/training.csv")
      
      # Pick 100 samples to do PCA
      data = picture[1:100,]
      pic.train <- as.character(data$Image)
      library(doParallel)
      registerDoParallel(cores=4)
      pic.train <- foreach(pic = pic.train, .combine=rbind) %dopar% {
        as.integer(unlist(strsplit(pic, " ")))
      }
      
      #show original image output
      options(repr.plot.width=6, repr.plot.height=2)
      par(mfrow=c(2,6),mar=c(0,0,0,0) )
      for(i in 1:12){
        im2 <- matrix(data=rev(pic.train[i,]), nrow=96, ncol=96)
        plot2 <- image(1:96, 1:96, im2, col=gray((0:255)/255),xaxt='n'
                       ,yaxt='n', ann=FALSE)
      }
      
      pic.train <<- pic.train
      x <<- t(t(pic.train))
    })
    
    output$graph <- renderPlot({
      print("tab2")
      
      # Find a covariance matrix
      #S <- cov(t(t(pic)))
      s <- crossprod(sweep(x, 2L, colMeans(x))) / (nrow(x) - 1L)
      Eigen <- eigen(s)
      eigenvalue <<- Eigen$values
      eigenvector <<- Eigen$vectors
      
      # Create Scree plot and Cumulative plot
      options(repr.plot.width=8, repr.plot.height=4)
      par(mfrow=c(1,2),mar=c(3,3,3,3) )
      per_var <- eigenvalue/sum(eigenvalue)*100
      cum_var <- cumsum(per_var)
      plot(per_var[1:150], xlab = "Component number",
           ylab = "Component variance", type = "l", main = "Scree graph")
      plot(cum_var[1:150], xlab = "Component number",
           ylab = "Component variance", type = "l", main = "cumulative graph")
    })
    
    output$eigenface <- renderPlot({
      print("tab3")
      
      # Show 100 eigen faces
      options(repr.plot.width=8, repr.plot.height=8)
      par(mfrow=c(5,10),mar=c(0,0,0,0) )
      for (i in 1:50) {
        t1 <- matrix(data=rev(t(eigenvector[,i])), nrow=96, ncol=96) 
        plot1 <- image(1:96, 1:96, t1, col=gray((0:255)/255),xaxt='n',yaxt='n', ann=FALSE)
      }
    })
    
    output$recog <- renderPlot({
      print("tab4")
      
      # Try to use first 20, 50, 100 component to reconstruct the face
      pca20 <- x%*%eigenvector[,1:20]
      pca50 <- x%*%eigenvector[,1:50]
      pca100 <- x%*%eigenvector[,1:100]
      
      # Show output
      options(repr.plot.width=8, repr.plot.height=6)
      par(mfrow=c(3,4),mar=c(2,2,2,2) )
      for (i in 1:1){
        t1 <- matrix(data=rev(pic.train[i,]), nrow=96, ncol=96)             
        plot1 <- image(1:96, 1:96, t1, col=gray((0:255)/255))
        title(main = "Original")
        pca20 <- matrix(data=rev(pca20[i,]%*%t(eigenvector[,1:20])), nrow=96, ncol=96)
        pcaplot1 <- image(1:96, 1:96, pca20, col=gray((0:255)/255))
        title(main = "pca20")
        pca50 <- matrix(data=rev(pca50[i,]%*%t(eigenvector[,1:50])), nrow=96, ncol=96)
        pcaplot2 <- image(1:96, 1:96, pca50, col=gray((0:255)/255))
        title(main = "pca50")
        pca100 <- matrix(data=rev(pca100[i,]%*%t(eigenvector[,1:100])), nrow=96, ncol=96)
        pcaplot4 <- image(1:96, 1:96, pca100, col=gray((0:255)/255))
        title(main = "pca100")
      }
    })
    
    output$tune <- renderPlot({
      print("tab5")
      
      # Find an average value of face data
      options(repr.plot.width=2, repr.plot.height=2)
      par(mfrow=c(1,1),mar=c(2,2,2,2) )
      avg_face <<- colMeans(pic.train)
      t1 <- matrix(data=rev(avg_face), nrow=96, ncol=96) 
      plot1 <- image(1:96, 1:96, t1, col=gray((0:255)/255))
      title(main = "Average value of Face")
    })
    
    output$recon_after_tune <- renderPlot({
      print("tab6")
      
      # Tuning output by subtract with mean
      sub_face <- apply(pic.train,1,"-",avg_face)
      #s2 <- cov(t(sub_face))
      s2 <- crossprod(sweep(t(sub_face), 2L, colMeans(t(sub_face)))) / (nrow(t(sub_face)) - 1L)
      dim(s2)
      s_Eigen <- eigen(s2)
      s_eigenvalue <- s_Eigen$values
      s_eigenvector <- s_Eigen$vectors
      s_pca20 <- t(sub_face)%*%s_eigenvector[,1:20]
      s_pca50 <- t(sub_face)%*%s_eigenvector[,1:50]
      s_pca100 <- t(sub_face)%*%s_eigenvector[,1:100]
      
      # Show output
      options(repr.plot.width=8, repr.plot.height=8)
      par(mfrow=c(3,4),mar=c(2,2,2,2) )
      for (i in 1:1){
        # To reconstruct, don't forget to add mean value that subtracting in previous step
        t1 <- matrix(data=rev(t(sub_face[,i])+t(avg_face)), nrow=96, ncol=96)             
        plot1 <- image(1:96, 1:96, t1, col=gray((0:255)/255))
        title(main = "Original")
        
        s_pca20 <- matrix(data=rev((s_pca20[i,]%*%t(s_eigenvector[,1:20]))+t(avg_face)), nrow=96, ncol=96)
        pcaplot1 <- image(1:96, 1:96, s_pca20, col=gray((0:255)/255))
        title(main = "PCA20")
        s_pca50 <- matrix(data=rev((s_pca50[i,]%*%t(s_eigenvector[,1:50]))+t(avg_face)), nrow=96, ncol=96)
        pcaplot2 <- image(1:96, 1:96, s_pca50, col=gray((0:255)/255))
        title(main = "PCA50")
        s_pca100 <- matrix(data=rev((s_pca100[i,]%*%t(s_eigenvector[,1:100]))+t(avg_face)), nrow=96, ncol=96)
        pcaplot4 <- image(1:96, 1:96, s_pca100, col=gray((0:255)/255))
        title(main = "PCA100")
      }
    })
  }
)