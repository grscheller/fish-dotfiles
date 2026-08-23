# Ensure a sane initial environment is set up for login shells.
#
# Note: This file plays the same role as does the
#       file ~/.profile in a POSIX compliant shell.
#
# Important: SCP connections invoke login shells and will gag
#            on extraneous output. Therefore for SCP to work
#            correctly, this file should not produce anything
#            to stdout.
#
# Factoid: COSMIC DE startup chain will invoke the user's
#          shell as a login shell at some point. That shell
#          lives until the user logs out.
#

status is-login
and begin
    set -gx FISH_VIRGIN_PATH_GRS $PATH
    set -gx FISH_LOGIN_SHELL_GRS $fish_pid

    # Set locale
    set -gx LANG en_US.utf8

    # Path to dotfile GitHub repo - set to defaults
    set -gx DOTFILE_GIT_REPOS ~/devel/dotfiles
    set -gx BASH_DOTFILES_GIT_REPO $DOTFILE_GIT_REPOS/bash-dotfiles
    set -gx FISH_DOTFILES_GIT_REPO $DOTFILE_GIT_REPOS/fish-dotfiles
    set -gx MISC_DOTFILES_GIT_REPO $DOTFILE_GIT_REPOS/misc-dotfiles
    set -gx NVIM_DOTFILES_GIT_REPO $DOTFILE_GIT_REPOS/nvim-dotfiles

    # Set up paging
    set -gx EDITOR nvim
    set -gx VISUAL nvim
    set -gx SUDO_EDITOR /usr/bin/nvim
    set -gx PAGER 'nvim -R'
    set -gx MANPAGER 'nvim +Man!'
    set -gx DIFFPROG 'nvim -d'

    # Haskell locations used by Stack and Cabal
    set -p PATH ~/.local/bin ~/.cabal/bin $PATH

    # Configure JDK & Scala on Pop!OS
    set -p PATH ~/.local/share/coursier/bin
    jdk_version 21

    # Zig toolchain
    test -L ~/devel/zig_nightly/current
    and set -p PATH ~/devel/zig_nightly/current

    # Rust toolchain
    test -e ~/.cargo/env.fish
    and set -p PATH ~/.cargo/bin

    # Mason's bin directory
    test -d ~/.local/share/nvim/mason/bin
    and set -p PATH ~/.local/share/nvim/mason/bin

    # Python configuration
    set -gx PIP_REQUIRE_VIRTUALENV true
    set -gx VE_VENV_DIR ~/devel/venvs

    # Add ~/bin at end of PATH
    set PATH $PATH ~/bin

    # Cleanup PATH: remove duplicate & nonexistent entries, resolve symlinks
    set PATH (pathtrim)

end
