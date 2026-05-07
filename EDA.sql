-- Exploratoray Data Analysis

 SELECT *
 FROM layoffs_staging2;
 
 SELECT MAX(total_laid_off), MAX(percentage_laid_off)
 FROM layoffs_staging2;
 
 SELECT *
 FROM layoffs_staging2
 WHERE percentage_laid_off =1
 ORDER BY funds_raised_millions DESC;
 
 SELECT company, SUM(total_laid_off)
 FROM layoffs_staging2
 GROUP BY company
 ORDER BY 2 DESC;
 
SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;
 
 
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

WITH Rolling_total AS
(
SELECT SUBSTR(`date`,1,7) AS month ,SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTR(`date`,1,7) IS NOT NULL
GROUP BY  SUBSTR(`date`,1,7)
ORDER BY 1 
)
SELECT month ,total_off, SUM(total_off) OVER(ORDER BY month) AS rolling_total
FROM Rolling_total ;

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company,YEAR(`date`)
ORDER BY 3 DESC;

WITH company_year (company , years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company,YEAR(`date`)
) ,company_year_rank AS
(
SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM company_year
WHERE years IS NOT NULL
)
SELECT *
FROM company_year_rank
WHERE Ranking <=5;

SELECT company , industry , YEAR(`date`) AS year , funds_raised_millions
FROM layoffs_staging2
WHERE  funds_raised_millions >=100
ORDER BY funds_raised_millions DESC;








