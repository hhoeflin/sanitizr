keep <- new.env()


.onAttach <- function(libname, pkgname) {
    snapshot(global=TRUE, search=TRUE, packages=TRUE, namespaces=TRUE)
}


##' Snapshot current configuration
##'
##' Stores which global variables currently exist, what environments or data.frames are attached to the
##' search path, which packages are loaded and which namespaces are loaded
##' @title Snapshot current configuration
##' @param global Snapshot global variables?
##' @param search Snapshot state of search path?
##' @param packages Snapshot loaded packages
##' @param namespaces Snapshot loaded namespaces?
##' @return list with the stored items; invisibly
##' @author Holger Hoefling
##' @export
##' @seealso \code{\link{get_snapshot}}, \code{\link{set_snapshot}}
snapshot <- function(global=TRUE, search=TRUE, packages=TRUE, namespaces=TRUE) {
    session_res <- sessionInfo()
    if(global) {
        keep$global <- ls(all.names=TRUE, envir=.GlobalEnv)
    }
    if(search) {
        keep$search <- base::search()
        keep$search <- setdiff(keep$search, grep("^package:", keep$search, value=TRUE))
    }
    if(packages) {
        keep$packages <- c(session_res$basePkgs, names(session_res$otherPkgs))
    }
    if(namespaces) {
        keep$namespaces <- names(session_res$loadedOnly)
    }
    return(invisible(as.list(keep)))
}


len1_logic_true <- function(x) {
    return(length(x) == 1 && is.logical(x) && x)
}

len1_logic_false <- function(x) {
    return(length(x) == 1 && is.logical(x) && !x)
}


##' Sets the saved snapshot
##'
##' Sets the saved information in the package to the contents
##' of the \code{snap} parameter
##' @title Sets the saved snapshot
##' @param snap An object structured as the return of the
##' \code{\link{snapshot}} function. It is a list with elements \code{global},
##' \code{search}, \code{packages} and \code{namespaces}. All of these are
##' character vectors.
##' @return Invisibly, the input \code{snap}.
##' @author Holger Hoefling
##' @export
##' @seealso \code{\link{get_snapshot}}, \code{\link{snapshot}}
set_snapshot <- function(snap) {
    keep$global <- snap$global
    keep$search <- snap$search
    keep$packages <- snap$packages
    keep$namespaces <- snap$namespaces
    return(invisible(snap))
}

##' Returns the current snapshotting information
##'
##' Returns the snapshot information stored in the package. It is a list
##' with items \code{global}, \code{search}, \code{packages} and \code{namespaces}.
##' All of these are
##' character vectors.
##' @title Returns the current snapshotting information
##' @return Returns the snapshot information as a list 
##' @author Holger Hoefling
##' @export 
##' @seealso \code{\link{set_snapshot}}, \code{\link{snapshot}}
get_snapshot <- function() {
    return(as.list(keep))
}
