% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ols.R
\name{cuda_ml_ols}
\alias{cuda_ml_ols}
\alias{cuda_ml_ols.default}
\alias{cuda_ml_ols.data.frame}
\alias{cuda_ml_ols.matrix}
\alias{cuda_ml_ols.formula}
\alias{cuda_ml_ols.recipe}
\title{Train a OLS model.}
\usage{
cuda_ml_ols(x, ...)

\method{cuda_ml_ols}{default}(x, ...)

\method{cuda_ml_ols}{data.frame}(
  x,
  y,
  method = c("svd", "eig", "qr"),
  fit_intercept = TRUE,
  normalize_input = FALSE,
  ...
)

\method{cuda_ml_ols}{matrix}(
  x,
  y,
  method = c("svd", "eig", "qr"),
  fit_intercept = TRUE,
  normalize_input = FALSE,
  ...
)

\method{cuda_ml_ols}{formula}(
  formula,
  data,
  method = c("svd", "eig", "qr"),
  fit_intercept = TRUE,
  normalize_input = FALSE,
  ...
)

\method{cuda_ml_ols}{recipe}(
  x,
  data,
  method = c("svd", "eig", "qr"),
  fit_intercept = TRUE,
  normalize_input = FALSE,
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

\item{method}{Must be one of {"svd", "eig", "qr"}.

  - "svd": compute SVD decomposition using Jacobi iterations.
  - "eig": use an eigendecomposition of the covariance matrix.
  - "qr": use the QR decomposition algorithm and solve `Rx = Q^T y`.

  If the number of features is larger than the sample size, then the
  "svd" algorithm will be force-selected because it is the only
   algorithm that can support this type of scenario.

  Default: "svd".}

\item{fit_intercept}{If TRUE, then the model tries to correct for the global
mean of the response variable. If FALSE, then the model expects data to be
centered. Default: TRUE.}

\item{normalize_input}{Ignored when \code{fit_intercept} is FALSE. If TRUE,
then the predictors will be normalized to have a L2 norm of 1.
Default: FALSE.}

\item{formula}{A formula specifying the outcome terms on the left-hand side,
and the predictor terms on the right-hand side.}

\item{data}{When a __recipe__ or __formula__ is used, \code{data} is
specified as a  __data frame__ containing the predictors and (if
applicable) the outcome.}
}
\value{
A OLS regressor that can be used with the 'predict' S3 generic to
  make predictions on new data points.
}
\description{
Train an Ordinary Least Square (OLS) model for regression tasks.
}
\examples{

library(cuda.ml)

model <- cuda_ml_ols(formula = mpg ~ ., data = mtcars, method = "qr")
predictions <- predict(model, mtcars[names(mtcars) != "mpg"])

# predictions will be comparable to those from a `stats::lm` model
lm_model <- stats::lm(formula = mpg ~ ., data = mtcars, method = "qr")
lm_predictions <- predict(lm_model, mtcars[names(mtcars) != "mpg"])

print(
  all.equal(
    as.numeric(lm_predictions),
    predictions$.pred,
    tolerance = 1e-3
  )
)
}
