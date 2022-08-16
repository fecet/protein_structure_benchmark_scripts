import jax
import tensorflow as tf
import torch

print(f'jax is using {jax.default_backend()}')
print(f"tensorflow is using {tf.config.list_physical_devices('GPU')}")

# check cuda available by `jax.default_backend()`
# python3 -c "import tensorflow as tf; "
print(f"torch is using {torch.utils.cpp_extension.CUDA_HOME}")
