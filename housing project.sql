--cleaning data in sql queries

select * from portfolioproject.dbo.nashvillehousing

--standardize date format (taking out the time )

select saledateconverted, CONVERT(Date,saledate)
from portfolioproject.dbo.nashvillehousing

update nashvillehousing
set SaleDate = CONVERT(Date,saledate)

alter table nashvillehousing
add saledateconverted date;

update nashvillehousing
set SaleDateconverted=CONVERT(Date,saledate)

--populated property address

select * from portfolioproject.dbo.nashvillehousing
--where PropertyAddress is null
order by ParcelID

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress ,isnull(a.propertyaddress,b.PropertyAddress)
from portfolioproject.dbo.nashvillehousing a
join portfolioproject.dbo.nashvillehousing b
on a.parcelID=b.parcelID and
a.[uniqueID]<>b.[uniqueID]
where a.PropertyAddress is null

update a
set propertyaddress=isnull(a.propertyaddress,b.PropertyAddress)
from portfolioproject.dbo.nashvillehousing a
join portfolioproject.dbo.nashvillehousing b
on a.parcelID=b.parcelID and
a.[uniqueID]<>b.[uniqueID]
where a.PropertyAddress is null

--breaking out address into individual columns(address,city,state)

select propertyaddress from portfolioproject.dbo.nashvillehousing
--where PropertyAddress is null
--order by ParcelID

select 
substring(propertyaddress,1,CHARINDEX(',',propertyaddress) -1) as address
,SUBSTRING(propertyaddress, CHARINDEX(',',propertyaddress) +1 , LEN(propertyaddress)) as address
from portfolioproject.dbo.nashvillehousing


alter table nashvillehousing
add Propertysplitaddress Nvarchar(255);

update nashvillehousing
set Propertysplitaddress= substring(propertyaddress,1, CHARINDEX(',',propertyaddress) -1) 

alter table nashvillehousing
add Propertysplitcity Nvarchar(255);

update nashvillehousing
set Propertysplitcity= substring(propertyaddress,CHARINDEX(',',propertyaddress) +1, LEN(propertyaddress)) 


select * from portfolioproject.dbo.nashvillehousing



select owneraddress from portfolioproject.dbo.nashvillehousing

select
PARSENAME(replace(owneraddress,',','.'),3)
,PARSENAME(replace(owneraddress,',','.'),2)
,PARSENAME(replace(owneraddress,',','.'),1)
from portfolioproject.dbo.nashvillehousing


alter table nashvillehousing
add Ownersplitaddress Nvarchar(255);

update nashvillehousing
set ownersplitaddress= PARSENAME(replace(owneraddress,',','.'),3)

alter table nashvillehousing
add ownersplitcity Nvarchar(255);

update nashvillehousing
set ownersplitcity=  PARSENAME(replace(owneraddress,',','.'),2)

alter table nashvillehousing
add ownersplitstate Nvarchar(255);

update nashvillehousing
set ownersplitstate=  PARSENAME(replace(owneraddress,',','.'),1)

select * from nashvillehousing


select distinct(soldasvacant),COUNT(soldasvacant)
from portfolioproject.dbo.nashvillehousing
group by SoldAsVacant
order by 2

-- changed y to yes and n to no using case statement
select soldasvacant,
case when SoldAsVacant='Y' then 'yes'
     when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
	 end
from portfolioproject.dbo.nashvillehousing
--group by SoldAsVacant
--order by 2


update nashvillehousing
set soldasvacant=case when SoldAsVacant='Y' then 'yes'
     when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
	 end

--removing duplicates using ctes,rownum and partion by
with rownumCTE as (
select *,
ROW_NUMBER() OVER(partition by parcelID,
propertyaddress,
saleprice,
saledate,
legalreference
order by uniqueID) row_num
from portfolioproject.dbo.nashvillehousing)
--order by ParcelID

select * from rownumCTE
where row_num > 1
--order by PropertyAddress




--delete unused columns
select * from portfolioproject.dbo.nashvillehousing

alter table portfolioproject.dbo.nashvillehousing
drop column owneraddress,taxdistrict,propertyaddress

alter table portfolioproject.dbo.nashvillehousing
drop column saledate








