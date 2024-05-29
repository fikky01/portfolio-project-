use PortfolioProject

--Cleaning Data
select * 
from nashvillehousing

--standardize Date
select saleDateConverted, CONVERT(Date, saleDate)
from nashvillehousing

alter table Nashvillehousing
add saleDateconverted Date;

Update nashvillehousing
set saleDateconverted = CONVERT(Date, saleDate)

--Populate Property Address
select * from  portfolioProject.dbo.nashvillehousing
--where propertyAddress is null


select a.parcelID, a.propertyAddress, b.ParcelID, b.propertyAddress, isnull(a.propertyAddress, b.PropertyAddress)
from  portfolioProject.dbo.nashvillehousing a
join portfolioProject.dbo.nashvillehousing b
on a.parcelID = b.ParcelID
and a.uniqueID <> b.UniqueID
where a.propertyAddress is null

update a
set propertyAddress = isnull(a.propertyAddress, b.PropertyAddress)
from  portfolioProject.dbo.nashvillehousing a
join portfolioProject.dbo.nashvillehousing b
on a.parcelID = b.ParcelID
and a.uniqueID <> b.UniqueID
where a.propertyAddress is null

--Breaking Out Address into individual Columns
select propertyAddress 
from  portfolioProject.dbo.nashvillehousing
--where propertyAddress is null

select SUBSTRING(propertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address, 
SUBSTRING(propertyAddress, CHARINDEX(',', PropertyAddress) +1, len(propertyAddress)) as Address 
from  portfolioProject.dbo.nashvillehousing


alter table [dbo].[NashvilleHousing]
add PropertySplitAddress varchar(255);

Update nashvillehousing
set PropertySplitAddress = SUBSTRING(propertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

alter table Nashvillehousing
add PropertySpilitCity varchar(255);

Update nashvillehousing
set PropertySpilitCity = SUBSTRING(propertyAddress, CHARINDEX(',', PropertyAddress) +1, len(propertyAddress))

select *from  portfolioProject.dbo.nashvillehousing



select OwnerAddress
from  portfolioProject.dbo.nashvillehousing

select PARSENAME(replace(ownerAddress, ',','.'),3), PARSENAME(replace(ownerAddress, ',','.'),2),
PARSENAME(replace(ownerAddress, ',','.'),1)
from  portfolioProject.dbo.nashvillehousing

alter table [dbo].[NashvilleHousing]
add OwnerSplitAddress varchar(255);

Update nashvillehousing
set  OwnerSplitAddress = PARSENAME(replace(ownerAddress, ',','.'),3)

alter table Nashvillehousing
add  OwnerSpilitCity varchar(255);

Update nashvillehousing
set  OwnerSpilitCity = PARSENAME(replace(ownerAddress, ',','.'),2)

alter table Nashvillehousing
add  OwnerSpilitState varchar(255);

Update nashvillehousing
set  OwnerSpilitState = PARSENAME(replace(ownerAddress, ',','.'),1)

select *
from  portfolioProject.dbo.nashvillehousing

--Change Y and N to Yes and No in the SoldAsVAcant Column 
select distinct(SoldAsVacant), count(soldasvacant)
from  portfolioProject.dbo.nashvillehousing
group by SoldAsVacant
order by 2

select SoldAsVacant,
case when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
End
from  portfolioProject.dbo.nashvillehousing

update nashvillehousing
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
End

--Removing Duplicates
Select *from  portfolioProject.dbo.nashvillehousing

with rownumCTE as (
select *, ROW_NUMBER() over(
partition by parcelID, PropertyAddress,SalePrice, SaleDate,legalreference
order by uniqueID) row_num
from  portfolioProject.dbo.nashvillehousing)

delete from  rownumCTE
where row_num >1


--delete used Columns
select *from  portfolioProject.dbo.nashvillehousing

alter table portfolioProject.dbo.nashvillehousing
drop column propertyAddress, ownerAddress,TaxDistrict