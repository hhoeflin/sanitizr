
##' Order packages by their dependencies
##'
##' Given packages, the function orders them so that every package
##' only depends on other packages with lower order number. This way,
##' they can safely be removed from the highest value down.
##' @title Order packages by their dependencies
##' @param pkgs The packages to order
##' @param inst_pkgs a database of installed packages as returned by \code{installed.packages}.
##' @param which Which type of dependencies should be taken into account. a character vector listing the types of dependencies, a
##' subset of ‘c("Depends", "Imports", "LinkingTo", "Suggests",
##' "Enhances")’.  Character string ‘"all"’ is shorthand for that
##' vector, character string ‘"most"’ for the same vector without
##' ‘"Enhances"’.
##' @param inst_pkgs The installed packages as returned by \code{installed.packages}
##' @return A data frame with the column 'pkg' giving the name of the package and 'level', by which the dataframe is sorted from lowest to highest.
##' @author Holger Hoefling
##' @importFrom tools package_dependencies
order_pkgs <- function(pkgs, inst_pkgs, which = c("Depends", "Imports", "LinkingTo")) {
    pkgs_ordered <- data.frame(pkg=character(0), level=numeric(0), stringsAsFactors = FALSE)

    if(length(pkgs) == 0) {
        return(pkgs_ordered)
    }
    

    pkg_deps <- package_dependencies(packages=pkgs, db=inst_pkgs, which=which)

    ## only packages in the list are considered as dependencies for this exercise
    pkg_deps <- lapply(pkg_deps, function(x, sel) {return(intersect(x, sel))}, sel=names(pkg_deps))
    
    ## so now we need to bring the list of pkg dependencies into an order so that each pkg is only
    ## dependent on other pkgs with lower order
    cur_level <- 1
    while(length(pkg_deps) > 0 && cur_level < 1000) { # last one is to prevent infinite loops
        num_deps <- unlist(lapply(pkg_deps, length))
        new_selected <- names(pkg_deps)[num_deps == 0]

        pkgs_ordered <- rbind(pkgs_ordered, data.frame(pkg=new_selected, level=cur_level, stringsAsFactors=FALSE))

        pkg_deps <- lapply(pkg_deps, function(x, sel) {return(setdiff(x, sel))}, sel=new_selected)
        pkg_deps <- pkg_deps[num_deps > 0]
        
        cur_level <- cur_level + 1
    }

    if(length(pkg_deps) > 0) {
        stop("There was a problem, the pkgs could not be ordered")
    }

    return(pkgs_ordered)
    print(pkgs_ordered)
}
