"""
PROJECT 1 — SALES DASHBOARD
Script 02: Exploratory Data Analysis
Full EDA with charts saved to reports/
"""

import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.ticker as mticker
import seaborn as sns
import os
import sys
import warnings
warnings.filterwarnings('ignore')

if hasattr(sys.stdout, 'reconfigure'):
    sys.stdout.reconfigure(encoding='utf-8')

# ── Config ────────────────────────────────────────────────────────────────────
BASE_DIR     = os.path.dirname(os.path.abspath(__file__))
DATA_PATH    = os.path.join(BASE_DIR, 'sales_data.csv')
REPORTS_PATH = os.path.join(BASE_DIR, 'reports')
os.makedirs(REPORTS_PATH, exist_ok=True)

PALETTE = ['#1a56db', '#0e9f6e', '#e3a008', '#e02424', '#7c3aed']
sns.set_theme(style='whitegrid', palette=PALETTE)
plt.rcParams.update({'font.family': 'DejaVu Sans', 'figure.dpi': 150})

# ── Load ──────────────────────────────────────────────────────────────────────
df = pd.read_csv(DATA_PATH, parse_dates=['Date'])
print(f"Loaded {len(df):,} rows × {len(df.columns)} columns")
print(df.dtypes)
print("\nSummary:")
print(df[['Revenue', 'Profit', 'Quantity']].describe().round(2))


# ─────────────────────────────────────────────────────────────────────────────
# 1. Revenue & Profit Overview
# ─────────────────────────────────────────────────────────────────────────────
def kpi_summary():
    total_rev  = df['Revenue'].sum()
    total_prof = df['Profit'].sum()
    margin     = total_prof / total_rev * 100
    orders     = len(df)
    aov        = total_rev / orders
    customers  = df['CustomerID'].nunique()

    print("\n" + "=" * 50)
    print("  KEY PERFORMANCE INDICATORS")
    print("=" * 50)
    print(f"  Total Revenue    : ₹{total_rev:>15,.0f}")
    print(f"  Total Profit     : ₹{total_prof:>15,.0f}")
    print(f"  Profit Margin    : {margin:>14.1f}%")
    print(f"  Total Orders     : {orders:>15,}")
    print(f"  Avg Order Value  : ₹{aov:>15,.0f}")
    print(f"  Unique Customers : {customers:>15,}")
    print("=" * 50)


kpi_summary()


# ─────────────────────────────────────────────────────────────────────────────
# 2. Quarterly Trend
# ─────────────────────────────────────────────────────────────────────────────
def plot_quarterly_trend():
    df['YearQ'] = df['Year'].astype(str) + '-' + df['Quarter']
    qt = (df.groupby('YearQ')
            .agg(Revenue=('Revenue', 'sum'), Profit=('Profit', 'sum'))
            .reset_index()
            .sort_values('YearQ'))
    qt['Margin%'] = qt['Profit'] / qt['Revenue'] * 100
    qt['QoQ_Growth'] = qt['Revenue'].pct_change() * 100

    fig, axes = plt.subplots(1, 2, figsize=(14, 5))
    fig.suptitle('Quarterly Revenue & Profit Trend', fontsize=14, fontweight='bold', y=1.01)

    x = range(len(qt))
    w = 0.35
    axes[0].bar([i - w/2 for i in x], qt['Revenue'] / 1e7, w, label='Revenue (₹ Cr)', color=PALETTE[0], alpha=0.9)
    axes[0].bar([i + w/2 for i in x], qt['Profit'] / 1e7, w, label='Profit (₹ Cr)', color=PALETTE[1], alpha=0.9)
    axes[0].set_xticks(list(x))
    axes[0].set_xticklabels(qt['YearQ'], rotation=35, ha='right', fontsize=9)
    axes[0].set_ylabel('₹ Crore')
    axes[0].legend(fontsize=9)
    axes[0].set_title('Revenue vs Profit per Quarter')
    axes[0].yaxis.set_major_formatter(mticker.FuncFormatter(lambda v, _: f'₹{v:.0f}Cr'))

    color_map = [PALETTE[1] if g >= 0 else PALETTE[3] for g in qt['QoQ_Growth'].fillna(0)]
    axes[1].bar(list(x), qt['QoQ_Growth'].fillna(0), color=color_map, alpha=0.9)
    axes[1].axhline(0, color='black', linewidth=0.8, linestyle='--')
    axes[1].set_xticks(list(x))
    axes[1].set_xticklabels(qt['YearQ'], rotation=35, ha='right', fontsize=9)
    axes[1].set_ylabel('QoQ Growth %')
    axes[1].set_title('Quarter-on-Quarter Revenue Growth')
    axes[1].yaxis.set_major_formatter(mticker.FuncFormatter(lambda v, _: f'{v:.1f}%'))

    plt.tight_layout()
    plt.savefig(os.path.join(REPORTS_PATH, '01_quarterly_trend.png'), bbox_inches='tight')
    plt.close()
    print("✅ Saved: 01_quarterly_trend.png")


plot_quarterly_trend()


# ─────────────────────────────────────────────────────────────────────────────
# 3. Region Performance
# ─────────────────────────────────────────────────────────────────────────────
def plot_region_performance():
    region = (df.groupby('Region')
                .agg(Revenue=('Revenue', 'sum'), Profit=('Profit', 'sum'), Orders=('OrderID', 'count'))
                .assign(Margin=lambda x: x['Profit'] / x['Revenue'] * 100)
                .sort_values('Revenue', ascending=False)
                .reset_index())

    fig, axes = plt.subplots(1, 3, figsize=(15, 5))
    fig.suptitle('Region-Wise Performance Analysis', fontsize=14, fontweight='bold')

    axes[0].barh(region['Region'], region['Revenue'] / 1e7, color=PALETTE[:5], alpha=0.9)
    axes[0].set_xlabel('₹ Crore')
    axes[0].set_title('Revenue by Region')
    axes[0].xaxis.set_major_formatter(mticker.FuncFormatter(lambda v, _: f'₹{v:.0f}Cr'))
    for i, v in enumerate(region['Revenue'] / 1e7):
        axes[0].text(v + 0.1, i, f'₹{v:.1f}Cr', va='center', fontsize=9)

    axes[1].bar(region['Region'], region['Margin'], color=[PALETTE[1] if m == region['Margin'].max() else '#d1d5db' for m in region['Margin']], alpha=0.9)
    axes[1].set_ylabel('Profit Margin %')
    axes[1].set_title('Profit Margin by Region')
    axes[1].yaxis.set_major_formatter(mticker.FuncFormatter(lambda v, _: f'{v:.1f}%'))
    for i, v in enumerate(region['Margin']):
        axes[1].text(i, v + 0.1, f'{v:.1f}%', ha='center', fontsize=9)

    axes[2].bar(region['Region'], region['Orders'], color=PALETTE[2], alpha=0.9)
    axes[2].set_ylabel('Number of Orders')
    axes[2].set_title('Order Volume by Region')
    for i, v in enumerate(region['Orders']):
        axes[2].text(i, v + 5, str(v), ha='center', fontsize=9)

    plt.tight_layout()
    plt.savefig(os.path.join(REPORTS_PATH, '02_region_performance.png'), bbox_inches='tight')
    plt.close()
    print("✅ Saved: 02_region_performance.png")


plot_region_performance()


# ─────────────────────────────────────────────────────────────────────────────
# 4. Product Performance
# ─────────────────────────────────────────────────────────────────────────────
def plot_product_performance():
    prod = (df.groupby('Product')
              .agg(Revenue=('Revenue', 'sum'), Profit=('Profit', 'sum'), Qty=('Quantity', 'sum'))
              .assign(Margin=lambda x: x['Profit'] / x['Revenue'] * 100)
              .sort_values('Revenue', ascending=True)
              .reset_index())

    fig, axes = plt.subplots(1, 2, figsize=(14, 6))
    fig.suptitle('Product Performance Analysis', fontsize=14, fontweight='bold')

    colors = [PALETTE[0] if p == prod['Revenue'].max() else '#93c5fd' for p in prod['Revenue']]
    axes[0].barh(prod['Product'], prod['Revenue'] / 1e7, color=colors, alpha=0.9)
    axes[0].set_xlabel('₹ Crore')
    axes[0].set_title('Revenue by Product')
    for i, v in enumerate(prod['Revenue'] / 1e7):
        axes[0].text(v + 0.05, i, f'₹{v:.1f}Cr', va='center', fontsize=8)

    scatter = axes[1].scatter(prod['Revenue'] / 1e7, prod['Margin'],
                               s=prod['Qty'] / 50, c=range(len(prod)),
                               cmap='Blues', alpha=0.8, edgecolors='navy', linewidths=0.6)
    for _, row in prod.iterrows():
        axes[1].annotate(row['Product'], (row['Revenue'] / 1e7, row['Margin']),
                          textcoords='offset points', xytext=(5, 4), fontsize=8)
    axes[1].set_xlabel('Revenue (₹ Crore)')
    axes[1].set_ylabel('Profit Margin %')
    axes[1].set_title('Revenue vs Margin (bubble = units sold)')

    plt.tight_layout()
    plt.savefig(os.path.join(REPORTS_PATH, '03_product_performance.png'), bbox_inches='tight')
    plt.close()
    print("✅ Saved: 03_product_performance.png")


plot_product_performance()


# ─────────────────────────────────────────────────────────────────────────────
# 5. Monthly Revenue Heatmap
# ─────────────────────────────────────────────────────────────────────────────
def plot_monthly_heatmap():
    pivot = df.pivot_table(values='Revenue', index='Year', columns='Month', aggfunc='sum') / 1e6
    pivot.columns = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                     'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']

    fig, ax = plt.subplots(figsize=(14, 4))
    sns.heatmap(pivot, annot=True, fmt='.1f', cmap='Blues',
                linewidths=0.5, ax=ax, cbar_kws={'label': '₹ Millions'})
    ax.set_title('Monthly Revenue Heatmap (₹ Millions)', fontsize=13, fontweight='bold')
    ax.set_ylabel('Year')
    plt.tight_layout()
    plt.savefig(os.path.join(REPORTS_PATH, '04_monthly_heatmap.png'), bbox_inches='tight')
    plt.close()
    print("✅ Saved: 04_monthly_heatmap.png")


plot_monthly_heatmap()


# ─────────────────────────────────────────────────────────────────────────────
# 6. Salesperson Leaderboard
# ─────────────────────────────────────────────────────────────────────────────
def plot_salesperson_leaderboard():
    sp = (df.groupby('Salesperson')
            .agg(Revenue=('Revenue', 'sum'), Orders=('OrderID', 'count'))
            .sort_values('Revenue', ascending=False)
            .head(10)
            .reset_index())

    fig, ax = plt.subplots(figsize=(10, 6))
    colors = [PALETTE[0]] + ['#93c5fd'] * 9
    bars = ax.barh(sp['Salesperson'][::-1], sp['Revenue'][::-1] / 1e6, color=colors[::-1], alpha=0.9)
    ax.set_xlabel('Revenue (₹ Millions)')
    ax.set_title('Top 10 Salesperson Leaderboard', fontsize=13, fontweight='bold')
    for bar, rev in zip(bars, sp['Revenue'][::-1] / 1e6):
        ax.text(bar.get_width() + 0.2, bar.get_y() + bar.get_height() / 2,
                f'₹{rev:.1f}M', va='center', fontsize=9)
    plt.tight_layout()
    plt.savefig(os.path.join(REPORTS_PATH, '05_salesperson_leaderboard.png'), bbox_inches='tight')
    plt.close()
    print("✅ Saved: 05_salesperson_leaderboard.png")


plot_salesperson_leaderboard()

print("\n✅ EDA complete. All charts saved to reports/")
