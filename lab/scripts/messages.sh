function mcode() {

  local code=$(sqlite3 ~/Library/Messages/chat.db "select text from message order by ROWID desc" | grep -i -m 1 "google" | grep -o "[0-9]\+")
  echo -n "$code" | pbcopy

 }

function mlast() {

  modeNumber=20

  if [[ $# -gt 0 ]]; then
  
    modeNumber="$1"
    shift

  fi

  sqlite3 ~/Library/Messages/chat.db "select text from message order by ROWID desc limit $modeNumber"

}
