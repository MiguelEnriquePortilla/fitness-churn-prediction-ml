# 📋 Datasets Directory

## Overview
Analysis-ready datasets optimized for machine learning, business intelligence, and dashboard creation. These carefully curated CSV files provide clean, structured data with enhanced features for immediate use in analytics workflows.

## 📊 Dataset Catalog

### **1. Primary Dataset** (`gym_churn_processed.csv`)
**Purpose**: Main analysis dataset with enhanced features for ML and visualization
- **Records**: 4,000 customer profiles
- **Features**: 19 variables (original + derived)
- **Quality**: 100% complete data, no missing values
- **Enhancement**: Added customer tiers, activity levels, risk scores

#### Key Features:
- **Original Variables**: Demographics, behavior, contract details, churn status
- **Derived Features**: 
  - `customer_value_tier`: Basic, Standard, Premium, VIP (based on spending)
  - `activity_level`: Low, Moderate, High, Super Active (based on frequency)
  - `tenure_category`: New, Developing, Established, Veteran (based on lifetime)
  - `risk_score`: Critical, High, Medium, Low (ML-derived risk assessment)

#### Business Applications:
- Predictive modeling and ML training
- Customer behavior analysis
- Retention strategy development
- Dashboard and visualization creation

---

### **2. Customer Segments** (`customer_segments.csv`)
**Purpose**: Strategic segmentation summary for business planning and resource allocation
- **Records**: 5 customer archetypes
- **Features**: 20 business metrics per segment
- **Focus**: Executive decision-making and strategy development

#### Archetype Profiles:
1. **🤝 Social Connectors** (15.8% | 24.6% churn)
   - Referral-driven, socially validated, commitment-flexible
   - Strategy: Leverage networks, migrate to longer commitments

2. **⚡ Active Independents** (22.2% | 9.0% churn)
   - Self-motivated, high-frequency, individual-focused
   - Strategy: Performance recognition, personalized challenges

3. **🏆 Premium Loyalists** (21.6% | 2.2% churn)
   - High-value, long-term, excellent engagement
   - Strategy: VIP experience, brand advocacy programs

4. **🚨 Flight Risks** (30.7% | 57.3% churn)
   - Youngest, newest, least engaged, minimal commitment
   - Strategy: Intensive retention, emergency re-engagement

5. **🎲 Decision Pending** (9.7% | 26.7% churn)
   - Balanced characteristics, unclear motivations
   - Strategy: Journey mapping, motivation discovery

#### Business Metrics Include:
- Segment size and portfolio percentage
- Churn rates and risk levels
- Revenue contribution and potential loss
- Demographic and behavioral characteristics
- Strategic priorities and focus areas

---

### **3. Feature Importance** (`feature_importance_rankings.csv`)
**Purpose**: ML model interpretability and business insight prioritization
- **Records**: 13 feature analyses
- **Features**: Importance scores, business interpretations, actionability metrics
- **Models**: Logistic Regression and Random Forest insights

#### Key Insights:
1. **🏃‍♂️ Current Activity** (30.2% importance)
   - Strongest predictor: -98.5% churn risk per additional visit
   - High actionability: Direct intervention opportunity

2. **⏰ Customer Lifetime** (25.1% importance)
   - Tenure loyalty: -97.6% churn risk per additional month
   - Medium actionability: Onboarding and early engagement focus

3. **💰 Additional Spending** (18.7% importance)
   - Economic engagement: -44.4% churn risk correlation
   - High actionability: Upselling and value programs

4. **📋 Contract Period** (12.3% importance)
   - Commitment factor: -46.7% churn risk for longer terms
   - High actionability: Contract migration strategies

5. **👥 Age Demographics** (8.9% importance)
   - Maturity factor: -70.1% churn risk per year
   - Low actionability: Targeting and messaging adaptation

#### Actionability Framework:
- **High**: Direct intervention possible (activity, spending, contracts)
- **Medium**: Strategic influence available (tenure, social engagement)
- **Low**: Targeting and messaging optimization (demographics, location)

## 🔧 Data Usage Instructions

### **Loading Data in Python**
```python
import pandas as pd

# Load primary dataset
df_main = pd.read_csv('datasets/gym_churn_processed.csv')

# Load customer segments
df_segments = pd.read_csv('datasets/customer_segments.csv')

# Load feature importance
df_features = pd.read_csv('datasets/feature_importance_rankings.csv')
```

### **Dashboard Integration**
```python
# Tableau/Power BI ready format
# All datasets optimized for direct import
# Consistent naming conventions
# Pre-calculated metrics for visualization
```

### **ML Pipeline Ready**
```python
# Prepared features for immediate modeling
X = df_main.drop(['customer_id', 'Churn'], axis=1)
y = df_main['Churn']

# Enhanced features already encoded
# Risk scores pre-calculated
# Categorical variables properly formatted
```

## 📈 Data Quality Specifications

### **Completeness**
- ✅ **100% Complete**: No missing values across all datasets
- ✅ **Consistent Types**: Proper data type formatting
- ✅ **Validated Ranges**: All values within expected business ranges
- ✅ **Referential Integrity**: Consistent customer IDs and segment mappings

### **Enhancement Standards**
- **Derived Features**: Business-meaningful categorizations
- **Risk Scoring**: ML-validated probability assessments
- **Segmentation**: Statistically validated clustering results
- **Interpretability**: Human-readable category labels

### **Business Alignment**
- **Executive Metrics**: KPIs aligned with business objectives
- **Operational Metrics**: Actionable insights for team implementation
- **Strategic Metrics**: Long-term planning and investment guidance
- **Performance Metrics**: Success measurement and optimization tracking

## 🎯 Business Applications by Dataset

### **Executive Decision Making**
- **Primary Dataset**: Detailed customer analysis and trend identification
- **Segments Dataset**: Portfolio optimization and resource allocation
- **Features Dataset**: Investment prioritization and capability building

### **Operational Implementation**
- **Primary Dataset**: Individual customer risk assessment and intervention
- **Segments Dataset**: Team training and program customization
- **Features Dataset**: Process optimization and monitoring focus areas

### **Strategic Planning**
- **Primary Dataset**: Market analysis and competitive positioning
- **Segments Dataset**: Product development and service enhancement
- **Features Dataset**: Technology investment and system requirements

## 🔄 Data Maintenance

### **Update Frequency**
- **Primary Dataset**: Monthly refresh with new customer data
- **Segments Dataset**: Quarterly review and archetype validation
- **Features Dataset**: Model retraining and importance recalculation

### **Version Control**
- Timestamped datasets for historical analysis
- Change documentation for business continuity
- Backup procedures for data integrity
- Access controls for data security

### **Quality Monitoring**
- Automated data validation checks
- Business rule compliance verification
- Outlier detection and investigation
- Consistency monitoring across datasets

## 🚀 Advanced Analytics Ready

### **Machine Learning Applications**
- **Classification**: Churn prediction, risk scoring, customer categorization
- **Clustering**: Market segmentation, behavior analysis, product personalization
- **Regression**: LTV prediction, spending forecasting, engagement modeling
- **Time Series**: Trend analysis, seasonal patterns, retention curves

### **Business Intelligence Integration**
- **Real-time Dashboards**: Executive KPIs and operational metrics
- **Automated Reporting**: Weekly/monthly business performance
- **Predictive Analytics**: Forward-looking business insights
- **Comparative Analysis**: Segment performance and competitive benchmarking

### **Research and Development**
- **A/B Testing**: Program effectiveness measurement
- **Cohort Analysis**: Customer journey optimization
- **Market Research**: Industry benchmarking and best practices
- **Innovation Projects**: New service development and testing

## 📚 Supporting Documentation

### **Data Sources**
- Original customer database extracts
- CRM system integration data
- Payment and billing history
- Facility usage tracking systems

### **Processing Pipeline**
- Data cleaning and validation procedures
- Feature engineering methodologies
- Quality assurance checkpoints
- Business rule implementation

### **Validation Results**
- Statistical significance testing
- Business logic verification
- Cross-validation performance metrics
- Expert review and approval

---

**📊 These datasets provide the foundation for data-driven decision making, enabling Model Fitness to transform customer insights into competitive advantage through scientific precision and business intelligence.**
