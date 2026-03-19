#!/usr/bin/sh

# Directories I like
export DWM_DIR="$XDG_SOURCE_HOME/suckless/dwm";
export ST_DIR="$XDG_SOURCE_HOME/suckless/st";
export YAZI_CONFIG_HOME="$HOME/.config/yazi";

export GOPATH="$HOME/.local/share/go"
export NPMBIN="$HOME/.local/share/npm/bin"
export NODE_PATH="${XDG_DATA_HOME:-$HOME/.local/share}/node_modules"
export HISTTIMEFORMAT="%d/%m/%y %T "
export XDG_CONFIG_HOME="$HOME/.config";
export XDG_CACHE_HOME="$HOME/.cache";
export XDG_DATA_HOME="$HOME/.local/share";
export XDG_STATE_HOME="$HOME/.local/state";
export XDG_SOURCE_HOME="$HOME/.local/src";
export XDG_BINARY_HOME="$GOME/.local/bin";

export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
export ZSHCFG="$ZDOTDIR/zshcfg"
export ZSH="$ZSHCFG/OMZ"
export HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/history"
export BM_DIR=""
export SSH_ENV="$HOME/.config/ssh/agent-environment"
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
# Adds `~/.local/bin` to $PATH
export SCRIPTS="$(du "$HOME/.local/bin/"{mrblocks-scripts,mrpanel-genmon-scripts,system-scripts} | cut -f2 | paste -sd ':')"}
export PATH="$PATH:$GOPATH/bin:$NPMBIN:$SCRIPTS"

#Set bookmarks dir
# To add any bookmark, use command below without quotes:
# bm 'bookmarkdir' '@bookmarkname' OR bm @bookmarkname to bookmark current directory
[[ -d "$ZSHCFG/bookmarks" ]] && export CDPATH=".:$ZSHCFG/bookmarks:/" \
	&& alias jmp="cd -P"

lf() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]
	then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
