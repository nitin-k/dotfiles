OUTPUT="$HOME/.backup/config/`date +%Y-%m-%d-%I:%M:%S`.config"
echo "Overwriting $HOME/.vimrc with .vimrc" >> $OUTPUT
diff .vimrc $HOME/.vimrc >> $OUTPUT
cp .vimrc $HOME/.vimrc
echo "Overwriting $HOME/.vim with folder .vim" >> $OUTPUT
cp -rf .vim $HOME/.vim
echo "Overwriting $HOME/.profile with .profile" >> $OUTPUT
diff .profile $HOME/.profile >> $OUTPUT
cp .profile $HOME/.profile
echo "Overwriting $HOME/.gitconfig with .gitconfig" >> $OUTPUT
diff .gitconfig $HOME/.gitconfig >> $OUTPUT
cp .gitconfig $HOME/.gitconfig

LINES=`wc -l $OUTPUT | cut -f1 -d' '`
if [ $LINES = "4" ] ;
  then
    echo "No changes made.";
    rm $OUTPUT
  else
    echo "Work complete.";
fi