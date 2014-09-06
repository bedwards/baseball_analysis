select
  event_cd_desc.description as "Event",
  count(*) as "N",
  sum(event_run.runs_eoi) as "Runs to End of Inning",
  round(avg(event_run.runs_eoi), 3) as "Average Runs",
  round(avg(run_expectancy.runs), 3) as "Starting RE",
  round(avg(event_run.runs_eoi), 3) - round(avg(run_expectancy.runs), 3) as "Run Value"
from (select * from event_run where game_year >= 1999 and game_year < 2003) as event_run
inner join event_cd_desc on event_run.event_cd = event_cd_desc.event_cd
inner join run_expectancy 
  on event_run.state_1b = run_expectancy.state_1b
    and event_run.state_2b = run_expectancy.state_2b
    and event_run.state_3b = run_expectancy.state_3b
    and event_run.state_outs = run_expectancy.state_outs
group by event_cd_desc.description , event_cd_desc.abbreviation
order by avg(event_run.runs_eoi) desc
;
