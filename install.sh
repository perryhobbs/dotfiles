echo 'Enable key repeat (instead of char accents)...'
defaults write -g ApplePressAndHoldEnabled -bool false

echo 'Change /usr/local permissions (for brew)...'
sudo chown -R $(whoami) /usr/local/bin /usr/local/lib /usr/local/sbin
chmod u+w /usr/local/bin /usr/local/lib /usr/local/sbin

echo 'Install brew...'
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

echo 'Install git & github cli...'
# note: running git --version might prompt to install xcode & other tools
/usr/local/bin/brew install git
/usr/local/bin/brew install gh
git --version

echo 'Install bash...'
/usr/local/bin/brew install bash

echo 'Pull dotfiles repo...'
/usr/local/bin/gh repo clone perryhobbs/dotfiles

echo 'Link dotfiles & change shell...'
ln -svf ~/dotfiles/.bashrc ~/.bashrc
ln -svf ~/dotfiles/.profile ~/.profile
ln -svf ~/dotfiles/.vimrc ~/.vimrc
ln -svf ~/dotfiles/.tmux.conf ~/.tmux.conf
ln -svf ~/dotfiles/.git ~/.git
echo '/usr/local/bin/bash' | sudo tee -a /etc/shells
chsh -s /usr/local/bin/bash

echo 'Install et client...'
# note: make sure et-server installed & started on remote end 
/usr/local/bin/brew install MisterTea/et/e

echo 'done'
echo 'Login again for changes to take effect'
echo 'Also make sure to import iterm profile & vs code settings & keybindings
