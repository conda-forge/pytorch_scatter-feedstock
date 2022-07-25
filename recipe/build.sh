if [[ "$cuda_compiler_version" == "None" ]]; then
  export FORCE_CUDA=0
else
  export TORCH_CUDA_ARCH_LIST="3.5;5.0"
  if [[ ${cuda_compiler_version} == 9.0* ]]; then
      export TORCH_CUDA_ARCH_LIST="$TORCH_CUDA_ARCH_LIST;6.0;7.0"
  elif [[ ${cuda_compiler_version} == 9.2* ]]; then
      export TORCH_CUDA_ARCH_LIST="$TORCH_CUDA_ARCH_LIST;6.0;6.1;7.0"
  elif [[ ${cuda_compiler_version} == 10.* ]]; then
      export TORCH_CUDA_ARCH_LIST="$TORCH_CUDA_ARCH_LIST;6.0;6.1;7.0;7.5"
  elif [[ ${cuda_compiler_version} == 11.0* ]]; then
      export TORCH_CUDA_ARCH_LIST="$TORCH_CUDA_ARCH_LIST;6.0;6.1;7.0;7.5;8.0"
  elif [[ ${cuda_compiler_version} == 11.1* ]]; then
      export TORCH_CUDA_ARCH_LIST="$TORCH_CUDA_ARCH_LIST;6.0;6.1;7.0;7.5;8.0;8.6"
  elif [[ ${cuda_compiler_version} == 11.2* ]]; then
      export TORCH_CUDA_ARCH_LIST="$TORCH_CUDA_ARCH_LIST;6.0;6.1;7.0;7.5;8.0;8.6"
  else
      echo "unsupported cuda version. edit build.sh"
      exit 1
  fi
  export TORCH_CUDA_ARCH_LIST="${TORCH_CUDA_ARCH_LIST}+PTX"
  export FORCE_CUDA=1
  export CC="$GCC"

  # 2022/07 hmaarrfk
  # Big Giant Hack for Pytorch 1.12.0
  # They limited the version in
  # https://github.com/pytorch/pytorch/blob/2ddb722bc6b166e9b32f316400e89437fe6b1ac3/torch/utils/cpp_extension.py#L51-L57=
  # But I've already patched 10.0 for compatibility with the CUDA
  # versions we support
  # Removing these lines makes their compilation check fail and emit a warning instead
  sed -i '/ (MINIMUM_GCC_VERSION,/d' ${SP_DIR}/torch/utils/cpp_extension.py
fi

${PYTHON} -m pip install . -vv
