alias T='t -a'
alias TE='t -a -t -embed'
alias TM='t -a main'
alias TT='t -a -t'
alias TTT='t -a -tt'
alias t2='tt && ttt'
alias tA='a -f'
alias tbrew='t brew'
alias tdisplayoptions='tmux display-message -a | fzf'
alias te='t -t -embed'
alias tka="tk -a"
alias tm1='tmux new-session'
alias tm2='tmux new-session \; split-window -v \; select-pane -U \; set-window-option synchronize-panes on \; attach'
alias tm3='tmux new-session \; split-window -v \; split-window -v \; select-pane -D \; set-window-option synchronize-panes on \; select-layout even-vertical \; attach'
alias tm4='tmux new-session \; split-window -h \; split-window -v \; select-pane -L \; split-window -v \; select-pane -U \; set-window-option synchronize-panes on \; attach'
alias tm5='tmux new-session \; split-window -h \; split-window -h \; split-window -h \; split-window -h \; select-pane -R \; set-window-option synchronize-panes on \; select-layout even-horizontal \; attach'
alias tm6='tmux new-session \; split-window -h \; split-window -h \; select-pane -L \; split-window -v \; select-pane -L \; split-window -v \; select-pane -L \; split-window -v \; select-pane -U \; set-window-option synchronize-panes on \; attach'
alias tm='t main'
alias tmh='tm2'
alias tmv2='tmux new-session \; split-window -h \; select-pane -L \; set-window-option synchronize-panes on \; attach'
alias tmv3='tmux new-session \; split-window -h \; split-window -h \; select-pane -R \; set-window-option synchronize-panes on \; select-layout even-horizontal \; attach'
alias tsource="tmux source ~/.tmux.conf"
alias tt='t -t'
alias ttt='t -tt'
alias mk='tk music'
alias ma='m -a'
alias tmupdate='t update'

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

  set hasMusic $(tmux ls 2>&1 | grep -i music | awk -F':' '{print $1}')

  if [ $hasMusic ]

    if [ $modeAttach ]

      tmux attach -t "$hasMusic"

    else

      if [ $modePlay ]
        mpause
      else

        if [ $modeSearch ]

          # echo "searching $modeSearch"
          set results (ls $MUSIC_DIRECTORY | grep -i "$modeSearch")
          set result (echo $results | head -n 1)
          echo "results:\n$results"
          
          if [ $results ]
            echo "\nplaying $result"
            cmus-remote -f "$MUSIC_DIRECTORY/$result"
          end

        else

          basename $(cmus-remote -Q | grep -i file | awk '{ print $2 }')

        end

      end

    end

  else

    t music

  end

end

# need watchexec service
function watchstart
  set countIt (ps aux | grep -i "watchexec.*calltmuxcallback" | wc -l | xargs)

  echo "counting |$countIt|"
  if test $countIt -lt 2 
    echo "starting"
    watchexec -W=/tmp/tmuxcallback calltmuxcallback &
  else
    echo "Already exists.  Quitting"
  end
end


function tl
  t -l $argv
end

function tmsleep # sleep time before windows are created

  set sleepRate .3

  if test (count $argv) -gt 0

    set newRate "$argv[1]"
    set sleepRate (math sleepRate * newRate)

  end

  pecho "$sleepRate"
  sleep $sleepRate
end

function t

  set loadTarget ''
  set loadDir ~/lab/scripts/tmuxp
  set listMatches ''
  set titleUsed ''
  set sessionName ''
  set paneName ''

  set modeDetach 't'
  set modeEmbed ''
  set modePopup ''
  set modeTemplate ''

  set currentTemplate $(cat ~/.tmuxdefault1 | xargs)
  set secondTemplate $(cat ~/.tmuxdefault2 | xargs)

  while test (count $argv) -gt 0

    set key "$argv[1]"
    set argv $argv[2..-1]

    switch "$key" 
      case '-l'; set listMatches 't'
      case '-a'; set modeDetach ''
      case '-tt'; set modeTemplate 'tt'
      case '-t'; set modeTemplate 't'
      case '-embed' 
        unset TMUX
        set modeEmbed '-embed'

      case '-popup'; set modePopup '-popup'
      case '*'; set loadTarget "$loadTarget*$key*"

    end

  end

  # make sure the template is not blank otherwise you get overything
  if [ "$currentTemplate" = '' ]
    set currentTemplate "blank"
  end

  if [ "$modeTemplate" = 't' ]
    set loadTarget "*$currentTemplate*"
  else if [ "$modeTemplate" = 'tt' ]
    set loadTarget "*$secondTemplate*"
  end

#  echo "|$loadTarget|"
#  return

  if [ $loadTarget ]

    set results $(find $loadDir -maxdepth 1 -iname "$loadTarget.yaml")
    #set targetFiles ($results) # turn into array
    # remove returns and a list with spaces so we can turn into an array
    set targetFiles (echo "$results" | sed -r 's/\n/ /g')

    set fileSize (count $targetFiles)

    #prinf "targetFiles %s\n" "$targetFiles"
    pecho "filesize |$fileSize|"

    if test $fileSize -eq 0

      pecho "no match"

    else

      # generate title once if it's not available 
      if [ "$RANDOM_TITLE1" = '' ]
        wondertitle
      end

      set sessionName ''
      for yFile in $targetFiles

#        pecho "RANDOM_TITLE $RANDOM_TITLE1"

        if [ $listMatches ]
          
            echo "$yFile"

        else

          set titleUsed 't'

          becho "load template $yFile"
          if [ "$modeDetach" = 't' ]

            pecho "tmuxp load -d $yFile"
            # tmuxp load -d "$yFile" &!
            tmuxp load -d "$yFile" &

          else

            # if not in a tmux session, size is greater than 1, and not set to embed.  Refrain from attaching and create all the sessions first
            if [ "$TMUX" = '' ] 
              and test $fileSize -gt 1 
              and [ "$modeEmbed" = '' ]

              pecho "detaching |$TMUX| $fileSize"
              # tmuxp load -d "$yFile" &!
              tmuxp load -d "$yFile" &

            else

              pecho "attaching |$TMUX| $fileSize"
              tmuxp load -a "$yFile" 

              if [ $modeEmbed ]
                break
              end

            end

          end

        end

        if [ $titleUsed ]
          tmsleep
          if [ "$sessionName" = '' ]
            set sessionName $(tmux display-message -p '#{session_name}')
            set paneName $(tmux display-message -p '#{window_name}')
          end
          wondertitle
          set titleUsed ''
        end

      end

      # attach to the first session
      if [ "$modeDetach" = '' ]
        and [ "$TMUX" = '' ] 
        test $fileSize -gt 1

        pecho "sessionName |$sessionName|"

        if [ $sessionName ]

          pecho "end attaching to $sessionName:$paneName"

          if [ $modeEmbed ]

#            tmux send-keys -t "$sessionName:$paneName" "unset TMUX" Enter
            tmrunsinglecommand "$sessionName:$paneName" "unset TMUX" "$modeEmbed"

          end

          tmsleep
          tmux attach -t "$sessionName:$paneName"

        end

      end

    end

  else

    echo -e "\nProfile(s): $loadDir"
    ls "$loadDir"
    tmdisplay

  end

end

# kill last session
function tk
   
  set modeAll ''
  set tmuxDefaultValue '.*'
  set tmuxTarget "$tmuxDefaultValue"
  set key ''

  while test (count $argv) -gt 0

    set key "$argv[1]"
    set argv $argv[2..-1]

    switch "$key" 

      case '-a'; set modeAll 't'
      case '*'; set tmuxTarget "$tmuxTarget$key$tmuxDefaultValue" 

    end
    
  end

  # becho "tmuxTarget $tmuxTarget"
  set confirmTermination 'f'
  set inSession ''
  set inWindow ''
  set allSessions $(tmux ls 2>&1 | grep -v "no server running on" | string collect)
  set allSessionNames $(echo $allSessions | awk -F':' '{print $1}' | string collect)
  set allSessionSize $(echo $allSessions | wc -l | xargs)

  set attachedSessions $(echo $allSessions | grep -i "(attached)" | awk -F':' '{print $1}')
  set attachedSize $(echo $attachedSessions | wc -l | xargs)
  set attachedSessions $(echo $attachedSessions | tr '\n' ' ')

  # if in tmux 
  if [ $TMUX ]
    set inSession $(tmux display-message -p '#{session_name}')
    set inWindow $(tmux display-message -p '#{window_name}')
    pecho "Session is |$inSession|"
  end

  set tmSize $(tmux ls 2>&1 | wc -l | xargs)
  set foundSession ''

  # echo "mode is $modeAll"
  # echo "allSessionNames $allSessionNames"
  # if without param
  if string match -iq '.*' $tmuxTarget 
    and [ "$modeAll" != 't' ]

    # echo "tmuxTarget $tmuxTarget"
    for iTmuxSession in $(echo $allSessionNames)
      # echo "session name to kill attachedSessions |$attachedSessions|"

      if string match -iq  "*$iTmuxSession*" $attachedSessions # it's a sessions value that's attached 
    
        if [ $inSession ] # if we are in a session check it
          
          if [ "$inSession" = $iTmuxSession ]

            set foundSession 't'

          end

        end
          
      else # kill the session then quit

        if string match -iqr "$tmuxTarget" $iTmuxSession

          pecho "1Terminating session ... |$iTmuxSession|"
          echo "Terminating session ... $iTmuxSession"
          # echo "tmux kill-session -t \"$iTmuxSession\""
          tmux kill-session -t "$iTmuxSession"
          break

        end

      end

    end

  else

    for iTmuxSession in $(echo $allSessionNames)

      set confirmTermination 'f'
      pecho "iTmux $iTmuxSession tmuxTarget $tmuxTarget"
      if [ $modeAll ]
        set confirmTermination 't'
      else if [ $(echo "$iTmuxSession" | grep -i "$tmuxTarget") ]
        pecho "grep confirmed kill"
        set confirmTermination 't'
      end
      
      if [ "$confirmTermination" = 't' ]
        
        if [ "$inSession" != "$iTmuxSession" ]
          pecho "2Terminating session ... $iTmuxSession"
          echo "2Terminating session ... $iTmuxSession"
          tmux kill-session -t "$iTmuxSession"
        else
          pecho "2Found session $iTmuxSession"
          set foundSession 't'
        end

      end

    end
  end

  # if you have a session token and it's all mode or it's the last one then kill itself
  if [ $inSession ]
    pecho "found insession all:$modeAll session:$foundSession size:$tmSize"
    if [ $modeAll ] 
      or [ $foundSession ] 
      and test $tmSize -eq 1
      pecho "3Terminating session ... $inSession:$inWindow"
      echo "3Terminating session ... $inSession:$inWindow"
      tmux kill-session -t "$inSession:$inWindow"
    end

  end

  tmdisplay

end

# attach to last session
function a

  set tmuxDefaultValue '.*'
  set tmuxTarget "$tmuxDefaultValue"
  set modeFirst ''
  set key ''

  while test (count $argv) -gt 0

    set key "$argv[1]"
    set argv $argv[2..-1]

    switch "$key" 

      case '-f'; set modeFirst 't'
      case '*'; set tmuxTarget "$tmuxTarget$key$tmuxDefaultValue"

    end
    
  end

  if [ "$tmuxTarget" = "$tmuxDefaultValue" ]
    echo "auto attach"
    if [ $modeFirst ]
      for iTmuxSession in $(tmux ls 2>&1 | grep -v "no server running on" | awk -F':' '{print $1}')
        tmux attach -t "$iTmuxSession"
        break
      end
    else
      tmux attach
    end
  else
    for iTmuxSession in $(tmux ls 2>&1 | grep -v "no server running on" | awk -F':' '{print $1}')
      if [ $(echo "$iTmuxSession" | grep -i "$tmuxTarget") ]
        tmux attach -t "$iTmuxSession"
        break
      end

    end

  end

end

function tmtemplist
  ls -1 ~/lab/scripts/tmuxp/ | fzf
end

function tmpopup

  set sessionName $(tmux display-message -p '#{session_name}')
  set paneName $(tmux display-message -p '#{window_name}')
  pecho "send session/pane $sessionName:$paneName"

  watchstart # start to watch for file

  tmux display-popup -d -E "tmux new-session -A -s scratch 'zsh -c \"popup $sessionName $paneName\"; exit'"
#  tmux display-popup -d -E "tmux new-session -A -s scratch 'zsh'"

end

function tmrunsinglecommand

  set argSessionWindow "$argv[1]"
  set argCommand "$argv[2]"
  set argv $argv[2..-1]
  set argv $argv[2..-1]

  set modeEmbed ''
  set key ''

  while test (count $argv) -gt 0

    set key "$argv[1]"
    set argv $argv[2..-1]

    switch "$key" 
      case '-embed'; set modeEmbed 't'
    end

  end

  if [ ! $modeEmbed ]
    becho "tmux split-window -h -t \"$argSessionWindow\""
    tmux split-window -h -t "$argSessionWindow"
  end

  becho "tmux send-keys -t \"$argSessionWindow\" \"$argCommand\" Enter"
  tmsleep 
  tmux send-keys -t "$argSessionWindow" "$argCommand" Enter

  if [ ! $modeEmbed ]
    tmsleep 2
    tmux kill-pane -t "$argSessionWindow"
  end

end

function calltmuxcreatewindow
  
#  tmux display-message -p "#S"
  tmgetsize
  pecho "|$TMUX_PANE|$TMUX|"
  set tmSize $(cat ~/.tmuxsize)
  
  if [ "$tmSize" = "0" ]
#    pecho "no size quitting"
    return
  end

  set key ''

  # need xargs to trim spaces
  set modeBackground ''
  set modeEmbed ''
  set modePopup ''

  set inSession $(tmux display-message -p '#{session_name}')
  set inWindow $(tmux display-message -p '#{window_name}')
  set currentTemplate $(cat ~/.tmuxdefault2 | xargs)
  set attachedSessions $(tmux ls 2>&1 | grep -i "(attached)" | awk -F':' '{print $1}')

  while test (count $argv) -gt 0

    set key "$argv[1]"
    set argv $argv[2..-1]

    switch "$key" 

      case '-background'; set modeBackground 't'
      case '-embed'; set modeEmbed '-embed'
      case '-popup'; set modePopup '-popup'

    end
    
  end
  
  if [ "$currentTemplate" = '' ]
    set currentTemplate "blank"
  end

  if [ $modeEmbed ] 
    and [ $TMUX ]

    export set TMUX_BACKUP $TMUX
#    unset TMUX

#  else
#  
#    if [ $TMUX_BACKUP ]
#
#      export set TMUX $TMUX_BACKUP
#      unset TMUX_BACKUP
#
#    end
#
  end

  pecho "current template |$currentTemplate|"
  
  # if you have one that's currently attached
  if [ $attachedSessions ]

    if [ $modeBackground ]

      pecho "attached background t:$currentTemplate s:$inSession w:$inWindow"

#      tmux send-keys -t "$inSession:$inWindow" "t $modeEmbed $currentTemplate" Enter
      if [ $modePopup ]
        pecho "insession backgroundmode popup"
        tmpopup "$inSession:$inWindow" "t $modeEmbed $currentTemplate" "$modeEmbed"
      else
        tmrunsinglecommand "$inSession:$inWindow" "t -a $modeEmbed $currentTemplate" "$modeEmbed"
      end

      gecho "$currentTemplate"

    else

      pecho "attached nobackground t:$currentTemplate s:$inSession w:$inWindow"

#      tmux send-keys -t "$inSession:$inWindow" "t $modeEmbed $currentTemplate" Enter
      if [ $modePopup ]
        pecho "insession popup"
        tmpopup "$inSession:$inWindow" "t $modeEmbed $currentTemplate" "$modeEmbed"
      else
        tmrunsinglecommand "$inSession:$inWindow" "t -a $modeEmbed $currentTemplate" "$modeEmbed"
      end

      wait # need to sleep and delay so tmux can create window to register
#      sleep 1
      tmsleep
      set newIndex $(tmux list-windows -t "$inSession" | tail -n 1 | awk -F':' '{ print $1 }')
      pecho "new index is $newIndex $inSession:$newIndex"
      tmux select-window -t "$inSession:$newIndex"
      pecho "tmux select-window -t \"$inSession:$newIndex\""

    end

  # else
  #
  #   if [ $modeBackground ]
  #
  #     pecho "unattached background"
  #     T $currentTemplate
  #
  #   else
  #
  #     pecho "unattached nobackground"
  #     t $currentTemplate
  #     ta # attached to terminal
  #
  #   end

  end

end



function calltmuxcreatewindowback
  
#  tmux display-message -p "#S"
  tmgetsize
  pecho "|$TMUX_PANE|$TMUX|"
  set tmSize $(cat ~/.tmuxsize)
  
  if [ "$tmSize" = "0" ]
#    pecho "no size quitting"
    return
  end

  set key ''

  # need xargs to trim spaces
  set modeBackground ''
  set modeEmbed ''
  set modePopup ''

  set inSession $(tmux display-message -p '#{session_name}')
  set inWindow $(tmux display-message -p '#{window_name}')
  set currentTemplate $(cat ~/.tmuxdefault2 | xargs)

  while test (count $argv) -gt 0

    set key "$argv[1]"
    set argv $argv[2..-1]

    switch "$key" 

      case '-background'; set modeBackground 't'
      case '-embed'; set modeEmbed '-embed'
      case '-popup'; set modePopup '-popup'

    end
    
  end
  
  if [ "$currentTemplate" = '' ]
    set currentTemplate "blank"
  end

  if [ $modeEmbed ]
    and [ $TMUX ]

    export set TMUX_BACKUP $TMUX
#    unset TMUX

#  else
#  
#    if [ $TMUX_BACKUP ]
#
#      export set TMUX $TMUX_BACKUP
#      unset TMUX_BACKUP
#
#    end
#
  end

  pecho "current template |$currentTemplate|"
  
  # if you have one that's currently attached
  if [ $inSession ]

    if [ $modeBackground ]

      pecho "attached background t:$currentTemplate s:$inSession w:$inWindow"

#      tmux send-keys -t "$inSession:$inWindow" "t $modeEmbed $currentTemplate" Enter
      if [ $modePopup ]
        pecho "insession backgroundmode popup"
        tmpopup "$inSession:$inWindow" "t $modeEmbed $currentTemplate" "$modeEmbed"
      else
        tmrunsinglecommand "$inSession:$inWindow" "t -a $modeEmbed $currentTemplate" "$modeEmbed"
      end

      gecho "$currentTemplate"

    else

      pecho "attached nobackground t:$currentTemplate s:$inSession w:$inWindow"

#      tmux send-keys -t "$inSession:$inWindow" "t $modeEmbed $currentTemplate" Enter
      if [ $modePopup ]
        pecho "insession popup"
        tmpopup "$inSession:$inWindow" "t $modeEmbed $currentTemplate" "$modeEmbed"
      else
        tmrunsinglecommand "$inSession:$inWindow" "t -a $modeEmbed $currentTemplate" "$modeEmbed"
      end

      wait # need to sleep and delay so tmux can create window to register
#      sleep 1
      tmsleep
      set newIndex $(tmux list-windows -t "$inSession" | tail -n 1 | awk -F':' '{ print $1 }')
      pecho "new index is $newIndex $inSession:$newIndex"
      tmux select-window -t "$inSession:$newIndex"
      pecho "tmux select-window -t \"$inSession:$newIndex\""

    end

  else

    if [ $modeBackground ]

      pecho "unattached background"
      T $currentTemplate

    else

      pecho "unattached nobackground"
      t $currentTemplate
      ta # attached to terminal

    end

  end

end

function tmgetsize

  set tmOutput (tmux ls 2>&1 | grep -v "no server running on")
  set tmSize 0

  # echo "tmOutput $tmOutput"

  if [ "$tmOutput" ]
    set tmSize $(echo $tmOutput | wc -l | xargs)
  end

  echo "$tmSize" > ~/.tmuxsize

  if test (count $argv) -gt 0
    echo "$tmSize"
  end

end

function tmdisplay

  set tmSize $(tmgetsize x)
  set tmOutput $(tmux ls 2>&1 | grep -v "no server running on" | string collect)

  echo -e "$tmSize" > ~/.tmuxsize
  echo -e "\nSession($tmSize): $(cat ~/.tmuxdefault1) / $(cat ~/.tmuxdefault2)"
  echo -e "$tmOutput"

end

# set tmux default value
function tdef

  set key ''
  set tmuxdefault1 "$(cat ~/.tmuxdefault1)"
  set tmuxdefault2 "$(cat ~/.tmuxdefault2)"
  set key ""

  if test (count $argv) -gt 0

    set key "$argv[1]"
    set argv $argv[2..-1]
    
    if [ "$key" != "- " ]
      set tmuxdefault1 "$key"
      echo "$tmuxdefault1" > ~/.tmuxdefault1
    end

  end

  if test (count $argv) -gt 0

    set key "$argv[1]"
    set argv $argv[2..-1]
    
    if [ "$key" != "- " ]
      set tmuxdefault2 "$key"
      echo "$tmuxdefault2" > ~/.tmuxdefault2
    end

  end

  echo "Setting template to: $tmuxdefault1 / $tmuxdefault2 ..."

end

function calltmuxcallback

  set hasvalue $(find /tmp/ -iname "tmuxcallback" -mmin -1 2>/dev/null)

  if [ $hasvalue ]

    tmux kill-session -t scratch
    set tmuxpopupcall $(cat /tmp/tmuxcallback)
    echo "callback $tmuxpopupcall"
    eval "$tmuxpopupcall"
  end

end

