# alias mp="cmus-remote -p" # play

alias mpause "cmus-remote -u"    # pause
alias mrepeat "cmus-remote -R"    # repeat
# alias mnext "cmus-remote -n"    # next
alias mprevious "cmus-remote -r"    # previous
alias mprevious2 "mprevious && mprevious"         # previous 2
alias mshuffle "cmus-remote -S"    # shuffle
alias mqueue "cmus-remote -q"    # queue
alias mraw "cmus-remote --raw" # raw
alias mseekf "cmus-remote --seek +30" # seek
alias mseekb "cmus-remote --seek -30" # seek
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
    set dirList (fd . --max-depth 1 --type dir $MUSIC_DIRECTORY | tail -n+2)
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
  set modePlay ''
  set key ''

  while test (count $argv) -gt 0

    set key "$argv[1]"
    set argv $argv[2..-1]

    switch $key
      case '-a'; set modeAttach 't'
      case '-p'; set modePlay 't'
      case '*'

        set modeSearch $modeSearch $key
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

			  if string length -q -- "$modeSearch"

					set modeSearch (string join -n -- '.*' $modeSearch)
					set modeSearch ".*$modeSearch.*"

          # echo "searching $modeSearch"
          set foundIt (fd -i "$modeSearch" --type file $MUSIC_DIRECTORY | string collect)
          set foundItFilter (echo "$foundIt" | grep -i -f $MUSIC_DEFAULT | head -n 1) # directories loaded if no match that means it's not loaded
          echo "fd \"$modeSearch\""
          # echo "fileSearch $modeSearch"
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

					set mStatus '▷'
					if [ $qStatus = 'paused' ]
						# set mStatus '□'
						set mStatus '⏸︎'
					end

					set musicFile (cmus-remote -Q | grep -i file | awk '{ print $2 }' | cut -d'/' -f6-)
					if test (string length "$musicFile") -gt 0
						set musicPosition (cmus-remote -Q | grep -i position | awk '{ print $2 }')
						set musicTotal (cmus-remote -Q | grep -i duration | awk '{ print $2 }')
						set per1 (math -s0 "(($musicPosition / $musicTotal) * 100)")
						set curMinutes (math -s0 "($musicPosition / 60)")
						set curSeconds (math -s0 "($musicPosition % 60)")
						set curSecondsPad (string repeat -n (math "2 - "(string length "$curSeconds")) "0") 
						set curSeconds "$curSecondsPad$curSeconds"
						set minutes (math -s0 "($musicTotal / 60)")
						set seconds (math -s0 "($musicTotal % 60)")
						set secondsPad (string repeat -n (math "2 - "(string length "$seconds")) "0") 
						set seconds "$secondsPad$seconds"
						# echo "padding |$seconds|"
						# set per1 (math -s0 "($per1 / 2)")
						set per2 (math -s0 "(100 - $per1)")
						set perTitle (printf "%2s" "$per1")
						set perbar1 (string repeat -n (math -s0 "$per1/5") "█")
						set perbar2 (string repeat -n (math -s0 "$per2/5") "░")
						echo -e "$mStatus $perTitle% $perbar1$perbar2 $curMinutes:$curSeconds/$minutes:$seconds\n$musicFile"
					else
						echo "0 stopped "
						set perbar2 (string repeat -n (math -s0 "100/5") "░")
						echo -e "⏸︎  0% $perbar2 0/0"
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
