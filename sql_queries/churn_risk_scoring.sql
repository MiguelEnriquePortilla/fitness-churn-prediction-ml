-- ================================================================
-- CHURN RISK SCORING: Advanced Predictive Analytics for Customer Retention
-- ================================================================
-- Purpose: Create comprehensive churn risk scores and identify 
-- high-value customers requiring immediate retention intervention

-- ================================================================
-- CHURN RISK SCORE CALCULATION - Multi-Factor Algorithm
-- ================================================================

-- Comprehensive risk scoring based on all key churn indicators
WITH risk_scoring AS (
    SELECT 
        customer_id,
        age,
        lifetime,
        avg_class_frequency_current_month,
        avg_class_frequency_total,
        avg_additional_charges_total,
        contract_period,
        month_to_end_contract,
        group_visits,
        near_location,
        partner,
        promo_friends,
        churn,
        
        -- Individual risk factors (0-100 scale, higher = more risk)
        CASE 
            WHEN lifetime <= 1 THEN 90
            WHEN lifetime <= 3 THEN 70
            WHEN lifetime <= 6 THEN 40
            WHEN lifetime <= 12 THEN 20
            ELSE 10
        END AS tenure_risk_score,
        
        CASE 
            WHEN avg_class_frequency_current_month = 0 THEN 100
            WHEN avg_class_frequency_current_month < 0.5 THEN 85
            WHEN avg_class_frequency_current_month < 1 THEN 70
            WHEN avg_class_frequency_current_month < 1.5 THEN 50
            WHEN avg_class_frequency_current_month < 2 THEN 30
            WHEN avg_class_frequency_current_month < 2.5 THEN 15
            ELSE 5
        END AS activity_risk_score,
        
        CASE 
            WHEN avg_additional_charges_total < 50 THEN 80
            WHEN avg_additional_charges_total < 100 THEN 60
            WHEN avg_additional_charges_total < 150 THEN 40
            WHEN avg_additional_charges_total < 200 THEN 25
            WHEN avg_additional_charges_total < 300 THEN 15
            ELSE 5
        END AS spending_risk_score,
        
        CASE 
            WHEN contract_period = 1 THEN 70
            WHEN contract_period <= 3 THEN 50
            WHEN contract_period = 6 THEN 30
            WHEN contract_period = 12 THEN 5
            ELSE 10
        END AS contract_risk_score,
        
        CASE 
            WHEN month_to_end_contract <= 1 THEN 80
            WHEN month_to_end_contract <= 2 THEN 60
            WHEN month_to_end_contract <= 3 THEN 40
            WHEN month_to_end_contract <= 6 THEN 20
            ELSE 10
        END AS renewal_risk_score,
        
        CASE 
            WHEN group_visits = 0 THEN 40
            ELSE 10
        END AS social_risk_score,
        
        CASE 
            WHEN partner = 0 AND promo_friends = 0 THEN 30  -- Organic acquisition
            WHEN partner = 1 AND promo_friends = 0 THEN 15  -- Partner only
            WHEN partner = 0 AND promo_friends = 1 THEN 10  -- Referral only
            ELSE 5  -- Partner + Referral
        END AS acquisition_risk_score
        
    FROM gym_customers
)

SELECT 
    customer_id,
    tenure_risk_score,
    activity_risk_score,
    spending_risk_score,
    contract_risk_score,
    renewal_risk_score,
    social_risk_score,
    acquisition_risk_score,
    
    -- Weighted composite risk score (0-100, higher = more risk)
    ROUND(
        (tenure_risk_score * 0.25 +          -- 25% weight
         activity_risk_score * 0.30 +        -- 30% weight (most important)
         spending_risk_score * 0.20 +        -- 20% weight
         contract_risk_score * 0.10 +        -- 10% weight
         renewal_risk_score * 0.10 +         -- 10% weight
         social_risk_score * 0.03 +          -- 3% weight
         acquisition_risk_score * 0.02), 1   -- 2% weight
    ) AS composite_risk_score,
    
    churn,
    
    -- Risk categories for business action
    CASE 
        WHEN ROUND(
            (tenure_risk_score * 0.25 +
             activity_risk_score * 0.30 +
             spending_risk_score * 0.20 +
             contract_risk_score * 0.10 +
             renewal_risk_score * 0.10 +
             social_risk_score * 0.03 +
             acquisition_risk_score * 0.02), 1
        ) >= 70 THEN 'CRITICAL_RISK'
        WHEN ROUND(
            (tenure_risk_score * 0.25 +
             activity_risk_score * 0.30 +
             spending_risk_score * 0.20 +
             contract_risk_score * 0.10 +
             renewal_risk_score * 0.10 +
             social_risk_score * 0.03 +
             acquisition_risk_score * 0.02), 1
        ) >= 50 THEN 'HIGH_RISK'
        WHEN ROUND(
            (tenure_risk_score * 0.25 +
             activity_risk_score * 0.30 +
             spending_risk_score * 0.20 +
             contract_risk_score * 0.10 +
             renewal_risk_score * 0.10 +
             social_risk_score * 0.03 +
             acquisition_risk_score * 0.02), 1
        ) >= 30 THEN 'MEDIUM_RISK'
        ELSE 'LOW_RISK'
    END AS risk_category

FROM risk_scoring
ORDER BY composite_risk_score DESC;

-- ================================================================
-- CHURN RISK VALIDATION - Model Performance Analysis
-- ================================================================

-- Validate risk scoring accuracy against actual churn
SELECT 
    risk_category,
    COUNT(*) as total_customers,
    SUM(churn) as actual_churned,
    ROUND(AVG(churn) * 100, 1) as actual_churn_rate_pct,
    ROUND(AVG(composite_risk_score), 1) as avg_risk_score,
    MIN(composite_risk_score) as min_risk_score,
    MAX(composite_risk_score) as max_risk_score,
    
    -- Model accuracy metrics
    CASE 
        WHEN risk_category = 'CRITICAL_RISK' AND AVG(churn) >= 0.6 THEN 'Accurate_Prediction'
        WHEN risk_category = 'HIGH_RISK' AND AVG(churn) BETWEEN 0.3 AND 0.6 THEN 'Accurate_Prediction'
        WHEN risk_category = 'MEDIUM_RISK' AND AVG(churn) BETWEEN 0.1 AND 0.4 THEN 'Accurate_Prediction'
        WHEN risk_category = 'LOW_RISK' AND AVG(churn) <= 0.2 THEN 'Accurate_Prediction'
        ELSE 'Needs_Calibration'
    END AS prediction_accuracy
FROM (
    SELECT 
        customer_id,
        churn,
        ROUND(
            (CASE 
                WHEN lifetime <= 1 THEN 90
                WHEN lifetime <= 3 THEN 70
                WHEN lifetime <= 6 THEN 40
                WHEN lifetime <= 12 THEN 20
                ELSE 10
            END * 0.25 +
            CASE 
                WHEN avg_class_frequency_current_month = 0 THEN 100
                WHEN avg_class_frequency_current_month < 0.5 THEN 85
                WHEN avg_class_frequency_current_month < 1 THEN 70
                WHEN avg_class_frequency_current_month < 1.5 THEN 50
                WHEN avg_class_frequency_current_month < 2 THEN 30
                WHEN avg_class_frequency_current_month < 2.5 THEN 15
                ELSE 5
            END * 0.30 +
            CASE 
                WHEN avg_additional_charges_total < 50 THEN 80
                WHEN avg_additional_charges_total < 100 THEN 60
                WHEN avg_additional_charges_total < 150 THEN 40
                WHEN avg_additional_charges_total < 200 THEN 25
                WHEN avg_additional_charges_total < 300 THEN 15
                ELSE 5
            END * 0.20 +
            CASE 
                WHEN contract_period = 1 THEN 70
                WHEN contract_period <= 3 THEN 50
                WHEN contract_period = 6 THEN 30
                WHEN contract_period = 12 THEN 5
                ELSE 10
            END * 0.10 +
            CASE 
                WHEN month_to_end_contract <= 1 THEN 80
                    WHEN month_to_end_contract <= 2 THEN 60
                    WHEN month_to_end_contract <= 3 THEN 40
                    WHEN month_to_end_contract <= 6 THEN 20
                    ELSE 10
                END * 0.10 +
                CASE 
                    WHEN group_visits = 0 THEN 40
                    ELSE 10
                END * 0.03 +
                CASE 
                    WHEN partner = 0 AND promo_friends = 0 THEN 30
                    WHEN partner = 1 AND promo_friends = 0 THEN 15
                    WHEN partner = 0 AND promo_friends = 1 THEN 10
                    ELSE 5
                END * 0.02), 1
            ) >= 30 THEN 'MEDIUM_RISK'
            ELSE 'LOW_RISK'
        END AS risk_category
    FROM gym_customers
) customer_risk_analysis
ORDER BY customer_value_score DESC, composite_risk_score DESC; 80
                WHEN month_to_end_contract <= 2 THEN 60
                WHEN month_to_end_contract <= 3 THEN 40
                WHEN month_to_end_contract <= 6 THEN 20
                ELSE 10
            END * 0.10 +
            CASE 
                WHEN group_visits = 0 THEN 40
                ELSE 10
            END * 0.03 +
            CASE 
                WHEN partner = 0 AND promo_friends = 0 THEN 30
                WHEN partner = 1 AND promo_friends = 0 THEN 15
                WHEN partner = 0 AND promo_friends = 1 THEN 10
                ELSE 5
            END * 0.02), 1
        ) AS composite_risk_score,
        
        CASE 
            WHEN ROUND(
                (CASE 
                    WHEN lifetime <= 1 THEN 90
                    WHEN lifetime <= 3 THEN 70
                    WHEN lifetime <= 6 THEN 40
                    WHEN lifetime <= 12 THEN 20
                    ELSE 10
                END * 0.25 +
                CASE 
                    WHEN avg_class_frequency_current_month = 0 THEN 100
                    WHEN avg_class_frequency_current_month < 0.5 THEN 85
                    WHEN avg_class_frequency_current_month < 1 THEN 70
                    WHEN avg_class_frequency_current_month < 1.5 THEN 50
                    WHEN avg_class_frequency_current_month < 2 THEN 30
                    WHEN avg_class_frequency_current_month < 2.5 THEN 15
                    ELSE 5
                END * 0.30 +
                CASE 
                    WHEN avg_additional_charges_total < 50 THEN 80
                    WHEN avg_additional_charges_total < 100 THEN 60
                    WHEN avg_additional_charges_total < 150 THEN 40
                    WHEN avg_additional_charges_total < 200 THEN 25
                    WHEN avg_additional_charges_total < 300 THEN 15
                    ELSE 5
                END * 0.20 +
                CASE 
                    WHEN contract_period = 1 THEN 70
                    WHEN contract_period <= 3 THEN 50
                    WHEN contract_period = 6 THEN 30
                    WHEN contract_period = 12 THEN 5
                    ELSE 10
                END * 0.10 +
                CASE 
                    WHEN month_to_end_contract <= 1 THEN 80
                    WHEN month_to_end_contract <= 2 THEN 60
                    WHEN month_to_end_contract <= 3 THEN 40
                    WHEN month_to_end_contract <= 6 THEN 20
                    ELSE 10
                END * 0.10 +
                CASE 
                    WHEN group_visits = 0 THEN 40
                    ELSE 10
                END * 0.03 +
                CASE 
                    WHEN partner = 0 AND promo_friends = 0 THEN 30
                    WHEN partner = 1 AND promo_friends = 0 THEN 15
                    WHEN partner = 0 AND promo_friends = 1 THEN 10
                    ELSE 5
                END * 0.02), 1
            ) >= 70 THEN 'CRITICAL_RISK'
            WHEN ROUND(
                (CASE 
                    WHEN lifetime <= 1 THEN 90
                    WHEN lifetime <= 3 THEN 70
                    WHEN lifetime <= 6 THEN 40
                    WHEN lifetime <= 12 THEN 20
                    ELSE 10
                END * 0.25 +
                CASE 
                    WHEN avg_class_frequency_current_month = 0 THEN 100
                    WHEN avg_class_frequency_current_month < 0.5 THEN 85
                    WHEN avg_class_frequency_current_month < 1 THEN 70
                    WHEN avg_class_frequency_current_month < 1.5 THEN 50
                    WHEN avg_class_frequency_current_month < 2 THEN 30
                    WHEN avg_class_frequency_current_month < 2.5 THEN 15
                    ELSE 5
                END * 0.30 +
                CASE 
                    WHEN avg_additional_charges_total < 50 THEN 80
                    WHEN avg_additional_charges_total < 100 THEN 60
                    WHEN avg_additional_charges_total < 150 THEN 40
                    WHEN avg_additional_charges_total < 200 THEN 25
                    WHEN avg_additional_charges_total < 300 THEN 15
                    ELSE 5
                END * 0.20 +
                CASE 
                    WHEN contract_period = 1 THEN 70
                    WHEN contract_period <= 3 THEN 50
                    WHEN contract_period = 6 THEN 30
                    WHEN contract_period = 12 THEN 5
                    ELSE 10
                END * 0.10 +
                CASE 
                    WHEN month_to_end_contract <= 1 THEN 80
                    WHEN month_to_end_contract <= 2 THEN 60
                    WHEN month_to_end_contract <= 3 THEN 40
                    WHEN month_to_end_contract <= 6 THEN 20
                    ELSE 10
                END * 0.10 +
                CASE 
                    WHEN group_visits = 0 THEN 40
                    ELSE 10
                END * 0.03 +
                CASE 
                    WHEN partner = 0 AND promo_friends = 0 THEN 30
                    WHEN partner = 1 AND promo_friends = 0 THEN 15
                    WHEN partner = 0 AND promo_friends = 1 THEN 10
                    ELSE 5
                END * 0.02), 1
            ) >= 50 THEN 'HIGH_RISK'
            WHEN ROUND(
                (CASE 
                    WHEN lifetime <= 1 THEN 90
                    WHEN lifetime <= 3 THEN 70
                    WHEN lifetime <= 6 THEN 40
                    WHEN lifetime <= 12 THEN 20
                    ELSE 10
                END * 0.25 +
                CASE 
                    WHEN avg_class_frequency_current_month = 0 THEN 100
                    WHEN avg_class_frequency_current_month < 0.5 THEN 85
                    WHEN avg_class_frequency_current_month < 1 THEN 70
                    WHEN avg_class_frequency_current_month < 1.5 THEN 50
                    WHEN avg_class_frequency_current_month < 2 THEN 30
                    WHEN avg_class_frequency_current_month < 2.5 THEN 15
                    ELSE 5
                END * 0.30 +
                CASE 
                    WHEN avg_additional_charges_total < 50 THEN 80
                    WHEN avg_additional_charges_total < 100 THEN 60
                    WHEN avg_additional_charges_total < 150 THEN 40
                    WHEN avg_additional_charges_total < 200 THEN 25
                    WHEN avg_additional_charges_total < 300 THEN 15
                    ELSE 5
                END * 0.20 +
                CASE 
                    WHEN contract_period = 1 THEN 70
                    WHEN contract_period <= 3 THEN 50
                    WHEN contract_period = 6 THEN 30
                    WHEN contract_period = 12 THEN 5
                    ELSE 10
                END * 0.10 +
                CASE 
                    WHEN month_to_end_contract <= 1 THEN 80
                    WHEN month_to_end_contract <= 2 THEN 60
                    WHEN month_to_end_contract <= 3 THEN 40
                    WHEN month_to_end_contract <= 6 THEN 20
                    ELSE 10
                END * 0.10 +
                CASE 
                    WHEN group_visits = 0 THEN 40
                    ELSE 10
                END * 0.03 +
                CASE 
                    WHEN partner = 0 AND promo_friends = 0 THEN 30
                    WHEN partner = 1 AND promo_friends = 0 THEN 15
                    WHEN partner = 0 AND promo_friends = 1 THEN 10
                    ELSE 5
                END * 0.02), 1
            ) >= 30 THEN 'MEDIUM_RISK'
            ELSE 'LOW_RISK'
        END AS risk_category
    FROM gym_customers
) risk_analysis
GROUP BY risk_category
ORDER BY avg_risk_score DESC;

-- ================================================================
-- HIGH-VALUE AT-RISK CUSTOMERS - Priority Intervention List
-- ================================================================

-- Identify high-value customers with significant churn risk for immediate action
SELECT 
    customer_id,
    age,
    lifetime,
    avg_class_frequency_current_month,
    avg_additional_charges_total,
    contract_period,
    month_to_end_contract,
    near_location,
    partner,
    promo_friends,
    group_visits,
    composite_risk_score,
    risk_category,
    churn,
    
    -- Customer value score (spending + potential)
    ROUND(
        (avg_additional_charges_total * 0.6 +      -- Current spending weight
         (contract_period * 10) * 0.2 +            -- Contract commitment weight  
         (CASE WHEN partner = 1 OR promo_friends = 1 THEN 50 ELSE 0 END) * 0.2), 0  -- Acquisition quality weight
    ) AS customer_value_score,
    
    -- Retention priority
    CASE 
        WHEN (avg_additional_charges_total * 0.6 + (contract_period * 10) * 0.2 + 
              (CASE WHEN partner = 1 OR promo_friends = 1 THEN 50 ELSE 0 END) * 0.2) >= 150 
         AND composite_risk_score >= 50 THEN 'PRIORITY_1_VIP_AT_RISK'
        WHEN (avg_additional_charges_total * 0.6 + (contract_period * 10) * 0.2 + 
              (CASE WHEN partner = 1 OR promo_friends = 1 THEN 50 ELSE 0 END) * 0.2) >= 100 
         AND composite_risk_score >= 50 THEN 'PRIORITY_2_HIGH_VALUE_AT_RISK'
        WHEN composite_risk_score >= 70 THEN 'PRIORITY_3_CRITICAL_RISK'
        WHEN composite_risk_score >= 50 THEN 'PRIORITY_4_HIGH_RISK'
        ELSE 'STANDARD_MONITORING'
    END AS intervention_priority

FROM (
    SELECT 
        customer_id,
        age,
        lifetime,
        avg_class_frequency_current_month,
        avg_additional_charges_total,
        contract_period,
        month_to_end_contract,
        near_location,
        partner,
        promo_friends,
        group_visits,
        churn,
        ROUND(
            (CASE 
                WHEN lifetime <= 1 THEN 90
                WHEN lifetime <= 3 THEN 70
                WHEN lifetime <= 6 THEN 40
                WHEN lifetime <= 12 THEN 20
                ELSE 10
            END * 0.25 +
            CASE 
                WHEN avg_class_frequency_current_month = 0 THEN 100
                WHEN avg_class_frequency_current_month < 0.5 THEN 85
                WHEN avg_class_frequency_current_month < 1 THEN 70
                WHEN avg_class_frequency_current_month < 1.5 THEN 50
                WHEN avg_class_frequency_current_month < 2 THEN 30
                WHEN avg_class_frequency_current_month < 2.5 THEN 15
                ELSE 5
            END * 0.30 +
            CASE 
                WHEN avg_additional_charges_total < 50 THEN 80
                WHEN avg_additional_charges_total < 100 THEN 60
                WHEN avg_additional_charges_total < 150 THEN 40
                WHEN avg_additional_charges_total < 200 THEN 25
                WHEN avg_additional_charges_total < 300 THEN 15
                ELSE 5
            END * 0.20 +
            CASE 
                WHEN contract_period = 1 THEN 70
                WHEN contract_period <= 3 THEN 50
                WHEN contract_period = 6 THEN 30
                WHEN contract_period = 12 THEN 5
                ELSE 10
            END * 0.10 +
            CASE 
                WHEN month_to_end_contract <= 1 THEN 80
                WHEN month_to_end_contract <= 2 THEN 60
                WHEN month_to_end_contract <= 3 THEN 40
                WHEN month_to_end_contract <= 6 THEN 20
                ELSE 10
            END * 0.10 +
            CASE 
                WHEN group_visits = 0 THEN 40
                ELSE 10
            END * 0.03 +
            CASE 
                WHEN partner = 0 AND promo_friends = 0 THEN 30
                WHEN partner = 1 AND promo_friends = 0 THEN 15
                WHEN partner = 0 AND promo_friends = 1 THEN 10
                ELSE 5
            END * 0.02), 1
        ) AS composite_risk_score,
        
        CASE 
            WHEN ROUND(
                (CASE 
                    WHEN lifetime <= 1 THEN 90
                    WHEN lifetime <= 3 THEN 70
                    WHEN lifetime <= 6 THEN 40
                    WHEN lifetime <= 12 THEN 20
                    ELSE 10
                END * 0.25 +
                CASE 
                    WHEN avg_class_frequency_current_month = 0 THEN 100
                    WHEN avg_class_frequency_current_month < 0.5 THEN 85
                    WHEN avg_class_frequency_current_month < 1 THEN 70
                    WHEN avg_class_frequency_current_month < 1.5 THEN 50
                    WHEN avg_class_frequency_current_month < 2 THEN 30
                    WHEN avg_class_frequency_current_month < 2.5 THEN 15
                    ELSE 5
                END * 0.30 +
                CASE 
                    WHEN avg_additional_charges_total < 50 THEN 80
                    WHEN avg_additional_charges_total < 100 THEN 60
                    WHEN avg_additional_charges_total < 150 THEN 40
                    WHEN avg_additional_charges_total < 200 THEN 25
                    WHEN avg_additional_charges_total < 300 THEN 15
                    ELSE 5
                END * 0.20 +
                CASE 
                    WHEN contract_period = 1 THEN 70
                    WHEN contract_period <= 3 THEN 50
                    WHEN contract_period = 6 THEN 30
                    WHEN contract_period = 12 THEN 5
                    ELSE 10
                END * 0.10 +
                CASE 
                    WHEN month_to_end_contract <= 1 THEN 80
                    WHEN month_to_end_contract <= 2 THEN 60
                    WHEN month_to_end_contract <= 3 THEN 40
                    WHEN month_to_end_contract <= 6 THEN 20
                    ELSE 10
                END * 0.10 +
                CASE 
                    WHEN group_visits = 0 THEN 40
                    ELSE 10
                END * 0.03 +
                CASE 
                    WHEN partner = 0 AND promo_friends = 0 THEN 30
                    WHEN partner = 1 AND promo_friends = 0 THEN 15
                    WHEN partner = 0 AND promo_friends = 1 THEN 10
                    ELSE 5
                END * 0.02), 1
            ) >= 70 THEN 'CRITICAL_RISK'
            WHEN ROUND(
                (CASE 
                    WHEN lifetime <= 1 THEN 90
                    WHEN lifetime <= 3 THEN 70
                    WHEN lifetime <= 6 THEN 40
                    WHEN lifetime <= 12 THEN 20
                    ELSE 10
                END * 0.25 +
                CASE 
                    WHEN avg_class_frequency_current_month = 0 THEN 100
                    WHEN avg_class_frequency_current_month < 0.5 THEN 85
                    WHEN avg_class_frequency_current_month < 1 THEN 70
                    WHEN avg_class_frequency_current_month < 1.5 THEN 50
                    WHEN avg_class_frequency_current_month < 2 THEN 30
                    WHEN avg_class_frequency_current_month < 2.5 THEN 15
                    ELSE 5
                END * 0.30 +
                CASE 
                    WHEN avg_additional_charges_total < 50 THEN 80
                    WHEN avg_additional_charges_total < 100 THEN 60
                    WHEN avg_additional_charges_total < 150 THEN 40
                    WHEN avg_additional_charges_total < 200 THEN 25
                    WHEN avg_additional_charges_total < 300 THEN 15
                    ELSE 5
                END * 0.20 +
                CASE 
                    WHEN contract_period = 1 THEN 70
                    WHEN contract_period <= 3 THEN 50
                    WHEN contract_period = 6 THEN 30
                    WHEN contract_period = 12 THEN 5
                    ELSE 10
                END * 0.10 +
                CASE 
                    WHEN month_to_end_contract <= 1 THEN 80
                    WHEN month_to_end_contract <= 2 THEN 60
                    WHEN month_to_end_contract <= 3 THEN 40
                    WHEN month_to_end_contract <= 6 THEN 20
                    ELSE 10
                END * 0.10 +
                CASE 
                    WHEN group_visits = 0 THEN 40
                    ELSE 10
                END * 0.03 +
                CASE 
                    WHEN partner = 0 AND promo_friends = 0 THEN 30
                    WHEN partner = 1 AND promo_friends = 0 THEN 15
                    WHEN partner = 0 AND promo_friends = 1 THEN 10
                    ELSE 5
                END * 0.02), 1
            ) >= 50 THEN 'HIGH_RISK'
            WHEN ROUND(
                (CASE 
                    WHEN lifetime <= 1 THEN 90
                    WHEN lifetime <= 3 THEN 70
                    WHEN lifetime <= 6 THEN 40
                    WHEN lifetime <= 12 THEN 20
                    ELSE 10
                END * 0.25 +
                CASE 
                    WHEN avg_class_frequency_current_month = 0 THEN 100
                    WHEN avg_class_frequency_current_month < 0.5 THEN 85
                    WHEN avg_class_frequency_current_month < 1 THEN 70
                    WHEN avg_class_frequency_current_month < 1.5 THEN 50
                    WHEN avg_class_frequency_current_month < 2 THEN 30
                    WHEN avg_class_frequency_current_month < 2.5 THEN 15
                    ELSE 5
                END * 0.30 +
                CASE 
                    WHEN avg_additional_charges_total < 50 THEN 80
                    WHEN avg_additional_charges_total < 100 THEN 60
                    WHEN avg_additional_charges_total < 150 THEN 40
                    WHEN avg_additional_charges_total < 200 THEN 25
                    WHEN avg_additional_charges_total < 300 THEN 15
                    ELSE 5
                END * 0.20 +
                CASE 
                    WHEN contract_period = 1 THEN 70
                    WHEN contract_period <= 3 THEN 50
                    WHEN contract_period = 6 THEN 30
                    WHEN contract_period = 12 THEN 5
                    ELSE 10
                END * 0.10 +
                CASE 
                    WHEN month_to_end_contract <= 1 THEN
