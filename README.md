# 📊 Project 1 - Business Sales Intelligence Dashboard

> End-to-end sales analytics for a 5,000-transaction, multi-region electronics business.
> Built to demonstrate: **SQL + Python EDA + Excel dashboarding + live web dashboard**.

---

## 🔥 Live Demo

Open `dashboard/index.html` in any browser — fully interactive, no server needed.
Filter by year, explore region/product/trend charts, read auto-generated insights.

---

## 📁 Project Structure

```
project1-sales-dashboard/
│
├── data/
│   ├── sales_data.csv                  ← 5,000 raw transactions
│   └── Project1_Sales_Dashboard.xlsx   ← Formatted Excel dashboard
│
├── notebooks/
│   ├── 01_generate_data.py             ← Synthetic data generator
│   ├── 02_eda_analysis.py              ← Full EDA: 5 charts → reports/
│   └── 03_build_excel.py               ← Excel dashboard builder
│
├── sql/
│   └── sales_queries.sql               ← 20+ production SQL queries
│
├── dashboard/
│   └── index.html                      ← Interactive web dashboard
│
├── reports/                            ← Auto-generated PNG charts (run EDA script)
│
├── requirements.txt
└── README.md
```

---

## 🛠 Tech Stack

| Layer | Tools |
|-------|-------|
| Data Generation | Python (NumPy, Pandas) |
| EDA & Visualization | Pandas, Matplotlib, Seaborn |
| Excel Dashboard | openpyxl (formulas, charts, conditional formatting) |
| SQL Analysis | PostgreSQL-compatible SQL (20+ queries) |
| Web Dashboard | Chart.js, HTML/CSS/JS (no framework needed) |

---

## ⚡ Quick Start

```bash
# 1. Install dependencies
pip install -r requirements.txt

# 2. (Optional) Re-generate data
python notebooks/01_generate_data.py

# 3. Run full EDA — saves 5 charts to reports/
python notebooks/02_eda_analysis.py

# 4. Open the live dashboard
open dashboard/index.html
```

---

## 📊 Key Metrics & Insights

| KPI | Value |
|-----|-------|
| Total Revenue | ₹134.4 Cr |
| Net Profit | ₹53.4 Cr |
| Profit Margin | 39.7% |
| Total Orders | 5,000 |
| Avg Order Value | ₹2.69L |
| Unique Customers | 500 |

### 💡 Business Insights Uncovered

1. **Q4 Seasonality** — Revenue spikes +15% in Q4 (Oct–Dec) driven by Laptop and Smartphone demand during festive season. Recommend pre-stocking 3x inventory by September.

2. **East Region Leads** — East region achieves 40.2% profit margin vs 38.9% (South, lowest). Reallocating 10% of South marketing budget to East campaigns could yield ₹1.8 Cr additional profit.

3. **Headphones Hidden Gem** — Highest margin product (47.6%) yet only 9.2% revenue share. Targeted upsell to existing Electronics buyers could grow this segment by 25%.

4. **Q3 Consistent Dip** — Q3 shows the lowest revenue in both 2022 and 2023. Root cause: slower corporate procurement in July–August. Recommendation: B2C promotional campaigns in August.

5. **Webcam Declining** — Only product with negative YoY growth (-3.2%). Post-pandemic demand normalization. Recommend inventory reduction and bundle pricing with new Laptop sales.

---

## 🗄 SQL Highlights

The `sql/sales_queries.sql` file contains 20+ production-grade queries including:

- **KPI Summary** — Revenue, profit, margin, AOV in one query
- **YoY Comparison** with window functions
- **QoQ Growth** using LAG() and PARTITION BY
- **Region × Year Pivot** — cross-tab with CASE WHEN
- **80/20 Analysis** — cumulative revenue ranking
- **Seasonal Demand** — Q4 uplift vs quarterly average
- **Running YTD** — cumulative revenue with window functions

---

## 📈 Charts Generated (EDA Script)

| File | Description |
|------|-------------|
| `01_quarterly_trend.png` | Revenue/Profit bar + QoQ growth |
| `02_region_performance.png` | Revenue, margin, order volume by region |
| `03_product_performance.png` | Product revenue + margin scatter |
| `04_monthly_heatmap.png` | Monthly revenue heatmap (year × month) |
| `05_salesperson_leaderboard.png` | Top 10 salesperson ranking |

---

## 📌 Interview Talking Points

- "I built the dataset generator to simulate realistic seasonality and regional pricing multipliers"
- "The SQL file includes window functions (LAG, RANK, SUM OVER PARTITION) to show I can handle real warehouse queries"
- "The web dashboard uses year-level filters that update all 4 charts simultaneously — I built this to show I understand UX for non-technical stakeholders"
- "The Excel workbook uses live IFERROR formulas so KPIs update automatically when data changes"

---


