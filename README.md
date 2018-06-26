# RPyGeo

RPyGeo provides access to (virtually any) ArcGIS geoprocessing tool from 
within R by running Python geoprocessing without writing Python code or touching ArcGIS.


This is the currently Work in Process version of the RPyGeo package. 
In contrast to the old version this version uses [Reticulat](https://rstudio.github.io/reticulate/articles/introduction.html)
in order to establish a connection to the ArcGIS geoprocessing methods. 
The package utilizes the ArcPy Python site-package or the ArcGIS API in order to
access ArcGIS functionality. There are two core functions of this package. The function
`rpygeo_build_env` can be applied to generate an ArcPy or arcgis
object representation in R. The function `rpygeo_geoprocessor` can be
used to carry out ArcGIS functions inside of R. The `rpygeo_geoprocessor` function
is a simple wrapper to execute a ArcGIS geoprocessing tool. However, all ArcGIS
tools can also be addressed via the object generated with `rypgeo_build_env`.
The two approaches to use ArcGIS functions are shown in the example bellow.

## Installation

You can install the old released version of RPyGeo from [CRAN](https://CRAN.R-project.org/package=RPyGeo ) with:

``` r
install.packages("RPyGeo")
```

And the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("fapola/RPyGeo")
```
## Examples
Load the ArcPy module related to ArcGIS Pro (and save it as a R
object called "arcpy_m") in R and also set the overwrite parameter
to FALSE and add some extensions. Note that we do not have to set the path
because the Python version is located in the default location
(C:/Program Files/ArcGIS/Pro/bin/Python/envs/arcgispro-py3/)in this example.

``` r
arcpy <- rpygeo_build_env(overwrite = TRUE,
                          extensions = c("3d", "Spatial"),
                          pro = TRUE)
```

We now have two possibilities to continue:

### Use the `arcpy` object directly to access ArcPy functions
Suppose we want to calculate the slope of a Digital Elevation Model.
We can get all functions provided by the `arcpy` object with:

``` r
py_list_attributes(arcpy)

```

It is possible to get the description including a explanation and a list of parameters
of any ArcPy function as a R list:

``` r
py_function_docs("arcpy$Slope_3d")

```

or as a text file:
``` r
py_help("arcpy$Slope_3d")

```

Suppose we want to add an additional extension. We can also do this with the 
help of our R representation of the arcpy object. 

``` r
arcpy$CheckOutExtension("Network")

```

We can run functions with:
``` r
arcpy$Slope_3d(in_raster = "dem.tif", out_raster = "slope.tif")

```
Caution, some functions are located in a sub-module. The same slope function e.g.
comes with the "Spatial Analyst" extension. We can find this function by
going into the sub-module `sa`.

``` r
arcpy$sa$Slope(in_raster = "dem.tif", out_raster = "slope.tif")

```

To list all functions of a sub-module we can type:

``` r
py_list_attributes(arcpya$sa)
```

### Use the provided `rpygeo_geoprocessor` function.
The `rpygeo_geoprocessor` method is a wrapper function provided by the `RPyGeo`
package to run ArcPy computations. 


``` r
rpygeo_geoprocessor(lib = arcpy, fun = "Slope_3d",
                    args = c("dem.tif", "slope.tif"))}
```
