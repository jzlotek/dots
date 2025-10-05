#!/bin/sh

[ -f $HOME/.config/aliasrc ] && source "$HOME/.config/aliasrc"

export XDG_CONFIG_HOME=$HOME/.config
export _PROFILE_SOURCED=1
