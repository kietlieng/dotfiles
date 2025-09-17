function getcode() {

  local code=$(sqlite3 ~/Library/Messages/chat.db "select text from message order by ROWID desc" | grep -i -m 1 "google" | grep -o "[0-9]\+")
  echo "$code" | pbcopy

 }
