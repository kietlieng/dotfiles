alias oscreen="open ~/lab/screenshots"
alias oshot="open ~/lab/screenshots && slast -r"
alias sref="slast -r"

# shotlast
function slast() {

  local currentDir=$(pwd)
  cd ~/lab/screenshots 
  local fullPath=$(pwd)

  local modeReference=''
  local key=''

  while [[ $# -gt 0 ]]; do

    key="$1"
    shift

    case "$key" in
      '-r') modeReference='t' ;;
      *) pecho "do nothing" ;;
    esac

  done

  pic=$(ls -1tr | tail -n 1)

  ref -f "$fullPath/$pic"

  if [[ ! $modeReference ]]; then
    open "$pic"
  fi

  cd $currentDir

}

# if there is a new file reference
function sreflast() {

  rm -rf $SCREENSHOT_DIRECTORY/.DS_Store
  local sOutput=$(ls -1tr $SCREENSHOT_DIRECTORY | tail -n 1)

  if [[ $sOutput ]]; then
    ref -f "$SCREENSHOT_DIRECTORY/$sOutput"

    pecho "ref -f \"$SCREENSHOT_DIRECTORY/$sOutput\""

  fi

}
