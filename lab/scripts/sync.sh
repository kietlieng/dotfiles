function synconsale() {
    scp -r j-ans:~/onsales $ONSALE_DIRECTORY
}

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

function syncdot() {

    sourceScript=~/lab/scripts
    destinationDir=~/lab/repos/dotfiles

    dConfigDir=${destinationDir}/config # config
    dFileDir=${destinationDir}/dotfiles # dot 
    dKittyDir=${dConfigDir}/kitty 

    # lab
    dLabDir=${destinationDir}/lab
    dScriptDir=${dLabDir}/scripts

    rm -rf $destinationDir/*

    # create directories
    mkdir -p $dConfigDir $dFileDir $dScriptDir $dKittyDir

    cp ~/.tmux.conf ${dFileDir}/.
    cp ~/.yabairc ${dFileDir}/.

    # copy init
    cp -rf ~/.config/nvim $dConfigDir/nvim
    rm -rf $dConfigDir/nvim/init.lua.*

    cp ~/.config/kitty/kitty.conf $dKittyDir/.

    cp -rf ~/lab/scripts/calls $dScriptDir/.
    cp -rf ~/lab/scripts/tmuxp $dScriptDir/.
    cp -rf ~/lab/scripts/applescript $dScriptDir/.
    cp -rf ~/lab/scripts/plot $dScriptDir/.

    find $sourceScript -maxdepth 1 -type f  -iname "*.sh" -exec cp {} ${dScriptDir}/. \;

}

function upcert() {

  rsync -av -a --exclude='.git/' ~/lab/repos/cert-alert dev-runner6:~/.
  rsync -av -a --exclude='.git/' ~/lab/repos/cert-alert gltest:~/.
  rsync -av -a --exclude='.git/' ~/lab/repos/cert-alert j-ans:~/.

}
