# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n] confirmations, etc.)
# must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Commands that require console output (e.g., prompts, echo) should be placed above this point
# These commands must be moved below instant prompt to avoid console output warnings

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname "$ZINIT_HOME")"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add Powerlevel10k theme using Zinit
zinit ice depth=1; zinit light romkatv/powerlevel10k


alias n='nvim $(fzf -m --preview="bat --color=always {}")'


# Add plugins using Zinit
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab # Load fzf-tab plugin via zinit for enhanced fuzzy tab completion

# Load Oh My Zsh plugins using Zinit snippets
zinit snippet OMZP::git  # Git plugin from OMZP
zinit snippet OMZP::sudo  # Sudo plugin from OMZP
zinit snippet OMZP::archlinux  # Arch Linux plugin from OMZP
zinit snippet OMZP::aws  # AWS plugin from OMZP
zinit snippet OMZP::kubectl  # kubectl plugin from OMZP
zinit snippet OMZP::kubectx  # kubectx plugin from OMZP

# Other custom plugins or snippets
zinit snippet OMZP::command-not-found  # Command-not-found plugin from OMZP

# Autoload compinit and initialize it
autoload -U compinit && compinit

# Replay previous cd commands silently (moved after the instant prompt block)
zinit cdreplay -q  # replay your previous cd commands silently

# Initialize fzf with Zsh integration (moved after the instant prompt block)
eval "$(fzf --zsh)"

# Initialize zoxide for faster directory navigation (moved after the instant prompt block)
eval "$(zoxide init --cmd cd zsh)"


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Commands that may produce console output after the instant prompt preamble
# should be placed here
# For example:
# echo "Finished loading Zsh plugins"

# Set keybindings to Vi mode
bindkey -e
# Bind 'n' to search forward through history in Vi mode
bindkey -M viins 'n' history-search-forward
# Bind 'p' to search backward through history in Vi mode
bindkey -M viins 'p' history-search-backward


# History configuration
HISTSIZE=5000              # Maximum number of history entries in memory
HISTFILE=~/.zsh_history     # File to save history
SAVEHIST=$HISTSIZE         # Number of history entries to save
HISTDUP=erase              # Remove duplicate entries from history

# Set history options
setopt append_history      # Append to the history file, not overwrite
setopt share_history       # Share history across all zsh sessions
setopt hist_ignore_space   # Ignore commands that start with a space
setopt hist_ignore_all_dups # Ignore all duplicate commands
setopt hist_save_no_dups  # Do not save duplicate commands to the history file
setopt hist_ignore_dups    # Ignore consecutive duplicate commands
setopt hist_find_no_dups  # Ignore duplicates while searching history


# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
# Disable menu for completion (optional, use fzf for completion)
zstyle ':completion:*' menu no
# fzf-tab preview for 'cd' completion
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color=auto $realpath'
# fzf-tab preview for zoxide completion
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color=auto $realpath'

# Aliases
alias ls='ls --color'
