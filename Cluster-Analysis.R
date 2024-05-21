library(ggplot2)
library(gplots)
library(pheatmap)
library(reshape2)
library(factoextra)
library(NbClust)
library(mixtools)
library(ClusterR)

Data = read.csv("Country-data.csv",  
                       header=T)     
head(Data)
summary(Data)
features = c('child_mort', 'exports', 'health', 'imports', 'income','inflation', 'life_expec', 'total_fer', 'gdpp')
##############################################################################################################
par(mfrow=c(3,3))
for(i in 1:9)
{
  boxplot(Data[,i+1], main = paste("Box plot of",features[i]), col = "dodgerblue")
 
}
##############################################################################################################
pairs(Data[,2:10], col = "dodgerblue")
cormat <- cor(Data[,2:10]) 
cormat = round(cormat,2)
melted_cormat <- melt(cormat)

ggplot(data = melted_cormat, aes(x=Var1, y=Var2, fill=value)) + 
  geom_tile()


get_lower_tri<-function(cormat){ 
  cormat[upper.tri(cormat)] <- NA
  return(cormat)
}
get_upper_tri <- function(cormat){ 
  cormat[lower.tri(cormat)]<- NA
  return(cormat)
}
reorder_cormat <- function(cormat){
  # Use correlation between variables as distance
  dd <- as.dist((1-cormat)/2)
  hc <- hclust(dd)
  cormat <-cormat[hc$order, hc$order]
}

cormat <- reorder_cormat(cormat)
upper_tri <- get_upper_tri(cormat)
# Melt the correlation matrix
melted_cormat <- melt(upper_tri, na.rm = TRUE)
# Create a ggheatmap
ggheatmap <- ggplot(melted_cormat, aes(Var2, Var1, fill = value))+
  geom_tile(color = "white")+
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", 
                       midpoint = 0, limit = c(-1,1), space = "Lab", 
                       name="Pearson\nCorrelation") +
  theme_minimal()+ # minimal theme
  theme(axis.text.x = element_text(angle = 45, vjust = 1, 
                                   size = 12, hjust = 1))+
  coord_fixed() + 
  geom_text(aes(Var2, Var1, label = value), color = "black", size = 4) +
  theme(
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    panel.grid.major = element_blank(),
    panel.border = element_blank(),
    panel.background = element_blank(),
    axis.ticks = element_blank(),
    legend.justification = c(1, 0),
    legend.position = c(0.6, 0.7),
    legend.direction = "horizontal")+
  guides(fill = guide_colorbar(barwidth = 7, barheight = 1,
                               title.position = "top", title.hjust = 0.5))
# Print the heatmap
print(ggheatmap)
##############################################################################################################
#Histogram amd KDE plot
par(mfrow=c(3,3))
for(i in 1:9)
{
  hist(Data[,i+1], main = paste("Histogram amd KDE plot of",features[i]), freq = F, breaks = 20)
  lines(density(Data[,i+1]), col = "red", lwd = 2)
}
##############################################################################################################
Data_scaled = scale(Data[,2:10]) 
head(Data_scaled)
##############################################################################################################
# Compute Hopkins statistic for Data
hopkins <- get_clust_tendency(Data_scaled, n=166, graph = T)
hopkins$hopkins_stat
hopkins$plot
##############################################################################################################
#K-Means
# Cluster numbers selection
par(mfrow=c(2,2))
fviz_nbclust(Data_scaled, kmeans, method = "wss") +
  geom_vline(xintercept = 3, linetype = 2) + # add line for better visualisation
  labs(subtitle = "Elbow method") # add subtitle

fviz_nbclust(Data_scaled, kmeans, method = "silhouette") +
  labs(subtitle = "Silhouette method")

fviz_nbclust(Data_scaled, kmeans, method = "gap_stat") +
  labs(subtitle = "Gap statistic method")

nbclust_out <- NbClust(
  data = Data_scaled,
  distance = "euclidean",
  min.nc = 2, # minimum number of clusters
  max.nc = 5, # maximum number of clusters
  method = "kmeans" # one of: "ward.D", "ward.D2", "single", "complete", "average", "mcquitty", "median", "centroid", "kmeans"
)

nbclust_plot <- data.frame(clusters = nbclust_out$Best.nc[1, ])
# select only indices which select between 2 and 5 clusters
nbclust_plot <- subset(nbclust_plot, clusters >= 2 && clusters <=5)

# create plot
ggplot(nbclust_plot) +
  aes(x = clusters) +
  geom_histogram(bins = 30L, fill = "#0c4c8a") +
  labs(x = "Number of clusters", y = "Frequency among all indices", title = "Optimal number of clusters") +
  theme_minimal()
############################################################################################################
#K-means(3)
km3 = kmeans(Data_scaled, 3, nstart = 25)
print(km3)
fviz_cluster(km3, data = Data_scaled)
clusterk = km3[["cluster"]]
Data = cbind(Data, clusterk)
Data$clusterk = as.factor(Data$clusterk)
cluster1k = Data[Data$clusterk == 1,]
cluster2k = Data[Data$clusterk == 2,]
cluster3k = Data[Data$clusterk == 3,]
#Visualizations

ggplot(Data, aes(x=child_mort, y=gdpp, color=clusterk)) +
  geom_point() +
  labs(title = "GDPP vs Child Mortality")

ggplot(Data, aes(x=inflation, y=gdpp, color=clusterk)) +
  geom_point() +
  labs(title = "GDPP vs Inflation")

ggplot(Data, aes(x=total_fer, y=gdpp, color=clusterk)) +
  geom_point() +
  labs(title = "GDPP vs Total Fertility")

ggplot(Data, aes(x=life_expec, y=gdpp, color=clusterk)) +
  geom_point() +
  labs(title = "GDPP vs Life expectancy")

ggplot(Data, aes(x=health, y=gdpp, color=clusterk)) +
  geom_point() +
  labs(title = "GDPP vs Health spending")
#############################################################################################################
#Hierachical clustering
# Dissimilarity matrix
par(mfrow=c(1,1))
d <- dist(Data_scaled, method = "euclidean")
single = hclust(d, method="single")
complete = hclust(d, method="complete")
average = hclust(d, method="average")
centroid = hclust(d, method="centroid")
plot(single, main = "Cluster Dendrogram (Single)", xlab = "Euclidean distance")
plot(complete, main = "Cluster Dendrogram (Complete)", xlab = "Euclidean distance")
plot(average, main = "Cluster Dendrogram (Average)", xlab = "Euclidean distance")
plot(centroid, main = "Cluster Dendrogram (Centroid)", xlab = "Euclidean distance")
#Cutting
clusterh <- cutree(tree = complete, k = 2)
clusterh.copy = clusterh
clusterh[clusterh == 1] = 2
clusterh[clusterh.copy ==2] = 1
Data = cbind(Data, clusterh)
Data$clusterh = as.factor(Data$clusterh)
#Visualization
fviz_cluster(list(data = Data_scaled, cluster = clusterh))
ggplot(Data, aes(x=child_mort, y=gdpp, color=clusterh)) +
  geom_point() +
  labs(title = "GDPP vs Child Mortality")

ggplot(Data, aes(x=inflation, y=gdpp, color=clusterh)) +
  geom_point() +
  labs(title = "GDPP vs Inflation")

ggplot(Data, aes(x=total_fer, y=gdpp, color=clusterh)) +
  geom_point() +
  labs(title = "GDPP vs Total Fertility")

ggplot(Data, aes(x=life_expec, y=gdpp, color=clusterh)) +
  geom_point() +
  labs(title = "GDPP vs Life expectancy")

ggplot(Data, aes(x=health, y=gdpp, color=clusterh)) +
  geom_point() +
  labs(title = "GDPP vs Health spending")
#####################################################################################################################
#GMM
GMM = GMM(Data_scaled, gaussian_comps = 3, km_iter = 100,
          em_iter = 200)
head(GMM$Log_likelihood)
clusterg = c()
for(i in 1:167)
{
  clusterg = append(clusterg, which.max(GMM[["Log_likelihood"]][i,]))
}
Data = cbind(Data, clusterg)
Data$clusterg = as.factor(Data$clusterg)
#Visualization
fviz_cluster(list(data = Data_scaled, cluster = clusterg))
ggplot(Data, aes(x=child_mort, y=gdpp, color=clusterg)) +
  geom_point() +
  labs(title = "GDPP vs Child Mortality")

ggplot(Data, aes(x=inflation, y=gdpp, color=clusterg)) +
  geom_point() +
  labs(title = "GDPP vs Inflation")

ggplot(Data, aes(x=total_fer, y=gdpp, color=clusterg)) +
  geom_point() +
  labs(title = "GDPP vs Total Fertility")

ggplot(Data, aes(x=life_expec, y=gdpp, color=clusterg)) +
  geom_point() +
  labs(title = "GDPP vs Life expectancy")

ggplot(Data, aes(x=health, y=gdpp, color=clusterg)) +
  geom_point() +
  labs(title = "GDPP vs Health spending")
#####################################################################################################################
