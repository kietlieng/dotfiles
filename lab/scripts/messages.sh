function mcode() {

  # local code=$(sqlite3 ~/Library/Messages/chat.db "select text from message where text LIKE '%google%' order by ROWID desc limit 1" | grep -o "[0-9]\+")
  local code=$(sqlite3 ~/Library/Messages/chat.db "select text from message order by ROWID desc limit 10" | grep -o "[0-9]\{4,15\}" | head -n 1)
  echo -n "$code" | pbcopy

 }

function mlast() {

  modeNumber=20

  if [[ $# -gt 0 ]]; then
  
    modeNumber="$1"
    shift

  fi

  sqlite3 ~/Library/Messages/chat.db "select account,text from message order by ROWID desc limit $modeNumber"

}

function msql() {

  sqlite3 ~/Library/Messages/chat.db

}
