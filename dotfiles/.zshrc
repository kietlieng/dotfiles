# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
# Path to your oh-my-zsh installation.
#
export ZSH="$HOME/.oh-my-zsh"
# syntax highlights for terminal
# kl slow
#source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

KL_STATUS_ARRAY_ROTATE=true
#KL_STATUS_ARRAY_ROTATE=false

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
#ZSH_THEME="robbyrussell"

# BEST THEME I'VE HAD! Moving to pure theme
#ZSH_THEME="geometry/geometry"

# User configuration

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"
# kl tmux setting
export DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# kl created my own
#plugins=( #git)
#plugins=( zsh-lazyload )

# marked directory position
cd `cat ~/.jumplast`

## kl will disable handle_completion_insecurities this causes slowdown
#export ZSH_DISABLE_COMPFIX=true
source $ZSH/oh-my-zsh.sh

# used to do autocompletion but the startup time for those are about 4 milliseconds on startup time
fpath=(~/lab/scripts/jumpScript/ssh/autocomplete $fpath)
fpath=(~/lab/scripts/jumpScript/directory/autocomplete $fpath)
autoload -U compinit
compinit

# export MANPATH="/usr/local/man:$MANPATH"
# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi
export EDITOR=nvim

# Compilation flags
# export ARCHFLAGS="-arch x86_64"
#export LDFLAGS="-L/usr/local/opt/curl/lib"
#export CPPFLAGS="-I/usr/local/opt/curl/include"


# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# vi mode
#bindkey -v
# Set vi timeout to 0.1 second
#export KEYTIMEOUT=1

# will allow reverse history search with vim binding on
#bindkey '^R' history-incremental-search-backward

# why do I need this?
export CLICOLOR=1
# use ripgrep
#export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden'
export GOPATH=$HOME/go

## User configuration
#echo "" > /tmp/sourcetime
#echo "load"
for f in $(find ~/lab/scripts -type f -iname "*.sh" | sort);
do

#    timer=$(($(gdate +%s%N)/1000000))

    source $f

#    now=$(($(gdate +%s%N)/1000000))
#    elapsed=$(($now-$timer))
#    echo $elapsed":" $f

done

#echo "runtime $runtime"

# override kitty terminal term variable.  This does not play well when ssh into servers
# since most don't support kitty terminal
TERM=xterm-256color
# TERM=xterm-kitty
#export PATH="$(brew --prefix)/opt/python@3.11/libexec/bin:$PATH"

# bun is a javascript runtime / bundler / test runner.  Haven't tried it
## bun completions
#[ -s "~/.bun/_bun" ] && source "~/.bun/_bun"
## bun
#export BUN_INSTALL="$HOME/.bun"
#export PATH="$BUN_INSTALL/bin:$PATH"

# kl npm package manager
## pnpm
#export PNPM_HOME="~/Library/pnpm"
#case ":$PATH:" in
#  *":$PNPM_HOME:"*) ;;
#  *) export PATH="$PNPM_HOME:$PATH" ;;
#esac
#
## pnpm end
# kl ruby eval
#eval "$(rbenv init - -zsh)"

# kl not so good.  Source vim binding.
# source $(brew --prefix)/Cellar/zsh-vi-mode/0.11.0/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

# nvim / kitty bin.  Don't need a nightly build.  But it's nice to know that I can
#export PATH="/opt/nightly/nvim-macos/bin:/opt/homebrew/bin:$PATH"

# use direnv
eval "$(direnv hook zsh)" &> /dev/null

# extend history limit

setopt BANG_HIST               # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY        # Write the history file in the ":start:elapsed;command" format.
setopt HIST_BEEP               # Beep when accessing nonexistent history.
setopt HIST_EXPIRE_DUPS_FIRST  # Expire duplicate entries first when trimming history.
setopt HIST_FIND_NO_DUPS       # Do not display a line previously found.
#setopt HIST_IGNORE_ALL_DUPS    # Delete old recorded entry if new entry is a duplicate.
#setopt HIST_IGNORE_DUPS        # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_SPACE       # Don't record an entry starting with a space.
setopt HIST_REDUCE_BLANKS      # Remove superfluous blanks before recording entry.
#setopt HIST_SAVE_NO_DUPS       # Don't write duplicate entries in the history file.
setopt HIST_VERIFY             # Don't execute immediately upon history expansion.
setopt appendhistory
setopt INC_APPEND_HISTORY      # Write to the history file immediately, not when the shell exits.
#setopt INC_APPEND_HISTORY_TIME # append command to history file immediately after execution
setopt SHARE_HISTORY           # Share history between all sessions.

## kl pure theme begin
## pure theme be sure to comment out geometry theme on top
fpath+=("$(brew --prefix)/share/zsh/site-functions" ~/.oh-my-zsh/themes/pure)

# load pure prompt
autoload -U promptinit; promptinit
prompt pure
# kl pure theme end

# kl starship has too much information
#eval "$(starship init zsh)"
#end=`date +%s`
#runtime=$((end-start))
#echo "$end $start zsh $runtime"
