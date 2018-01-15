#' @title  Initialize Arcpy module in R
#'
#' @description Initialises the Python "arcpy" site-package in R with the help
#'   of reticulate
#'
#'
#' @param path Root path to the Python version which contains "arcpy". If left empty, the function
#'   looks for `python.exe` in the most likely location (C:\Python27\)
#' @return Returns arcpy module in R
#' @author Fabian Polakowski
#' @export
#'
#'

#TODO add parameters such as overwrite or cellsize or extensions to build_env or to geoprocessor function?

rpygeo_build_env = function (path = NULL)
  {

  # set path
  # TODO check if it is really a arcpy python
  if (is.null(path)) {
    # TODO search for path
    # search python.exe in most common path
    dirs <- list.files(path = "C:/Python27", pattern = "python.exe", recursive = TRUE, full.names = TRUE)

    if (length(dirs) == 1) {
      path <- dirs
    }

    if (length(dirs) > 1) {
      stop("multiple paths found, define ArcGIS Path\n")
    }

    if (length(dirs) < 1){
      stop("No python function found in 'C:/Python27' - please define python path\n")
    }

  }
  if (!is.null(path)) {
    path == path
    #TODO check if path is correct
  }

  # init
  use_python(python = path, required = TRUE)
  return(import("arcpy"))

}





rpygeo_geoprocessor(

  fun,
  args = NULL,
  env = NULL,
  extensions = NULL

)
{
  #

  # process
  # run process with eval and paste fun and args strings together
  #eval(parse(text = paste0("arcpy$Slope_3d('C:/Users/f/Google Drive/MA/thesis/R_analysis/data/raster_kw.tif', 'C:/Users/f/Google Drive/MA/thesis/R_analysis/data/raster_kw_r.tif')")))
}






