🧠 Automated Deployment of AMD ROCm 6.4.2 and PyTorch 2.9.0 AI Stack for Ubuntu 22.04/24.04
on Radeon AI PRO R9700 (RDNA4) and Radeon PRO W7000 series (RDNA3)

Version 1.0 (July 29th 2025)

This technical deep dive provides step-by-step instructions for deploying AMD ROCm 6.4.2,
OCL 2.x, and the PyTorch 2.9.0 nightly build environment on Ubuntu 22.04.x and 24.04.x,
compatible with RDNA 3 (Radeon PRO W7000 series) and RDNA 4 (Radeon AI PRO R9700, Radeon RX 9070
and Radeon RX 9060).

📌 Executive Summary:

The Radeon™ AI PRO R9700 is AMD’s latest workstation GPU designed to accelerate AI development and inference, combining advanced RDNA™ 4 architecture with dedicated AI engines for optimized performance and efficiency. With robust FP16/INT8 throughput and enterprise-grade drivers, it delivers reliable, high-performance compute for AI workloads in professional environments.
This whitepaper presents a robust, automated solution for deploying AMD’s ROCm 6.4.2 platform, OpenCL 2.x, and PyTorch 2.9.0 (nightly build) along with Hugging Face Transformers on Ubuntu 22.04 and 24.04 systems. The script enables streamlined installation for AMD GPU-accelerated environments, optimized for RDNA3/4 and CDNA2/3 hardware. Designed for data scientists, ML engineers, and AI researchers, the solution offers a reproducible and fully automated installation experience that ensures compatibility, stability, and performance in both desktop and server configurations.

System preparation:

Installing Ubuntu OS
Install the Ubuntu Linux Desktop or Server version. Ensure that OpenSSH is included to allow remote system access. In this whitepaper, we use MobaXterm for SSH and SFTP access.
It is recommended to use Ubuntu 24.04.x, which includes Python 3.12 wheels, required by most AI prefill and decode optimizations.

⚠️ Note: Ubuntu 20.04.x (Focal Fossa) is no longer supported.

All scripts were developed using the free version of Microsoft Visual Studio Code.
If you encounter compatibility issues with the provided Bash script, you can create a new one in the main user directory using the following command:

📝 sudo nano os.sh

Paste the script into the file, save it, and launch it using:

📝 bash os.sh

The script (script_module_ROCm_642_Ubuntu_22.04-24.04_pytorch_290_v4server.sh) can be downloaded on GitHub repository directly:

📝 wget raw.githubusercontent.com/JoergR75/ROCm-6.4.2-deployment-on-RDNA4/refs/heads/main/script_module_ROCm_642_Ubuntu_22.04-24.04_pytorch_290_v4server.sh

Start the script:

📝 bash script_module_ROCm_642_Ubuntu_22.04-24.04_pytorch_290_v4server.sh
