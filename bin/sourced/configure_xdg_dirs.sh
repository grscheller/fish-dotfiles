# Setup XDG Desktop folder locations
#
# XDG names are used in the install scripts.
#
# - defaults to standard locations if not already defined
#   - can override in shell for multiple configs to exist
# - tries to ensure XDG directories exist
#
# shellcheck shell=sh

: "${XDG_CONFIG_HOME:=$HOME/.config}"
: "${XDG_DATA_HOME:=$HOME/.local/share}"
: "${XDG_STATE_HOME:=$HOME/.local/state}"
: "${XDG_CACHE_HOME:=$HOME/.cache}"

export XDG_CONFIG_HOME XDG_DATA_HOME XDG_STATE_HOME XDG_CACHE_HOME

if test "$OS_GRS" != windows
then
    ensure_dir "$XDG_CONFIG_HOME" >&2
    chmod 0755 "$XDG_CONFIG_HOME"
    ensure_dir "$XDG_DATA_HOME" >&2
    chmod 0755 "$XDG_DATA_HOME"
    ensure_dir "$XDG_STATE_HOME" >&2
    chmod 0755 "$XDG_STATE_HOME"
    ensure_dir "$XDG_CACHE_HOME" >&2
    chmod 0755 "$XDG_CACHE_HOME"
fi
