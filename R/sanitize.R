##' Cleans the current workspace
##'
##' Removes all elements in the global environment and detaches all attached packages that are not base packages.
##' One can specify certain packages that should be kept.
##' @title Cleans the workspace
##' @param hidden Should also hidden variables starting with a dot be removed?
##' @param keep_global Which global variables to keep
##' @param keep_search Which environments to keep on the search path
##' @param keep_packages Which loaded packages to keep
##' @param keep_namespaces Which loaded namespaces to keep
##' @param verbose More comments on what is deleted, detached and unloaded
##' @return TRUE if everything succeeded, FALSE otherwise
##' @author Holger Hoefling
##' @importFrom utils sessionInfo
##' @importFrom tools package_dependencies
##' @importFrom utils installed.packages
##' @export
sanitize <- function(keep_global=keep$global, keep_search=keep$search,
                           keep_packages=keep$packages, keep_namespaces=keep$namespaces,
                           hidden=FALSE, verbose=FALSE) {
    session_res <- sessionInfo()

    ## check if the input is true or false
    ## and adjust accordingly
    if(len1_logic_true(keep_global)) {
        keep_global = character(0)
    }
    else if(len1_logic_false(keep_global)) {
        keep_global = ls(all.names=TRUE, envir=.GlobalEnv)
    }

    if(len1_logic_true(keep_search)) {
        keep_global = character(0)
    }
    else if(len1_logic_false(keep_search)) {
        keep_global = base::search()
        keep$search <- setdiff(keep$search, grep("^package:", keep$search))
    }

    if(len1_logic_true(keep_packages)) {
        keep_global = character(0)
    }
    else if(len1_logic_false(keep_packages)) {
        keep_global = c(session_res$basePkgs, names(session_res$otherPkgs))
    }

    if(len1_logic_true(keep_namespaces)) {
        keep_global = character(0)
    }
    else if(len1_logic_false(keep_namespaces)) {
        keep$namespaces <- names(session_res$loadedOnly)
    }


    ## first clean the global namespace    
    objectsToRemove <- setdiff(ls(all.names=hidden, envir=.GlobalEnv), keep_global)
    if(verbose) { cat("Removing objects: ", paste(objectsToRemove, collapse=", "))}
    rm(list=objectsToRemove, envir=.GlobalEnv)

    ## detach objects on the search path as required
    to_detach_search <- base::search()
    to_detach_search <- setdiff(to_detach_search, c(grep("^package:", to_detach_search, value=TRUE), keep_search))
    for(i in seq_along(to_detach_search)) {
        if(verbose) { cat("Detaching ", to_detach_search[i], "\n")}
        detach(to_detach_search[i], character.only=TRUE)
    }

    ## now detach the attached packages
    inst_pkgs <- installed.packages()
    to_detach_pkgs <- setdiff(c(session_res$basePkgs, names(session_res$otherPkgs)), keep_packages)
    attached_order <- order_pkgs(to_detach_pkgs, which=c("Depends", "LinkingTo"), inst_pkgs=inst_pkgs)
    for(i in rev(seq_along(attached_order$pkg))) {
        if(verbose) { cat("Detaching package ", attached_order$pkg[i], "\n")}
        detach(paste0("package:", attached_order$pkg[i]), character.only=TRUE)
    }

    ## now unload the namespaces
    to_unload_ns <- setdiff(c(to_detach_pkgs, names(session_res$loadedOnly)), keep_namespaces)
    loaded_order <- order_pkgs(to_unload_ns, which=c("Depends", "Imports", "LinkingTo"), inst_pkgs=inst_pkgs)
    for(i in rev(seq_along(loaded_order$pkg))) {
        if(verbose) { cat("Unloading namespace ", loaded_order$pkg[i], "\n")}
        unloadNamespace(loaded_order$pkg[i])
    }
}

##' @rdname sanitize
##' @export
cleanWorkspace <- sanitize
