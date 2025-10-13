function syncmovies() {

  local set targetX '*'
  local set key ''

  while [[ $# -gt 0 ]]; do

    set key "$1"
    shift

    case "$key" in
      *) set targetX "${targetX}$key*" ;;
    esac

  done

  if [[ $targetX == '*' ]]; then
    echo "none"
    return
  else
    pwd
#    which rsync
    set modeCommand "rsync -av $targetX ~/lab/movies/." 
    echo "$modeCommand" | pbcopy
    echo "rsync -av $targetX ~/lab/movies/." | pbcopy
    rsync -av $targetX ~/lab/movies/.
  fi


}

function synctolast() {
    echo "parameters $# pwd"
    set targetpath $(pwd)
    if [[ $# -gt 1 ]];
    then
        echo "param $1"
        echo "rsync -avp $(pwd)/$1 lastcomp:${targetpath%/*}/$1"
        rsync -avp $(pwd)/$1 lastcomp:${targetpath%/*}/$1
    else
        echo "rsync -avp $(pwd) lastcomp:${targetpath%/*}"
        rsync -avp $(pwd) lastcomp:${targetpath%/*}
    fi
}

function syncfromlast() {
    echo "parameters $# pwd"
    set targetpath $(pwd)
    echo "rsync -avp lastcomp:$(pwd) ${targetpath%/*}"
    rsync -avp lastcomp:$(pwd) ${targetpath%/*}
}

function cpdot() {

    setopt localoptions rmstarsilent

    set sourceScript ~/lab/scripts
    set destinationDir ~/lab/repos/dotfiles

    set dBatDir ${destinationDir}/bat
    set dBrewDir ${destinationDir}/brew
    set dConfigDir ${destinationDir}/config
    set dDirenvDir ${destinationDir}/direnv
    set dFileDir ${destinationDir}/dotfiles
    set dYaziDir ${destinationDir}/yazi
    set dYaziDir ${destinationDir}/znosource

    # lab
    dLabDir=${destinationDir}/lab
    dScriptDir=${dLabDir}/scripts

    # puretheme
    dPure=${destinationDir}/.oh-my-zsh/themes/pure/

    rm -rf $destinationDir/*

    # create directories
    mkdir -p $dConfigDir $dFileDir $dScriptDir $dBrewDir $dPure $dYaziDir $dDirenvDir $dBatDir
  
    cd $dBrewDir
    brew bundle dump

    cp ~/.gitconfig ${dFileDir}/.
    cp ~/.yabairc ${dFileDir}/.
    cp ~/.zshrc ${dFileDir}/.
#    cp ~/.tmux.conf ${dFileDir}/.

    # copy init

    cp -rf ~/.config/kitty $dConfigDir/.
    cp -rf ~/.config/tmux $dConfigDir/.
    cp -rf ~/.config/nvim $dConfigDir/.
    cp -rf ~/.config/skhd $dConfigDir/.
    cp -rf ~/.config/yazi $dConfigDir/.
    cp -rf ~/.config/direnv $dConfigDir/.
    cp -rf ~/.config/bat $dConfigDir/.

    cp -rf ~/lab/scripts/calls $dScriptDir/.
    cp -rf ~/lab/scripts/tmuxp $dScriptDir/.
    cp -rf ~/lab/scripts/applescript $dScriptDir/.
    cp -rf ~/lab/scripts/plot $dScriptDir/.
    cp -rf ~/lab/scripts/python $dScriptDir/.
    cp -rf ~/lab/scripts/zlast $dScriptDir/.
    cp -rf ~/lab/scripts/ruby $dScriptDir/.
    cp -rf ~/lab/scripts/swift $dScriptDir/.
    cp -rf ~/lab/scripts/znosource $dScriptDir/.
#    cp -rf ~/lab/scripts/deprecated $dScriptDir/.

    cp ~/.oh-my-zsh/themes/pure/pure.zsh $dPure/.


    # rm $dConfigDir/nvim/init.lua.*
    rm $dConfigDir/kitty/kitty.conf.*
    rm $dConfigDir/kitty/kitty.*.conf

    find $sourceScript -maxdepth 1 -type f  -iname "*.sh" -exec cp {} ${dScriptDir}/. \;

    cd $destinationDir

}
