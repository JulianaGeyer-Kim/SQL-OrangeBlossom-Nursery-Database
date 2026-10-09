# Orange Blossom Nursery – SQL Group Project

A group project for my SQL course: a relational database designed for **Orange Blossom Nursery**, a plant nursery that sells to contractors, landscaping firms, and homeowners. The database tracks client orders, billing and payments, purchase orders, vendors, and employee specialties. The project includes SQL queries that answer real business questions.

## Project Overview

Orange Blossom handles large, multi-phase plant orders, payments made over time, and purchasing from multiple vendors. Without a structured database, this information is hard to manage and prone to error. The database centralizes the company's operational data so it can:

- Track plant orders by project, including size, color, quantity, and price
- Manage client accounts, payments, and outstanding balances
- Monitor purchase orders and vendor locations
- Record employee specialties to assign staff to the right projects
- Support inventory planning using historical order data

## Database Design

The database is normalized into **16 tables**:

| Area | Tables |
|------|--------|
| Client orders | `ClientOrderForm`, `ClientOrderItem`, `Item`, `Client`, `ProjectLocation` |
| Billing | `BillingForm`, `BillingPayment`, `Payment` |
| Purchasing | `PurchaseOrderForm`, `PurchaseItem`, `Vendor`, `VendorLocation` |
| Employees | `Employee`, `EmployeeSpecialty`, `Specialty` |
| Shared | `City` |

### Key Design Decisions

- Each project belongs to one client and is managed by one employee. A client can have many projects.
- Each plant has a fixed list price, but the actual sale price is stored on the order line, since employees may adjust it for job difficulty or discounts.
- Size and color are stored on the order line rather than the plant table, because they vary by project.
- Employees and specialties have a many-to-many relationship, handled with the `EmployeeSpecialty` table.
- Payments are tied to specific projects rather than general client accounts.
- Calculated values such as totals and balances are computed in queries instead of being stored.

## Queries

All queries are in `Queries.sql`, organized into three sections, one per business form.

### Client Orders

| # | Question | Technique |
|---|----------|-----------|
| 1 | What is the average sale price per item? | `INNER JOIN`, `AVG`, `GROUP BY` |
| 2 | Which clients have placed more than one project order? | `INNER JOIN`, `COUNT`, `GROUP BY`, `HAVING` |
| 3 | What is the total quantity of items ordered for each project? | `SUM`, `GROUP BY` |
| 4 | Which clients have never placed a project order? | `NOT IN` subquery |

### Billing

| # | Question | Technique |
|---|----------|-----------|
| 1 | Which clients have paid more than $500 in total? | Multi-table `INNER JOIN`, `SUM`, `GROUP BY`, `HAVING` |
| 2 | What is the average project cost per employee who has handled billing? | Multi-table `INNER JOIN`, `AVG`, `GROUP BY` |
| 3 | Which payments are above the average payment amount? | Subquery in `WHERE` |
| 4 | How many payments has each client made, and what is their remaining balance? | Multi-table `INNER JOIN`, `COUNT`, `SUM`, `GROUP BY` |

### Purchase Orders

| # | Question | Technique |
|---|----------|-----------|
| 1 | Which purchase orders were placed with each vendor location after January 1, 2024? | Multi-table `INNER JOIN`, date filter |
| 2 | Which employees processed more than one purchase order? | `INNER JOIN`, `COUNT`, `GROUP BY`, `HAVING` |
| 3 | How many purchase orders has each vendor received? | `INNER JOIN`, `COUNT`, `GROUP BY` |
| 4 | Which items have a list price higher than average? | Subquery in `WHERE` |

### Example Query

```sql
-- Which clients have a total amount paid exceeding $500?
SELECT client.ClientID, client.ClientFirstName, client.ClientLastName
FROM client
INNER JOIN billingform ON client.ClientID = billingform.ClientID
INNER JOIN billingpayment ON billingform.BillingID = billingpayment.BillingID
WHERE billingpayment.AmountPaid IS NOT NULL
GROUP BY client.ClientID, client.ClientFirstName, client.ClientLastName
HAVING SUM(billingpayment.AmountPaid) > 500;
```

## Business Scenarios

The queries support two realistic scenarios:

1. **End-of-Quarter Billing Review:** the finance manager identifies top-paying clients, reviews employee billing performance, and flags unusually large payments.
2. **Accounts Receivable Follow-Up:** the billing coordinator reviews each client's number of payments and remaining balance, then follows up on outstanding accounts.

## What's Included

| File | Description |
|------|-------------|
| `Queries.sql` | All SQL queries for the project |

## Tools Used

- MySQL
- MySQL Workbench (database modeling)

## Skills Demonstrated

- Relational database design and normalization
- Entity relationship diagrams
- SQL joins across multiple tables
- Aggregate functions with `GROUP BY` and `HAVING`
- Subqueries
- Translating business needs into queries
- Working in a team

## Team and Contributions

This was a group project completed with two teammates, who are credited anonymously.

- **Student 1** – wrote the Client Order queries
- **Student 2** – wrote the Purchase Order queries
- **Juliana Geyer-Kim (me)** – wrote the Billing queries

Database design, normalization, and the written report were completed as a team.

Each section of `Queries.sql` is labeled with its author.

## Author

Juliana Geyer-Kim – [GitHub Profile](https://github.com/JulianaGeyer-Kim)
