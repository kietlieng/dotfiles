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
alias mla "ml -a"

function ml

  set modeAttach ''
  set modeSearch ''
  set modePlay ''
  set modeDir 'all'
  set modeAdd ''
  set dirList ''

  set key ''

  while test (count $argv) -gt 0

    set key "$argv[1]"
    set argv $argv[2..-1]

    switch $key
      case '-a'; set modeAdd 't'
      case '-c' 

        set dirList MUSIC_DIRECTORY_CODING
        set modeDir ''

      case '*'

        # add music if it exists
        # if [ -d "$MUSIC_DIRECTORY/$key" ]
        for mDir in (ls -1 $MUSIC_DIRECTORY | grep -i "$key")

          set dirList $dirList "$MUSIC_DIRECTORY/$mDir"
          set modeDir ''

        end

    end

  end


  if [ $modeDir = 'all' ]
    # set dirList (ls -1 $MUSIC_DIRECTORY)
    set dirList (find $MUSIC_DIRECTORY -maxdepth 1 -type d | tail -n+2)
  end

  # echo "dirList $dirList"
  mraw "view 3"
  # echo "view 3"
  if test -z $modeAdd
    mraw clear
  end

  for musicDir in $dirList

    if test -n $musicDir
      mraw "add $musicDir"
    end

  end

  mraw "view 2" 
  if test -z $modeAdd
    # echo "clear"
    mraw clear
  end


  set musicDirFirstTime ''

  for musicDir in $dirList

    if test -n $musicDir

      # if it's empty
      if test -z $musicDirFirstTime
        echo "$musicDir" > $MUSIC_DEFAULT
        set musicDirFirstTime "t"
      else
        echo "$musicDir" >> $MUSIC_DEFAULT
      end
      mraw "add $musicDir"
      echo "adding $musicDir"

    end

  end

end

function m

  set modeAttach ''
  set modeSearch ''
  set mideFileSearch ''
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
        set modeFileSearch $modeFileSearch "$key"
    end

  end

  set hasMusic (tmux ls 2>&1 | grep -i music | awk -F':' '{print $1}')
  set modeFileSearch (string join -- "*" $modeFileSearch)
  set modeFileSearch "*$modeFileSearch*"

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
          set foundIt (find $MUSIC_DIRECTORY -iname "$modeFileSearch" | string collect)
          set foundItFilter (echo "$foundIt" | grep -i -f $MUSIC_DEFAULT | head -n 1) # directories loaded if no match that means it's not loaded
          # echo "find $MUSIC_DIRECTORY -iname \"$modeFileSearch\""
          echo "find \"$modeFileSearch\""
          # echo "fileSearch $modeFileSearch"
          set shortName (string replace -a -i $MUSIC_DIRECTORY "" $foundIt)
					set shortName (string join "\n" $shortName)
					echo -e $shortName
					set shortFoundItFilter (string replace -a -i $MUSIC_DIRECTORY "" $foundItFilter)

          # echo -e "founditFilter\n$foundItFilter"

          # set musicFile (cmus-remote -Q | grep -i file | awk '{print $NF }')
          # set musicDir (dirname $musicFile)
          # echo "musicDir $musicDir"
          # set results (/bin/ls -1 $musicDir | grep -i "$modeSearch" | string collect)
          # set result (echo $results | head -n 1)
          # echo -e "results:\n$results"
          #
          if [ "$foundItFilter" ]
            echo -e "\nplaying $shortFoundItFilter"
            cmus-remote -f "$foundItFilter"
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
