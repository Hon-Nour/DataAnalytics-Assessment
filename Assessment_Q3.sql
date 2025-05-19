-- Retrieve details of inactive savings and investment plans
SELECT  
    p.id AS plan_id,  -- Plan identifier
    p.owner_id,       -- Owner of the plan
    CASE 
        WHEN p.is_regular_savings = 1 THEN 'savings' 
        WHEN p.is_a_fund = 1 THEN 'investment' 
        ELSE 'other' 
    END AS type,  -- Type of the plan
    MAX(s.transaction_date) AS last_transaction_date,  -- Most recent transaction date
    DATEDIFF(CURRENT_DATE, MAX(s.transaction_date)) AS inactivity_days  -- Days since the last transaction
FROM 
    plans_plan AS p
LEFT JOIN 
    savings_savingsaccount AS s 
    ON p.id = s.plan_id 
WHERE 
    (p.is_regular_savings = 1 OR p.is_a_fund = 1)  -- Only savings or investment plans
GROUP BY 
    p.id, p.owner_id
HAVING 
    inactivity_days >= 365  -- Plans inactive for at least a year
ORDER BY 
    inactivity_days DESC;  -- Show most inactive plans first
