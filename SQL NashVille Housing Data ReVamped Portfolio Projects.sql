
  /*

Cleaning Data in SQL Queries

*/


Select *
From [Portfolio Project].dbo.[NashVille Data ReVamp]

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format (Standardizing date format is a cruical step in data cleaning process, Dates can be represented
-- in numerous formats, and standardizing them into single amd more useable format helps in avoiding confusion and errors.

Select SaleDateRevamped, CONVERT(Date,SaleDate) 
From [Portfolio Project].dbo.[NashVille Data ReVamp]

ALTER TABLE [NashVille Data ReVamp]
Add SaleDateRevamped Date

Update [NashVille Data ReVamp]
SET SaleDateRevamped = CONVERT(Date,SaleDate)


------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address Data (Using JOIN and ISNULL Function)

Select *
From [Portfolio Project].dbo.[NashVille Data ReVamp]
Where	PropertyAddress is   null
Order by ParcelID

Select Nas.ParcelID, Nas.PropertyAddress, Vil.ParcelID, Vil.PropertyAddress,  ISNULL(,Nas.PropertyAddress, Vil.PropertyAddress)
From [Portfolio Project].dbo.[NashVille Data ReVamp] Nas
JOIN [Portfolio Project].dbo.[NashVille Data ReVamp] vil
     on Nas.ParcelID = Vil.ParcelID
	 AND Nas.[UniqueID ] <> Vil.[UniqueID ]
Where Nas.PropertyAddress is null


Update Nas
SET PropertyAddress =  ISNULL(Nas.PropertyAddress, Vil.PropertyAddress)
From [Portfolio Project].dbo.[NashVille Data ReVamp] Nas
JOIN [Portfolio Project].dbo.[NashVille Data ReVamp] vil
     on Nas.ParcelID = Vil.ParcelID
	 AND Nas.[UniqueID ] <> Vil.[UniqueID ]
Where Nas.PropertyAddress is null


--------------------------------------------------------------------------------------------------------------------------

-- Seperating Address Into Individual Columns (Address, City, State), Using SUBSTRINGS, CHARINDEX,PARSENAME AND REPLACE 
--Functions.

Select PropertyAddress
From [Portfolio Project].dbo.[NashVille Data ReVamp]
--Where	PropertyAddress is   null
--Order by ParcelID


SELECT
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address
,  SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as Address

From [Portfolio Project].dbo.[NashVille Data ReVamp]


ALTER TABLE [NashVille Data ReVamp]
Add PropertyDivideAddress Nvarchar(255);

Update [NashVille Data ReVamp]
SET PropertyDivideAddress =  SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)



ALTER TABLE [NashVille Data ReVamp]
Add PropertyDivideCity Nvarchar(255);

Update [NashVille Data ReVamp]
SET PropertyDivideCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+ 1, LEN(PropertyAddress))


Select *

From [Portfolio Project].dbo.[NashVille Data ReVamp]


Select OwnerAddress
From [Portfolio Project].dbo.[NashVille Data ReVamp]


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') ,3) as Address
,PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2) as City
,PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1) as State
From [Portfolio Project].dbo.[NashVille Data ReVamp]



ALTER TABLE [NashVille Data ReVamp]
Add OwnerDivideAddress Nvarchar(255);

Update [NashVille Data ReVamp]
SET OwnerDivideAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,3) 



ALTER TABLE [NashVille Data ReVamp]
Add OwnerDivideCity Nvarchar(255);

Update [NashVille Data ReVamp]
SET OwnerDivideCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2) 



ALTER TABLE [NashVille Data ReVamp]
Add OwnerDivideState Nvarchar(255);

Update [NashVille Data ReVamp]
SET OwnerDivideState = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1) 


Select *
From [Portfolio Project].dbo.[NashVille Data ReVamp]



--------------------------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" field (Using Distinct Statement, Count function and CASE STATEMENT 'When')

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From [Portfolio Project].dbo.[NashVille Data ReVamp]
Group by SoldAsVacant
Order by 2


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes' 
       When SoldAsVacant = 'N' THEN 'No' 
	   ELSE SoldAsVacant
	   END
From [Portfolio Project].dbo.[NashVille Data ReVamp]

Update [NashVille Data ReVamp]	
SET SoldAsVacant =  CASE When SoldAsVacant = 'Y' THEN 'Yes' 
       When SoldAsVacant = 'N' THEN 'No' 
	   ELSE SoldAsVacant
	   END


-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates Rows (Using CTE, OVER and PARTITION BY Expressions to Split Rows into groups and ORDER BY Function )


WITH ROWNUMCTE AS(
Select *,
     ROW_NUMBER() OVER (
	 PARTITION BY ParcelID,
	              PropertyAddress,
				  SalePrice,
				  SaleDate,
				  LegalReference
				  ORDER BY 
				     UniqueID
					 ) row_num
 From [Portfolio Project].dbo.[NashVille Data ReVamp] 
 --Order by ParcelID
 )
 Select *
 From ROWNUMCTE
 Where row_num > 1
 --Order by PropertyAddress 


 ---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns (Using Alter Table Statement and Drop Table Command)

Select *
From [Portfolio Project].dbo.[NashVille Data ReVamp] 

 ALTER TABLE [Portfolio Project].dbo.[NashVille Data ReVamp]
 DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

 ALTER TABLE [Portfolio Project].dbo.[NashVille Data ReVamp]
 DROP COLUMN SaleDate

 ALTER TABLE [Portfolio Project].dbo.[NashVille Data ReVamp]
 DROP COLUMN SaleDateConverted




