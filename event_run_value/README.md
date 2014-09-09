Run Values by Event
===================

This work allows for the analysis of the value of various baseball events. Example events might be a home run or hit by pitch. The value that is assigned is the runs resulting from the event itself as well as the typical number of runs that will be scored throughout the remainder of the half-inning. This latter part gives value to events that don't immediately score runs but increase the likelihood that the team will score runs that inning. The value of these events comes from the batter reaching base, runners advancing, and/or no outs being recorded.

This work is inspired by Chapter 1 of [The Book](http://www.amazon.com/gp/product/B00GW6A89Y) and Chapter 5 of [Analyzing Baseball Data with R](http://www.amazon.com/Analyzing-Baseball-Data-Chapman-Hall-ebook/dp/B00GBC36S4/ref=sr_sp-atf_title_1_1?s=digital-text&ie=UTF8&qid=1409819843&sr=1-1&keywords=Analyzing+Baseball+Data+with+R).

I was able to reproduce various tables from "The Book". Here is Table 1. Run Expectancy, By the 24 Base/Out States, 1999-2002 [matrix.sql](matrix.sql)

    1B  | 2B | 3B | 0 Outs | 1 Out | 2 Outs
    ----+----+----+--------+-------+--------
     -- | -- | -- |  0.555 | 0.297 |  0.117
     1B | -- | -- |  0.953 | 0.572 |  0.251
     -- | 2B | -- |  1.189 | 0.724 |  0.344
     -- | -- | 3B |  1.484 | 0.983 |  0.387
     1B | 2B | -- |  1.571 | 0.971 |  0.465
     1B | -- | 3B |  1.902 | 1.240 |  0.536
     -- | 2B | 3B |  2.052 | 1.467 |  0.634
     1B | 2B | 3B |  2.416 | 1.650 |  0.813

Recreation of "The Book"'s Table 4. Runs To End of Inning, By Event [reoi_by_event_type.sql](reoi_by_event_type.sql)

    Event                   |   N    | Runs to End of Inning | Average Runs | Starting RE | Run Value
    ------------------------+--------+-----------------------+--------------+-------------+-----------
     home run               |  21027 |                 40839 |        1.942 |       0.533 |     1.409
     triple                 |   3644 |                  5887 |        1.616 |       0.552 |     1.064
     double                 |  34128 |                 44738 |        1.311 |       0.547 |     0.764
     error                  |   7407 |                  8587 |        1.159 |       0.600 |     0.559
     interference           |     60 |                    65 |        1.083 |       0.654 |     0.429
     single                 | 112727 |                115913 |        1.028 |       0.553 |     0.475
     passed ball            |   1166 |                  1191 |        1.021 |       0.739 |     0.282
     wild pitch             |   5312 |                  5300 |        0.998 |       0.714 |     0.284
     hit by pitch           |   6558 |                  6354 |        0.969 |       0.584 |     0.385
     balk                   |    625 |                   596 |        0.954 |       0.714 |     0.240
     fielders choice        |   1765 |                  1518 |        0.860 |       1.175 |    -0.315
     walk                   |  60572 |                 51430 |        0.849 |       0.519 |     0.330
     intentional walk       |   4634 |                  3915 |        0.845 |       0.742 |     0.103
     stolen base            |  10259 |                  8065 |        0.786 |       0.596 |     0.190
     defensive indifference |    412 |                   212 |        0.515 |       0.454 |     0.061
     pickoff                |   2268 |                   951 |        0.419 |       0.671 |    -0.252
     generic out            | 352007 |                 87742 |        0.249 |       0.544 |    -0.295
     strikeout              | 120614 |                 25056 |        0.208 |       0.518 |    -0.310
     caught stealing        |   3734 |                   616 |        0.165 |       0.621 |    -0.456
     other advance          |    211 |                    29 |        0.137 |       0.708 |    -0.571

Recreation of "The Book"'s Table 5. Runs To End Of Inning, By Base/Out State, For HR [hr_state_reoi.sql](hr_state_reoi.sql)

    1B  | 2B | 3B | Outs |  HR  | REOI | Avg REOI | Start RE | Run Value
    ----+----+----+------+------+------+----------+----------+-----------
     -- | -- | -- |    0 | 5519 | 8780 |    1.591 |    0.555 |     1.036
     -- | -- | -- |    1 | 3498 | 4528 |    1.294 |    0.297 |     0.997
     -- | -- | -- |    2 | 3023 | 3382 |    1.119 |    0.117 |     1.002
     1B | -- | -- |    0 | 1195 | 3137 |    2.625 |    0.953 |     1.672
     1B | -- | -- |    1 | 1401 | 3213 |    2.293 |    0.572 |     1.721
     1B | -- | -- |    2 | 1394 | 2957 |    2.121 |    0.251 |     1.870
     -- | 2B | -- |    0 |  292 |  728 |    2.493 |    1.189 |     1.304
     -- | 2B | -- |    1 |  535 | 1243 |    2.323 |    0.724 |     1.599
     -- | 2B | -- |    2 |  661 | 1395 |    2.110 |    0.344 |     1.766
     -- | -- | 3B |    0 |   42 |  106 |    2.524 |    1.484 |     1.040
     -- | -- | 3B |    1 |  193 |  440 |    2.280 |    0.983 |     1.297
     -- | -- | 3B |    2 |  273 |  583 |    2.136 |    0.387 |     1.749
     1B | 2B | -- |    0 |  305 | 1042 |    3.416 |    1.571 |     1.845
     1B | 2B | -- |    1 |  544 | 1826 |    3.357 |    0.971 |     2.386
     1B | 2B | -- |    2 |  588 | 1831 |    3.114 |    0.465 |     2.649
     1B | -- | 3B |    0 |  120 |  426 |    3.550 |    1.902 |     1.648
     1B | -- | 3B |    1 |  230 |  760 |    3.304 |    1.240 |     2.064
     1B | -- | 3B |    2 |  312 |  981 |    3.144 |    0.536 |     2.608
     -- | 2B | 3B |    0 |   59 |  210 |    3.559 |    2.052 |     1.507
     -- | 2B | 3B |    1 |  133 |  438 |    3.293 |    1.467 |     1.826
     -- | 2B | 3B |    2 |  155 |  491 |    3.168 |    0.634 |     2.534
     1B | 2B | 3B |    0 |   78 |  354 |    4.538 |    2.416 |     2.122
     1B | 2B | 3B |    1 |  230 |  969 |    4.213 |    1.650 |     2.563
     1B | 2B | 3B |    2 |  247 | 1019 |    4.126 |    0.813 |     3.313

Recreation of "The Book"'s Table 6. Run Value of HR, By Base/Out State [hr_state_reoi_2.sql](hr_state_reoi_2.sql)

    1B  | 2B | 3B | Outs |  HR  | Original | Starting RE | Ending RE | Run Value
    ----+----+----+------+------+----------+-------------+-----------+-----------
     -- | -- | -- |    0 | 5519 |    1.036 |       0.555 |     1.555 |     1.000
     -- | -- | -- |    1 | 3498 |    0.997 |       0.297 |     1.297 |     1.000
     -- | -- | -- |    2 | 3023 |    1.002 |       0.117 |     1.117 |     1.000
     1B | -- | -- |    0 | 1195 |    1.672 |       0.953 |     2.555 |     1.602
     1B | -- | -- |    1 | 1401 |    1.721 |       0.572 |     2.297 |     1.725
     1B | -- | -- |    2 | 1394 |    1.870 |       0.251 |     2.117 |     1.866
     -- | 2B | -- |    0 |  292 |    1.304 |       1.189 |     2.555 |     1.366
     -- | 2B | -- |    1 |  535 |    1.599 |       0.724 |     2.297 |     1.573
     -- | 2B | -- |    2 |  661 |    1.766 |       0.344 |     2.117 |     1.773
     -- | -- | 3B |    0 |   42 |    1.040 |       1.484 |     2.555 |     1.071
     -- | -- | 3B |    1 |  193 |    1.297 |       0.983 |     2.297 |     1.314
     -- | -- | 3B |    2 |  273 |    1.749 |       0.387 |     2.117 |     1.730
     1B | 2B | -- |    0 |  305 |    1.845 |       1.571 |     3.555 |     1.984
     1B | 2B | -- |    1 |  544 |    2.386 |       0.971 |     3.297 |     2.326
     1B | 2B | -- |    2 |  588 |    2.649 |       0.465 |     3.117 |     2.652
     1B | -- | 3B |    0 |  120 |    1.648 |       1.902 |     3.555 |     1.653
     1B | -- | 3B |    1 |  230 |    2.064 |       1.240 |     3.297 |     2.057
     1B | -- | 3B |    2 |  312 |    2.608 |       0.536 |     3.117 |     2.581
     -- | 2B | 3B |    0 |   59 |    1.507 |       2.052 |     3.555 |     1.503
     -- | 2B | 3B |    1 |  133 |    1.826 |       1.467 |     3.297 |     1.830
     -- | 2B | 3B |    2 |  155 |    2.534 |       0.634 |     3.117 |     2.483
     1B | 2B | 3B |    0 |   78 |    2.122 |       2.416 |     4.555 |     2.139
     1B | 2B | 3B |    1 |  230 |    2.563 |       1.650 |     4.297 |     2.647
     1B | 2B | 3B |    2 |  247 |    3.313 |       0.813 |     4.117 |     3.304

Recreation of "The Book"'s Table 7. Run Values By Event [event_run_value.sql](event_run_value.sql)

    Event                   | Run Value
    ------------------------+-----------
     home run               |     1.397
     triple                 |     1.071
     double                 |     0.779
     error                  |     0.521
     single                 |     0.478
     interference           |     0.392
     hit by pitch           |     0.351
     walk                   |     0.323
     passed ball            |     0.268
     wild pitch             |     0.266
     balk                   |     0.265
     intentional walk       |     0.179
     stolen base            |     0.178
     defensive indifference |     0.118
     pickoff                |    -0.268
     generic out            |    -0.281
     fielders choice        |    -0.300
     strikeout              |    -0.308
     caught stealing        |    -0.572
     other advance          |    -0.663

Backing Data
============

This work depends on [loading the Retrosheet play-by-play event data into a PostgreSQL database](/retrosheet/).

To produce the series of tables show above you must create the backing table (event_run). The retrosheet event table is not sufficient. This new backing table has additional information encoding the game state before and after the event, as well as providing context about the half inning in which the event occurred. The new columns are runs_eoi (runs through end of inning), and four columns for the base/out state before and after the event (state_* and new_state_*). runs_eoi represents the runs scored directly as a result of this event and the actual runs scored in the remainder of the half-inning in which this event occurred. [event_run.sql](event_run.sql) is the sql script used to create the event_run table.
