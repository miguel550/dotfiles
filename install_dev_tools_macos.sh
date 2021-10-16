brew help > /dev/null
if [ $? -ne 0 ]; then
  echo "Please install brew before continuing https://brew.sh/"
  exit 1
fi


echo Installing tmux...
brew install tmux

if [ $? -ne 0 ]; then
  echo "Something bad happened, we can't continue..."
  exit 1
fi

ln -s ~/dotfiles/tmux.conf ~/.tmux.conf

echo Installing nvim...
brew install tree-sitter --HEAD
brew install nvim --HEAD

if [ $? -ne 0 ]; then
  echo "Something bad happened, we can't continue..."
  exit 1
fi

ln -s ~/dotfiles/nvim ~/.config/nvim

echo "Install vim-plug to install plugings in nvim"
echo "https://github.com/junegunn/vim-plug#unix-linux"


echo Installing karabiner elements...
brew install --cask karabiner-elements

if [ $? -ne 0 ]; then
  echo "Something bad happened, we can't continue..."
  exit 1
fi

ln -s ~/dotfiles/karabiner ~/.config/karabiner
