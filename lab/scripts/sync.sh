function synctolast() {
    echo "parameters $# pwd"
    targetpath=$(pwd)
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
    targetpath=$(pwd)
    echo "rsync -avp lastcomp:$(pwd) ${targetpath%/*}"
    rsync -avp lastcomp:$(pwd) ${targetpath%/*}
}

function cpdot() {

    setopt localoptions rmstarsilent

    sourceScript=~/lab/scripts
    destinationDir=~/lab/repos/dotfiles

    dConfigDir=${destinationDir}/config # config
    dFileDir=${destinationDir}/dotfiles # dot 
    dBrewDir=${destinationDir}/brew # brew

    # lab
    dLabDir=${destinationDir}/lab
    dScriptDir=${dLabDir}/scripts

    # puretheme
    dPure=${destinationDir}/.oh-my-zsh/themes/pure/

    rm -rf $destinationDir/*

    # create directories
    mkdir -p $dConfigDir $dFileDir $dScriptDir $dBrewDir $dPure 
  
    cd $dBrewDir
    brew bundle dump

#    cp ~/.tmux.conf ${dFileDir}/.
    cp ~/.yabairc ${dFileDir}/.

    # copy init

    cp -rf ~/.config/kitty $dConfigDir/.
    cp -rf ~/.config/tmux $dConfigDir/.
    cp -rf ~/.config/nvim $dConfigDir/.
    cp -rf ~/.config/skhd $dConfigDir/.

    cp -rf ~/lab/scripts/calls $dScriptDir/.
    cp -rf ~/lab/scripts/tmuxp $dScriptDir/.
    cp -rf ~/lab/scripts/applescript $dScriptDir/.
    cp -rf ~/lab/scripts/plot $dScriptDir/.
    cp -rf ~/lab/scripts/python $dScriptDir/.
    cp -rf ~/lab/scripts/zlast $dScriptDir/.
#    cp -rf ~/lab/scripts/deprecated $dScriptDir/.

    cp ~/.oh-my-zsh/themes/pure/pure.zsh $dPure/.


    rm -rf $dConfigDir/nvim/init.lua.*
    rm -rf $dConfigDir/kitty/kitty.conf.*

    find $sourceScript -maxdepth 1 -type f  -iname "*.sh" -exec cp {} ${dScriptDir}/. \;

    cd $destinationDir

}
