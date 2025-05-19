-- Calculate the number of transactions each user makes per month
WITH monthly_transactions AS (
    SELECT 
        s.owner_id,  
        DATE_FORMAT(s.transaction_date, '%Y-%m') AS transaction_month, 
        COUNT(s.id) AS monthly_transaction_count 
    FROM 
        savings_savingsaccount AS s  -- Main table with transaction records
    GROUP BY 
        s.owner_id, transaction_month -- Grouping by user and month for accurate counts
), 

-- Calculate each user's average transaction frequency per month
user_average_frequency AS (
    SELECT 
        owner_id,  
        -- Calculating the average number of transactions per month for each user
        AVG(monthly_transaction_count) AS avg_transactions_per_month,

        -- Categorizing users based on their average transaction frequency
        CASE
            WHEN ROUND(AVG(monthly_transaction_count), 0) >= 10 THEN 'High Frequency'  -- 10 or more transactions per month
            WHEN ROUND(AVG(monthly_transaction_count), 0) >= 3 THEN 'Medium Frequency' -- Between 3 and 9 transactions per month
            ELSE 'Low Frequency' -- 2 or fewer transactions per month
        END AS frequency_category
    FROM 
        monthly_transactions  -- Using the previous CTE
    GROUP BY 
        owner_id  
)

-- Summarize the data by frequency category
SELECT 
    frequency_category,  -- The transaction frequency category (High, Medium, Low)
    COUNT(*) AS customer_count,  -- Number of users in each category
    ROUND(AVG(avg_transactions_per_month), 2) AS avg_transactions_per_month -- Average transactions for each category
FROM 
    user_average_frequency  -- Using the calculated averages
GROUP BY 
    frequency_category  -- Grouping by frequency category for the summary
ORDER BY 
    frequency_category DESC;  -- Listing categories from highest to lowest (High, Medium, Low)
