drop table if exists run_expectancy;
create table run_expectancy as
select
  state_1b,
  state_2b,
  state_3b,
  state_outs,
  round(avg(runs_eoi), 3) as runs
from event_run
where game_year >= 1999 and game_year < 2003
group by state_1b, state_2b, state_3b, state_outs
order by state_1b, state_2b, state_3b, state_outs
;
