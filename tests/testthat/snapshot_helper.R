normalize_snapshot <- function(x) {
    x <- lapply(x, function(x) return(sort(unique(x))))
    return(x)
}

compare_snapshots <- function(x, y) {
    x <- normalize_snapshot(x)
    y <- normalize_snapshot(y)

    expect_equal(x, y)
}
    
