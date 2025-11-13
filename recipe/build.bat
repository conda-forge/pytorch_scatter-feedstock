if not "%cuda_compiler_version%" == "None" (
    set TORCH_CUDA_ARCH_LIST=5.0;6.0;7.0;7.5;8.0;8.6;8.9;9.0;10.0;12.0+PTX
    set FORCE_CUDA=1
) else (
    set FORCE_CUDA=0
)

%PYTHON% -m pip install . -vv --no-deps --no-build-isolation
