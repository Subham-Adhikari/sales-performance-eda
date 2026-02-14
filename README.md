<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sales Performance Analysis - SQL Project</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Helvetica, Arial, sans-serif;
            line-height: 1.6;
            color: #24292e;
            max-width: 900px;
            margin: 0 auto;
            padding: 20px;
            background-color: #ffffff;
        }
        h1 {
            border-bottom: 3px solid #0366d6;
            padding-bottom: 10px;
            color: #0366d6;
        }
        h2 {
            color: #24292e;
            border-bottom: 1px solid #e1e4e8;
            padding-bottom: 8px;
            margin-top: 30px;
        }
        h3 {
            color: #0366d6;
            margin-top: 20px;
        }
        .badge {
            display: inline-block;
            padding: 4px 8px;
            margin: 4px;
            border-radius: 3px;
            font-size: 12px;
            font-weight: 600;
        }
        .badge-sql {
            background-color: #e8f5e9;
            color: #2e7d32;
        }
        .badge-mssql {
            background-color: #e3f2fd;
            color: #1565c0;
        }
        .badge-analysis {
            background-color: #fff3e0;
            color: #e65100;
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin: 20px 0;
        }
        .stat-card {
            background: #f6f8fa;
            border: 1px solid #e1e4e8;
            border-radius: 6px;
            padding: 15px;
            text-align: center;
        }
        .stat-number {
            font-size: 28px;
            font-weight: bold;
            color: #0366d6;
        }
        .stat-label {
            font-size: 14px;
            color: #586069;
            margin-top: 5px;
        }
        .key-findings {
            background-color: #fff8e1;
            border-left: 4px solid #ffc107;
            padding: 15px 20px;
            margin: 20px 0;
            border-radius: 4px;
        }
        .insight-box {
            background-color: #e8f5e9;
            border-left: 4px solid #4caf50;
            padding: 15px 20px;
            margin: 15px 0;
            border-radius: 4px;
        }
        .tech-stack {
            background-color: #f6f8fa;
            padding: 15px;
            border-radius: 6px;
            margin: 15px 0;
        }
        ul {
            line-height: 1.8;
        }
        code {
            background-color: #f6f8fa;
            padding: 2px 6px;
            border-radius: 3px;
            font-family: 'Courier New', monospace;
            font-size: 14px;
        }
        .footer {
            margin-top: 40px;
            padding-top: 20px;
            border-top: 1px solid #e1e4e8;
            text-align: center;
            color: #586069;
            font-size: 14px;
        }
    </style>
</head>
<body>

<h1>📊 Sales Performance Analysis</h1>

<div>
    <span class="badge badge-sql">SQL</span>
    <span class="badge badge-mssql">Microsoft SQL Server</span>
    <span class="badge badge-analysis">Data Analysis</span>
</div>

<h2>🎯 Project Overview</h2>
<p>
    This project analyzes sales transaction data from a bike retail business spanning 2011-2014. 
    The analysis focuses on customer segmentation, product performance, and operational efficiency 
    to identify revenue drivers and potential business risks.
</p>

<h2>📈 Key Metrics</h2>
<div class="stats-grid">
    <div class="stat-card">
        <div class="stat-number">60,379</div>
        <div class="stat-label">Sales Transactions</div>
    </div>
    <div class="stat-card">
        <div class="stat-number">18,482</div>
        <div class="stat-label">Unique Customers</div>
    </div>
    <div class="stat-card">
        <div class="stat-number">130</div>
        <div class="stat-label">Products Analyzed</div>
    </div>
    <div class="stat-card">
        <div class="stat-number">3+ Years</div>
        <div class="stat-label">Data Coverage (2011-2014)</div>
    </div>
</div>

<h2>🔍 Key Findings</h2>

<div class="key-findings">
    <h3>💡 Customer Concentration Risk</h3>
    <p><strong>Top 10% of customers generated 40% of total revenue</strong>, indicating significant dependency on a small customer base. This presents both an opportunity (focus on high-value retention) and a risk (vulnerability to customer churn).</p>
</div>

<div class="insight-box">
    <h3>🚴 Product Category Dominance</h3>
    <p><strong>Bikes category contributed 96% of revenue</strong> with an average order value of <strong>$1,061</strong>. This demonstrates strong product-market fit but highlights potential over-reliance on a single category, suggesting need for product diversification.</p>
</div>

<div class="insight-box">
    <h3>📦 Operational Excellence</h3>
    <p>Analysis revealed <strong>7-day average shipping time</strong> with <strong>100% on-time delivery rate</strong>, demonstrating efficient logistics operations and strong fulfillment capabilities.</p>
</div>

<h2>🛠️ Technical Approach</h2>

<div class="tech-stack">
    <h3>SQL Techniques Used:</h3>
    <ul>
        <li><strong>Multi-table Joins:</strong> Connected fact and dimension tables (fact_sales, dim_customers, dim_products)</li>
        <li><strong>Common Table Expressions (CTEs):</strong> Structured complex queries for customer revenue aggregation</li>
        <li><strong>Window Functions:</strong> Used RANK and PERCENT_RANK for customer segmentation analysis</li>
        <li><strong>Aggregations:</strong> SUM, AVG, COUNT with GROUP BY for performance metrics</li>
        <li><strong>Data Quality Handling:</strong> Excluded 19 invalid records with missing order dates to ensure analysis accuracy</li>
    </ul>
</div>

<h2>📊 Database Schema</h2>
<p>The analysis utilized the following data structure:</p>

<h3>Tables:</h3>
<ul>
    <li><code>fact_sales</code>: Transaction-level data (order_number, product_key, customer_key, order_date, shipping_date, due_date, sales_amount, quantity, price)</li>
    <li><code>dim_customers</code>: Customer demographics (customer_key, customer_id, first_name, last_name, country, gender, birthdate)</li>
    <li><code>dim_products</code>: Product hierarchy (product_key, product_id, product_name, category, subcategory, cost, product_line)</li>
</ul>

<h2>💼 Business Recommendations</h2>
<p>Based on the analysis, the following strategic actions are recommended:</p>
<ol>
    <li><strong>Customer Retention Program:</strong> Implement targeted retention strategies for top 10% high-value customers to protect 40% of revenue</li>
    <li><strong>Customer Acquisition Strategy:</strong> Diversify customer base to reduce concentration risk and dependency on small customer segment</li>
    <li><strong>Product Diversification:</strong> Expand beyond Bikes category to reduce 96% revenue dependency on single product line</li>
    <li><strong>Leverage Operational Strength:</strong> Maintain and market 100% on-time delivery as competitive advantage in customer acquisition</li>
</ol>

<h2>📁 Project Structure</h2>
<pre>
sales-performance-analysis/
│
├── queries/
│   ├── data_quality_check.sql
│   ├── customer_segmentation.sql
│   ├── product_performance.sql
│   └── shipping_analysis.sql
│
├── results/
│   └── analysis_findings.md
│
└── README.md
</pre>

<h2>🚀 How to Use</h2>
<ol>
    <li>Clone this repository</li>
    <li>Import the SQL queries from the <code>queries/</code> folder into Microsoft SQL Server</li>
    <li>Execute queries sequentially to reproduce the analysis</li>
    <li>Review findings in <code>results/analysis_findings.md</code></li>
</ol>

<h2>🎓 Skills Demonstrated</h2>
<ul>
    <li>Advanced SQL querying and optimization</li>
    <li>Customer segmentation and cohort analysis</li>
    <li>Product performance analysis</li>
    <li>Operational metrics evaluation</li>
    <li>Data quality assessment and handling</li>
    <li>Business insight generation from raw data</li>
    <li>Strategic thinking and recommendation development</li>
</ul>

<h2>📧 Contact</h2>
<p>For questions or collaboration opportunities, feel free to reach out!</p>

<div class="footer">
    <p>🔗 Connect with me on <a href="https://linkedin.com/in/yourprofile">LinkedIn</a> | 📧 Email: your.email@example.com</p>
    <p>⭐ If you found this project useful, please consider giving it a star!</p>
</div>

</body>
</html>















---
---



# 🚲 Bike Sales Supply Chain Analytics (EDA & ADA using SQL)

## 📌 Project Overview
SQL-based analytics project built using **T-SQL (MS SQL Server)** to analyze bike sales and supply chain performance.  
The project converts raw transactional data into **dashboard-ready analytical views** for fast insight generation and business decision-making.

---

## 🏢 Business Context
- **Domain:** 🚲 Bike Sales & Supply Chain Analytics  
- **Primary Consumers:** 📊 Dashboards, business users, analysts  
- **Objective:** Enable quick performance monitoring and insight discovery without additional data transformation

---

## 🗂 Dataset Summary
- Company-like mock dataset
- ~**60,000** sales records
- Data period: **late 2010 – early 2014**
- Star schema model:
  - `fact_sales`
  - `dim_products`
  - `dim_customers`

---

## 🔍 Analysis Coverage

### Exploratory Data Analysis (EDA)
- Time-based sales and revenue trends
- Category and product contribution
- Order volume and quantity distribution
- Customer purchasing patterns

### Advanced Data Analysis (ADA)
- Product and customer-level aggregations
- Revenue-based performance segmentation
- Product lifecycle and recency analysis
- KPI calculation for reporting and dashboards

---

## 📊 Demo Business Metrics (Sample Insights)

> ⚠️ *Figures shown below are representative demo values for illustration.  
Actual values will be updated based on final outputs.*

### 🔹 Overall Sales Performance
- Sales records analyzed: **~60,000**
- Total revenue generated: **~₹29.36 Million**
- Average Order Revenue (AOR): **~₹1,061**
- Average Monthly Revenue (AMR): **~₹XX,XXX**

---

### 🔹 Product Performance
- Products analyzed: **~XXX**
- High-performing products contribution: **~XX% of total revenue**
- Mid-performing products contribution: **~XX% of sales volume**
- Low-performing products: **consistent but lower revenue impact**

---

### 🔹 Product Lifecycle Metrics
- Product lifespan range: **~X – ~XX months**
- Long-lifecycle products: **higher AMR**
- Early-stage products: **faster initial revenue growth**

---

### 🔹 Recency Metrics
- Products sold in last 12 months: **~XX%**
- Recently sold products: **higher AOR**
- Dormant products: **declining monthly revenue trend**

---

### 🔹 Customer Metrics (Customer-Level View)
- Unique customers: **~18,484**
- Revenue from repeat customers: **avgerage ~1000**
  
---

## 🧱 Reporting Layer (Final Output)

Two reusable analytical views were created:

### 🧾 Product-Level View
- Revenue, quantity, and order metrics
- Product segmentation (High / Mid / Low)
- Product lifespan and recency KPIs

### 👥 Customer-Level View
- Customer order frequency and value
- Recency indicators
- Supports retention and behavioral analysis

These views act as a **semantic layer** and can be directly connected to **Power BI / Tableau**.

---

## 🛠 SQL & Analytics Techniques Used
- CTE-based transformations
- Multi-level aggregations
- Date intelligence using `DATEDIFF`
- Safe KPI calculations using `NULLIF`
- Reusable analytical view design

---

## 🎯 Why This Project
- Demonstrates SQL-only end-to-end analytics
- Focuses on metrics businesses actually track
- Built with dashboard and reporting consumption in mind
- Mirrors real-world analytics workflows

---

## 💻 Tools & Technologies
- MS SQL Server (T-SQL)
- Relational Data Modeling
- Analytical SQL Design

---

## 📝 Notes
- Dataset is a **company-like mock dataset**
