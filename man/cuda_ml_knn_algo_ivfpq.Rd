% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/knn.R
\name{cuda_ml_knn_algo_ivfpq}
\alias{cuda_ml_knn_algo_ivfpq}
\title{Build a specification for the "ivfpq" KNN query algorithm.}
\usage{
cuda_ml_knn_algo_ivfpq(
  nlist,
  nprobe,
  m,
  n_bits,
  use_precomputed_tables = FALSE
)
}
\arguments{
\item{nlist}{Number of cells to partition dataset into.}

\item{nprobe}{At query time, the number of cells used for approximate nearest
neighbor search.}

\item{m}{Number of subquantizers.}

\item{n_bits}{Bits allocated per subquantizer.}

\item{use_precomputed_tables}{Whether to use precomputed tables.}
}
\value{
An object encapsulating all required parameters of the "ivfpq" KNN
  query algorithm.
}
\description{
Build a specification of the inverted-file-product-quantization KNN query
algorithm, with all required parameters specified explicitly.
}
