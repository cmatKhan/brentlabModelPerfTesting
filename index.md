# brentlabModelPerfTesting

<!-- badges: start -->
  [![Codecov test coverage](https://codecov.io/gh/cmatKhan/brentlabModelPerfTesting/branch/main/graph/badge.svg)](https://app.codecov.io/gh/cmatKhan/brentlabModelPerfTesting?branch=main)
[![R-CMD-check](https://github.com/cmatKhan/brentlabModelPerfTesting/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/cmatKhan/brentlabModelPerfTesting/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

# Description

The goal of brentlabModelPerfTesting is to both demonstrate how to construct 
an R package, and to provide a platform to perform model resource performance, 
and eventually accuracy performance, testing on both a local computer and a 
high performance cluster.


# Dependencies

__A linux os__ or, simply use the docker/singularity image. Then the only dependency is docker/singularity.

This package depends on a precompiled version of [xgboost]() which is 
configured for both `cpu` and `gpu` execution __on linux__. Therefore, for both development 
and to install this package via `remotes::install_github`, this will likely 
only work on a linux system. It might work on mac. Definitely will not work on 
Windows.  

That said, there is a a Docker image (see [below](#dockerhub)) which will 
work on all systems.

# Install

## user

```{sh}
remotes::install_github('https://github.com/cmatKhan/brentlabModelPerfTesting')
```

## developer

```{sh}
git clone https://github.com/cmatKhan/brentlabModelPerfTesting
```

## docker and singularity

```{sh}
docker pull cmatkhan/brentlabxgboost
```

```{sh}
singularity pull docker://cmatkhan/brentlabxgboost
```
