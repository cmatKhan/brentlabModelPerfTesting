test_that("prepare_data", {
  test_data = readRDS(
    system.file('testing_gene_data.rds',
                package = 'brentlabModelPerfTesting'))

  suppressWarnings({prepped_data_subset = prep_data(test_data, 10)})

  expect_equal(dim(prepped_data_subset$train), c(20*.8,10))

  suppressWarnings({prepped_data_default = prep_data(test_data)})

  expect_equal(dim(prepped_data_default$train), c(20*.8,19))
})
