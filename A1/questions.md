# Query Questions

## Basic Queries
<ol>
    <li>List all product names in alphabetical order (ORDER BY)</li>
    <li>List the product ID, name and price of all products in price and alphabetical name order
    (ORDER BY).</li>
    <li>List the product ID, name and price of all products from highest to lowest price and in
    alphabetical name order (ORDER BY, DESC).</li>
    <li>List all the products that cost $3.49 (WHERE, =).</li>
    <li>List all products that cost less than $10.00 (WHERE, <).</li>
    <li>List all products not made by vendor DLL01 (WHERE, <>).</li>
    <li>List all the products with a price between $5.00 and $10.00 (WHERE, BETWEEN).</li>
    <li>List any products made by either vendor DLL01 or vendor BRS01 costing $10.00 or
    greater (where, or, and, also look at order of evaluation using parenthesis).</li>
    <li>Return the average price of all the products in the Products table (AVG).</li>
    <li>Return the total number of customers in the Customers table (COUNT (*), AS result
    name). </li>
    <li>Return the number of customers in the Customers table with an e-mail address (COUNT
    (column name)). </li>
    <li>Return the number of product types, minimum, maximum and average product price
    from the products table.</li>
    <li>Joins: Return the vendor name, product price and product name from the vendors and
    products tables (JOIN or WHERE tablename.columnname, =).</li>
    <li>Return the product name, vendor name, product price and quantity for each item in
    order number 20007 (JOIN or WHERE tablename.columnname, =, AND)</li>
</ol>
<br>

## Sub Queries
<ol>
    <li>Create a list of all the customers (customer name and customer contact) who ordered
    item RGAN01.
    <ul>
        <li>Retrieve the order numbers of all orders containing item RGAN01.</li>
        <li>Retrieve the customer ID of all the customers who have orders listed in the order
        numbers returned in the previous step.</li>
        <li>Retrieve the customer information for all the customer IDs returned in the previous step.</li>
        <li>Work out each query then combine as nested sub queries.</li>
    </ul></li>  
    <li>Display the total number of orders placed by every customer in the Customers table, as
    well as the city the customer is in.
    <ul>
        <li>Retrieve the list of customers from the customers table</li>
        <li>For each customer retrieved, count the number of associated orders in the Orders
        treble.</li>
    </ul></li>
</ol>
<br>

## Combined Query
<ol>
    <li>Create a report on all the customers in Nelson and Wellington. You also should include
    all Fun4All locations, regardless of city. The resulting customers should be in
    alphabetical order of customer name then customer contact (WHERE, IN(), UNION,
    ORDER BY).</li>
</ol>
<br>

## Views
<ol>
    <li>Create a view called vProductCustomer which joins the Customer, Order and OrderItem
    tables to return a list of all customers who have ordered any product (CREATE VIEW, AS).
    Now retrieve from that view a list of customers who ordered product RGAN01.</li>
    <li>Add a customer to the database. Using a view to format mailing list data:
    <ul>
        <li>First create a query that will display the customer name and then the address in the
        following format: CustName Customer address City/town, Phone number.</li>
        <li>Next turn this query into a view called vCustomerMailingLabel</li>
        <li>Display all the “entries” in vCustomerMailingLabel</li>
        <li>Try defining the customer mailing label view so that it filters out any incomplete
        addresses as these cannot be used for mailing labels.</li>
    </ul></li>
</ol>