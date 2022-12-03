set file_search_path = 'path/to/inputs';

--part 1
with inputs as (
select 
	row_number() over() as elf,
	rucksack ,
	[rucksack[i] for i in range(1,len(rucksack)+1)] as items,
	items[1:len(items)/2] as compart_1,
	items[len(items)/2 + 1:len(items)+1] as compart_2
from read_csv_auto('day3.txt', header=false, columns={'rucksack':'varchar'})
)
, c1 as (
	select 
		elf,
		unnest(compart_1) as item
	from inputs
)

, c2 as (
	select 
		elf,
		unnest(compart_2) as item
	from inputs
)

, priorities as (
select distinct *,
	case 
		when lower(item) = item then ord(item) - 96
		when upper(item) = item then ord(item) - 64 + 26
	end as priority
from c1 natural join c2
)

select sum(priority) from priorities;
;

--part 2
with inputs as (
	select 
		row_number() over() as elf,
		ntile((select count(*) from read_csv_auto('day3.txt', header=false, columns={'rucksack':'varchar'}))/3) over () as grp,
		rucksack ,
		[rucksack[i] for i in range(1,len(rucksack)+1)] as items,
	from read_csv_auto('day3.txt', header=false, columns={'rucksack':'varchar'})
)
,elf_groups as (
	select 
		grp,
		list(items order by elf)[1] as elf1,
		list(items order by elf)[2] as elf2,
		list(items order by elf)[3] as elf3
	from inputs
	group by grp
)
, e1 as (
	select 
		grp,
		unnest(elf1) as item
	from elf_groups
)
, e2 as (
	select 
		grp,
		unnest(elf2) as item
	from elf_groups
)
, e3 as (
	select 
		grp,
		unnest(elf3) as item
	from elf_groups
)
, common_group_items as (
	select distinct 
		*,
		case 
			when lower(item) = item then ord(item) - 96
			when upper(item) = item then ord(item) - 64 + 26
		end as priority
	from e1
	natural join e2
	natural join e3
)
select sum(priority) from common_group_items;
;


