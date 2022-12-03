set file_search_path = 'path/to/inputs';
--pt1
inputs as (
	select *
	from read_csv_auto('day2.txt', header=false, delim=' ', columns = {'opp':'varchar', 'you':'varchar'})
)
,possibilities(opp, you, res) as (
	select * 
	from (values ('A', 'X', 4), --draw 1 + 3
				 ('A', 'Y', 8), --win 2 + 6
				 ('A', 'Z', 3), --lose 3 + 0
				 ('B', 'X', 1), --lose 1 + 0
				 ('B', 'Y', 5), --draw 2 + 3
				 ('B', 'Z', 9), --win 3 + 6
				 ('C', 'X', 7), --win 1 + 6
				 ('C', 'Y', 2), --lose 2 + 0
				 ('C', 'Z', 6), --draw 3 + 3
		) p(opp, you, res)
)
, game_results as (
	select i.*, p.res
	from inputs i
	left join possibilities p 
		on p.you = i.you
		and p.opp = i.opp
) 
select sum(res) from game_results;

--pt2
with inputs as (
	select *
	from read_csv_auto('day2.txt', header=false, delim=' ', columns = {'opp':'varchar', 'you':'varchar'})
)
,possibilities(opp, you, res) as (
	select * 
	from (values ('A', 'X', 3), --lose r-s
				 ('A', 'Y', 4), --draw r-r
				 ('A', 'Z', 8), --win r-p
				 ('B', 'X', 1), --lose p-r
				 ('B', 'Y', 5), --draw p-p
				 ('B', 'Z', 9), --win p-s
				 ('C', 'X', 2), --lose s-p
				 ('C', 'Y', 6), --draw s-s
				 ('C', 'Z', 7), --win s-r
		) p(opp, you, res)
)
, game_results as (
	select i.*, p.res
	from inputs i
	left join possibilities p 
		on p.you = i.you
		and p.opp = i.opp
) 
select sum(res) from game_results;