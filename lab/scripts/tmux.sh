#alias tm='tm1'
alias tmh='tm2'
alias tm1='tmux new-session'
alias tm2='tmux new-session \; split-window -v \; select-pane -U \; set-window-option synchronize-panes on \; attach'
alias tmv2='tmux new-session \; split-window -h \; select-pane -L \; set-window-option synchronize-panes on \; attach'
alias tm3='tmux new-session \; split-window -v \; split-window -v \; select-pane -D \; set-window-option synchronize-panes on \; select-layout even-vertical \; attach'
alias tmv3='tmux new-session \; split-window -h \; split-window -h \; select-pane -R \; set-window-option synchronize-panes on \; select-layout even-horizontal \; attach'
alias tm4='tmux new-session \; split-window -h \; split-window -v \; select-pane -L \; split-window -v \; select-pane -U \; set-window-option synchronize-panes on \; attach'
alias tm5='tmux new-session \; split-window -h \; split-window -h \; split-window -h \; split-window -h \; select-pane -R \; set-window-option synchronize-panes on \; select-layout even-horizontal \; attach'
alias tm6='tmux new-session \; split-window -h \; split-window -h \; select-pane -L \; split-window -v \; select-pane -L \; split-window -v \; select-pane -L \; split-window -v \; select-pane -U \; set-window-option synchronize-panes on \; attach'
alias tsource="tmux source-file ~/.tmux.conf"


function tl() {
  t -l $@
}

function t() {
  loadTarget=""
  loadDir=~/lab/scripts/tmuxp
  listMatches='f'

  while [[ $# -gt 0 ]]; do

    key="$1"
    case "$key" in
      '-l' ) 
        listMatches='t'
        shift
        ;;
      *)
        loadTarget="$loadTarget*$key*"
        shift
        ;;

    esac

  done

  if [[ $loadTarget != ""  ]]; then

    results=$(find $loadDir -maxdepth 1 -iname "${loadTarget}.yaml")
    #targetFiles=($results) # turn into array
    # remove returns and a list with spaces so we can turn into an array
    targetFiles=($(echo "$results" | sed -r 's/\n/ /g'))

    fileSize=${#targetFiles[@]}

    #prinf "targetFiles %s\n" "${targetFiles[@]}"
    #echo "filesize $fileSize"

    fileIndex=1

    for yFile in "${targetFiles[@]}"; do

      #echo "index is $fileIndex"

      if [[ $listMatches == 't' ]]; then
          echo "$yFile"
      else
        if [[ $fileIndex -lt $fileSize ]]; then

          tmuxp load -d "$yFile"
          #echo "load and detach"

        else

          tmuxp load "$yFile"
          #echo "load and attach"

        fi
      fi

      fileIndex=$((fileIndex + 1))

    done

    # this one works
    #results=$(find $loadDir -maxdepth 1 -iname "${loadTarget}.yaml")
    #targetFiles=$results
    #tmuxp load $(echo "$targetFiles" | tail -n 1)


  else

    echo "loading $loadDir"
    ls -l "$loadDir"
    tmux ls

  fi

}


function tmx() {
    echo "${@}"
    echo "${#}"
    #echo "$1"
    target_list=()
    #target_list=("nvim test.txt" "nvim test.txt")
    #echo "${prod_list[*]}"
    #split_list=()
    #if [ "${#}" -gt 0 ]; then
    #  placeholder=$1
    #  #if [ "dev" = "$placeholder" ]; then
    #  #  target_list=( "jsh dev-usw-r4-def-h4 -c" "jsh dev-usw-r6-def-h6 -c" "jsh dev-usw-r7-def-h7 -c" "jsh dev-usw-r8-def-h8 -c" )
    #  #fi
    #  target_list+=( $placeholder )
    #fi

    while [[ "${#}" -gt 0 ]]
    do
        target_list+=( "$1" )
        shift
    done
    #echo "working!? ${target_list[@]}"
    # means you're not in a session
    if [ -z "$TMUX_PANE" ]; then
        #for ssh_entry in "${target_list[@]:1}"; do
        pane_name="tpane"
        first_pane="t"

        for ssh_entry in "${target_list[@]}"; do
            # check first pane
            if [[ "$first_pane" == "t" ]]; then
                tmux new-session -d -s $pane_name
                first_pane="f"
            else
                tmux split-window -h -t $pane_name
            fi
            tmux send-keys -t $pane_name "$ssh_entry" Enter
        done

        if [[ "$first_pane" == "f" ]]; then
            tmux select-layout -t $pane_name tiled
            tmux set-window-option -t $pane_name synchronize-panes on
            tmux attach -t $pane_name
        fi
    else
        # ? what is this doing
        pane_index=$((${TMUX_PANE:1} + 1))
        echo "${target_list[$pane_index]}"
        #zsh -c $target_list[$pane_index]
        evalValue=${target_list[$pane_index]}
        eval echo "$evalValue"
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
        echo "attach auto"
        tmux attach
    fi
}
