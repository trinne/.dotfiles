#!/bin/bash

# https://vimawesome.com/plugin/nerdtree-red
git clone git://github.com/scrooloose/nerdtree.git ~/.vim/pack/trinne/start/nerdtree
vim -u NONE -c "helptags ~/.vim/pack/trinne/start/nerdtree/doc" -c q

# https://vimawesome.com/plugin/surround-vim
git clone git://tpope.io/vim/surround.git ~/.vim/pack/trinne/start/surround
vim -u NONE -c "helptags ~/.vim/pack/trinne/start/surround/doc" -c q

# https://vimawesome.com/plugin/vim-fireplace
git clone git://tpope.io/vim/fireplace.git ~/.vim/pack/trinne/start/fireplace
vim -u NONE -c "helptags ~/.vim/pack/trinne/start/fireplace/doc" -c q

# https://vimawesome.com/plugin/vim-salve
git clone git://github.com/tpope/vim-salve.git ~/.vim/pack/trinne/start/vim-salve
git clone git://github.com/tpope/vim-projectionist.git ~/.vim/pack/trinne/start/vim-projectionist
git clone git://github.com/tpope/vim-dispatch.git ~/.vim/pack/trinne/start/vim-dispatch
git clone git://github.com/tpope/vim-fireplace.git ~/.vim/pack/trinne/start/vim-fireplace

# https://vimawesome.com/plugin/vim-airline-superman
git clone https://github.com/vim-airline/vim-airline.git ~/.vim/pack/trinne/start/vim-airline
vim -u NONE -c "helptags ~/.vim/pack/trinne/start/vim-airline/doc" -c q

git clone git://github.com/vim-airline/vim-airline-themes.git ~/.vim/pack/trinne/start/vim-airline-themes

# https://vimawesome.com/plugin/indentline
git clone git://github.com/yggdroot/indentline.git ~/.vim/pack/trinne/start/indentline
vim -u NONE -c "helptags ~/.vim/pack/trinne/start/indentline/doc" -c q

# https://vimawesome.com/plugin/rainbow-parentheses-vim
git clone git://github.com/kien/rainbow_parentheses.vim.git ~/.vim/pack/trinne/start/rainbow_parentheses.vim
vim -u NONE -c "helptags ~/.vim/pack/trinne/start/rainbow_parentheses.vim/doc" -c q

