# Supply-Chain-data-SQL

Introduction
This project analyzes an end-to-end supply chain dataset to measure flow/process efficiency, manufacturing quality, inventory health, logistics performance, sales and customer patterns. Using a single supplychain table, the analysis computes core KPIs (order volumes, costs, lead times, defect rates, revenue and profit), inspects relationships (correlations between lead times and shipping), and surfaces operational risks such as stockouts or high transportation cost-per-unit.

Project objective
- Provide actionable insights to reduce costs, improve quality, and avoid stockouts.
- Identify high-value products/regions and underperforming suppliers or carriers.
- Recommend process improvements across manufacturing, inventory and logistics to boost profitability and service levels.

# Dataset used

Questions (KPIs) you computed
Core KPIs and metrics produced by your SQL:
Total ordered quantity (SUM(Order_quantities))


Average supplier lead time, manufacturing lead time, total lead time (AVG(Lead_time), AVG(Manufacturing_lead_time))


Total cost (SUM(costs))


Average defect rate (AVG(Defect_rates))


Total production volume (SUM(Production_volumes))


Profit-to-sales ratio and Total profit (SUM(Revenue_generated) - SUM(manufacturing_costs + shipping_costs))


Average lead time by transport mode & route (grouped averages)


Cost-to-benefit ratio by transport mode & product type


Correlation coefficient between manufacturing lead time and shipping times (measure of relationship strength)


Supplier defect-rate ranking and defect variation by product/supplier


Transportation cost per unit by route/carrier


Manufacturing lead time vs stock availability by supplier


Products at risk of stockout (CTE ProductSummary → StockRisk)


Carrier performance vs lead times (delayed shipment % per carrier)


Revenue by product_type with corresponding defect rates and benefit-to-sales ratio by region



Process used (step-by-step)
Data ingestion & schema design


Loaded raw CSV/XLSX into a single supplychain table (DDL provided).


Data cleaning (Power Query / SQL):


Ensure numeric columns typed correctly (costs, lead times), standardize categorical values (supplier names, transport modes), and remove or mark duplicates and nulls.


Exploratory queries / KPI calculations


Run aggregations and grouped queries (the ones you listed) to generate baseline KPIs.


Deeper analysis


Use GROUP BY to compare modes/regions/suppliers.


Use a correlation formula to test relationships (manufacturing lead time vs shipping time).


Use CTE(s) (e.g., ProductSummary, StockRisk) to compute derived metrics such as daily sales rate and stock risk.


Validation & sanity checks


Verify outliers (extreme lead times, negative costs), null handling and denominator checks (NULLIF used for division safety).


Visualization & reporting (recommended next step)


Push results to dashboards (Power BI/Tableau) to monitor KPIs and drill into problem areas.



Analysis & Key insights (what each query reveals)
Below are the types of insights each query set yields and how to interpret them:
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



Recommendations (actionable)
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


If the correlation between manufacturing lead time and shipping times is strong, treat delays end-to-end: reducing one part alone may not help—coordinate across manufacturing, warehousing, and logistics.


Operationalize KPIs


Build a dashboard for these KPIs with alerts (stockout risk, defect rate thresholds, carrier delay thresholds) so teams can act proactively.



Conclusion
By running the provided queries you generate a comprehensive snapshot of supply chain performance: volume, lead time, cost, quality and logistics. The SQL outputs enable you to identify which suppliers or transport modes cause delays or cost overruns, which products risk stockouts, and where quality issues reduce profitability. Immediate improvements should focus on mitigating stock risk, reducing defect rates through supplier/manufacturing interventions, and optimizing transport choices to improve cost-to-benefit. Operationalizing these insights in a dashboard and closing the loop with supplier/operations teams will translate analysis into measurable business improvements.


