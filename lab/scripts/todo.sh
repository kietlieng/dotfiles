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

  local fileDone=~/.tododone
  local fileOutput=~/.todooutput
  local fileToDo=~/.todo
  local fileToDoSaved=~/.todosaved
   
  local formatDate='+%y-%m-%d'

  local currentDateStatic=$(dgetdate)
  local currentDate=$currentDateStatic

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

      '-move') modeMove='t';;
      '-tag') modeTag=$(echo "$1 " |  tr '[:lower:]' '[:upper:]'); shift ;;
      '-add') modeAdd='t';;
      '-date') currentDate="$1"; shift ;;
      '-save' ) modeSave='t';;
      '-l' ) modeLast='t';;
      '-sub') modeSub='-';;
      '-1') currentDate=$(dgetdate "${modeSub}1d" $currentDate) ;;
      '-2') currentDate=$(dgetdate "${modeSub}2d" $currentDate) ;;
      '-3') currentDate=$(dgetdate "${modeSub}3d" $currentDate) ;;
      '-4') currentDate=$(dgetdate "${modeSub}4d" $currentDate) ;;
      '-5') currentDate=$(dgetdate "${modeSub}5d" $currentDate) ;;
      '-6') currentDate=$(dgetdate "${modeSub}6d" $currentDate) ;;
      '-w') currentDate=$(dgetdate "${modeSub}1w" $currentDate) ;;
      '-2w') currentDate=$(dgetdate "${modeSub}2w" $currentDate) ;;
      '-3w') currentDate=$(dgetdate "${modeSub}3w" $currentDate) ;;
      '-4w') currentDate=$(dgetdate "${modeSub}4w" $currentDate) ;;
      '-5w') currentDate=$(dgetdate "${modeSub}5w" $currentDate) ;;
      '-m') currentDate=$(dgetdate "${modeSub}1m" $currentDate) ;;
      '-2m') currentDate=$(dgetdate "${modeSub}2m" $currentDate) ;;
      '-3m') currentDate=$(dgetdate "${modeSub}3m" $currentDate) ;;
      '-4m') currentDate=$(dgetdate "${modeSub}4m" $currentDate) ;;
      '-5m') currentDate=$(dgetdate "${modeSub}5m" $currentDate) ;;
      '-6m') currentDate=$(dgetdate "${modeSub}6m" $currentDate) ;;
      '-7m') currentDate=$(dgetdate "${modeSub}7m" $currentDate) ;;
      '-8m') currentDate=$(dgetdate "${modeSub}8m" $currentDate) ;;
      '-9m') currentDate=$(dgetdate "${modeSub}9m" $currentDate) ;;
      '-10m') currentDate=$(dgetdate "${modeSub}10m" $currentDate) ;;
      '-11m') currentDate=$(dgetdate "${modeSub}11m" $currentDate) ;;
      '-y') currentDate=$(dgetdate "${modeSub}1y" $currentDate) ;;
      '-2y') currentDate=$(dgetdate "${modeSub}2y" $currentDate) ;;
      '-3y') currentDate=$(dgetdate "${modeSub}3y" $currentDate) ;;
      '-4y') currentDate=$(dgetdate "${modeSub}4y" $currentDate) ;;
      '-5y') currentDate=$(dgetdate "${modeSub}5y" $currentDate) ;;
      '-delete') echo "figure out delete later" ;;
      *) 
        targetString="$targetString$key " 
      ;;

    esac

  done

  # populate search string
  targetSearch=$(echo "$targetString" | xargs | sed 's/ /.*/g')

  if [[ $modeSave ]]; then
    echo "$targetString" > $fileToDoSaved
    echo "Saved: $targetString"
    return
  fi

  if [[ $modeLast ]]; then
    lastSave=$(cat $fileToDoSaved |  tr '[:lower:]' '[:upper:]')
  fi

  # not add but search search
  if [[ ! $modeAdd ]]; then

    becho "searching $targetSearch"
    grep -hi "$targetSearch" $fileToDo


    if [[ "$currentDate" != "$currentDateStatic" ]]; then
      
      grep -hi "$targetSearch" $fileToDo > $fileOutput

      local noDate=""
      while read line; do
        echo "1 current line $line"
        noDate=$(echo "$line" | awk '{for(i=2; i<=NF; i++) printf $i (i==NF ? "\n" : OFS)}')
        echo "2 current line $noDate"

        # remove value 
        echo "sed -i '' \"/$noDate/d\" $fileToDo"
        sed -i '' "/$noDate/d" $fileToDo
      
        # move value
        echo "$currentDate: ${modeTag}${lastSave}${noDate}" >> $fileToDo
      done < $fileOutput

      sort -o $fileToDo $fileToDo

    fi

    return

  elif [[ $targetString ]]; then

    echo "$currentDate: ${modeTag}${lastSave}${targetString}" >> $fileToDo
    sort -o $fileToDo $fileToDo

  fi

  cat $fileToDo

}

function da() {

  echo "d -add $@"
  d -add $@

}


# todo done and move
function dx() {

  local fileDone=~/.tododone
  local fileOutput=/tmp/do-output
  local fileToDo=~/.todo
  local fileToDoSaved=~/.todosaved

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
  echo "$doValues" > $fileOutput
  
  while read line; do
    echo "$line"
    sed -i '' "/$line/d" ~/.todo
  done < $fileOutput

#  if [[ -n $doValues ]]; then
##		echo "has doValues $doValues"
#		for doIndex in "$doValues"; do
##			kill $doIndex
#			echo "x $doIndex"
#		done
#	fi

}

# todo move to another date
function dv() {
  

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
    echo "$modeSetting" > ~/.todosetting
  fi

}

function dreminder() {

  local today=$(date "+%y%m%d%H")
  local fileDo="/tmp/do-$today"
  local shouldDisplay=$(dsetting)

#  echo "shouldDisplay $shouldDisplay"
 
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
