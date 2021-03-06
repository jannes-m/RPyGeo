#' @title RPyGeo: ArcGIS Geoprocessing in R via Python
#'
#' @description Provide access to (virtually any) ArcGIS geoprocessing tool from
#'   within R by running Python
#'   geoprocessing without writing Python code or touching ArcGIS.
#' @details The package utilizes the ArcPy Python site-package or the ArcGIS API
#'   in order to access ArcGIS functionality. The function
#'   \code{\link{rpygeo_build_env}} can be applied to generate an ArcPy or arcgis
#'   object.
#'
#' @examples
#'
#' # load the ArcPy module related to ArcGIS Pro (and save it as a R
#' # object called "arcpy_m") in R and also set the overwrite parameter
#' # to FALSE and add some extensions. Note that we do not have to set the path
#' # because the Python version is located in the default location
#' # (C:/Program Files/ArcGIS/Pro/bin/Python/envs/arcgispro-py3/)in this example.
#' \dontrun{arcpy <- rpygeo_build_env(overwrite = TRUE,
#'                                      extensions = c("3d", "Spatial", "na"),
#'                                      pro = TRUE)}
#' # Suppose we want to calculate the slope of a Digtial Elevation Model.
#' # It is possible to get the description of any ArcPy function as a R list:
#' \dontrun{py_function_docs("arcpy$Slope_3d")}
#' # Now we can run our computation:
#' \dontrun{arcpy$Slope_3d(arcpy$Slope_3d(in_raster = "dem.tif", out_raster = "slope.tif")}
#'
"_PACKAGE"
