# 🛒 Superstore Sales — Data Analysis Project

<div align="center">

![Data Analysis](https://img.shields.io/badge/Data%20Analysis-2026-teal?style=for-the-badge)
![SQL](https://img.shields.io/badge/SQL-Server-blue?style=for-the-badge&logo=microsoftsqlserver)
![Tableau](https://img.shields.io/badge/Tableau-Desktop-orange?style=for-the-badge&logo=tableau)
![Power BI](https://img.shields.io/badge/Power%20BI-Dashboard-yellow?style=for-the-badge&logo=powerbi)
![Python](https://img.shields.io/badge/Python-3.x-green?style=for-the-badge&logo=python)
![Excel](https://img.shields.io/badge/Microsoft-Excel-darkgreen?style=for-the-badge&logo=microsoftexcel)

**Group Two | Digital Egypt Pioneers Initiative × CLS Learning Solutions**

</div>

---

## 📌 Project Overview

This project analyzes **Superstore Sales data** to uncover key business insights, identify loss drivers, and support data-driven decision making. The analysis covers sales performance, profitability, customer behavior, regional trends, discount impact, and return patterns — using a full data analytics pipeline from cleaning to dashboarding.

> *"Turning raw sales data into actionable business strategy."*

---

## 👥 Team Members

| Name | Background | Tools |
|------|-----------|-------|
| **Mohammed Afify** | Accountant (10+ yrs) & Data Analyst (5 yrs) | Power BI, Presentation |
| **Asmaa Ali** | Mathematics & Statistics Graduate | Python, SQL, Tableau |

---

## 🗂️ Dataset Description

### Source
Superstore Sales Dataset — a widely used retail dataset representing a US-based retail chain.

### Size
| Metric | Value |
|--------|-------|
| 📄 Total Rows | **10,000+** records |
| 📊 Total Columns | **23** columns |
| 🗓️ Date Range | **2023 – 2026** |
| 🏢 Total Orders | **5,111** unique orders |
| 👤 Total Customers | **804** unique customers |
| 📦 Total Products | **1,862** unique products |

### Column Dictionary

| # | Column Name | Type | Description |
|---|------------|------|-------------|
| 1 | `Row ID` | Integer | Unique row identifier |
| 2 | `Order ID` | String | Unique order identifier (e.g. CA-2023-152156) |
| 3 | `Order Date` | Date | Date the order was placed |
| 4 | `Ship Date` | Date | Date the order was shipped |
| 5 | `Ship Mode` | String | Shipping method: Standard Class, Second Class, First Class, Same Day |
| 6 | `Customer ID` | String | Unique customer identifier |
| 7 | `Customer Name` | String | Full name of the customer |
| 8 | `Segment` | String | Customer segment: Consumer, Corporate, Home Office |
| 9 | `Country/Region` | String | Country of the order (United States / Canada) |
| 10 | `City` | String | City of the order |
| 11 | `State/Province` | String | State or province of the order |
| 12 | `Postal Code` | String | Postal/ZIP code |
| 13 | `Region` | String | Sales region: West, East, Central, South |
| 14 | `Product ID` | String | Unique product identifier |
| 15 | `Category` | String | Product category: Furniture, Office Supplies, Technology |
| 16 | `Sub-Category` | String | Product sub-category (17 unique values) |
| 17 | `Product Name` | String | Full product name |
| 18 | `Sales` | Decimal | Revenue from the order line ($) |
| 19 | `Quantity` | Integer | Number of units ordered |
| 20 | `Discount` | Decimal | Discount applied (0.0 – 0.8) |
| 21 | `Profit` | Decimal | Profit from the order line ($) — can be negative |
| 22 | `Profit Margin` | Decimal | Profit as % of Sales |
| 23 | `Regional Manager` | String | Manager responsible for the region |
| 24 | `Returned` | String | Whether the order was returned: Yes / No (from Returns table) |

---

## 🛠️ Tools Used

| Tool | Purpose |
|------|---------|
| ![Excel](https://img.shields.io/badge/-Excel-217346?logo=microsoftexcel&logoColor=white) | Data inspection, cleaning, calculated columns |
| ![SQL](https://img.shields.io/badge/-SQL%20Server-CC2927?logo=microsoftsqlserver&logoColor=white) | Exploratory analysis, KPIs, business questions |
| ![Tableau](https://img.shields.io/badge/-Tableau-E97627?logo=tableau&logoColor=white) | Interactive dashboards, calculated fields, parameters |
| ![Power BI](https://img.shields.io/badge/-Power%20BI-F2C811?logo=powerbi&logoColor=black) | Additional dashboards, decomposition tree, maps |
| ![Python](https://img.shields.io/badge/-Python-3776AB?logo=python&logoColor=white) | Web app dashboard using Plotly / Dash |

---

## 🧹 Phase 1 — Data Cleaning & Preprocessing

Steps performed in **Excel** and **SQL**:

1. **Data Inspection** — reviewed all 23 columns, checked data types (text, numbers, dates), ensured column names were consistent
2. **Missing Values** — no missing values found in the main dataset; Returned column populated after joining the Returns table
3. **Duplicate Removal** — checked for duplicate `Order ID` + `Product ID` combinations
4. **Standardize Formats** — unified text casing using `TRIM` and `PROPER`, standardized date formats
5. **Fix Numbers** — verified `Sales`, `Profit`, and `Discount` fields for logical consistency (no negative quantities, discount range 0–1)
6. **Calculated Columns Added:**
   - `Profit Margin` = Profit / Sales × 100
   - `Delivery Time` = Ship Date − Order Date (in days)
   - `Order Status` = Returned / Completed (from join with Returns table)

---

## 🔍 Phase 2 — SQL Analysis

All queries were run on `superstore_final` table in **SQL Server**.

### Section 1 — General Overview
```sql
-- Total Sales, Profit, Margin, Orders, Customers, Avg Order Value
SELECT
    SUM(Sales)                              AS Total_Sales,
    SUM(Profit)                             AS Total_Profit,
    ROUND(SUM(Profit)/SUM(Sales)*100, 2)    AS Profit_Margin,
    SUM(Quantity)                           AS Total_Units_Sold,
    COUNT(DISTINCT Order_ID)                AS Total_Orders,
    COUNT(DISTINCT Customer_ID)             AS Total_Customers,
    ROUND(AVG(Sales), 2)                    AS Avg_Order_Value
FROM superstore_final
```
**Result:** Total Sales = $2,326,534 | Profit = $292,716 | Margin = 12.58% | Orders = 5,111 | Customers = 804

---

### Section 2 — Product & Sub-Category Analysis

**2.1 — Which sub-categories are losing money?**
```sql
SELECT Category, Sub_Category,
    COUNT(DISTINCT Order_ID)                    AS Total_Orders,
    ROUND(SUM(Sales), 2)                        AS Total_Sales,
    ROUND(SUM(Profit), 2)                       AS Total_Profit,
    ROUND(SUM(Profit)/SUM(Sales)*100, 2)        AS Profit_Margin_Pct,
    COUNT(DISTINCT CASE WHEN Profit < 0
          THEN Order_ID END)                    AS Loss_Orders,
    ROUND(AVG(Discount)*100, 2)                 AS Avg_Discount_Pct
FROM superstore_final
GROUP BY Category, Sub_Category
ORDER BY Total_Profit ASC
```
**Key Finding:** Tables (-$17,333) and Bookcases (-$3,632) are the biggest loss-makers in Furniture.

**2.2 — Top 10 products losing the most money**
```sql
SELECT TOP 10 Product_Name, Category, Sub_Category,
    COUNT(DISTINCT Order_ID)    AS Total_Orders,
    ROUND(SUM(Sales), 2)        AS Total_Sales,
    ROUND(SUM(Profit), 2)       AS Total_Profit,
    ROUND(AVG(Discount)*100, 2) AS Avg_Discount_Pct
FROM superstore_final
GROUP BY Product_Name, Category, Sub_Category
ORDER BY Total_Profit ASC
```
**Key Finding:** Cubify CubeX 3D Printer (-$8,879) is the single most loss-making product — with a 53% average discount.

**2.3 — Top 10 most profitable products**
```sql
SELECT TOP 10 Product_Name, Category, Sub_Category,
    COUNT(DISTINCT Order_ID)    AS Total_Orders,
    ROUND(SUM(Profit), 2)       AS Total_Profit,
    ROUND(SUM(Sales), 2)        AS Total_Sales,
    ROUND(AVG(Discount)*100, 2) AS Avg_Discount_Pct
FROM superstore_final
GROUP BY Product_Name, Category, Sub_Category
ORDER BY Total_Profit DESC
```
**Key Finding:** Canon imageCLASS 2200 Copier ($25,199 profit) is the top performer — with only 12% avg discount.

---

### Section 3 — Discount Impact Analysis

**3.1 — Profit by discount level**
```sql
SELECT ROUND(Discount*100, 0)       AS Discount_Pct,
    COUNT(DISTINCT Order_ID)        AS Orders,
    ROUND(SUM(Profit), 2)           AS Total_Profit,
    ROUND(SUM(Sales), 2)            AS Total_Sales,
    ROUND(AVG(Profit), 2)           AS Avg_Profit,
    ROUND(AVG(Sales), 2)            AS Avg_Sales
FROM superstore_final
GROUP BY ROUND(Discount*100, 0)
ORDER BY Discount_Pct
```
**Key Finding:**
- 0% discount → $326,718 total profit (avg $66/order)
- 30% discount → **-$10,513 total profit** (avg -$45/order)
- 70% discount → **-$40,300 total profit** (avg -$95/order)
- ✅ **Clear conclusion: Every discount above 20% turns profitable orders into losses**

---

### Section 4 — Returns Analysis

**4.1 — Returns by category and sub-category**
```sql
SELECT Category, Sub_Category,
    COUNT(DISTINCT Order_ID)                                            AS Total_Orders,
    COUNT(DISTINCT CASE WHEN Returned='Yes' THEN Order_ID END)          AS Returned_Orders,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN Returned='Yes'
          THEN Order_ID END) / COUNT(DISTINCT Order_ID), 2)             AS Return_Rate_Pct,
    SUM(CASE WHEN Returned='Yes' THEN Quantity ELSE 0 END)              AS Returned_Quantity,
    ROUND(SUM(CASE WHEN Returned='Yes' THEN Sales ELSE 0 END), 2)       AS Returned_Sales_Value,
    ROUND(SUM(CASE WHEN Returned='Yes' THEN Profit ELSE 0 END), 2)      AS Profit_Lost_From_Returns
FROM superstore_final
GROUP BY Category, Sub_Category
ORDER BY Return_Rate_Pct DESC
```
**Key Finding:** Technology > Machines has the highest return rate (11.4%), followed by Furniture > Tables (9.55%).

**4.2 — Returns by customer segment**
```sql
SELECT Segment,
    COUNT(DISTINCT Order_ID)                                            AS Total_Orders,
    COUNT(DISTINCT CASE WHEN Returned='Yes' THEN Order_ID END)          AS Returned_Orders,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN Returned='Yes'
          THEN Order_ID END) / NULLIF(COUNT(DISTINCT Order_ID),0), 2)   AS Return_Rate_Pct,
    ROUND(SUM(CASE WHEN Returned='Yes' THEN Profit ELSE 0 END), 2)      AS Profit_Lost
FROM superstore_final
GROUP BY Segment
ORDER BY Return_Rate_Pct DESC
```
**Key Finding:** Corporate segment has the highest return rate (5.99%), Consumer follows (5.86%).

**4.3 — Returns by region and state**
```sql
SELECT Region, [Regional Manager], State_Province,
    COUNT(Returned)                                                     AS Returned_Orders,
    COUNT(DISTINCT Order_ID)                                            AS Total_Orders,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN Returned='Yes'
          THEN Order_ID END) / NULLIF(COUNT(DISTINCT Order_ID),0), 2)   AS Return_Rate_Pct,
    ROUND(SUM(Sales), 2)                                                AS Total_Sales
FROM superstore_final
GROUP BY Region, State_Province, [Regional Manager]
ORDER BY Return_Rate_Pct DESC
```
**Key Finding:** Utah (West) has the highest return rate at 15.38%, followed by Montana and Oregon.

---

## 📊 Phase 3 — Tableau Dashboards

### Dashboard 1 — Overview Superstore Analysis
**Charts:**
- KPI Cards: Total Revenue ($2.33M), Profit ($292.30K), Orders Placed (5,111), Customers (804)
- Orders by Segment (Donut chart) — Consumer 51.74%, Corporate 29.73%, Home Office 18.53%
- Sales by Ship Mode (Bullet chart) — Standard Class leads at $1.38M
- Sales by Region (Bullet chart) — West $739K, East $691K, Central $503K, South $391K
- Monthly Sales & Profit (Dual line chart) — seasonal peaks in Q4
- Yearly Sales by Quantity (Combo bar+line) — consistent YoY growth

**Filters:** Category, Sub-Category, Region, Segment, Ship Mode, Month/Year, Sales or Profit toggle

---

### Dashboard 2 — Superstore Sales Analysis
**Charts:**
- KPI Cards + Sparkline for 2026 total ($745.57K, +21.44% vs PY)
- Sales Over Time (Line chart 2023–2026)
- Sales by State (Geographic bubble map)
- Top 10 Customers by Total Sales (Heat table)
- 10 Highest Sales by City (Bar chart) — NYC leads at $256K
- Sub-category by Sales (Treemap) — Phones $331K, Chairs $335K

**Filters:** Region, Segment, Ship Mode, Category, Sub-Category, Month/Year slider

---

### Dashboard 3 — Superstore Profit Analysis
**Charts:**
- KPI Cards: Profit ($292.30K), Profit Ratio (12.56%), % Profitable Orders (79.32%), % Loss Orders (20.68%) + Sparkline
- Profit by Sub-Category (Radial/Rose chart)
- Profit by Ship Mode (Bullet chart)
- Profit by Region (Bullet chart) — West dominates
- Profit % Diff. by Category (Text table with YoY arrows) — Furniture shows -53.59% in 2026
- Monthly Profit by Order Status (Dual area line — Completed vs Returned)
- Profit by Customers (Scatter plot — avg $0 line reference)

**Filters:** Segment, Ship Mode, Category, Region, Sub-Category, Month/Year, Year

---

### Dashboard 4 — Orders & Products Analysis
**Charts:**
- KPI Cards: All Products (1,862), Returned Orders (296), Return Rate (5.79%), Returned Quantity (3,053), Avg Discount (15.5%)
- Monthly Completed Orders (Area chart with Completed/Returned toggle)
- Avg Discount by Region (Bar chart) — Central has highest avg discount (24%)
- Quantity Ordered by Sub-Category (Donut chart — total 38,654)
- Category for each Segment by QTY (Sankey/Flow chart)
- Top & Bottom Products by Profit (Diverging bar chart)
- Completed Orders by Customers (Frequency distribution bar)

**Filters:** Category, Sub-Category, Region, Segment, Ship Mode, Month/Year, Order Status parameter

---

### Key Calculated Fields Built in Tableau

| Field Name | Formula | Purpose |
|-----------|---------|---------|
| `Order Status` | `IF [Returned]="Yes" THEN "Returned Order" ELSE "Completed Order" END` | Classify orders |
| `Loss Orders` | `COUNTD(IF {FIXED [Order ID]:SUM([Profit])}<=0 THEN [Order ID] END)` | Count loss orders accurately |
| `Profitable Orders` | `COUNTD(IF {FIXED [Order ID]:SUM([Profit])}>0 THEN [Order ID] END)` | Count profitable orders |
| `% Loss Orders` | `[Loss Orders] / COUNTD([Order ID])` | Loss order rate |
| `% Profitable Orders` | `[Profitable Orders] / COUNTD([Order ID])` | Profitable order rate |
| `Return Rate` | `COUNTD(IF [Returned]="Yes" THEN [Order ID] END) / COUNTD([Order ID])` | Return rate % |
| `Returned Orders` | `COUNTD(IF [Returned]="Yes" THEN [Order ID] END)` | Count returns |
| `Returned Quantity` | `IF [Returned]="Yes" THEN [Quantity] ELSE 0 END` | Returned units |
| `Returned Sales Value` | `IF [Returned]="Yes" THEN [Sales] ELSE 0 END` | Revenue lost to returns |
| `All or Returned` | `IF [Returned?]="Returned Orders" THEN [Returned]="Yes" ELSE TRUE END` | Parameter filter logic |
| `Profit CY` | `IF YEAR([Order Date])=2026 THEN [Profit] END` | Current year profit |
| `Profit PY` | `IF YEAR([Order Date])=2025 THEN [Profit] END` | Previous year profit |
| `%Chg (Profit)` | `([Profit CY]-[Profit PY])/ABS([Profit PY])` | YoY profit change % |
| `Avg Order Value` | `SUM([Sales])/COUNTD([Order ID])` | Average order value |
| `Delivery Time` | `DATEDIFF('day',[Order Date],[Ship Date])` | Days to ship |

---

## 💡 Key Findings

### 📈 Sales
- Total revenue reached **$2.33M** across 4 years with consistent growth — 2026 was the best year (+21.44%)
- **Technology** is the highest-revenue category ($839K), followed closely by Chairs and Phones individually
- **New York City** is the #1 city by sales ($256K), followed by Los Angeles ($175K)
- **Q4 (Oct–Dec)** consistently drives the highest monthly sales — seasonal peak pattern confirmed

### 💰 Profit
- Overall profit margin is **12.58%** — healthy but unevenly distributed across categories
- **Technology** has the best margin (17%+), **Furniture** is barely profitable (3%) — Tables are actively losing money (-$17K)
- **West region** generates the most profit, **Central** is least profitable despite strong sales
- **79.32%** of orders are profitable — 20.68% are loss-making

### 🏷️ Discounts
- Orders with **0% discount** generate $326K profit (avg $66/order)
- Once discount hits **30%**, average profit per order turns **negative (-$45)**
- At **70% discount**, average loss is **-$95 per order**
- ✅ Discount is the single biggest controllable driver of losses

### 🔄 Returns
- **296 orders returned** — return rate of **5.79%**
- **3,053 units** were returned (Returned Quantity metric)
- **Machines** have the highest return rate by sub-category (11.4%)
- **Corporate segment** has the highest return rate (5.99%)
- **Utah state** has the highest state-level return rate (15.38%)

---

## 📋 Recommendations

1. **Cap discounts at 20%** — every % above 20 erodes margin significantly; remove 30%+ discounts from standard policy
2. **Review Furniture pricing strategy** — especially Tables and Bookcases which have negative total profit despite high sales volume
3. **Investigate Machines returns** — 11.4% return rate suggests quality or expectation mismatch issues
4. **Double down on Technology** — highest margin, highest sales, lowest return rate
5. **Grow Corporate segment** — they spend more per order; targeted B2B campaigns would increase high-value orders
6. **Focus marketing spend on Q4** — historical data confirms Sep–Dec is the peak; maximize inventory and promotions then
7. **Study Central region losses** — recurring underperformance needs targeted operational review

---

## 📁 Project Structure

```
📦 Superstore-Analysis
 ┣ 📂 Data
 ┃ ┣ 📄 superstore_raw.xlsx          # Original dataset
 ┃ ┗ 📄 superstore_final.xlsx        # Cleaned dataset
 ┣ 📂 SQL
 ┃ ┗ 📄 sales_analysis.sql           # All SQL queries (7 sections)
 ┣ 📂 Tableau
 ┃ ┣ 📄 Overview_Dashboard.twbx
 ┃ ┣ 📄 Sales_Dashboard.twbx
 ┃ ┣ 📄 Profit_Dashboard.twbx
 ┃ ┗ 📄 Orders_Returns_Dashboard.twbx
 ┣ 📂 PowerBI
 ┃ ┣ 📄 Customer_Orders.pbix
 ┃ ┗ 📄 Sales_Geography.pbix
 ┣ 📂 Python
 ┃ ┗ 📄 dashboard_app.py             # Plotly Dash web dashboard
 ┣ 📂 Presentation
 ┃ ┗ 📄 Superstore_Project.pdf       # Final presentation slides
 ┗ 📄 README.md
```

---

## 🚀 How to Run

### SQL
1. Import `superstore_final.xlsx` into SQL Server
2. Run `sales_analysis.sql` section by section

### Tableau
1. Open `.twbx` files in Tableau Desktop
2. Data source is embedded — no reconnection needed

### Python Dashboard

This dashboard was developed using Streamlit and Plotly.

### Run Locally

```bash
pip install -r requirements.txt
streamlit run app.py
# Open http: http://localhost:8501/
```

---

## 🔗 Links

- 📂 **GitHub Repository:** [github.com/MohamedAfify2025/Data-analysis-project](https://github.com/MohamedAfify2025/Data-analysis-project)
- 🎓 **Initiative:** Digital Egypt Pioneers — رواد مصر الرقمية
- 🏫 **Training Partner:** CLS Learning Solutions (Since 1995)

---

<div align="center">

**Group Two | Data Analysis 2026**

*Built with data, powered by curiosity.*

</div>
