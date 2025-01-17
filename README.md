
<!-- README.md is generated from README.Rmd. Please edit that file -->

## rpostgis <a href="https://CRAN.R-project.org/package=rpostgis"><img src="man/figures/logo.png" align="right" height="138" alt="rpostgis website" /></a>

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/rpostgis)](https://CRAN.R-project.org/package=rpostgis)
[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![Total
Downloads](https://cranlogs.r-pkg.org/badges/grand-total/rpostgis?color=blue)](https://CRAN.R-project.org/package=rpostgis)
[![Last Month
Downloads](https://cranlogs.r-pkg.org/badges/last-month/rpostgis?color=green)](https://CRAN.R-project.org/package=rpostgis)
<!-- badges: end -->

The `rpostgis` package provides an interface between R and
[`PostGIS`](https://postgis.net/)-enabled
[`PostgreSQL`](https://www.postgresql.org/) databases to transparently
transfer spatial data. Both vector (points, lines, polygons) and raster
data are supported in read and write modes. Also provides convenience
functions to execute common procedures in `PostgreSQL`/`PostGIS`.

## Installation of the released versions

You can install the latest released version from CRAN:

``` r
pak::pak("rpostgis")
```

## Installation of the development versions

A stable version of the package is always available on the project’s
[GitHub page](https://github.com/Cidree/rpostgis), and may be ahead of
the CRAN version. To install it, use the following command:

``` r
pak::pak("Cidree/rpostgis")
```

For the latest (possibly unstable) development version, use:

``` r
remotes::install_github("Cidree/rpostgis", ref = "dev")
```

## Getting started

`rpostgis` relies on a working connection provided by the `RPostgreSQL`
package to a PostgreSQL database, e.g.:

``` r
conn <- RPostgreSQL::dbConnect(
  drv      = "PostgreSQL", 
  host     = "localhost",
  dbname   = "<DB_NAME>", 
  user     = "<USER>", 
  password = "<PASSWORD>"
)
```

> Note: as of `rpostgis 1.4.3` the `RPostgres::Postgres()` driver is
> also allowed for connection objects; however, this should be
> considered experimental and is not recommended for most use cases.

Once the connection is established, the first step is to check if the
database has `PostGIS` already installed (and install it if it’s not the
case):

``` r
pgPostGIS(conn)
```

If the function returns `TRUE`, the database is ready and functional.
You can check the geometries and rasters present in the database with:

``` r
pgListGeom(conn, geog = TRUE)
pgListRast(conn)
```

To terminate the session, close and clear the connection with:

``` r
RPostgreSQL::dbDisconnect(conn)
```

## Documentation

Full documentation with the complete list of functions of the package
can be found on `rpostgis`
[homepage](http://cidree.github.io/rpostgis/).
