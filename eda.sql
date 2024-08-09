-- EDA : Exploratory Data Analysis

SELECT * 
FROM layoffs_dev2;

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_dev2;

SELECT * 
FROM layoffs_dev2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

SELECT company, SUM(total_laid_off)
FROM layoffs_dev2
GROUP BY company
ORDER BY 2 DESC;

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_dev2;

SELECT industry, SUM(total_laid_off)
FROM layoffs_dev2
GROUP BY industry
ORDER BY 2 DESC;

SELECT country, SUM(total_laid_off)
FROM layoffs_dev2
GROUP BY country
ORDER BY 2 DESC;

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_dev2
GROUP BY YEAR(`date`)
ORDER BY 2 DESC;

SELECT SUBSTRING(`date`, 1, 7) as `MONTH`, SUM(total_laid_off)
FROM layoffs_dev2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1;

WITH Rolling_Total AS
(
	SELECT SUBSTRING(`date`, 1, 7) as `MONTH`, SUM(total_laid_off) as total_laid
	FROM layoffs_dev2
	WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
	GROUP BY `MONTH`
	ORDER BY 1
)
SELECT `MONTH`, total_laid, SUM(total_laid) OVER (ORDER BY `MONTH`) as rolling_total_laid_off
FROM Rolling_Total;

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_dev2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

-- Ranking based on total_laid_offs on each year
WITH Company_Year (company, laid_year, total_laid_off) AS
(
	SELECT company, YEAR(`date`), SUM(total_laid_off)
	FROM layoffs_dev2
	GROUP BY company, YEAR(`date`)
)
SELECT *, DENSE_RANK() OVER (PARTITION BY laid_year ORDER BY total_laid_off DESC) AS laid_off_ranking
FROM Company_Year
WHERE laid_year IS NOT NULL
ORDER BY laid_off_ranking;

WITH Company_Year (company, laid_year, total_laid_off) AS
(
	SELECT company, YEAR(`date`), SUM(total_laid_off)
	FROM layoffs_dev2
	GROUP BY company, YEAR(`date`)
), Company_Year_Ranking AS
(
	SELECT *, DENSE_RANK() OVER (PARTITION BY laid_year ORDER BY total_laid_off DESC) AS laid_off_ranking
	FROM Company_Year
	WHERE laid_year IS NOT NULL
)
SELECT *
FROM Company_Year_Ranking
WHERE laid_off_ranking <= 5;