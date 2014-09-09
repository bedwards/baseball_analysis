select
  event_cd_desc.description as "Event",
  round(avg(event_run.runs_scored + new_re.runs - run_expectancy.runs), 3) as "Run Value"
from (select * from event_run where game_year >= 1999 and game_year < 2003) as event_run
inner join event_cd_desc on event_run.event_cd = event_cd_desc.event_cd
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
group by event_cd_desc.description
order by "Run Value" desc
;
