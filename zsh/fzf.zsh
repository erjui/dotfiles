# Setup fzf
# ---------
if [[ ! "$PATH" == */home/seongjae/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/seongjae/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/seongjae/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/home/seongjae/.fzf/shell/key-bindings.zsh"
