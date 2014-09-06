Run Values by Event
===================

This work allows for the analysis of the value of various baseball events. Example events might be a home run or hit by pitch. The value that is assigned is the runs resulting from the event itself as well as the typical number of runs that will be scored throughout the remainder of the half-inning. This latter part gives value to events that don't immediately score runs but increase the likelihood that the team will score runs that inning. The value of these events comes from the batter reaching base, runners advancing, and/or no outs being recorded.

This work is inspired by Chapter 1 of [The Book](http://www.amazon.com/gp/product/B00GW6A89Y) and Chapter 5 of [Analyzing Baseball Data with R](http://www.amazon.com/Analyzing-Baseball-Data-Chapman-Hall-ebook/dp/B00GBC36S4/ref=sr_sp-atf_title_1_1?s=digital-text&ie=UTF8&qid=1409819843&sr=1-1&keywords=Analyzing+Baseball+Data+with+R).

I was able to reproduce various tables from "The Book". Here is Table 1. Run Expectancy, By the 24 Base/Out States, 1999-2002.

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

Recreation of "The Book"'s Table 4. Runs To End of Inning, By Event

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

Backing Data
============

This work depends on [loading the Retrosheet play-by-play event data into a PostgreSQL database](/retrosheet/).

A series of tables will be produced for human consumption and contemplation, but first you must create the backing table. The retrosheet event table is not sufficient. This new backing table has additional information encoding the game state before and after the event, as well as providing context about the half inning in which the event occurred. The new columns are state, new_state, and runs_roi.

state and new_state
-------------------

Both are strings encoding the state of runners on base and number of outs.

    <1B occupied flag><2B occupied flag><3B occupied flag><out count>

For example, if there are runners on 2nd and 3rd with 2 outs the state string would be '0112'. state is the state before the event. new_state is the state after the event.

runs_roi
------------------------

runs_roi represents the runs scored directly as a result of this event and the actual runs scored in the remainder of the half-inning in which this event occurred.
