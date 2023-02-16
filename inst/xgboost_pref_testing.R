#!/usr/bin/env Rscript

library(optparse)
library(readr)
library(assertthat)
library(futile.logger)
library(brentlabModelPerfTesting)

# GLOBALS ---------------------------------------------------------------------
TEST = FALSE

# cmd line argument parser ----------------------------------------------------

parser <- OptionParser()
parser <- add_option(parser, c("-v", "--verbose"), action="store_true",
                     default=FALSE, help="Print extra output [default]")
parser <- add_option(parser, c("--input"), type="character",
                     default="use_package_data",
                     help=paste("you do not have to set this to use the",
                                "brentlabModelPerfTesting package test data.",
                                "This default data is a 1300 x 81822.",
                                "default label_colname, see below, is",
                                "set to default to the appropriate response",
                                "label for this data. Otherwise, set a",
                                "path to a rds file of a data.frame where",
                                "the first column is an expression vector",
                                "the rest of the columns are snp vectors.",
                                "rows are samples", sep = " "),
                     metavar ="/path/to/input.rds")
parser <- add_option(parser, c("--label_colname"), type="character",
                     default="ensg00000183117_19",
                     help=paste("name of the column in the input data to",
                                "use as the response vector. Default is ",
                                "set for the default package input data", sep = " "),
                     metavar ="ensg00000183117_19")
parser <- add_option(parser, c("-g", "--gpu"),
                     default = FALSE,
                     action="store_true",
                     dest="gpu",
                     help="set --gpu to use the gpu_hist method. otherwise, cpu")
parser <- add_option(parser, c("--cpu"), type="integer",
                     default=5,
                     help="number of threads. Ignored if --gpu is set",
                     metavar="5")
parser <- add_option(parser, c('--rounds'), type="integer",
                     default=10,
                     help="xgboost rounds parameter",
                     metavar ="10")
parser <- add_option(parser, c('--max_bin'), type="integer",
                     default=10,
                     help="xgboost max_bin parameter",
                     metavar ="10")
parser <- add_option(parser, c('--max_depth'), type="integer",
                     default=10,
                     help="xgboost max_depth parameter",
                     metavar="10")
parser <- add_option(parser, c("--num_features"), type="integer",
                     default=-1,
                     help="number of features to include. Default is -1, which will include all avail",
                     metavar="-1")
parser <- add_option(parser, c("--out"),
                     default = FALSE,
                     action="store_true",
                     dest="out",
                     help=paste("set --out to write a csv with the",
                                 "performance time and memory results", sep=" "))
parser <- add_option(parser, c("--prefix"), type="character",
                     default="xgboost_perf_test",
                     help=paste("prefix to append to results. Default is none.",
                                "if --out is set, set --prefix to some string",
                                "to add something, ",
                                "eg param_10_10_2_result.csv", sep=" "),
                     metavar="''")

# main ------------------------------------------------------------------------
if(TEST){
  opt = parse_args(parser, args = c("--verbose"))
  if (opt$num_features == -1){
    opt$num_features = Inf
  }
} else{
  opt = parse_args(parser)
  if (opt$num_features == -1){
    opt$num_features = Inf
  }
}

if (opt$verbose){
  x = flog.threshold(INFO)
} else{
  x = flog.threshold(ERROR)
}

flog.info(paste(paste(names(opt), opt, sep = ': '), collapse = ", "))

if (opt$input == 'use_package_data'){
  input_data = readRDS(
    system.file('gene_data_clean.rds',
                package = 'brentlabModelPerfTesting'))
} else{
  input_data = readRDS(opt$input)
}

# ensure that the input data is a data.frame (tibble is a data.frame, too)
if (!is.data.frame(input_data)){
  stop(paste('input data must be an rds which is read in as a',
       'data.frame obj (tibble counts as a data.frame)', sep=" "))
}

split_data = brentlabModelPerfTesting::prep_data(
  input_data,
  feature_num = opt$num_features,
  label_vector = opt$label_colname)

if (opt$gpu) {

  param <- list(
    objective = 'reg:squarederror',
    eval_metric = 'mae',
    subsample = 0.5,
    max_depth = opt$max_depth,
    max_bin = opt$max_bin,
    tree_method = 'gpu_hist')
} else{
  param <- list(
    objective = 'reg:squarederror',
    eval_metric = 'mae',
    subsample = 0.5,
    nthread = opt$cpu,
    max_depth=opt$max_depth,
    max_bin = opt$max_bin,
    tree_method = 'hist')
}

res = brentlabModelPerfTesting::perf_test_xgboost(
  split_data$train,
  split_data$test,
  param,
  opt$rounds,
  verbose = ifelse(opt$verbose, 1, 0))

if(opt$out){
  write_csv(res, paste0(paste(opt$prefix, "result", sep='_'), '.csv'))
}

print(res)
