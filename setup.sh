#!/bin/bash

echo "Updating package list..."
apt update

if ! command -v od &>/dev/null; then
	echo "'od' not found. Installing bsdmainutils..."
	apt install -y bsdmainutils
else
	echo "'od' is already installed."
fi

if ! command -v tr &>/dev/null; then
	echo "'tr' not found. Installing coreutils..."
	apt install -y coreutils
else
	echo "'tr' is already installed."
fi

if ! command -v strip &>/dev/null; then
	echo "'strip' not found. Installing binutils..."
	apt install -y binutils
else
	echo "'strip' is already installed."
fi

if ! command -v rustc &>/dev/null || ! command -v cargo &>/dev/null; then
	echo "Rust not found. Installing Rust..."
	apt install -y rust
else
	echo "Rust is already installed."
fi

if ! command -v base64 &>/dev/null; then
	echo "'base64' not found. Installing coreutils..."
	apt install -y coreutils
else
	echo "'base64' is already installed."
fi

echo ""
echo "Verifying installations..."
if command -v od &>/dev/null; then
	echo "'od' is installed."
else
	echo "'od' is not installed. Please install it manually."
fi

if command -v tr &>/dev/null; then
	echo "'tr' is installed."
else
	echo "'tr' is not installed. Please install it manually."
fi

if command -v strip &>/dev/null; then
	echo "'strip' is installed."
else
	echo "'strip' is not installed. Please install it manually."
fi

if command -v rustc &>/dev/null && command -v cargo &>/dev/null; then
	echo "Rust is installed."
else
	echo "Rust is not installed. Please install it manually."
fi

if command -v base64 &>/dev/null; then
	echo "'base64' is installed."
else
	echo "'base64' is not installed. Please install it manually."
fi

echo ""
echo "Setup complete."
