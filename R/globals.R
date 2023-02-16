# in order to eliminate notes from the R CMD check,
# regarding the use of dplyr variables, place those
# variables here. Note that this is messy and probably
# should be avoided in general -- best to re-write
# code to avoid having to do this
# . is used in prep_data() in a pipe
utils::globalVariables(c("."))
