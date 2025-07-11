-- ================================================================
-- CUSTOMER PROFILING ANALYSIS: Demographic and Behavioral Segmentation  
-- ================================================================
-- Purpose: Identify distinct customer profiles based on demographics,
-- behavior patterns, and churn risk for targeted retention strategies

-- ================================================================
-- CUSTOMER DEMOGRAPHIC PROFILES
-- ================================================================

-- Age-based customer segmentation with churn analysis
SELECT 
    CASE 
        WHEN age BETWEEN 18 AND 25 THEN 'Young_Adults'
        WHEN age BETWEEN 26 AND 30 THEN 'Peak_Fitness'  
        WHEN age BETWEEN 31 AND 35 THEN 'Established_Adults'
        WHEN age > 35 THEN 'Mature_Adults'
    END AS age_segment,
    COUNT(*) as total_customers,
    ROUND(AVG(age), 1) as avg_age,
    ROUND(AVG(churn) * 100, 1) as churn_rate_pct,
    ROUND(AVG(avg_additional_charges_total), 0) as avg_spending,
    ROUND(AVG(lifetime), 1) as avg_tenure_months
FROM gym_customers
GROUP BY age_segment
ORDER BY avg_age;

-- ================================================================
-- GEOGRAPHIC AND CONVENIENCE ANALYSIS  
-- ================================================================

-- Proximity impact on customer loyalty and engagement
SELECT 
    near_location,
    CASE 
        WHEN near_location = 1 THEN 'Lives_Near_Gym'
        ELSE 'Lives_Far_From_Gym'
    END AS proximity_status,
    COUNT(*) as customer_count,
    ROUND(AVG(churn) * 100, 1) as churn_rate_pct,
    ROUND(AVG(avg_class_frequency_current_month), 2) as avg_weekly_visits,
    ROUND(AVG(contract_period), 1) as avg_contract_months,
    ROUND(AVG(avg_additional_charges_total), 0) as avg_additional_spending
FROM gym_customers  
GROUP BY near_location, proximity_status
ORDER BY near_location DESC;

-- ================================================================
-- CUSTOMER ACQUISITION CHANNEL ANALYSIS
-- ================================================================

-- Channel performance: Organic vs Partner vs Referral vs Combined
SELECT 
    CASE 
        WHEN partner = 0 AND promo_friends = 0 THEN 'Organic'
        WHEN partner = 1 AND promo_friends = 0 THEN 'Corporate_Partner'
        WHEN partner = 0 AND promo_friends = 1 THEN 'Friend_Referral'  
        WHEN partner = 1 AND promo_friends = 1 THEN 'Partner_Plus_Referral'
    END AS acquisition_channel,
    COUNT(*) as customers,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 1) as pct_of_total,
    ROUND(AVG(churn) * 100, 1) as churn_rate_pct,
    ROUND(AVG(lifetime), 1) as avg_tenure_months,
    ROUND(AVG(avg_additional_charges_total), 0) as avg_spending,
    ROUND(AVG(contract_period), 1) as avg_contract_length
FROM gym_customers
GROUP BY acquisition_channel
ORDER BY churn_rate_pct ASC;

-- ================================================================
-- CONTRACT COMMITMENT ANALYSIS
-- ================================================================

-- Contract period impact on retention and customer value
SELECT 
    contract_period,
    CASE 
        WHEN contract_period = 1 THEN 'Monthly_Flexible'
        WHEN contract_period BETWEEN 2 AND 6 THEN 'Short_Term'
        WHEN contract_period = 12 THEN 'Annual_Committed'
        ELSE 'Other'
    END AS contract_type,
    COUNT(*) as customer_count,
    ROUND(AVG(churn) * 100, 1) as churn_rate_pct,
    ROUND(AVG(avg_additional_charges_total), 0) as avg_additional_spending,
    ROUND(AVG(avg_class_frequency_current_month), 2) as avg_weekly_frequency,
    ROUND(AVG(lifetime), 1) as avg_tenure_months
FROM gym_customers
GROUP BY contract_period, contract_type
HAVING COUNT(*) >= 50  -- Focus on significant segments
ORDER BY contract_period;

-- ================================================================
-- HIGH-VALUE CUSTOMER IDENTIFICATION
-- ================================================================

-- Identify premium customers: High spending + Low churn + High engagement
SELECT 
    customer_id,
    age,
    lifetime,
    contract_period,
    avg_additional_charges_total,
    avg_class_frequency_current_month,
    near_location,
    partner,
    promo_friends,
    group_visits,
    churn,
    -- Scoring algorithm for customer value
    CASE 
        WHEN avg_additional_charges_total >= 200 
         AND avg_class_frequency_current_month >= 2.5 
         AND contract_period >= 12 
         AND churn = 0 THEN 'Premium_VIP'
        WHEN avg_additional_charges_total >= 150 
         AND avg_class_frequency_current_month >= 2.0 
         AND churn = 0 THEN 'High_Value'
        WHEN churn = 0 AND lifetime >= 6 THEN 'Stable_Loyal'
        WHEN churn = 1 AND lifetime <= 3 THEN 'Early_Churn_Risk'
        WHEN churn = 1 THEN 'Lost_Customer'
        ELSE 'Standard'
    END AS customer_tier
FROM gym_customers
ORDER BY avg_additional_charges_total DESC, 
         avg_class_frequency_current_month DESC;

-- ================================================================
-- CUSTOMER PROFILE SUMMARY FOR MARKETING SEGMENTATION
-- ================================================================

-- Executive summary: Customer profiles with business recommendations
SELECT 
    customer_tier,
    COUNT(*) as segment_size,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 1) as pct_of_total,
    ROUND(AVG(age), 1) as avg_age,
    ROUND(AVG(lifetime), 1) as avg_tenure,
    ROUND(AVG(avg_additional_charges_total), 0) as avg_spending,
    ROUND(AVG(avg_class_frequency_current_month), 2) as avg_frequency,
    ROUND(AVG(contract_period), 1) as avg_contract,
    ROUND(AVG(churn) * 100, 1) as churn_rate_pct
FROM (
    SELECT *,
        CASE 
            WHEN avg_additional_charges_total >= 200 
             AND avg_class_frequency_current_month >= 2.5 
             AND contract_period >= 12 
             AND churn = 0 THEN 'Premium_VIP'
            WHEN avg_additional_charges_total >= 150 
             AND avg_class_frequency_current_month >= 2.0 
             AND churn = 0 THEN 'High_Value'
            WHEN churn = 0 AND lifetime >= 6 THEN 'Stable_Loyal'
            WHEN churn = 1 AND lifetime <= 3 THEN 'Early_Churn_Risk'
            WHEN churn = 1 THEN 'Lost_Customer'
            ELSE 'Standard'
        END AS customer_tier
    FROM gym_customers
) customer_analysis
GROUP BY customer_tier
ORDER BY avg_spending DESC;
