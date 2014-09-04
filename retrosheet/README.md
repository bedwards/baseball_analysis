Loading Retrosheet Events
=========================

Here are the steps I used to load the Retrosheet play-by-play event data into a PostgreSQL database.

Download and install the prerequisites that are external to this GitHub repository.

1. Download the [retrosheet event data](http://www.retrosheet.org/game.htm). Download all the regular season event files by decade from 1921-2013.
2. Download the [bevent.exe](http://www.retrosheet.org/tools.htm) tool.
3. If using a Mac, [install wine using homebrew](http://www.davidbaumgold.com/tutorials/wine-mac/).
4. Familiarize yourself with the [descriptions of the event fields](http://www.retrosheet.org/datause.txt).
5. Download [fields.csv](https://raw.githubusercontent.com/maxtoki/baseball_R/master/data/fields.csv).
6. Install csvkit using [pip install csvkit](http://csvkit.readthedocs.org/en/latest/index.html#), from which the csvsql tool is used to generate SQL DDL from headers and data in CSV files.

Prepare the CSV.

1. Unzip the event files for all decades into a single directory.
2. Transform the event files into a CSV file.

    for filename in `ls ~/Downloads/eve_zip/*.EV*`
    do
      year=`echo $filename | cut -c1-4`
      wine ~/bevent.exe -y $year -f 0-96 $filename >> noheader.csv
    done

My strategy was to copy the CSV into Postgres using a staging table named "event_ingest" with all fields defined as varchars with no constraints. Then in a second step, select from event_ingest and insert into a table named "event". This strategy was more workable than debugging problems with copying from the CSV directly into the event table. Below I show the steps I used to create the DDL, but you can skip these steps by using the [DDL script](ddl.sql) in this repository.

Generate create table statements.

    cat headers.csv > event.csv
    head -n1000 noheader.csv >> event.csv
    csvsql -i postgresql --no-constraints event.csv
    csvsql -i postgresql event.csv

