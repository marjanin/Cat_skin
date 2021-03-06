#K-means for leg movement data
rm(list = ls()); # clear workspace variables
cat("\014") # it means ctrl+L. clear window
library(rgl)

#load("simple_zmp_locations_exp_1.Rda")
load("simple_zmp_locations_exp_2.Rda")
#load("simple_zmp_locations_exp_3.Rda")
#load("simple_zmp_locations_exp_4.Rda")

#Change this line to analyse different files:
simple_zmp_locations.data <- simple_zmp_locations_exp_2.data

#View(simple_zmp_locations.data)

##################################################################################################

#Separate class and data
zmp.class <- simple_zmp_locations.data[,c("ZMP_location")] #Actual classes
simple_zmp_locations.data <- simple_zmp_locations.data[,c("LC_1","LC_2","LC_3","LC_4")]

head(simple_zmp_locations.data)
#View(simple_zmp_locations.data)

par(mfrow=c(2,3), mar=c(5,4,2,2))
plot(simple_zmp_locations.data[c("LC_1","LC_2")])# Plot to see how LC_1 and LC_2 data points have been distributed in clusters
plot(simple_zmp_locations.data[c("LC_3","LC_4")])
plot(simple_zmp_locations.data[c("LC_1","LC_3")])
plot(simple_zmp_locations.data[c("LC_1","LC_4")])
plot(simple_zmp_locations.data[c("LC_2","LC_3")])
plot(simple_zmp_locations.data[c("LC_2","LC_4")])

#Example visualize the data first on two dimension

#Create a function
normalize <- function(x){
  return ((x-min(x))/(max(x)-min(x)))
}

#Normalization
simple_zmp_locations.data$LC_1 <- normalize(simple_zmp_locations.data$LC_1)
simple_zmp_locations.data$LC_2 <- normalize(simple_zmp_locations.data$LC_2)
simple_zmp_locations.data$LC_3 <- normalize(simple_zmp_locations.data$LC_3)
simple_zmp_locations.data$LC_4 <- normalize(simple_zmp_locations.data$LC_4)
head(simple_zmp_locations.data) #normalize the values to be within (0-1)

summary(simple_zmp_locations.data)  #Summary of normalized simple_zmp_locations.data 

k <- 9 #No. clusters
result<- kmeans(simple_zmp_locations.data,k,iter.max=5,nstart=1)
result$size
mean(result$size)
sd(result$size)
str(result) #Compactly Display the Structure of an Arbitrary R Object
result$centers #4 dimensions
result$cluster

#Plot results, use scatter plot
# 4 attributes, 6 combinations
par(mfrow=c(2,3), mar=c(5,4,2,2))
plot(simple_zmp_locations.data[c("LC_1","LC_2")], col=result$cluster)# Plot to see how LC_1 and LC_2 data points have been distributed in clusters
plot(simple_zmp_locations.data[c("LC_3","LC_4")], col=result$cluster)
plot(simple_zmp_locations.data[c("LC_1","LC_3")], col=result$cluster)
plot(simple_zmp_locations.data[c("LC_1","LC_4")], col=result$cluster)
plot(simple_zmp_locations.data[c("LC_2","LC_3")], col=result$cluster)
plot(simple_zmp_locations.data[c("LC_2","LC_4")], col=result$cluster)


mycolors <- c('royalblue1', 'darkcyan', 'oldlace','brown1','cadetblue1','darkgoldenrod', 'coral1', 'darkgray', 'green1')
simple_zmp_locations.data$color <- mycolors[ as.numeric(result$cluster) ]

par(mar=c(0,0,0,0))
plot3d( 
  x=simple_zmp_locations.data$`LC_1`, y=simple_zmp_locations.data$`LC_2`, z=simple_zmp_locations.data$`LC_3`, 
  col = simple_zmp_locations.data$color, 
  type = 's', 
  radius = .05,
  xlab="LC_1", ylab="LC_2", zlab="LC_3")

#Determining how good the clustering performed (comparing predictions to actual labels)



# # Choose the number of clusters k= 1-5
# k.values <- 1:10
# #Do for loops for different k-values
# tot.withinss.k <- rep(0,length(k.values))
# count <-1
# for (val in k.values) {
#   result<-kmeans(simple_zmp_locations.data,val,iter.max=10,nstart=1)
# 
#   tot.withinss.k[count]<-result$tot.withinss #calculating the within sum of sqrs
#   count<-count+1
# }
# 
# graphics.off() # close all plots
# plot(k.values, tot.withinss.k,
#      type="b", pch = 19, frame = FALSE,
#      xlab="Number of clusters K",
#      ylab="Total within-clusters sum of squares")

#Accuracy (Correction)
