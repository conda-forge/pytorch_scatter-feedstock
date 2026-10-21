@ echo on

if not "%cuda_compiler_version%" == "None" (
    set FORCE_CUDA=1
    set "TORCH_CUDA_ARCH_LIST=%CF_TORCH_CUDA_ARCH_LIST%"
) else (
    set FORCE_CUDA=0
)

REM Patch PyTorch header to bypass Windows CUDA guard

set "FILE=%PREFIX%\Library\include\torch\csrc\dynamo\compiled_autograd.h"

powershell -NoProfile -ExecutionPolicy Bypass -Command "(Get-Content '%FILE%') -replace '^\s*#if defined\(_WIN32\) && \(defined\(USE_CUDA\) \|\| defined\(USE_ROCM\)\)\s*$', '#if 1' | Set-Content -Encoding ASCII '%FILE%'"
if errorlevel 1 exit 1

%PYTHON% -m pip install . -vv --no-deps --no-build-isolation
