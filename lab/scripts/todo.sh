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
  date -j -v "$targetChange" -f "$formatDate" "$targetDate" "$formatDate2"

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
  local modeAbsolute=''
  local modeAdd=''
  local modeLast=''
  local modeSave=''
  local modeSub='+'
  local modeTag=''
  local targetSearch=''
  local targetString=''

  local dateValue=''
  local lastDateChangeValue=''
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
      '-abs') modeAbsolute='t';;

      # dates
      '-1d' | '-2d' | '-3d' | '-4d' | '-5d' | '-6d' | '-1w' | '-2w' | '-3w' | '-4w' | '-5w' | '-1m' | '-2m' | '-3m' | '-4m' | '-5m' | '-6m' | '-7m' | '-8m' | '-9m' | '-10m' | '-11m' | '-1y' | '-2y' | '-3y' | '-4y' | '-5y') 
        dateValue=$(echo "$key" | cut -c2-)
        lastDateChangeValue="${modeSub}${dateValue}" 
        currentDate=$(dgetdate "$lastDateChangeValue" "$currentDate")
        ;;
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

  local doDate=""
  # not add but search search
  if [[ ! $modeAdd ]] && [[ $targetSearch ]]; then

    becho "searching |$targetSearch|"
    grep -hi "$targetSearch" $fileToDo

    if [[ "$currentDate" != "$currentDateStatic" ]]; then
      
      grep -hi "$targetSearch" $fileToDo > $fileOutput

      local noDate=""
      while read line; do
        doDate=$(echo "$line" | awk '{print $1 }')

#        echo "1 current line $line"
        noDate=$(echo "$line" | awk '{for(i=2; i<=NF; i++) printf $i (i==NF ? "\n" : OFS)}')
#        echo "2 current line $noDate"

        # remove value 
#        echo "sed -i '' \"/$noDate/d\" $fileToDo"
        sed -i '' "/$noDate/d" $fileToDo

        # if relative date find relative date
        if [[ ! $modeAbsolute ]]; then
          echo "dDate operation |$lastDateChangeValue|"
          echo "dgetdate \"$lastDateChangeValue\" $doDate"
          currentDate=$(dgetdate "$lastDateChangeValue" $doDate)
        fi
        echo "$currentDate ${modeTag}${lastSave}${noDate}" >> $fileToDo

      done < $fileOutput

      sort -o $fileToDo $fileToDo

    fi

    return

  elif [[ $targetString ]]; then

    echo "$currentDate ${modeTag}${lastSave}${targetString}" >> $fileToDo
    sort -o $fileToDo $fileToDo

  fi

  # do listing
  local currentPointer='t'
  while read line; do
    doDate=$(echo "$line" | awk '{print $1 }')
    
    if [[ ("$doDate" == "$currentDateStatic") || ("$doDate" > "$currentDateStatic") ]]; then 

      if [[ $currentPointer ]]; then
        echo "🯁🯂🯃 >>>>>>>> $currentDateStatic <<<<<<<<"
      fi
      currentPointer=''
    fi
    echo "$line"

  done < $fileToDo

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
  today=$(date "+%y%m%d%H%M")

  local fileDo="/tmp/do-$today"
  local shouldDisplay=$(dsetting)
  local onVideo=$(ps aux | grep -i "zoom.us.app\|Microsoft Teams.app" | wc -l)
#  echo "shouldDisplay $shouldDisplay"

  if [[ $shouldDisplay ]]; then
    
    if [[ onVideo -gt 1 ]]; then 
      echo "Zoom / MS Teams detected."
      return
    else
      if [[ $# -gt 0 ]]; then
        d
        return 
      fi

      if [[ ! -f $fileDo ]]; then
        d
        echo "touched $fileDo" > $fileDo
      fi
    fi
  fi

}
