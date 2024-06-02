
-- DATA CLEANING PROJECT -- 
-- convert date column to date only format -- 

-- Because SaleDate still DATE, so CONVERT() function cannot workout 

Select *
from PortfolioProject.dbo.NastvilleHousing

ALTER TABLE NastvilleHousing
ALTER COLUMN SaleDate DATE

Select SaleDate 
from PortfolioProject.dbo.NastvilleHousing

--- WORKING WITH PropertyAddress 
Select *
from PortfolioProject.dbo.NastvilleHousing
--where PropertyAddress is null 
order by ParcelID

-- filling the propertyAdrress even the parcelID is matched 
-- using self-join
Select tblA.ParcelID,tblA.PropertyAddress,tblB.ParcelID,tblB.PropertyAddress,
	ISNULL(tblA.PropertyAddress,tblB.PropertyAddress)
from PortfolioProject.dbo.NastvilleHousing as tblA
join PortfolioProject.dbo.NastvilleHousing as tblB
	on tblA.ParcelID=tblB.ParcelID
	and tblA.[UniqueID ] <> tblB.[UniqueID ]
where tblA.PropertyAddress is null 

UPDATE tblA
SET PropertyAddress = ISNULL(tblA.PropertyAddress,tblB.PropertyAddress)
from PortfolioProject.dbo.NastvilleHousing as tblA
join PortfolioProject.dbo.NastvilleHousing as tblB
	on tblA.ParcelID=tblB.ParcelID
	and tblA.[UniqueID ] <> tblB.[UniqueID ]
where tblA.PropertyAddress is null 

---split Address to Address,City by substring , character index 
SELECT PropertyAddress
from PortfolioProject.dbo.NastvilleHousing

SELECT SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
	SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1 ,LEN(propertyAddress)) as Address
from PortfolioProject.dbo.NastvilleHousing

ALTER TABLE NastvilleHousing
ADD PropertySplitAddress nvarchar(255)

UPDATE NastvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE NastvilleHousing
ADD PropertySplitCity nvarchar(255)

UPDATE NastvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1 ,LEN(propertyAddress))

select *
from PortfolioProject.dbo.NastvilleHousing

-- OWNERADDRESS 
-- using PARSENAME

select *
from PortfolioProject.dbo.NastvilleHousing

--  (.) is default delimiter of PARSENAME so we have to replace ',' with '.'
-- the PARSENAME will split into 4 parts ** the rightmost is 1 always 

select OwnerAddress,PARSENAME(REPLACE(OwnerAddress,',','.'),3),
	PARSENAME(REPLACE(OwnerAddress,',','.'),2),
	PARSENAME(REPLACE(OwnerAddress,',','.'),1)
from PortfolioProject.dbo.NastvilleHousing

ALTER TABLE PortfolioProject.dbo.NastvilleHousing
ADD OwnerSplitAddress nvarchar(255)

UPDATE PortfolioProject.dbo.NastvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE PortfolioProject.dbo.NastvilleHousing
ADD OwnerSplitCity nvarchar(255)

UPDATE PortfolioProject.dbo.NastvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE PortfolioProject.dbo.NastvilleHousing
ADD OwnerSplitState nvarchar(255)

UPDATE PortfolioProject.dbo.NastvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)


--- set the value consistent in 'SoldAsVacant' field
select distinct SoldAsVacant,count(SoldAsVacant)
from PortfolioProject.dbo.NastvilleHousing
group by SoldAsVacant
order by 2 desc


select SoldAsVacant,
	CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END
from PortfolioProject.dbo.NastvilleHousing

UPDATE PortfolioProject.dbo.NastvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END

--- REMOVE DUPLICATE ---
--- CREATE CTE
WITH RowNumCTE AS (
--- find the row which same detail (in partition by ) and keep row count in  row_num 
SELECT *,ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY 
					UniqueID
				) row_num
FROM PortfolioProject.dbo.NastvilleHousing
--order by ParcelID
)

--DELETE
--from RowNumCTE
--where row_num >1 

SELECT * 
from RowNumCTE
where row_num >1 
Order by PropertyAddress

--DELETE UNUSED COLUMN 
ALTER TABLE PortfolioProject.dbo.NastvilleHousing
DROP COLUMN OwnerAddress,TaxDistrict,PropertyAddress,SaleDate

Select *
from PortfolioProject.dbo.NastvilleHousing
