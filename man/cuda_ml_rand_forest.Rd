% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rand_forest.R
\name{cuda_ml_rand_forest}
\alias{cuda_ml_rand_forest}
\alias{cuda_ml_rand_forest.default}
\alias{cuda_ml_rand_forest.data.frame}
\alias{cuda_ml_rand_forest.matrix}
\alias{cuda_ml_rand_forest.formula}
\alias{cuda_ml_rand_forest.recipe}
\title{Train a random forest model.}
\usage{
cuda_ml_rand_forest(x, ...)

\method{cuda_ml_rand_forest}{default}(x, ...)

\method{cuda_ml_rand_forest}{data.frame}(
  x,
  y,
  mtry = NULL,
  trees = NULL,
  min_n = 2L,
  bootstrap = TRUE,
  max_depth = 16L,
  max_leaves = Inf,
  max_predictors_per_note_split = NULL,
  n_bins = 128L,
  min_samples_leaf = 1L,
  split_criterion = NULL,
  min_impurity_decrease = 0,
  max_batch_size = 128L,
  n_streams = 8L,
  cuML_log_level = c("off", "critical", "error", "warn", "info", "debug", "trace"),
  ...
)

\method{cuda_ml_rand_forest}{matrix}(
  x,
  y,
  mtry = NULL,
  trees = NULL,
  min_n = 2L,
  bootstrap = TRUE,
  max_depth = 16L,
  max_leaves = Inf,
  max_predictors_per_note_split = NULL,
  n_bins = 128L,
  min_samples_leaf = 1L,
  split_criterion = NULL,
  min_impurity_decrease = 0,
  max_batch_size = 128L,
  n_streams = 8L,
  cuML_log_level = c("off", "critical", "error", "warn", "info", "debug", "trace"),
  ...
)

\method{cuda_ml_rand_forest}{formula}(
  formula,
  data,
  mtry = NULL,
  trees = NULL,
  min_n = 2L,
  bootstrap = TRUE,
  max_depth = 16L,
  max_leaves = Inf,
  max_predictors_per_note_split = NULL,
  n_bins = 128L,
  min_samples_leaf = 1L,
  split_criterion = NULL,
  min_impurity_decrease = 0,
  max_batch_size = 128L,
  n_streams = 8L,
  cuML_log_level = c("off", "critical", "error", "warn", "info", "debug", "trace"),
  ...
)

\method{cuda_ml_rand_forest}{recipe}(
  x,
  data,
  mtry = NULL,
  trees = NULL,
  min_n = 2L,
  bootstrap = TRUE,
  max_depth = 16L,
  max_leaves = Inf,
  max_predictors_per_note_split = NULL,
  n_bins = 128L,
  min_samples_leaf = 1L,
  split_criterion = NULL,
  min_impurity_decrease = 0,
  max_batch_size = 128L,
  n_streams = 8L,
  cuML_log_level = c("off", "critical", "error", "warn", "info", "debug", "trace"),
  ...
)
}
\arguments{
\item{x}{Depending on the context:

  * A __data frame__ of predictors.
  * A __matrix__ of predictors.
  * A __recipe__ specifying a set of preprocessing steps
  * created from [recipes::recipe()].
  * A __formula__ specifying the predictors and the outcome.}

\item{...}{Optional arguments; currently unused.}

\item{y}{A numeric vector (for regression) or factor (for classification) of
desired responses.}

\item{mtry}{The number of predictors that will be randomly sampled at each
split when creating the tree models. Default: the square root of the total
number of predictors.}

\item{trees}{An integer for the number of trees contained in the ensemble.
Default: 100L.}

\item{min_n}{An integer for the minimum number of data points in a node that
are required for the node to be split further. Default: 2L.}

\item{bootstrap}{Whether to perform bootstrap.
If TRUE, each tree in the forest is built on a bootstrapped sample with
replacement.
If FALSE, the whole dataset is used to build each tree.}

\item{max_depth}{Maximum tree depth. Default: 16L.}

\item{max_leaves}{Maximum leaf nodes per tree. Soft constraint. Default: Inf
(unlimited).}

\item{max_predictors_per_note_split}{Number of predictor to consider per node
split. Default: square root of the total number predictors.}

\item{n_bins}{Number of bins used by the split algorithm. Default: 128L.}

\item{min_samples_leaf}{The minimum number of data points in each leaf node.
Default: 1L.}

\item{split_criterion}{The criterion used to split nodes, can be "gini" or
"entropy" for classifications, and "mse" or "mae" for regressions.
Default: "gini" for classification; "mse" for regression.}

\item{min_impurity_decrease}{Minimum decrease in impurity requried for node
to be spilt. Default: 0.}

\item{max_batch_size}{Maximum number of nodes that can be processed in a
given batch. Default: 128L.}

\item{n_streams}{Number of CUDA streams to use for building trees.
Default: 8L.}

\item{cuML_log_level}{Log level within cuML library functions. Must be one of
{"off", "critical", "error", "warn", "info", "debug", "trace"}.
Default: off.}

\item{formula}{A formula specifying the outcome terms on the left-hand side,
and the predictor terms on the right-hand side.}

\item{data}{When a __recipe__ or __formula__ is used, \code{data} is
specified as a  __data frame__ containing the predictors and (if
applicable) the outcome.}
}
\value{
A random forest classifier / regressor object that can be used with
  the 'predict' S3 generic to make predictions on new data points.
}
\description{
Train a random forest model for classification or regression tasks.
}
\examples{
library(cuda.ml)

# Classification

model <- cuda_ml_rand_forest(
  formula = Species ~ .,
  data = iris,
  trees = 100
)

predictions <- predict(model, iris[names(iris) != "Species"])

# Regression

model <- cuda_ml_rand_forest(
  formula = mpg ~ .,
  data = mtcars,
  trees = 100
)

predictions <- predict(model, mtcars[names(mtcars) != "mpg"])
}
