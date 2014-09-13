Run Values by Event (R)
=======================

Analyzing the run value of various baseball events (home run, single, walk, 
etc.) using [R](http://www.r-project.org/). This work is based on the 
[SQL work](../). It starts by converting the run_value table to CSV.

    copy (
      select * 
      from event_run 
      where game_year >= 1999 and game_year < 2003
    ) 
    to 'event_run_1999_2002.csv' csv header;

Run the [script](run_expectancy.r), or follow along step-by-step. First, load the
CSV it into R.

    system.time(events <- read.csv("event_run_1999_2002.csv"))
     user  system elapsed 
     31.183   0.274  31.455 

And transforming the values slightly to match up with what I want to print out.

    events$state_1b <- factor(events$state_1b,labels=c("--","1B"))
    events$state_2b <- factor(events$state_2b, labels=c("--","2B"))
    events$state_3b <- factor(events$state_3b, labels=c("--","3B"))
    events$state_outs <- factor(events$state_outs, labels=c("0 Outs","1 Out", "2 Outs"))
    events$new_state_1b <- factor(events$new_state_1b,labels=c("--","1B"))
    events$new_state_2b <- factor(events$new_state_2b, labels=c("--","2B"))
    events$new_state_3b <- factor(events$new_state_3b, labels=c("--","3B"))
    events$new_state_outs <- factor(events$new_state_outs, labels=c("0 Outs","1 Out", "2 Outs", "3 Outs"))

Get a feel for the data

    print(head(events, 4), row.names=FALSE)

           event_uid game_year runs_scored runs_eoi event_cd state_1b state_2b state_3b state_outs
     ANA199904060010      1999           0        0        2       --       --       --     0 Outs
     ANA199904060011      1999           0        0        2       --       --       --      1 Out
     ANA199904060012      1999           0        0       14       --       --       --     2 Outs
     ANA199904060013      1999           0        0        3       1B       --       --     2 Outs
     new_state_1b new_state_2b new_state_3b new_state_outs
               --           --           --          1 Out
               --           --           --         2 Outs
               1B           --           --         2 Outs
               1B           --           --         3 Outs

Load required packages.

    require(reshape2)
    require(plyr)

If those fail, install the packages, and then re-run the require commands.

    install.packages("reshape2")
    install.packages("plyr")

Recreate Table 1 from "The Book". It is the run expectancy table of the 24 baseball
baserunner/out states for the 1999-2002 MLB seasons.

    table_1 <- dcast(
      events, 
      list(
        .("1B"=state_1b, "2B"=state_2b, "3B"=state_3b),
        .(state_outs)), 
      fun.aggregate=function(runs_eoi) round(mean(runs_eoi), 3), 
      value.var="runs_eoi")

    table_1 <- table_1[order(table_1$"0 Outs"),]

    print(table_1, row.names=FALSE)

     1B 2B 3B 0 Outs 1 Out 2 Outs
     -- -- --  0.555 0.297  0.117
     1B -- --  0.953 0.572  0.251
     -- 2B --  1.189 0.724  0.344
     -- -- 3B  1.484 0.983  0.387
     1B 2B --  1.571 0.971  0.465
     1B -- 3B  1.902 1.240  0.536
     -- 2B 3B  2.052 1.467  0.634
     1B 2B 3B  2.416 1.650  0.813
