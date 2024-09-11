alias shotref="shotlast -r"

# shotlast
function shotlast() {

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

  cpfile -f "$fullPath/$pic"

  if [[ ! $modeReference ]]; then
    open "$pic"
  fi

  cd $currentDir

}


