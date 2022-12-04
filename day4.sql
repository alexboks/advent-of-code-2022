set file_search_path = 'path/to/inputs';

--part 1
with inputs as (
	select 
		row_number() over () as grp, 
		str_split(e1, '-')[1]::int as e1_start,
		str_split(e1, '-')[2]::int as e1_end,
		str_split(e2, '-')[1]::int as e2_start,
		str_split(e2, '-')[2]::int as e2_end,
	from read_csv_auto('day4.txt', header=false, columns ={'e1':'varchar', 'e2':'varchar'})
)

, p1_answer as (
select 
	1 as part,
	count(*) as answer
from inputs 
where 
	(e1_start >= e2_start and e1_end <= e2_end)
	or 
	(e2_start >= e1_start and e2_end <= e1_end)
)
--part2
, p2_answer as (
	select 
		2 as part,
		count(*) as answer
	from inputs
	where 
		(e1_start <= e2_end and e1_end >= e2_start)
		or (e2_start <= e1_end and e2_end >= e1_start)
)

select * from p1_answer
union all
select * from p2_answer
	;