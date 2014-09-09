select
  "1B",
  "2B",
  "3B",
  "Outs",
  "HR",
  "Avg REOI" - "Starting RE" as "Original",
  "Starting RE",
  "Ending RE",
  "Ending RE" - "Starting RE" as "Run Value"
from
(
  select
    case when event_run.state_1b then '1B' else '--' end as "1B",
    case when event_run.state_2b then '2B' else '--' end as "2B",
    case when event_run.state_3b then '3B' else '--' end as "3B",
    event_run.state_outs as "Outs",
    count(*) as "HR",
    round(avg(event_run.runs_eoi), 3) as "Avg REOI",
    round(avg(run_expectancy.runs), 3) as "Starting RE",
    round(avg(event_run.runs_scored + new_re.runs), 3) as "Ending RE"
  from (select * from event_run where game_year >= 1999 and game_year < 2003) as event_run
  inner join run_expectancy 
    on event_run.state_1b = run_expectancy.state_1b
    and event_run.state_2b = run_expectancy.state_2b
    and event_run.state_3b = run_expectancy.state_3b
    and event_run.state_outs = run_expectancy.state_outs
  inner join run_expectancy as new_re
    on event_run.new_state_1b = new_re.state_1b
      and event_run.new_state_2b = new_re.state_2b
      and event_run.new_state_3b = new_re.state_3b
      and event_run.new_state_outs = new_re.state_outs
  where event_run.event_cd = 23
  group by
    event_run.state_1b,
    event_run.state_2b,
    event_run.state_3b,
    event_run.state_outs
  order by
    event_run.state_1b::integer + event_run.state_2b::integer + event_run.state_3b::integer,
    event_run.state_3b,
    event_run.state_2b,
    event_run.state_1b,
    event_run.state_outs
) as q
;
