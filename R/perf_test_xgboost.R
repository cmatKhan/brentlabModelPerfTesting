#' Perform time and space evaluation on xgboost models on cpu or gpu
#'
#' @description run an xgboost with time and memory usage tracking. Purpose
#'   of this is to gather simple resource metrics, namely runtime and memory
#'   usage, on a single model.
#' @note Caret, for instance, offers some speed-ups which make cross
#'   validation, eg, faster by exploiting some methods of sharing data
#'   between fold models. This means that it might be slightly faster
#'   to run 5-fold cv using caret than it is to run 5 individual
#'   models outside of caret.
#'
#' @importFrom xgboost xgb.train
#' @importFrom peakRAM peakRAM
#' @importFrom pryr mem_used
#'
#' @param train_data an xgboost xgb.dMatrix object of training data
#' @param test_data an xgboost xgb.dMatrix object of testing data
#' @param param a list object with certain parameters set. See the
#'   xgboost documentation
#' @param rounds the xgboost number of rounds. See xgboost documentation.
#'   this is the major affector of runtime
#' @param verbose set xgboost to verbosity 1 if TRUE, else 0 for no msgs.
#'   Default to FALSE
#' @return a dataframe with columns time_sec, model_ram_mb, total_mem_used_gb
#'
#' @examples
#' test_data = readRDS(
#'   system.file('testing_gene_data.rds',
#'           package = 'brentlabModelPerfTesting'))
#' # suppressWarnings only here b/c test data is too small
#' # and stratified split is turned off. In general, do not suppressWarnings
#' suppressWarnings({input_data = prep_data(test_data)})
#'
#' param <- list(
#'   objective = 'reg:squarederror',
#'   eval_metric = 'mae',
#'   subsample = 0.5,
#'   nthread = 1, # expecting to be overwritten
#'   max_depth=10, # expecting to be overwritten
#'   max_bin = 10, # expecting to be overwritten
#'   tree_method = 'hist')
#'
#' perf_test_xgboost(input_data$train, input_data$test, param, 5)
#'
#' \dontrun{
#' # using the gpu
#' test_data = readRDS(
#'   system.file('testing_gene_data.rds',
#'           package = 'brentlabModelPerfTesting'))
#' # suppressWarnings only here b/c test data is too small
#' # and stratified split is turned off. In general, do not suppressWarnings
#' suppressWarnings({input_data = prep_data(test_data)})
#'
#' # this is an example using the gpu. Note that
#' # the number of rounds has been increased so that
#' # if you're using a nvidia gpu, you could watch this run using
#' # watch -n0.1 nvidia-smi
#' param <- list(
#'   objective = 'reg:squarederror',
#'   eval_metric = 'mae',
#'   subsample = 0.5,
#'   max_depth=10, # expecting to be overwritten
#'   max_bin = 10, # expecting to be overwritten
#'   tree_method = 'gpu_hist')
#'
#' perf_test_xgboost(input_data$train, input_data$test, param, 1000)
#'}
#'
#' @export
perf_test_xgboost = function(train_data, test_data, param, rounds, verbose=FALSE){

  # start timer
  start = as.numeric(Sys.time())
  # execute model -- track peak RAM usage
  ram_info = peakRAM::peakRAM(
    xgboost::xgb.train(
      param,
      train_data,
      watchlist = list(train = train_data, test = test_data),
      verbose = ifelse(verbose, 1, 0),
      nrounds = rounds)
  )
  # end timer
  end = as.numeric(Sys.time())

  # return performance metrics
  data.frame(
    time_sec = end-start,
    model_ram_mb = ram_info$Peak_RAM_Used_MiB,
    total_mem_used_gb =
      round(as.numeric(pryr::mem_used()) / 1e9, 2)
  )
}
