# 📚 Data Dictionary: Fitness Industry Churn Prediction Dataset

## Overview
Comprehensive data dictionary for the Model Fitness customer churn prediction dataset. This document provides detailed specifications for all variables, business rules, data quality standards, and analytical applications.

**Dataset Scope**: 4,000 customer records with 19 features (14 original + 5 derived)  
**Quality Standard**: 100% complete data, validated business logic  
**Update Frequency**: Monthly with new customer data integration  

---

## 🏗️ Primary Dataset: `gym_churn_processed.csv`

### **Table Schema Overview**
| Category | Variables | Description |
|----------|-----------|-------------|
| **Identity** | customer_id | Unique customer identifier |
| **Demographics** | gender, Age | Customer demographic profile |
| **Geographic** | Near_Location | Proximity and convenience factors |
| **Acquisition** | Partner, Promo_friends, Phone | Customer acquisition and contact methods |
| **Contractual** | Contract_period, Month_to_end_contract | Agreement terms and timing |
| **Behavioral** | Group_visits, Lifetime, Avg_class_frequency_total, Avg_class_frequency_current_month | Engagement and activity patterns |
| **Economic** | Avg_additional_charges_total | Spending and value indicators |
| **Target** | Churn | Prediction objective variable |
| **Derived** | customer_value_tier, activity_level, tenure_category, risk_score | Enhanced features for analysis |

---

## 📊 Variable Specifications

### **Identity Variables**

#### `customer_id`
- **Type**: Integer (Primary Key)
- **Range**: 1 to 4,000
- **Format**: Sequential unique identifier
- **Business Rule**: One record per customer, no duplicates
- **Usage**: Data joining, individual customer tracking
- **Example**: 1, 2, 3, ..., 4000

---

### **Demographic Variables**

#### `gender`
- **Type**: Integer (Binary)
- **Values**: 
  - `0` = Female
  - `1` = Male
- **Distribution**: ~51% Male, ~49% Female
- **Business Rule**: Required field, no missing values
- **Usage**: Demographic analysis, marketing segmentation
- **Analytical Note**: Shows minimal correlation with churn (coefficient: 0.015)

#### `Age`
- **Type**: Integer
- **Range**: 18 to 41 years
- **Unit**: Years
- **Distribution**: 
  - Mean: 29.2 years
  - Std Dev: 3.3 years
  - 25th percentile: 27 years
  - 75th percentile: 31 years
- **Business Rule**: Must be ≥18 (legal membership requirement)
- **Usage**: Life stage analysis, targeted programming
- **Churn Impact**: Younger customers (25-30) show higher churn rates
- **Example**: 25, 29, 33, 28

---

### **Geographic Variables**

#### `Near_Location`
- **Type**: Integer (Binary)
- **Values**:
  - `0` = Lives/works far from gym
  - `1` = Lives/works near gym location
- **Distribution**: 85% live/work near location
- **Business Rule**: Based on address proximity analysis
- **Usage**: Location strategy, facility expansion planning
- **Churn Impact**: 10.5pp lower churn for nearby customers
- **Example**: 1 (near), 0 (far)

---

### **Acquisition & Contact Variables**

#### `Partner`
- **Type**: Integer (Binary)
- **Values**:
  - `0` = Individual membership
  - `1` = Corporate partner membership (employer benefits)
- **Distribution**: 49% are corporate partner members
- **Business Rule**: Based on membership enrollment source
- **Usage**: B2B relationship management, retention strategies
- **Churn Impact**: 17.9pp lower churn for partner customers
- **Example**: 1 (corporate), 0 (individual)

#### `Promo_friends`
- **Type**: Integer (Binary)
- **Values**:
  - `0` = Direct/organic acquisition
  - `1` = Acquired through "bring a friend" referral program
- **Distribution**: 31% acquired through referral program
- **Business Rule**: Tracked through referral codes and promotional records
- **Usage**: Referral program effectiveness, social network analysis
- **Churn Impact**: 17.0pp lower churn for referred customers
- **Example**: 1 (referral), 0 (direct)

#### `Phone`
- **Type**: Integer (Binary)
- **Values**:
  - `0` = No phone number on file
  - `1` = Phone number available for contact
- **Distribution**: 90% have phone contact information
- **Business Rule**: Customer service and emergency contact capability
- **Usage**: Communication strategy, customer service optimization
- **Churn Impact**: Minimal impact on retention
- **Example**: 1 (phone available), 0 (no phone)

---

### **Contractual Variables**

#### `Contract_period`
- **Type**: Integer
- **Range**: 1 to 12 months
- **Unit**: Months
- **Distribution**:
  - 1 month: 42% (most common - flexible)
  - 3 months: 15%
  - 6 months: 18%
  - 12 months: 25% (annual commitment)
- **Business Rule**: Standard contract terms offered
- **Usage**: Revenue forecasting, commitment analysis
- **Churn Impact**: Longer contracts show dramatically lower churn
- **Example**: 1, 3, 6, 12

#### `Month_to_end_contract`
- **Type**: Float
- **Range**: 1.0 to 12.0 months
- **Unit**: Months remaining until contract expiration
- **Distribution**:
  - Mean: 4.3 months
  - Critical Period: <2 months (high churn risk)
- **Business Rule**: Calculated from contract end date
- **Usage**: Renewal timing, intervention scheduling
- **Churn Impact**: <2 months to renewal = high risk period
- **Example**: 1.5, 3.2, 6.8, 11.0

---

### **Behavioral Variables**

#### `Group_visits`
- **Type**: Integer (Binary)
- **Values**:
  - `0` = Individual workouts only
  - `1` = Participates in group classes
- **Distribution**: 41% participate in group classes
- **Business Rule**: Based on class attendance records
- **Usage**: Social engagement analysis, program optimization
- **Churn Impact**: 19.5pp lower churn for group participants
- **Example**: 1 (group classes), 0 (individual only)

#### `Lifetime`
- **Type**: Integer
- **Range**: 0 to 31 months
- **Unit**: Months since first gym visit
- **Distribution**:
  - Mean: 3.7 months
  - Critical Period: <3 months (high churn risk)
  - Veteran Status: >12 months (low churn risk)
- **Business Rule**: Calculated from first visit date to analysis date
- **Usage**: Customer lifecycle analysis, onboarding optimization
- **Churn Impact**: Each additional month reduces churn risk by 97.6%
- **Example**: 0, 2, 5, 12, 24

#### `Avg_class_frequency_total`
- **Type**: Float
- **Range**: 0.00 to 6.02 visits per week
- **Unit**: Average weekly visits (historical)
- **Distribution**:
  - Mean: 1.88 visits/week
  - High Activity: >2.5 visits/week
  - Low Activity: <1.0 visits/week
- **Business Rule**: Calculated across entire customer history
- **Usage**: Long-term engagement patterns, capacity planning
- **Churn Impact**: Contextual predictor (baseline behavior)
- **Example**: 0.5, 1.2, 2.1, 3.4

#### `Avg_class_frequency_current_month`
- **Type**: Float
- **Range**: 0.00 to 6.15 visits per week
- **Unit**: Average weekly visits (current month)
- **Distribution**:
  - Mean: 1.77 visits/week
  - Critical Threshold: <1.0 visits/week (high churn risk)
  - Optimal Range: 2.0-3.0 visits/week
- **Business Rule**: Calculated from most recent 30-day period
- **Usage**: Early warning system, immediate intervention triggers
- **Churn Impact**: Strongest predictor (-98.5% churn risk per additional visit)
- **Example**: 0.0, 0.8, 2.1, 3.5

---

### **Economic Variables**

#### `Avg_additional_charges_total`
- **Type**: Float
- **Range**: $0.15 to $552.59
- **Unit**: US Dollars per month
- **Distribution**:
  - Mean: $146.94/month
  - 25th percentile: $68.87
  - 75th percentile: $210.95
  - High Value: >$200/month
- **Business Rule**: Additional services beyond base membership
- **Components**: Personal training, nutrition coaching, premium classes, equipment rental
- **Usage**: Revenue optimization, customer value analysis
- **Churn Impact**: Higher spending correlates with 44.4% lower churn risk
- **Example**: 45.50, 128.75, 234.80, 445.20

---

### **Target Variable**

#### `Churn`
- **Type**: Integer (Binary)
- **Values**:
  - `0` = Customer retained (active membership)
  - `1` = Customer churned (canceled or expired membership)
- **Distribution**: 26.5% churn rate (1,061 of 4,000 customers)
- **Business Rule**: Based on membership status at analysis cutoff date
- **Definition**: No gym visits for 30+ consecutive days OR formal cancellation
- **Usage**: Model training target, business performance KPI
- **Business Impact**: $141,860/month revenue at risk from churned customers
- **Example**: 0 (retained), 1 (churned)

---

## 🎯 Derived Features (Enhanced Analysis)

### **Customer Value Segmentation**

#### `customer_value_tier`
- **Type**: Categorical (4 levels)
- **Values**:
  - `Basic`: $0-100/month additional spending
  - `Standard`: $100-200/month additional spending
  - `Premium`: $200-300/month additional spending
  - `VIP`: >$300/month additional spending
- **Business Rule**: Based on `Avg_additional_charges_total` quartile analysis
- **Distribution**: 
  - Basic: 35% of customers
  - Standard: 40% of customers
  - Premium: 20% of customers
  - VIP: 5% of customers
- **Usage**: Pricing strategy, service tier optimization, targeted marketing
- **Churn Correlation**: Higher tiers show progressively lower churn rates

#### `activity_level`
- **Type**: Categorical (4 levels)
- **Values**:
  - `Low`: <1.0 visits/week
  - `Moderate`: 1.0-2.0 visits/week
  - `High`: 2.0-3.0 visits/week
  - `Super Active`: >3.0 visits/week
- **Business Rule**: Based on `Avg_class_frequency_current_month` distribution
- **Distribution**:
  - Low: 28% (high churn risk)
  - Moderate: 45% (moderate risk)
  - High: 22% (low risk)
  - Super Active: 5% (minimal risk)
- **Usage**: Engagement optimization, intervention targeting, capacity management
- **Churn Correlation**: Strong inverse relationship with activity level

#### `tenure_category`
- **Type**: Categorical (4 levels)
- **Values**:
  - `New (0-3m)`: 0-3 months lifetime
  - `Developing (3-6m)`: 3-6 months lifetime
  - `Established (6-12m)`: 6-12 months lifetime
  - `Veteran (12m+)`: >12 months lifetime
- **Business Rule**: Based on `Lifetime` natural breakpoints and business cycles
- **Distribution**:
  - New: 55% (highest risk period)
  - Developing: 28% (stabilization period)
  - Established: 12% (loyalty building)
  - Veteran: 5% (highly loyal)
- **Usage**: Lifecycle marketing, onboarding optimization, loyalty programs
- **Churn Correlation**: Dramatic risk reduction with tenure progression

#### `risk_score`
- **Type**: Categorical (4 levels)
- **Values**:
  - `Critical`: >70% predicted churn probability
  - `High`: 50-70% predicted churn probability
  - `Medium`: 30-50% predicted churn probability
  - `Low`: <30% predicted churn probability
- **Business Rule**: Based on ML model probability outputs
- **Calculation**: Logistic regression probability scores converted to risk categories
- **Distribution**:
  - Critical: 18% (immediate intervention required)
  - High: 22% (proactive outreach needed)
  - Medium: 35% (monitoring and engagement)
  - Low: 25% (standard service)
- **Usage**: Intervention prioritization, resource allocation, automated alerts
- **Accuracy**: 91.9% model accuracy in risk category prediction

---

## 📐 Business Rules & Data Quality

### **Data Validation Rules**
```sql
-- Age validation
Age BETWEEN 18 AND 100

-- Contract period validation  
Contract_period IN (1, 3, 6, 12)

-- Frequency logical validation
Avg_class_frequency_current_month >= 0 AND <= 7

-- Spending validation
Avg_additional_charges_total >= 0

-- Binary field validation
gender IN (0, 1)
Near_Location IN (0, 1)
Partner IN (0, 1)
Promo_friends IN (0, 1)
Phone IN (0, 1)
Group_visits IN (0, 1)
Churn IN (0, 1)

-- Tenure validation
Lifetime >= 0 AND Month_to_end_contract > 0
```

### **Business Logic Constraints**
- **Tenure Logic**: `Lifetime` cannot exceed 36 months (business operation period)
- **Contract Logic**: `Month_to_end_contract` cannot exceed `Contract_period`
- **Activity Logic**: `Avg_class_frequency_current_month` should be ≤ `Avg_class_frequency_total + 2` (reasonable variation)
- **Value Logic**: Customers with `customer_value_tier = VIP` should have `Avg_additional_charges_total > 300`

### **Data Quality Standards**
- **Completeness**: 100% - No missing values allowed
- **Accuracy**: ±5% variance acceptable for calculated fields
- **Consistency**: Cross-field validation rules enforced
- **Timeliness**: Monthly updates with 48-hour processing window
- **Validity**: All values within acceptable business ranges

---

## 🔄 Calculated Fields & Formulas

### **Customer Value Tier Assignment**
```python
def assign_value_tier(spending):
    if spending < 100:
        return 'Basic'
    elif spending < 200:
        return 'Standard'
    elif spending < 300:
        return 'Premium'
    else:
        return 'VIP'
```

### **Activity Level Classification**
```python
def classify_activity(frequency):
    if frequency < 1.0:
        return 'Low'
    elif frequency < 2.0:
        return 'Moderate'
    elif frequency < 3.0:
        return 'High'
    else:
        return 'Super Active'
```

### **Risk Score Calculation**
```python
def calculate_risk_score(ml_probability):
    if ml_probability > 0.70:
        return 'Critical'
    elif ml_probability > 0.50:
        return 'High'
    elif ml_probability > 0.30:
        return 'Medium'
    else:
        return 'Low'
```

---

## 📊 Usage Guidelines by Analysis Type

### **Predictive Modeling**
- **Features**: All original variables except `customer_id` and `Churn`
- **Target**: `Churn` (binary classification)
- **Preprocessing**: Standardization recommended for distance-based algorithms
- **Validation**: Stratified train-test split to maintain churn proportion

### **Customer Segmentation**
- **Features**: All variables except `Churn` and `customer_id`
- **Method**: K-means clustering with standardized features
- **Interpretation**: Use derived features for business segment naming
- **Validation**: Silhouette analysis and business logic review

### **Business Intelligence**
- **Dimensions**: `customer_value_tier`, `activity_level`, `tenure_category`, `risk_score`
- **Measures**: `Avg_additional_charges_total`, churn rates, customer counts
- **Time Series**: `Lifetime`, `Month_to_end_contract` for temporal analysis
- **Filtering**: Use demographic and acquisition variables for drill-down

### **Dashboard Development**
- **Key Metrics**: Churn rate, revenue per customer, activity levels
- **Segmentation**: By value tier, risk score, tenure category
- **Alerts**: Critical risk customers, contract renewals, low activity
- **Trends**: Monthly progression of key indicators

---

## 🔍 Data Lineage & Sources

### **Source Systems**
- **Customer Management System**: Demographics, contracts, contact information
- **Access Control System**: Visit frequency and timing data
- **Payment Processing**: Additional charges and spending patterns
- **Class Booking System**: Group visit participation
- **Customer Service**: Churn status and cancellation data

### **Data Processing Pipeline**
1. **Extraction**: Daily batch extraction from source systems
2. **Transformation**: Data cleaning, validation, and feature engineering
3. **Quality Assurance**: Automated validation rules and business logic checks
4. **Loading**: Integration into analytical dataset with versioning
5. **Documentation**: Automated data lineage and impact analysis

### **Update Schedule**
- **Frequency**: Monthly full refresh
- **Incremental**: Weekly updates for high-priority fields
- **Real-time**: Churn status and risk scores for operational use
- **Historical**: Maintained for trend analysis and model validation

---

**This data dictionary serves as the authoritative reference for all analytical work, ensuring consistent interpretation and application of customer data across business intelligence, machine learning, and strategic decision-making initiatives.**
