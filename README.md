# Business Sales Dashboard

End-to-end sales analytics project covering 5,000 transactions across 5 regions and 8 products for FY 2022-2023. Built to demonstrate the full data analyst workflow from raw data to business insights.

---

## Files

| File | Description |
|------|-------------|
| `sales_data.csv` | 5,000 raw sales transactions |
| `sales_dashboard.xlsx` | Formatted Excel dashboard with live KPI formulas |
| `analysis.py` | Python EDA script — generates 5 charts and prints key metrics |
| `queries.sql` | 20+ SQL queries covering KPIs, trends, pivots, and window functions |
| `dashboard.html` | Interactive web dashboard — open in any browser, no server needed |
| `requirements.txt` | Python dependencies |

---

## Tech Stack

| Layer | Tools |
|-------|-------|
| Data and EDA | Python, Pandas, Matplotlib, Seaborn |
| SQL Analysis | PostgreSQL-compatible SQL — window functions, CTEs, pivots |
| Excel Dashboard | openpyxl — live formulas, conditional formatting, charts |
| Web Dashboard | Chart.js, HTML, CSS, JavaScript |

---

## Quick Start

```bash
pip install -r requirements.txt
python analysis.py
```

Open `dashboard.html` in a browser to explore the interactive charts.

---

## Key Results

| Metric | Value |
|--------|-------|
| Total Revenue | Rs. 134.4 Cr |
| Net Profit | Rs. 53.4 Cr |
| Profit Margin | 39.7% |
| Total Orders | 5,000 |
| Avg Order Value | Rs. 2.69L |
| Unique Customers | 500 |

---

## Business Insights

**Q4 Seasonality** — Revenue spikes 15% in Q4 driven by Laptop and Smartphone demand. Pre-stocking 3x inventory by September is recommended.

**East Region Leads** — East achieves 40.2% profit margin versus 38.9% in South. Reallocating 10% of South marketing budget to East could yield Rs. 1.8 Cr additional profit.

**Headphones Opportunity** — Highest margin product at 47.6% but only 9.2% revenue share. Targeted upsell to existing Electronics buyers could grow this segment by 25%.

**Q3 Consistent Dip** — Q3 is the weakest quarter in both years due to slower corporate procurement in July-August. B2C promotional campaigns in August are recommended.

**Webcam Declining** — Only product with negative YoY growth at -3.2%. Inventory reduction and bundle pricing alongside Laptop sales is advised.

---

## SQL Highlights

- KPI summary — revenue, profit, margin, and AOV in a single query
- YoY and QoQ growth using the `LAG()` window function
- Region x Year revenue pivot using `CASE WHEN`
- 80/20 revenue analysis with cumulative ranking
- Running year-to-date total using `SUM() OVER (PARTITION BY year ORDER BY month)`

---

## Repo Name

`sales-dashboard-project`

## Description

End-to-end business sales dashboard — Python EDA, 20+ SQL queries, Excel dashboard, interactive HTML visualization.

---


