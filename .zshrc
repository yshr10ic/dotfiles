autoload -Uz add-zsh-hook

# --------------------------------------------------
#  anyenvの設定
# --------------------------------------------------
eval "$(anyenv init -)"

# --------------------------------------------------
#  zsh-completions(補完機能)の設定
# --------------------------------------------------
if [ -e /usr/local/share/zsh-completions ]; then
  fpath=(/usr/local/share/zsh-completions $fpath)
fi
autoload -U compinit
compinit -u

# --------------------------------------------------
#  プロンプトの設定（左）
# --------------------------------------------------
# venvの環境名を消す
export VIRTUAL_ENV_DISABLE_PROMPT=1

# venvがactivateのときに、環境名とPythonのバージョンを取得する
function pyprecmd () {
  PYTHON_PROMPT_STRING=""
  if [ -n "$VIRTUAL_ENV" ]; then
    PYTHON_VERSION_STRING="py:"$(pyenv version-name)
    PYTHON_VIRTUAL_ENV_STRING="`basename \"$VIRTUAL_ENV\"`"
    PYTHON_PROMPT_STRING="("${PYTHON_VIRTUAL_ENV_STRING}" "${PYTHON_VERSION_STRING}") "
  fi
}

add-zsh-hook precmd pyprecmd

function setprompt() {
  PROMPT='
%F{red}${PYTHON_PROMPT_STRING}%f%n@%m %F{green}%~%f
%F{green}%B●%b%f '
}

setprompt
unfunction setprompt

# --------------------------------------------------
#  プロンプトの設定（右）：Gitブランチの状態表示
# --------------------------------------------------
autoload -Uz vcs_info
setopt prompt_subst

# true | false
# trueで作業ブランチの状態に応じて表示を変える
zstyle ':vcs_info:*' check-for-changes false
# addしてない場合の表示
zstyle ':vcs_info:*' unstagedstr "%F{red}%B＋%b%f"
# commitしてない場合の表示
zstyle ':vcs_info:*' stagedstr "%F{yellow}★ %f"
# デフォルトの状態の表示
zstyle ':vcs_info:*' formats "%u%c%F{green}【 %b 】%f"
# コンフリクトが起きたり特別な状態になるとformatsの代わりに表示
zstyle ':vcs_info:*' actionformats '【%b | %a】'

precmd () { vcs_info }

RPROMPT=$RPROMPT'${vcs_info_msg_0_}'

# --------------------------------------------------
#  alias（ls）
# --------------------------------------------------
alias la='ls -a'
alias ll='ls -l'
alias lr='ls -R'

# --------------------------------------------------
#  alias（Git）
# --------------------------------------------------
alias g="git"
compdef g=git

alias gs='git status --short --branch'
alias ga='git add -A'
alias gc='git commit -m'
alias gp='git push origin master'

alias gd='git diff'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gb='git branch'
alias gba='git branch -a'
alias gbr='git branch -r'

alias gm='git merge'
alias gr='git reset'

# --------------------------------------------------
#  alias（other）
# --------------------------------------------------
alias c='clear'
alias h='history'
alias va='source venv/bin/activate'

# --------------------------------------------------
#  Other
# --------------------------------------------------
# 同時に起動しているzshの間でhistoryを共有する
setopt share_history

# 同じコマンドをhistoryに残さない
setopt hist_ignore_all_dups

# スペースから始まるコマンドをhistoryに残さない
setopt hist_ignore_space

# historyに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks

# 高機能なワイルドカード展開を使用する
setopt extended_glob

# コマンドのスペルミスを指摘
setopt correct
