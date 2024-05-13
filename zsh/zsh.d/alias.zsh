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

# docker
# @https://github.com/akarzim/zsh-docker-aliases/blob/master/alias.zsh
alias dk='docker'
alias dka='docker attach'
alias dkb='docker build'
alias dkd='docker diff'
alias dkdf='docker system df'
alias dke='docker exec'
alias dkE='docker exec -e COLUMNS=`tput cols` -e LINES=`tput lines` -i -t'
alias dkh='docker history'
alias dki='docker images'
alias dkin='docker inspect'
alias dkim='docker import'
alias dkk='docker kill'
alias dkkh='docker kill -s HUP'
alias dkl='docker logs'
alias dkL='docker logs -f'
alias dkli='docker login'
alias dklo='docker logout'
alias dkls='docker ps'
alias dkp='docker pause'
alias dkP='docker unpause'
alias dkpl='docker pull'
alias dkph='docker push'
alias dkps='docker ps'
alias dkpsa='docker ps -a'
alias dkr='docker run'
alias dkR='docker run -e COLUMNS=`tput cols` -e LINES=`tput lines` -i -t --rm'
alias dkRe='docker run -e COLUMNS=`tput cols` -e LINES=`tput lines` -i -t --rm --entrypoint /bin/bash'
alias dkRM='docker system prune'
alias dkrm='docker rm'
alias dkrmi='docker rmi'
alias dkrn='docker rename'
alias dks='docker start'
alias dkS='docker restart'
alias dkss='docker stats'
alias dksv='docker save'
alias dkt='docker tag'
alias dktop='docker top'
alias dkup='docker update'
alias dkV='docker volume'
alias dkv='docker version'
alias dkw='docker wait'
alias dkx='docker stop'

## Container (C)
alias dkC='docker container'
alias dkCa='docker container attach'
alias dkCcp='docker container cp'
alias dkCd='docker container diff'
alias dkCe='docker container exec'
alias dkCE='docker container exec -e COLUMNS=`tput cols` -e LINES=`tput lines` -i -t'
alias dkCin='docker container inspect'
alias dkCk='docker container kill'
alias dkCl='docker container logs'
alias dkCL='docker container logs -f'
alias dkCls='docker container ls'
alias dkCp='docker container pause'
alias dkCpr='docker container prune'
alias dkCrn='docker container rename'
alias dkCS='docker container restart'
alias dkCrm='docker container rm'
alias dkCr='docker container run'
alias dkCR='docker container run -e COLUMNS=`tput cols` -e LINES=`tput lines` -i -t --rm'
alias dkCRe='docker container run -e COLUMNS=`tput cols` -e LINES=`tput lines` -i -t --rm --entrypoint /bin/bash'
alias dkCs='docker container start'
alias dkCss='docker container stats'
alias dkCx='docker container stop'
alias dkCtop='docker container top'
alias dkCP='docker container unpause'
alias dkCup='docker container update'
alias dkCw='docker container wait'

## Image (I)
alias dkI='docker image'
alias dkIb='docker image build'
alias dkIh='docker image history'
alias dkIim='docker image import'
alias dkIin='docker image inspect'
alias dkIls='docker image ls'
alias dkIpr='docker image prune'
alias dkIpl='docker image pull'
alias dkIph='docker image push'
alias dkIrm='docker image rm'
alias dkIsv='docker image save'
alias dkIt='docker image tag'
alias dkIf='function dkIf_(){ docker images -f "reference=*/*/$1*" -f "reference=*$1*" }; dkIf_'

## Volume (V)
alias dkV='docker volume'
alias dkVin='docker volume inspect'
alias dkVls='docker volume ls'
alias dkVpr='docker volume prune'
alias dkVrm='docker volume rm'

## Network (N)
alias dkN='docker network'
alias dkNs='docker network connect'
alias dkNx='docker network disconnect'
alias dkNin='docker network inspect'
alias dkNls='docker network ls'
alias dkNpr='docker network prune'
alias dkNrm='docker network rm'

## System (Y)
alias dkY='docker system'
alias dkYdf='docker system df'
alias dkYpr='docker system prune'

## Stack (K)
alias dkK='docker stack'
alias dkKls='docker stack ls'
alias dkKps='docker stack ps'
alias dkKrm='docker stack rm'

## Swarm (W)
alias dkW='docker swarm'

## CleanUp (rm)
# Clean up exited containers (docker < 1.13)
alias dkrmC='docker rm $(docker ps -qaf status=exited)'

# Clean up dangling images (docker < 1.13)
alias dkrmI='docker rmi $(docker images -qf dangling=true)'

# Pull all tagged images
alias dkplI='docker images --format "{{ .Repository }}" | grep -v "^<none>$" | xargs -L1 docker pull'

# Clean up dangling volumes (docker < 1.13)
alias dkrmV='docker volume rm $(docker volume ls -qf dangling=true)'

# Docker Machine (m)
alias dkm='docker-machine'
alias dkma='docker-machine active'
alias dkmcp='docker-machine scp'
alias dkmin='docker-machine inspect'
alias dkmip='docker-machine ip'
alias dkmk='docker-machine kill'
alias dkmls='docker-machine ls'
alias dkmpr='docker-machine provision'
alias dkmps='docker-machine ps'
alias dkmrg='docker-machine regenerate-certs'
alias dkmrm='docker-machine rm'
alias dkms='docker-machine start'
alias dkmsh='docker-machine ssh'
alias dkmst='docker-machine status'
alias dkmS='docker-machine restart'
alias dkmu='docker-machine url'
alias dkmup='docker-machine upgrade'
alias dkmv='docker-machine version'
alias dkmx='docker-machine stop'

# Docker Compose (c)
if [[ $(uname -s) == "Linux" ]]; then
    alias dkc='docker-compose'
    alias dkcb='docker-compose build'
    alias dkcB='docker-compose build --no-cache'
    alias dkccf='docker-compose config'
    alias dkccr='docker-compose create'
    alias dkcd='docker-compose down'
    alias dkce='docker-compose exec -e COLUMNS=`tput cols` -e LINES=`tput lines`'
    alias dkcev='docker-compose events'
    alias dkci='docker-compose images'
    alias dkck='docker-compose kill'
    alias dkcl='docker-compose logs'
    alias dkcL='docker-compose logs -f'
    alias dkcls='docker-compose ps'
    alias dkcp='docker-compose pause'
    alias dkcP='docker-compose unpause'
    alias dkcpl='docker-compose pull'
    alias dkcph='docker-compose push'
    alias dkcpo='docker-compose port'
    alias dkcps='docker-compose ps'
    alias dkcr='docker-compose run -e COLUMNS=`tput cols` -e LINES=`tput lines`'
    alias dkcR='docker-compose run -e COLUMNS=`tput cols` -e LINES=`tput lines` --rm'
    alias dkcrm='docker-compose rm'
    alias dkcs='docker-compose start'
    alias dkcsc='docker-compose scale'
    alias dkcS='docker-compose restart'
    alias dkct='docker-compose top'
    alias dkcu='docker-compose up'
    alias dkcU='docker-compose up -d'
    alias dkcv='docker-compose version'
    alias dkcx='docker-compose stop'
else
    alias dkc='docker compose'
    alias dkcb='docker compose build'
    alias dkcB='docker compose build --no-cache'
    alias dkccp='docker compose copy'
    alias dkccr='docker compose create'
    alias dkccv='docker compose convert'
    alias dkcd='docker compose down'
    alias dkce='docker compose exec -e COLUMNS=`tput cols` -e LINES=`tput lines`'
    alias dkcev='docker compose events'
    alias dkci='docker compose images'
    alias dkck='docker compose kill'
    alias dkcl='docker compose logs'
    alias dkcL='docker compose logs -f'
    alias dkcls='docker compose ls'
    alias dkcp='docker compose pause'
    alias dkcP='docker compose unpause'
    alias dkcpl='docker compose pull'
    alias dkcph='docker compose push'
    alias dkcpo='docker compose port'
    alias dkcps='docker compose ps'
    alias dkcr='docker compose run -e COLUMNS=`tput cols` -e LINES=`tput lines`'
    alias dkcR='docker compose run -e COLUMNS=`tput cols` -e LINES=`tput lines` --rm'
    alias dkcrm='docker compose rm'
    alias dkcs='docker compose start'
    alias dkcsc='docker-compose scale'
    alias dkcS='docker compose restart'
    alias dkct='docker compose top'
    alias dkcu='docker compose up'
    alias dkcU='docker compose up -d'
    alias dkcv='docker-compose version'
    alias dkcx='docker compose stop'
fi

