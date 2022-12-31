#!/usr/bin/env bash

safe_link(){
    local src=$1
    local dest=$2

    if [ -f $dest ]; then
        read -p "$dest already exists. Override? [y/n] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm $dest
            ln -s $src $dest
        else
            echo "Skip $dest"
            return
        fi
    fi
}


# zsh symlink
safe_link ~/dotfiles/zsh/zlogin ~/.zlogin
safe_link ~/dotfiles/zsh/zlogout ~/.zlogout
safe_link ~/dotfiles/zsh/zprofile ~/.zprofile
safe_link ~/dotfiles/zsh/zshrc ~/.zshrc
safe_link ~/dotfiles/zsh/p10k.zsh ~/.p10k.zsh

safe_link ~/dotfiles/zsh/fzf ~/.fzf
safe_link ~/dotfiles/zsh/fzf.zsh ~/.fzf.zsh

# vim symlink
safe_link ~/dotfiles/vim/vimrc ~/.vimrc

# tmux symlink
safe_link ~/dotfiles/tmux/tmux.conf ~/.tmux.conf

