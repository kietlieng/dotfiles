alias krebuild="kpull && kbuild && kreplacelauncher"

function kterm() {
  kitty +kitten ssh "$1"
}

function kpull() {
  currentDir=$(pwd)
  cd ~/lab/repos/kitty
  git checkout go.mod
  git pull
  sed -i -e "s/go 1.23$/go 1.23.0/g" go.mod
  cd $currentDir
}

function kbuild() {
  cd ~/lab/repos/kitty
  ./dev.sh build
}

function kreplacelauncher() {
  fileNameDate=$(date +"%y%m%d%H%M")
#  sudo cp -rf /Applications/kitty.app /Applications/kitty.app.${fileNameDate}
  sudo mv -f /Applications/kitty.app /Applications/kitty.app.${fileNameDate}
  sudo cp -rf ~/lab/repos/kitty/kitty/launcher/kitty.app /Applications/.
}

function kfontdebug() {
  kitty --debug-font-fallback
}

function kfonts() {
  kitty +list-fonts --psnames
}

function ktheme() {

  switchTheme=$(ls -1 ~/.config/kitty/kitty-themes/themes | fzf)
  if [[ $switchTheme ]]; then

    echo "~/.config/kitty/kitty-themes/themes/$switchTheme"
    kitty @ set-colors -a ~/.config/kitty/kitty-themes/themes/$switchTheme

  fi

}
