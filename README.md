RPyGeo
================

RPyGeo
------

RPyGeo is a package providing access to ArcGIS geoprocessing tools in R. It archives this by building an interface between R and the ArcPy Python side-package via the [Reticulate](https://rstudio.github.io/reticulate/articles/introduction.html) package.

RPyGeo is not just a wrapper package for ArcPy. It aims to create an environment, in which the user can perform ArcGIS and R functions on the same dataset in a contiguous workflow. It should not be necessary to touch Python or ArcGIS.

Installation
------------

You can get the latest RPyGeo version with dependencies from Github:

``` r
devtools::install_github("r-spatial/RSAGA", dependencies = TRUE, force = TRUE)
```

In order to use RPyGeo you need to install ArcMap or ArcGIS Pro. ArcPy is included in a full ArcGIS installation.

ArcPy
-----

ArcPy is a Python side-package that provides the user with Python access to almost any geoprocessing tools in ArcGIS. ArcPy is organized into modules, which are Python files with functions and classes. The ArcPy main module has several hundred functions and classes. It is supported by various modules like the `data access` module or extensions like the `spatial analysis` extension, which increase the number of functions and classes further.

The ArcPy functions are essentially wrapper for the ArcGIS geoprocessing tools and other scripting tasks.
The ArcPy classes are blueprints for any kind of object in ArcPy. For example, `Point` and `Raster` are classes to describe geographic data. ArcPy classes are also used to set geoprocessing environment settings (e.g. `workspace` or `extent`).

Tutorial
--------

In this tutorial we use geographic data from the `spData` package and streamline the workflow with the `%>%` operator from the `dpylr` package. The `elev` and `nz` dataset are used to demonstrate raster and vector file operations.

``` r
writeRaster(elev, "C:/workspace/elev.tif")
st_write(nz, "C:/workspace/nz.shp")
```

We write the geographic data`elev` and `nz` to the workspace directory.

### Load ArcPy module and build environment

First you have to initialize the ArcPy Python site package in R. You can also set environment settings such as `overwrite`, `extension` and `workspace`. It is not necessary to set the `path` parameter if Python is installed in the default location.

The workspace can be a directory or file geodatabase. If you work with large raster files we advise you to use a directory, because it takes a long time to load raster datasets from a file geodatabase into the R session.

``` r
arcpy <- rpygeo_build_env(workspace = "C:/workspace/",
                        overwrite = TRUE,
                        extensions = "Spatial")
```

In this example we imported the ArcPy into the R session. It is assigned to the variable `env`. All data is read and written in the `C:/workspace/` directory and files can be overwritten. Moreover, the spatial analysis extension is activated.

A scratch workspace is automatically created inside the workspace. ArcPy stores temporary files in this directory. You can change the scratch directory with the parameter `scratch_workspace`.

### Use ArcPy functions

ArcPy functions can be accessed via the `$` operator. You can take advantage of the code completion feature of RStudio. After typing the `$` operator all functions of the ArcPy module are listed. Parameters are also autocompleted.

``` r
env$Slope_3d(in_raster = "elev.tif", out_raster = "slope.tif")
```

We created a slope raster file from the elevation raster file. Note that `slope.tif` is written to the workspace directory and is not automatically loaded into the R session.

We can use the pipe operator `%>%` to chain ArcPy function together.

``` r
arcpy$Dissolve_management(in_features = "nz.shp", 
                        out_feature_class = "nz_island.shp", 
                        dissolve_field = "Island") %>%
  arcpy$PolygonToLine_management("nz_border.shp")
```

In this example the `nz.shp` shapefile is dissolved on the `Island` field and then the polygons are converted to polylines.

<img src="https://github.com/be-marc/RPyGeo/blob/master/vignettes/nz.png?raw=true" alt="NZ Workflow." style="width:100.0%" />

### Modules and extensions

RPyGeo imports all functions and classes of the available ArcPy modules and extensions. You can access all geoprocessing tools found in the standard toolboxes with a single `$` operator. To access the functions and classes of another module, you have to use a second `$` operator to specify the module.

``` r
arcpy$sa$Slope(in_raster = "elev.tif")
```

The `Slope` function of the Spatial Analysis extension is located under `sa`.

### Help files

Help files for each ArcPy function can be accessed with the function `rpygeo_help`.

``` r
rpygeo_help(arcpy$Slope_3d)
```

The help file is displayed in the viewer pane of RStudio. If you use RPyGeo in another IDE, the help file is displayed in the default browser.

### Search for ArcPy function

If you do not know the name of the ArcPy function or class, the `rpygeo_search` function can be used. The search term can be plain text or a regular expression.

``` r
rpygeo_search(search_term = "3d", module = arcpy)
```

In this example all functions of the ArcPy main module, that contain the term `3d` in their name are returned.

If we want to search in another module we have to change the `module` parameter.

``` r
rpygeo_search(search_term = "Classify", module = arcpy$sa)
```

### Load output file into R Session

The output of an ArcPy function can be directly loaded into the R session with the `rpygeo_load` function.

``` r
arcpy$Slope_3d(in_raster = "elev.tif", out_raster = "slope.tif") %>%
  rpygeo_load() -> slope
```

The slope raster is loaded as a `raster` object into the R session.

### Save files

Some functions have no parameter to specify an output file. Instead they return an object and a temporary file is saved to the workspace. For example, the `sa$Aspect` function returns a `Raster` object and writes a temporary Arc/Info Binary Grid file to the workspace.

``` r
arcpy$sa$Aspect(in_raster("elev.tif")) %>%
  rpygeo_save("aspect.tif")
```

### Map algebra

Map algebra expressions can be used in RPyGeo with special operators. The four basic calculus functions are implemented as `%rpygeo_+%`, `%rpygeo_-%`, `%rpygeo_*%`, `%rpygeo_/%`.

``` r
ras <- arcpy$sa$Raster("elev.tif") 

ras %rpygeo_+% 2 %>%
  rpygeo_save("elev_2.tif")
```

In this example we created a raster object from the elevation raster. Then we added 2 to each pixel value. For map algebra the `rpygeo_save` function is very handy, because the output of map algebra is always a temporary file.
