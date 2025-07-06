#!/bin/bash

set -e
source  ./config/bash/components/notice.sh

info "🚀 Setting up development environment with flakes..."
if ! command -v nix &> /dev/null; then
    info "📦 Installing Nix..."
    curl -fsSL https://install.determinate.systems/nix | sh -s -- install --determinate
    success "❄  Nix install is success! Please restart shell, due to nix will be enabled."
    return
else
    info "❄  Installed Nix"
fi

if ! command -v home-manager &> /dev/null; then
    echo "📦 Installing home-manager..."
    nix run home-manager/master -- init --switch
    # Verifying
    if ! command -v home-manager &> /dev/null; then
        error "Failed install home-manager"
        return
    else
        success "🏠 home-manager install is success!"
    fi
else
    info "🏠 Installed home-manager"
fi

if ! command -v home-manager &> /dev/null; then
    error "home-manager is not installed! Abort configuration."
    return
else
    info "⚙️ Applying home-manager configuration..."
    home-manager switch --flake .#tkcd
    success "✅ Setup completed! Please restart your shell."
fi

