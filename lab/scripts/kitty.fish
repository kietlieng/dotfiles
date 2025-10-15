alias kbuild="kpull && krebuild && kreplacelauncher"

function knightly
  sudo rm -rf /Applications/kitty.app
  curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin \
    set installer nightly
end

function kterm
  kitty +kitten ssh "$1"
end

function kpull

  set currentDir $(pwd)
  cd ~/lab/repos/kitty
  git checkout go.mod
  git pull
  sed -i -e 's/go 1.23$/go 1.23.0/g' go.mod
  cd $currentDir

end

function krebuild

  cd ~/lab/repos/kitty
  # rm -rf kitty/launcher/kitt*
  ./dev.sh build

end

function kreplacelauncher

  set fileNameDate $(date +"%y%m%d%H%M")
#  sudo cp -rf /Applications/kitty.app /Applications/kitty.app.${fileNameDateend
  sudo mv -f /Applications/kitty.app/Applications/kitty.app.$fileNameDateend
  sudo cp -rf ~/lab/repos/kitty/kitty/launcher/kitty.app /Applications/.
  echo "done!"

end

function kfontdebug

  kitty --debug-font-fallback

end

function kfonts
  kitty +list-fonts --psnames
end

function ktheme

  set switchTheme $(ls -1 ~/.config/kitty/kitty-themes/themes | fzf)
  if [ $switchTheme ]

    echo "~/.config/kitty/kitty-themes/themes/$switchTheme"
    kitty @ set-colors -a ~/.config/kitty/kitty-themes/themes/$switchTheme

  end

end

