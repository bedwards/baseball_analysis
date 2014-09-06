drop table if exists event_run;

create table event_run (
  event_uid varchar(15) primary key,
  game_year integer not null,
  runs_scored integer not null,
  runs_eoi integer not null,
  event_cd integer not null,
  state_1b boolean not null,
  state_2b boolean not null,
  state_3b boolean not null,
  state_outs integer not null,
  new_state_1b boolean not null,
  new_state_2b boolean not null,
  new_state_3b boolean not null,
  new_state_outs integer not null
);

create index event_run_game_year_index on event_run(game_year);

with event_subset as (select * from event where game_year >= 1999)
insert into event_run
select * from (
select
  event_uid,
  game_year,
  runs_scored,
  max_runs - runs as runs_eoi,
  event_cd,
  base1_run_id is not null as state_1b,
  base2_run_id is not null as state_2b,
  base3_run_id is not null as state_3b,
  outs_ct as state_outs,
  1 in (bat_dest_id, run1_dest_id) as new_state_1b,
  2 in (bat_dest_id, run1_dest_id, run2_dest_id) as new_state_2b,
  3 in (bat_dest_id, run1_dest_id, run2_dest_id, run3_dest_id) as new_state_3b,
  outs_ct + event_outs_ct as new_state_outs
from event_subset
inner join (
  select
    half_inning_id,
    sum(runs_scored) + min(runs) as max_runs
  from event_subset
  where inn_ct < 9 or not bat_home_id
  group by half_inning_id
  ) as half_inning 
  on event_subset.half_inning_id = half_inning.half_inning_id
) as q
where
  runs_scored > 0
  or state_1b != new_state_1b
  or state_2b != new_state_2b
  or state_3b != new_state_3b
  or state_outs < new_state_outs
;
