/****** Script for SelectTopNRows command from SSMS  ******/
SELECT *
FROM Port_Projects.dbo.nashvillehousing

/* Standardize Date format */
SELECT SaleDate, CONVERT(Date, SaleDate)
FROM Port_Projects.dbo.nashvillehousing

UPDATE nashvillehousing
SET SaleDate = CONVERT(Date, SaleDate)

ALTER Table nashvillehousing
add SaleDateConverted Date

UPDATE nashvillehousing
SET SaleDateConverted = CONVERT(Date, SaleDate)



/* Populate property address (some prop.adresses are null so fill them with owner adress*/
SELECT *
FROM Port_Projects.dbo.nashvillehousing
Order by ParcelID

SELECT A.ParcelID,A.PropertyAddress, B.ParcelID, B.PropertyAddress ISNULL(A.PropertyAddress,B.PropertyAddress) 
FROM Port_Projects.dbo.nashvillehousing as A
join Port_Projects.dbo.nashvillehousing as B
on A.ParcelID = B.ParcelID AND A.[UniqueID ]<>B.[UniqueID ]
where A.PropertyAddress is Null

UPDATE A
SET PropertyAddress = ISNULL(A.PropertyAddress,B.PropertyAddress) 
FROM Port_Projects.dbo.nashvillehousing as A
join Port_Projects.dbo.nashvillehousing as B
on A.ParcelID = B.ParcelID AND A.[UniqueID ]<>B.[UniqueID ]
where A.PropertyAddress is Null


/* Breaking out Adress into indv. columns (Adress, City, State) */
SELECT * --PropertyAddress
FROM Port_Projects.dbo.nashvillehousing

SELECT 
SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
, SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as Region,
FROM Port_Projects.dbo.nashvillehousing

ALTER Table nashvillehousing
add PropertySplitAddress NVARCHAR(255)

UPDATE nashvillehousing
SET PropertySplitAddress = SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER Table nashvillehousing
add PropertySplitCity NVARCHAR(255);

UPDATE nashvillehousing
SET PropertySplitCity = SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

/* Using Parse statements*/
SELECT 
PARSENAME(REPLACE(OwnerAddress, ',' , '.'),3),
PARSENAME(REPLACE(OwnerAddress, ',' , '.'),2),
PARSENAME(REPLACE(OwnerAddress, ',' , '.'),1)
FROM Port_Projects.dbo.nashvillehousing

ALTER Table nashvillehousing
add OwnerSplitAddress NVARCHAR(255)

UPDATE nashvillehousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',' , '.'),3)

ALTER Table nashvillehousing
add OwnerSplitCity NVARCHAR(255);

UPDATE nashvillehousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',' , '.'),2)

ALTER Table nashvillehousing
add OwnerSplitState NVARCHAR(255);

UPDATE nashvillehousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',' , '.'),1)

SELECT *
FROM Port_Projects.dbo.nashvillehousing



/* Change Y & N to Yes and No */
SELECT Distinct SoldAsVacant, count(SoldAsVacant)
FROM Port_Projects.dbo.nashvillehousing
GROUP by SoldAsVacant

SELECT SoldAsVacant
,CASE When SoldAsVacant='Y' THEN 'Yes'
	 When SoldAsVacant='N' THEN 'No'
	ELSE SoldAsVacant
	END
FROM Port_Projects.dbo.nashvillehousing

UPDATE nashvillehousing
SET SoldAsVacant = (CASE When SoldAsVacant='Y' THEN 'Yes'
	 When SoldAsVacant='N' THEN 'No'
	ELSE SoldAsVacant
	END) 

SELECT SoldAsVacant
FROM Port_Projects.dbo.nashvillehousing


/* Remove Duplicates */

WITH RowNumCTE AS(
Select * ,
ROW_NUMBER() OVER(
PARTITION by ParcelID,
			PropertyAddress,
			SalePrice,
			SaleDate,
			LegalReference
			ORDER By 
				UniqueID
				) row_num

FROM Port_Projects.dbo.nashvillehousing )
DELETE
From RowNumCTE
WHERE row_num>1
Order by PropertyAddress 



WITH RowNumCTE AS(
Select * ,
ROW_NUMBER() OVER(
PARTITION by ParcelID,
			PropertyAddress,
			SalePrice,
			SaleDate,
			LegalReference
			ORDER By 
				UniqueID
				) row_num

FROM Port_Projects.dbo.nashvillehousing )
SELECT *
From RowNumCTE
WHERE row_num>1
Order by PropertyAddress 


/*  DROP UNUSED COLUMNS*/

Select * 
FROM Port_Projects.dbo.nashvillehousing 

ALTER table nashvillehousing
Drop column OwnerAddress, PropertyAddress, TaxDistrict

ALTER table nashvillehousing
Drop column SaleDate