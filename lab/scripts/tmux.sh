alias T='t -d'
alias TM='t -d main'
alias TT='t -d -t'
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


function tl() {
  t -l $@
}


function t() {

  local loadTarget=""
  local loadDir=~/lab/scripts/tmuxp
  local listMatches='f'

  local modeDetach='f'
  local modeTemplate='f'

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

      local titleUsed=''
      # generate title once before using
      gentitle
      local firstTitle="$RANDOM_TITLE"
      for yFile in "${targetFiles[@]}"; do

        if [[ $titleUsed ]]; then
          gentitle
          titleUsed=''
        fi


        if [[ $listMatches == 't' ]]; then
            pecho "$yFile"
        else

          if [[ $modeDetach == 't' ]]; then
            pecho "tmuxp load -d \"$yFile\""
            titleUsed='t'
            tmuxp load -d "$yFile"
          else
            titleUsed='t'

            # if not in a tmux session size is greater than 1, refrain from attaching and create all the sessions first
            if [[ $TMUX == '' ]] && [[ $fileSize -gt 1 ]]; then
              pecho "detaching |$TMUX| $fileSize"
              tmuxp load -d "$yFile" 
            else
              pecho "attaching |$TMUX| $fileSize"
              tmuxp load -a "$yFile" 
            fi
          fi

        fi

      done

      # attach to the first session
      if [[ $modeDetach == 'f' ]] && [[ $TMUX == '' ]] && [[ $fileSize -gt 1 ]]; then
        pecho "attach"
        tmux attach -t "$firstTitle"
      fi

    fi

    # this one works
    #results=$(find $loadDir -maxdepth 1 -iname "${loadTarget}.yaml")
    #targetFiles=$results
    #tmuxp load $(echo "$targetFiles" | tail -n 1)


  else

    echo "\nLoading $loadDir"
    ls "$loadDir"
    echo "\nSessions:"
    tmux ls
    echo -n "\ntmux default: "
    cat ~/.tmuxdefault

  fi

}

# kill last session
function tk() {
   
  local modeAll='f'
  local tmuxDefaultValue='.*'
  local tmuxTarget="$tmuxDefaultValue"
  local key=''

  while [[ $# -gt 0 ]]; do

    key="$1"
    shift

    case "$key" in
      '-a')
        modeAll='t'
        ;;
      *)
        tmuxTarget="${tmuxTarget}${key}${tmuxDefaultValue}"
        ;;
    esac
    
  done

  pecho "tmuxTarget $tmuxTarget"
  local confirmTermination='f'
  local currentSession=""
  local lastSession=''

  # if in tmux 
  if [[ $TMUX ]]; then
    lastSession=$(tmux display-message -p '#{session_name}')
  fi

  if [[ $tmuxTarget == "$tmuxDefaultValue" ]] && [[ $modeAll == 'f'  ]]; then

    currentSession=$(tmux ls 2>&1 | grep -v "no server running on" | awk -F':' '{print $1}' | head  -n 1)
    echo "Terminating session ... $currentSession"
    tmux kill-session

  else

    for iTmux in $(tmux ls 2>&1 | grep -v "no server running on" | awk -F':' '{print $1}'); do

      confirmTermination='f'
      pecho "iTmux $iTmux"
      pecho "tmuxTarget $tmuxTarget"
      if [[ $modeAll == 't' ]]; then
        confirmTermination='t'
      elif [[ $(echo "$iTmux" | grep -i "$tmuxTarget") ]]; then
        pecho "grep confirmed kill"
        confirmTermination='t'
      fi
      
      if [[ $confirmTermination == 't' ]]; then
        
        if [[ $lastSession != $iTmux ]]; then
          echo "Terminating session ... $iTmux"
          tmux kill-session -t "$iTmux"
        fi
      fi

    done
  fi

  if [[ $lastSession ]]; then
    echo "Terminating session ... $lastSession"
    tmux kill-session -t "$lastSession"
  fi

  echo "\nSessions:"
  tmux ls

}

# attach to last session
function ta() {

  local tmuxDefaultValue='.*'
  local tmuxTarget="$tmuxDefaultValue"
  local key=''

  while [[ $# -gt 0 ]]; do

    key="$1"
    shift

    case "$key" in
      *)
        tmuxTarget="${tmuxTarget}${key}${tmuxDefaultValue}"
        ;;
    esac
    
  done

  if [[ $tmuxTarget == "$tmuxDefaultValue" ]]; then
    echo "auto attach"
    tmux attach
  else
    for iTmux in $(tmux ls 2>&1 | grep -v "no server running on" | awk -F':' '{print $1}'); do
      if [[ $(echo "$iTmux" | grep -i "$tmuxTarget") ]]; then
        tmux attach -t "$iTmux"
        break
      fi

    done

  fi

}

function calltmuxcreatewindow() {
  
#  tmux display-message -p "#S"
#  echo "|$TMUX_PANE|$TMUX|"

  local key=''

  # need xargs to trim spaces
  local modeBackground='f'
  local currentSession=$(tmux display-message -p '#{session_name}')
  local currentWindow=$(tmux display-message -p '#{window_name}')
  local currentTemplate=$(cat ~/.tmuxdefault | xargs)

  while [[ $# -gt 0 ]]; do

    key="$1"
    shift

    case "$key" in
      '-background')
        modeBackground='t'
        ;;
      *)
        ;;
    esac
    
  done
  
  if [[ $currentTemplate == '' ]]; then
    currentTemplate="blank"
  fi

  pecho "current template |$currentTemplate|"
  
  # if you have one that's currently attached
  if [[ $currentSession ]]; then

    if [[ $modeBackground == 't' ]]; then

      pecho "attached background $currentTemplate"
      tmux send-keys -t "$currentSession:$currentWindow" "t $currentTemplate" Enter
      gecho "$currentTemplate"

    else

      pecho "attached nobackground $currentTemplate"
      tmux send-keys -t "$currentSession:$currentWindow" "t $currentTemplate" Enter

      # need to sleep and delay so tmux can create window to register
      wait
      sleep 1
      local newIndex=$(tmux list-windows -t "$currentSession" | tail -n 1 | awk -F':' '{ print $1 }')
      pecho "new index is $newIndex"
      tmux select-window -t "$currentSession:$newIndex"
      pecho "tmux select-window -t \"$currentSession:$newIndex\""

    fi

  else

    if [[ $modeBackground == 't' ]]; then
      pecho "unattached background"
      T $currentTemplate
    else
      pecho "unattached nobackground"
      t $currentTemplate
      ta # attached to terminal
    fi

  fi

}

# set tmux default value
function tdefault() {

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
