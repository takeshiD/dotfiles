#!/bin/bash

set -e

echo "🚀 Setting up development environment with flakes..."
if ! command -v nix &> /dev/null; then
    echo "📦 Installing Nix..."
    curl -fsSL https://install.determinate.systems/nix | sh -s -- install --determinate
    # Verifying
    if ! command -v nix &> /dev/null; then
        echo "Error! Failed Nix install"
        return
    fi
else
    echo "✔  Installed Nix"
fi

if ! command -v home-manager &> /dev/null; then
    echo "📦 Installing home-manager..."
    nix run home-manager/master -- init --switch
    # Verifying
    if ! command -v home-manager &> /dev/null; then
        echo "Error! Failed home-manager install"
        return
    fi
else
    echo "✔  Installed home-manager"
fi

echo "⚙️ Applying home-manager configuration..."
home-manager switch --flake .#tkcd

echo "✅ Setup completed! Please restart your shell."
