set file_search_path = 'path/to/inputs';

create or replace temp table advent as 
select 
    row_number() over () as row_num,
    case when calories is null then 0 else 1 end as break,
    *
from read_csv_auto('day1.txt', header=false, columns={'calories':'int'})
;

with cte as (
    select 
        *,
        row_number() over(order by row_num) - row_number() over (partition by break) as elf
    from advent
    order by row_num
)

select 
    elf,
    sum(calories) as total_cals
from cte 
where break=1
group by 1
order by 2 desc
limit 3;