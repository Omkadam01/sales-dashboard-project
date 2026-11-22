# Business Sales Dashboard

End-to-end sales analytics project covering 5,000 transactions across 5 regions and 8 products for FY 2022-2023. Built to demonstrate the full data analyst workflow from raw data to business insights.

---

## Files

| File | Description |
|------|-------------|
| `sales_data.csv` | 5,000 raw sales transactions |
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
| Web Dashboard | Chart.js, HTML, CSS, JavaScript |

---

## Quick Start

```bash
pip install -r requirements.txt
python analysis.py
```

Open `dashboard.html` in a browser to explore the interactive charts.

## Live Demo

[Open the Sales Dashboard](https://omkadam01.github.io/sales-dashboard-project/)

The dashboard is a static GitHub Pages site. It does not require a backend,
database, environment variables, or build command. For a local preview, run
`python -m http.server 8000` from the repository root and open
`http://localhost:8000/`. Chart.js and the two web fonts are loaded from public
CDNs, so an internet connection is required for charts and custom typography.
The site does not collect visitor data.

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

**Q4 Seasonality** — Q4 generated Rs. 38.75 Cr across both years, the strongest quarter in the dataset.

**North Region Leads Revenue** — North generated Rs. 28.83 Cr, followed by East at Rs. 28.25 Cr.

**Mouse Leads Margin** — Mouse has the highest product margin at 49.9%, while Laptop remains the largest product by revenue at Rs. 53.90 Cr.

**Smartphone Growth** — Smartphone revenue increased 20.3% in 2023 versus 2022.

**Monitor Decline** — Monitor revenue decreased 16.4% in 2023, the largest product-level decline in the dataset.

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

End-to-end business sales dashboard — Python EDA, 20+ SQL queries, and interactive HTML visualization.

---


