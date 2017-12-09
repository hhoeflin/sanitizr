context("sanitize")

source("snapshot_helper.R")

test_that("snapshot", {
    snap1 <- snapshot()

    ## try what happens when there are new items in .Globalenv
    assign(x="test", value=1, envir=.GlobalEnv)
    snap2 <- snapshot()
    compare_snapshots(snap2, within(snap1, global <- c(global, "test")))
    rm("test", envir=.GlobalEnv)

    ## new attach a data.frame to the search path
    attach(data.frame(a=1), name="test_frame")
    snap3 <- snapshot()
    compare_snapshots(snap3, within(snap1, search <- c(search, "test_frame")))
    detach("test_frame")

    ## load a package
    library(RColorBrewer)
    snap4 <- snapshot()
    compare_snapshots(snap4, within(snap1, packages <- c(packages, "RColorBrewer")))
    detach("package:RColorBrewer")

    ## load a namespace only
    snap5 <- snapshot()
    compare_snapshots(snap5, within(snap1, namespaces <- c(namespaces, "RColorBrewer")))

    unloadNamespace("RColorBrewer")
    snap6 <- snapshot()
    compare_snapshots(snap6, snap1)

    
})

test_that("sanitize", {
    snap1 <- snapshot()
    library(RColorBrewer)
    assign(x="test", value=1, envir=.GlobalEnv)
    attach(data.frame(a=1), name="test_frame")
    sanitize()
    snap2 <- snapshot()
    compare_snapshots(snap1, snap2)
})
