
if [ -d "$HOME/global_env" ]; then
	echo "Activating global_env..."
	. "$HOME/global_env/bin/activate"
	echo "global_env activated!"
else
	echo "global_env not found"
fi



# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

### EXPORT
export TERM="xterm-256color"                      # getting proper colors
export HISTORY_IGNORE="(ls|cd|pwd|exit|sudo reboot|history|cd -|cd ..)"
export EDITOR="emacsclient -t -a ''"              # $EDITOR use Emacs in terminal
export VISUAL="emacsclient -c -a 'emacs'"         # $VISUAL use Emacs in GUI mode
export PATH="/usr/bin/rg:$PATH"

export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64

# To enable autocompletion,
autoload -Uz compinit
compinit

# Cargo path
source $HOME/.cargo/env


# For autocompletion with an arrow-key driven interface
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# For enabling autocompletion of privileged environments in privileged commands (e.g. if you complete a command starting with sudo
zstyle ':completion::complete:*' gain-privileges 1

# Load aliases if they exist.
[ -f "${XDG_CONFIG_HOME}/zsh/.aliases" ] && . "${XDG_CONFIG_HOME}/zsh/.aliases"
[ -f "${XDG_CONFIG_HOME}/zsh/.aliases.local" ] && . "${XDG_CONFIG_HOME}/zsh/.aliases.local"

# option tells Zsh to use vi mode for key bindings.
# bindkey -v

# Change cursor shape for different vi modes.
function zle-keymap-select () {
    case $KEYMAP in
        vicmd) echo -ne '\e[1 q';;      # block
        viins|main) echo -ne '\e[5 q';; # beam
    esac
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.


# Basic key bindings
typeset -g -A key
bindkey '^?' backward-delete-char
bindkey '^[[5~' up-line-or-history
bindkey '^[[3~' delete-char
bindkey '^[[6~' down-line-or-history
bindkey '^[[A' up-line-or-search
bindkey '^[[D' backward-char
bindkey '^[[B' down-line-or-search
bindkey '^[[C' forward-char
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

# Move cursor to the beginning of the line
bindkey '^A' beginning-of-line

# Move cursor to the end of the line
bindkey '^E' end-of-line

# Move cursor left (backward) one position
bindkey '^B' backward-char

# Move cursor right (forward) one position
bindkey '^F' forward-char

# Move cursor right (forward) one word
bindkey '^[f' forward-word
bindkey '^[F' forward-word  # Some terminal configurations require capital F

# Move cursor left (backward) one word
bindkey '^[b' backward-word
bindkey '^[B' backward-word  # Some terminal configurations require capital B

# Delete from cursor to end of the line
bindkey '^K' kill-line

# Delete from the cursor to the beginning of the line
bindkey '^U' kill-whole-line

# use Ctrl-P to accept suggestion
bindkey '^P' autosuggest-accept

# Ensure the completion system is aware of new commands or scripts added to $PATH during the session
zstyle ':completion:*' rehash true

# Auto correction
ENABLE_CORRECTION="true"

# Use vim keys in tab complete menu:
#bindkey -M menuselect 'h' vi-backward-char
#bindkey -M menuselect 'k' vi-up-line-or-history
#bindkey -M menuselect 'l' vi-forward-char
#bindkey -M menuselect 'j' vi-down-line-or-history
#bindkey -v '^?' backward-delete-char

# Autoload the colors module if not already loaded, and then enable color support
autoload -Uz colors && colors


### HISTORY

# Commands are added to the history immediately
setopt INC_APPEND_HISTORY
export HISTTIMEFORMAT="[%F %T] "

# Add Timestamp to history
setopt EXTENDED_HISTORY

# Remove duplicates in history
setopt incappendhistory
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups



# Load Functions
source "$ZDOTDIR"/zsh-functions

# Plugins
zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"

# Zsh git completion
zstyle ':completion:*:*:git:*' script ~/.config/zsh/git-completion.zsh
fpath=($HOME/.config/zsh $fpath)

# Need to add below Docker completion

# Load zsh-syntax-highlighting; should be last.
#source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null
#source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null

#if [ -f "$HOME"/.cache/zsh/history ] ;then
#touch "$HOME"/.cache/zsh/history
#fi


# Rclone config
#source "$HOME"/bin/set-rclone-password

# expand alias with function associated in zsh-functions file
zle -N expand-alias
bindkey -M main ' ' expand-alias

# globalias function settings defined in file zsh-function
 zle -N globalias

 # space expands all aliases, including global
 bindkey -M emacs " " globalias
 bindkey -M viins " " globalias

 # control-space to make a normal space
 #ibindkey -M emacs "^ " magic-space
 #bindkey -M viins "^ " magic-space

 # normal space during searches
 bindkey -M isearch " " magic-space

source ~/powerlevel10k/powerlevel10k.zsh-theme

# Adb fastboot
if [ -d "$HOME/adb-fastboot/platform-tools" ] ; then
 export PATH="$HOME/adb-fastboot/platform-tools:$PATH"
fi

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


# Export Cargo path for Rust apps
#export PATH="$HOME/.cargo/bin"

#export PATH="/home/alien/.cargo/bin"

eval "$(atuin init zsh)"
eval "$(atuin init zsh)"
source ~/powerlevel10k/powerlevel10k.zsh-theme

