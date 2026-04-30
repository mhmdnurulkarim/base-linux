#Copy Config file
cd ~/base-arch-linux/i3\ by\ Karim2501

if [ -d ~/.config ]; then
  echo "config direktori detected, backup..."
  rm -rf ~/.config_old
  mkdir ~/.config_old && mv ~/.config/* ~/.config_old
  cp Config/* ~/.config -rf;
else
  echo "config no detected, install qtile config"
  mkdir ~/.config && cp Config/* ~/.config -rf;
fi

#Copy Source Code
if [ -f ~/.xinitrc ]; then
  echo "xinitrc detected, backup..."
  mv ~/.xinitrc ~/.xinitrc_old
  cp Script/xinitrc ~/ -rf && mv ~/xinitrc ~/.xinitrc;
else
  echo "xinitrc not detected, install..."
  cp Script/xinitrc ~/ -rf && mv ~/xinitrc ~/.xinitrc;
fi

if [ -f ~/.zshrc ]; then
  echo "zshrc detected, backup..."
  mv ~/.zshrc ~/.zshrc_old
  cp Script/zshrc ~/ -rf && mv ~/zshrc ~/.zshrc;
else
  echo "zshrc not detected, install..."
  cp Script/zshrc ~/ -rf && mv ~/zshrc ~/.zshrc;
fi

if [ -f ~/.p10k.zsh]; then
  echo "Powerlevel 10k detected, backup..."
  mv ~/.p10k.zsh ~/.p10k_old.zsh
  cp Script/p10k.zsh ~/ -rf && mv ~/p10k.zsh ~/.p10k.zsh;
else
  echo "PowerLevel 10k not detected, install..."
  cp Script/p10k.zsh ~/ -rf && mv ~/p10.zsh ~/.p10k.zsh;
fi

if [ -f ~/.zprofile ]; then
  echo "zprofile detected, backup..."
  mv ~/.zprofile ~/.zprofile_old
  cp Script/zprofile ~/ -rf && mv ~/zprofile ~/.zprofile;
else
  echo "zprofile not detected, install..."
  cp Script/zprofile ~/ -rf && mv ~/zprofile ~/.zprofile;
fi
if [ -f ~/.vimrc ]; then
  echo "vimrc detected, backup..."
  mv ~/.vimrc ~/.vimrc_old
  cp Script/vimrc ~/ -rf && mv ~/vimrc ~/.vimrc;
else
  echo "vimrc not detected, install..."
  cp Script/vimrc ~/ -rf && mv ~/vimrc ~/.vimrc;
fi

cp Pictures ~/ -rf

#Install font external
#if [ -d ~/.local/share/fonts ]; then
#  echo "some font detected, backup and install used font"
#  mkdir ~/.local/share/fonts_old && mv ~/.local/share/fonts ~/.local/share/fonts_old;
#else
#  echo "nothing detected fonts"
#  mkdir ~/.local/share/fonts;
#fi

#oh-my-zsh from git
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k

source ~/.zshrc
p10k configure
