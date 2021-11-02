Select *
From PortfolioProject..CovidDeaths$
Where continent is not null
Order by 3,4

--Select *
--From PortfolioProject..CovidVaccinations$
--Order by 3,4

Select Location, date, total_cases, new_cases, total_cases, population 
From PortfolioProject..CovidDeaths$
Where continent is not null
order by 1,2

--Total cases vs total deaths
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercent
From PortfolioProject..CovidDeaths$
Where location like '%India%'
and continent is not null
order by 1,2

--Total cases vs total population
Select Location, date, total_cases, population, (total_cases/population)*100 as InfectRate
From PortfolioProject..CovidDeaths$
Where location like '%India%'
and continent is not null
order by 1,2

--Countries with highest infection rate as compared to population
Select Location, MAX(total_cases)as TotalCases, population, (MAX(total_cases)/population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths$
--Where location like '%India%'
Where continent is not null
Group by location, population
order by PercentPopulationInfected desc

--Countries with highest death rate as compared to population
Select Location, MAX(total_deaths)as TotalDases, population, (MAX(total_deaths)/population)*100 as PercentPopulationDied
From PortfolioProject..CovidDeaths$
--Where location like '%India%'
Where continent is not null
Group by location, population
order by PercentPopulationDied desc

--Total Deaths
Select Location, MAX(cast(total_deaths as int)) as TotalDeaths
From PortfolioProject..CovidDeaths$
--Where location like '%India%'
Where continent is not null
Group by location
order by TotalDeaths desc

--Lets break things down by continent
Select location, MAX(cast(total_deaths as int)) as TotalDeaths
From PortfolioProject..CovidDeaths$
--Where location like '%India%'
Where continent is null
Group by location
order by TotalDeaths desc


--Show continents with highest death count per population
Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths$
--Where location like '%India%'
Where continent is null
and location not in ('World','European Union','International')
Group by location
order by TotalDeathCount desc


--Vaccinations
Select location, MAX(total_vaccinations) as TotVacc
From PortfolioProject..CovidVaccinations$
--Where location like '%India%'
Group by location
order by TotVacc desc


--Total population vs total vaccinations
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(Convert(int,vac.new_vaccinations)) 
OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.location= vac.location
	and dea.date = vac.date 
where dea.continent is not null
order by 2,3

--USE CTE
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as 
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(Convert(int,vac.new_vaccinations)) 
OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.location= vac.location
	and dea.date = vac.date 
where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac







/*
Covid 19 Data Exploration 
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/

Select *
From PortfolioProject..CovidDeaths$
Where continent is not null 
order by 3,4


-- Select Data that we are going to be starting with

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Where continent is not null 
order by 1,2


-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%states%'
and continent is not null 
order by 1,2


-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
order by 1,2


-- Countries with Highest Infection Rate compared to Population

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths$
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc

Select Location, date, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths$
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc


-- Countries with Highest Death Count per Population

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null 
Group by Location
order by TotalDeathCount desc



-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null 
Group by continent
order by TotalDeathCount desc



-- GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths$
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2



-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3


-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac



-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated




-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 






