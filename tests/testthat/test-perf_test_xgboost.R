test_that("test_perf_test_xgboost", {

  test_data = readRDS(
    system.file('testing_gene_data.rds',
                package = 'brentlabModelPerfTesting'))

  suppressWarnings({input_data = prep_data(test_data)})

  param <- list(
    objective = 'reg:squarederror',
    eval_metric = 'mae',
    subsample = 0.5,
    nthread = 1, # expecting to be overwritten
    max_depth=10, # expecting to be overwritten
    max_bin = 10, # expecting to be overwritten
    tree_method = 'hist')

  actual = perf_test_xgboost(input_data$train, input_data$test, param, 5)

  expect_equal(dim(actual), c(1,3))
})
