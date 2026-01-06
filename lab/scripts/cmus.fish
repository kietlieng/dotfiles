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
alias mlc "ml -c"

function ml

  set modeAttach ''
  set modeSearch ''
  set modePlay ''
  set key ''
  set musicDir "$MUSIC_DIRECTORY_MAIN"

  while test (count $argv) -gt 0

    set key "$argv[1]"
    set argv $argv[2..-1]

    switch $key
      case '-c'; 
        set musicDir $MUSIC_DIRECTORY_CODING
      case '*'
        if [ -d "$MUSIC_DIRECTORY/$key" ]
          set musicDir "$MUSIC_DIRECTORY/$key"
        end
    end

  end

  echo "current musicDir $musicDir"
  mraw "view 3" && mraw clear && mraw "add $musicDir"
  mraw "view 2" && mraw clear && mraw "add $musicDir"

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
          set musicFile (cmus-remote -Q | grep -i file | awk '{print $NF }')
          set musicDir (dirname $musicFile)
          echo "musicDir $musicDir"
          set results (/bin/ls -1 $musicDir | grep -i "$modeSearch" | string collect)
          set result (echo $results | head -n 1)
          echo -e "results:\n$results"
          
          if [ "$results" ]
            echo -e "\nplaying $result"
            cmus-remote -f "$musicDir/$result"
          end

        else

          set qStatus (cmus-remote -Q | grep -i status | awk '{print $2}')

          if [ "$qStatus" != 'stopped' ]
            # basename (cmus-remote -Q | grep -i file | awk '{ print $2 }')
            cmus-remote -Q | grep -i file | awk '{ print $2 }' | cut -d'/' -f6-
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

  set qStatus (cmus-remote -Q | grep -i status | awk '{print $2}')
  set isRunning (ps aux | grep -i "cmus" | grep -v ".fish\|grep" | wc -l)

  echo "$isRunning"
  if test $isRunning -eq 0
    echo "cmus does not exists"
    m
    return
  end

  echo "status |$qStatus|"
  if [ "$qStatus" = 'stopped' ]
    echo "stopped"
    mpause
  else 
    echo "it's running next"
    cmus-remote -n
    return
  end


end
