#!/bin/bash

# Install tools specified in mise.toml
#
cd /workspaces/crypto-predictor-system

# Trust the mise configuration
mise trust

# Disable idiomatic version files to avoid warnings
mise settings add idiomatic_version_file_enable_tools "[]"

# Install all tools from mise.toml
mise install

# Add mise activation to bash profile
echo 'eval "$(/usr/local/bin/mise activate bash)"' >> ~/.bashrc

# Activate mise for current session
source ~/.bashrc
