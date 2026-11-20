-- ===== PART 1: SUBQUERIES =====

SELECT c.company_name, AVG(i.price) AS average_price
FROM company c
JOIN items i ON c.company_id = i.company_id
GROUP BY c.company_name;

SELECT c.company_name, AVG(i.price) AS average_price
FROM company c
JOIN items i ON c.company_id = i.company_id
GROUP BY c.company_name
HAVING AVG(i.price) > (SELECT AVG(price) FROM items);

SELECT item_id, item_name, price, company_id
FROM items
WHERE price > (SELECT AVG(price) FROM items);

SELECT e.emp_id, e.emp_fname, e.emp_lname, e.emp_dept AS dept_code
FROM employees_new e
JOIN departments_new d ON e.emp_dept = d.dept_code
WHERE d.dept_budget > (SELECT AVG(dept_budget) FROM departments_new);

SELECT d.dept_code, d.dept_name
FROM departments_new d
JOIN employees_new e ON d.dept_code = e.emp_dept
GROUP BY d.dept_code, d.dept_name
HAVING COUNT(e.emp_id) > (
    SELECT AVG(emp_count)
    FROM (
        SELECT COUNT(*) AS emp_count
        FROM employees_new
        GROUP BY emp_dept
    ) AS t
);

SELECT item_id, item_name, price, company_id
FROM items i
WHERE price < (
    SELECT AVG(price)
    FROM items
    WHERE company_id = i.company_id
);

SELECT d.dept_code, d.dept_name, t.employee_count
FROM departments_new d
JOIN (
    SELECT emp_dept, COUNT(*) AS employee_count
    FROM employees_new
    GROUP BY emp_dept
    HAVING COUNT(*) = 1
) AS t ON d.dept_code = t.emp_dept;

SELECT c.company_name, AVG(i.price) AS average_price
FROM company c
JOIN items i ON c.company_id = i.company_id
GROUP BY c.company_name
HAVING AVG(i.price) = (
    SELECT MIN(avg_price)
    FROM (
        SELECT AVG(price) AS avg_price
        FROM items
        GROUP BY company_id
    ) AS t
);

SELECT e.emp_id, e.emp_fname, e.emp_lname, e.emp_dept AS dept_code
FROM employees_new e
JOIN departments_new d ON e.emp_dept = d.dept_code
WHERE d.dept_budget < (SELECT AVG(dept_budget) FROM departments_new);

-- ===== PART 2: CTE =====

WITH avg_price AS (
    SELECT AVG(price) AS avg_p
    FROM items
)
SELECT *
FROM items
WHERE price > (SELECT avg_p FROM avg_price);

WITH item_counts AS (
    SELECT company_id, COUNT(*) AS item_count
    FROM items
    GROUP BY company_id
)
SELECT c.company_name, ic.item_count
FROM company c
JOIN item_counts ic ON c.company_id = ic.company_id;

WITH company_avg AS (
    SELECT company_id, AVG(price) AS avg_price
    FROM items
    GROUP BY company_id
)
SELECT c.company_name, ca.avg_price
FROM company c
JOIN company_avg ca ON c.company_id = ca.company_id
WHERE ca.avg_price > 2000;

WITH emp_dept_info AS (
    SELECT CONCAT(e.emp_fname, ' ', e.emp_lname) AS full_name,
           d.dept_name
    FROM employees_new e
    JOIN departments_new d ON e.emp_dept = d.dept_code
)
SELECT * FROM emp_dept_info;

WITH avg_budget AS (
    SELECT AVG(dept_budget) AS avg_b
    FROM departments_new
)
SELECT d.*
FROM departments_new d
JOIN avg_budget a ON d.dept_budget > a.avg_b;

WITH emp_counts AS (
    SELECT emp_dept, COUNT(*) AS emp_count
    FROM employees_new
    GROUP BY emp_dept
)
SELECT d.dept_code, d.dept_name, ec.emp_count
FROM departments_new d
JOIN emp_counts ec ON d.dept_code = ec.emp_dept
WHERE ec.emp_count > 1;

WITH overall_avg AS (
    SELECT AVG(price) AS avg_p
    FROM items
),
company_avg AS (
    SELECT company_id, AVG(price) AS avg_price
    FROM items
    GROUP BY company_id
)
SELECT c.company_name, ca.avg_price
FROM company c
JOIN company_avg ca ON c.company_id = ca.company_id
JOIN overall_avg o ON ca.avg_price < o.avg_p;
