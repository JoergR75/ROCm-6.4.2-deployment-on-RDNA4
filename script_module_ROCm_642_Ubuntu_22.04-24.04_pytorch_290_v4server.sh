#!/bin/bash
# ROCm 6.4.2 + OCL 2.x + Pytorch 2.9.0 + Transformers Setup for Ubuntu 22.04.x and 24.04.x DT and Server build (! 20.04.x will not be supported anymore)
# ==========================================================================================================================================
# This script will automatically install ROCm 6.4.2 + Pytroch 2.9.0 (nightly build) for Ubuntu 22.04.x and 24.04.x automatically downloading
# the correct install script in non interactive mode.
#
# Requirements
# OS:                   Ubuntu Server 22.04.5 LTS (Jammy Jellyfish) or Ubuntu 24.04.2 LTS (Noble Numbat)
# Kernel:               tested: 5.15.0-144 (22.04) and 6.8.0-64 (24.04)
# Supported HW:         CDNA 2, CDNA 3, RDNA 3, RDNA 4
#
# Software
# ROCm(TM) Platform:    6.4.2
# Release:              https://rocm.docs.amd.com/en/latest/
# Driver:               https://repo.radeon.com/amdgpu-install/6.4.1/ubuntu/
# Pytorch:              2.9.0.dev20250720+rocm6.4
# Transformers:         4.53.3
# Tools:                git (version control system used for tracking changes in computer files)
#                       htop (monitoring - dynamic overview of running processes)
#                       ncdu (NCurses Disk Usage utility, which provides a text-based interface for viewing disk usage)
#                       cmake (CMake is an open-source, cross-platform family of tools designed to build, test, and package software)
#                       libmsgpack-dev (development package for MessagePack, a binary serialization format. MessagePack is designed to be efficient in both size and speed, making it a popular choice for data interchange in performance-sensitive applications)
#                       freeipmi-tools (read BMC version)
#                       git-lfs (is an extension to Git that helps manage large files (such as datasets, images, videos, binaries, etc.) efficiently by replacing them with lightweight text pointers in your Git repository)
#
# Author: Joerg Roskowetz
# Script process time: ~15 minutes (depending on system and internet configuration)
# Date: July 27th 2025

# global stdout method
function print () {
    printf "\033[1;36m\t$1\033[1;35m\n"; sleep 4
}

clear &&
print '\nAMD ROCm 6.4.2 + OCL 2.x + Pytorch 2.9.0 + Transformers installation auto-detecting installed Ubuntu (22.04.x or 24.04.x) DT and Server version (! 20.04.x will not be supported by ROCm 6.4.0 onwards anymore !)\n'
print 'Ubuntu OS Update ...\n'

sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt -y upgrade

print '\nDone\n'

install_focal() {
    print '\nUbuntu 20.04.x (focal) is not longer be supported for ROCm 6.4.2. The last supported version is ROCm 6.4.0.\n'
    print 'More details can be verified under https://repo.radeon.com/amdgpu-install/6.4/ubuntu/ \n'
}

install_jellyfish() {
    print '\nUbuntu 22.04.x (jammy jellyfish) installation method has been set.\n'
    # Download the installer script
    wget https://repo.radeon.com/amdgpu-install/6.4.2/ubuntu/jammy/amdgpu-install_6.4.60402-1_all.deb
    # install latest headers and static library files necessary for building C++ programs which use libstdc++
    sudo DEBIAN_FRONTEND=noninteractive apt install "linux-headers-$(uname -r)" "linux-modules-extra-$(uname -r)" --yes
    sudo DEBIAN_FRONTEND=noninteractive apt install python3-setuptools python3-wheel libpython3.10 --yes
    sudo DEBIAN_FRONTEND=noninteractive apt install libstdc++-12-dev --yes
    sudo DEBIAN_FRONTEND=noninteractive apt install git-lfs --yes

    # Install with "default" settings (no interaction)
    sudo DEBIAN_FRONTEND=noninteractive apt install -y ./amdgpu-install_6.4.60402-1_all.deb

    # Installing multiple use cases including ROCm 6.4.2, OCL and HIP SDK

    print '\nInstalling ROCm 6.4.2 + OCL 2.x environment ...\n'

    sudo apt update
    sudo apt install amdgpu-dkms rocm --yes

    # Groups setup and ROCm/OCL path in global *.icd file
    # Add path into global amdocl64*.icd file

    echo "/opt/rocm/lib/libamdocl64.so" | sudo tee /etc/OpenCL/vendors/amdocl64*.icd

    # add the user to the sudo group (iportant e.g. to compile vllm, flashattention in a pip environment)

    sudo usermod -a -G video,render ${SUDO_USER:-$USER}
    sudo usermod -aG sudo ${SUDO_USER:-$USER}

    # Install tools - git, htop, cmake, libmsgpack-dev, ncdu (NCurses Disk Usage utility / df -h) and freeipmi-tools (BMC version read)

    sudo DEBIAN_FRONTEND=noninteractive apt install -y git
    sudo DEBIAN_FRONTEND=noninteractive apt install -y htop
    sudo DEBIAN_FRONTEND=noninteractive apt install -y freeipmi-tools
    sudo DEBIAN_FRONTEND=noninteractive apt install -y ncdu
    sudo DEBIAN_FRONTEND=noninteractive apt install -y cmake
    sudo DEBIAN_FRONTEND=noninteractive apt install -y libmsgpack-dev

    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    source ~/.bashrc

    print '\nInstalling Pytorch 2.9.0, Transformers environment ...\n'

    pip3 install --upgrade pip
    pip3 install --upgrade pip wheel
    pip3 install joblib
    pip3 install setuptools_scm
    pip3 install --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/rocm6.4
    pip3 install transformers
    pip3 install accelerate
    pip3 install -U diffusers
    pip3 install protobuf
    pip3 install sentencepiece
    pip3 install datasets

    print '\nFinished ROCm 6.4.2 + OCL 2.x + Pytroch 2.9.0 (nightly build) + Transformers environment installation and setup.\n'
    print 'After the reboot test your installation with typing "rocminfo" or "clinfo" or "rocm-smi".\n'
    print 'The active Pytorch device can be verified with: "python3 test.py"\n'
}

install_noble() {
    print '\nUbuntu 24.04.x (noble numbat) installation method has been set.\n'
    # Download the installer script
    wget https://repo.radeon.com/amdgpu-install/6.4.2/ubuntu/noble/amdgpu-install_6.4.60402-1_all.deb
    # Install the necessary headers and static library files
    sudo DEBIAN_FRONTEND=noninteractive apt install "linux-headers-$(uname -r)" "linux-modules-extra-$(uname -r)" --yes
    sudo DEBIAN_FRONTEND=noninteractive apt install python3-setuptools python3-wheel libpython3.12 --yes
    sudo DEBIAN_FRONTEND=noninteractive apt install libstdc++-13-dev --yes
    sudo DEBIAN_FRONTEND=noninteractive apt install git-lfs --yes

    # Install with "default" settings (no interaction)
    sudo DEBIAN_FRONTEND=noninteractive apt install -y ./amdgpu-install_6.4.60402-1_all.deb

    # Installing multiple use cases including ROCm 6.4.2, OCL and HIP SDK

    print '\nInstalling ROCm 6.4.2 + OCL 2.x environment ...\n'

    sudo apt update
    sudo apt install amdgpu-dkms rocm --yes

    # Groups setup and ROCm/OCL path in global *.icd file
    # Add path into global amdocl64*.icd file

    echo "/opt/rocm/lib/libamdocl64.so" | sudo tee /etc/OpenCL/vendors/amdocl64*.icd

    # add the user to the sudo group (iportant e.g. to compile vllm, flashattention in a pip environment)

    sudo usermod -a -G video,render ${SUDO_USER:-$USER}
    sudo usermod -aG sudo ${SUDO_USER:-$USER}

    # Install tools - git, htop, cmake, libmsgpack-dev, ncdu (NCurses Disk Usage utility / df -h) and freeipmi-tools (BMC version read)

    sudo DEBIAN_FRONTEND=noninteractive apt install -y git
    sudo DEBIAN_FRONTEND=noninteractive apt install -y htop
    sudo DEBIAN_FRONTEND=noninteractive apt install -y freeipmi-tools
    sudo DEBIAN_FRONTEND=noninteractive apt install -y ncdu
    sudo DEBIAN_FRONTEND=noninteractive apt install -y cmake
    sudo DEBIAN_FRONTEND=noninteractive apt install -y libmsgpack-dev

    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    source ~/.bashrc

    print '\nInstalling Pytorch 2.9.0, Transformers environment ...\n'

    pip3 install --upgrade pip --break-system-packages
    pip3 install --upgrade pip wheel --break-system-packages
    pip3 install joblib --break-system-packages
    pip3 install setuptools_scm --break-system-packages
    pip3 install --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/rocm6.4 --break-system-packages
    pip3 install transformers --break-system-packages
    pip3 install accelerate --break-system-packages
    pip3 install -U diffusers --break-system-packages
    pip3 install protobuf --break-system-packages
    pip3 install sentencepiece --break-system-packages
    pip3 install datasets --break-system-packages

    print '\nFinished ROCm 6.4.2 + OCL 2.x + Pytroch 2.9.0 (nightly build) + Transformers environment installation and setup.\n'
    print 'After the reboot test your installation with typing "rocminfo" or "clinfo" or "rocm-smi".\n'
    print 'The active Pytorch device can be verified with: "python3 test.py"\n'
}

# Check if supported Ubuntu release exists
if command -v lsb_release > /dev/null; then
    UBUNTU_CODENAME=$(lsb_release -c -s)

    if [ "$UBUNTU_CODENAME" = "focal" ]; then
        print '\nDetected Ubuntu Focal Fossa (20.04.x).\n'

install_focal

    elif [ "$UBUNTU_CODENAME" = "jammy" ]; then
        print '\nDetected Ubuntu Jammy Jellyfish (22.04.x).\n'

install_jellyfish

 elif [ "$UBUNTU_CODENAME" = "noble" ]; then
        print '\nDetected Ubuntu Noble Numbat (24.04.x).\n'

install_noble

    else
        print '\nUnknown Ubuntu version!\n'
    fi
else
    print '\nlsb_release command not found. Unable to determine Ubuntu version.\n'
fi

echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# create test script

cd && echo 'import torch

print("PyTorch version:", torch.__version__)
print("ROCm version:", torch.version.hip if hasattr(torch.version, 'hip') else "Not ROCm build")
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

' >> test.py

# reboot option
print 'Reboot system now (recommended)? (y/n)'
read q
if [ $q == "y" ]; then
    for i in 3 2 1
    do
        printf "Reboot in $i ...\r"; sleep 1
    done
    sudo reboot
fi