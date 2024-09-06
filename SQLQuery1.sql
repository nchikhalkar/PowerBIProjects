select * from [Bank loan project DB].[dbo].[financial_loan]

--1.	Total Loan Applications: 
SELECT COUNT(id) as Total_Loan_Application 
FROM financial_loan

--MTD Loan Applications and track changes Month-over-Month (MoM).

SELECT COUNT(id) as MTD_Loan_Application 
FROM financial_loan
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021

--PMTD Loan Applications and track changes Month-over-Month (MoM).

SELECT COUNT(id) as MTD_Loan_Application 
FROM financial_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021

--2.	Total Funded Amount: 
 SELECT SUM(loan_amount) as Total_Funded_Amount 
 FROM financial_loan


 --	MTD_Total Funded Amount: 
 SELECT SUM(loan_amount) as MTD_Total_Funded_Amount 
 FROM financial_loan
 WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021

  --	PMTD_Total Funded Amount: 
 SELECT SUM(loan_amount) as MTD_Total_Funded_Amount 
 FROM financial_loan
 WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021

 --3.	Total Amount Received: 

 SELECT SUM(total_payment) as Total_Amount_Received
 FROM financial_loan

  --	MTD_Total Amount Received: 

 SELECT SUM(total_payment) as MTD_Total_Amount_Received
 FROM financial_loan
  WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021

    --	PMTD_Total Amount Received: 

 SELECT SUM(total_payment) as PMTD_Total_Amount_Received
 FROM financial_loan
  WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021

  --4.	Average Interest Rate: 
  SELECT ROUND(AVG(int_rate),4) * 100 as Average_Interest_Rate
 FROM financial_loan

   --	MTD_Average Interest Rate: 
  SELECT ROUND(AVG(int_rate),4) * 100 as Average_Interest_Rate
 FROM financial_loan
 WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021

  --	PMTD_Average Interest Rate:
  SELECT ROUND(AVG(int_rate),4) * 100 as Average_Interest_Rate
 FROM financial_loan
 WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021

 --5.	Average Debt-to-Income Ratio (DTI): 
 SELECT ROUND(AVG(dti),4) * 100 as Average_DTI
 FROM financial_loan

 --MTD_Average Debt-to-Income Ratio (DTI): 
 SELECT ROUND(AVG(dti),4) * 100 as MTD_Average_DTI
 FROM financial_loan
  WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021
   
 SELECT ROUND(AVG(dti),4) * 100 as PMTD_Average_DTI
 FROM financial_loan
  WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021

  --1.	Good Loan Percentage: 
  SELECT
    ( COUNT(CASE WHEN loan_status = 'Fully Paid' OR loan_status = 'Current' THEN id END) * 100)
	/
	COUNT(id) as Good_Loan_Percentage
FROM financial_loan

--1.	Good Loan Application  

SELECT COUNT(id) AS Good_Loan_Application  
FROM financial_loan
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current'

--3.	Good Loan Funded Amount: 

SELECT SUM(loan_amount) AS Good_Loan_Funded_Amount
FROM financial_loan
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current'

--4.	Good Loan Total Received Amount:
SELECT SUM(total_payment) AS GoodLoan_Total_Received_Amount
from [Bank loan project DB].[dbo].[financial_loan]
WHERE loan_status IN ('Fully Paid','Current')
--Bad Loan KPIs:
--1.	Bad Loan  Percentage: 

SELECT
    ( COUNT(CASE WHEN loan_status = 'Charged off' THEN id END) * 100)
	/
	COUNT(id) as Bad_Loan_Percentage
FROM [Bank loan project DB].[dbo].[financial_loan]

--3.	Bad Loan Applications

SELECT COUNT(id) as Bad_Loan_Applications
FROM [Bank loan project DB].[dbo].[financial_loan]
WHERE loan_status = 'Charged off'

--3.	Bad Loan Funded Amount: 
SELECT SUM(loan_amount) as Bad_Loan_Applications
FROM [Bank loan project DB].[dbo].[financial_loan]
WHERE loan_status = 'Charged off'

--4.	Bad Loan Total Received Amount: 
SELECT SUM(total_payment) as Bad_Loan_Received_Amount
FROM [Bank loan project DB].[dbo].[financial_loan]
WHERE loan_status = 'Charged off'

--Loan Status

select 
    loan_status,
	COUNT(id) AS Total_Loan_Applications,
	SUM(total_payment) AS Total_Amount_Received,
	SUM(loan_amount) AS Total_Loan_Amount,
	AVG(int_rate * 100) AS Intrest_Rate,
	AVG(dti * 100) AS DTI
from [Bank loan project DB].[dbo].[financial_loan]
GROUP BY loan_status

--Loan Status Month to Date
select 
    loan_status,
	SUM(total_payment) AS MTD_Total_Amount_Received,
	SUM(loan_amount) AS MTD_Total_Loan_Amount
	
from [Bank loan project DB].[dbo].[financial_loan]
where MONTH(issue_date) = 12
GROUP BY loan_status

--1. Monthly Trends by Issue Date (Line Chart):

SELECT
    MONTH (issue_date) AS Month_Number,
    DATENAME(MONTH, issue_date) AS Month_Name,
	SUM(total_payment) AS Total_Amount_Received,
	SUM(loan_amount) AS Total_Loan_Amount	
FROM [Bank loan project DB].[dbo].[financial_loan]
GROUP BY MONTH (issue_date),DATENAME(MONTH, issue_date)
ORDER BY MONTH (issue_date) 

--2. Regional Analysis by State (Filled Map):
SELECT
    address_state,
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Loan_Amount,	
	SUM(total_payment) AS Total_Amount_Received
FROM [Bank loan project DB].[dbo].[financial_loan]
GROUP BY address_state
ORDER BY COUNT(id) DESC
--3. Loan Term Analysis (Donut Chart):
SELECT
    term,
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Loan_Amount,	
	SUM(total_payment) AS Total_Amount_Received
FROM [Bank loan project DB].[dbo].[financial_loan]
GROUP BY  term
ORDER BY  term

--4. Employee Length Analysis (Bar Chart):

SELECT
    emp_length,
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Loan_Amount,	
	SUM(total_payment) AS Total_Amount_Received
FROM [Bank loan project DB].[dbo].[financial_loan]
GROUP BY  emp_length
ORDER BY  COUNT(id) DESC

--5. Loan Purpose Breakdown (Bar Chart):
SELECT
    purpose,
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Loan_Amount,	
	SUM(total_payment) AS Total_Amount_Received
FROM [Bank loan project DB].[dbo].[financial_loan]
GROUP BY  purpose
ORDER BY  COUNT(id) DESC

--6. Home Ownership Analysis (Tree Map):
SELECT
    home_ownership,
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Loan_Amount,	
	SUM(total_payment) AS Total_Amount_Received
FROM [Bank loan project DB].[dbo].[financial_loan]
GROUP BY  home_ownership
ORDER BY  COUNT(id) DESC





