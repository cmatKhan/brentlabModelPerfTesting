
# brentlabModelPerfTesting

<!-- badges: start -->
  [![R-CMD-check](https://github.com/cmatKhan/brentlabModelPerfTesting/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/cmatKhan/brentlabModelPerfTesting/actions/workflows/R-CMD-check.yaml)
  
  [![Codecov test coverage](https://codecov.io/gh/cmatKhan/brentlabModelPerfTesting/branch/main/graph/badge.svg)](https://app.codecov.io/gh/cmatKhan/brentlabModelPerfTesting?branch=main)
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

But, to reiterate, there is a container (see [below](#docker-and-singularity)) which will 
work on all systems.

# [Read the Documentation](https://cmatkhan.github.io/brentlabModelPerfTesting/)

# Install: User

## Using R

```{sh}
remotes::install_github('https://github.com/cmatKhan/brentlabModelPerfTesting')
```

## Docker and Singularity

```{sh}
docker pull cmatkhan/brentlabxgboost
```

```{sh}
singularity pull docker://cmatkhan/brentlabxgboost
```

__Note__: you can use the image for development -- `git clone` the repo as 
described below, then use the container via `singularity shell` or the 
`docker -it` (interactive -- look up the docs, you have to start the 
container first). Personally, I prefer writing Dockerfiles and 
utilizing dockerhub, but I use singularity on both my local and the cluster 
to actually use the containers.

# Install: Developer

```{sh}
$ git clone https://github.com/cmatKhan/brentlabModelPerfTesting

$ cd brentlabModelPerfTesting

# open the project in Rstudio (ie, go to file --> open project ...), or 
# launch R on the cmd line. Make sure you're in the project directory.

# in R, restore the virtual environment. This may take some time.
> renv::restore()
```

If you don't have access to a linux machine, use the container as noted above.
