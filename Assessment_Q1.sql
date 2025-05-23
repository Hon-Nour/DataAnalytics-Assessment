-- Selecting user ID and name, along with key metrics
SELECT
    u.id AS owner_id,  -- Unique ID of the user
    CONCAT(u.first_name, ' ', u.last_name) AS name,            -- User's name

    -- Counting how many savings plans each user has
    SUM(CASE WHEN p.is_regular_savings = 1 THEN 1 ELSE 0 END) AS savings_count,

    -- Counting how many investment plans each user has
    SUM(CASE WHEN p.is_a_fund = 1 THEN 1 ELSE 0 END) AS investment_count,

    -- Calculating the total amount deposited across all plans
    SUM(sa.confirmed_amount) AS total_deposits

FROM
    users_customuser AS u  -- Main user table
JOIN 
    plans_plan AS p        -- Joining with plans table to get user plans
    ON u.id = p.owner_id
JOIN 
    savings_savingsaccount AS sa -- Joining with savings account table for transaction details
    ON p.id = sa.plan_id

WHERE
    sa.confirmed_amount > 0  -- Only considering funded plans
    AND (p.is_regular_savings = 1 OR p.is_a_fund = 1) -- Only savings or investment plans

GROUP BY
    u.id, u.name  -- Grouping by user to get results for each one

HAVING
    -- Ensuring each user has at least one savings plan
    SUM(CASE WHEN p.is_regular_savings = 1 THEN 1 ELSE 0 END) > 0  
    AND 
    -- Ensuring each user has at least one investment plan
    SUM(CASE WHEN p.is_a_fund = 1 THEN 1 ELSE 0 END) > 0           

ORDER BY
    total_deposits DESC;  -- Listing users with the highest total deposits first
