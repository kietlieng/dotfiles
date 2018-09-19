alias tm='tmux new-session \; split-window -h \; attach'
alias tl='tmux ls'

function tk() {
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

function ta() {
  if [[ $# -gt 0 ]]; then
    tmux attach -t $1
  else 
    tmux attach
  fi
}
