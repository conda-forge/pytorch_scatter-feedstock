#!/bin/bash
set -ex

if [[ "$cuda_compiler_version" == "None" ]]; then
  export FORCE_CUDA=0
else
  export TORCH_CUDA_ARCH_LIST="${CF_TORCH_CUDA_ARCH_LIST}"
  export FORCE_CUDA=1
  # create a compiler shim because build checks whether $CC exists,
  # so we cannot pass flags in that variable; cannot use regular
  # compiler activation because nvcc doesn't understand most of the
  # flags, but we need to pass our main include directory at least.
  cat > $RECIPE_DIR/gcc_shim <<"EOF"
#!/bin/sh
exec $GCC -I$PREFIX/include "$@"
EOF
  chmod +x $RECIPE_DIR/gcc_shim
  export CC="$RECIPE_DIR/gcc_shim"
fi

# see https://github.com/conda-forge/torchvision-feedstock/pull/125#discussion_r2480080905
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" == "1" ]]; then
  # remove build prefix headers that conflict with cross compilation
  rm -rf "${BUILD_PREFIX}"/venv/lib/python3.*/site-packages/torch/include/torch/csrc/api/include/
fi

${PYTHON} -m pip install . -vv
