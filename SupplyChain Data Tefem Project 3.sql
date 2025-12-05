Create database Supplychain_data;

Show databases;
Show tables;
DROP TABLE suply_chain;

Use Supplychain_data;

Select*
From supplychain;

create Table supplychain(
Product_type varchar(30) Not Null,
SKU varchar(6) Not Null Primary key,
Price float Not Null,
Availability int Not Null,
Number_of_Products Int Not Null,
Revenue_generated float Not Null,
Customer_demographics varchar (30) Not Null,
Stock_levels int Not Null,
Lead_times int Not Null,
Order_quantities int Not null,
Shipping_times int Not Null,
Shipping_carriers varchar(15) Not Null,
Shipping_costs float Not Null,
Supplier_name varchar (10) Not Null,
Location varchar(15) Not Null,
Lead_time int Not Null,
Production_volumes int Not Null,
Manufacturing_lead_time int Not Null,
Manufacturing_costs Float Not Null,
Inspection_results varchar(15) Not Null,
Defect_rates float Not Null,
Transportation_modes varchar(10) Not Null,
Routes varchar (10) Not Null,
Costs float Not Null

);
-- KPIs

-- Ordered quantity

SELECT
	SUM(Order_quantities) As Total_Order 
FROM
	supplychain;

-- AVG Leadtime

SELECT
	AVG(Lead_time) Supplier_Leadtime,
	AVG(Manufacturing_lead_time) Manufacturing_time,
	AVG(Lead_time + Manufacturing_lead_time ) Total_leadtime
FROM
	Supplychain;

-- Total Cost

SELECT
	ROUND(SUM(costs), 2) Total_cost
FROM 
	Supplychain;

-- Avg Defect Rate

SELECT
	AVG(Defect_rates) Avg_defect_rates
FROM
	Supplychain;

-- Total Production Volume

SELECT
	SUM(Production_volumes) Total_volume_produced
FROM
	Supplychain;

-- profit to sale ratio

SELECT
	(SUM(Revenue_generated) - SUM(manufacturing_costs + shipping_costs))/ SUM(revenue_generated) * 100
FROM
	Supplychain;


-- Revenue & profit

SELECT
	SUM(Revenue_generated) Total_rev,
	SUM(Revenue_generated) - SUM(manufacturing_costs + shipping_costs) Total_profit
FROM
	Supplychain;

-- ANALYSIS --

-- Flow Process & Cost

-- What is the average lead time across different transportation modes and routes?

SELECT
	Transportation_modes,
	Routes,
	AVG(Lead_time) Avg_Leadtime
FROM	
	Supplychain
GROUP BY
	Transportation_modes, Routes
ORDER BY
	Avg_Leadtime DESC;

-- Which transportation mode has the lowest cost-to-benefit ratio for each product type?

SELECT
	Transportation_modes,
	Product_type,
	ROUND((SUM(manufacturing_costs + Shipping_costs)/ SUM(revenue_generated) * 100),2) Cost_to_Benefit
FROM	
	Supplychain
GROUP BY
	Transportation_modes, Product_type 
ORDER BY
	Cost_to_Benefit ASC;

-- What is the correlation between manufacturing lead time and overall shipping time?

SELECT 
    (
        COUNT(*) * SUM(CAST(Manufacturing_lead_time AS DECIMAL(18,6)) * CAST(Shipping_times AS DECIMAL(18,6))) 
        - SUM(CAST(Manufacturing_lead_time AS DECIMAL(18,6))) * SUM(CAST(Shipping_times AS DECIMAL(18,6)))
    ) /
    SQRT(
        (COUNT(*) * SUM(CAST(Manufacturing_lead_time AS DECIMAL(18,6)) * CAST(Manufacturing_lead_time AS DECIMAL(18,6))) 
        - POWER(SUM(CAST(Manufacturing_lead_time AS DECIMAL(18,6))), 2))
        *
        (COUNT(*) * SUM(CAST(Shipping_times AS DECIMAL(18,6)) * CAST(Shipping_times AS DECIMAL(18,6))) 
        - POWER(SUM(CAST(Shipping_times AS DECIMAL(18,6))), 2))
    ) AS Correlation_Coefficient
FROM 
    Supplychain;
    
    -- Supply Chain & Quality Control (QC):

-- Which supplier consistently has the lowest defect rates?

SELECT
	Supplier_name,
	AVG(Defect_rates) Defect_rates
FROM
	Supplychain
GROUP BY
	Supplier_name
ORDER BY
	Defect_rates ASC;
 
 -- How do defect rates vary across different product types and Suppliers?

SELECT
	product_type, Supplier_name,
	AVG(Defect_rates) Defect_rate
FROM
	Supplychain
GROUP BY
	Product_type, Supplier_name
ORDER BY
	Defect_rate ASC;

-- Which routes or carriers have the highest transportation costs per unit shipped?

SELECT
	Routes,
	Shipping_carriers,
	ROUND(SUM(shipping_costs)/ SUM(Number_of_products),2) Transportation_cost_per_units
FROM
	Supplychain
GROUP BY
	Routes, Shipping_carriers
ORDER BY
	Transportation_cost_per_units DESC;

-- Manufacturing & QC:

-- What is the average manufacturing lead time per supplier, and how does it impact stock availability?

SELECT
	Supplier_name,
	AVG(Manufacturing_lead_time) Manufacturing_Leadtime,
	AVG(Stock_levels) Available_Stock
FROM
	Supplychain
GROUP BY
	Supplier_name;


-- Which product types have the highest defect rates, and what are the potential causes?

SELECT
	Product_type,
	AVG(Defect_rates) Avg_defect_rate,
	SUM(Number_of_products) total_Qty,
	SUM(CASE WHEN Inspection_results = 'Fail' THEN 1 ELSE 0 END) AS Failed_Products
FROM
	Supplychain
GROUP BY
	Product_type
ORDER BY
	Avg_defect_rate;


-- How does manufacturing cost correlate with defect rates?

SELECT
	Product_type,
	AVG(Manufacturing_costs) Manufacturing_cost,
	AVG(Defect_rates) Defect_rate
FROM
	Supplychain
GROUP BY
	Product_type
ORDER BY
	Defect_rate DESC;
    
  -- Inventory & Logistics:

-- Which products are at risk of stockouts based on current stock levels and lead times? 

WITH ProductSummary AS (
    SELECT 
        Product_type,
        SUM(Stock_levels) AS Total_Stock,
        SUM(Number_of_products) AS Total_Sold,
        AVG(Lead_time) AS Avg_Lead_Time
    FROM 
        Supplychain
    GROUP BY 
        Product_type
),
StockRisk AS (
    SELECT 
        Product_type,
        Total_Stock,
        Total_Sold,
        Avg_Lead_Time,
        -- Calculate the daily sales rate
        (Total_Sold / Avg_Lead_Time) AS Daily_Sales_Rate,
        -- Calculate expected demand during lead time
        (Total_Sold / Avg_Lead_Time) * Avg_Lead_Time AS Expected_Demand,
        -- Determine if stock is at risk
        CASE 
            WHEN Total_Stock < ((Total_Sold / Avg_Lead_Time) * Avg_Lead_Time) THEN 'At Risk'
            ELSE 'Safe'
        END AS Stock_Status
    FROM 
        ProductSummary
)
SELECT 
    Product_type,
    Total_Stock,
    Total_Sold,
    Avg_Lead_Time,
    Daily_Sales_Rate,
    Expected_Demand,
    Stock_Status
FROM 
    StockRisk;


-- How do lead times vary between different suppliers, and what is their impact on inventory level??

SELECT
	Supplier_name,
	AVG(Lead_time) Avg_Lead_time,
	AVG(Stock_levels) Avg_Stock_level,
	SUM(Number_of_products) total_Qty_sold,
	CASE	
		WHEN SUM(Number_of_products) > 0 THEN
			AVG(stock_levels) / (SUM(Number_of_products) / AVG(Lead_time))
		ELSE NULL
	END inventory_days
FROM
	Supplychain
GROUP BY
	Supplier_name
ORDER BY
	Avg_Lead_time;


-- What is the relationship between shipping carrier performance and lead times

WITH CarrierLeadTime AS (
	SELECT
		shipping_carriers,
		AVG(Lead_time) AS Avg_lead_time
	FROM
		Supplychain
	GROUP BY
		Shipping_carriers
)
SELECT
	sc.Shipping_carriers,
	clt.Avg_lead_time,
	COUNT(CASE WHEN sc.lead_time > clt.Avg_lead_time THEN 1 END) Delayed_shipments,
	COUNT(*) AS Total_shipments,
	(COUNT(CASE WHEN sc.lead_time > clt.Avg_lead_time THEN 1 END)  * 100 / COUNT(*)) Delayed_shipments
FROM
	Supplychain sc
JOIN
	CarrierLeadTime clt ON sc.Shipping_carriers = clt.Shipping_carriers
GROUP BY
	sc.Shipping_carriers, clt.Avg_lead_time
ORDER BY 
	clt.Avg_Lead_time;


-- Sales & Customers:

-- Which product types generate the highest revenue, and what are their corresponding defect rates?

SELECT
	Product_type,
	SUM(Revenue_generated) Total_revenue,
	AVG(Defect_rates) Avg_Defect_rate
FROM
	Supplychain
GROUP BY
	Product_type
ORDER BY
	Total_revenue DESC;

-- How does customer demographics (e.g., gender) correlate with product preferences and sales volume?

SELECT
	Customer_demographics,
	Product_type,
	SUM(Number_of_products) Total_Qty
FROM
	Supplychain
GROUP BY
	Customer_demographics, Product_type
ORDER BY
	Total_Qty DESC;

-- Which products have the highest benefit-to-sales ratio, and how does this vary across regions?

SELECT
	Product_type,
	Location,
	SUM(Revenue_generated - Manufacturing_costs) Total_benefit,
	SUM(Revenue_generated) Total_revenue,
	(SUM(Revenue_generated - Manufacturing_costs) / NULLIF (SUM(Revenue_generated),0)) Benefit_Ratio
FROM
	Supplychain	
GROUP BY
	Product_type, Location
ORDER BY
	Benefit_Ratio  
    
    