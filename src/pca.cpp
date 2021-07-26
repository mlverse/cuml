#if HAS_CUML

#include "async_utils.h"
#include "cuda_utils.h"
#include "handle_utils.h"
#include "matrix_utils.h"
#include "pinned_host_vector.h"
#include "preprocessor.h"
#include "stream_allocator.h"

#include <thrust/async/copy.h>
#include <thrust/device_vector.h>
#include <cuml/decomposition/pca.hpp>

#include <memory>
#include <vector>

#else

#include "warn_cuml_missing.h"

#endif

#include <Rcpp.h>

// [[Rcpp::export(".pca_fit_transform")]]
Rcpp::List pca_fit_transform(Rcpp::NumericMatrix const& x, double const tol,
                             int const n_iters, bool const verbose,
                             int const n_components, int const algo,
                             bool const whiten) {
  Rcpp::List result;

#if HAS_CUML
  auto const m = cuml4r::Matrix<>(x, /*transpose=*/true);
  auto const n_rows = m.numCols;
  auto const n_cols = m.numRows;

  ML::paramsPCA params;
  params.n_rows = n_rows;
  params.n_cols = n_cols;
  params.gpu_id = cuml4r::currentDevice();
  params.tol = tol;
  params.n_iterations = n_iters;
  params.verbose = verbose;
  params.n_components = n_components;
  params.algorithm = static_cast<ML::solver>(algo);
  params.copy = true;
  params.whiten = whiten;

  auto stream_view = cuml4r::stream_allocator::getOrCreateStream();
  raft::handle_t handle;
  cuml4r::handle_utils::initializeHandle(handle, stream_view.value());

  // PCA input
  auto const& h_input = m.values;
  thrust::device_vector<double> d_input(h_input.size());
  auto CUML4R_ANONYMOUS_VARIABLE(input_h2d) = cuml4r::async_copy(
    stream_view.value(), h_input.cbegin(), h_input.cend(), d_input.begin());

  // PCA outputs
  thrust::device_vector<double> d_transformed_data(n_rows * n_components);
  thrust::device_vector<double> d_components(n_cols * n_components);
  thrust::device_vector<double> d_explained_var(n_components);
  thrust::device_vector<double> d_explained_var_ratio(n_components);
  thrust::device_vector<double> d_singular_vals(n_components);
  thrust::device_vector<double> d_mu(n_cols);
  thrust::device_vector<double> d_noise_vars(1);

  ML::pcaFitTransform(
    handle,
    /*input=*/d_input.data().get(),
    /*trans_input=*/d_transformed_data.data().get(),
    /*components=*/d_components.data().get(),
    /*explained_var=*/d_explained_var.data().get(),
    /*explained_var_ratio=*/d_explained_var_ratio.data().get(),
    /*singular_vals=*/d_singular_vals.data().get(),
    /*mu=*/d_mu.data().get(),
    /*noise_vars=*/d_noise_vars.data().get(),
    /*prms=*/params);

  cuml4r::pinned_host_vector<double> h_transformed_data(n_rows * n_components);
  cuml4r::pinned_host_vector<double> h_components(n_cols * n_components);
  cuml4r::pinned_host_vector<double> h_explained_var(n_components);
  cuml4r::pinned_host_vector<double> h_explained_var_ratio(n_components);
  cuml4r::pinned_host_vector<double> h_singular_vals(n_components);
  cuml4r::pinned_host_vector<double> h_mu(n_cols);
  cuml4r::pinned_host_vector<double> h_noise_vars(1);

  auto CUML4R_ANONYMOUS_VARIABLE(transformed_data_d2h) =
    cuml4r::async_copy(stream_view.value(), d_transformed_data.cbegin(),
                       d_transformed_data.cend(), h_transformed_data.begin());
  auto CUML4R_ANONYMOUS_VARIABLE(components_d2h) =
    cuml4r::async_copy(stream_view.value(), d_components.cbegin(),
                       d_components.cend(), h_components.begin());
  auto CUML4R_ANONYMOUS_VARIABLE(explained_var_d2h) =
    cuml4r::async_copy(stream_view.value(), d_explained_var.cbegin(),
                       d_explained_var.cend(), h_explained_var.begin());
  auto CUML4R_ANONYMOUS_VARIABLE(explained_var_ratio_d2h) = cuml4r::async_copy(
    stream_view.value(), d_explained_var_ratio.cbegin(),
    d_explained_var_ratio.cend(), h_explained_var_ratio.begin());
  auto CUML4R_ANONYMOUS_VARIABLE(singular_vals_d2h) =
    cuml4r::async_copy(stream_view.value(), d_singular_vals.cbegin(),
                       d_singular_vals.cend(), h_singular_vals.begin());
  auto CUML4R_ANONYMOUS_VARIABLE(mu_d2h) = cuml4r::async_copy(
    stream_view.value(), d_mu.cbegin(), d_mu.cend(), h_mu.begin());
  auto CUML4R_ANONYMOUS_VARIABLE(noise_vars_d2h) =
    cuml4r::async_copy(stream_view.value(), d_noise_vars.cbegin(),
                       d_noise_vars.cend(), h_noise_vars.begin());

  CUDA_RT_CALL(cudaStreamSynchronize(stream_view.value()));

  result["components"] = Rcpp::NumericMatrix(n_components, n_cols, h_components.begin());
  result["explained_variance"] =
    Rcpp::NumericVector(h_explained_var.begin(), h_explained_var.end());
  result["explained_variance_ratio"] =
    Rcpp::NumericVector(h_explained_var_ratio.begin(), h_explained_var_ratio.end());
  result["singular_values"] =
    Rcpp::NumericVector(h_singular_vals.begin(), h_singular_vals.end());
  result["mean"] = Rcpp::NumericVector(h_mu.begin(), h_mu.end());
  // NOTE: noise variance calculation appears to be unimplemented in cuML at the moment
  // result["noise_variance"] = Rcpp::NumericVector(h_noise_vars.begin(), h_noise_vars.end());
  result["transformed_data"] = Rcpp::NumericMatrix(n_rows, n_components, h_transformed_data.begin());
#else

#include "warn_cuml_missing.h"

#endif

  return result;
}
