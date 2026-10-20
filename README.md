# Global Electronics Retailer — Business Analysis

## Project Overview

This project analyzes sales data from a multinational electronics retailer
to evaluate business performance, product profitability, customer purchasing
behavior, and market performance.

The project combines data preparation, SQL analysis, Excel reporting, and
interactive Power BI dashboards to turn raw retail data into business insights
and recommendations.

## Project Objectives

- Evaluate overall revenue, profit, profit margin, and order performance.
- Analyze revenue and profitability across products and categories.
- Identify major country/market contributors.
- Understand repeat customers, one-time customers, and customers with no
  recorded orders.
- Explore sales trends over time.
- Validate data quality and identify limitations affecting analysis.
- Present findings through SQL , Excel and Power BI dashboards.

## Tools and Technologies

| Tool | Purpose |
|---|---|
| Python | Data cleaning |
| MySQL | Data cleaning, validation, and business analysis |
| Microsoft Excel | PivotTable analysis and executive dashboard |
| Power BI | Interactive dashboards and visual reporting |

## Project Workflow

1. **Data preparation:** Standardized selected column names and data types
   and handled blank values as part of the cleaning workflow.
2. **Data validation:** Checked row counts, missing values, key relationships,
   financial calculations, delivery dates, and exchange-rate records.
3. **SQL business analysis:** Investigated 53 business questions covering
   KPIs, sales trends, products, categories, customers, markets, stores,
   delivery, and forecast scenarios.
4. **Excel analysis:** Used summary analysis and dashboard visuals to compare
   key business metrics.
5. **Power BI reporting:** Created a three-page interactive report for
   executive, product/store, and customer analysis.
6. **Recommendations:** Translated the recorded findings into potential
   business actions.

## Key Performance Indicators

| Metric | Recorded Result |
|---|---:|
| Total Revenue | $55.76 million |
| Total Profit | $32.66 million |
| Profit Margin | 58.58% |
| Distinct Orders | 26,326 |
| Average Order Value | $2,117.47 |
| Repeat Customers | 7,272 |
| One-Time Customers | 4,615 |
| Customers with No Recorded Orders | 3,379 |


## Key Business Insights

### 1. Overall Performance

The recorded analysis shows $55.76 million in revenue and $32.66 million
in profit, with a profit margin of 58.58%.

Revenue, profit, and margin should be evaluated together to understand
business performance.

### 2. Customer Purchasing Behavior

The customer analysis identifies repeat customers, one-time customers,
and customers with no recorded orders.

Earlier calculations indicate that repeat customers account for approximately
82.47% of distinct orders, emphasizing the importance of customer retention
and repeat purchasing.

### 3. Product Category Contribution

The Computers category contributes approximately 34.5% of total recorded
profit, making it an important category to monitor.

### 4. Market Performance

The United States is the largest recorded country contributor by revenue.
Market comparisons should consider profit and margin as well as revenue.

The Online label represents a channel/market grouping, not a geographic
country, and should be treated separately from physical-country comparisons.

### 5. Sales Trends

The recorded annual revenue analysis shows changes over time. However,
the 2021 data only extends through February 20.

Therefore, 2021 is a partial year and should not be compared directly with
complete calendar years.

### 6. Data Quality

The recorded validation checks found missing delivery dates in approximately
79.06% of Sales records. This limits delivery-duration analysis and warrants
further investigation.

## Power BI Dashboard

The report contains three pages.

### Page 1 — Executive Overview

- Total Revenue
- Total Profit
- Profit Margin
- Distinct Orders
- Average Order Value
- Monthly Revenue Trend
- Revenue by Country/Market
- Revenue by Product
- Year and Month slicers

### Page 2 — Product & Store Performance

- Top 10 Products by Revenue
- Profit by Product Category
- Top 5 Stores by Revenue

### Page 3 — Customer Insights

- Total Customers
- Repeat Customers
- One-Time Customers
- Customers with No Recorded Orders
- Customer Segmentation
- Customers by Country
- Gender by Revenue
- Category slicer

## Recommendations

1. **Customer retention:** Track repeat-purchase rate, orders per customer,
   and revenue per customer to evaluate retention initiatives.

2. **Product performance:** Monitor top products using revenue, profit,
   and margin instead of revenue alone.

3. **Category strategy:** Track the Computers category's contribution and
   assess opportunities across other product categories.

4. **Market performance:** Compare country/market results using revenue,
   profit, and margin. Keep Online separate from geographic-country analysis.

5. **Data quality:** Investigate missing delivery dates and monitor data
   completeness before relying on delivery KPIs.

6. **Trend analysis:** Compare equivalent periods across years and label
   partial-year data clearly.

7. **Forecast interpretation:** Treat the forecast based on an assumed
   8% annual growth rate as an illustrative scenario, not a guaranteed result.

## SQL Skills Demonstrated

- Aggregate functions and `GROUP BY`
- `INNER JOIN` and `LEFT JOIN`
- Common Table Expressions (CTEs)
- Recursive CTEs
- Window functions such as `LAG()` and `RANK()`
- Conditional logic using `CASE`
- Date functions and date-difference calculations
- Customer segmentation
- Revenue contribution and profitability analysis
- Data-quality and relationship validation

## Suggested Repository Structure
Global-Electronics-Retailer/
├── Python/
│   └── "Global _Electronics _Retailer.ipynb"
├── SQL/
│   ├── 01_data_cleaning.sql
│   ├── 02_data_validation.sql
│   └── 03_business_analysis.sql
├── Excel/
│   └── "Global_Electronics_Analysis.xlsx"
├── PowerBI/
│   ├── "Global Electronics Retailer.pbix"
│   
└── README.md
