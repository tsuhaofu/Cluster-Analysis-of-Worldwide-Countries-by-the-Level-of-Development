This repository contains two computational statistics projects focusing on different aspects of data analysis and machine learning.

# Project 1: Cluster Analysis of Worldwide Countries by the Level of Development


This project performs a cluster analysis on worldwide countries using various socio-economic and health welfare variables to identify and segment countries most in need of assistance. Using a dataset of 167 countries, this project aims to group countries by their development status, offering insights for international humanitarian and public health organizations.

## Introduction
International humanitarian and public health organizations face challenges in efficiently allocating resources to countries most in need. Traditional classifications of countries into developed, developing, and underdeveloped categories are often insufficient to capture the nuanced realities of each country's situation. This project seeks to use socio-economic and health indicators to segment countries and better identify those in dire need of assistance.

## Data
The dataset includes the following socio-economic and health welfare variables for 167 countries:
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
- **Correlation Matrix**: Initial analysis showed significant correlations among variables such as per capita GDP, income, and life expectancy. Outliers were observed across all variables, particularly in per capita GDP and income, but were retained due to the small dataset size and their potential to represent distinct clusters.
- **Box Plots**: Identified outliers in each variable, with significant numbers in per capita GDP and income.
- **Histograms and Kernel Density Estimation Plots**: Most variables did not follow a normal distribution, impacting the computation of Euclidean distances, leading to the decision to standardize the dataset.

## Methods
The project utilized the following clustering methods:
1. **K-means**: Chose three clusters based on methods including the Elbow method and Average Silhouette Gap Statistics. K-means effectively segmented the data into three clusters representing developed, developing, and underdeveloped countries.
2. **Hierarchical Clustering**: Using methods like Complete, Average, Single, and Centroid, it was found that only Complete method maximized data segmentation. However, its results showed significant overlap and underperformance in high-dimensional data, leading to a decision to merge clusters, resulting in two main groups.
3. **Gaussian Mixture Model (GMM)**: To enhance comparison with other models, a mixture of three multivariate normal distributions was used. The results closely resembled those of K-means but with improved precision due to better initial convergence from using K-means for initialization.

## Results
- **K-means**: Identified three clusters with clear characteristics of developed, developing, and underdeveloped countries.
- **Hierarchical Clustering**: Two main clusters were identified, representing developed or rapidly developing countries and underdeveloped to lowly developing countries.
- **GMM**: Similar to K-means but with no overlap, indicating a more precise segmentation.

## Summary
Among the three clustering algorithms, K-means and GMM outperformed Hierarchical Clustering in segmenting the data. GMM provided the most precise segmentation, likely due to its initialization and convergence properties. Hierarchical Clustering was less suitable for high-dimensional data.

## Usage
To replicate this analysis, follow the instructions in the project folder, which includes the necessary code, dataset, and additional documentation.

## Dependencies
- Python 3.x
- Libraries: NumPy, pandas, scikit-learn, matplotlib, seaborn

## Contributors
- [Your Name](link to your GitHub profile)

## License
This project is licensed under the [MIT License](link to license file).
