#!/usr/bin/env bash
# REMIND. bash dotfiles are not supported yet.

RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m'

safe_link(){
    local src=$1
    local dst=$2

    if [[ -f $dst ]] || [[ -d $dst ]]; then
        read -p "$dst already exists. Override? [y/n] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm $dst
            ln -s $src $dst
        else
            echo "Skip $dst"
        fi
    elif [[ -L $dst ]]; then # if broken symlink
        read -p "$dst is broken symlink. Override? [y/n] " -n 1 -r
        echo
        echo "Skip $dst"
    else
        echo "Link $src to $dst"
        ln -s $src $dst
    fi
}

DOTFILES=$(dirname $(readlink -f $0))
echo "dotfile absolute path: $DOTFILES"

symlink () {
    # zsh symlink
    safe_link $DOTFILES/zsh/zlogin ~/.zlogin
    safe_link $DOTFILES/zsh/zlogout ~/.zlogout
    safe_link $DOTFILES/zsh/zprofile ~/.zprofile
    safe_link $DOTFILES/zsh/zshrc ~/.zshrc
    safe_link $DOTFILES/zsh/p10k.zsh ~/.p10k.zsh
    safe_link $DOTFILES/zsh ~/.zsh

    safe_link $DOTFILES/zsh/fzf ~/.fzf
    safe_link $DOTFILES/zsh/fzf.zsh ~/.fzf.zsh

    # vim, neovim symlink
    safe_link $DOTFILES/vim/vimrc ~/.vimrc
    safe_link $DOTFILES/vim ~/.vim
    safe_link $DOTFILES/nvim ~/.config/nvim

    # tmux symlink
    safe_link $DOTFILES/tmux/tmux.conf ~/.tmux.conf
    safe_link $DOTFILES/tmux ~/.tmux

    # git symlink
    safe_link $DOTFILES/git/.gitconfig ~/.gitconfig
    safe_link $DOTFILES/git/.gitignore ~/.gitignore
}

set_git_secret_config () {
    if [ ! -f ~/.gitconfig.secret ];
    then
        touch ~/.gitconfig.secret

        echo -ne "${YELLOW}Enter your name: ${NC}"
        read username
        echo -ne "${YELLOW}Enter your email: ${NC}"
        read useremail

        git config --file ~/.gitconfig.secret user.name "$username"
        git config --file ~/.gitconfig.secret user.email "$useremail"
    else
        echo -e "${RED} ~/.gitconfig.secret already exists. ${NC}"
    fi
}


symlink
set_git_secret_config

