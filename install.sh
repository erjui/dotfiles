#!/usr/bin/env bash
# REMIND. bash dotfiles are not supported yet.

RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
NC='\033[0m'

safe_link(){
    local src=$1
    local dst=$2

    if [[ -f $dst ]] || [[ -d $dst ]]; then
        read -p "$dst already exists. Override? [y/n] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            read -p "Backup $dst to $dst.bak? [y/n] " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                mv $dst $dst.bak
                # echo "Backup $dst to $dst.bak"
            else
                rm -rf $dst
                # echo "Override $dst"
            fi
            ln -s $src $dst
        else
            echo "Skip $dst"
        fi
    elif [[ -L $dst ]]; then # if broken symlink
        read -p "$dst is broken symlink. Override? [y/n] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm $dst
            ln -s $src $dst
        else
            echo "Skip $dst"
        fi
    else
        mkdir -p $(dirname $dst)
        echo "Link $src to $dst"
        ln -s $src $dst
    fi
}

automatic_link() {
    local src=$1
    local dst=$2

    if [[ -f $dst ]] || [[ -d $dst ]]; then
        echo "$dst already exists. Backup $dst to $dst.bak."
        mv $dst $dst.bak
        ln -s $src $dst
    elif [[ -L $dst ]]; then # if broken symlink
        echo "$dst is broken symlink. Remove $dst and reassign."
        rm $dst
        ln -s $src $dst
    else
        mkdir -p $(dirname $dst)
        echo "Link $src to $dst"
        ln -s $src $dst
    fi
}

DOTFILES=$(dirname $(readlink -f $0))
echo "dotfile absolute path: $DOTFILES"

symlink () {
    # zsh symlink
    safe_link $DOTFILES/zsh/zfunc ~/.zfunc
    safe_link $DOTFILES/zsh/zlogin ~/.zlogin
    safe_link $DOTFILES/zsh/zlogout ~/.zlogout
    safe_link $DOTFILES/zsh/zprofile ~/.zprofile
    safe_link $DOTFILES/zsh/zshenv ~/.zshenv
    safe_link $DOTFILES/zsh/zshrc ~/.zshrc
    safe_link $DOTFILES/zsh/p10k.zsh ~/.p10k.zsh
    safe_link $DOTFILES/zsh/prezto ~/.zprezto
    safe_link $DOTFILES/zsh/zpreztorc ~/.zpreztorc
    safe_link $DOTFILES/zsh/zplug ~/.zplug
    safe_link $DOTFILES/zsh ~/.zsh

    # bash symlink
    safe_link $DOTFILES/bash/bashrc ~/.bashrc

    # fzf symlink
    safe_link $DOTFILES/zsh/fzf ~/.fzf
    safe_link $DOTFILES/zsh/fzf.zsh ~/.fzf.zsh
    safe_link $DOTFILES/bash/fzf.bash ~/.fzf.bash

    # vim, neovim symlink
    safe_link $DOTFILES/vim/vimrc ~/.vimrc
    safe_link $DOTFILES/vim ~/.vim
    safe_link $DOTFILES/nvim ~/.config/nvim

    # nano symlink
    safe_link $DOTFILES/nano ~/.nano
    safe_link $DOTFILES/nano/nanorc ~/.nanorc

    # tmux symlink
    safe_link $DOTFILES/tmux/tmux.conf ~/.tmux.conf
    safe_link $DOTFILES/tmux ~/.tmux

    # git symlink
    safe_link $DOTFILES/git/.gitconfig ~/.gitconfig
    safe_link $DOTFILES/git/.gitignore ~/.gitignore

    # bin symlink
    safe_link $DOTFILES/bin ~/.bin
}

symlink_automatic () {
    # zsh symlink
    automatic_link $DOTFILES/zsh/zfunc ~/.zfunc
    automatic_link $DOTFILES/zsh/zlogin ~/.zlogin
    automatic_link $DOTFILES/zsh/zlogout ~/.zlogout
    automatic_link $DOTFILES/zsh/zprofile ~/.zprofile
    automatic_link $DOTFILES/zsh/zshenv ~/.zshenv
    automatic_link $DOTFILES/zsh/zshrc ~/.zshrc
    automatic_link $DOTFILES/zsh/p10k.zsh ~/.p10k.zsh
    automatic_link $DOTFILES/zsh/prezto ~/.zprezto
    automatic_link $DOTFILES/zsh/zpreztorc ~/.zpreztorc
    automatic_link $DOTFILES/zsh/zplug ~/.zplug
    automatic_link $DOTFILES/zsh ~/.zsh

    # bash symlink
    automatic_link $DOTFILES/bash/bashrc ~/.bashrc

    # fzf symlink
    automatic_link $DOTFILES/zsh/fzf ~/.fzf
    automatic_link $DOTFILES/zsh/fzf.zsh ~/.fzf.zsh
    automatic_link $DOTFILES/bash/fzf.bash ~/.fzf.bash

    # vim, neovim symlink
    automatic_link $DOTFILES/vim/vimrc ~/.vimrc
    automatic_link $DOTFILES/vim ~/.vim
    automatic_link $DOTFILES/nvim ~/.config/nvim

    # nano symlink
    automatic_link $DOTFILES/nano ~/.nano
    automatic_link $DOTFILES/nano/nanorc ~/.nanorc

    # tmux symlink
    automatic_link $DOTFILES/tmux/tmux.conf ~/.tmux.conf
    automatic_link $DOTFILES/tmux ~/.tmux

    # git symlink
    automatic_link $DOTFILES/git/.gitconfig ~/.gitconfig
    automatic_link $DOTFILES/git/.gitignore ~/.gitignore

    # bin symlink
    automatic_link $DOTFILES/bin ~/.bin
}

set_git_secret_config () {
    echo -e "${YELLOW}Set git secret config${NC}"

    if [ ! -f ~/.gitconfig.secret ];
    then
        touch ~/.gitconfig.secret

        echo -e "${YELLOW}Register git user name / email${NC}"
        echo -ne "${YELLOW}Enter your name: ${NC}"
        read username
        echo -ne "${YELLOW}Enter your email: ${NC}"
        read useremail

        git config --file ~/.gitconfig.secret user.name "$username"
        git config --file ~/.gitconfig.secret user.email "$useremail"

        echo -e "${YELLOW}Register git credential helper ${NC}"
        echo -e "${YELLOW}1. Do not register${NC}"
        echo -e "${YELLOW}2. Register permanently (store)${NC}"
        echo -e "${YELLOW}3. Regieter temporarily (cache)${NC}"
        echo -ne "${YELLOW}Enter your choice: ${NC}"
        read choice

        case $choice in
            1)
                ;;
            2|s|store)
                git config --file ~/.gitconfig.secret credential.helper "store"
                ;;
            3|c|cache)
                git config --file ~/.gitconfig.secret credential.helper "cache --timeout=3600"
                ;;
            *)
                echo -e "${RED}Invalid choice. ${NC}"
                ;;
        esac
        echo

        # print current .gitconfig.secret config
        echo -e "${GREEN}Current git secret config${NC}"
        echo -ne "${GREEN}user.name: ${NC}"; git config --file ~/.gitconfig.secret user.name
        echo -ne "${GREEN}user.email: ${NC}"; git config --file ~/.gitconfig.secret user.email
        echo -ne "${GREEN}credential.helper: ${NC}"; git config --file ~/.gitconfig.secret credential.helper
        echo
    else
        echo -e "${RED}~/.gitconfig.secret already exists. ${NC}"
        echo
    fi
}

update_submodule() {
    cd $DOTFILES
    git submodule update --init --recursive
}

case $1
in
    i*|interact)
        echo -e "${RED}| ${YELLOW}interactive installation ${RED}| ${NC}\n"
        symlink
        set_git_secret_config
        update_submodule
        ;;
    a*|auto)
        echo -e "${RED}| ${YELLOW}automatic installation ${RED}| ${NC}\n"
        symlink_automatic
        update_submodule
        ;;
    h*|help|*)
        echo "Usage: bash install.sh [OPTION]"
        echo "Options:"
        echo ""
        echo "  interact    Install interactively"
        echo "  auto        Install automatically"
        echo "  help        Print this help"
        echo ""
esac

