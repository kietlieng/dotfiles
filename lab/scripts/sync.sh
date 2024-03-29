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

    setopt localoptions rmstarsilent

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

    cp -rf ~/.config/kitty/* $dKittyDir/.

    cp -rf ~/lab/scripts/calls $dScriptDir/.
    cp -rf ~/lab/scripts/tmuxp $dScriptDir/.
    cp -rf ~/lab/scripts/applescript $dScriptDir/.
    cp -rf ~/lab/scripts/plot $dScriptDir/.

    find $sourceScript -maxdepth 1 -type f  -iname "*.sh" -exec cp {} ${dScriptDir}/. \;

    cd $destinationDir

}

function upad21() {
  
  echo "rsync -av compare.sh ~/lab/repos/edge/public-dns-repo/scripts/dnscompare.sh j-dnscompare:~/dnscompare/."
  rsync -av compare.sh ~/lab/repos/edge/public-dns-repo/scripts/dnscompare.sh j-dnscompare:~/dnscompare/.

}

function upcert() {

  echo -n "\n\nUpload runner6 "
  rsync -av -a --exclude='.git/' ~/lab/repos/cert-alert etadm@dev-runner6:~/.
  echo -n "\n\nUpload gltest server "
  rsync -av -a --exclude='.git/' ~/lab/repos/cert-alert centos@glupgrade:~/.
  echo -n "\n\nUpload prod aws ansible "
  rsync -av -a --exclude='.git/' ~/lab/repos/cert-alert j-ans:~/.

}

function upocto() {
  echo "up ans"
  rsync -av -a --exclude='.git/' ~/lab/repos/edge/dns-internal-prod  centos@j-ans:~/.
  echo "up 196"
  rsync -av -a --exclude='.git/' ~/lab/repos/edge/dns-internal-prod  j-196:~/.
}
