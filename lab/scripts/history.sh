# call backup history today
# extend history limit
#
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=1000000
export SAVEHIST=$HISTSIZE

alias zhistrestore="cp ~/.merged_history ~/.zsh_history"

# experimenting with commands to
function xhistcom() {

    echo "$(history | tail -n 1 | awk '{$1="";print $0}')" > /tmp/lastcommand.txt
    vim /tmp/lastcommand.txt

}

hscrub() {

  currentLang=$LANG

  export LANG="C"
  echo "sed -ir \"/$1/Id\" ~/.zsh_history"
  sed -ir "/$1/Id" ~/.zsh_history
#  mv ~/.zsh_history.bak ~/.zsh_history

  export LANG=$currentLang

}

# history backup file
function hbackup() {

    local histDir=~/.config/zshhistory
    local currentTime=$(date +"%y%m%d")

    local hMergedCount=$(ls -l -B ~/.merged_history | awk '{print $2}' | sed 's/,//g')
    local hCount=$(ls -l -B ~/.zsh_history | awk '{print $2}' | sed 's/,//g')


    if [[ $hCount -lt $hMergedCount ]]; then
      echo "history has been truncated $hCount/$hMergedCount. Run zhistmerge zhistrestore to rebuild" 
    fi

    if [[ ! -f $histDir/.zsh_history.${currentTime} ]]; then

      cp ~/.zsh_history $histDir/.zsh_history.${currentTime}

    fi

}

# restore the merge function
function zhistmerge() {

  pushd ~/.config/zshhistory/
  ruby ~/lab/scripts/ruby/restorehistory.rb .zsh_history.* > ~/.merged_history
  popd
  ls -l ~/.merged_history

}
