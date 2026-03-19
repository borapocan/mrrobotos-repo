# Enable colors and change prompt:
autoload -U colors && colors
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

# Fetch all plugins in dir
plugins=(`echo $(ls $ZSH/plugins | sed -z 's/\n/ /g')`)
export EDITOR="nvim";

# # Basic auto/tab complete:
# autoload -U compinit
# zstyle ':completion:*' menu select
# zmodload zsh/complist
# compinit
setopt extendedglob
_comp_options+=(globdots)		# Include hidden files.

mkv2mp4() {
	ffmpeg -i $1 -codec copy $2
}

qcow2img() {
    qemu-img create disk.qcow2 $1
}

quickemugenconf() {
    iso=$(ls $1/*.iso)
    src=$(cat << EOF
#!/bin/quickemu --vm
guest_os="linux"
disk_img="$1/disk.qcow2"
iso="$iso"
EOF
)
    echo -e "$src" > $1.conf
}

#chatgptcopy() {
#	export OPENAI_KEY="$OPENAI_API_KEY"
#	chatgpt -p "$(xclip -o)" | tr -d '\n' | xclip -selection clipboard
#	xclip -o
#}

#rmexcept() {
#	[ ! -n "$1" ] && echo "Please input a var" && return
#	find . ! -name $1 -type f -exec rm -f {} +
#}

umountforce() {
    fuser -km $1
    umount $1
}

urltotar() {
    curl -L $1 | tar xvfz - -C $2
}

tarxz() {
    XZ_OPT=-$1 tar cJvf $2 .
}

mntqcow2() {
    lsmod | grep nbd || sudo modprobe nbd
    sudo qemu-nbd --format qcow2 $1 --connect $2
}

mrsudo() {
    sudo -i sh -c "cd '$PWD'; zsh"
}

privateuser() {
	sudo -u nobody bash --noprofile --norc
}

githttptossh() {
    git remote set-url origin git@github.com:$(git remote get-url origin | rev | cut -d '/' -f -2 | rev)
}

getclang() {
	wget https://raw.githubusercontent.com/FT-Labs/phylib/master/.clang-format
}

tardel() {
	ext=$(file -b --extension $1 | awk -F'/' '{print $1}')
	case $ext in
		gz)  f="gzip" ;;
		zst) f="zstd" ;;
		xz)  f="xz"   ;;
	esac

	tar --$f -xvf $1 && rm $1
}

cppwd() {
	echo -n "$PWD" | xclip -selection clipboard
}
zle -N cppwd

function lf() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	command rm -f -- "$tmp" 2>/dev/null
}



# below opens a new terminal in current dir
bindkey -s '^t' 't\n'
bindkey '^p' cppwd
setopt chaselinks
setopt autocd
# change below theme if using oh-my-zsh
#ZSH_THEME=""
HISTSIZE=100000
SAVEHIST=100000
setopt appendhistory
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

# Load aliases
[ -f "$ZSHCFG/aliasrc" ] && source "$ZSHCFG/aliasrc"

RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
# Note that in different distro or installation way below source files need to be changed, they are usually in ~/.zsh/
source "$ZSHCFG/OMZ/oh-my-zsh.sh"
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview \
  '[[ $group == "[process ID]" ]] && ps --pid=$word -o cmd --no-headers -w -w'
#zstyle ':fzf-tab:*' fzf-command

zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:3:wrap
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath' # remember to use single quote here!!!
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'
zstyle ':fzf-tab:*' single-group color header
zstyle -d ':completion:*' format
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*:phint:*' sort false
#zstyle ':fzf-tab:complete:phint:argument-rest' fzf-flags  --no-sort --preview-window=down:60%:wrap --with-nth 1
zstyle ':fzf-tab:complete:phint:argument-rest' fzf-flags  --no-sort --preview-window=down:wrap --with-nth 1
zstyle ':fzf-tab:complete:phint:argument-rest' fzf-change-desc "swap"
#zstyle ':fzf-tab:complete:phint:argument-rest' fzf-preview 'echo Cmd: ${${(Q)desc#*--}::-2}'
zstyle ':fzf-tab:complete:phint:argument-rest' fzf-preview 'echo Cmd: ${word}; grep "" 2>/dev/null $(which ${word#*sudo\ })'


# vi mode
bindkey -v
export KEYTIMEOUT=1
export GPG_TTY=$(tty)
if [ ! -z $BM_DIR ]; then
    cd -P $BM_DIR &&
    export BM_DIR=""
fi

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# Below to change autosuggestion options
bindkey '^[[Z' autosuggest-accept   # shift tab to accept ghost text
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(buffer-empty bracketed-paste accept-line push-line-or-edit)
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_USE_ASYNC=true

#powerline-daemon -q

case "$TERM" in (rxvt|rxvt-*|st|st-*|*xterm*|(dt|k|E)term)
    local term_title () { print -n "\e]0;${(j: :q)@}\a" }
    precmd () {
      local DIR="$(print -P '[%c]')"
      term_title "$DIR" "st"
    }
    preexec () {
      local DIR="$(print -P '[%c]%#')"
      local CMD="${(j:\n:)${(f)1}}"
      #term_title "$DIR" "$CMD" use this if you want directory in command, below only prints program name
	  term_title "$CMD"
    }
  ;;
esac

export LESS_TERMCAP_mb=$(tput bold; tput setaf 39)
export LESS_TERMCAP_md=$(tput bold; tput setaf 45)
export LESS_TERMCAP_me=$(tput sgr0)

neofetch;
export PATH=$PATH:$(go env GOPATH)/bin
export PATH="$HOME/.local/bin:$PATH"
