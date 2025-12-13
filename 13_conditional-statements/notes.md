### Conditional Logic Using Variables in SQL

SQL supports variables and conditional statements that allow queries to behave dynamically based on runtime values. This is commonly used in reports, stored procedures, APIs, and business rules.

### Variable Declaration

Variables are used to temporarily store values that can be referenced in SQL statements.
They help make queries flexible, reusable, and easier to maintain.

- Variables can store values such as numbers, strings, dates, or flags.
- Values can be assigned directly or calculated from queries.
- Variable support and syntax may vary slightly between databases.

### Using Variables in Queries

Variables can be used in SELECT, INSERT, UPDATE, and DELETE statements to control:

- Which records are returned
- How values are calculated
- Whether certain operations should execute

This allows the same query to behave differently without modifying SQL code.

### Conditional Execution (IF / ELSE)

SQL supports conditional execution where statements run based on a variable’s value.

- If a condition evaluates to true, one block of SQL executes.
- Otherwise, an alternative block executes.
- This is useful for role-based logic, validations, and business workflows.

### Conditional Expressions (CASE)

The CASE expression provides if–else logic inside queries.

- It evaluates conditions sequentially.
- Returns values based on matching conditions.
- Commonly used for categorization, dynamic calculations, and status mapping.

### Optional Filtering Using Variables

Variables can be used to build optional filters.

- When a variable is null, the filter is ignored.
- When a value is provided, the result set is filtered accordingly.

This approach is widely used in search APIs and reporting screens.

### Handling NULL Values

SQL provides built-in functions to handle null values conditionally:

- Replace missing values with defaults
- Prevent calculation errors
- Apply safe logic for optional data

These functions improve data consistency and query safety.

### Conditional Data Modification

Variables can control data changes during:

- Updates (e.g., apply price increase based on category)
- Inserts (e.g., insert only if record does not exist)

This ensures data integrity and prevents unwanted modifications.

### Benefits of Using Variables and Conditional Logic

- Improves query reusability
- Reduces hard-coded values
- Supports dynamic business rules
- Enhances readability and maintainability
- Essential for stored procedures and APIs
