#include "cuda_utils.h"

#include <Rcpp.h>

#if HAS_CUML

namespace cuml4r {

int currentDevice() {
  int dev_id;
  CUDA_RT_CALL(cudaGetDevice(&dev_id));
  return dev_id;
}

}  // namespace cuml4r

#else

#include "warn_cuml_missing.h"

#endif
