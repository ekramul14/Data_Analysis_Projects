use PortfolioProject;


select *
from nashville_housing;

-- Breaking Out Address into Individual Columns (Address, City, State)
select *
from nashville_housing;


SELECT PropertyAddress,
    CASE 
        WHEN LOCATE(',', PropertyAddress) > 0 
        THEN SUBSTRING(PropertyAddress, 1, LOCATE(', ', PropertyAddress) - 1)
        ELSE PropertyAddress
    END AS Address,
    CASE 
        WHEN LOCATE(',', PropertyAddress) > 0 
        THEN SUBSTRING(PropertyAddress, LOCATE(', ', PropertyAddress) + 1, length(PropertyAddress))
        ELSE PropertyAddress
    END AS Address
FROM 
    nashville_housing;

 alter table nashville_housing
 add PropertySplitAddress nvarchar(255);
 
 update nashville_housing
 set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, LOCATE(', ', PropertyAddress) - 1);
 
  alter table nashville_housing
 add PropertySplitCity nvarchar(255);
 
 update nashville_housing
 set PropertySplitCity = SUBSTRING(PropertyAddress, LOCATE(', ', PropertyAddress) + 1, length(PropertyAddress));
 
 
 select OwnerAddress 
 from nashville_housing;
 
 
 select
 substring_index(OwnerAddress,',', 1),
 substring_index(substring_index(OwnerAddress,',', 2),',', -1),
 substring_index(OwnerAddress,',', -1)
 from nashville_housing;
 
 
 alter table nashville_housing
 add OwnerSplitAddress nvarchar(255);
 
 update nashville_housing
 set OwnerSplitAddress = substring_index(OwnerAddress,',', 1);
 
  alter table nashville_housing
 add OwnerSplitCity nvarchar(255);
 
 update nashville_housing
 set OwnerSplitCity = substring_index(substring_index(OwnerAddress,',', 2),',', -1);
 
   alter table nashville_housing
 add OwnerSplitState nvarchar(255);
 
 update nashville_housing
 set OwnerSplitState = substring_index(OwnerAddress,',', -1);
 
 
 
 -- Change Y and N to Yes and No respectively in 'SoldAsVacant' field
 
 select distinct(SoldAsVacant), count(SoldAsVacant)
from nashville_housing
group by SoldAsVacant
order by 2;

select SoldAsVacant,
	case
		when SoldAsVacant = 'Y' then 'Yes'
		when SoldAsVacant = 'N' then 'No'
        else SoldAsVacant
	end
from nashville_housing;

update nashville_housing
set SoldAsVacant = case
		when SoldAsVacant = 'Y' then 'Yes'
		when SoldAsVacant = 'N' then 'No'
        else SoldAsVacant
	end;





-- Removal of Duplicates

select *
from nashville_housing;

select *,
row_number() over(
partition by ParcelID, SaleDate, SalePrice, LegalReference
order by UniqueID) row_num
from nashville_housing
order by ParcelID ;

with rownumCTE as (
select *,
row_number() over(
partition by ParcelID, SaleDate, SalePrice, LegalReference
order by UniqueID) row_num
from nashville_housing
)
select *
from rownumCTE
where row_num > 1
order by PropertyAddress;


with rownumCTE as (
select *,
row_number() over(
partition by ParcelID, SaleDate, SalePrice, LegalReference
order by UniqueID) row_num
from nashville_housing
)
delete
from rownumCTE
where row_num > 1;



CREATE TEMPORARY TABLE temp_table AS
SELECT 
    * 
FROM (
  SELECT 
    *,
    ROW_NUMBER() OVER (
      PARTITION BY ParcelID, SaleDate, SalePrice, LegalReference 
      ORDER BY UniqueID
    ) AS row_num
  FROM nashville_housing
) AS subquery
WHERE row_num = 1;

TRUNCATE TABLE nashville_housing;

ALTER TABLE nashville_housing
ADD COLUMN row_num INT;

INSERT INTO nashville_housing
SELECT * FROM temp_table;

ALTER TABLE nashville_housing
DROP COLUMN row_num;



-- Deleting Unused Columns

select *
from nashville_housing;


alter table nashville_housing
drop column OwnerAddress, 
drop column TaxDistrict, 
drop column PropertyAddress;
