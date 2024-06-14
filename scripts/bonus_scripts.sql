-- 1. How many npi numbers appear in the prescriber table but not in the prescription table?

-- SELECT COUNT(DISTINCT specialty_description)
-- FROM prescriber
-- WHERE specialty_description NOT IN
-- 	(SELECT prescriber.specialty_description
-- 	FROM prescription
-- 	JOIN prescriber  
-- 	ON prescription.npi = prescriber.npi)
-- ORDER BY 1

-- 2.
--     a. Find the top five drugs (generic_name) prescribed by prescribers with the specialty of Family Practice.
-- SELECT generic_name, COUNT(*)
-- FROM drug
-- JOIN prescription
-- 	ON drug.drug_name = prescription.drug_name
-- JOIN prescriber
-- 	ON prescription.npi = prescriber.npi
-- WHERE prescriber.specialty_description = 'Family Practice'
-- GROUP BY 1
-- ORDER BY 2 DESC
-- LIMIT 5

--     b. Find the top five drugs (generic_name) prescribed by prescribers with the specialty of Cardiology.
-- SELECT generic_name, COUNT(*)
-- FROM drug
-- JOIN prescription
-- 	ON drug.drug_name = prescription.drug_name
-- JOIN prescriber
-- 	ON prescription.npi = prescriber.npi
-- WHERE prescriber.specialty_description = 'Cardiology'
-- GROUP BY 1
-- ORDER BY 2 DESC
-- LIMIT 5

--     c. Which drugs are in the top five prescribed by Family Practice prescribers and Cardiologists? Combine what you did for parts a and b into a single query to answer this question.

-- SELECT DISTINCT generic_name, COUNT(*)
-- FROM drug
-- JOIN prescription
-- 	ON drug.drug_name = prescription.drug_name
-- JOIN prescriber
-- 	ON prescription.npi = prescriber.npi
-- WHERE prescriber.specialty_description = 'Family Practice' OR
-- 	prescriber.specialty_description = 'Cardiology'
-- GROUP BY 1
-- ORDER BY 2 DESC
-- LIMIT 5


-- 3. Your goal in this question is to generate a list of the top prescribers in each of the major metropolitan areas of Tennessee.
--     a. First, write a query that finds the top 5 prescribers in Nashville in terms of the total number of claims (total_claim_count) across all drugs. Report the npi, the total number of claims, and include a column showing the city.


-- SELECT 
-- 	prescriber.npi,
-- 	prescriber.nppes_provider_city,
-- 	prescription.total_claim_count
-- FROM prescriber
-- JOIN prescription
-- 	ON prescriber.npi = prescription.npi
-- WHERE prescriber.nppes_provider_city = 'NASHVILLE'
-- ORDER BY 3 DESC
-- LIMIT 5

--old code
-- SELECT 
-- 	prescriber.npi,
-- 	prescriber.nppes_provider_city,
-- 	prescription.total_claim_count
-- FROM prescriber
-- JOIN prescription
-- 	ON prescriber.npi = prescription.npi
-- -- GROUP BY 1, 2 -- I hate that I have to group by 2 but I think this is still okay since the npi is a unique prescriber who only ever prescribes from a single city? 
-- ORDER BY 3 DESC
-- LIMIT 5


--     b. Now, report the same for Memphis.

-- SELECT 
-- 	prescriber.npi,
-- 	prescriber.nppes_provider_city,
-- 	prescription.total_claim_count
-- FROM prescriber
-- JOIN prescription
-- 	ON prescriber.npi = prescription.npi
-- WHERE prescriber.nppes_provider_city = 'MEMPHIS'
-- ORDER BY 3 DESC
-- LIMIT 5


--     c. Combine your results from a and b, along with the results for Knoxville and Chattanooga.

(SELECT 
	prescriber.npi,
	prescriber.nppes_provider_city,
	prescription.total_claim_count
FROM prescriber
JOIN prescription
	ON prescriber.npi = prescription.npi
WHERE prescriber.nppes_provider_city = 'NASHVILLE'
ORDER BY 3 DESC
LIMIT 5)
UNION ALL
(SELECT 
	prescriber.npi,
	prescriber.nppes_provider_city,
	prescription.total_claim_count
FROM prescriber
JOIN prescription
	ON prescriber.npi = prescription.npi
WHERE prescriber.nppes_provider_city = 'MEMPHIS'
ORDER BY 3 DESC
LIMIT 5)
UNION ALL
(SELECT 
	prescriber.npi,
	prescriber.nppes_provider_city,
	prescription.total_claim_count
FROM prescriber
JOIN prescription
	ON prescriber.npi = prescription.npi
WHERE prescriber.nppes_provider_city = 'KNOXVILLE'
ORDER BY 3 DESC
LIMIT 5)
UNION ALL
(SELECT 
	prescriber.npi,
	prescriber.nppes_provider_city,
	prescription.total_claim_count
FROM prescriber
JOIN prescription
	ON prescriber.npi = prescription.npi
WHERE prescriber.nppes_provider_city = 'CHATTANOOGA'
ORDER BY 3 DESC
LIMIT 5)
ORDER BY 3 DESC 


-- 4. Find all counties which had an above-average number of overdose deaths. Report the county name and number of overdose deaths.

-- 5.
--     a. Write a query that finds the total population of Tennessee.
    
--     b. Build off of the query that you wrote in part a to write a query that returns for each county that county's name, its population, and the percentage of the total population of Tennessee that is contained in that county.