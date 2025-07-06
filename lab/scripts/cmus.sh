# alias mp="cmus-remote -p" # play

alias mpause="cmus-remote -u"    # pause
alias mrepeat="cmus-remote -R"    # repeat
alias mnext="cmus-remote -n"    # next
alias mprevious="cmus-remote -r"    # previous
alias mprevious2="mprevious && mprevious"         # previous 2
alias mshuffle="cmus-remote -S"    # shuffle
alias mqueue="cmus-remote -q"    # queue
alias mraw="cmus-remote --raw" # raw
alias mseekf="cmus-remote --seek +60" # seek
alias mseekb="cmus-remote --seek -60" # seek
alias ml="mraw clear && mraw \"add $MUSIC_DIRECTORY\""

function mpl() {

  local results=$(ls $MUSIC_DIRECTORY | grep -i "$@")
  local result=$(echo $results | head -n 1)
  echo "results: $results"
  
  if [[ $results ]]; then
    echo "playing $result"
    cmus-remote -f "$result"
  fi

}
