The End Result
==============

After following the steps documented here you will have a PostgresSQL database with the Retrosheet play-by-play event data from the 1921 season to the 2013 season. The database performs reasonably well on my three-year-old Mac Book Pro.
This is truly an amazing time to analyze baseball stats. I was really into baseball as a kid in the 80s and early 90s. It is remarkable how much more can be accomplished today with the advances in computing power, opensource software, and the Internet.

Here is a description of the data.

* 83 MLB seasons
* 97 columns, 10.8 million rows
* 4.3 GB CSV file
* 14 minutes - time it takes to load data from staging table to table with types, constraints, and additional columns (details below)
* 7 seconds - time to count distinct years
* 2 seconds - time to count number of home runs hit in the 80s (range of years)
* 120 ms - time to count home runs in specific year

Table sizes

    table_name    | table_size | total_size
    --------------+------------+------------
    event_ingest  | 3426 MB    | 3426 MB
    event         | 4971 MB    | 6209 MB

Query to produce those results

    =# select
         table_name,
         pg_size_pretty(pg_table_size(table_name)) as table_size,
         pg_size_pretty(pg_total_relation_size(table_name)) as total_size
       from (
         select table_name
         from information_schema.tables
         where
           table_schema = 'retrosheet'
           and table_name like 'event%'
       ) as q;


Loading Retrosheet Events
=========================

Here are the steps I used to load the Retrosheet play-by-play event data into a PostgreSQL database. First, download and install the prerequisites that are external to this GitHub repository.

1. Download the [retrosheet event data](http://www.retrosheet.org/game.htm). Download all the regular season event files by decade from 1921-2013.
2. Download the [bevent.exe](http://www.retrosheet.org/tools.htm) tool.
3. If using a Mac, [install wine using homebrew](http://www.davidbaumgold.com/tutorials/wine-mac/).
4. Familiarize yourself with the [descriptions of the event fields](http://www.retrosheet.org/datause.txt).

Next, prepare a CSV file with event data for all decades. Unzip the event files for all decades into a single directory. Transform the event files into a CSV file.

    for filename in `ls ~/Downloads/eve_zip/*.EV*`
    do
      year=`echo $filename | cut -c1-4`
      wine ~/bevent.exe -y $year -f 0-96 $filename >> noheader.csv
    done

Create a schema for the retrosheet event data.

    $ psql
    =# create schema retrosheet;
    =# set search_path=retrosheet;

My strategy is to copy the CSV into Postgres using a staging table named "event_ingest" with all fields defined as varchars with no constraints. Then in a second step, select from event_ingest and insert into a table named "event". This strategy was more workable than debugging problems with copying from the CSV directly into the event table. Create the database schema.

    =# \i ddl.sql

Load the events into the staging table.

    =# copy event_ingest from 'noheader.csv' csv;

The event table has the following fields in addition to those found in event_ingest:

* event_uid (game_id + event_id)
* game_date (extracted from game_id)
* game_year (extracted from game_id)
* game_month (extracted from game_id)
* game_day_of_month (extracted from game_id)
* game_number (extracted from game_id, for double headers)
* home_team_id (extracted from game_id)
* half_inning_id (game_id + inn_ct + bat_home_id)
* runs - total runs scored by both teams prior to this event (away_score_ct + home_score_ct)
* runs_scored - runs scored during this event (sum of batter and runner destination IDs that indicate crossing home plate)

Copy the data from the event_ingest table to the event table using [event.sql](event.sql).

    =# \i event.sql

Gory Details of Creating DDL
============================

Here I show the steps I used to create the DDL, but you can skip these steps by using the [DDL script](ddl.sql) in this repository. First, download and install the prerequisites that are external to this GitHub repository.

1. Download [fields.csv](https://raw.githubusercontent.com/maxtoki/baseball_R/master/data/fields.csv).
2. Install csvkit using [pip install csvkit](http://csvkit.readthedocs.org/en/latest/index.html#), from which the csvsql tool is used to generate SQL DDL from headers and data in CSV files.

Create and load the fields table.

    =# create table fields (
         field_number integer not null,
         description varchar(43) not null,
         header varchar(25) not null
       );
    =# copy fields from 'fields.csv' csv header;

Generate header.csv file from the fields table.

    =# \t
    Showing only tuples.
    =# \o header.csv
    =# select string_agg(header,',') from fields;
    =# \o
    =# \t

Generate the create table statement for event_ingest.

    $ cat header.csv > event_sample.csv
    $ head -n1000 noheader.csv >> event_sample.csv
    $ csvsql -i postgresql --no-constraints event_sample.csv

Edit the output changing all the field types to varchar and change the table name to event_ingest. Generate the create table statement with constraints for the event table.

    $ csvsql -i postgresql event_sample.csv

Edit it to match the create table statement in [ddl.sql](ddl.sql). csvsql gives a good start, but it only uses a subset of the data and some of the types are incorrect. Also I created enum types for some of the fields.

Create indexes on game_year and half_inning_id.

    =# create index event_game_year_index on event(game_year);
    =# create index event_game_half_inning_index on event(half_inning_id);
