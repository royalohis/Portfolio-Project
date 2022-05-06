
SELECT 
    *
FROM
    cdeathsdb
WHERE
    continent IS NOT NULL
ORDER BY 3 , 4;

SELECT 
    location,
    date,
    total_cases,
    new_cases,
    total_deaths,
    population
FROM
    cdeathsdb
WHERE
    continent IS NOT NULL
ORDER BY 1 , 2;


-- calculating total cases vs total deaths
-- likelihood of dying if you contact covid in your country 

SELECT 
    location,
    date,
    total_cases,
    total_deaths,
    (total_deaths / total_cases) * 100 AS DeathPercentage
FROM
    cdeathsdb
WHERE
    location LIKE '%Nigeria%'
ORDER BY 1 , 2;

-- looking at total cases vs population
SELECT 
    location,
    date,
    population,
    total_cases,
    (total_cases / population) * 100 AS PercentofPopulationInfection
FROM
    cdeathsdb
WHERE
    continent IS NOT NULL
ORDER BY 1 , 2;

-- looking at countries with the highest infection rates compate to their populations

SELECT 
    Location,
    MAX(total_cases) AS Highest_infection_count,
    Population,
    MAX((total_cases) / population) * 100 AS PercentagePopulationInfected
FROM
    cdeathsdb
WHERE
    continent IS NOT NULL
GROUP BY location , population
ORDER BY PercentagePopulationInfected DESC;

--  showing countries with the higest death count

SELECT 
    Location, MAX(total_deaths) AS TotalDeathCount
FROM
    cdeathsdb
WHERE
    location NOT IN ('Asia' , 'European Union',
        'europe',
        'Africa',
        'North America',
        'South America',
        'Oceania',
        'world')
GROUP BY location
ORDER BY TotalDeathCount DESC;

-- BREAKING THINGS DOWN BY CONTINENT
SELECT 
    Location, MAX(total_deaths) AS TotalDeathCount
FROM
    cdeathsdb
WHERE
    location IN ('Asia' , 'European Union',
        'europe',
        'Africa',
        'North America',
        'South America',
        'Oceania',
        'world')
GROUP BY location
ORDER BY TotalDeathCount DESC;

-- GLOBAL NUMBERS BY DATE
SELECT 
    Date,
    SUM(new_cases) AS RecordedCases,
    SUM(new_deaths) AS RecodedDeaths,
    (SUM(new_deaths) / SUM(new_cases)) * 100 AS DeathsPercentage
FROM
    cdeathsdb
GROUP BY date
ORDER BY RecordedCases DESC , RecodedDeaths DESC;
 
 -- Global numbers 
SELECT 
    SUM(new_cases) AS RecordedCases,
    SUM(new_deaths) AS RecodedDeaths,
    (SUM(new_deaths) / SUM(new_cases)) * 100 AS DeathsPercentage
FROM
    cdeathsdb
ORDER BY RecordedCases DESC , RecodedDeaths DESC;
 
 -- looking at total population vs vaccination

    select  cdea.continent, cdea.location, cdea.date, cdea.population,cvac.new_vaccinations,
    sum(cvac.new_vaccinations) OVER (partition by  cdea.location order by cdea.location, cdea.date) as VaccineRollingTotal -- (VaccineRollingTotal/ population) * 100
  from cdeathsdb cdea
  join covidvacines cvac
	on cdea.location = cvac.location
     AND
     cdea.date = cvac.date
     where cdea.continent IS NOT NULL AND cdea.continent <> ''
     order by 2,3;
     
     -- USING CTE
   with 
   cte_PopuVsVacc as 
     ( select  cdea.continent, cdea.location, cdea.date, cdea.population,cvac.new_vaccinations,
    sum(cvac.new_vaccinations) OVER (partition by  cdea.location order by cdea.location, cdea.date) as VaccineRollingTotal -- (VaccineRollingTotal/ population) * 100
   from cdeathsdb cdea
  join covidvacines cvac
	on cdea.location = cvac.location
     AND
     cdea.date = cvac.date
     where cdea.continent IS NOT NULL AND cdea.continent <> '')
     -- order by 2,3 
     SELECT * , (VaccineRollingTotal/ population) * 100 AS PercentVaccinated
     FROM 
     cte_PopuVsVacc;
     
     -- CREATING VIEWS FOR VISUALIZATION 
     -- (1) Population  VS Vaccinationa 
   CREATE VIEW cte_PopuVsVacc as 
      with 
   cte_PopuVsVacc as 
     ( select  cdea.continent, cdea.location, cdea.date, cdea.population,cvac.new_vaccinations,
    sum(cvac.new_vaccinations) OVER (partition by  cdea.location order by cdea.location, cdea.date) as VaccineRollingTotal -- (VaccineRollingTotal/ population) * 100
   from cdeathsdb cdea
  join covidvacines cvac
	on cdea.location = cvac.location
     AND
     cdea.date = cvac.date
     where cdea.continent IS NOT NULL AND cdea.continent <> '')
     -- order by 2,3 
     SELECT * , (VaccineRollingTotal/ population) * 100 AS PercentVaccinated
     FROM 
     cte_PopuVsVacc;
     
     -- Nigeria covid data
CREATE VIEW NigeriaCovidData AS
    SELECT 
        location,
        date,
        total_cases,
        total_deaths,
        (total_deaths / total_cases) * 100 AS DeathPercentage
    FROM
        cdeathsdb
    WHERE
        location LIKE '%Nigeria%'
    ORDER BY 1 , 2;
     
-- (3) contries with highest date count
CREATE VIEW HigestDeathCountByCountry AS
    SELECT 
        Location, MAX(total_deaths) AS TotalDeathCount
    FROM
        cdeathsdb
    WHERE
        location NOT IN ('Asia' , 'European Union',
            'europe',
            'Africa',
            'North America',
            'South America',
            'Oceania',
            'world')
    GROUP BY location
    ORDER BY TotalDeathCount DESC;

-- (4)looking at countries with the highest infection rates compate to their populations
CREATE VIEW HigestInfectVsPopulation AS
    SELECT 
        Location,
        MAX(total_cases) AS Highest_infection_count,
        Population,
        MAX((total_cases) / population) * 100 AS PercentagePopulationInfected
    FROM
        cdeathsdb
    WHERE
        continent IS NOT NULL
    GROUP BY location , population
    ORDER BY PercentagePopulationInfected DESC;

-- (5) Global numbers 

CREATE VIEW Globalnumbers AS
    SELECT 
        SUM(new_cases) AS RecordedCases,
        SUM(new_deaths) AS RecodedDeaths,
        (SUM(new_deaths) / SUM(new_cases)) * 100 AS DeathsPercentage
    FROM
        cdeathsdb
    ORDER BY RecordedCases DESC , RecodedDeaths DESC;

     
     
   
 
 
 



