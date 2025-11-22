# alias mp="cmus-remote -p" # play

alias mpause "cmus-remote -u"    # pause
alias mrepeat "cmus-remote -R"    # repeat
# alias mnext "cmus-remote -n"    # next
alias mprevious "cmus-remote -r"    # previous
alias mprevious2 "mprevious && mprevious"         # previous 2
alias mshuffle "cmus-remote -S"    # shuffle
alias mqueue "cmus-remote -q"    # queue
alias mraw "cmus-remote --raw" # raw
alias mseekf "cmus-remote --seek +60" # seek
alias mseekb "cmus-remote --seek -60" # seek

function ml

  mraw "view 3" && mraw clear && mraw "add $MUSIC_DIRECTORY"
  mraw "view 2" && mraw clear && mraw "add $MUSIC_DIRECTORY"

end

function m

  set modeAttach ''
  set modeSearch ''
  set modePlay ''
  set key ''

  while test (count $argv) -gt 0

    set key "$argv[1]"
    set argv $argv[2..-1]

    switch $key
      case '-a'; set modeAttach 't'
      case '-p'; set modePlay 't'
      case '*'
        set modeSearch "$modeSearch.*$key.*"
    end

  end

  set hasMusic (tmux ls 2>&1 | grep -i music | awk -F':' '{print $1}')

  # echo "hasMusic $hasMusic"
  if [ "$hasMusic" ]

    if [ $modeAttach ]

      tmux attach -t "$hasMusic"

    else

      if [ $modePlay ]
        mpause
      else

        if [ $modeSearch ]

          # echo "searching $modeSearch"
          set results (ls $MUSIC_DIRECTORY | grep -i "$modeSearch" | string collect)
          set result (echo $results | head -n 1)
          echo -e "results:\n$results"
          
          if [ "$results" ]
            echo -e "\nplaying $result"
            cmus-remote -f "$MUSIC_DIRECTORY/$result"
          end

        else

          set qStatus (cmus-remote -Q | grep -i status | grep -io "stopped")

          if [ "$qStatus" != 'stopped' ]
            basename (cmus-remote -Q | grep -i file | awk '{ print $2 }')
          else
            mpause
          end

        end

      end

    end

  else

    t music

  end

end

function mnext 

  set qStatus (cmus-remote -Q | grep -i status | grep -io "stopped")
  set isRunning (ps aux | grep -i "cmus" | grep -v ".fish\|grep" | wc -l)

  echo "$isRunning"
  if test $isRunning -eq 0
    echo "cmus not running"
    m
    return
  end

  if [ "$qStatus" != 'stopped' ]
    cmus-remote -n
    return
  end

  mpause
  return

end
