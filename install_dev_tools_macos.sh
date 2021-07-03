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

ln -s .tmux.conf ~/.tmux.conf

echo Installing nvim...
brew install tree-sitter --HEAD
brew install nvim --HEAD

if [ $? -ne 0 ]; then
  echo "Something bad happened, we can't continue..."
  exit 1
fi

rm ~/.config/nvim/init.vim
ln -s .nvimrc ~/.config/nvim/init.vim
