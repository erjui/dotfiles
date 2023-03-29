# Custom aliases for ZSH

os='linux'
if [[ `uname` == "Darwin" ]]; then
    os='mac'
fi

BBLACK='\033[1;30m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
NC='\033[0m'
ONWHITE='\033[47m'

alias reload!='source ~/.zshrc'
alias c='clear'
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

# directory management
if command -v xdg-open &> /dev/null
then
    alias opwd='xdg-open .'
fi
# rsync without files specified in .gitignore
alias rsyncgit="rsync -ahrvz --include='**.gitignore' --exclude='/.git' --filter=':- .gitignore' --delete-after"

# fasd
# alias automatically generated by zsh plugin in zshrc
if command -v fasd &> /dev/null
then
#     alias a='fasd -a' # file dir
#     alias s='fasd -si' # rank interactive
#     alias d='fasd -d' # dir
#     alias f='fasd -f' # file
#     alias sd='fasd -sid'
#     alias sf='fasd -sif'
#     alias z='fasd_cd -d'
#     alias zz='fasd_cd -d -i'
#     alias v='f -e vim'
#     alias o='a -e xdg-open'

    unalias sd
    unalias sf
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

alias md='mkdir -p'
alias rd='rmdir'

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
alias ca='conda activate'
alias cel='conda env list'
alias cl='conda list'

# htop
if command -v htop &> /dev/null
then
    alias top='htop'
    alias topc='htop -s PERCENT_CPU'
    alias topm='htop -s PERCENT_MEM'
fi

# exa
# TODO: Add sort by size aliases
if command -v exa &> /dev/null
then
    alias ls='exa -F'
    alias la='exa -lahF'
    alias ll='exa -lhF'
    alias lag='exa -lahF --git'
    alias llg='exa -lhF --git'
    alias lt='exa -T'
    alias ltl='exa -T -L'

    alias lsrt='exa -lahF --sort'
    alias lsrtt='exa -lahF --sort=modified' # modified time by default: (modifed|accessed|changed)
    alias lsrts='exa -lahF --sort=size'
    alias lsrte='exa -lahF --sort=extension'
    alias lsrtn'exa -lahF --sort=name'

    alias l='exa -lahF'
else
    alias la='ls -al'
    alias ll='ls -l'
    if command -v tree &> /dev/null
    then
        alias lt='tree'
        alias ltl='tree -L'
    fi

    alias lsrt='ls -al --sort'
    alias lsrtt='ls -al --sort=time'
    alias lsrts='ls -al --sort=size'
    alias lsrte='ls -al --sort=extension'

    alias l='ls -al'
fi

# bat
if [[ $os == 'mac' ]] ;
then
    if command -v bat &> /dev/null
    then
        alias cat='bat'
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
    alais gs='watch -n 0.1 -d nvidia-smi'
fi

# git
if command -v git &> /dev/null
then
    function git_current_branch() {
        git branch --show-current
    }

    function git_main_branch() {
        def=`git remote show origin | sed -n '/HEAD branch/s/.*: //p'`
        echo $def
    }

    function git_develop_branch() {
        echo "develop"
    }

    alias g=git
    alias ga='git add'
    alias gaa='git add --all'
    alias gam='git am'
    alias gama='git am --abort'
    alias gamc='git am --continue'
    alias gams='git am --skip'
    alias gamscp='git am --show-current-patch'
    alias gap='git apply'
    alias gapa='git add --patch'
    alias gapt='git apply --3way'
    alias gau='git add --update'
    alias gav='git add --verbose'
    alias gb='git branch'
    alias gbD='git branch -D'
    alias gba='git branch -a'
    alias gbc='git branch --show-current | copy'
    alias gbd='git branch -d'
    alias gbda='git branch --no-color --merged | command grep -vE "^([+*]|\s*($(git_main_branch)|$(git_develop_branch))\s*$)" | command xargs git branch -d 2>/dev/null'
    alias gbl='git blame -b -w'
    alias gbnm='git branch --no-merged'
    alias gbr='git branch --remote'
    alias gbs='git bisect'
    alias gbsb='git bisect bad'
    alias gbsg='git bisect good'
    alias gbsr='git bisect reset'
    alias gbss='git bisect start'
    alias gc='git commit -v'
    alias 'gc!'='git commit -v --amend'
    alias gca='git commit -v -a'
    alias 'gca!'='git commit -v -a --amend'
    alias gcam='git commit -a -m'
    alias 'gcan!'='git commit -v -a --no-edit --amend'
    alias 'gcans!'='git commit -v -a -s --no-edit --amend'
    alias gcas='git commit -a -s'
    alias gcasm='git commit -a -s -m'
    alias gcb='git checkout -b'
    alias gcd='git checkout $(git_develop_branch)'
    alias gcf='git config --list'
    alias gcfix='git commit --fixup'
    alias gcl='git clone --recurse-submodules'
    alias gclean='git clean -id'
    alias gcm='git checkout $(git_main_branch)'
    alias gcmsg='git commit -m'
    alias 'gcn!'='git commit -v --no-edit --amend'
    alias gco='git checkout'
    alias gcor='git checkout --recurse-submodules'
    alias gcount='git shortlog -sn'
    alias gcp='git cherry-pick'
    alias gcpa='git cherry-pick --abort'
    alias gcpc='git cherry-pick --continue'
    alias gcs='git commit -S'
    alias gcsm='git commit -s -m'
    alias gcsquash='git commit --squash'
    alias gcss='git commit -S -s'
    alias gcssm='git commit -S -s -m'
    alias gd='git diff'
    alias gdca='git diff --cached'
    alias gdct='git describe --tags $(git rev-list --tags --max-count=1)'
    alias gdcw='git diff --cached --word-diff'
    alias gds='git diff --staged'
    alias gdt='git diff-tree --no-commit-id --name-only -r'
    alias gdup='git diff @{upstream}'
    alias gdw='git diff --word-diff'
    alias gf='git fetch'
    alias gfa='git fetch --all --prune --jobs=10'
    alias gfg='git ls-files | grep'
    alias gfo='git fetch origin'
    alias gg='git gui citool'
    alias gga='git gui citool --amend'
    alias ggpull='git pull origin "$(git_current_branch)"'
    alias ggpur=ggu
    alias ggpush='git push origin "$(git_current_branch)"'
    alias ggsup='git branch --set-upstream-to=origin/$(git_current_branch)'
    alias ghh='git help'
    alias gignore='git update-index --assume-unchanged'
    alias gignored='git ls-files -v | grep "^[[:lower:]]"'
    alias git-svn-dcommit-push='git svn dcommit && git push github $(git_main_branch):svntrunk'
    alias gk='\gitk --all --branches &!'
    alias gke='\gitk --all $(git log -g --pretty=%h) &!'
    alias gl='git pull'
    alias glg='git log --stat'
    alias glgg='git log --graph'
    alias glgga='git log --graph --decorate --all'
    alias glgm='git log --graph --max-count=10'
    alias glgp='git log --stat -p'
    alias glo='git log --oneline --decorate'
    alias globurl='noglob urlglobber '
    alias glod='git log --graph --pretty='\''%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset'\'
    alias glods='git log --graph --pretty='\''%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset'\'' --date=short'
    alias glog='git log --oneline --decorate --graph'
    alias gloga='git log --oneline --decorate --graph --all'
    alias glol='git log --graph --pretty='\''%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset'\'
    alias glola='git log --graph --pretty='\''%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset'\'' --all'
    alias glols='git log --graph --pretty='\''%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset'\'' --stat'
    alias glp=_git_log_prettily
    alias glum='git pull upstream $(git_main_branch)'
    alias gm='git merge'
    alias gma='git merge --abort'
    alias gmc='git merge --continue'
    alias gmom='git merge origin/$(git_main_branch)'
    alias gmtl='git mergetool --no-prompt'
    alias gmtlvim='git mergetool --no-prompt --tool=vimdiff'
    alias gmum='git merge upstream/$(git_main_branch)'
    alias gp='git push'
    alias gpd='git push --dry-run'
    alias gpf='git push --force-with-lease'
    alias 'gpf!'='git push --force'
    alias gpoat='git push origin --all && git push origin --tags'
    alias gpr='git pull --rebase'
    alias gpristine='git reset --hard && git clean -dffx'
    alias gpsup='git push --set-upstream origin $(git_current_branch)'
    alias gpu='git push upstream'
    alias gpv='git push -v'
    alias gr='git remote'
    alias gra='git remote add'
    alias grb='git rebase'
    alias grba='git rebase --abort'
    alias grbc='git rebase --continue'
    alias grbd='git rebase $(git_develop_branch)'
    alias grbi='git rebase -i'
    alias grbm='git rebase $(git_main_branch)'
    alias grbo='git rebase --onto'
    alias grbom='git rebase origin/$(git_main_branch)'
    alias grbs='git rebase --skip'
    alias grev='git revert'
    alias grh='git reset'
    alias grhh='git reset --hard'
    alias grm='git rm'
    alias grmc='git rm --cached'
    alias grmv='git remote rename'
    alias groh='git reset origin/$(git_current_branch) --hard'
    alias grrm='git remote remove'
    alias grs='git restore'
    alias grset='git remote set-url'
    alias grss='git restore --source'
    alias grst='git restore --staged'
    alias grt='cd "$(git rev-parse --show-toplevel || echo .)"'
    alias gru='git reset --'
    alias grup='git remote update'
    alias grv='git remote -v'
    alias gsb='git status -sb'
    alias gsd='git svn dcommit'
    alias gsh='git show'
    alias gsi='git submodule init'
    alias gsps='git show --pretty=short --show-signature'
    alias gsr='git svn rebase'
    alias gss='git status -s'
    alias gst='git status'
    alias gsta='git stash push'
    alias gstaa='git stash apply'
    alias gstall='git stash --all'
    alias gstc='git stash clear'
    alias gstd='git stash drop'
    alias gstl='git stash list'
    alias gstp='git stash pop'
    alias gsts='git stash show --text'
    alias gstu='gsta --include-untracked'
    alias gsu='git submodule update'
    alias gsw='git switch'
    alias gswc='git switch -c'
    alias gswd='git switch $(git_develop_branch)'
    alias gswm='git switch $(git_main_branch)'
    alias gtl='gtl(){ git tag --sort=-v:refname -n -l "${1}*" }; noglob gtl'
    alias gts='git tag -s'
    alias gtv='git tag | sort -V'
    alias gunignore='git update-index --no-assume-unchanged'
    alias gunwip='git log -n 1 | grep -q -c "\-\-wip\-\-" && git reset HEAD~1'
    alias gup='git pull --rebase'
    alias gupa='git pull --rebase --autostash'
    alias gupav='git pull --rebase --autostash -v'
    alias gupom='git pull --rebase origin $(git_main_branch)'
    alias gupomi='git pull --rebase=interactive origin $(git_main_branch)'
    alias gupv='git pull --rebase -v'
    alias gwch='git whatchanged -p --abbrev-commit --pretty=medium'
    alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign -m "--wip-- [skip ci]"'

    # REMIND: temporiary aliases for testing usability of new git commands
    # safe version of git rebase & checkout
    function grbsf() {
        git stash push && git rebase $1 $2 && git stash pop
    }
    function gcosf() {
        git stash push && git checkout $1 && git stash pop
    }
fi
