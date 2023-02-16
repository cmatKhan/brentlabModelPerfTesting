# Using inst/

After installing the package, all of these files are available like so:

```{r}
library(brentlabModelPerfTesting)

# fill in the name of a file (listed below) in the first argument
# of system.file

test_data = readRDS(
  system.file('<name of file>',
          package = 'brentlabModelPerfTesting'))
          
# concrete example

test_data = readRDS(
  system.file('testing_gene_data.rds',
          package = 'brentlabModelPerfTesting'))
          
# list all available flies
# note! there is more here than just the contents of `inst` -- it is actually 
# listing the directory which stores the installed version of the package 
# in your .libPath()

list.files(system.file(package = 'brentlabModelPerfTesting'))
```

All of the `.rds` files in this directory are `data.frames` (a tibble is a 
`data.frame`) -- if you read them in with `readRDS`, you'll have a `data.frame` 
in memory.

__NOTE__: our SNP matricies would be better stored and operated on if they 
were sparse matricies -- these are essentially matricies with their column 
vectors (R is column-major by default) are stored with run length encoding 
to compress the long strings of 0s. _Some_ of the modeling softwares -- 
XGBoost being one -- do accept sparse matricies as input. I have not done 
testing on this, yet.

# cpu_gpu_perf_results.rds

This is a data.frame which contains the performance results testing on both 
various numbers of CPUs and on the GPU while varying number of features, 
number of rounds, max_depth and max_bin.

# gene_data_clean.rds

A 1300 subject by 81,822 feature matrix. The first column is `ensg00000183117_19` 
and represents the expression of that gene in the 1300 subjects. The rest of 
the columns are SNP vectors -- mostly 0s, representing REF genotype at that 
SNP. A 1 represents ALT -- with names like `x1935887` (note: R doesn't like 
numeric column names since it is easy to confuse with a column index. Hence, 
a 'clean' R `data.frame` will add an `x` to numerically named columns).  

# slurm-simple.tmpl

This is a simple slurm template for use with [future.batchtools](https://future.batchtools.futureverse.org/)

# testing_gene_data.rds

A 20 x 20 subset of the first 20 columns/rows of `gene_data_clean`

# xgboost_perf_testing.R

A executable cmd line script intended to be used to performance test XGBoost 
(see the function `?brentlabModelPerfTesting::perf_test_xgboost`, 
or the [reference docs](https://cmatkhan.github.io/brentlabModelPerfTesting/reference/index.html) for details). An example of using this script in a container is in the 
[Usage section](https://cmatkhan.github.io/brentlabModelPerfTesting/articles/Usage.html) of the docs
