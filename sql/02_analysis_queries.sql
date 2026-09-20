-- ============================================================
-- Manufacturing Production Quality & Risk Dashboard (Full Dataset)
-- Core analysis queries
-- ============================================================

-- 1. DEFECT RATE BY SUPPLIER QUALITY TIER
SELECT
    supplier_quality_tier,
    COUNT(*)                                    AS num_runs,
    ROUND(AVG(defect_rate), 3)                  AS avg_defect_rate,
    ROUND(AVG(quality_score), 2)                 AS avg_quality_score
FROM production_batches
GROUP BY supplier_quality_tier
ORDER BY avg_defect_rate DESC;


-- 2. DEFECT RATE BY PRODUCTION VOLUME TIER
SELECT
    production_volume_bin,
    COUNT(*)                                    AS num_runs,
    ROUND(AVG(defect_rate), 3)                  AS avg_defect_rate,
    ROUND(AVG(downtime_percentage), 3)           AS avg_downtime_pct
FROM production_batches
GROUP BY production_volume_bin
ORDER BY
    CASE production_volume_bin
        WHEN 'Very Low' THEN 1 WHEN 'Low' THEN 2 WHEN 'Medium' THEN 3
        WHEN 'High' THEN 4 WHEN 'Very High' THEN 5 END;


-- 3. HIGH-RISK RUNS: worst combination of defect rate + downtime + low supplier quality
SELECT
    run_id, production_volume, supplier_quality, defect_rate,
    downtime_percentage, maintenance_hours, defect_risk_flag
FROM production_batches
WHERE defect_risk_flag = 'High Risk'
ORDER BY defect_rate DESC, downtime_percentage DESC
LIMIT 50;


-- 4. MAINTENANCE HOURS vs. DOWNTIME
SELECT
    CASE
        WHEN maintenance_hours < 5  THEN '0-4 hrs'
        WHEN maintenance_hours < 10 THEN '5-9 hrs'
        WHEN maintenance_hours < 15 THEN '10-14 hrs'
        ELSE '15+ hrs'
    END                                          AS maintenance_bucket,
    COUNT(*)                                     AS num_runs,
    ROUND(AVG(downtime_percentage), 4)           AS avg_downtime_pct,
    ROUND(AVG(defect_rate), 3)                   AS avg_defect_rate
FROM production_batches
GROUP BY 1
ORDER BY 1;


-- 5. INVENTORY RISK: stockout rate vs. inventory turnover vs. defect rate
SELECT
    CASE
        WHEN stockout_rate < 0.03 THEN 'Low Stockout Risk'
        WHEN stockout_rate < 0.07 THEN 'Medium Stockout Risk'
        ELSE 'High Stockout Risk'
    END                                          AS stockout_risk_band,
    COUNT(*)                                     AS num_runs,
    ROUND(AVG(inventory_turnover), 2)             AS avg_inventory_turnover,
    ROUND(AVG(defect_rate), 3)                   AS avg_defect_rate
FROM production_batches
GROUP BY 1
ORDER BY avg_defect_rate DESC;


-- 6. DELIVERY DELAY IMPACT
SELECT
    delivery_delay,
    COUNT(*)                                     AS num_runs,
    ROUND(AVG(defect_rate), 3)                   AS avg_defect_rate,
    ROUND(AVG(quality_score), 2)                  AS avg_quality_score
FROM production_batches
GROUP BY delivery_delay
ORDER BY delivery_delay;


-- 7. COST EFFICIENCY: cost per unit vs. defect rate
SELECT
    run_id, production_volume, production_cost,
    ROUND(production_cost / NULLIF(production_volume, 0), 2)  AS cost_per_unit,
    defect_rate
FROM production_batches
ORDER BY cost_per_unit DESC, defect_rate DESC
LIMIT 50;


-- 8. WORKER PRODUCTIVITY vs. DEFECT RATE
--    Does a more productive workforce mean more rushed, defect-prone output — or the opposite?
SELECT
    CASE
        WHEN worker_productivity < 85  THEN 'Low (80-85)'
        WHEN worker_productivity < 90  THEN 'Medium (85-90)'
        WHEN worker_productivity < 95  THEN 'High (90-95)'
        ELSE 'Very High (95-100)'
    END                                          AS productivity_band,
    COUNT(*)                                     AS num_runs,
    ROUND(AVG(defect_rate), 3)                   AS avg_defect_rate,
    ROUND(AVG(safety_incidents), 2)               AS avg_safety_incidents
FROM production_batches
GROUP BY 1
ORDER BY 1;


-- 9. SAFETY INCIDENTS vs. DOWNTIME & DEFECT RATE
--    Are runs with more safety incidents also operationally worse overall?
SELECT
    safety_incidents,
    COUNT(*)                                     AS num_runs,
    ROUND(AVG(downtime_percentage), 4)           AS avg_downtime_pct,
    ROUND(AVG(defect_rate), 3)                   AS avg_defect_rate
FROM production_batches
GROUP BY safety_incidents
ORDER BY safety_incidents;


-- 10. ENERGY EFFICIENCY vs. COST vs. DEFECT RATE
SELECT
    CASE
        WHEN energy_efficiency < 0.2 THEN 'Low (0.1-0.2)'
        WHEN energy_efficiency < 0.3 THEN 'Medium (0.2-0.3)'
        WHEN energy_efficiency < 0.4 THEN 'High (0.3-0.4)'
        ELSE 'Very High (0.4-0.5)'
    END                                          AS efficiency_band,
    COUNT(*)                                     AS num_runs,
    ROUND(AVG(energy_consumption), 0)             AS avg_energy_consumption,
    ROUND(AVG(defect_rate), 3)                   AS avg_defect_rate
FROM production_batches
GROUP BY 1
ORDER BY 1;


-- 11. DEFECT STATUS RATE (the dataset's binary outcome label) BY SUPPLIER QUALITY TIER
--     A simple validation check: does the binary flag agree with the continuous defect_rate story?
SELECT
    supplier_quality_tier,
    COUNT(*)                                     AS num_runs,
    SUM(defect_status)                            AS runs_flagged_defective,
    ROUND(100.0 * SUM(defect_status) / COUNT(*), 2) AS pct_flagged_defective
FROM production_batches
GROUP BY supplier_quality_tier
ORDER BY pct_flagged_defective DESC;


-- 12. OVERALL SUMMARY (dashboard top KPI cards)
SELECT
    COUNT(*)                                     AS total_runs,
    ROUND(AVG(defect_rate), 3)                   AS overall_avg_defect_rate,
    ROUND(100.0 * SUM(defect_status) / COUNT(*), 2) AS pct_runs_flagged_defective,
    ROUND(AVG(quality_score), 2)                  AS overall_avg_quality_score,
    ROUND(AVG(downtime_percentage), 4)            AS overall_avg_downtime_pct,
    ROUND(AVG(worker_productivity), 2)             AS overall_avg_worker_productivity,
    SUM(safety_incidents)                          AS total_safety_incidents,
    SUM(CASE WHEN defect_risk_flag = 'High Risk' THEN 1 ELSE 0 END) AS high_risk_run_count
FROM production_batches;
