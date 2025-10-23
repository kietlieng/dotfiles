function mcode

  # set code $(sqlite3 ~/Library/Messages/chat.db "select text from message where text LIKE '%google%' order by ROWID desc limit 1" | grep -o "[0-9]\+")
  set code $(sqlite3 ~/Library/Messages/chat.db "select text from message order by ROWID desc limit 10" | grep -o "[0-9]\{4,15\}" | head -n 1)
  echo -n "$code" | pbcopy

 end

function mlast

  set modeNumber 20

  if test (count $argv) -gt 0
  
    set modeNumber "$argv"
    set argv $argv[2..-1]

  end

  sqlite3 ~/Library/Messages/chat.db "select account,text from message order by ROWID desc limit $modeNumber"

end

function msql
     
  sqlite3 ~/Library/Messages/chat.db

end
