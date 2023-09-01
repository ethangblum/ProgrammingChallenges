--Question One--
--Write a query to get the sum of impressions by day.--
SELECT date, SUM(impressions) AS total_impressions
FROM marketing_performance
GROUP BY date
ORDER BY date;

--Question Two--
--Write a query to get the top three revenue-generating states in order of best to worst. How much revenue did the third best state generate?--
SELECT state, SUM(revenue) AS total_revenue
FROM website_revenue
GROUP BY state
ORDER BY total_revenue DESC
LIMIT 3;

--Question Three--
--Write a query that shows total cost, impressions, clicks, and revenue of each campaign. Make sure to include the campaign name in the output.--
SELECT 
    ci.id AS campaign_id, 
    ci.name AS campaign_name,
    SUM(mp.cost) AS total_cost,
    SUM(mp.impressions) AS total_impressions,
    SUM(mp.clicks) AS total_clicks,
    SUM(wr.revenue) AS total_revenue
FROM 
    campaign_info ci
LEFT JOIN 
    marketing_performance mp ON ci.id = mp.campaign_id
LEFT JOIN 
    website_revenue wr ON ci.id = wr.campaign_id
GROUP BY 
    ci.id, ci.name
ORDER BY 
    ci.name;

--Question Four--
--Write a query to get the number of conversions of Campaign5 by state. Which state generated the most conversions for this campaign?--
SELECT 
    mp.geo AS state,
    SUM(mp.conversions) AS total_conversions
FROM 
    marketing_performance mp
JOIN 
    campaign_info ci ON mp.campaign_id = ci.id
WHERE 
    ci.name = 'Campaign5'
GROUP BY 
    mp.geo
ORDER BY 
    total_conversions DESC;
--Georgia has 672 Conversions, while, Ohio has 442 Conversions. Therefore, Georgia has the highest for this campaign.--

--Question Five--
--In your opinion, which campaign was the most efficient, and why?--
--Based on the campaign data provided, I decided that to determine which campaign was the most efficient would be to determine which campaign had the high return on ad expenditure. To do this, I wrote the query below...--
SELECT
    ci.name AS Campaign_Name,
    SUM(wr.revenue) / SUM(mp.cost) AS ROAS
FROM
    campaign_info ci
LEFT JOIN
    marketing_performance mp ON ci.id = mp.campaign_id
LEFT JOIN
    website_revenue wr ON ci.id = wr.campaign_id
GROUP BY
    ci.name
ORDER BY
    ROAS DESC;


--Question Six (Bonus)--
--Write a query that showcases the best day of the week (e.g., Sunday, Monday, Tuesday, etc.) to run ads.--
SELECT
    CASE 
        WHEN strftime('%w', SUBSTR(date, 1, 10)) = '0' THEN 'Sunday'
        WHEN strftime('%w', SUBSTR(date, 1, 10)) = '1' THEN 'Monday'
        WHEN strftime('%w', SUBSTR(date, 1, 10)) = '2' THEN 'Tuesday'
        WHEN strftime('%w', SUBSTR(date, 1, 10)) = '3' THEN 'Wednesday'
        WHEN strftime('%w', SUBSTR(date, 1, 10)) = '4' THEN 'Thursday'
        WHEN strftime('%w', SUBSTR(date, 1, 10)) = '5' THEN 'Friday'
        WHEN strftime('%w', SUBSTR(date, 1, 10)) = '6' THEN 'Saturday'
    END AS Day_Of_Week,
    SUM(conversions) AS Total_Conversions
FROM
    marketing_performance
GROUP BY
    strftime('%w', SUBSTR(date, 1, 10))
ORDER BY
    Total_Conversions DESC;

--From this query, I determined that the best day of the week to run ads would be Friday as it would have 3,457 conversions.--