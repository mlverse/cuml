% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cuml_utils.R
\name{cuML_minor_version}
\alias{cuML_minor_version}
\title{Get the minor version of the RAPIDS cuML shared library {cuda.ml} was linked
to.}
\usage{
cuML_minor_version()
}
\value{
The minor version of the RAPIDS cuML shared library {cuda.ml} was
linked to in a character vector, or \code{NA_character_} if {cuda.ml} was not
linked to any version of RAPIDS cuML.
}
\description{
Get the minor version of the RAPIDS cuML shared library {cuda.ml} was linked
to.
}
\examples{

library(cuda.ml)

print(cuML_minor_version())
}
