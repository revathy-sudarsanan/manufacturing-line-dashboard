-- ============================================================
-- Manufacturing Production Quality & Risk Dashboard (Full Dataset)
-- Data source: "Predicting Manufacturing Defects Dataset" (Kaggle, rabieelkharoua)
-- Schema definition
-- ============================================================

CREATE TABLE production_batches (
    run_id                 INT PRIMARY KEY,
    production_volume      INT NOT NULL,
    production_cost        DECIMAL(12,2) NOT NULL,
    supplier_quality       DECIMAL(5,2) NOT NULL,
    delivery_delay         INT NOT NULL,
    defect_rate            DECIMAL(6,4) NOT NULL,
    quality_score           DECIMAL(5,2) NOT NULL,
    maintenance_hours      INT NOT NULL,
    downtime_percentage    DECIMAL(6,4) NOT NULL,
    inventory_turnover     DECIMAL(6,2) NOT NULL,
    stockout_rate          DECIMAL(6,4) NOT NULL,
    worker_productivity    DECIMAL(5,2) NOT NULL,   -- productivity index, 80-100
    safety_incidents       INT NOT NULL,            -- count of safety incidents in the run
    energy_consumption     DECIMAL(10,2) NOT NULL,  -- kWh
    energy_efficiency      DECIMAL(5,4) NOT NULL,   -- 0-1 efficiency ratio
    additive_process_time  DECIMAL(6,2) NOT NULL,   -- hours
    additive_material_cost DECIMAL(10,2) NOT NULL,
    defect_status          INT NOT NULL,            -- 0 = no defect flagged, 1 = defect flagged
    production_volume_bin  VARCHAR(15),
    supplier_quality_tier  VARCHAR(25),
    defect_risk_flag       VARCHAR(15),             -- quartile-based Low/Medium/High Risk on defect_rate
    defect_status_label    VARCHAR(20)              -- "No Defect" / "Defect Flagged"
);

-- Cross-sectional dataset: one row per production run, no date/line/shift dimension.
-- defect_status is the dataset's original binary outcome label (kept alongside the continuous
-- defect_rate metric — useful if this project is later extended into a classification model).
