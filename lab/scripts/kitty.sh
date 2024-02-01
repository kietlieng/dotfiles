function kterm() {
  kitty +kitten ssh "$1"
}

function kpull() {
  currentDir=$(pwd)
  cd ~/lab/repos/kitty
  git pull
  cd $currentDir
}

function kbuild() {
  cd ~/lab/repos/kitty
  ./dev.sh build
}

function kreplacelauncher() {
  fileNameDate=$(date +"%y%m%d%H%M")
  sudo cp -rf /Applications/kitty.app /Applications/kitty.app.${fileNameDate}
  sudo cp -rf ~/lab/repos/kitty/kitty/launcher/kitty.app /Applications/.
}

function kdebugfont() {
  kitty --debug-font-fallback
}

function kfonts() {
  kitty +list-fonts --psnames
}

