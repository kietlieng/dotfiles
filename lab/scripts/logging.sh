# Echo family! 
# printing functions 
function becho() { # broadcast echo.  Put in file and also output to screen

  local fname="${funcstack[2]}: $@"
  echo "$fname" >> /tmp/log-gecho
  echo "$fname"

}

function pecho() { # put echo into file

  local fname="${funcstack[2]}: $@"
  echo "$fname" >> /tmp/log-gecho

}

function gecho() { # get echo from file
  
  cat /tmp/log-gecho

}

function cecho() { # get echo from file.  Then empty
  
  cat /tmp/log-gecho
  echo "" > /tmp/log-gecho

}

function techo() { # get echo from file.  Then empty
  
  tail -f  /tmp/log-gecho

}
