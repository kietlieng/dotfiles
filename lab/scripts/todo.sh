alias don="dsetting on"
alias doff="dsetting off"

function dgetdate() {

  # date -j -v +1d -f "%y/%m/%d" "$currentDate" "+%Y-%m-%d"

  local formatDate='%y-%m-%d'
  local formatDate2='+%y-%m-%d'
  if [[ $# -eq 0 ]]; then
    date  "+$formatDate"
    return
  fi

  local targetChange="$1"
  local targetDate="$2"

  # tranform date based on current
  #echo "date -j -v \"$1\" -f \"$formatDate\" \"$2\" \"$formatDate2\""
  date -j -v "$1" -f "$formatDate" "$2" "$formatDate2"

}

# todo
function d() {

  local fileToDo=~/.todo
  local fileDone=~/.tododone
  local fileToDoSaved=~/.todosaved
   
  local formatDate='+%y-%m-%d'

  local currentDate=$(dgetdate)

  local lastSave=''
  local modeAdd=''
  local modeLast=''
  local modeSave=''
  local modeSub='+'
  local modeTag=''
  local targetSearch=''
  local targetString=''
#  echo "$currentDate"

  # date -j -v +1d -f "%y/%m/%d" "$currentDate" "+%Y-%m-%d"

  local key=''

  while [[ $# -gt 0 ]]; do

    key="$1"
    shift

    case "$key" in

      '-tag') modeTag=$(echo "$1 " |  tr '[:lower:]' '[:upper:]'); shift ;;
      '-add') modeAdd='t';;
      '-date') currentDate="$1" shift ;;
      '-save' ) modeSave='t';;
      '-l' ) modeLast='t';;
      '-sub') modeSub='-';;
      '-1') currentDate=$(tdgetdate "${modeSub}1d" $currentDate) ;;
      '-2') currentDate=$(tdgetdate "${modeSub}2d" $currentDate) ;;
      '-3') currentDate=$(tdgetdate "${modeSub}3d" $currentDate) ;;
      '-4') currentDate=$(tdgetdate "${modeSub}4d" $currentDate) ;;
      '-5') currentDate=$(tdgetdate "${modeSub}5d" $currentDate) ;;
      '-6') currentDate=$(tdgetdate "${modeSub}6d" $currentDate) ;;
      '-w') currentDate=$(tdgetdate "${modeSub}1w" $currentDate) ;;
      '-2w') currentDate=$(tdgetdate "${modeSub}2w" $currentDate) ;;
      '-3w') currentDate=$(tdgetdate "${modeSub}3w" $currentDate) ;;
      '-4w') currentDate=$(tdgetdate "${modeSub}4w" $currentDate) ;;
      '-5w') currentDate=$(tdgetdate "${modeSub}5w" $currentDate) ;;
      '-m') currentDate=$(tdgetdate "${modeSub}1m" $currentDate) ;;
      '-2m') currentDate=$(tdgetdate "${modeSub}2m" $currentDate) ;;
      '-3m') currentDate=$(tdgetdate "${modeSub}3m" $currentDate) ;;
      '-4m') currentDate=$(tdgetdate "${modeSub}4m" $currentDate) ;;
      '-5m') currentDate=$(tdgetdate "${modeSub}5m" $currentDate) ;;
      '-6m') currentDate=$(tdgetdate "${modeSub}6m" $currentDate) ;;
      '-7m') currentDate=$(tdgetdate "${modeSub}7m" $currentDate) ;;
      '-8m') currentDate=$(tdgetdate "${modeSub}8m" $currentDate) ;;
      '-9m') currentDate=$(tdgetdate "${modeSub}9m" $currentDate) ;;
      '-10m') currentDate=$(tdgetdate "${modeSub}10m" $currentDate) ;;
      '-11m') currentDate=$(tdgetdate "${modeSub}11m" $currentDate) ;;
      '-y') currentDate=$(tdgetdate "${modeSub}1y" $currentDate) ;;
      '-2y') currentDate=$(tdgetdate "${modeSub}2y" $currentDate) ;;
      '-3y') currentDate=$(tdgetdate "${modeSub}3y" $currentDate) ;;
      '-4y') currentDate=$(tdgetdate "${modeSub}4y" $currentDate) ;;
      '-5y') currentDate=$(tdgetdate "${modeSub}5y" $currentDate) ;;
      '-delete') echo "figure out delete later" ;;
      *) 
        targetString="$targetString$key " 
        targetSearch="$targeSearch.*$key"
      ;;

    esac

  done

  if [[ $modeSave ]]; then
    echo "$targetString" > $fileToDoSaved
    echo "Saved: $targetString"
    return
  fi


  if [[ $modeSave == '' ]]; then
#    echo "searching"
    grep -hi "$targetSearch" $fileToDo $fileToDoSaved
    return

  elif [[ $targetString ]]; then

    if [[ $modeLast ]]; then
      lastSave=$(cat $fileToDoSaved |  tr '[:lower:]' '[:upper:]')
    fi

    echo "$currentDate: ${modeTag}${lastSave}${targetString}" >> $fileToDo
    sort -o $fileToDo $fileToDo

  fi

  cat $fileToDo

}

function da() {

  echo "adding"
  d -add $@

}


# do done and move
function dx() {

  local fileToDo=~/.todo
  local fileDone=~/.tododone
  local fileToDoSaved=~/.todosaved
  local fileOutput=/tmp/do-output

  local hashDir=$(md5 -q -s $(pwd)) 
	local queryFile="/tmp/do-$hashDir" 
	local defaultQuery='' 

	if [[ -f $queryFile ]]; then
		defaultQuery=$(cat $queryFile) 
	fi

	if [[ $# -gt 0 ]]; then
		defaultQuery=$1 
		shift
	fi

  local doValues=$(cat $fileToDo | fzf -m --ansi --color fg:-1,bg:-1,hl:46,fg+:40,bg+:233,hl+:46 --color prompt:166,border:46 --height 75%  --border=sharp --prompt="➤  " --pointer="➤ " --marker="➤ " --bind "change:execute(echo {q} > $queryFile)" --query "$defaultQuery")

  echo "$doValues" >> $fileDone
  while read line; do
    echo "$line"
    sed -i '' "/$line/d" ~/.todo
  done < /tmp/do-output

#  if [[ -n $doValues ]]; then
##		echo "has doValues $doValues"
#		for doIndex in "$doValues"; do
##			kill $doIndex
#			echo "x $doIndex"
#		done
#	fi

}

function dsetting() {

  local modeSetting=''
  local modeDisplay='t'
  local key=''

  while [[ $# -gt 0 ]]; do

    key="$1"
    shift

    case "$key" in
      'on') modeSetting='t'; modeDisplay='' ;;
      'off') modeSetting=''; modeDisplay='' ;;
      *) modeSetting='' ;;
    esac

  done

  if [[ $modeDisplay ]]; then
    cat ~/.todosetting
  else
    echo "$key" > ~/.todosetting
  fi

}

function dreminder() {

  local today=$(date "+%y%m%d-%H")
  local fileDo="/tmp/do-$today"
  local shouldDisplay=$(dsetting)

#  echo "$shouldDisplay"
 
  if [[ $shouldDisplay ]]; then
    
    if [[ $# -gt 0 ]]; then
      d
      return 
    fi

    if [[ ! -f $fileDo ]]; then
       
      d
      echo "touched $fileDo" > $fileDo

    fi

  fi

}
