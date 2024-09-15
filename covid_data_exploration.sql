use PortfolioProject;

select *
from coviddeaths
order by 3,4;

select *
from covidvaccinations
order by 3,4;

select location, date,  total_cases, new_cases, total_deaths, population
from coviddeaths
order by 1, 2;

-- Total cases vs Total deaths

select location, date,  total_cases, total_deaths,(total_deaths/total_cases)*100 as death_percentage
from coviddeaths
order by 5 desc;

select location, date,  total_cases, total_deaths,(total_deaths/total_cases)*100 as death_percentage
from coviddeaths
where location like '%desh%'
order by 1,2;



-- Total cases vs Population
select location, date, population, total_cases, (total_cases/population)*100 as infection_percentage
from coviddeaths
-- where location like '%desh%'
order by 1,2;



-- Highest Infection Rate compared to Population 
select location, population,  max(total_cases) as HighestInfectionCount,max(total_deaths/total_cases)*100 as death_percentage
from coviddeaths
group by location, population
order by death_percentage desc ;


-- Highest Death Count per Population

select location, max(total_deaths) as TotalDeathCount
from coviddeaths
group by location
order by TotalDeathCount desc;


-- Global

select date, sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, sum(new_deaths)/sum(new_cases) * 100 as Death_percentage
from coviddeaths
where continent is not null
group by date
order by 1,2 asc;

select  sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, sum(new_deaths)/sum(new_cases) * 100 as Death_percentage
from coviddeaths
where continent is not null
-- group by date
order by 1,2 asc;

ALTER TABLE coviddeaths
MODIFY COLUMN date DATETIME;


ALTER TABLE covidvaccinations
MODIFY COLUMN date DATETIME;

select * 
from covidvaccinations;

select * 
from coviddeaths;

select continent, location, date, new_vaccinations, sum(new_vaccinations) over (partition by location order by location,date)
from covidvaccinations
where continent is not null
order by 2,3;

-- CTE

with PopsVac (Continent, Loacation, Date, New_Vaccination, RollingPeopleVacccinated) as
(
select continent, location, date, new_vaccinations, sum(new_vaccinations) over (partition by location order by location,date)
from covidvaccinations
where continent is not null
)
select *, (New_vaccination/RollingPeopleVacccinated)*100
from PopsVac;



select sum(new_cases) as total_cases, SUM(new_deaths) as total_deaths, sum(new_deaths )/SUM(New_Cases)*100 as DeathPercentage
from coviddeaths
-- Where location like '%states%'
where continent is not null
-- Group By date
order by 1,2;

Select continent, SUM(new_deaths) as TotalDeathCount
From CovidDeaths
-- Where location like '%states%'
Where continent is not null
and location not in ('World', 'European Union', 'International')
Group by continent
order by TotalDeathCount desc;



Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From CovidDeaths
-- Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc;


Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From CovidDeaths
-- Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc;


