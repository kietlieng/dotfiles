alias T='t -d'
alias TM='t -d main'
alias TT='t -d -t'
alias TE='t -d -t -embed'
alias tA='ta -f'
alias tdisplayoptions='tmux display-message -a | fzf'
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
alias te='t -t -embed'

function tl() {
  t -l $@
}

function tmsleep() { # sleep time before windows are created
  sleep .3
}

function t() {

  local loadTarget=''
  local loadDir=~/lab/scripts/tmuxp
  local listMatches=''
  local titleUsed=''
  local firstTitle=''
  local firstWindow=''

  local modeDetach=''
  local modeEmbed=''
  local modePopup=''
  local modeTemplate=''

  local currentTemplate=$(cat ~/.tmuxdefault | xargs)

  while [[ $# -gt 0 ]]; do

    key="$1"
    case "$key" in
      '-l' ) 
        listMatches='t'
        shift
        ;;
      '-d' ) 
        modeDetach='t'
        shift
        ;;
      '-t' ) 
        modeTemplate='t'
        shift
        ;;
      '-embed' ) 
        unset TMUX
        modeEmbed='-embed'
        shift
        ;;

      '-popup' ) 
        modePopup='-popup'
        shift
        ;;

      *)
        loadTarget="$loadTarget*$key*"
        shift
        ;;

    esac

  done

  # make sure the template is not blank otherwise you get overything
  if [[ $currentTemplate == '' ]]; then
    currentTemplate="blank"
  fi

  if [[ $modeTemplate == 't' ]]; then
    loadTarget="*$currentTemplate*"
  fi

#  echo "|$loadTarget|"
#  return

  if [[ $loadTarget != ""  ]]; then

    results=$(find $loadDir -maxdepth 1 -iname "${loadTarget}.yaml")
    #targetFiles=($results) # turn into array
    # remove returns and a list with spaces so we can turn into an array
    targetFiles=($(echo "$results" | sed -r 's/\n/ /g'))

    fileSize=$((${#targetFiles[@]}))

    #prinf "targetFiles %s\n" "${targetFiles[@]}"
    pecho "filesize |$fileSize|"

    if [[ $fileSize -eq 0 ]]; then

      pecho "no match"

    else

      # generate title once if it's not available 
      if [[ $RANDOM_TITLE1 == '' ]]; then
        gentitle
      fi

      firstTitle=''
      for yFile in "${targetFiles[@]}"; do

        pecho "RANDOM_TITLE $RANDOM_TITLE1"

        if [[ $listMatches ]]; then
          
            echo "$yFile"

        else

          titleUsed='t'
          if [[ $modeDetach == 't' ]]; then

            pecho "tmuxp load -d \"$yFile\""
            tmuxp load -d "$yFile"

          else

            # if not in a tmux session, size is greater than 1, and not set to embed.  Refrain from attaching and create all the sessions first
            if [[ $TMUX == '' ]] && [[ $fileSize -gt 1 ]] && [[ $modeEmbed == '' ]]; then

              pecho "detaching |$TMUX| $fileSize"
              tmuxp load -d "$yFile" 

            else

              pecho "attaching |$TMUX| $fileSize"
              tmuxp load -a "$yFile" 

              if [[ $modeEmbed ]]; then
                break
              fi

            fi

          fi

        fi

        if [[ $titleUsed ]]; then
          tmsleep
          if [[ $firstTitle == '' ]]; then
            firstTitle=$(tmux display-message -p '#{session_name}')
            firstWindow=$(tmux display-message -p '#{window_name}')
          fi
          gentitle
          titleUsed=''
        fi

      done

      # attach to the first session
      if [[ $modeDetach == '' ]] && [[ $TMUX == '' ]] && [[ $fileSize -gt 1 ]]; then

        pecho "firstTitle |$firstTitle|"

        if [[ $firstTitle ]]; then

          pecho "end attaching to $firstTitle:$firstWindow"

          if [[ $modeEmbed ]]; then

#            tmux send-keys -t "$firstTitle:$firstWindow" "unset TMUX" Enter
            trunsinglecommand "$firstTitle:$firstWindow" "unset TMUX" "$modeEmbed"

          fi

          tmsleep
          tmux attach -t "$firstTitle:$firstWindow"

        fi

      fi

    fi
#    tmdisplay

  else

    echo "\nProfile(s): $loadDir"
    ls "$loadDir"
    tmdisplay

  fi

}

# kill last session
function tk() {
   
  local modeAll=''
  local tmuxDefaultValue='.*'
  local tmuxTarget="$tmuxDefaultValue"
  local key=''

  while [[ $# -gt 0 ]]; do

    key="$1"
    shift

    case "$key" in
      '-a') modeAll='t' ;;
      *) tmuxTarget="${tmuxTarget}${key}${tmuxDefaultValue}" ;;
    esac
    
  done

  pecho "tmuxTarget $tmuxTarget"
  local confirmTermination='f'
  local inSession=''
  local inWindow=''
  local allSessions=$(tmux ls 2>&1 | grep -v "no server running on")
  local allSessionNames=$(echo $allSessions | awk -F':' '{print $1}')
  local allSessionSize=$(echo $allSessions | wc -l | xargs)

  local attachedSessions=$(echo $allSessions | grep -i "(attached)" | awk -F':' '{print $1}')
  local attachedSize=$(echo $attacheSessions | wc -l | xargs)
  local attachedSessions=$(echo $attachedSessions | tr '\n' ' ')

  # if in tmux 
  if [[ $TMUX ]]; then
    inSession=$(tmux display-message -p '#{session_name}')
    inWindow=$(tmux display-message -p '#{window_name}')
    pecho "Session is |$inSession|"
  fi

  local tmSize=$(tmux ls | wc -l | xargs)
  local foundSession=''

  # if without param
  if [[ $tmuxTarget == '.*' ]] && [[ ! $modeAll ]]; then

    for iTmuxSession in $(echo $allSessionNames); do

      if [[ $attachedSessions == *"$iTmuxSession"* ]]; then  # it's a sessions value that's attached 
    
        if [[ $inSession ]]; then # if we are in a session check it
          
          if [[ $inSession == $iTmuxSession ]]; then

            foundSession='t'

          fi

        fi
          
      else # kill the session then quit

        pecho "1Terminating session ... |$iTmuxSession|"
        echo "Terminating session ... $iTmuxSession"
        tmux kill-session -t "$iTmuxSession"
        break

      fi

    done

  else

    for iTmuxSession in $(echo $allSessionNames); do

      confirmTermination='f'
      pecho "iTmux $iTmuxSession tmuxTarget $tmuxTarget"
      if [[ $modeAll ]]; then
        confirmTermination='t'
      elif [[ $(echo "$iTmuxSession" | grep -i "$tmuxTarget") ]]; then
        pecho "grep confirmed kill"
        confirmTermination='t'
      fi
      
      if [[ $confirmTermination == 't' ]]; then
        
        if [[ $inSession != $iTmuxSession ]]; then
          pecho "2Terminating session ... $iTmuxSession"
          echo "Terminating session ... $iTmuxSession"
          tmux kill-session -t "$iTmuxSession"
        else
          pecho "2Found session $iTmuxSession"
          foundSession='t'
        fi

      fi

    done
  fi

  # if you have a session token and it's all mode or it's the last one then kill itself
  if [[ $inSession ]]; then 
    pecho "found insession all:$modeAll session:$foundSession size:$tmSize"
    if [[ $modeAll ]] || [[ $foundSession ]] && [[ $tmSize -eq 1 ]]; then
      pecho "3Terminating session ... $inSession:$inWindow"
      echo "Terminating session ... $inSession:$inWindow"
      tmux kill-session -t "$inSession:$inWindow"
    fi

  fi 

  tmdisplay

}

# attach to last session
function ta() {

  local tmuxDefaultValue='.*'
  local tmuxTarget="$tmuxDefaultValue"
  local modeFirst=''
  local key=''

  while [[ $# -gt 0 ]]; do

    key="$1"
    shift

    case "$key" in
      '-f')
        modeFirst='t'
        ;;
      *)
        tmuxTarget="${tmuxTarget}${key}${tmuxDefaultValue}"
        ;;
    esac
    
  done

  if [[ $tmuxTarget == "$tmuxDefaultValue" ]]; then
    echo "auto attach"
    if [[ $modeFirst ]]; then
      for iTmuxSession in $(tmux ls 2>&1 | grep -v "no server running on" | awk -F':' '{print $1}'); do
        tmux attach -t "$iTmuxSession"
        break
      done
    else
      tmux attach
    fi
  else
    for iTmuxSession in $(tmux ls 2>&1 | grep -v "no server running on" | awk -F':' '{print $1}'); do
      if [[ $(echo "$iTmuxSession" | grep -i "$tmuxTarget") ]]; then
        tmux attach -t "$iTmuxSession"
        break
      fi

    done

  fi

}

function tmtemplist() {
  ls -1 ~/lab/scripts/tmuxp/ | fzf
}

function tmpopup() {

  tmux send-keys -t $1 "bind-key -T copy-mode-vi 'C-q' send-keys 'C-g'" Enter
  tmux display-popup -d -E "tmux new-session -A -s scratch 'zsh -c \"interactive\"'"

}

function trunsinglecommand() {

  local argSessionWindow="$1"
  local argCommand="$2"
  shift
  shift

  local modeEmbed=''
  local key=''

  while [[ $# -gt 0 ]]; do

    key="$1"
    shift

    case "$key" in
      '-embed') modeEmbed='t' ;;
      *) ;;
    esac

  done

  if [[ ! $modeEmbed ]]; then
    tmux split-window -h -t "$argSessionWindow"
  fi

  tmux send-keys -t "$argSessionWindow" "$argCommand" Enter

  if [[ ! $modeEmbed ]]; then
    tmsleep
    tmsleep
    tmux kill-pane -t "$argSessionWindow"
  fi

}

function calltmuxcreatewindow() {
  
#  tmux display-message -p "#S"
#  echo "|$TMUX_PANE|$TMUX|"

  local key=''

  # need xargs to trim spaces
  local modeBackground=''
  local modeEmbed=''
  local modePopup=''

  local inSession=$(tmux display-message -p '#{session_name}')
  local inWindow=$(tmux display-message -p '#{window_name}')
  local currentTemplate=$(cat ~/.tmuxdefault | xargs)

  while [[ $# -gt 0 ]]; do

    key="$1"
    shift

    case "$key" in
      '-background')
        modeBackground='t'
        ;;
      '-embed')
        modeEmbed='-embed'
        ;;
      '-popup')
        modePopup='-popup'
        ;;
      *)
        ;;
    esac
    
  done
  
  if [[ $currentTemplate == '' ]]; then
    currentTemplate="blank"
  fi

  if [[ $modeEmbed ]] && [[ $TMUX ]]; then

    export TMUX_BACKUP=$TMUX
#    unset TMUX

#  else
#  
#    if [[ $TMUX_BACKUP ]]; then
#
#      export TMUX=$TMUX_BACKUP
#      unset TMUX_BACKUP
#
#    fi
#
  fi

  pecho "current template |$currentTemplate|"
  
  # if you have one that's currently attached
  if [[ $inSession ]]; then

    if [[ $modeBackground ]]; then

      pecho "attached background t:$currentTemplate s:$inSession w:$inWindow"

#      tmux send-keys -t "$inSession:$inWindow" "t $modeEmbed $currentTemplate" Enter
      if [[ $modePopup ]]; then
        tmpopup "$inSession:$inWindow" "t $modeEmbed $currentTemplate" "$modeEmbed"
      else
        trunsinglecommand "$inSession:$inWindow" "t $modeEmbed $currentTemplate" "$modeEmbed"
      fi

      gecho "$currentTemplate"

    else

      pecho "attached nobackground t:$currentTemplate s:$inSession w:$inWindow"

#      tmux send-keys -t "$inSession:$inWindow" "t $modeEmbed $currentTemplate" Enter
      if [[ $modePopup ]]; then
        tmpopup "$inSession:$inWindow" "t $modeEmbed $currentTemplate" "$modeEmbed"
      else
        trunsinglecommand "$inSession:$inWindow" "t $modeEmbed $currentTemplate" "$modeEmbed"
      fi

      wait # need to sleep and delay so tmux can create window to register
#      sleep 1
      tmsleep
      local newIndex=$(tmux list-windows -t "$inSession" | tail -n 1 | awk -F':' '{ print $1 }')
      pecho "new index is $newIndex $inSession:$newIndex"
      tmux select-window -t "$inSession:$newIndex"
      pecho "tmux select-window -t \"$inSession:$newIndex\""

    fi

  else

    if [[ $modeBackground ]]; then

      pecho "unattached background"
      T $currentTemplate

    else

      pecho "unattached nobackground"
      t $currentTemplate
      ta # attached to terminal

    fi

  fi

}


function tmdisplay() {

  local tmOutput=$(tmux ls 2>&1 | grep -v "no server running on")
  local tmSize=0

  if [[ $tmOutput ]]; then
    tmSize=$(echo $tmOutput | wc -l | xargs)
  fi

  echo "\nSession($tmSize): $(cat ~/.tmuxdefault)"
  echo "$tmOutput"

}

# set tmux default value
function td() {

  local key=''
  local tmuxdefault=""

  while [[ $# -gt 0 ]]; do

    key="$1"
    shift

    case "$key" in
      *)
        tmuxdefault="$key"
        ;;
    esac
    
  done

  echo "$tmuxdefault" > ~/.tmuxdefault

}
