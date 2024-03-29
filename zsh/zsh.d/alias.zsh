# Custom aliases for ZSH
# @https://zsh.sourceforge.io/Doc/Release/Options.html

unsetopt NOMATCH

os='undefined'
if [[ "$OSTYPE" == darwin* ]]; then
    os='mac'
elif [[ "$OSTYPE" == linux* ]]; then
    os='linux'
    alias open='xdg-open'
fi

BBLACK='\033[1;30m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
NC='\033[0m'
ONWHITE='\033[47m'

alias reload!='source ~/.zshrc'
alias c='clear'

if [[ $os == 'linux' ]] ;
then
    if command -v poweroff &> /dev/null
    then
        # safe poweroff
        function spoweroff() {
            echo -e "${GREEN}The systme will be off after 3 seconds${NC}" && sleep 1
            echo -e "${YELLOW}The systme will be off after 2 seconds${NC}" && sleep 1
            echo -e "${RED}The systme will be off after 1 seconds${NC}" && sleep 1
            echo -e "${ONWHITE}${BBLACK}BEEP BEEP BEEP BEEP BEEP BEEP BEEP BEEP${NC}" && sleep 0.2
            poweroff
        }
    fi
fi

# copy and paste
if command -v xclip &> /dev/null
then
    alias copy='xclip -selection clipboard'
    alias copy!='xclip -o'
    alias pwdc='pwd | copy'
    if command -v fasd &> /dev/null
    then
        function dirc() {d $1 | copy}
    fi
fi

# vim: use neovim as default
if command -v nvim &> /dev/null
then
    alias vim='nvim'
fi
alias vi='vim'

alias python='python3'
alias py='python'
alias pip='pip3'

alias cp='nocorrect cp -iv'
alias mv='nocorrect mv -iv'
alias rm='nocorrect rm -iv'

# TODO: Add du-dust, alternative for du
alias ducsh='du -csh * 2>/dev/null | sort -hr'
alias ducsh.='du -csh .* 2>/dev/null | sort -hr'
alias ducsha='du -csh * .* 2>/dev/null | sort -hr'
if command -v duf &> /dev/null
then
    alias df='duf --sort size'
else
    alias df='df -hT'
fi

# TODO: python virtual environment
# anaconda
if command -v conda &> /dev/null
then
    alias ca='conda activate'
    alias cel='conda env list'
    alias cl='conda list'
fi

# htop
if command -v htop &> /dev/null
then
    alias top='htop'
    alias topc='htop -s PERCENT_CPU'
    alias topm='htop -s PERCENT_MEM'
fi

# bat
if [[ $os == 'mac' ]] ;
then
    if command -v bat &> /dev/null
    then
        alias cat='bat --theme "Monokai Extended"'
    fi
else
    if command -v batcat &> /dev/null
    then
        alias cat='batcat'
    fi
fi

# fd
if command -v fdfind &> /dev/null
then
    alias fd='fdfind'
else
    alias fd='find'
fi

# tmux
if command -v tmux &> /dev/null
then
    alias tn='tmux new -s'
    alias tl='tmux list-session'
    alias ta='tmux attach-session -t'
    alias tk='tmux kill-session -t'
    alias tka='tmux kill-server'

    # REMIND: temporiary aliases for tmux preset readily available
    function tnpreset() {
        tmux new -s $1 \; \
        split-window -v -p 30 \; \
        send-keys 'gpustat -pi' C-m \; \
        select-pane -t 0 \
    }
fi

# gpustat
if command -v gpustat &> /dev/null
then
    alias gs='gpustat -pi'
elif command -v nvidia-smi &> /dev/null
then
    alias gs='watch -n 0.1 -d nvidia-smi'
fi
