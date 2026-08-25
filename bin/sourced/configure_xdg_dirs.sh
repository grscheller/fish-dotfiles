## Setup XDG Desktop folder locations
#
# grscheller/fish-dotfiles uses XDG names in its setup scripts.
#
# - defaults to standard locations if not already defined
#   - can override in shell for multiple configs to exist
#   - fish on LINUX or MSYS2 uses these when exported
# - tries to ensure XDG directories exist
# - XDG names can be overridden for multiple configurations to coexist
#
# shellcheck shell=sh

# Script use XDG Desktop names, even on Windows 11

if test "$OS" = Windows_NT
then
    # Window 11
    _local_app_data="$(cygpath -u "$LOCALAPPDATA")"
    : "${WIN_LOCAL_APP_DATA:=$_local_app_data}"
    : "${WIN_CACHE_HOME:=$_local_app_data/Temp}"
    unset _local_app_data
    : "${XDG_CONFIG_HOME:=$HOME/.config}"
    : "${XDG_DATA_HOME:=$HOME/.local/share}"
    : "${XDG_STATE_HOME:=$HOME/.local/state}"
    : "${XDG_CACHE_HOME:=$HOME/.cache}"
else
    # Linux
    : "${WIN_LOCAL_APP_DATA:=}"
    : "${WIN_CACHE_HOME:=}"
    : "${XDG_CONFIG_HOME:=$HOME/.config}"
    : "${XDG_DATA_HOME:=$HOME/.local/share}"
    : "${XDG_STATE_HOME:=$HOME/.local/state}"
    : "${XDG_CACHE_HOME:=$HOME/.cache}"
    export XDG_CONFIG_HOME XDG_DATA_HOME XDG_STATE_HOME XDG_CACHE_HOME
fi

ensure_dir "$XDG_CONFIG_HOME" >&2
chmod 0755 "$XDG_CONFIG_HOME"
ensure_dir "$XDG_DATA_HOME" >&2
chmod 0755 "$XDG_DATA_HOME"
ensure_dir "$XDG_STATE_HOME" >&2
chmod 0755 "$XDG_STATE_HOME"
ensure_dir "$XDG_CACHE_HOME" >&2
chmod 0755 "$XDG_CACHE_HOME"
