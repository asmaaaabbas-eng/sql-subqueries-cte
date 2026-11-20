# SQL Subqueries & CTEs

A set of 16 SQL problems solved with **MySQL**, focused on breaking complex questions into clear, readable steps using **subqueries** and **Common Table Expressions (CTEs)**.

## Dataset

Four related tables:

| Table | Columns used |
|---|---|
| `company` | `company_id`, `company_name` |
| `items` | `item_id`, `item_name`, `price`, `company_id` |
| `employees_new` | `emp_id`, `emp_fname`, `emp_lname`, `emp_dept` |
| `departments_new` | `dept_code`, `dept_name`, `dept_budget` |

## What's covered

### Part 1: Subqueries (9 questions)
- Average item price per company
- Companies whose average price is above the overall average (subquery in `HAVING`)
- Items priced above the overall average (subquery in `WHERE`)
- Employees in departments with a budget above / below the average budget
- Departments with more employees than the average department (derived table in `FROM`)
- Items priced below the average of **their own company** (correlated subquery)
- Departments with exactly one employee
- Companies whose average price equals the lowest company average

### Part 2: CTEs (7 questions)
- Items priced above the overall average
- Item count per company
- Companies with an average price above 2000
- Employee full name with department name
- Departments with a budget above the average
- Departments with more than one employee
- Companies below the overall average price (multiple CTEs in one query)

## Example

Companies whose average item price is higher than the overall average:

```sql
SELECT c.company_name, AVG(i.price) AS average_price
FROM company c
JOIN items i ON c.company_id = i.company_id
GROUP BY c.company_name
HAVING AVG(i.price) > (SELECT AVG(price) FROM items);
```

| company_name | average_price |
|---|---|
| TechZone | 2700.0000 |
| VisionTech | 3500.0000 |

The same idea with a CTE:

```sql
WITH avg_price AS (
    SELECT AVG(price) AS avg_p
    FROM items
)
SELECT *
FROM items
WHERE price > (SELECT avg_p FROM avg_price);
```

## Files

- `subqueries_and_cte.sql`: all queries, split into Part 1 and Part 2
- `subqueries_cte_queries_and_results.pdf`: every query with a screenshot of its result

## How to run

1. Create the four tables in MySQL and load the data.
2. Open `subqueries_and_cte.sql` in MySQL Workbench.
3. Run the queries one by one.

## Skills

SQL · MySQL · Subqueries · Correlated Subqueries · CTEs · Aggregations (`GROUP BY`, `HAVING`) · Data Analysis
