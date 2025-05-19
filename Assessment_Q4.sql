-- Calculate customer tenure in months
WITH customer_tenure AS ( 
    SELECT 
        u.id AS customer_id,  -- Unique ID for each customer
        CONCAT(u.first_name, ' ', u.last_name) AS name,               -- Customer's name
        TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months  -- How long they've been with us, in months
    FROM 
        users_customuser AS u
),

-- Summarise transaction data and calculate total profit per customer
customer_transactions AS (
    SELECT 
        s.owner_id AS customer_id,  -- Links transactions to the customer
        COUNT(s.id) AS total_transactions,  -- Number of transactions made by the customer
        SUM(s.confirmed_amount) * 0.001 AS total_profit  -- 0.1% of total transaction value as profit
    FROM 
        savings_savingsaccount AS s
    GROUP BY 
        s.owner_id  -- Group transactions by customer
)

-- Combine customer tenure and transaction data to estimate customer lifetime value (CLV)
SELECT 
    ct.customer_id,  -- Customer's unique ID
    ct.name,         -- Customer's name
    ROUND(ct.tenure_months, 2) AS tenure_months,  -- Tenure rounded to two decimal places
    COALESCE(ctxn.total_transactions, 0) AS total_transactions,  -- Total transactions, or 0 if none
    ROUND(
        ((COALESCE(ctxn.total_transactions, 0) / ct.tenure_months) * 12 *  -- Annualized transaction frequency
         (COALESCE(ctxn.total_profit, 0) / COALESCE(ctxn.total_transactions, 1))),  -- Average profit per transaction
        2) AS estimated_clv  -- Final estimated customer lifetime value
FROM 
    customer_tenure AS ct
LEFT JOIN 
    customer_transactions AS ctxn 
    ON ct.customer_id = ctxn.customer_id  -- Match customers to their transaction data
ORDER BY 
    estimated_clv DESC;  -- Sort customers by estimated lifetime value, highest first
