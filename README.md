# Prediction of Coronary Heart Disease (CHD) using Logistic Regression

## 📖 Overview
Cardiovascular diseases (CVDs) are the leading cause of death globally. According to the World Health Organization (WHO), an estimated 17.9 million people died from CVDs in 2019, representing 32% of all global deaths.

This project utilizes the **Framingham Heart Study** dataset to predict the 10-year risk of future Coronary Heart Disease (CHD). By applying Logistic Regression, the analysis identifies key risk factors and builds a classification model to assist in early detection.

## 📊 About the Dataset
The dataset is publicly available from the Kaggle website and originates from an ongoing cardiovascular study on residents of the town of Framingham, Massachusetts.

* **Source:** Framingham Heart Study.
* **Attributes:** The dataset includes over 4,000 records with 15 attributes, covering demographic, behavioral, and medical risk factors.
* **Target Variable:** `TenYearCHD` (1 = Risk of CHD, 0 = No Risk).

Key features analyzed include:
* **Demographic:** Age, Gender.
* **Behavioral:** Current Smoker, Cigs Per Day.
* **Medical History:** BP Meds, Prevalent Stroke, Prevalent Hyp, Diabetes.
* **Clinical:** Tot Chol, Sys BP, Dia BP, BMI, Heart Rate, Glucose.

## ⚙️ Methodology

### 1. Data Preprocessing
To ensure model accuracy, the raw data underwent a cleaning process. Missing values (NA) were identified across several columns. Rows containing null values were removed to maintain data integrity, resulting in a refined dataset of 3,658 records.

### 2. Exploratory Data Analysis (EDA)
Comprehensive analysis was performed to understand the distribution of variables:
* **Histograms:** Used to visualize the frequency distribution of heart rates and other continuous variables.
* **Correlation Analysis:** A heatmap was generated to identify multicollinearity between features, ensuring the selected independent variables contributed uniquely to the model.

### 3. Predictive Modeling
**Logistic Regression** was selected for this classification problem due to the binary nature of the target variable. The dataset was split into training and testing sets (80/20 split) to evaluate performance on unseen data.

## 📈 Results
The Logistic Regression model demonstrated strong predictive capabilities:

* **Accuracy:** ~86% (0.858)
* **Confusion Matrix:**
    * True Negatives: 549
    * False Positives: 6
    * False Negatives: 86
    * True Positives: 8

The model successfully identifies the majority of negative cases (No CHD), providing a baseline for risk assessment.

---
*Dataset provided by the Framingham Heart Study.*
