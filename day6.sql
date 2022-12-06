set file_search_path = 'path/to/inputs';

with inputs as (
	select 
		unnest(generate_series(1, len(str_split(s, '')))) as row_num,
		unnest(str_split(s, '')) as stream
	from read_csv_auto('day6.txt', header=false) as i(s)
)
, stream as (
	select 
		*,
		unnest(list(stream) over w) as last_4_stream
	from inputs
	window w as (rows between 13 preceding and current row)
	--day 1, change to 3
)
select 
	row_num,
	count(distinct last_4_stream) as distinct_signal
from stream
group by row_num
having distinct_signal = 14 --day 1, change to 4
order by 1