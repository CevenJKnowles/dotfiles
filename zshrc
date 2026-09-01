ZSH=$HOME/.oh-my-zsh

# You can change the theme with another one from https://github.com/robbyrussell/oh-my-zsh/wiki/themes
ZSH_THEME="robbyrussell"

# Useful oh-my-zsh plugins for Le Wagon bootcamps
plugins=(git gitfast last-working-dir common-aliases zsh-syntax-highlighting history-substring-search ssh-agent)

# Prompt for the SSH key passphrase on the first shell of the session
zstyle :omz:plugins:ssh-agent lifetime 12h
zstyle :omz:plugins:ssh-agent identities id_ed25519

# (macOS-only) Prevent Homebrew from reporting - https://github.com/Homebrew/brew/blob/master/docs/Analytics.md
export HOMEBREW_NO_ANALYTICS=1

# Disable warning about insecure completion-dependent directories
ZSH_DISABLE_COMPFIX=true

# Actually load Oh-My-Zsh
source "${ZSH}/oh-my-zsh.sh"
unalias rm # No interactive rm by default (brought by plugins/common-aliases)
unalias lt # we need `lt` for https://github.com/localtunnel/localtunnel

# Load rbenv if installed (to manage your Ruby versions)
export PATH="${HOME}/.rbenv/bin:${PATH}" # Needed for Linux/WSL
type -a rbenv > /dev/null && eval "$(rbenv init -)"

# Load pyenv (to manage your Python versions)
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
type -a pyenv > /dev/null && eval "$(pyenv init -)" && eval "$(pyenv virtualenv-init - 2> /dev/null)" && RPROMPT+='[🐍 $(pyenv version-name)]'

# Load nvm (to manage your node versions)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Call `nvm use` automatically in a directory with a `.nvmrc` file
autoload -U add-zsh-hook
load-nvmrc() {
  if nvm -v &> /dev/null; then
    local node_version="$(nvm version)"
    local nvmrc_path="$(nvm_find_nvmrc)"

    if [ -n "$nvmrc_path" ]; then
      local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

      if [ "$nvmrc_node_version" = "N/A" ]; then
        nvm install
      elif [ "$nvmrc_node_version" != "$node_version" ]; then
        nvm use --silent
      fi
    elif [ "$node_version" != "$(nvm version default)" ]; then
      nvm use default --silent
    fi
  fi
}
type -a nvm > /dev/null && add-zsh-hook chpwd load-nvmrc
type -a nvm > /dev/null && load-nvmrc

# Rails and Ruby uses the local `bin` folder to store binstubs.
# So instead of running `bin/rails` like the doc says, just run `rails`
# Same for `./node_modules/.bin` and nodejs
export PATH="./bin:./node_modules/.bin:${PATH}:/usr/local/sbin"

# Store your own aliases in the ~/.aliases file and load the here.
[[ -f "$HOME/.aliases" ]] && source "$HOME/.aliases"

# Encoding stuff for the terminal
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export BUNDLER_EDITOR=code
export EDITOR=code

# Set ipdb as the default Python debugger
export PYTHONBREAKPOINT=ipdb.set_trace

# Google Cloud SDK
export PATH="$HOME/Dev/04_Lewagon/google-cloud-sdk/bin:$PATH"
if [ -f "$HOME/Dev/04_Lewagon/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/Dev/04_Lewagon/google-cloud-sdk/completion.zsh.inc"; fi
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
export GOOGLE_APPLICATION_CREDENTIALS="$HOME/path/to/your-service-account-key.json"

# Local, untracked overrides (real credential paths, machine-specific values)
[[ -f "$HOME/Dev/CJK_config/zshrc.local" ]] && source "$HOME/Dev/CJK_config/zshrc.local"

# 03-Decision-Science Olist module imports
export PYTHONPATH="/home/cjk/code/CevenJKnowles/03-Decision-Science:$PYTHONPATH"
alias gp='git push'

# ---------- Accessible palette prompt ----------
C_PATH='#17FCD0'    # location
C_OK='#9CF216'      # good
C_ATTN='#F59423'    # attention
C_BAD='#FF6BAC'     # problem
C_INFO='#A29DF7'    # information
C_DIM='#9A9AA5'     # structure

ZSH_THEME_GIT_PROMPT_PREFIX="  %F{$C_DIM}git:(%F{$C_ATTN}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%f"
ZSH_THEME_GIT_PROMPT_CLEAN="%F{$C_DIM})"
ZSH_THEME_GIT_PROMPT_DIRTY="%F{$C_DIM})"

ZSH_THEME_GIT_PROMPT_UNTRACKED="%F{$C_ATTN}?"
ZSH_THEME_GIT_PROMPT_ADDED="%F{$C_OK}+"
ZSH_THEME_GIT_PROMPT_MODIFIED="%F{$C_BAD}!"
ZSH_THEME_GIT_PROMPT_RENAMED="%F{$C_ATTN}>"
ZSH_THEME_GIT_PROMPT_DELETED="%F{$C_BAD}x"
ZSH_THEME_GIT_PROMPT_STASHED="%F{$C_INFO}\$"
ZSH_THEME_GIT_PROMPT_UNMERGED="%F{$C_BAD}="
ZSH_THEME_GIT_PROMPT_AHEAD="%F{$C_OK}^"
ZSH_THEME_GIT_PROMPT_BEHIND="%F{$C_ATTN}v"
ZSH_THEME_GIT_PROMPT_DIVERGED="%F{$C_BAD}Y"

PROMPT="%(?:%F{$C_OK}%1{➜%}:%F{$C_BAD}%1{➜%})"
PROMPT+="  %F{$C_PATH}%c%f"
PROMPT+='$(git_prompt_info)$(git_prompt_status)'
PROMPT+="%f  %F{$C_PATH}%1{➜%}%f  "
