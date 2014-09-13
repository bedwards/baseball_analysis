#! /usr/bin/env Rscript

suppressMessages(require(reshape2))
suppressMessages(require(plyr))

args <- commandArgs(trailingOnly = TRUE)

if (length(args) != 1) {
  stop("Usage: run_expectancy.r <path/to/csv>")
}

event_run_csv_path <- args[1]
cat("\nReading CSV (takes about 30 seconds).\n")
system.time(events <- read.csv(event_run_csv_path))
cat("\n")

events$state_1b <- factor(events$state_1b,labels=c("--","1B"))
events$state_2b <- factor(events$state_2b, labels=c("--","2B"))
events$state_3b <- factor(events$state_3b, labels=c("--","3B"))
events$state_outs <- factor(events$state_outs, labels=c("0 Outs","1 Out", "2 Outs"))
events$new_state_1b <- factor(events$new_state_1b,labels=c("--","1B"))
events$new_state_2b <- factor(events$new_state_2b, labels=c("--","2B"))
events$new_state_3b <- factor(events$new_state_3b, labels=c("--","3B"))
events$new_state_outs <- factor(events$new_state_outs, labels=c("0 Outs","1 Out", "2 Outs", "3 Outs"))

table_1 <- dcast(
  events, 
  list(
    .("1B"=state_1b, "2B"=state_2b, "3B"=state_3b),
    .(state_outs)), 
  fun.aggregate=function(runs_eoi) round(mean(runs_eoi), 3), 
  value.var="runs_eoi")

table_1 <- table_1[order(table_1$"0 Outs"),]
cat("\nRun Expectancy, By the 24 Base/Out States, 1999-2002\n\n")
print(table_1, row.names=FALSE)
cat("\n")
