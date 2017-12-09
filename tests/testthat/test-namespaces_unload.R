context("Namespaces")

source("snapshot_helper.R")

test_sanitize_single_pkg <- function(pkgname) {
    snap_before <- snapshot()
    skip_if_not_installed(pkgname)
    library(pkgname, character.only=TRUE)
    sanitize()
    snap_after <- snapshot()
    compare_snapshots(snap_before, snap_after)
}

test_that("load_unload single pkgs", {
    test_sanitize_single_pkg("grid")
    test_sanitize_single_pkg("ggplot2")
    test_sanitize_single_pkg("dplyr")
    test_sanitize_single_pkg("plyr")
})
