--Select 
--From PortfolioProject.dbo.CovidDealths
--order by 3,4

--Select *
--From PortfolioProject.dbo.CovidVaccinations
--order by 3,4


--- Select Data that we're going to be using --
Select location,date,total_cases,new_cases,total_deaths,population
From PortfolioProject.dbo.CovidDeaths
order by 1,2 --- by column no. ---

--- convert total_deaths and total_case to int ---
alter table PortfolioProject.dbo.CovidDeaths
alter column total_cases float

alter table PortfolioProject.dbo.CovidDeaths
alter column total_deaths float

--- max(cast(total_deaths as int))---

--- looking at Total Cases vs Total Deaths ---
--- shows likelihood of dying if you contract covid in your country 
Select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject.dbo.CovidDeaths
where location = 'Thailand'
order by 1,2

--- looking at total cases vs the population ---
--- show the percentage of population that infected ---
Select location,date,total_cases,population,(total_cases/population)*100 as CasePercentage
From PortfolioProject.dbo.CovidDeaths
where location = 'Thailand'
order by 1,2

--- find the country with highest infection rate --
Select location,population,
	max(total_cases) as HighestInfectionCount,
	(max(total_cases)/population)*100 as PercentOfPopulationInfected

from PortfolioProject.dbo.CovidDeaths
group by location,population
order by PercentOfPopulationInfected desc

--- DRILL DOWN BY THE CONTINENT ---
-- showing the continent with highest death count --
Select continent,
	max(total_deaths) as TotalDeathCount
from PortfolioProject.dbo.CovidDealths
where continent is not null
group by continent
order by TotalDeathCount desc

--- showing countries with Death count per population ---
Select location,
	max(total_deaths) as TotalDeathCount
from PortfolioProject.dbo.CovidDeaths
where continent is not null
group by location
order by TotalDeathCount desc

--- GLOBAL NUMBERS ---
Select date,
	sum(new_cases) as total_cases,
	sum(new_deaths) as total_deaths,
	sum(new_deaths)/sum(new_cases)*100 as DeathPercentage

	---total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject.dbo.CovidDeaths
--where location = 'Thailand'
where continent is not null
group by date
order by 1,2

-- Looking on Total Population vs Total Vaccinations 
--- JOINING ---
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
-- we wil use over & partition by to accumulate total vaccinaton --
	SUM(CAST(vac.new_vaccinations as float)) OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date) as Accum_Vaccination,
From PortfolioProject.dbo.CovidDeaths as dea
join PortfolioProject.dbo.CovidVaccinations as vac
	on dea.date=vac.date
	and dea.location=vac.location
where dea.continent is not null
order by 2,3

--- USE Common Table Expression (CTE) to create vitual table 
With PopvsVac (Continent,location,date,population,new_vaccinations,Accum_Vaccination)
as 
(
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
-- we wil use over & partition by to accumulate total vaccinaton --
-- and order to see easily how the table accumulated --
	SUM(CAST(vac.new_vaccinations as float)) OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date) as Accum_Vaccination
From PortfolioProject.dbo.CovidDeaths as dea
join PortfolioProject.dbo.CovidVaccinations as vac
	on dea.date=vac.date
	and dea.location=vac.location
where dea.continent is not null
---order by 2,3
)
Select *,(Accum_Vaccination/population)*100
From PopvsVac 


-- TEMP TABLE --
DROP TABLE if exists PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated 
(	Continent nvarchar(255),
	location nvarchar(255),
	date datetime,
	Population numeric,
	New_Vaccinations numeric,
	Accum_Vaccination numeric
)

INSERT INTO #PercentPopulationVaccinated 
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
	SUM(CAST(vac.new_vaccinations as float)) OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date) as Accum_Vaccination
From PortfolioProject.dbo.CovidDeaths as dea
join PortfolioProject.dbo.CovidVaccinations as vac
	on dea.date=vac.date
	and dea.location=vac.location
where dea.continent is not null
---order by 2,3

Select *,(Accum_Vaccination/population)*100 as AccumvsPopulation
From #PercentPopulationVaccinated 

-- CREATE VIEW FOR STORE DATA TO VISUALIZATION 
Create view PercentPopulationVaccinated as 
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
	SUM(CAST(vac.new_vaccinations as float)) OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date) as Accum_Vaccination
From PortfolioProject.dbo.CovidDeaths as dea
join PortfolioProject.dbo.CovidVaccinations as vac
	on dea.date=vac.date
	and dea.location=vac.location
where dea.continent is not null
--order by 2,3

Select *
From PercentPopulationVaccinated