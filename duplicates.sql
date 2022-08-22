Handling duplicates in SQL.

Identifying the duplicate entries
The first step should be to define which column or combination of columns forms the unique row. Once we have the set of columns that decide the 
uniqueness of the row we can use the following two strategies to find which column combinations have duplicate entries.

1. GROUP BY
We can use GROUP By to find out the number of time the combination of grouping columns appear in the table.
If the count is more than 1 it means there are two rows with the same values of the selected column combination. Hence giving the duplicated values.

SELECT col1, col2
FROM table_name
WHERE (col1, col2) IN (
    SELECT col1, col2 FROM table_name
    GROUP BY col1, col2 
    HAVING COUNT(*) > 1
    )
2. ROW_NUMBER with WINDOW
In SQL, PARTITION BY clause divides the result set into multiple partitions where each row in a given partition has the same value
for selected columns. If the set of column values is unique in the table then the partition with that column set will have single rows. 
Conversely, partitions with more than one row denote the presence of duplicate values. We use ROW_NUMBER() to assign a sequential integer to each row 
within the partition of a result set. A sequence (appearance/occurrence) greater than one means that the value is appearing more than one time.

WITH dedup AS (
 SELECT col1, col2,
  ROW_NUMBER() OVER (PARTITION BY col1, col2 ORDER BY col3 ASC) AS occurrence
 FROM
  table_name
 )
SELECT
 col1, col2
FROM
 dedup
WHERE
 occurrence > 1
Selecting the duplicate records
Now we would like to select the unique records from the dataset. We have many ways to do so. I am listing down 5 of them.

1. DISTINCT
The DISTINCT function in SQL returns the result with unique values.

SELECT DISTINCT col1, col2
FROM table_name
2. UNION
In SQL, UNION combines the results of two SELECT statements. At the same time, it removes the multiple occurrences of the rows in the resulting dataset 
and keeps only a single occurrence of each row.

SELECT col1, col2
FROM table_name
UNION
SELECT col1, col2
FROM table_name
3. INTERSECT
In SQL, INTERSECT is used to get the common rows of two SELECT queries. Similar to UNION , INTERSECT also removes the multiple occurrences of the rows 
in the resulting dataset and keeps only a single occurrence of each row.

SELECT col1, col2
FROM table_name
INTERSECT
SELECT col1, col2
FROM table_name
4. ROW_NUMBER
As discussed above, a sequence (appearance/occurrence) greater than one means that the value is appearing more than one time. 
And value 1 means the first appearance of the set of column values. Hence we filter the rows where the occurrence value is set to 1. This will result in unique rows.

WITH dedup AS (
 SELECT col1, col2,
  ROW_NUMBER() OVER (PARTITION BY col1, col2 ORDER BY col3 ASC) AS occurrence
 FROM
  table_name
 )
SELECT
 col1, col2
FROM
 dedup
WHERE
 occurrence = 1
5. GROUP BY
In SQL, GROUP BY returns a single row for each unique combination of the GROUP BY columns. Hence if we simply select the columns and group them by 
the same columns we will get the unique rows.

SELECT col1, col2
FROM table_name
GROUP BY col1, col2
Deleting the duplicate records and keeping one
Now we would like to delete the duplicate records from the dataset. This we can do using the ROW_NUMBER and PARTITION BY. 
To decide which rows to keep (latest/oldest or based on some other column) we can use ORDER BY in the window.

WITH dedup AS (
 SELECT col1, col2,
  ROW_NUMBER() OVER (PARTITION BY col1, col2 ORDER BY col3 ASC) AS occurrence
 FROM
  table_name
 )
delete from dedup where occurrence > 1 -- deletes the earliest (based on col3)
If we wish to decide to keep the latest one we can switch the order by value to DESC. Also if we wanted to keep two copies then we can change the 
where clause to occurrence > 2 .
