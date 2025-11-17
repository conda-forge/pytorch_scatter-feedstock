if [[ "$cuda_compiler_version" == "None" ]]; then
  export FORCE_CUDA=0
else
  if [[ ${cuda_compiler_version} == 9.0* ]]; then
    export TORCH_CUDA_ARCH_LIST="3.5;5.0;6.0;7.0+PTX"
  elif [[ ${cuda_compiler_version} == 9.2* ]]; then
    export TORCH_CUDA_ARCH_LIST="3.5;5.0;6.0;6.1;7.0+PTX"
  elif [[ ${cuda_compiler_version} == 10.* ]]; then
    export TORCH_CUDA_ARCH_LIST="3.5;5.0;6.0;6.1;7.0;7.5+PTX"
  elif [[ ${cuda_compiler_version} == 11.0* ]]; then
    export TORCH_CUDA_ARCH_LIST="3.5;5.0;6.0;6.1;7.0;7.5;8.0+PTX"
  elif [[ ${cuda_compiler_version} == 11.1 ]]; then
    export TORCH_CUDA_ARCH_LIST="3.5;5.0;6.0;6.1;7.0;7.5;8.0;8.6+PTX"
  elif [[ ${cuda_compiler_version} == 11.2 ]]; then
    export TORCH_CUDA_ARCH_LIST="3.5;5.0;6.0;6.1;7.0;7.5;8.0;8.6+PTX"
  elif [[ ${cuda_compiler_version} == 11.8 ]]; then
    export TORCH_CUDA_ARCH_LIST="3.5;5.0;6.0;6.1;7.0;7.5;8.0;8.6;8.9+PTX"
  elif [[ ${cuda_compiler_version} == 12.0 ]]; then
    export TORCH_CUDA_ARCH_LIST="5.0;6.0;6.1;7.0;7.5;8.0;8.6;8.9;9.0+PTX"
  elif [[ ${cuda_compiler_version} == 12.6 ]]; then
    export TORCH_CUDA_ARCH_LIST="5.0;6.0;6.1;7.0;7.5;8.0;8.6;8.9;9.0+PTX"
  elif [[ ${cuda_compiler_version} == 12.9 ]]; then
    export TORCH_CUDA_ARCH_LIST="5.0;6.0;7.0;7.5;8.0;8.6;9.0;10.0;12.0+PTX"
  else
    echo "unsupported cuda version. edit build_pytorch.sh"
    exit 1
  fi
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
