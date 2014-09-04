Run Values by Event
===================

This work allows for the analysis of the value of various baseball events. Example events might be a home run or hit by pitch. The value that is assigned is the runs resulting from the event itself as well as the typical number of runs that will be scored throughout the remainder of the half-inning. This latter part gives value events that don't immediately score runs but increase the likelihood that the team will score runs that inning. The value of these events comes from the batter reaching base, runners advancing, and/or no outs being recorded.

This work is inspired by Chapter 1 of [The Book](http://www.amazon.com/gp/product/B00GW6A89Y) and Chapter 5 of [Analyzing Baseball Data with R](http://www.amazon.com/Analyzing-Baseball-Data-Chapman-Hall-ebook/dp/B00GBC36S4/ref=sr_sp-atf_title_1_1?s=digital-text&ie=UTF8&qid=1409819843&sr=1-1&keywords=Analyzing+Baseball+Data+with+R).

This work depends on [loading the Retrosheet play-by-play event data into a PostgreSQL database](/retrosheet/).


Backing Data
============

A series of tables will be produced for human consumption and contemplation, but first you must create the backing table. The retrosheet event table is not sufficient. This new backing table has additional information about the half inning in which the event occurred. The new columns with half-inning information are

* 