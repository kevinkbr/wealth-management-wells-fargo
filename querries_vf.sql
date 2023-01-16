USE invest;





SELECT a.date, a.ticker, (a.value-a.p0)/a.p0 as returns
FROM
(
SELECT *, LAG(value, 250) OVER (
								PARTITION BY ticker
                                ORDER by `date`
                                ) AS p0
FROM pricing_daily_new
WHERE price_type='Adjusted'
ORDER BY `date`) AS a
;

CREATE VIEW team8_returns1 AS
SELECT a.date, a.ticker, a.value, a.lagged_price, a.price_type,
(a.value-a.lagged_price)/a.lagged_price as returns
FROM 
(SELECT *, LAG(value,1) OVER(
							PARTITION BY ticker
                            ORDER BY date
                            ) as lagged_price
FROM invest.pricing_daily_new
WHERE price_type='Adjusted' AND date > '2021-09-09'
) a;

-- THIS IS NOW THE MAIN CODE TO GET THE PORTFOLIO
-- this query gives us all of the information needed from a client to then calculate their portfolio returns 
-- important to note tha we must change the customer id
 
SELECT 
    tr.ticker,
    AVG(returns) * 250 AS mu,
    STD(returns) * SQRT(250) AS sigma,
    AVG(returns) / STD(returns) AS risk_adj_returns,
    CASE
        WHEN STD(returns) >= 0.014 THEN 'Aggressive'
        ELSE 'conservative'
    END AS client_type,
    hc.quantity,
    hc.value,
    (hc.quantity * hc.value) AS total_quantity
FROM
    invest.team8_returns1 AS tr
        INNER JOIN
    holdings_current AS hc ON tr.ticker = hc.ticker
        INNER JOIN
    account_dim AS ad ON hc.account_id = ad.account_id
        INNER JOIN
    customer_details AS cd ON cd.customer_id = ad.client_id
WHERE
    customer_id = 99
GROUP BY ticker
ORDER BY risk_adj_returns DESC
;

-- this qury allows us to know if the client is aggressive or conservtive using count_case

SELECT 
    client_type, COUNT(client_type), total_invested
FROM
    (SELECT 
        tr.ticker,
            AVG(returns) AS mu,
            STD(returns) AS sigma,
            AVG(returns) / STD(returns) AS risk_adj_returns,
            CASE
                WHEN STD(returns) >= 0.014 THEN 'Aggressive'
                ELSE 'conservative'
            END AS client_type,
            SUM(hc.quantity * hc.value) AS total_invested
    FROM
        invest.team8_returns1 AS tr
    INNER JOIN holdings_current AS hc ON tr.ticker = hc.ticker
    INNER JOIN account_dim AS ad ON hc.account_id = ad.account_id
    INNER JOIN customer_details AS cd ON cd.customer_id = ad.client_id
    WHERE
        customer_id = 99
    GROUP BY tr.ticker
    ORDER BY risk_adj_returns DESC) AS meh
GROUP BY client_type
;


-- CALCULATING THE PORTFOLIO PROFIT FOR CUSTOMER 123


SELECT 
    SUM(weight * mu) AS portfolioreturn
FROM
    (SELECT 
        customer_id,
            tr.ticker,
            AVG(returns) * 250 AS mu,
            STD(returns) * SQRT(250) AS sigma,
            AVG(returns) / STD(returns) AS risk_adj_returns,
            CASE
                WHEN STD(returns) >= 0.014 THEN 'Aggressive'
                ELSE 'conservative'
            END AS conservative_or_nah,
            hc.quantity,
            hc.value,
            (hc.quantity * hc.value) AS total_quantity,
            hc.quantity / 40790 AS weight
    FROM
        invest.team8_returns1 AS tr
    INNER JOIN holdings_current AS hc ON tr.ticker = hc.ticker
    INNER JOIN account_dim AS ad ON hc.account_id = ad.account_id
    INNER JOIN customer_details AS cd ON cd.customer_id = ad.client_id
    WHERE
        customer_id = 123
    GROUP BY ticker
    ORDER BY risk_adj_returns DESC) AS experiment

;

-- CALCULATING THE PORTFOLIO PROFIT FOR CUSTOMER 919
SELECT 
    SUM(weight * mu) AS portfolioreturn
FROM
    (SELECT 
        customer_id,
            tr.ticker,
            AVG(returns) * 250 AS mu,
            STD(returns) * SQRT(250) AS sigma,
            AVG(returns) / STD(returns) AS risk_adj_returns,
            CASE
                WHEN STD(returns) >= 0.014 THEN 'Aggressive'
                ELSE 'conservative'
            END AS conservative_or_nah,
            hc.quantity,
            hc.value,
            (hc.quantity * hc.value) AS total_quantity,
            hc.quantity / 32311 AS weight
    FROM
        invest.team8_returns1 AS tr
    INNER JOIN holdings_current AS hc ON tr.ticker = hc.ticker
    INNER JOIN account_dim AS ad ON hc.account_id = ad.account_id
    INNER JOIN customer_details AS cd ON cd.customer_id = ad.client_id
    WHERE
        customer_id = 919
    GROUP BY ticker
    ORDER BY risk_adj_returns DESC) AS experiment

;

-- CALCULATING THE PORTFOLIO PROFIT FOR CUSTOMER 10
SELECT 
    SUM(weight * mu) AS portfolioreturn
FROM
    (SELECT 
        customer_id,
            tr.ticker,
            AVG(returns) * 250 AS mu,
            STD(returns) * SQRT(250) AS sigma,
            AVG(returns) / STD(returns) AS risk_adj_returns,
            CASE
                WHEN STD(returns) >= 0.014 THEN 'Aggressive'
                ELSE 'conservative'
            END AS conservative_or_nah,
            hc.quantity,
            hc.value,
            (hc.quantity * hc.value) AS total_quantity,
            hc.quantity / 32465 AS weight
    FROM
        invest.team8_returns1 AS tr
    INNER JOIN holdings_current AS hc ON tr.ticker = hc.ticker
    INNER JOIN account_dim AS ad ON hc.account_id = ad.account_id
    INNER JOIN customer_details AS cd ON cd.customer_id = ad.client_id
    WHERE
        customer_id = 10
    GROUP BY ticker
    ORDER BY risk_adj_returns DESC) AS experiment

;

SELECT 
    SUM(quantity)
FROM
    holdings_current AS hc
        INNER JOIN
    account_dim AS ad ON hc.account_id = ad.account_id
        INNER JOIN
    customer_details AS cd ON ad.client_id = cd.customer_id
WHERE
    customer_id = 919
;


-- CALCULATING THE PORTFOLIO PROFIT FOR CUSTOMER 70
SELECT 
    SUM(weight * mu) AS portfolioreturn
FROM
    (SELECT 
        customer_id,
            tr.ticker,
            AVG(returns) * 250 AS mu,
            STD(returns) * SQRT(250) AS sigma,
            AVG(returns) / STD(returns) AS risk_adj_returns,
            CASE
                WHEN STD(returns) >= 0.014 THEN 'Aggressive'
                ELSE 'conservative'
            END AS conservative_or_nah,
            hc.quantity,
            hc.value,
            (hc.quantity * hc.value) AS total_quantity,
            hc.quantity / 41077 AS weight
    FROM
        invest.team8_returns1 AS tr
    INNER JOIN holdings_current AS hc ON tr.ticker = hc.ticker
    INNER JOIN account_dim AS ad ON hc.account_id = ad.account_id
    INNER JOIN customer_details AS cd ON cd.customer_id = ad.client_id
    WHERE
        customer_id = 70
    GROUP BY ticker
    ORDER BY risk_adj_returns DESC) AS experiment
;


DROP VIEW team8_returns10;

CREATE VIEW team8_returns10 AS
SELECT a.date, a.ticker, a.value, a.lagged_price, a.price_type,
(a.value-a.lagged_price)/a.lagged_price as returns
FROM 
(SELECT *, LAG(value,250) OVER(						-- lagged price of previous 1 year
							PARTITION BY ticker
                            ORDER BY date
                            ) as lagged_price
FROM invest.pricing_daily_new
WHERE price_type='Adjusted' AND date > '2019-09-09' -- Take a three-year average 
) a;

/* Because we have difference average return. We can use "sharp ratio" instead of "standard deviation" to compare the efficient stock.
The most efficient stock which is "LBAY" because they have the highest sharp ratio
with high return and low risk(standard deviation) */

SELECT 
    ticker,
    AVG(returns) AS Averagereturn,
    STD(returns) AS Standarddev,
    AVG(returns) / STD(returns) AS Sharpratio
FROM
    invest.team8_returns10
GROUP BY ticker
ORDER BY Sharpratio DESC;

/* Tesla is the most risky stock because its standard deviation is the highest.
However, It provided the highest return. We can suggest Tesla to customer who is not conservative */ 

SELECT 
    ticker,
    AVG(returns) AS Averagereturn,
    STD(returns) AS Standarddev,
    AVG(returns) / STD(returns) AS Sharpratio
FROM
    invest.team8_returns10
GROUP BY ticker
ORDER BY Standarddev DESC;

/* Another way to difine customer type who is aggressive(buy a lot equity) or
who is conservative (buy a lot of fixed asset, alternatives, commodities)
by SUM (hc.value*hc.quantity) Total value of each major_asset_class 
Example for customer_id 123 */
SELECT 
    ROUND(SUM(hc.value * hc.quantity), 0) AS totalvalue,
    (CASE
        WHEN sm.major_asset_class LIKE 'fixed%' THEN 'conservative'
        WHEN sm.major_asset_class = 'commodities' THEN 'conservative'
        WHEN sm.major_asset_class = 'alternatives' THEN 'conservative'
        ELSE 'aggressive'
    END) AS customertype
FROM
    holdings_current AS hc
        INNER JOIN
    account_dim AS ad ON hc.account_id = ad.account_id
        INNER JOIN
    security_masterlist AS sm ON hc.ticker = sm.ticker
WHERE
    client_id = '123'
GROUP BY customertype;
-- bo


