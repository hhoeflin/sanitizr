# sanitizr

[![Build Status](https://travis-ci.org/hhoeflin/sanitizr.png)](https://travis-ci.org/hhoeflin/sanitizr)
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/hhoeflin/sanitizr?branch=master&svg=true)](https://ci.appveyor.com/project/hhoeflin/sanitizr)
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/sanitizr)](https://cran.r-project.org/package=sanitizr)
[![Coverage Status](https://img.shields.io/codecov/c/github/hhoeflin/sanitizr/master.svg)](https://codecov.io/github/hhoeflin/sanitizr?branch=master)

# Getting Started

The intention of the *sanitizr* package is to remove all objects from the global workspace, detach all previously attached 
environments on the search path as well unload all recently loaded namespaces and detach all loaded packages. The package
aims to recreate the state the workspace was in when it was initially loaded (i.e. all items that were present before 
it was loaded remain where they are). 

```R
cleanWorkspace()
```

# Other options

Need to fill in other ways to use it
