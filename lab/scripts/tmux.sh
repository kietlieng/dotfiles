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

function tsleep() {
  sleep .3
}

function t() {

  local loadTarget=''
  local loadDir=~/lab/scripts/tmuxp
  local listMatches=''
  local titleUsed=''
  local firstTitle=''

  local modeDetach=''
  local modeEmbed=''
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
        modeEmbed='t'
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
          tsleep
          if [[ $firstTitle == '' ]]; then
            firstTitle=$(tmux display-message -p '#{session_name}')
          fi
          gentitle
          titleUsed=''
        fi

      done

      # attach to the first session
      if [[ $modeDetach == '' ]] && [[ $TMUX == '' ]] && [[ $fileSize -gt 1 ]]; then

        pecho "firstTitle |$firstTitle|"

        if [[ $firstTitle ]]; then

          pecho "end attaching to $firstTitle"

          if [[ $modeEmbed ]]; then
            tmux send-keys -t "$firstTitle" "unset TMUX" Enter
          fi

          tsleep
          tmux attach -t "$firstTitle"

        fi

      fi

    fi

    tmuxlist

  else

    echo "\nLoading $loadDir"
    ls "$loadDir"
    tmuxlist

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
#  local currentSession=""
  local inSession=''

  # if in tmux 
  if [[ $TMUX ]]; then
    inSession=$(tmux display-message -p '#{session_name}')
    pecho "Session is |$inSession|"
  fi

  local tsSize=$(tmux ls | wc -l | xargs)
  local foundSession=''
  if [[ $tmuxTarget == "$tmuxDefaultValue" ]] && [[ $modeAll == 'f'  ]]; then

    for iTmuxSession in $(tmux ls 2>&1 | grep -v "no server running on" | awk -F':' '{print $1}' | head -n 2); do

      if [[ $inSession != $iTmuxSession ]]; then
        pecho "1Terminating session ... $iTmuxSession"
        echo "Terminating session ... $iTmuxSession"
        tmux kill-session -t "$iTmuxSession"
        break
      else
        foundSession='t'
      fi

    done

  else

    for iTmuxSession in $(tmux ls 2>&1 | grep -v "no server running on" | awk -F':' '{print $1}'); do

      confirmTermination='f'
      pecho "iTmux $iTmuxSession"
      pecho "tmuxTarget $tmuxTarget"
      if [[ $modeAll == 't' ]]; then
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
          foundSession='t'
        fi
      fi

    done
  fi

  # if you have a session token and it's all mode or it's the last one then kill itself
  if [[ $inSession ]]; then 

    if [[ $modeAll == 't' ]] || [[ $foundSession ]] && [[ $tsSize -eq 1 ]]; then
      pecho "3Terminating session ... $inSession"
      echo "Terminating session ... $inSession"
      tmux kill-session -t "$inSession"
    fi

  fi 

  tmuxlist

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

function calltmuxcreatewindow() {
  
#  tmux display-message -p "#S"
#  echo "|$TMUX_PANE|$TMUX|"

  local key=''

  # need xargs to trim spaces
  local modeBackground=''
  local modeEmbed=''
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
      *)
        ;;
    esac
    
  done
  
  if [[ $currentTemplate == '' ]]; then
    currentTemplate="blank"
  fi

  if [[ $modeEmbed ]] && [[ $TMUX ]]; then

    unset TMUX

  fi

  pecho "current template |$currentTemplate|"
  
  # if you have one that's currently attached
  if [[ $inSession ]]; then

    if [[ $modeBackground ]]; then

      pecho "attached background t:$currentTemplate s:$inSession w:$inWindow"
      tmux send-keys -t "$inSession:$inWindow" "t $modeEmbed $currentTemplate" Enter
      gecho "$currentTemplate"

    else

      pecho "attached nobackground t:$currentTemplate s:$inSession w:$inWindow"
      tmux send-keys -t "$inSession:$inWindow" "t $modeEmbed $currentTemplate" Enter
      wait # need to sleep and delay so tmux can create window to register
#      sleep 1
      tsleep
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


function tmuxlist() {

  tsSize=$(tmux ls 2>&1 | grep -v "no server running on" | wc -l | xargs)
  echo "\nSessions: ($tsSize)"
  tmux ls
  echo -n "\ntmux default: "
  cat ~/.tmuxdefault

}

# set tmux default value
function tdef() {

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
