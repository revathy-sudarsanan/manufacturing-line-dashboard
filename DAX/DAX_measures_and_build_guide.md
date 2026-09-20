# Power BI Build Guide — Manufacturing Production Quality & Risk Dashboard (Full Dataset)

Data source: `data/production_batches_full.csv` (Kaggle's "Predicting Manufacturing Defects
Dataset" by rabieelkharoua — 3,240 production runs, all 17 metric columns).

---

## 1. Load the data

1. Open **Power BI Desktop** → `Get Data` → `Text/CSV` → select `production_batches_full.csv`.
2. Click **Transform Data**.

## 2. Clean in Power Query

1. Confirm types: whole numbers for `run_id`, `production_volume`, `delivery_delay`,
   `maintenance_hours`, `safety_incidents`, `defect_status`; decimal for the rest of the metrics;
   text for `production_volume_bin`, `supplier_quality_tier`, `defect_risk_flag`,
   `defect_status_label`.
2. No further transforms needed — bins/tiers/flags are pre-computed in the CSV.
3. Close & Apply.

## 3. Data model

Single flat table, no relationships needed (same as before — one row per production run).

## 4. Create these DAX measures

```DAX
Total Runs = COUNTROWS(production_batches)

Avg Defect Rate = AVERAGE(production_batches[defect_rate])

Pct Flagged Defective =
DIVIDE(SUM(production_batches[defect_status]), [Total Runs])

Avg Quality Score = AVERAGE(production_batches[quality_score])

Avg Downtime % = AVERAGE(production_batches[downtime_percentage])

High Risk Run % =
DIVIDE(
    CALCULATE(COUNTROWS(production_batches), production_batches[defect_risk_flag] = "High Risk"),
    [Total Runs]
)

Avg Cost Per Unit =
DIVIDE(
    AVERAGE(production_batches[production_cost]),
    AVERAGE(production_batches[production_volume])
)

Avg Worker Productivity = AVERAGE(production_batches[worker_productivity])

Total Safety Incidents = SUM(production_batches[safety_incidents])

Avg Energy Efficiency = AVERAGE(production_batches[energy_efficiency])

Avg Energy Consumption = AVERAGE(production_batches[energy_consumption])
```

## 5. Build the report pages

**Page 1 — Executive Overview**
- KPI cards: `Total Runs`, `Avg Defect Rate`, `Pct Flagged Defective`, `High Risk Run %`
- Scatter: `supplier_quality` (x) vs `defect_rate` (y), colored by `defect_risk_flag`
- Bar: `Avg Defect Rate` by `production_volume_bin`

**Page 2 — Quality Risk Drivers**
- Bar: `Avg Defect Rate` by `supplier_quality_tier`
- Bar: `Avg Downtime %` by maintenance-hours bucket
- Table: top 20 `High Risk` runs

**Page 3 — Supply Chain & Inventory**
- Scatter: `stockout_rate` vs `defect_rate`
- Bar: `Avg Inventory Turnover` by stockout risk band
- Bar: `Avg Defect Rate` by `delivery_delay`

**Page 4 — People & Safety** *(new — uses the extra columns)*
- Bar: `Avg Defect Rate` by worker-productivity band
- Scatter: `safety_incidents` (x) vs `downtime_percentage` (y)
- KPI card: `Total Safety Incidents`

**Page 5 — Energy & Cost Efficiency** *(new)*
- Scatter: `energy_efficiency` (x) vs `defect_rate` (y)
- Bar: `Avg Energy Consumption` by efficiency band
- Scatter: `Avg Cost Per Unit` vs `defect_rate` (worst-of-both-worlds view)

## 6. Add slicers

Slicer panel for `production_volume_bin`, `supplier_quality_tier`, `defect_risk_flag`, and
`defect_status_label` on every page.

## 7. Polish

- Consistent red/amber/green scheme tied to `defect_risk_flag`.
- Title + data-source credit + "portfolio project" note.
- Export a PDF snapshot for the README; save the `.pbix`.

## 8. Optional next step — predictive extension

`defect_status` is the dataset's original binary label (0/1). This BI project stops at
descriptive/diagnostic analysis (what happened and why), but if you want to extend it later,
`defect_status` is exactly what you'd use as the target variable for a logistic regression or
classification model in Python — a natural "Phase 2" to mention in an interview if asked how
you'd take this further.

## 9. What to say about it in interviews

> "I used a public Kaggle manufacturing dataset — production runs with supplier quality,
> downtime, worker productivity, safety incidents, and energy metrics — and built a SQL layer to
> segment runs by risk, then a 5-page Power BI report testing which operational factors actually
> correlate with defects. The supplier-quality scatter plot was the clearest signal; I also found
> [mention whichever pattern the data actually shows once you've built it, e.g. worker
> productivity vs. defect rate] which I hadn't expected going in."
