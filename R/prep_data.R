
#' prep data for the testing functions
#'
#' @importFrom assertthat assert_that
#' @importFrom rsample initial_split training testing
#' @importFrom xgboost xgb.DMatrix
#' @importFrom dplyr select all_of
#' @import futile.logger
#'
#' @param gene_data a data.frame where the label_vector column is the response
#'   and the rest of the columns are predictors
#' @param feature_num is the number of feature_num to select from the data. must be
#'   $>=$ 1.If exceeds ncol, ncol-1 is used (1 col removed as the label).
#'   Default is to use all columns
#' @param label_vector name of the column to use as the response
#'
#' @return a list with xgboost data matrix objects, slots dtrain, dtest and wl
#'   see the xgboost docs on wl. dtrain is the trainin data to
#'
#' @examples
#'   test_data = readRDS(
#'       system.file('testing_gene_data.rds',
#'       package = 'brentlabModelPerfTesting'))
#'   # note: suppressed warnings used here b/c the test data is too
#'   # small to stratify. Typically, do not use supressWarnings.
#'   suppressWarnings({prepped_data_subset = brentlabModelPerfTesting::prep_data(test_data, 10)})
#'
#'   names(prepped_data_subset)
#'
#' @export
prep_data = function(
    gene_data,
    feature_num = Inf,
    label_vector = 'ensg00000183117_19'){

  assertthat::assert_that(is.numeric(feature_num))

  assertthat::assert_that((label_vector) %in% colnames(gene_data))

  gene_data_split <- rsample::initial_split(
    gene_data,
    prop = 0.8,
    strata = rlang::sym(label_vector)
  )

  feature_num = max(1,feature_num)

  flog.info(paste0('creating train test data with ',
            as.character(min(ncol(gene_data)-1, feature_num)),
            ' predictor variables'))

  # prepare the input data -- subset number of feature_num to
  # test effect of feature_num on runtime/performance
  train_dat = as.matrix(rsample::training(gene_data_split) %>%
                          dplyr::select(-all_of(label_vector)) %>%
                          .[,1:min(ncol(gene_data)-1, feature_num)])

  test_dat = as.matrix(rsample::testing(gene_data_split) %>%
                         dplyr::select(-all_of(label_vector))) %>%
    .[,1:min(ncol(gene_data_split)-1,feature_num)]

  # common for all test iterations -- not testing effect of number of samples
  train_labels = training(gene_data_split)[[label_vector]]

  test_labels = testing(gene_data_split)[[label_vector]]

  # return data for xgboost input
  list(
    train = xgboost::xgb.DMatrix(train_dat, label = train_labels),
    test = xgboost::xgb.DMatrix(test_dat, label=test_labels)
  )
}
