#!/usr/bin/env bash

# zsh symlink
# ln -s ~/dotfiles/zsh ~/zsh
ln -s ~/dotfiles/zsh/zlogin ~/.zlogin
ln -s ~/dotfiles/zsh/zlogout ~/.zlogout
ln -s ~/dotfiles/zsh/zprofile ~/.zprofile
ln -s ~/dotfiles/zsh/zshrc ~/.zshrc
ln -s ~/dotfiles/zsh/p10k.zsh ~/.p10k.zsh

# vim symlink
# ln -s ~/dotfiles/vim ~/.vim
ln -s ~/dotfiles/vim/vimrc ~/.vimrc

# tmux symlink
# ln -s ~/dotfiles/tmux ~/.tmux # fix weird behavior
ln -s ~/dotfiles/tmux/tmux.conf ~/.tmux.conf

