-- ================================================================
-- BUSINESS INTELLIGENCE DASHBOARD: Executive KPIs and Strategic Metrics
-- ================================================================
-- Purpose: Generate executive-level insights for data-driven decision making
-- and strategic planning for customer retention and revenue optimization

-- ================================================================
-- EXECUTIVE SUMMARY - Key Performance Indicators
-- ================================================================

-- High-level business metrics for executive dashboard
SELECT 
    'CUSTOMER_BASE_OVERVIEW' AS metric_category,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn = 0 THEN 1 ELSE 0 END) AS active_customers,
    SUM(CASE WHEN churn = 1 THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(AVG(churn) * 100, 1) AS overall_churn_rate_pct,
    ROUND(AVG(lifetime), 1) AS avg_customer_tenure_months,
    ROUND(AVG(avg_additional_charges_total), 0) AS avg_monthly_additional_revenue,
    ROUND(SUM(avg_additional_charges_total), 0) AS total_additional_revenue_monthly

FROM gym_customers

UNION ALL

-- Revenue and profitability metrics
SELECT 
    'REVENUE_METRICS' AS metric_category,
    ROUND(AVG(avg_additional_charges_total), 0) AS avg_customer_value,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY avg_additional_charges_total), 0) AS median_customer_value,
    ROUND(MAX(avg_additional_charges_total), 0) AS highest_customer_value,
    ROUND(MIN(avg_additional_charges_total), 0) AS lowest_customer_value,
    COUNT(CASE WHEN avg_additional_charges_total >= 200 THEN 1 END) AS high_value_customers,
    COUNT(CASE WHEN avg_additional_charges_total < 100 THEN 1 END) AS low_value_customers,
    ROUND(AVG(CASE WHEN churn = 0 THEN avg_additional_charges_total END), 0) AS avg_revenue_retained_customers

FROM gym_customers

UNION ALL

-- Engagement and activity metrics
SELECT 
    'ENGAGEMENT_METRICS' AS metric_category,
    ROUND(AVG(avg_class_frequency_current_month), 2) AS avg_weekly_frequency,
    COUNT(CASE WHEN avg_class_frequency_current_month >= 2 THEN 1 END) AS highly_active_customers,
    COUNT(CASE WHEN avg_class_frequency_current_month < 1 THEN 1 END) AS low_activity_customers,
    COUNT(CASE WHEN group_visits = 1 THEN 1 END) AS group_class_participants,
    ROUND(AVG(group_visits) * 100, 1) AS group_participation_rate_pct,
    COUNT(CASE WHEN avg_class_frequency_current_month = 0 THEN 1 END) AS inactive_current_month,
    ROUND(AVG(contract_period), 1) AS avg_contract_length_months

FROM gym_customers;

-- ================================================================
-- CHURN IMPACT ANALYSIS - Revenue Loss Assessment
-- ================================================================

-- Quantify financial impact of customer churn
SELECT 
    'MONTHLY_IMPACT' AS impact_period,
    SUM(CASE WHEN churn = 1 THEN avg_additional_charges_total ELSE 0 END) AS lost_monthly_revenue,
    COUNT(CASE WHEN churn = 1 THEN 1 END) AS customers_lost,
    ROUND(AVG(CASE WHEN churn = 1 THEN avg_additional_charges_total END), 0) AS avg_value_lost_customer,
    
    -- Projected annual impact
    ROUND(SUM(CASE WHEN churn = 1 THEN avg_additional_charges_total ELSE 0 END) * 12, 0) AS projected_annual_loss,
    
    -- Retention opportunity
    ROUND(SUM(CASE WHEN churn = 1 THEN avg_additional_charges_total ELSE 0 END) * 0.7, 0) AS potential_monthly_recovery,
    ROUND(SUM(CASE WHEN churn = 1 THEN avg_additional_charges_total ELSE 0 END) * 0.7 * 12, 0) AS potential_annual_recovery

FROM gym_customers

UNION ALL

-- Customer Lifetime Value analysis
SELECT 
    'LIFETIME_VALUE' AS impact_period,
    ROUND(AVG(avg_additional_charges_total * lifetime), 0) AS avg_customer_ltv,
    ROUND(AVG(CASE WHEN churn = 0 THEN avg_additional_charges_total * lifetime END), 0) AS avg_ltv_retained,
    ROUND(AVG(CASE WHEN churn = 1 THEN avg_additional_charges_total * lifetime END), 0) AS avg_ltv_churned,
    
    -- LTV impact of churn
    ROUND(SUM(CASE WHEN churn = 1 THEN avg_additional_charges_total * lifetime END), 0) AS total_ltv_lost,
    
    -- Potential LTV if retention improved
    ROUND(SUM(CASE WHEN churn = 1 THEN avg_additional_charges_total * 12 END), 0) AS potential_ltv_recovery,
    ROUND((SUM(CASE WHEN churn = 1 THEN avg_additional_charges_total * 12 END) - 
           SUM(CASE WHEN churn = 1 THEN avg_additional_charges_total * lifetime END)), 0) AS ltv_uplift_opportunity

FROM gym_customers;

-- ================================================================
-- SEGMENT PERFORMANCE ANALYSIS
-- ================================================================

-- Business performance by customer segments
SELECT 
    CASE 
        WHEN avg_additional_charges_total >= 200 AND contract_period >= 12 AND churn = 0 THEN 'Premium_VIP'
        WHEN avg_additional_charges_total >= 150 AND churn = 0 THEN 'High_Value_Loyal'
        WHEN avg_class_frequency_current_month >= 2.5 AND churn = 0 THEN 'Active_Engaged'
        WHEN churn = 0 AND lifetime >= 6 THEN 'Stable_Long_Term'
        WHEN churn = 1 AND lifetime <= 3 THEN 'Early_Churn'
        WHEN churn = 1 THEN 'Lost_Customer'
        ELSE 'Standard_Customer'
    END AS business_segment,
    
    COUNT(*) AS segment_size,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 1) AS pct_of_customer_base,
    ROUND(AVG(avg_additional_charges_total), 0) AS avg_monthly_revenue,
    ROUND(SUM(avg_additional_charges_total), 0) AS total_monthly_revenue,
    ROUND(SUM(avg_additional_charges_total) * 100.0 / SUM(SUM(avg_additional_charges_total)) OVER(), 1) AS pct_of_total_revenue,
    ROUND(AVG(lifetime), 1) AS avg_tenure_months,
    ROUND(AVG(avg_class_frequency_current_month), 2) AS avg_activity_level,
    ROUND(AVG(churn) * 100, 1) AS churn_rate_pct

FROM gym_customers
GROUP BY business_segment
ORDER BY total_monthly_revenue DESC;

-- ================================================================
-- ACQUISITION CHANNEL ROI ANALYSIS
-- ================================================================

-- Compare performance and ROI across acquisition channels
SELECT 
    CASE 
        WHEN partner = 0 AND promo_friends = 0 THEN 'Organic_Acquisition'
        WHEN partner = 1 AND promo_friends = 0 THEN 'Corporate_Partner'
        WHEN partner = 0 AND promo_friends = 1 THEN 'Friend_Referral'
        WHEN partner = 1 AND promo_friends = 1 THEN 'Partner_Plus_Referral'
    END AS acquisition_channel,
    
    COUNT(*) AS customers_acquired,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 1) AS pct_of_acquisitions,
    ROUND(AVG(churn) * 100, 1) AS churn_rate_pct,
    ROUND(AVG(lifetime), 1) AS avg_tenure_months,
    ROUND(AVG(avg_additional_charges_total), 0) AS avg_monthly_revenue,
    ROUND(SUM(avg_additional_charges_total), 0) AS total_monthly_revenue,
    
    -- Channel efficiency metrics
    ROUND(AVG(avg_additional_charges_total * lifetime), 0) AS avg_customer_ltv,
    ROUND(SUM(avg_additional_charges_total * lifetime), 0) AS total_ltv_by_channel,
    ROUND(AVG(contract_period), 1) AS avg_commitment_months,
    ROUND(AVG(CASE WHEN group_visits = 1 THEN 1.0 ELSE 0.0 END) * 100, 1) AS group_participation_rate,
    
    -- ROI indicators (higher LTV, lower churn = better ROI)
    CASE 
        WHEN AVG(churn) < 0.2 AND AVG(avg_additional_charges_total * lifetime) > 500 THEN 'Excellent_ROI'
        WHEN AVG(churn) < 0.3 AND AVG(avg_additional_charges_total * lifetime) > 300 THEN 'Good_ROI'
        WHEN AVG(churn) < 0.4 THEN 'Fair_ROI'
        ELSE 'Poor_ROI'
    END AS channel_roi_assessment

FROM gym_customers
GROUP BY acquisition_channel
ORDER BY total_ltv_by_channel DESC;

-- ================================================================
-- PREDICTIVE BUSINESS METRICS
-- ================================================================

-- Forward-looking metrics for strategic planning
WITH risk_assessment AS (
    SELECT *,
        CASE 
            WHEN avg_class_frequency_current_month < 1 AND lifetime <= 3 THEN 'High_Risk'
            WHEN avg_class_frequency_current_month < 1.5 AND contract_period <= 3 THEN 'Medium_Risk'
            WHEN avg_class_frequency_current_month >= 2.5 AND contract_period >= 12 THEN 'Low_Risk'
            ELSE 'Standard_Risk'
        END AS risk_category
    FROM gym_customers
)

SELECT 
    risk_category,
    COUNT(*) AS customers_in_category,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 1) AS pct_of_base,
    ROUND(AVG(churn) * 100, 1) AS current_churn_rate,
    ROUND(SUM(avg_additional_charges_total), 0) AS monthly_revenue_at_risk,
    ROUND(SUM(avg_additional_charges_total) * 12, 0) AS annual_revenue_at_risk,
    
    -- Intervention impact projections
    ROUND(SUM(avg_additional_charges_total) * 
          CASE 
              WHEN risk_category = 'High_Risk' THEN 0.6  -- 60% retention possible
              WHEN risk_category = 'Medium_Risk' THEN 0.8  -- 80% retention possible
              ELSE 0.95  -- 95% retention for low risk
          END, 0) AS projected_retained_revenue,
          
    ROUND(SUM(avg_additional_charges_total) * 
          (CASE 
              WHEN risk_category = 'High_Risk' THEN 0.6
              WHEN risk_category = 'Medium_Risk' THEN 0.8
              ELSE 0.95
          END - (1 - AVG(churn))), 0) AS revenue_improvement_opportunity

FROM risk_assessment
GROUP BY risk_category
ORDER BY annual_revenue_at_risk DESC;

-- ================================================================
-- OPERATIONAL EFFICIENCY METRICS
-- ================================================================

-- Metrics for operational optimization
SELECT 
    'CONTRACT_EFFICIENCY' AS metric_type,
    COUNT(CASE WHEN contract_period = 1 THEN 1 END) AS monthly_contracts,
    COUNT(CASE WHEN contract_period BETWEEN 3 AND 6 THEN 1 END) AS short_term_contracts,
    COUNT(CASE WHEN contract_period = 12 THEN 1 END) AS annual_contracts,
    
    -- Contract performance
    ROUND(AVG(CASE WHEN contract_period = 1 THEN churn END) * 100, 1) AS monthly_churn_rate,
    ROUND(AVG(CASE WHEN contract_period = 12 THEN churn END) * 100, 1) AS annual_churn_rate,
    ROUND(AVG(CASE WHEN contract_period = 12 THEN avg_additional_charges_total END), 0) AS annual_avg_revenue,
    ROUND(AVG(CASE WHEN contract_period = 1 THEN avg_additional_charges_total END), 0) AS monthly_avg_revenue

FROM gym_customers

UNION ALL

SELECT 
    'FACILITY_UTILIZATION' AS metric_type,
    COUNT(CASE WHEN near_location = 1 THEN 1 END) AS customers_near_facility,
    COUNT(CASE WHEN near_location = 0 THEN 1 END) AS customers_far_facility,
    COUNT(CASE WHEN group_visits = 1 THEN 1 END) AS group_class_users,
    
    -- Utilization efficiency
    ROUND(AVG(CASE WHEN near_location = 1 THEN churn END) * 100, 1) AS near_facility_churn,
    ROUND(AVG(CASE WHEN near_location = 0 THEN churn END) * 100, 1) AS far_facility_churn,
    ROUND(AVG(CASE WHEN group_visits = 1 THEN avg_class_frequency_current_month END), 2) AS group_user_frequency,
    ROUND(AVG(CASE WHEN group_visits = 0 THEN avg_class_frequency_current_month END), 2) AS individual_user_frequency

FROM gym_customers

UNION ALL

SELECT 
    'CUSTOMER_SERVICE_IMPACT' AS metric_type,
    COUNT(CASE WHEN phone = 1 THEN 1 END) AS customers_with_phone,
    COUNT(CASE WHEN phone = 0 THEN 1 END) AS customers_without_phone,
    COUNT(CASE WHEN month_to_end_contract <= 2 THEN 1 END) AS contracts_expiring_soon,
    
    -- Service opportunity
    ROUND(AVG(CASE WHEN phone = 1 THEN churn END) * 100, 1) AS phone_contact_churn,
    ROUND(AVG(CASE WHEN phone = 0 THEN churn END) * 100, 1) AS no_phone_contact_churn,
    ROUND(AVG(CASE WHEN month_to_end_contract <= 2 THEN churn END) * 100, 1) AS expiring_contract_churn,
    COUNT(CASE WHEN month_to_end_contract <= 2 AND churn = 0 THEN 1 END) AS renewal_opportunities

FROM gym_customers;
