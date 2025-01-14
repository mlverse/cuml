% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/model.R
\name{cuda_ml_unserialize}
\alias{cuda_ml_unserialize}
\alias{cuda_ml_unserialise}
\title{Unserialize a CuML model state}
\usage{
cuda_ml_unserialize(connection, ...)

cuda_ml_unserialise(connection, ...)
}
\arguments{
\item{connection}{An open connection or a raw vector.}

\item{...}{Additional arguments to \code{base::unserialize()}.}
}
\value{
A unserialized CuML model.
}
\description{
Unserialize a CuML model state into a CuML model object.
}
\seealso{
\code{\link[base]{unserialize}}
}
