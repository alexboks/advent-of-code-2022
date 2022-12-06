set file_search_path = 'path/to/inputs';

-- i did not come up with this answer, just including it for completeness sake :)
-- credit goes to Teggy from DuckDB discord chat

WITH RECURSIVE
input(row, line) AS (
  SELECT ROW_NUMBER() OVER () AS row, c.line
  FROM   read_csv_auto('day5.txt', SEP=false) AS c(line)
),
-- number of stacks
width(w) AS (
  SELECT unnest(generate_series(1, len(string_split_regex(i.line, '\d+')) - 1))
  FROM   input AS i
  WHERE  regexp_full_match(i.line, '( +\d+ +)+')
),
-- extract stacks
stacks(row, line) AS (
  SELECT i.row, i.line
  FROM   input AS i
  WHERE  strpos(i.line, '[') > 0
),
-- initial stack configuration
initial(stacks) AS (
  SELECT list({'pos': stack.pos, 'stack': stack.stack} ORDER BY stack.pos)
  FROM   (SELECT pos, ltrim(string_agg(s.line[2+(pos-1)*4], '' ORDER BY s.row)) AS stack
          FROM   stacks AS s, width AS _(pos)
          GROUP BY pos) AS stack
),
-- list of stack moves to perform
moves(move, line, crates, "from", "to") AS (
  SELECT ROW_NUMBER() OVER (ORDER BY i.row) AS move,
         string_split_regex(i.line, 'move|from|to')[2:4] AS cft,
         cft[1] :: int AS crates, cft[2] :: int AS "from", cft[3] :: int AS "to"
  FROM   input AS i
  WHERE  i.line[1] = 'm'
),
-- crate/stack movement logic (done ?)
run(move, stacks) AS (
  SELECT 1 AS move, i.stacks
  FROM   initial AS i

    UNION ALL

  SELECT r.move + 1 AS move,
         list_apply(r.stacks,
                    stack -> CASE WHEN stack.pos = m."to"
                                  THEN {'pos':stack.pos, 'stack': reverse(r.stacks[m."from"].stack[:m.crates]) || stack.stack} --for pt2 remove reverse fn call
                                  WHEN stack.pos = m."from"
                                  THEN {'pos':stack.pos, 'stack': stack.stack[1+m.crates:]}
                                  ELSE stack
                             END) AS stacks
  FROM   run AS r, moves AS m
  WHERE  r.move = m.move
)
SELECT replace(list_string_agg(list_apply(r.stacks, stack -> stack.stack[1])), ',', '') AS crates
FROM   run AS r
ORDER BY r.move DESC
LIMIT 1;