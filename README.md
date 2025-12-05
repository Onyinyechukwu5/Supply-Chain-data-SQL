# Supply-Chain-data-SQL

# Introduction
This project analyzes an end-to-end supply chain dataset to measure flow/process efficiency, manufacturing quality, inventory health, logistics performance, sales and customer patterns. Using a single supplychain dataset, the analysis computes core KPIs (order volumes, costs, lead times, defect rates, revenue and profit), inspects relationships (correlations between lead times and shipping), and surfaces operational risks such as stockouts or high transportation cost-per-unit.

# Project objective
- Provide actionable insights to reduce costs, improve quality, and avoid stockouts.
- Identify high-value products/regions and underperforming suppliers or carriers.
- Recommend process improvements across manufacturing, inventory and logistics to boost profitability and service levels.

# Dataset used
<a href = https://github.com/Onyinyechukwu5/Supply-Chain-data-SQL/blob/main/supply_chain_data.csv> Dataset <a/>

# Questions (KPIs)
## Flow Process & Cost:
1. What is the average lead time across different transportation modes and routes?
Insight: Helps identify efficiency and bottlenecks in delivery processes.
2. Which transportation mode has the lowest cost-to-benefit ratio for each product type?
Insight: Evaluates the most cost-efficient transport option relative to product benefits.
3. What is the correlation between manufacturing lead time and overall shipping time?
Insight: Identifies if delays in manufacturing directly impact delivery timelines.
Supply Chain & Quality Control (QC):
4. Which supplier consistently has the lowest defect rates?
Insight: Assesses supplier performance to ensure better QC practices.
5. How do defect rates vary across different product types and suppliers?
Insight: Identifies product-specific or supplier-specific quality issues.
6. Which routes or carriers have the highest transportation costs per unit shipped?
Insight: Pinpoints costly supply chain links for cost reduction opportunities.
## Manufacturing & QC:
7. What is the average manufacturing lead time per supplier, and how does it impact 
stock availability?
Insight: Evaluates supplier reliability and its effect on inventory management.
8. Which product types have the highest defect rates, and what are the potential causes?
Insight: Helps prioritize quality improvements in manufacturing.
9. How does manufacturing cost correlate with defect rates?
Insight: Determines if higher costs lead to better quality or if resources are misallocated.
## Inventory & Logistics:
10. Which products are at risk of stockouts based on current stock levels and lead times?
Insight: Helps in proactive inventory planning to avoid stockouts.
11. How do lead times vary between different suppliers, and what is their impact on 
inventory levels?
Insight: Evaluates supplier efficiency and its impact on overall inventory health.
12. What is the relationship between shipping carrier performance and lead times?
Insight: Assesses which carriers are the most reliable and efficient.
Sales & Customers:
13. Which product types generate the highest revenue, and what are their corresponding 
defect rates?
Insight: Balances revenue generation with product quality to understand overall profitability.
14. How does customer demographics (e.g., gender) correlate with product preferences 
and sales volume?
Insight: Tailors marketing and product development efforts to target demographics 
effectively.
15. Which products have the highest benefit-to-sales ratio, and how does this vary across 
regions?
Insight: Identifies the most profitable products and regions for focused sales efforts



# Process used
Data ingestion & schema design
- Loaded raw CSV into a single supplychain table (DDL provided).
- Ensured numeric columns are typed correctly (costs, lead times), standardized categorical values (supplier names, transport modes), and remove or mark duplicates and nulls.

# Analysis & Key insights 

Volume & Revenue KPIs
SUM(Number_of_products) and SUM(Revenue_generated) identify best-selling products and highest revenue streams. Use these to prioritize production and inventory.

Lead time performance
AVG(Lead_time) and AVG(Manufacturing_lead_time) show where delays occur (supplier vs manufacturing). Large manufacturing lead time suggests internal capacity or process issues; large supplier lead time suggests supplier reliability concerns.

Cost & profit
SUM(costs) and profit calculations show whether revenue sufficiently covers manufacturing and shipping. Low profit-to-sales ratio pinpoints margin pressure.

Quality (QC)
AVG(Defect_rates) overall and AVG(Defect_rates) BY Supplier reveal which suppliers or product types cause quality problems. High defect rates increase rework, returns and costs.

Transport efficiency & cost-benefit
Grouped AVG lead time by Transportation_modes, Routes finds slow transport choices.
Cost-to-benefit ratio per transport mode and product type highlights expensive delivery options that do not produce proportional revenue.

Correlation manufacturing lead time ↔ shipping time
The correlation coefficient indicates whether longer manufacturing lead times are associated with longer shipping (supply chain coupling). A strong positive correlation suggests systemic delays; near zero suggests independent issues.


Stockout risk
The StockRisk CTE flags product types where current stock < expected demand during lead time — these are at risk of stockout and need reorder action.
Carrier performance
Counting shipments above carrier average lead time computes delayed shipment percentages per carrier — useful for carrier SLAs and switching decisions.

Customer & sales segmentation
Customer_demographics × Product_type shows which customer segments prefer which products so marketing and assortment can be tailored.

# Recommendations (actionable)
Fix supplier & manufacturing bottlenecks
If supplier lead times are high for specific suppliers, open supplier scorecards, renegotiate lead times or qualify additional suppliers.
If manufacturing lead times are high, investigate capacity, preventive maintenance, or process optimization (lean methods).

Prioritize inventory for at-risk products
Use the StockRisk results to perform targeted replenishment and raise reorder points for products flagged "At Risk".
Rationalize transportation choices
Move volume to transport modes/routes with better cost-to-benefit ratios. Renegotiate rates with carriers that show high transportation cost-per-unit or high delay rates.

Quality improvement program
For suppliers or product types with high Defect_rates, implement root-cause analysis, stricter incoming inspection, and corrective action plans. Consider supplier development programs.
Margin & pricing review
If profit-to-sales ratio is low, evaluate pricing, reduce non-value costs (manufacturing inefficiency, high shipping), or reallocate high-margin products to priority channels.

Monitor correlation-driven risks
If the correlation between manufacturing lead time and shipping times is strong, treat delays end-to-end: reducing one part alone may not help coordinate across manufacturing, warehousing, and logistics.

# Conclusion
By running the provided queries you generate a comprehensive snapshot of supply chain performance: volume, lead time, cost, quality and logistics. The SQL outputs enable you to identify which suppliers or transport modes cause delays or cost overruns, which products risk stockouts, and where quality issues reduce profitability. Immediate improvements should focus on mitigating stock risk, reducing defect rates through supplier/manufacturing interventions, and optimizing transport choices to improve cost-to-benefit. Operationalizing these insights in a dashboard and closing the loop with supplier/operations teams will translate analysis into measurable business improvements.


