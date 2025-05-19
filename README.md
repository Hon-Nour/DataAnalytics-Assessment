# DataAnalytics-Assessment
## Introduction

Personally, I think of SQL as like English: You just need to understand it. It helps to write it out first on paper, thinking about what you want the query to do. That’s my approach. I look at each question, break it down into clear steps, and build my query around those steps.

This project contains my solutions for the Cowrywise Data Analytics assessment, demonstrating my skills in data analysis, query optimisation, and problem-solving.

### Question1
For this problem, the goal was to list users who have both savings and investment plans, along with their total deposits. So, I started by asking myself a few questions:
1. How do I make sure each user has at least one of each?
2. How do I sum up all their deposits?
   
**From here, I knew the solution involved:**
1. Using CASE statements to count how many savings and investment plans each user has.
2. Filtering out users who don’t have both types of plans using HAVING.
3. Summing the deposits for each user and sorting them by the highest total as a form of order

**Challenges:**
1. One challenge I faced was accurately counting the different types of plans each user had without accidentally double-counting them. The solution was to use SUM with CASE statements, which is a clean way to count specific values within groups.
2. Performance Optimisation: The query was slow for large datasets because of the multiple SUM(CASE...END) conditions. I used SUM instead of COUNT for counting because it is faster and works well with the CASE condition.

### Question2
I broke down this customer analysis into simple steps:
First, I counted how many transactions each customer made per month. This shows us their actual usage patterns throughout the year.
Then I calculated each person's monthly average to see their typical behaviour.
Finally, I grouped everyone into these categories:

"High Frequency" (10+ transactions/month)
"Medium Frequency" (3-9 transactions/month)
"Low Frequency" (2 or fewer transactions/month)

**Challenges:**

The main challenge was figuring out the right way to average. I needed to average twice:
First average: Getting each customer's typical month (not just their total)
Second average: Finding what's normal within each frequency group
If I had just counted total transactions and divided by months, I would have missed the true pattern of how customers actually use the service month to month.

### Question3
For this task, I aimed to identify savings and investment plans that have been inactive for over a year. The query calculates the days since the last transaction for each relevant plan and filters out the ones with significant inactivity. The logic is straightforward:
1. Plan Type Identification: The CASE statement determines whether a plan is savings, investment, or another type.
2. Transaction Data Analysis: Using MAX on transaction dates identifies the most recent transaction for each plan.
3. Inactivity Calculation: The DATEDIFF function computes the number of days since the last transaction, with the assumption that today is the current date.
4. Filtering and Sorting: Plans inactive for over a year (inactivity_days >= 365) are filtered and sorted by inactivity length in descending order.

**Challenges:**
A key challenge was the absence of a specified "current date" for calculating inactivity. To address this, I confidently used CURRENT_DATE as a stand-in, assuming the query runs on today's date. This ensures the logic stays dynamic and works in real-time without needing manual updates to the query for each run. It’s a practical solution that keeps the query functional and efficient.

### Question4
My focus was on calculating customer tenure and summarising their transactions to estimate their lifetime value (CLV). I started by breaking the problem into two parts: understanding how long customers have been with the company and analysing their transactions. The approach uses two tables:
1. users_customuser: This table provides customer details and their joining date, which I used to calculate their tenure in months.
2. savings_savingsaccount: This table includes transaction data, which I used to compute the number of transactions and the total profit generated.

By joining these two tables, I combined the tenure and transaction data to calculate the estimated CLV, using a formula that incorporates transaction frequency and profit per transaction. The query sorts the results by CLV to highlight the most valuable customers.

**Challenges:**

Initially, I misunderstood the problem and assumed the company earned profits from withdrawals. This led me to include the withdrawals_withdrawal table and write queries based on it. However, after re-reading the question, I realised we were only supposed to use the users_customuser and savings_savingsaccount tables.

To resolve this, I adjusted my query to exclude withdrawal data and focused solely on the required tables. This ensured the query met the requirements while remaining accurate and efficient. It was a helpful reminder to double-check instructions
