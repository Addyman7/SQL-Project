SELECT * FROM addy7.`credit card transactions - india - simple`;
/* TASK 1 */

SELECT City, SUM(Amount) AS TotalSpends, (SUM(Amount) * 100.0 / (SELECT SUM(Amount) From addy7.`credit card transactions - india - simple`)) AS PercentageContribution
From addy7.`credit card transactions - india - simple` GROUP BY City ORDER BY TotalSpends DESC LIMIT 5;
/* TASK 2*/

UPDATE addy7.`credit card transactions - india - simple`
SET Date = DATE_FORMAT(STR_TO_DATE(Date, '%d-%b-%y'), '%Y-%m-%d');

select * from addy7.`credit card transactions - india - simple`;
SELECT `Card Type`, 
       CASE `Month`
           WHEN 1 THEN 'Jan'
           WHEN 2 THEN 'Feb'
           WHEN 3 THEN 'Mar'
           WHEN 4 THEN 'Apr'
           WHEN 5 THEN 'May'
           WHEN 6 THEN 'Jun'
           WHEN 7 THEN 'Jul'
           WHEN 8 THEN 'Aug'
           WHEN 9 THEN 'Sep'
           WHEN 10 THEN 'Oct'
           WHEN 11 THEN 'Nov'
           WHEN 12 THEN 'Dec'
       END AS `Month`,
       `TotalSpent`
FROM (
  SELECT `Card Type`, MONTH(`Date`) AS `Month`, SUM(`Amount`) AS `TotalSpent`
  FROM addy7.`credit card transactions - india - simple`
  GROUP BY `Card Type`, `Month`
) AS subquery
WHERE (`Card Type`, `TotalSpent`) IN (
  SELECT `Card Type`, MAX(`TotalSpent`)
  FROM (
    SELECT `Card Type`, MONTH(`Date`) AS `Month`,SUM(`Amount`) AS `TotalSpent`
    FROM addy7.`credit card transactions - india - simple`
    GROUP BY `Card Type`, `Month`
  ) AS max_subquery
  GROUP BY `Card Type`
)
ORDER BY FIELD(`Card Type`, 'Signature', 'Silver', 'Platinum', 'Gold');
/* TASK 4 */

SELECT City, (SUM(CASE WHEN `Card Type` = 'Gold' THEN Amount ELSE 0 END) / SUM(Amount)) * 100 AS percentage_spend 
FROM addy7.`credit card transactions - india - simple` 
GROUP BY City 
HAVING percentage_spend > 0 
ORDER BY percentage_spend ASC 
LIMIT 1;
/* TASK 5 */

SELECT City,MAX(`Exp Type`) AS highest_expense_type,MIN(`Exp Type`) AS lowest_expense_type 
FROM addy7.`credit card transactions - india - simple` 
GROUP BY City;
/* TASK 6 */

SELECT `Exp Type`,CONCAT(ROUND((SUM(CASE WHEN Gender = 'F' THEN Amount ELSE 0 END) / SUM(Amount)) * 100, 2), '%') AS female_percentage 
FROM addy7.`credit card transactions - india - simple` 
GROUP BY `Exp Type`;
/* TASK 7*/

SELECT `Card Type`,`Exp Type`,(SUM(Amount) - LAG(SUM(Amount)) OVER (PARTITION BY `Card Type`, `Exp Type` ORDER BY `Date`)) AS growth
FROM addy7.`credit card transactions - india - simple`
WHERE DATE_FORMAT(Date, '%b-%Y') = 'Jan-2014'
GROUP BY `Card Type`, `Exp Type`, `Date`
ORDER BY growth DESC
LIMIT 1;
/* TASK 8 */

SELECT City,SUM(Amount) / COUNT(*) AS spend_transaction_ratio
FROM addy7.`credit card transactions - india - simple`
WHERE DAYOFWEEK(Date) IN (1, 7) -- Filter for weekends (Sunday = 1, Saturday = 7)
GROUP BY City
ORDER BY spend_transaction_ratio DESC
LIMIT 1;
/* TASK 9 */

SELECT City,DATEDIFF(MIN(Date), MIN(first_transaction_date)) AS days_to_500th_transaction
FROM (
  SELECT City,Date,MIN(Date) OVER (PARTITION BY City) AS first_transaction_date,ROW_NUMBER() OVER (PARTITION BY City ORDER BY Date) AS transaction_count
  FROM addy7.`credit card transactions - india - simple`
) AS subquery
WHERE transaction_count = 500
GROUP BY City
ORDER BY days_to_500th_transaction ASC
LIMIT 1;
