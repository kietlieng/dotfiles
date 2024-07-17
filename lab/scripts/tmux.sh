alias T='t -d'
alias tt='t -t'
alias TT='t -d -t'
alias TM='t -d main'
alias tm='t main'
alias tmh='tm2'
alias tm1='tmux new-session'
alias tm2='tmux new-session \; split-window -v \; select-pane -U \; set-window-option synchronize-panes on \; attach'
alias tmv2='tmux new-session \; split-window -h \; select-pane -L \; set-window-option synchronize-panes on \; attach'
alias tm3='tmux new-session \; split-window -v \; split-window -v \; select-pane -D \; set-window-option synchronize-panes on \; select-layout even-vertical \; attach'
alias tmv3='tmux new-session \; split-window -h \; split-window -h \; select-pane -R \; set-window-option synchronize-panes on \; select-layout even-horizontal \; attach'
alias tm4='tmux new-session \; split-window -h \; split-window -v \; select-pane -L \; split-window -v \; select-pane -U \; set-window-option synchronize-panes on \; attach'
alias tm5='tmux new-session \; split-window -h \; split-window -h \; split-window -h \; split-window -h \; select-pane -R \; set-window-option synchronize-panes on \; select-layout even-horizontal \; attach'
alias tm6='tmux new-session \; split-window -h \; split-window -h \; select-pane -L \; split-window -v \; select-pane -L \; split-window -v \; select-pane -L \; split-window -v \; select-pane -U \; set-window-option synchronize-panes on \; attach'
alias tsource="tmux source ~/.tmux.conf"


function tl() {
  t -l $@
}

function t() {

  local loadTarget=""
  local loadDir=~/lab/scripts/tmuxp
  local listMatches='f'
  local detachmode='f'
  local templateMode='f'
  local currentTemplate=$(cat ~/.tmuxdefault)

  while [[ $# -gt 0 ]]; do

    key="$1"
    case "$key" in
      '-l' ) 
        listMatches='t'
        shift
        ;;
      '-d' ) 
        detachmode='t'
        shift
        ;;
      '-t' ) 
        templateMode='t'
        shift
        ;;
      *)
        loadTarget="$loadTarget*$key*"
        shift
        ;;

    esac

  done

  if [[ $templateMode == 't' ]]; then

    loadTarget="*$currentTemplate*"

  fi

  if [[ $loadTarget != ""  ]]; then

    results=$(find $loadDir -maxdepth 1 -iname "${loadTarget}.yaml")
    #targetFiles=($results) # turn into array
    # remove returns and a list with spaces so we can turn into an array
    targetFiles=($(echo "$results" | sed -r 's/\n/ /g'))

    fileSize=${#targetFiles[@]}

    #prinf "targetFiles %s\n" "${targetFiles[@]}"
    #pecho "filesize $fileSize"

    fileIndex=1

    if [[ $fileSize -eq 0 ]]; then

      pecho "no match"

    else

      for yFile in "${targetFiles[@]}"; do

        #pecho "index is $fileIndex"

        if [[ $listMatches == 't' ]]; then
            pecho "$yFile"
        else

          gentitle
          # attach to th elast index only? 
          if [[ $fileIndex -lt $fileSize ]]; then


            if [[ $detachmode == 't' ]]; then
              pecho "tmuxp load -d \"$yFile\""
              tmuxp load -d "$yFile"
            else
              tmuxp load -a "$yFile" 
            fi

          else

            if [[ $detachmode == 't' ]]; then

              pecho "begin tmuxp load -d \"$yFile\""
              tmuxp load -d "$yFile"

            else

              pecho "begin tmuxp load -a \"$yFile\"" 
              pecho "RANDOM_TITLE -a \"$yFile\" $RANDOM_TITLE" 
              tmuxp load -a "$yFile"

            fi
            #pecho "load and attach"

          fi
        fi

        fileIndex=$((fileIndex + 1))

      done

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
    NO_TM_LISTING=$(tmux ls 2>&1 | grep -v "no server running on")
    if [ "$NO_TM_LISTING" ]; then
        if [[ $# -gt 0 ]]; then
            tmux kill-session -t "$1"
        else
            TERMINAL_NUMBER=$(tmux ls | awk '{print $1}' | head -n 1)
            if [ "$TERMINAL_NUMBER" ]; then
                echo "killing ... $TERMINAL_NUMBER"
                tmux kill-session -t "$TERMINAL_NUMBER"
            fi
        fi
        tmux ls
    fi
}

# attach to last session
function ta() {
    if [[ $# -gt 0 ]]; then
        echo "attach to $1"
        tmux attach -t "$1"
    else
        echo "auto attach"
        tmux attach
    fi
}

function calltmuxcreatewindow() {
  
  local key=''
  local currentTemplate=$(cat ~/.tmuxdefault)
  echo "$currentTemplate"
  local currentAttach=$(tmux ls | grep -i attached | awk -F':' '{print $1}')
  local backgroundMode='f'

  while [[ $# -gt 0 ]]; do

    key="$1"
    shift

    case "$key" in
      '-background')
        backgroundMode='t'
        ;;
      *)
        ;;
    esac
    
  done
  

  if [[ $currentTemplate == '' ]]; then
    currentTemplate="blank"
  fi

  pecho "current template $currentTemplate"
  
  # if you have one that's currently attached
  if [[ $currentAttach ]]; then

    if [[ $backgroundMode == 't' ]]; then
      pecho "attached background $currentTemplate"
      tmux send-keys -t "$currentAttach" "t $currentTemplate" Enter
#        tmux send-keys -t "$currentAttach" "TT $currentTemplate" Enter
    else
      pecho "attached nobackground $currentTemplate"
      tmux send-keys -t "$currentAttach" "t $currentTemplate" Enter

      # need to sleep and delay so tmux can create windows to register
      sleep .5
      local newIndex=$(tmux list-windows -t "$currentAttach" | tail -n 1 | awk -F':' '{ print $1 }')
      pecho "new index is $newIndex"
#        tmux send-keys -t "$currentAttach" "tt $currentTemplate" Enter
      tmux select-window -t "$currentAttach:$newIndex"
      pecho "tmux select-window -t \"$currentAttach:$newIndex\""
    fi

  else

    if [[ $backgroundMode == 't' ]]; then
      pecho "unattached background"
      T $currentTemplate
    else
      pecho "unattached nobackground"
      t $currentTemplate
      # attached to terminal
      ta
    fi

  fi

}

#function calltmuxcreatewindowx() {
#  
#  local currentAttach=$(tmux ls | grep -i attached | awk -F':' '{print $1}')
#  local currentTemplate=""
#
#  if [[ $currentAttach ]]; then
#
#    currentTemplate=$(cat ~/.tmuxdefault)
#
#    pecho "has current attached \"$currentAttach\""
#    gentitle
#    tmux new-window -a -n "$RANDOM_TITLE" -t $currentAttach
##    tmux split-window -v -t "$RANDOM_TITLE" \; select-pane -U
#    tmux split-window -v -t "$RANDOM_TITLE"
#
#    # don't move to last window
#    pecho $#
#    if [[ $# == 0 ]]; then
#
#      tmux select-window -t +1
#
#    else
#
#      echo "select new window"
#
#    fi
#
#  fi
#
#}

# set tmux default value
function ttemp() {

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
