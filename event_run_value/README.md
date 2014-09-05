Run Values by Event
===================

This work allows for the analysis of the value of various baseball events. Example events might be a home run or hit by pitch. The value that is assigned is the runs resulting from the event itself as well as the typical number of runs that will be scored throughout the remainder of the half-inning. This latter part gives value events that don't immediately score runs but increase the likelihood that the team will score runs that inning. The value of these events comes from the batter reaching base, runners advancing, and/or no outs being recorded.

This work is inspired by Chapter 1 of [The Book](http://www.amazon.com/gp/product/B00GW6A89Y) and Chapter 5 of [Analyzing Baseball Data with R](http://www.amazon.com/Analyzing-Baseball-Data-Chapman-Hall-ebook/dp/B00GBC36S4/ref=sr_sp-atf_title_1_1?s=digital-text&ie=UTF8&qid=1409819843&sr=1-1&keywords=Analyzing+Baseball+Data+with+R).

I was able to reproduce various tables from "The Book". Here is Table 1. Run Expectancy, By the 24 Base/Out States, 1999-2002.

    1B  | 2B | 3B | 0 Outs | 1 Out | 2 Outs
    ----+----+----+--------+-------+--------
     -- | -- | -- |  0.546 | 0.292 |  0.115
     1B | -- | -- |  0.938 | 0.563 |  0.247
     -- | 2B | -- |  1.176 | 0.711 |  0.339
     -- | -- | 3B |  1.475 | 0.976 |  0.382
     1B | 2B | -- |  1.552 | 0.955 |  0.457
     1B | -- | 3B |  1.886 | 1.227 |  0.526
     -- | 2B | 3B |  2.043 | 1.452 |  0.626
     1B | 2B | 3B |  2.400 | 1.622 |  0.795

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
