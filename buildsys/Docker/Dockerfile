# Step 1: Use Ubuntu 20.04 to guarantee glibc 2.31 backward compatibility
FROM ubuntu:20.04

# Step 2: Prevent interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Step 3: Install absolute core dependencies needed for BAWT linux builds
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    p7zip-full \
    curl \
    ca-certificates \
    git \
    make \
    gcc \
    g++ \
    locales \
    zlib1g-dev \
    libx11-dev \
    libxft-dev \
    libcups2-dev \
    && locale-gen en_US.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# Step 4: Configure the workspace inside the container
WORKDIR /workspace

# Step 5: Start with a clear entry bash shell
CMD ["/bin/bash"]
