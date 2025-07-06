# alias mp="cmus-remote -p" # play

alias mm="cmus-remote -u"    # pause
alias mr="cmus-remote -R"    # repeat
alias mn="cmus-remote -n"    # next
alias mp="cmus-remote -r"    # previous
alias mpp="mp && mp"         # previous 2
alias mS="cmus-remote -S"    # shuffle
alias mq="cmus-remote -q"    # queue
alias mR="cmus-remote --raw" # raw
alias ms="cmus-remote --seek +60" # seek
alias mP="cmus-remote --seek -60" # seek
alias ml='mR clear && mR "add ~/lab/music"'

function mpl() {

  local results=$(ls ~/lab/music | grep -i "$@")
  local result=$(echo $results | head -n 1)
  echo "results: $results"
  
  if [[ $results ]]; then
    echo "playing $result"
    cmus-remote -f "$result"
  fi

}
