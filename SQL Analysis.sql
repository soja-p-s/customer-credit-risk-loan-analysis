CREATE TABLE credit_data (
    age INTEGER,
    income NUMERIC,
    loanamount NUMERIC,
    creditscore NUMERIC,
    yearsexperience INTEGER,
    gender VARCHAR(10),
    education VARCHAR(50),
    city VARCHAR(50),
    employmenttype VARCHAR(50),
    loanapproved INTEGER,
    income_loan_ratio NUMERIC,
    risklevel VARCHAR(20),
    experiencegroup VARCHAR(20),
    incomegroup VARCHAR(20)
);
SELECT * FROM credit_data LIMIT 10;
SELECT COUNT(*) FROM credit_data;


"Add ID Column to Existing Table"

ALTER TABLE credit_data
ADD COLUMN id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY;
SELECT * FROM credit_data LIMIT 10;


"1. Create KPI VIEW" 


CREATE VIEW kpi_summary AS
SELECT
    COUNT(*) AS total_customers,
    
    ROUND(AVG(loanapproved)*100,2) AS approval_rate_percent,
    
    ROUND(AVG(income),2) AS avg_income,
    
    ROUND(AVG(loanamount),2) AS avg_loan_amount,
    
    SUM(CASE WHEN risklevel = 'High Risk' THEN 1 ELSE 0 END) AS high_risk_customers,
    
    ROUND(
        SUM(CASE WHEN risklevel = 'High Risk' THEN 1 ELSE 0 END)*100.0 / COUNT(*),
        2
    ) AS high_risk_percent

FROM credit_data;
'loan Approval Analysis view'

CREATE VIEW loan_approval_analysis AS
SELECT 
    gender,
    education,
    employmenttype,
    city,
    COUNT(*) AS total_customers,
    ROUND(AVG(loanapproved)*100,2) AS approval_rate
FROM credit_data
GROUP BY gender, education, employmenttype, city;
SELECT * FROM loan_approval_analysis ;

"CREDIT RISK ANALYSIS VIEW"

CREATE VIEW credit_risk_analysis AS
SELECT 
    risklevel,
    COUNT(*) AS total_customers,
    ROUND(AVG(loanapproved)*100,2) AS approval_rate,
    ROUND(AVG(creditscore),2) AS avg_credit_score,
    ROUND(AVG(income_loan_ratio),2) AS avg_income_loan_ratio
FROM credit_data
GROUP BY risklevel; 

"CUSTOMER SEGMENTATION VIEW"

CREATE VIEW customer_segmentation AS
SELECT 
    incomegroup,
    experiencegroup,
    employmenttype,
    COUNT(*) AS total_customers,
    ROUND(AVG(income),2) AS avg_income,
    ROUND(AVG(loanamount),2) AS avg_loan_amount,
    ROUND(AVG(loanapproved)*100,2) AS approval_rate
FROM credit_data
GROUP BY incomegroup, experiencegroup, employmenttype;

"ADVANCED ANALYSIS VIEW"

CREATE VIEW advanced_analysis AS
SELECT 
    gender,
    employmenttype,
    incomegroup,
    risklevel,
    COUNT(*) AS total_customers,
    
    ROUND(AVG(loanapproved)*100,2) AS approval_rate,
    
    ROUND(AVG(income),2) AS avg_income,
    ROUND(AVG(loanamount),2) AS avg_loan_amount,
    
    ROUND(AVG(income_loan_ratio),2) AS avg_ratio

FROM credit_data
GROUP BY gender, employmenttype, incomegroup, risklevel;

"Rejected Customers Analysis" 

CREATE VIEW rejection_analysis AS
SELECT 
    employmenttype,
    incomegroup,
    risklevel,
    COUNT(*) AS rejected_count
FROM credit_data
WHERE loanapproved = 0
GROUP BY employmenttype, incomegroup, risklevel;