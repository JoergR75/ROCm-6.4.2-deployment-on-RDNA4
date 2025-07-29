import torch

print("PyTorch version:", torch.__version__)
print("ROCm version:", torch.version.hip if hasattr(torch.version, “hip”) else "Not ROCm build")
print("Is ROCm available:", torch.version.hip is not None)
print("Number of GPUs:", torch.cuda.device_count())
print("GPU Name:", torch.cuda.get_device_name(0) if torch.cuda.device_count() > 0 else "No GPU detected")

# Create two tensors and add them on the GPU
device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")

a = torch.rand(3, 3, device=device)
b = torch.rand(3, 3, device=device)
c = a + b

print("Tensor operation successful on:", device)
print(c)
