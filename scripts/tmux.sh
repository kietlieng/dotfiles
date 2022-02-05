alias tm='tm2'
alias tm1='tmux new-session'
alias tm2='tmux new-session \; split-window -h \; select-pane -L \; attach'
alias tm3='tmux new-session \; split-window -h \; split-window -h \; select-pane -L \; select-pane -L \; attach \; select-layout even-horizontal'
alias tm4='tmux new-session \; split-window -h \; split-window -v \; select-pane -L \; split-window -v \; select-pane -U \; attach'
alias tm6='tmux new-session \; split-window -h \; split-window -h \; select-pane -L \; split-window -v \; select-pane -L \; split-window -v \; select-pane -L \; split-window -v \; select-pane -U \; attach'
alias tl='tmux ls'
alias tsource="tmux source-file ~/.tmux.conf"


function tpane() {
  echo "${@}"
  echo "${#}"
  target_list=()
  split_list=()

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
    echo $target_list[$pane_index]
    #zsh -c $target_list[$pane_index]
    eval($target_list[$pane_index])
  fi
}

# kill last session
function td() {
  TM_LISTING=$(tmux ls)
  NO_TM_LISTING=$(tmux ls 2>&1 | grep -v "no server running on")
  if [ "$NO_TM_LISTING" ]; then
    if [[ $# -gt 0 ]]; then
      tmux kill-session -t $1
    else
      TERMINAL_NUMBER=$(tmux ls | awk '{print $1}' | grep -o "[0-9]*" | head -n 1)
      if [ "$TERMINAL_NUMBER" ]; then
          echo "killing ... $TERMINAL_NUMBER"
          tmux kill-session -t $TERMINAL_NUMBER
      fi
    fi
    tmux ls
  fi
}

# attach to last session
function ta() {
  if [[ $# -gt 0 ]]; then
    tmux attach -t $1
  else
    tmux attach
  fi
}
