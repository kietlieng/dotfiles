function synconsale() {
    scp -r j-ans:~/onsales $ONSALE_DIRECTORY
}

function syncto() {
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

function syncfrom() {
    echo "parameters $# pwd"
    targetpath=$(pwd)
    echo "rsync -avp lastcomp:$(pwd) ${targetpath%/*}"
    rsync -avp lastcomp:$(pwd) ${targetpath%/*}
}

function syncdot() {

    scriptPath=~/lab/scripts
    dotPath=~/lab/repos/dotfiles
    jumpsshPath=~/lab/repos/jumpssh
    jumpscriptPath=~/lab/repos/jumpScript
    dotFileDir=${dotPath}/dotfiles
    dotLabDir=${dotPath}/lab
    dotConfigDir=${dotPath}/config

    rm -rf $dotPath/*

    # create dot files
    mkdir -p $dotFileDir 
    mkdir -p $dotLabDir 
    mkdir -p $dotLabDir 
    mkdir -p $dotConfigDir

    cp ~/.tmux.conf ${dotFileDir}/.
    cp ~/.yabairc ${dotFileDir}/.
    cp -rf ~/.config/nvim $dotConfigDir/nvim
    rm -rf $dotConfigDir/nvim/init.lua.*

    find $scriptPath -maxdepth 1 -type f  -iname "*.sh" -exec cp {} ${dotLabDir}/. \;

    find $scriptPath -type f  -iname "jumpssh.sh" -exec cp {} ${jumpsshPath}/. \;
    find $scriptPath -type f  -iname "jumpscript.sh" -exec cp {} ${jumpscriptPath}/. \;

}

function upcert() {

  rsync -av -a --exclude='.git/' ~/lab/repos/cert-alert gltest:~/.
  # 172.31.100.249 jumper2
  rsync -av -a --exclude='.git/' ~/lab/repos/cert-alert j-ans:~/.

}
