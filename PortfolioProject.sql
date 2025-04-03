/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/

Select *
From PortfolioProject..CovidDeaths1
Where continent is not null 
order by 3,4


-- Select Data that we are going to be starting with

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths1
Where continent is not null 
order by 1,2


-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths1
Where location like '%states%'
and continent is not null 
order by 1,2


-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths1
--Where location like '%states%'
order by 1,2


-- Countries with Highest Infection Rate compared to Population

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths1
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc


-- Countries with Highest Death Count per Population

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths1
--Where location like '%states%'
Where continent is not null 
Group by Location
order by TotalDeathCount desc



-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths1
--Where location like '%states%'
Where continent is not null 
Group by continent
order by TotalDeathCount desc



-- GLOBAL NUMBERS

Select SUM(CAST(new_cases AS INT)) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(CAST(New_Cases AS INT))*100 as DeathPercentage
From PortfolioProject..CovidDeaths1
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2

--LOOKING AT TOTATAL POPULATION VS VACCINATIONS 
SELECT Cast(dea.continent as nvarchar(50)) AS CONTINENT,
dea.location,CAST(dea.date AS date) AS DATE,dea.population,
CAST(vac.new_vaccinations  AS INT) AS NEW_VACCINATIONS , 
SUM(CAST(vac.new_vaccinations AS INT)) OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths1 dea
JOIN PortfolioProject..CovidVaccination vac
 on dea.location = vac.location
 and dea.date = vac.date
WHERE dea.continent IS NOT NULL --and vac.new_vaccinations is not null
 order by 1,2,3

 --USE CTE
WITH PopVsVac(continent,location,date,population,new_vaccinations,Rollingpeoplevaccinated) as (
SELECT Cast(dea.continent as nvarchar(50)) AS CONTINENT,
dea.location,CAST(dea.date AS date) AS DATE,dea.population,
CAST(vac.new_vaccinations  AS INT) AS NEW_VACCINATIONS , 
SUM(CAST(vac.new_vaccinations AS INT)) OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths1 dea
JOIN PortfolioProject..CovidVaccination vac
 on dea.location = vac.location
 and dea.date = vac.date
WHERE dea.continent IS NOT NULL 
and vac.new_vaccinations is not null)
 --order by 1,2,3)
 --)
 select * , (CAST(Rollingpeoplevaccinated AS FLOAT(50))/population)* 100
 from PopVsVac


 Create view PercentPopulationVaccinated as

 SELECT Cast(dea.continent as nvarchar(50)) AS CONTINENT,
dea.location,CAST(dea.date AS date) AS DATE,dea.population,
CAST(vac.new_vaccinations  AS INT) AS NEW_VACCINATIONS , 
SUM(CAST(vac.new_vaccinations AS INT)) OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths1 dea
JOIN PortfolioProject..CovidVaccination vac
 on dea.location = vac.location
 and dea.date = vac.date
WHERE dea.continent IS NOT NULL 
and vac.new_vaccinations is not null
 --order by 1,2,3)
 --)