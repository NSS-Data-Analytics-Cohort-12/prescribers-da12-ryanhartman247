-- For this exericse, you'll be working with a database derived from the [Medicare Part D Prescriber Public Use File](https://www.hhs.gov/guidance/document/medicare-provider-utilization-and-payment-data-part-d-prescriber-0). More information about the data is contained in the Methodology PDF file. See also the included entity-relationship diagram.

-- 1. 
--     a. Which prescriber had the highest total number of claims (totaled over all drugs)? Report the npi and the total number of claims.
-- SELECT
-- 	prescriber.npi AS prescriber,
-- 	SUM(prescription.total_claim_count) AS sum_of_claims
-- FROM prescriber
-- JOIN prescription
-- 	ON prescriber.npi = prescription.npi
-- GROUP BY 1
-- ORDER BY 2 DESC  

--     b. Repeat the above, but this time report the nppes_provider_first_name, nppes_provider_last_org_name,  specialty_description, and the total number of claims.
-- SELECT
-- 	-- prescriber.npi AS prescriber,
-- 	nppes_provider_first_name, 
-- 	nppes_provider_last_org_name, 
-- 	specialty_description,
-- 	SUM(prescription.total_claim_count) AS sum_of_claims
-- FROM prescriber
-- JOIN prescription
-- 	ON prescriber.npi = prescription.npi
-- GROUP BY 1, 2, 3
-- ORDER BY 4 DESC   


-- 2. 
--     a. Which specialty had the most total number of claims (totaled over all drugs)?
-- SELECT
-- 	prescriber.specialty_description,
-- 	SUM(prescription.total_claim_count)::MONEY
-- FROM prescriber
-- JOIN prescription 
-- 	ON prescriber.npi = prescription.npi
-- GROUP BY 1
-- ORDER BY 2 DESC

--     b. Which specialty had the most total number of claims for opioids?
-- SELECT
-- 	prescriber.specialty_description,
-- 	SUM(prescription.total_claim_count) sum_of_claims
-- FROM prescriber
-- JOIN prescription 
-- 	ON prescriber.npi = prescription.npi 
-- JOIN drug
-- 	ON prescription.drug_name = drug.drug_name
-- WHERE drug.opioid_drug_flag = 'Y'
-- GROUP BY 1
-- ORDER BY 2 DESC

--     c. **Challenge Question:** Are there any specialties that appear in the prescriber table that have no associated prescriptions in the prescription table?

-- SELECT DISTINCT specialty_description
-- FROM prescriber
-- WHERE specialty_description NOT IN
-- 	(SELECT prescriber.specialty_description
-- 	FROM prescription
-- 	JOIN prescriber  
-- 	ON prescription.npi = prescriber.npi)
-- ORDER BY 1 

--Couldn't get this one to work. It does now!!
-- (SELECT 
-- 	specialty_description
-- FROM prescriber
-- 	LEFT JOIN prescription
-- 	USING(npi))
-- EXCEPT
-- (SELECT 
-- 	specialty_description
-- FROM prescription
-- 	LEFT JOIN prescriber
-- 	USING(npi))

--Original answer. There are so many ways to solve! 
-- SELECT
-- 	prescriber.specialty_description,
-- 	COUNT(prescription.*)
-- FROM prescriber
-- LEFT JOIN prescription
-- 	ON prescriber.npi = prescription.npi
-- GROUP BY 1
-- HAVING COUNT(prescription.*) = 0
-- ORDER BY 2

--     d. **Difficult Bonus:** *Do not attempt until you have solved all other problems!* For each specialty, report the percentage of total claims by that specialty which are for opioids. Which specialties have a high percentage of opioids?

-- SELECT
--     prescriber.specialty_description,
--     CASE
-- 		WHEN drug.opioid_drug_flag = 'Y' THEN 'Yes'
-- 		WHEN drug.opioid_drug_flag = 'N' THEN 'No'
-- 		ELSE 'n/a'
-- 	END AS opioid_drug_flag,
--     SUM(prescription.total_claim_count) AS sum_claim_count,
--     ROUND(SUM(prescription.total_claim_count) * 100 / SUM(SUM(prescription.total_claim_count)) OVER (PARTITION BY prescriber.specialty_description))||'%' AS percentage_of_specialty
-- FROM prescriber
-- JOIN prescription
--     ON prescriber.npi = prescription.npi
-- JOIN drug
--     ON prescription.drug_name = drug.drug_name
-- --WHERE opioid_drug_flag = 'Y'
-- GROUP BY 1, 2
-- ORDER BY 1, 2

--answer key 
-- SELECT
-- 	specialty_description,
-- 	SUM(
-- 		CASE WHEN opioid_drug_flag = 'Y' THEN total_claim_count
-- 		ELSE 0
-- 	END
-- 	) as opioid_claims,
-- 	SUM(total_claim_count) AS total_claims,
-- 	SUM(
-- 		CASE WHEN opioid_drug_flag = 'Y' THEN total_claim_count
-- 		ELSE 0
-- 	END
-- 	) * 100.0 /  SUM(total_claim_count) AS opioid_percentage
-- FROM prescriber
-- INNER JOIN prescription
-- USING(npi)
-- INNER JOIN drug
-- USING(drug_name)
-- GROUP BY specialty_description
-- ORDER BY opioid_percentage DESC;

-- 3. 
--     a. Which drug (generic_name) had the highest total drug cost?
-- SELECT
-- 	generic_name,
-- 	SUM(total_drug_cost)::MONEY
-- FROM drug d
-- JOIN prescription p
-- 	ON d.drug_name = p.drug_name
-- GROUP BY 1
-- ORDER BY 2 DESC
-- LIMIT 10

--     b. Which drug (generic_name) has the hightest total cost per day? **Bonus: Round your cost per day column to 2 decimal places. Google ROUND to see how this works.*
-- I can't figure out how to get total cost per day from the ERD???
--not sure if this is right..
-- SELECT
-- 	d.generic_name,
-- 	SUM(p.total_drug_cost) / SUM(p.total_day_supply) AS drug_cost_per_day
-- FROM prescription p
-- JOIN drug d
-- USING(drug_name)
-- GROUP BY 1
-- ORDER BY 2


-- 4. 
--     a. For each drug in the drug table, return the drug name and then a column named 'drug_type' which says 'opioid' for drugs which have opioid_drug_flag = 'Y', says 'antibiotic' for those drugs which have antibiotic_drug_flag = 'Y', and says 'neither' for all other drugs. **Hint:** You may want to use a CASE expression for this. See https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-case/ 

-- SELECT
-- 	drug_name,
-- 	CASE
-- 		WHEN opioid_drug_flag = 'Y' THEN 'opioid'
-- 		WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
-- 		ELSE 'neither'
-- 	END AS drug_type
-- FROM drug 


--     b. Building off of the query you wrote for part a, determine whether more was spent (total_drug_cost) on opioids or on antibiotics. Hint: Format the total costs as MONEY for easier comparision.
-- SELECT
-- 	CASE
-- 		WHEN d.opioid_drug_flag = 'Y' OR d.long_acting_opioid_drug_flag = 'Y' THEN 'opioid'
-- 		WHEN d.antibiotic_drug_flag = 'Y' THEN 'antibiotic'
-- 		WHEN d.antipsychotic_drug_flag = 'Y' THEN 'antipsychotic'
-- 		ELSE 'neither'
-- 	END AS drug_type,
-- 	SUM(p.total_drug_cost)::MONEY AS total_cost
-- FROM drug d
-- JOIN prescription p 
-- 	ON d.drug_name = p.drug_name
-- GROUP BY 1
-- ORDER BY 2 DESC


-- 5. 
--     a. How many CBSAs are in Tennessee? **Warning:** The cbsa table contains information for all states, not just Tennessee.

-- SELECT COUNT(*)
-- FROM cbsa
-- WHERE state = 'TN'

--     b. Which cbsa has the largest combined population? Which has the smallest? Report the CBSA name and total population.
-- SELECT
-- 	c.cbsaname,
-- 	TO_CHAR(SUM(p.population), 'FM999,999,999,999') AS total_population
-- FROM cbsa c
-- JOIN population p -- is this population table only for TN?? 
-- 	ON c.fipscounty = p.fipscounty
-- GROUP BY 1
-- ORDER BY SUM(p.population)DESC

-- or this one?? I get confused as to when to use SUM?
-- SELECT
-- 	c.cbsaname,
-- 	MAX(p.population) AS total_population
-- FROM cbsa c
-- JOIN population p -- is this population table only for TN?? 
-- 	ON c.fipscounty = p.fipscounty
-- GROUP BY 1
-- ORDER BY 2 DESC

--Need to do SUM because there are multiple population fields for a single cbsaname field. See below. 
-- SELECT 
-- 	c.cbsaname,
-- 	p.population
-- FROM cbsa c
-- JOIN population p
-- ON c.fipscounty = p.fipscounty
-- ORDER BY 2 DESC

--     c. What is the largest (in terms of population) county which is not included in a CBSA? Report the county name and population.

-- SELECT
-- 	county,
-- 	population
-- FROM fips_county f
-- JOIN population p
-- 	ON f.fipscounty = p.fipscounty
-- WHERE f.fipscounty NOT IN
-- 	(SELECT cbsa.fipscounty FROM cbsa)
-- ORDER BY 2 DESC

-- 6. 
--     a. Find all rows in the prescription table where total_claims is at least 3000. Report the drug_name and the total_claim_count.
-- SELECT 
-- 	drug_name,
-- 	total_claim_count
-- FROM prescription
-- WHERE total_claim_count > 3000


--     b. For each instance that you found in part a, add a column that indicates whether the drug is an opioid.
-- SELECT 
-- 	p.drug_name,
-- 	p.total_claim_count,
-- 	CASE
-- 		WHEN opioid_drug_flag = 'Y' THEN 'opioid'
-- 		ELSE 'non opioid'
-- 	END AS drug_type
-- FROM prescription p 
-- JOIN drug d
-- 	on p.drug_name = d.drug_name
-- WHERE total_claim_count > 3000


--     c. Add another column to you answer from the previous part which gives the prescriber first and last name associated with each row.
-- SELECT 
-- 	p.drug_name,
-- 	p.total_claim_count,
-- 	CASE
-- 		WHEN opioid_drug_flag = 'Y' THEN 'opioid'
-- 		ELSE 'non opioid'
-- 	END AS drug_type,
-- 	nppes_provider_first_name,
-- 	nppes_provider_last_org_name
-- FROM prescription p 
-- JOIN drug d
-- 	on p.drug_name = d.drug_name
-- JOIN prescriber p2
-- 	ON p.npi = p2.npi
-- WHERE total_claim_count > 3000
-- ORDER BY 2 DESC


-- 7. The goal of this exercise is to generate a full list of all pain management specialists in Nashville and the number of claims they had for each opioid. **Hint:** The results from all 3 parts will have 637 rows.

--     a. First, create a list of all npi/drug_name combinations for pain management specialists (specialty_description = 'Pain Management) in the city of Nashville (nppes_provider_city = 'NASHVILLE'), where the drug is an opioid (opiod_drug_flag = 'Y'). **Warning:** Double-check your query before running it. You will only need to use the prescriber and drug tables since you don't need the claims numbers yet.

-- SELECT
-- 	p.npi,
-- 	d.drug_name
-- FROM prescriber p
-- CROSS JOIN drug d
-- WHERE
-- 	p.specialty_description = 'Pain Management' AND
-- 	UPPER(p.nppes_provider_city) = 'NASHVILLE' AND
-- 	d.opioid_drug_flag = 'Y' 
	

--     b. Next, report the number of claims per drug per prescriber. Be sure to include all combinations, whether or not the prescriber had any claims. You should report the npi, the drug name, and the number of claims (total_claim_count).

-- SELECT
-- 	p.npi,
-- 	d.drug_name,
-- 	SUM(p2.total_claim_count) AS sum_total_claim_count
-- FROM prescriber p
-- CROSS JOIN drug d
-- LEFT JOIN prescription p2
-- 	ON p2.drug_name = d.drug_name
-- WHERE
-- 	p.specialty_description = 'Pain Management' AND
-- 	UPPER(p.nppes_provider_city) = 'NASHVILLE' AND
-- 	d.opioid_drug_flag = 'Y'
-- GROUP BY 1,2
-- ORDER BY 3 DESC 

--UPDATED! 
-- SELECT 
-- 	prescriber.npi, 
-- 	drug.drug_name, 
-- 	prescription.total_claim_count AS total_claims
-- FROM prescriber
-- CROSS JOIN drug
-- LEFT JOIN prescription
-- 	ON prescriber.npi = prescription.npi
-- 	AND drug.drug_name = prescription.drug_name
-- WHERE prescriber.specialty_description = 'Pain Management'
-- 	AND prescriber.nppes_provider_city = 'NASHVILLE'
-- 	AND opioid_drug_flag = 'Y'
-- ORDER BY 3


--     c. Finally, if you have not done so already, fill in any missing values for total_claim_count with 0. Hint - Google the COALESCE function.

-- SELECT 
-- 	prescriber.npi, 
-- 	drug.drug_name, 
-- 	COALESCE(prescription.total_claim_count, 0) AS total_claims
-- FROM prescriber
-- CROSS JOIN drug
-- LEFT JOIN prescription
-- 	ON prescriber.npi = prescription.npi
-- 	AND drug.drug_name = prescription.drug_name
-- WHERE prescriber.specialty_description = 'Pain Management'
-- 	AND prescriber.nppes_provider_city = 'NASHVILLE'
-- 	AND opioid_drug_flag = 'Y'
-- ORDER BY 3 DESC
