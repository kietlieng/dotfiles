# call backup history today
# extend history limit
#
set -gx HISTFILE "$HOME/.zsh_history"
set -gx HISTSIZE 1000000
set -gx SAVEHIST $HISTSIZE

alias zhistandmerge="zhistmerge && zhistrestore"
alias zhistrestore="cp ~/.merged_history ~/.zsh_history"

# experimenting with commands to
function xhistcom

    echo "$(history | tail -n 1 | awk '{$1="";print $0}')" > /tmp/lastcommand.txt
    vim /tmp/lastcommand.txt

end

function hscrub

  set currentLang $LANG

  set -gx LANG "C"
  echo "sed -ir \"/$1/Id\" ~/.zsh_history"
  sed -ir "/$1/Id" ~/.zsh_history
#  mv ~/.zsh_history.bak ~/.zsh_history

  set -gx LANG $currentLang

end

# history backup file
function hbackup

    set --local histDir ~/.config/zshhistory
    set --local currentTime $(date +"%y%m%d")

    set --local hMergedCount $(ls -l -B ~/.merged_history | awk '{print $2}' | sed 's/,//g')
    set --local hCount $(ls -l -B ~/.zsh_history | awk '{print $2}' | sed 's/,//g')

    if [ $hCount -lt $hMergedCount ]

      echo "history has been truncated $hCount/$hMergedCount. Run zhistandmerge (zhistmerge zhistrestore) to rebuild" 

    end

    if [ ! -f $histDir/.zsh_history.$currentTime ]

      cp ~/.zsh_history $histDir/.zsh_history.$currentTimeend

    end

end

# restore the merge function
function zhistmerge

  pushd ~/.config/zshhistory/
  ruby ~/lab/scripts/ruby/restorehistory.rb .zsh_history.* > ~/.merged_history
  popd
  ls -l ~/.merged_history

end

