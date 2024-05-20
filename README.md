# Cluster Analysis of Worldwide Countries by the Level of Development

This project performs a cluster analysis on worldwide countries using various socio-economic and health welfare variables to identify and segment countries most in need of assistance. Using a dataset of 167 countries, this project aims to group countries by their development status, offering insights for international humanitarian and public health organizations.

## Introduction
International humanitarian and public health organizations face challenges in efficiently allocating resources to countries most in need. Traditional classifications of countries into developed, developing, and underdeveloped categories are often insufficient to capture the nuanced realities of each country's situation. This project seeks to use socio-economic and health indicators to segment countries and better identify those in dire need of assistance.

## Data
The [Country Dataset](https://www.kaggle.com/datasets/santhraul/country-data) includes the following socio-economic and health welfare variables for 167 countries:
- `country`: Country name
- `child_mort`: Number of deaths per 1000 children under five
- `exports`: Percentage of exports of goods and services per capita GDP
- `health`: Total health expenditure as a percentage of per capita GDP
- `imports`: Percentage of imports of goods and services per capita GDP
- `Income`: Net income per capita
- `Inflation`: Annual GDP growth rate
- `life_expec`: Expected life span
- `total_fer`: Average number of children per woman
- `gdpp`: GDP per capita

## Exploratory Data Analysis
- **Correlation Matrix**: Initial analysis showed significant correlations among variables such as per capita GDP, income, and life expectancy. 
- **Box Plots**: Outliers were observed across all variables, particularly in per capita GDP and income, but were retained due to the small dataset size and their potential to represent distinct clusters.
- **Histograms and Kernel Density Estimation Plots**: Most variables did not follow a normal distribution, impacting the computation of Euclidean distances, leading to the decision to standardize the dataset.

## Methods
The project utilized the following clustering methods:
1. **K-means**: Chose three clusters based on methods including the Elbow method, Average Silhouette and Gap Statistics. K-means effectively segmented the data into three clusters representing developed, developing, and underdeveloped countries.
2. **Hierarchical Clustering**: Using methods like Complete, Average, Single, and Centroid, it was found that only Complete method maximized data segmentation. However, its results showed significant overlap and underperformance in high-dimensional data, leading to a decision to merge clusters. The two groups represent countries evolving from highly developing to developed, and from underdeveloped to lowly developing stages.
3. **Gaussian Mixture Model (GMM)**: To enhance comparison with other models, a mixture of three multivariate normal distributions was used. The results closely resembled those of K-means but with improved precision due to better initial convergence from using K-means for initialization.

## Results

The clusters identified distinct groups of countries:
- **Cluster 1 (Developed Countries)**: Characterized by low child mortality, high GDP per capita, and high life expectancy.
- **Cluster 2 (Developing Countries)**: Medium values for child mortality, GDP per capita, and life expectancy.
- **Cluster 3 (Underdeveloped Countries)**: High child mortality, low GDP per capita, and low life expectancy.


## Conclusion
The analysis revealed that socio-economic and health indicators like child mortality, per capita GDP, and life expectancy are key factors in distinguishing between different levels of country development. Both K-means and GMM effectively segmented the data into meaningful clusters, with GMM showing the highest precision due to its robust initialization and convergence properties. Hierarchical Clustering, though less effective in this high-dimensional setting, still provided valuable insights into broader groupings of countries. This study underscores the importance of using multiple clustering approaches to capture the complex dimensions of global development.


