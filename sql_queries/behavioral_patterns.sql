-- ================================================================
-- BEHAVIORAL PATTERNS ANALYSIS: Activity Trends and Engagement Metrics
-- ================================================================
-- Purpose: Identify behavioral patterns that predict churn risk
-- and engagement levels for proactive intervention strategies

-- ================================================================
-- ACTIVITY FREQUENCY ANALYSIS - Current vs Historical Patterns
-- ================================================================

-- Compare current month activity vs historical average to detect declining engagement
SELECT 
    CASE 
        WHEN avg_class_frequency_current_month = 0 THEN 'Inactive_Current'
        WHEN avg_class_frequency_current_month < 1 THEN 'Low_Activity'
        WHEN avg_class_frequency_current_month BETWEEN 1 AND 2 THEN 'Moderate_Activity'
        WHEN avg_class_frequency_current_month BETWEEN 2 AND 3 THEN 'High_Activity'
        WHEN avg_class_frequency_current_month > 3 THEN 'Super_Active'
    END AS current_activity_level,
    COUNT(*) as customer_count,
    ROUND(AVG(churn) * 100, 1) as churn_rate_pct,
    ROUND(AVG(avg_class_frequency_current_month), 2) as avg_current_frequency,
    ROUND(AVG(avg_class_frequency_total), 2) as avg_historical_frequency,
    ROUND(AVG(avg_class_frequency_current_month - avg_class_frequency_total), 2) as frequency_change,
    ROUND(AVG(lifetime), 1) as avg_tenure_months
FROM gym_customers
GROUP BY current_activity_level
ORDER BY avg_current_frequency;

-- ================================================================
-- ENGAGEMENT DECLINE DETECTION
-- ================================================================

-- Identify customers with significant activity drops (early churn warning)
SELECT 
    customer_id,
    avg_class_frequency_total as historical_avg,
    avg_class_frequency_current_month as current_month,
    ROUND((avg_class_frequency_current_month - avg_class_frequency_total), 2) as frequency_change,
    ROUND(((avg_class_frequency_current_month - avg_class_frequency_total) / 
           NULLIF(avg_class_frequency_total, 0)) * 100, 1) as pct_change,
    lifetime,
    churn,
    CASE 
        WHEN avg_class_frequency_current_month < avg_class_frequency_total * 0.5 THEN 'Severe_Decline'
        WHEN avg_class_frequency_current_month < avg_class_frequency_total * 0.7 THEN 'Moderate_Decline'
        WHEN avg_class_frequency_current_month < avg_class_frequency_total * 0.9 THEN 'Slight_Decline'
        WHEN avg_class_frequency_current_month >= avg_class_frequency_total THEN 'Stable_or_Growing'
    END AS engagement_trend
FROM gym_customers
WHERE avg_class_frequency_total > 0  -- Exclude customers with no historical activity
ORDER BY pct_change ASC;

-- ================================================================
-- GROUP CLASS PARTICIPATION IMPACT
-- ================================================================

-- Social engagement analysis: Group classes vs individual workouts
SELECT 
    group_visits,
    CASE 
        WHEN group_visits = 1 THEN 'Group_Class_Participant'
        ELSE 'Individual_Workout_Only'
    END AS social_engagement_type,
    COUNT(*) as customer_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 1) as pct_of_total,
    ROUND(AVG(churn) * 100, 1) as churn_rate_pct,
    ROUND(AVG(avg_class_frequency_current_month), 2) as avg_weekly_visits,
    ROUND(AVG(avg_additional_charges_total), 0) as avg_additional_spending,
    ROUND(AVG(contract_period), 1) as avg_contract_length,
    ROUND(AVG(lifetime), 1) as avg_tenure_months
FROM gym_customers
GROUP BY group_visits, social_engagement_type
ORDER BY group_visits DESC;

-- ================================================================
-- CUSTOMER LIFECYCLE ANALYSIS - Tenure-based Behavior
-- ================================================================

-- Behavior patterns by customer maturity/lifetime
SELECT 
    CASE 
        WHEN lifetime = 0 THEN 'New_Member_First_Month'
        WHEN lifetime BETWEEN 1 AND 3 THEN 'Early_Stage_1_3_Months'
        WHEN lifetime BETWEEN 4 AND 6 THEN 'Developing_4_6_Months'
        WHEN lifetime BETWEEN 7 AND 12 THEN 'Established_7_12_Months'
        WHEN lifetime > 12 THEN 'Veteran_12_Plus_Months'
    END AS lifecycle_stage,
    COUNT(*) as customer_count,
    ROUND(AVG(churn) * 100, 1) as churn_rate_pct,
    ROUND(AVG(avg_class_frequency_current_month), 2) as avg_current_frequency,
    ROUND(AVG(avg_additional_charges_total), 0) as avg_spending,
    ROUND(AVG(contract_period), 1) as avg_contract_length,
    -- Progression metrics
    MIN(lifetime) as min_tenure,
    MAX(lifetime) as max_tenure,
    ROUND(AVG(CASE WHEN group_visits = 1 THEN 1.0 ELSE 0.0 END) * 100, 1) as group_participation_pct
FROM gym_customers
GROUP BY lifecycle_stage
ORDER BY min_tenure;

-- ================================================================
-- SPENDING BEHAVIOR AND ENGAGEMENT CORRELATION
-- ================================================================

-- Relationship between spending patterns and activity levels
SELECT 
    CASE 
        WHEN avg_additional_charges_total < 50 THEN 'Minimal_Spender'
        WHEN avg_additional_charges_total BETWEEN 50 AND 100 THEN 'Low_Spender'
        WHEN avg_additional_charges_total BETWEEN 100 AND 200 THEN 'Moderate_Spender'
        WHEN avg_additional_charges_total BETWEEN 200 AND 300 THEN 'High_Spender'
        WHEN avg_additional_charges_total > 300 THEN 'Premium_Spender'
    END AS spending_tier,
    COUNT(*) as customer_count,
    ROUND(AVG(churn) * 100, 1) as churn_rate_pct,
    ROUND(AVG(avg_additional_charges_total), 0) as avg_additional_spending,
    ROUND(AVG(avg_class_frequency_current_month), 2) as avg_weekly_frequency,
    ROUND(AVG(contract_period), 1) as avg_contract_months,
    ROUND(AVG(lifetime), 1) as avg_tenure,
    ROUND(AVG(CASE WHEN group_visits = 1 THEN 1.0 ELSE 0.0 END) * 100, 1) as group_class_participation_pct
FROM gym_customers
GROUP BY spending_tier
ORDER BY avg_additional_spending;

-- ================================================================
-- CHURN RISK BEHAVIORAL INDICATORS
-- ================================================================

-- Multi-dimensional risk scoring based on behavioral patterns
SELECT 
    customer_id,
    lifetime,
    avg_class_frequency_current_month,
    avg_class_frequency_total,
    avg_additional_charges_total,
    contract_period,
    month_to_end_contract,
    group_visits,
    churn,
    -- Behavioral risk scoring
    CASE 
        WHEN avg_class_frequency_current_month < 1 
         AND lifetime <= 3 
         AND avg_additional_charges_total < 100 THEN 'Critical_Risk'
        WHEN avg_class_frequency_current_month < 1.5 
         AND contract_period <= 3 
         AND group_visits = 0 THEN 'High_Risk'
        WHEN avg_class_frequency_current_month < 2 
         OR avg_additional_charges_total < 120 THEN 'Medium_Risk'
        WHEN avg_class_frequency_current_month >= 2.5 
         AND contract_period >= 12 
         AND group_visits = 1 THEN 'Low_Risk'
        ELSE 'Standard_Risk'
    END AS behavioral_risk_score,
    -- Engagement quality indicators
    ROUND((avg_class_frequency_current_month * 0.4 + 
           (avg_additional_charges_total/100) * 0.3 + 
           (contract_period/12) * 0.3), 2) as engagement_quality_score
FROM gym_customers
ORDER BY engagement_quality_score DESC;

-- ================================================================
-- RETENTION OPPORTUNITY ANALYSIS
-- ================================================================

-- Identify customers with high retention potential based on behavior
SELECT 
    behavioral_risk_score,
    COUNT(*) as customer_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 1) as pct_of_total,
    ROUND(AVG(churn) * 100, 1) as actual_churn_rate,
    ROUND(AVG(engagement_quality_score), 2) as avg_engagement_score,
    ROUND(AVG(avg_class_frequency_current_month), 2) as avg_activity_level,
    ROUND(AVG(avg_additional_charges_total), 0) as avg_spending,
    -- Intervention priority
    CASE 
        WHEN AVG(churn) > 0.5 THEN 'Emergency_Intervention'
        WHEN AVG(churn) BETWEEN 0.25 AND 0.5 THEN 'Proactive_Outreach'
        WHEN AVG(churn) BETWEEN 0.1 AND 0.25 THEN 'Engagement_Programs'
        ELSE 'Retention_Rewards'
    END AS recommended_action
FROM (
    SELECT *,
        CASE 
            WHEN avg_class_frequency_current_month < 1 
             AND lifetime <= 3 
             AND avg_additional_charges_total < 100 THEN 'Critical_Risk'
            WHEN avg_class_frequency_current_month < 1.5 
             AND contract_period <= 3 
             AND group_visits = 0 THEN 'High_Risk'
            WHEN avg_class_frequency_current_month < 2 
             OR avg_additional_charges_total < 120 THEN 'Medium_Risk'
            WHEN avg_class_frequency_current_month >= 2.5 
             AND contract_period >= 12 
             AND group_visits = 1 THEN 'Low_Risk'
            ELSE 'Standard_Risk'
        END AS behavioral_risk_score,
        ROUND((avg_class_frequency_current_month * 0.4 + 
               (avg_additional_charges_total/100) * 0.3 + 
               (contract_period/12) * 0.3), 2) as engagement_quality_score
    FROM gym_customers
) risk_analysis
GROUP BY behavioral_risk_score
ORDER BY actual_churn_rate DESC;
