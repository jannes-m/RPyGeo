# RPyGeo 1.0.0

## General

- The R-ArcMap interface was completely rewritten, and is now based on the **reticulate** package. The reticulate package accesses the arcpy Python side-package and provides all arcpy functions and classes in the R session.

## Features

**Workflow**

RPyGeo aims to create an environment, in which the user can perform ArcGIS and R functions on the same dataset in a contiguous workflow. For that, two new functions are integrated into RPyGeo.

* `rpygeo_load()` - Load the output of ArcPy functions into the R session
* `rpygeo_save()` - Save temporary files to the workspace

Moreover, ArcPy functions can be chained together with the `%>%` operator now.


**Map algebra**

To perform mathematical calculations with raster objects, four new operators are available: 

* `%rpygeo_+%` 
* `%rpygeo_-%` 
* `%rpygeo_*%`
* `%rpygeo_/%`


**Search and help**

ArcPy help files are now directly displayed in the RStudio viewer panel or the default browser with the `rpygeo_help` function. The `rpygeo_search` function searches for ArcPy functions based on plain text or regular expressions.


**Code completion**

ArcPy functions and classes are code completed in RStudio now.


**File geodatabases**

All new functions are compatible with file geodatabases. Feature classes can be loaded directly into the R session. Raster files are exported first and then automatically loaded. 

