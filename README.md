# Manufacturing Production Quality & Risk Dashboard

**SQL · Power BI · DAX · Root-Cause Analysis · Risk Segmentation**

A portfolio project analyzing 3,240 real manufacturing production runs — covering supplier
quality, production volume, maintenance, inventory, worker productivity, safety, and energy
metrics — to identify what actually drives defect rates, using SQL for analysis and Power
BI/DAX for interactive reporting.

## Data Source

[**"Predicting Manufacturing Defects Dataset"**](https://www.kaggle.com/) by rabieelkharoua,
via Kaggle — full column set: production volume, cost, supplier quality, delivery delay, defect
rate, quality score, maintenance hours, downtime %, inventory turnover, stockout rate, worker
productivity, safety incidents, energy consumption/efficiency, additive process time/cost, and
defect status (binary outcome label). Used here for portfolio/learning purposes — full credit
to the original dataset author.

## Business Questions Answered

1. **Supplier quality**: Does a lower supplier quality score correlate with a higher defect rate?
2. **Production scale**: Do higher-volume runs have better or worse defect rates?
3. **Maintenance**: Does more maintenance time correlate with lower downtime and fewer defects?
4. **Supply chain risk**: How do stockout rate and inventory turnover relate to quality?
5. **Cost efficiency**: Which runs are both expensive per unit *and* defect-prone?
6. **People & safety**: Does worker productivity trade off against defect rate, and do safety
   incidents track with operational downtime?
7. **Energy**: Does energy efficiency relate to cost or quality outcomes?

## Project Structure

```
manufacturing-line-dashboard/
├── README.md
├── data/
│   └── production_batches_full.csv   # 3,240 production runs, all 17 metrics + derived columns
├── sql/
│   ├── 01_schema.sql                  # table definition
│   └── 02_analysis_queries.sql        # 12 analysis queries
└── powerbi/
    └── DAX_measures_and_build_guide.md  # 5-page report build guide + DAX measures
```

## Methodology

1. **Data prep**: Combined the dataset's full column set, added a `run_id` primary key, and
   three derived analytical columns: `production_volume_bin` (quintiles), `supplier_quality_tier`
   (Poor/Fair/Good/Excellent), and `defect_risk_flag` (quartile-based Low/Medium/High Risk on
   defect rate).
2. **SQL analysis**: 12 queries covering defect-rate drivers across supplier quality, volume,
   maintenance, inventory, delivery delay, worker productivity, safety, and energy efficiency,
   plus a high-risk-run drilldown and an overall KPI summary (see `sql/02_analysis_queries.sql`).
3. **Power BI reporting layer**: 5-page report (Executive Overview, Quality Risk Drivers, Supply
   Chain & Inventory, People & Safety, Energy & Cost Efficiency) with DAX measures for defect
   rate, flagged-defect %, high-risk run %, and cost-per-unit — full build steps in
   `powerbi/DAX_measures_and_build_guide.md`.

## Key Skills Demonstrated

- SQL: aggregation, CASE-based bucketing, multi-dimensional risk segmentation
- Power BI / DAX: measures, scatter-plot driver analysis, risk-flag slicing across 5 report pages
- Root-cause / driver analysis: isolating which operational, people, and energy factors move
  defect rate
- Data preparation: merging column subsets, adding derived bins/tiers/risk flags
- Business storytelling: translating a flat dataset into a decision-ready risk dashboard

## How to Reproduce

1. Clone this repo.
2. Load `data/production_batches_full.csv` into any SQL engine using `sql/01_schema.sql`, then
   run the queries in `sql/02_analysis_queries.sql`.
3. Follow `powerbi/DAX_measures_and_build_guide.md` to build the Power BI report from the CSV.

---
Built by Revathy Sudarsanan Sheeba — [LinkedIn](#) · [Portfolio](#)
