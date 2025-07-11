# 🏃‍♂️ Fitness Churn Prediction & Retention Strategy

> **ML-powered customer retention analysis achieving 91.9% accuracy with actionable business insights for fitness industry transformation**

![Python](https://img.shields.io/badge/Python-3.8+-blue?style=flat-square&logo=python)
![Scikit-Learn](https://img.shields.io/badge/Scikit--Learn-ML-orange?style=flat-square&logo=scikit-learn)
![Pandas](https://img.shields.io/badge/Pandas-Data%20Analysis-green?style=flat-square&logo=pandas)
![Matplotlib](https://img.shields.io/badge/Matplotlib-Visualization-red?style=flat-square&logo=plotly)

## 🎯 Project Overview

Comprehensive machine learning analysis of **4,000 gym members** to predict customer churn and develop data-driven retention strategies for Model Fitness. This project transforms raw customer data into actionable business intelligence that directly impacts revenue and customer lifetime value.

### Key Discoveries:
- **🎯 91.9% Prediction Accuracy** - Industry-leading churn detection capability
- **🔍 5 Customer Archetypes** - From 2.2% to 57.3% churn rates (2,500% difference)
- **💰 $43 Average Spending Gap** - Clear economic indicators of loyalty
- **⚡ 98.5% Retention Power** - Current activity frequency as strongest predictor

## 🛠️ Tech Stack

| Technology | Purpose | Implementation |
|------------|---------|----------------|
| **Python 3.8+** | Core Analysis | Pandas, NumPy for data manipulation |
| **Scikit-Learn** | Machine Learning | Logistic Regression, Random Forest, K-Means |
| **Matplotlib/Seaborn** | Visualization | Statistical plots, business dashboards |
| **Jupyter Notebook** | Development | Interactive analysis and documentation |

## 📊 Dataset Overview

**Source:** Model Fitness customer database  
**Size:** 4,000 customers × 14 features  
**Quality:** 100% complete data (no missing values)  
**Target:** Binary churn prediction (26.5% base rate)

### Key Features Analyzed:
- **Demographic:** Age, gender, location proximity
- **Contractual:** Contract period, months to expiration  
- **Behavioral:** Class frequency (historical vs current), group participation
- **Economic:** Additional service spending, partnership status
- **Social:** Referral source, corporate partnerships

## 🔍 Analysis Framework

### **Phase 1: Exploratory Data Analysis**
- Quality assessment and statistical profiling
- Comparative analysis: churned vs retained customers  
- Feature correlation mapping and business insight extraction
- Visual storytelling with 15+ professional charts

### **Phase 2: Predictive Modeling**
- Train/test split with stratification (75%/25%)
- Model comparison: Logistic Regression vs Random Forest
- Hyperparameter optimization and cross-validation
- Feature importance analysis for business interpretation

### **Phase 3: Customer Segmentation**
- Hierarchical clustering analysis with dendrograms
- K-Means clustering (k=5) for customer archetypes
- Segment profiling with churn risk assessment
- PCA visualization for dimensional reduction

### **Phase 4: Business Strategy Development**
- ROI-focused retention recommendations
- Segment-specific intervention strategies
- Implementation roadmap with measurable KPIs

## 📈 Key Findings & Business Impact

### 🏆 **Model Performance Excellence**
```
✅ Logistic Regression (Champion Model):
   • Accuracy: 91.9%
   • Precision: 86.8%  
   • Recall: 81.9%
   • F1-Score: 84.3%
   • Overfitting: <2% (production-ready)
```

### 🎯 **The 5 Customer Archetypes**

| Archetype | Size | Churn Rate | Key Characteristics | Strategy |
|-----------|------|------------|-------------------|----------|
| **🏆 Premium Loyalists** | 21.6% | 2.2% | Long contracts, high engagement, social | VIP Program |
| **⚡ Active Independents** | 22.2% | 9.0% | High frequency, self-motivated | Merit Rewards |
| **🤝 Social Connectors** | 15.8% | 24.6% | 100% referrals, short contracts | Commitment Migration |
| **🎲 Decision Pending** | 9.7% | 26.7% | Balanced characteristics | Extreme Personalization |
| **🚨 Flight Risks** | 30.7% | 57.3% | Low engagement, minimal commitment | Emergency Intervention |

### 💰 **Economic Impact Quantified**
- **Current Loss:** 1,061 customers annually (26.5% churn)
- **Revenue at Risk:** ~$141,860/month in additional service spending
- **Opportunity:** Reducing churn to 20% = +260 customers retained annually
- **ROI Projection:** 5:1 return on targeted retention investments

## 📊 Visualizations & Dashboard

### Business Intelligence Charts:
- **Economic Factors:** Spending patterns vs commitment levels
- **Engagement Metrics:** Activity frequency and social participation  
- **Risk Mapping:** PCA-based customer positioning
- **Segment Profiling:** Demographic and behavioral heatmaps

*[Visual samples and interactive dashboard links to be added]*

## 🎯 Strategic Recommendations

### **🚨 Immediate Actions (0-30 days)**
1. **Early Warning System:** Automated alerts for <1 visit/week in first 60 days
2. **Emergency Intervention:** Rescue program for 1,227 Flight Risk customers
3. **Social Engagement:** Mandatory buddy system for new members

### **📈 Growth Initiatives (30-90 days)**  
1. **Contract Migration:** Incentivize short-term customers toward annual commitments
2. **Spending Acceleration:** Progressive rewards for additional service usage
3. **Channel Optimization:** Shift acquisition budget toward Partner+Referral channels

### **🏆 Strategic Transformation (90+ days)**
1. **Archetype-Specific Experiences:** 5 differentiated customer journeys
2. **Predictive Operations:** Real-time churn scoring integration
3. **Community Building:** Group class participation as retention driver

## 📁 Repository Structure

```
fitness-churn-prediction-ml/
├── 📖 README.md                          # Project overview and insights
├── 🗄️ sql_queries/                       # Data extraction and analysis queries
│   ├── customer_profiling.sql            # Customer segmentation analysis  
│   ├── behavioral_patterns.sql           # Activity and engagement metrics
│   ├── churn_risk_scoring.sql            # Risk assessment calculations
│   └── business_intelligence.sql         # KPI and performance metrics
├── 📊 analysis/                          # Python notebooks and scripts
│   ├── 01_exploratory_data_analysis.ipynb # Comprehensive EDA with visualizations
│   ├── 02_predictive_modeling.ipynb      # ML model development and evaluation
│   ├── 03_customer_segmentation.ipynb    # Clustering and archetype analysis
│   └── 04_business_recommendations.ipynb # Strategic insights and ROI analysis
├── 📈 visualizations/                    # Charts and dashboard assets
│   ├── generate_business_charts.py       # Automated chart generation
│   ├── eda_insights_dashboard.png        # Key findings visualization
│   ├── model_performance_metrics.png     # ML evaluation results
│   └── customer_archetype_profiles.png   # Segment analysis charts
├── 📋 datasets/                          # Analysis-ready data files
│   ├── gym_churn_processed.csv           # Clean dataset for modeling
│   ├── customer_segments.csv             # Clustered customer data
│   └── feature_importance_rankings.csv   # Model interpretability data
└── 📖 documentation/                     # Technical and business documentation
    ├── methodology.md                    # Analytical approach and assumptions
    ├── data_dictionary.md                # Variable definitions and business rules
    ├── model_evaluation.md               # Performance metrics and validation
    └── implementation_roadmap.md         # Business strategy execution plan
```

## 🚀 How to Reproduce This Analysis

### Prerequisites:
```bash
Python 3.8+
pandas >= 1.3.0
scikit-learn >= 1.0.0  
matplotlib >= 3.4.0
seaborn >= 0.11.0
jupyter >= 1.0.0
```

### Quick Start:
```bash
# Clone repository
git clone https://github.com/MiguelEnriquePortilla/fitness-churn-prediction-ml.git

# Install dependencies  
pip install -r requirements.txt

# Launch analysis
jupyter notebook analysis/01_exploratory_data_analysis.ipynb
```

### Analysis Workflow:
1. **Data Exploration:** Start with `01_exploratory_data_analysis.ipynb`
2. **Model Training:** Run `02_predictive_modeling.ipynb`  
3. **Segmentation:** Execute `03_customer_segmentation.ipynb`
4. **Business Strategy:** Review `04_business_recommendations.ipynb`

## 💡 Insights for Fitness Industry

This analysis reveals universal patterns applicable across fitness and subscription-based businesses:

### **The Engagement-Loyalty Equation:** 
Current activity frequency (not historical) predicts retention with 98.5% confidence - focus on recent behavior, not past performance.

### **Social Physics of Retention:**
Group class participation creates community bonds that reduce churn by 8 percentage points - fitness is fundamentally a social experience.

### **Economic Predictability:**
Customer spending patterns in the first 90 days predict lifetime behavior - early engagement investment pays exponential returns.

### **Generational Commitment Patterns:**
Younger customers (25-30) prefer flexibility while mature customers (30+) value stability - age-based contract strategies optimize retention.

## 🔗 Connect & Collaborate

**Miguel Enrique Portilla**  
📧 [miguelportilla.data@gmail.com](mailto:miguelportilla.data@gmail.com)  
💼 [LinkedIn](https://linkedin.com/in/miguel-enrique-portilla)  
🐙 [GitHub](https://github.com/MiguelEnriquePortilla)

---

### 📊 **Project Impact:** Transforming customer retention from reactive to predictive with data-driven precision

*This project demonstrates end-to-end machine learning pipeline development with direct business value creation - from raw data to strategic recommendations that drive measurable ROI.*
