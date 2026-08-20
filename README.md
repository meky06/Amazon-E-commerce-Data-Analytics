# Amazon-E-commerce-Data-Analytics
Demo Amazon E-commerce analytics using project using SQL, Python, Machine Learning, and Power BI to analyze sales, customers, products, and delivery performance.
Project Overview

This project analyzes the Brazilian E-Commerce Public Dataset by Olist to uncover insights into sales performance, customer behavior, product performance, and delivery operations.

The project combines SQL, Python, Machine Learning, and Power BI to transform raw e-commerce data into an interactive insightful dashboard.

Business Objectives:
Analyze revenue and sales trends over time
Identify top-performing product categories
Understand customer purchasing behavior
Analyze delivery performance and late deliveries
Identify customer repeat-purchase patterns
Demonstrate how predictive analytics can support business decisions

Tools:
SQL Server / SSMS — Data validation and new table generation using aggregate functions for
Machine Learning predictions.
Python — Data preprocessing and machine learning modeling.
Power BI — Data modeling, DAX and interactive visualization
GitHub — Project documentation.

Dashboard:

Overview

Provides a high-level view of the e-commerce business, including revenue, orders, customers and delivery performance.

Trend Analysis:

Analyzes how sales and order activity change over time for the purpose of detecting seasonality.

Product Analysis

Explores best selling and most ordered product categories.

Customer Analysis

Examines customer purchasing behavior to detect patterns in their activities.

Predictions

Machine Learning answers the question of "Would 2017 customers make another purchases in 2018?".

Machine Learning:

A machine-learning model was developed to predict repeat purchase behavior using customer-level features.

The modeling workflow included:

-Feature engineering
-Data preprocessing
-Train/test splitting
-Model training
-Model evaluation
-Generation of prediction probabilities
-Integration of predictions into Power BI

Because the dataset is highly imbalanced, PR-AUC and class-level metrics were considered alongside accuracy when evaluating the model.
