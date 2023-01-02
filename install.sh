#!/usr/bin/env bash

safe_link(){
    local src=$1
    local dst=$2

    if [ -f $dst ]; then
        read -p "$dst already exists. Override? [y/n] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm $dst
            ln -s $src $dst
        else
            echo "Skip $dst"
        fi
    else
        echo "Link $src to $dst"
        if [[ -d $src ]]; then
            mkdir -p $dst
        fi
        ln -s $src $dst
    fi
}


# zsh symlink
safe_link ~/dotfiles/zsh/zlogin ~/.zlogin
safe_link ~/dotfiles/zsh/zlogout ~/.zlogout
safe_link ~/dotfiles/zsh/zprofile ~/.zprofile
safe_link ~/dotfiles/zsh/zshrc ~/.zshrc
safe_link ~/dotfiles/zsh/p10k.zsh ~/.p10k.zsh
safe_link ~/dotfiles/zsh ~/.zsh

safe_link ~/dotfiles/zsh/fzf ~/.fzf
safe_link ~/dotfiles/zsh/fzf.zsh ~/.fzf.zsh

# vim symlink
safe_link ~/dotfiles/vim/vimrc ~/.vimrc
safe_link ~/dotfiles/vim ~/.vim

# tmux symlink
safe_link ~/dotfiles/tmux/tmux.conf ~/.tmux.conf
safe_link ~/dotfiles/tmux ~/.tmux

