![header](https://capsule-render.vercel.app/api?type=venom&text=Dotfiles&animation=fadeIn&fontSize=40&desc=for%20best%20productivity&descAlignY=70&descSize=20)

# 🧑‍💻 My Personal Dotfiles for Linux & MacOS Systems

Welcome to my collection of **dotfiles** tailored for **Linux** and **MacOS** systems!  

<div align="left">
	<img src="https://img.shields.io/badge/Debian-A81D33?style=for-the-badge&logo=debian&logoColor=white" />
	<img src="https://img.shields.io/badge/mac%20os-000000?style=for-the-badge&logo=apple&logoColor=white" />
	<img src="https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white" />
   <img src="https://img.shields.io/badge/shell_script-%23121011.svg?style=for-the-badge&logo=gnu-bash&logoColor=white" />
   <img src="https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54" />
</div>

## Why Dotfiles?

### 🔄 Portability at Its Finest
- Ensure a consistent development environment across different machines.
- Seamlessly transition between **Linux** and **MacOS** systems, embracing the power of *NIX systems.

### 🛠 Boosting Productivity
- **Efficient Development:** Maintain a uniform working environment for efficient development and experimentation.
- **Automated Setup:** Install essential packages effortlessly with a single command.
- **Preconfigured Goodies:** Set up useful packages, plugins, and aliases in advance, eliminating the need for tedious manual work.

Feel free to explore and adapt these dotfiles to suit your preferences. Happy coding! 🚀


<details>
  <summary>Please note that this repo is still under development!</summary>
It's primarily designed for my personal use at the moment,
but I'm actively working on making it more versatile for other users too!
Stay tuned for updates!

</details>

# Installation on New System 🔥

For a new system, whether it's Linux or MacOS, kickstart the process effortlessly!  
The necessary packages will be installed automatically with the following commands:

### Clone the Repository
```bash
git clone https://github.com/erjui/dotfiles.git
```

### For Linux Users
```bash
cd linux-setup
sh linux-setup.sh desktop
```

### For MacOS Users
```bash
cd mac-setup
sh mac-setup.sh desktop
```

<details>
  <summary>Linux Server Setup for Minimal or Deep Learning Framework Installation</summary>
  
  - **Minimal Installation on Server:**
    - Run `sh linux-setup.sh server`

  - **Deep Learning Frameworks Setup (e.g., Nvidia Driver, CUDA, cuDNN, and NCCL):**
    - Run `sh linux-setup.sh dl`
</details>

# Automated Configuration Setup ❄

Execute the following command to effortlessly generate symlinks for all dotfiles and establish fundamental configurations,  
Setup will be done through the command line:

```bash
cd $dotfiles
bash install.sh
```

License
-------

[The MIT License (MIT)](LICENSE)

Copyright (c) 2022-2023 Seongjae Kang (@erjui)

![footer](https://capsule-render.vercel.app/api?section=footer)
