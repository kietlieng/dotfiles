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

      # single
      '-1' ) 
        lastDateChangeValue="${modeSub}1" 
        currentDate=$(dgetdate "$lastDateChangeValue" "$currentDate")
        ;;

      # single
      '-w' | '-m' | '-y' ) 
        dateValue=$(echo "$key" | cut -c2-)
        lastDateChangeValue="${modeSub}1${dateValue}" 
        currentDate=$(dgetdate "$lastDateChangeValue" "$currentDate")
        ;;

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
    echo "$targetString" > $FILE_TODOSAVED
    echo "Saved: $targetString"
    return
  fi

  if [[ $modeLast ]]; then
    lastSave=$(cat $FILE_TODOSAVED |  tr '[:lower:]' '[:upper:]')
  fi

  local doDate=""
  # not add but search search
  if [[ ! $modeAdd ]] && [[ $targetSearch ]]; then

    becho "searching |$targetSearch|"
    grep -hi "$targetSearch" $FILE_TODO

    if [[ "$currentDate" != "$currentDateStatic" ]]; then
      
      grep -hi "$targetSearch" $FILE_TODO > $FILE_TODO_OUTPUT

      local noDate=""
      while read line; do
        doDate=$(echo "$line" | awk '{print $1 }')

#        echo "1 current line $line"
        noDate=$(echo "$line" | awk '{for(i=2; i<=NF; i++) printf $i (i==NF ? "\n" : OFS)}')
#        echo "2 current line $noDate"

        # remove value 
#        sed -i '' "/$noDate/d" $FILE_TODO
        echo "sed -i '' \"/$line/d\" $FILE_TODO"
        sed -i '' "/$line/d" $FILE_TODO

        # if relative date find relative date
        if [[ ! $modeAbsolute ]]; then
          echo "dDate operation |$lastDateChangeValue|"
          echo "dgetdate \"$lastDateChangeValue\" $doDate"
          currentDate=$(dgetdate "$lastDateChangeValue" $doDate)
        fi
        echo "$currentDate ${modeTag}${lastSave}${noDate}" >> $FILE_TODO

      done < $FILE_TODO_OUTPUT

      sort -o $FILE_TODO $FILE_TODO

    fi

    return

  elif [[ $targetString ]]; then

    echo "$currentDate ${modeTag}${lastSave}${targetString}" >> $FILE_TODO
    sort -o $FILE_TODO $FILE_TODO

  fi

  dlist "$currentDateStatic"
#  dprint

#  # do listing
#  local currentPointer='t'
#  while read line; do
#    doDate=$(echo "$line" | awk '{print $1 }')
#    
#    if [[ ("$doDate" == "$currentDateStatic") || ("$doDate" > "$currentDateStatic") ]]; then 
#
#      if [[ $currentPointer ]]; then
#        echo "\n\033[0;31m  󱅼 🯁🯂🯃  >>>>>>>> $currentDateStatic <<<<<<<<  󰭥 󱩁 \033[0m\n"
#      fi
#      currentPointer=''
#    fi
#    echo "$line"
#
#  done < $FILE_TODO

}

function dlist() {

  local currentDateStatic="$1"
  # do listing
  local currentPointer='t'
  while read line; do
    doDate=$(echo "$line" | awk '{print $1 }')
    doContent=$(echo "$line" | awk '{for(i=2; i<=NF; i++) printf $i (i==NF ? "\n" : OFS)}')
    
    if [[ ("$doDate" == "$currentDateStatic") || ("$doDate" > "$currentDateStatic") ]]; then 

      if [[ $currentPointer ]]; then
        echo "\n\033[0;31m  󱅼 🯁🯂🯃  >>>>>>>> $currentDateStatic <<<<<<<<  󰭥 󱩁 \033[0m\n"
      fi
      currentPointer=''
    fi
    dprint -date "$doDate" -content "$doContent"
#    echo "$line"

  done < $FILE_TODO

}

# 
function dprint() {
  
  local argDate=""
  local argContent=""

  local modeColor=''
  local key=''

  declare -A dColors

  dColors=( 
    ["red"]="\033[0;31m" 
    ["clear"]="\033[0m"
    ["black"]="\033[0;30m"
    ["dgray"]="1;30m"
    ["lred"]="\033[1;31m"
    ["green"]="\033[0;32m"
    ["lgreen"]="\033[1;32m"
    ["orange"]="\033[0;33m"
    ["yellow"]="\033[1;33m"
    ["blue"]="\033[0;34m"
    ["lblue"]="\033[1;34m"
    ["purple"]="\033[0;35m"
    ["lpurple"]="\033[1;35m"
    ["cyan"]="\033[0;36m"
    ["lcyan"]="\033[1;36m"
    ["lgray"]="\033[0;37m"
    ["white"]="\033[1;37m"
  )

  while [[ $# -gt 0 ]]; do

    key="$1"
    shift

    case "$key" in
      '-date') modeDate="$1"; shift ;;
      '-content') modeContent="$1"; shift ;;
      *) ;;
    esac

  done

  messageOutput="$modeDate "
  if [[ $(echo "$modeContent" | grep "PLACES\|PAUSE") ]]; then
    messageOutput="${messageOutput}${dColors[red]}"
  elif [[ $(echo "$modeContent" | grep "MEDICAL") ]]; then
    messageOutput="${messageOutput}${dColors[orange]}"
  elif [[ $(echo "$modeContent" | grep "TRIP") ]]; then
    messageOutput="${messageOutput}${dColors[cyan]}"
  elif [[ $(echo "$modeContent" | grep "TAX") ]]; then
    messageOutput="${messageOutput}${dColors[purple]}"
  elif [[ $(echo "$modeContent" | grep "wife") ]]; then
    messageOutput="${messageOutput}${dColors[lgreen]}"
  elif [[ $(echo "$modeContent" | grep "BDAY") ]]; then
    messageOutput="${messageOutput}${dColors[yellow]}"
  elif [[ $(echo "$modeContent" | grep "accord") ]]; then
    messageOutput="${messageOutput}${dColors[blue]}"
  fi
  messageOutput="${messageOutput}${modeContent}${dColors[clear]}"
  echo "$messageOutput"

}

function da() {

  echo "d -add $@"
  d -add $@

}


# todo done and move
function dx() {

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

  local doValues=$(cat $FILE_TODO | fzf -m --ansi --color fg:-1,bg:-1,hl:46,fg+:40,bg+:233,hl+:46 --color prompt:166,border:46 --height 75%  --border=sharp --prompt="➤  " --pointer="➤ " --marker="➤ " --bind "change:execute(echo {q} > $queryFile)" --query "$defaultQuery")

  echo "$doValues" >> $FILE_TODO_OUTPUT
  echo "$doValues" > $FILE_TODO_DONE
  
  while read line; do
    echo "$line"
    sed -i '' "/$line/d" $FILE_TODO
  done < $FILE_TODO_OUTPUT

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
    cat $FILE_TODO_SETTING
  else
    echo "$modeSetting" > $FILE_TODO_SETTING
  fi

}

function dreminder() {

  local currentMinute=$(date "+%M")
  currentMinute=$((currentMinute / 30))

  local today=$(date "+%y%m%d%H")
  today="${today}${currentMinute}"

  local fileDo="$DIRECTORY_TODO/do-$today"

#  echo "$fileDo"
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

        if [[ ! -d "$DIRECTORY_TODO" ]]; then
          mkdir $DIRECTORY_TODO
        fi
        echo "touched $fileDo" > $fileDo
      fi
    fi
  fi

}
