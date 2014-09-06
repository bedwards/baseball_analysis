select
  case when bases.state_1b then '1B' else '--' end as "1B",
  case when bases.state_2b then '2B' else '--' end as "2B",
  case when bases.state_3b then '3B' else '--' end as "3B",
  no_outs.runs as "0 Outs",
  one_out.runs as "1 Out",
  two_outs.runs as "2 Outs"
from (
  select distinct state_1b, state_2b, state_3b from run_expectancy
  ) as bases
inner join (
  select * from run_expectancy where state_outs = 0
  ) as no_outs
  on bases.state_1b = no_outs.state_1b
    and bases.state_2b = no_outs.state_2b
    and bases.state_3b = no_outs.state_3b
inner join (
  select * from run_expectancy where state_outs = 1
  ) as one_out
  on bases.state_1b = one_out.state_1b
    and bases.state_2b = one_out.state_2b
    and bases.state_3b = one_out.state_3b
inner join (
  select * from run_expectancy where state_outs = 2
  ) as two_outs
  on bases.state_1b = two_outs.state_1b
    and bases.state_2b = two_outs.state_2b
    and bases.state_3b = two_outs.state_3b
order by no_outs.runs
;
