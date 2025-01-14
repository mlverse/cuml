% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/elastic_net.R
\name{cuda_ml_elastic_net}
\alias{cuda_ml_elastic_net}
\alias{cuda_ml_elastic_net.default}
\alias{cuda_ml_elastic_net.data.frame}
\alias{cuda_ml_elastic_net.matrix}
\alias{cuda_ml_elastic_net.formula}
\alias{cuda_ml_elastic_net.recipe}
\title{Train a linear model using elastic regression.}
\usage{
cuda_ml_elastic_net(x, ...)

\method{cuda_ml_elastic_net}{default}(x, ...)

\method{cuda_ml_elastic_net}{data.frame}(
  x,
  y,
  alpha = 1,
  l1_ratio = 0.5,
  max_iter = 1000L,
  tol = 0.001,
  fit_intercept = TRUE,
  normalize_input = FALSE,
  selection = c("cyclic", "random"),
  ...
)

\method{cuda_ml_elastic_net}{matrix}(
  x,
  y,
  alpha = 1,
  l1_ratio = 0.5,
  max_iter = 1000L,
  tol = 0.001,
  fit_intercept = TRUE,
  normalize_input = FALSE,
  selection = c("cyclic", "random"),
  ...
)

\method{cuda_ml_elastic_net}{formula}(
  formula,
  data,
  alpha = 1,
  l1_ratio = 0.5,
  max_iter = 1000L,
  tol = 0.001,
  fit_intercept = TRUE,
  normalize_input = FALSE,
  selection = c("cyclic", "random"),
  ...
)

\method{cuda_ml_elastic_net}{recipe}(
  x,
  data,
  alpha = 1,
  l1_ratio = 0.5,
  max_iter = 1000L,
  tol = 0.001,
  fit_intercept = TRUE,
  normalize_input = FALSE,
  selection = c("cyclic", "random"),
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

\item{alpha}{Multiplier of the penalty term (i.e., the result would become
and Ordinary Least Square model if \code{alpha} were set to 0). Default: 1.
For numerical reasons, running elastic regression with \code{alpha} set to
0 is not advised. For the \code{alpha}-equals-to-0 scenario, one should use
\code{cuda_ml_ols} to train an OLS model instead.
Default: 1.}

\item{l1_ratio}{The ElasticNet mixing parameter, with 0 <= l1_ratio <= 1.
For l1_ratio = 0 the penalty is an L2 penalty. For l1_ratio = 1 it is an L1
penalty.
For 0 < l1_ratio < 1, the penalty is a combination of L1 and L2.
The penalty term is computed using the following formula:
  penalty = \code{alpha} * \code{l1_ratio} * ||w||_1 +
            0.5 * \code{alpha} * (1 - \code{l1_ratio}) * ||w||^2_2
where ||w||_1 is the L1 norm of the coefficients, and ||w||_2 is the L2
norm of the coefficients.}

\item{max_iter}{The maximum number of coordinate descent iterations.
Default: 1000L.}

\item{tol}{Stop the coordinate descent when the duality gap is below this
threshold. Default: 1e-3.}

\item{fit_intercept}{If TRUE, then the model tries to correct for the global
mean of the response variable. If FALSE, then the model expects data to be
centered. Default: TRUE.}

\item{normalize_input}{Ignored when \code{fit_intercept} is FALSE. If TRUE,
then the predictors will be normalized to have a L2 norm of 1.
Default: FALSE.}

\item{selection}{If "random", then instead of updating coefficients in cyclic
order, a random coefficient is updated in each iteration. Default: "cyclic".}

\item{formula}{A formula specifying the outcome terms on the left-hand side,
and the predictor terms on the right-hand side.}

\item{data}{When a __recipe__ or __formula__ is used, \code{data} is
specified as a  __data frame__ containing the predictors and (if
applicable) the outcome.}
}
\value{
An elastic net regressor that can be used with the 'predict' S3
  generic to make predictions on new data points.
}
\description{
Train a linear model with combined L1 and L2 priors as the regularizer.
}
\examples{

library(cuda.ml)

model <- cuda_ml_elastic_net(
  formula = mpg ~ ., data = mtcars, alpha = 1e-3, l1_ratio = 0.6
)
cuda_ml_predictions <- predict(model, mtcars)

# predictions will be comparable to those from a `glmnet` model with `lambda`
# set to 1e-3 and `alpha` set to 0.6
# (in `glmnet`, `lambda` is the weight of the penalty term, and `alpha` is
#  the elastic mixing parameter between L1 and L2 penalties.

library(glmnet)

glmnet_model <- glmnet(
  x = as.matrix(mtcars[names(mtcars) != "mpg"]), y = mtcars$mpg,
  alpha = 0.6, lambda = 1e-3, nlambda = 1, standardize = FALSE
)

glm_predictions <- predict(
  glmnet_model, as.matrix(mtcars[names(mtcars) != "mpg"]),
  s = 0
)

print(
  all.equal(
    as.numeric(glm_predictions),
    cuda_ml_predictions$.pred,
    tolerance = 1e-2
  )
)
}
