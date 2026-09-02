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

set -q FISH_VIRGIN_PATH_GRS
or begin
    set -gx FISH_VIRGIN_PATH_GRS $PATH

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

    # Configure JDK & Scala - /usr/lib/jvm is Debian/Ubuntu layout
    test -d /usr/lib/jvm
    and begin
        set -p PATH ~/.local/share/coursier/bin
        jdk_version 21
    end

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

    # For Windows, locations for git, nvim and openssh
    set -l prog_files '/c/Program Files'
    test -d "$prog_files"
    and begin
        set -l git_path $prog_files/Git/cmd
        set -l nvim_path $prog_files/Neovim/bin
        set -l win_openssh_path /c/Windows/System32/OpenSSH
        test -e "$git_path/git.exe"
        and set -a PATH $git_path
        test -e "$nvim_path/nvim.exe"
        and set -a PATH $nvim_path
        test -e "$win_openssh_path/ssh.exe"
        and set -p PATH $win_openssh_path
    end

    # Add ~/bin at end of PATH
    set -a PATH ~/bin

    # Cleanup PATH: remove duplicate & nonexistent entries, resolve symlinks
    set PATH (pathtrim $PATH)

end
