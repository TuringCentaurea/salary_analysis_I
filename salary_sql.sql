
-- Objectives and Investigation Areas Prior to Data Analysis
-- 1. Analysis of DA and DS Degree Distributions, Including Percentages and Counts
-- 2. Salary and Academic Background at Various Career Levels for Both Professions
-- 3. Experience Requirements Across Various Career Levels
-- 4. Trends in Gender Distribution for DA and DS

 

## 1.Data Cleaning and Validation
-- check the completeness of the dataset
select * from salary_data;
-- Correcting Import Name Errors
ALTER TABLE salary_data
RENAME COLUMN `锘緼ge` TO `age`;
select count(*) from salary_data;
select distinct(age) from salary_data;
select distinct(gender) from salary_data;
select distinct(`Education Level`) from salary_data;
select distinct(`Job Title`) from salary_data;
select distinct(`Years of Experience`) from salary_data;
select distinct(Salary) from salary_data;
-- Remove the null value or empty space for further analysis 
DELETE FROM salary_data where age is null and gender is null 
							and `Education Level` is null 
                            and `Job Title` is null
                            and `Years of Experience` is null 
                            and Salary is null;
DELETE FROM salary_data where age = '' and gender = ''
							and `Education Level` = ''
                            and `Job Title` = ''
                            and `Years of Experience` = '' 
                            and Salary = '';
-- Inconsistent Values
-- To avoid redundancy, we have merged the counts for 'Master's' and 'Master's Degree' as they refer to the same qualification, 
-- along with 'Bachelor' and 'Bachelor's Degree'
UPDATE salary_data
	SET `Education Level` = 'Bachelor'
    WHERE `Education Level` = 'Bachelor''s' OR `Education Level` = 'Bachelor''s Degree';
UPDATE salary_data
	SET `Education Level` = 'phD'
    WHERE `Education Level` = 'Bachelor''s' OR `Education Level` = 'PhD';
UPDATE salary_data
	SET `Education Level` = 'Master'
    WHERE `Education Level` = 'Master''s' OR `Education Level` = 'Master''s Degree';
-- count how many duplicate row in this dataset 
SELECT SUM(cnt - 1) AS total_duplicate_rows
FROM (
  SELECT 
    COUNT(*) AS cnt FROM salary_data
  GROUP BY age, Gender, `Education Level`, `Job Title`, `Years of Experience`, Salary
  HAVING COUNT(*) > 1
) AS duplicates;

    
#2. The dataset size for the upcoming analysis
select * from salary_data;
select count(*) from salary_data;
select count(*) from salary_data where `Job Title` like '%Data%';
select distinct(`Job Title`) from salary_data where `Job Title` like '%Data%';


-- Classify occupations by function
-- Add new column
ALTER TABLE salary_data
ADD COLUMN job_function VARCHAR(100);
-- Classify and update based on the new job titles.
UPDATE salary_data
SET job_function = CASE
    WHEN `Job Title` IN ('Chief Data Officer', 'Director of Data Science') THEN 'Leadership'
    WHEN `Job Title` IN ('Data Analyst', 'Junior Data Analyst', 'Senior Data Analyst') THEN 'Data Analysis'
    WHEN `Job Title` IN ('Data Scientist', 'Junior Data Scientist', 'Senior Data Scientist') THEN 'Data Science'
    WHEN `Job Title` IN ('Senior Data Engineer') THEN 'Data Engineering'
    WHEN `Job Title` IN ('Data Entry Clerk') THEN 'Administrative'
    ELSE 'Not Data Related'
END;
select * from salary_data;
select `Education Level` from salary_data group by `Education Level`;

select job_function, count(job_function), avg(`Salary`) from salary_data group by job_function;

-- Find the most common education level in each job function.
SELECT job_function,
       `Education Level`,
       freq
FROM (
    SELECT
        job_function,
        `Education Level`,
        COUNT(*) AS freq,
        -- Assign a rank within each job_title partition,
        -- ordered by frequency descending
        RANK() OVER (
            PARTITION BY job_function
            ORDER BY COUNT(*) DESC
        ) AS freq_rank
    FROM salary_data
    GROUP BY job_function, `Education Level`
) AS sub
WHERE freq_rank = 1;


SELECT *
FROM salary_data
INTO OUTFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\clean_salary_table.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

SHOW VARIABLES LIKE 'secure_file_priv';

   

