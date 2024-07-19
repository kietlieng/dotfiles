alias ccore="c core"
alias ce="c edit"
alias cl="c -"
alias cy="c y"
alias jote="jot -query ''"
alias lint="yamllint "
alias xd="x -cd"
alias xl="x -l"

# edit git file
function xgit() {

    currentFolder=$(pwd)
    rootFolder=$(gitrootfolder)
    cd $rootFolder
#    nvim -c "/url" ".git/config"
    nvim ".git/config"
    echo "$rootFolder"
    cd $currentFolder

}


function xignore() {

    currentFolder=$(pwd)
    rootFolder=$(gitrootfolder)
    cd $rootFolder
    nvim ".gitignore"
    cd $currentFolder

}

# find docker file
function xd() {
    vfile "Dockerfile"
}

# edit ci yaml file without looking
function xc() {
    vfile ".gitlab-ci.yml"
}

# go up to root folder and find a file
function vfile() {

    currentFolder=$(pwd)
    rootFolder=$(gitrootfolder)
    searchExpression="$1"

    find $rootFolder -iname "$searchExpression" -exec nvim {} \;
    #echo "find $rootFolder -iname \".gitlab-ci.yml\" -exec nvim {} \;"
    echo -n "$rootFolder"
    if [[ -z $(find $rootFolder -iname "$searchExpression") ]]; then
        echo ": $searchExpression not found"
    fi
    echo ""
}


# arg1 directory
# arg2 default value of query
# returns:
# - list of results if there are files
# - the filename of the query value in file /tmp/query-[hash] that way you can retrieve the value that you want and do something with it
function fzfpreview() {

  local searchDirectory=$1
  local defaultQuery=$2
  local hashDir=$(md5 -q -s $searchDirectory)
  local queryFile="/tmp/query-$hashDir"

  local filesToEdit=$(rg --files $searchDirectory | fzf --multi --preview "bat --style=numbers --color=always --line-range :500 {}" --bind "change:execute(echo {q} > $queryFile)" --bind "ctrl-r:execute(echo \"\" > $queryFile)" --query "$defaultQuery")

  if [[ ${#filesToEdit[@]} != 0 ]]; then

    editFiles=($(echo "$filesToEdit" | sed -r 's/\n/ /g'))
    echo "$filesToEdit"

  else

    echo "$queryFile"

  fi


}


function xtmp() {

  local tempResults=$(fzfpreview /tmp)
  local editFiles=()
  for element in $(echo $tempResults | tr '\n' ' '); do
    editFiles+=("$element")
  done

  if [ ${#editFiles[@]} -gt 0 ]; then
    nvim -f $editFiles
  fi


}

# go into fzf for searching files and edit
function x() {

    goToDirectory='f'
    rootDirectory=''
    currentDirectory=$(pwd)
    lastOnly='f'

    while [[ $# -gt 0 ]]; do

        key="$1"
        shift

        case "$key" in

          '-l' )

            lastOnly='t'
            ;;
            
          '-c' ) 

            goToDirectory="t"
            ;;

          '-d' )
            rootDirectory="$1"
            ;;
          *) echo default
          ;;

        esac

    done

    if [[ $rootDirectory != '' ]]; then
      cd "$rootDirectory" 
    fi


    if [[ $lastOnly == 't' ]]; then

      for isFile in $(ls -1t | awk '{print $1}' ); do
        echo "file $isFile"
        if [[ -f $isFile ]]; then
          nvim $isFile
          break
        fi
      done

    else

      filesToEdit=$(/opt/homebrew/bin/fzf --multi)
      if [[ ${#filesToEdit[@]} != 0 ]]; then

          if [[ $goToDirectory == 't' ]]; then

            cd $(dirname $filesToEdit)

          else

  #          echo "array1 ${filesToEdit[@]}"
            editFiles=($(echo "$filesToEdit" | sed -r 's/\n/ /g'))

            nvim $editFiles

          fi

      fi

      cd $currentDirectory

    fi

}

# same as above function except we go to the root git directory then search
function X() {

    rootFolder=$(gitrootfolder)

    x -d $rootFolder $@

}

alias xG="xg '?'"

# open all files that are modified / new / deleted to nvim from git 
function xg() {

  key=''

  gitType="M" 

  while [[ $# -gt 0 ]]; do

    key="$1"
    shift

    case "$key" in

      '?')

        gitType="M?"
        ;;

      *)

        echo default
        ;;

    esac
    
  done
  
  filesToEdit=""
  
  # modified and new
  if [[ $gitType == 'M?' ]]; then

    filesToEdit=$(git status --porcelain | awk '{ if ($1 == "M" || $1 == "??" )  print $2}')

    if [[ $filesToEdit != '' ]]; then 
      nvim $(git status --porcelain | awk '{ if ($1 == "M" || $1 == "??" )  print $2}')
      echo "files to edit $filesToEdit"
    fi

  else

    # only modified
    filesToEdit=$(git status --porcelain | awk '{ if ($1 == "M") print $2}')

    if [[ $filesToEdit != '' ]]; then 
      nvim $(git status --porcelain | awk '{ if ($1 == "M") print $2}')
      echo "files to edit $filesToEdit"
    fi

  fi


}


# copy file path
function fxcp() {

    cp $(fzf)

}

# find subdomain on string
function subd() {
    subdomain=$(echo "$1" | awk -F/ '{sub(/^www\.?/,"",$3); print $3}')
    echo -n $subdomain | pbcopy
    echo $subdomain
}

# copy current path
function pc() {
    relativePath="~${PWD#"$HOME"}"

    echo "$relativePath/" 

#    if [[ $# -gt 0 ]]; then
    echo -n "$relativePath/" | pbcopy
#    fi
}

# grep listing
function gxl() {
    gx -l $@
}


# ?? not coded in gx function
function gxi() {

    gx -i $@

}

function gxcdl() {
    gx -ci -l $@
}

# duplicate of xc
function gxcd() {
    gx -ci $@
}

# match all from file a to file b in order
# Meaning: file a: go line by line.  Match to file b.  Output 
function gxab() {
  local fileA="$1"
  local fileB="$2"
  local results=""
  local currentResults=""

  while read line; do

    currentResults=$(grep -i "$line" $fileB)
    if [[ $currentResults ]]; then
      echo $currentResults
      results="$results\n$currentResults"
    else
      results="$results\n$currentResults"
    fi

  done <$fileA

  echo "$results" | pbcopy
  echo "$results" > /tmp/ab.txt

}

# grep recursive
function gx() {
    local searchExpression='.*'
    local shouldList='false'
    local searchCICD='f'
    local targetFile="*"

    while [[ $# -gt 0 ]]
    do

        key="$1"
        case $key in

            '-l' )
                shouldList='true'
                shift
                ;;
            '-ci' )
                searchCICD='t'
                shift
                ;;
            * )
                searchExpression="$searchExpression${1}.*"
                shift
                ;;

        esac

    done

    if [[ $searchExpression = '.*' ]]; then
        echo "No expression"
    else
        #echo "search term $searchExpression"
        if [[ $searchCICD = 't' ]]; then
            if [[ $shouldList = "true" ]]; then
                find . -iname ".gitlab-ci.yml" -exec grep -il "$searchExpression" {} \;
            else
                find . -iname ".gitlab-ci.yml" -exec grep -i "$searchExpression" {} \;
            fi
        else

            # implement pipe input stream
            if ! [[ -t 0 ]]; then
                #echo "implement piping"
                targetFile='/tmp/inputstream'

                > $targetFile
                while read inputResults
                do
                    echo $inputResults >> $targetFile
                done
                #cat $targetFile
            fi

            #echo "target file $targetFile"
            if [[ $shouldList = "true" ]]; then
                #echo "test1"
                #pipe
                if ! [[ -t 0 ]]; then
                    ggrep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox} -irl "$searchExpression" $targetFile
                else
                    # dumping to null cause this will error out on * due to the backtick evaluation
                    #ggrep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox} -irl "$searchExpression" `$targetFile` 2> /dev/null
                    ggrep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox} -irl "$searchExpression" *
                fi
            else
                #echo "ggrep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox} -ir \"$searchExpression\" $targetFile"
                if ! [[ -t 0 ]]; then
                    ggrep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox} -ir "$searchExpression" $targetFile
                else
                    # dumping to null cause this will error out on * due to the backtick evaluation
                    echo "search expression $searchExpression"
                    #ggrep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox} -ir "$searchExpression" `$targetFile` 2> /dev/null
                    ggrep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox} -ir "$searchExpression" *
                fi
            fi
        fi

    fi
}

# rename function.  
function fxrename() {

  currentName="$1"
  newName="${currentName// /_}"
  newName="${newName//\(/_}"
  newName="${newName//\)/_}"
  newName="${newName//'/_}"
  renameCommand="mv '$currentName' $newName"
  echo "$renameCommand"
  echo -n "$renameCommand" | pbcopy

}

# find file
function fx() {
    searchexpression="*"
    while [[ $# -gt 0 ]]
    do
        searchexpression="$searchexpression${1}*"
        shift
    done
    echo "find . -iname \"$searchexpression\""
    find . -iname $searchexpression
}

# find and grep list
function fgxl() {
    fgx $@ -l

}

# find and grep
function fgx() {
    fileExpression="$1"
    searchExpression="$2"
    listOption='f'
    shift
    shift

    while [[ $# -gt 0 ]];
    do
        key="$1"
        case $key in
            '-l' )
                listOption='t'
                shift
                ;;
            * )
                shift
                ;;
        esac
    done

    if [[ $listOption = 't' ]];
    then
        find . -iname "*${fileExpression}*" -exec grep -il "${searchExpression}" {} \;
    else
        find . -iname "*${fileExpression}*" -exec grep -i "${searchExpression}" {} \;
    fi
}

# will script out extension
function nameonly() {
    results=$(strr -c -s " " -r "_" $@)
    results=$(strr -c -s ".\/" "$results")
    results=$(strr -c -s ".epub" "$results")
    results=$(strr -c -s ".doc" "$results")
    results=$(strr -c -s ".txt" "$results")
    results=$(strr -c -s ".azw3" "$results")
    results=$(strr -c -s ".mobi" "$results")
    results=$(strr -c -s ".pdf" "$results")
}

# no idea  what this does
function strr() {
    searchExpression=""
    copy='false'
    searchTerm=" "
    replaceTerm=""
    while [[ $# -gt 0 ]];
    do
        key="$1"
        case $key in
            '-s' )
                searchTerm="$2"
                shift
                shift
                ;;
            '-r' )
                replaceTerm="$2"
                shift
                shift
                ;;
            '-c' )
                copy='true'
                shift
                ;;
            * )
                shortened=$(echo $key | sed "s/$searchTerm/$replaceTerm/g")
                searchExpression="$searchExpression${replaceTerm}${shortened}"
                shift
                ;;
        esac
    done

    searchExpression=${searchExpression#$replaceTerm}
    searchExpression=${searchExpression%$replaceTerm}
    if [[ "$copy" = "true" ]]; then
        echo -n "$searchExpression" | pbcopy
    fi
    echo "$searchExpression"
}

#source ~/lab/scrap/bash/test.sh

# experimenting with commands to
function vcom() {

    echo "$(history | tail -n 1 | awk '{$1="";print $0}')" > /tmp/lastcommand.txt
    nvim /tmp/lastcommand.txt

}

# jot down on napkin 
# jot will create file in /tmp
function jot() {

    local fileScratch="nap"
    local jotQuery="nap-"

    while [[ $# -gt 0 ]]; do

      key="$1"
      shift

      case "$key" in

        '-query')
          jotQuery="$1"
          shift
          ;;

        *)
          fileScratch="${fileScratch}-${key}"
          ;;
      esac
        
    done

    # no filename
    if [[ $fileScratch != "nap" ]]; then

      nvim "/tmp/${fileScratch}"
      echo "blah /tmp/${fileScratch}"

    else

      echo "" > /tmp/fzf-query
      filesToEdit=$(ls -1 /tmp/ | fzf --multi --preview 'bat --style=numbers --color=always --line-range :500 /tmp/{}' --query "$jotQuery"  --bind 'change:execute(echo {q} > /tmp/fzf-query)' --bind 'ctrl-r:execute(echo "" > /tmp/fzf-query)')
      
      editFiles=()
      for tempFile in $(echo "$filesToEdit"); do
        editFiles+=("/tmp/$tempFile")
      done
#      editFiles=($(echo "$filesToEdit" | sed -r 's/nap/\/tmp\/nap/g'))

      local fzfQuery=$(cat /tmp/fzf-query)
      if [[ "$editFiles" ]]; then
        nvim $editFiles
        echo "|$editFiles|"
      elif [[ "$fzfQuery" ]]; then # if there as a query but it did not create results
        nvim "/tmp/$fzfQuery"
      fi

    fi

}

function xshot() {

  local currentDir=$(pwd)

  local fzfDefaultCommandBackup=$FZF_DEFAULT_COMMAND
  unset FZF_DEFAULT_COMMAND

  cd ~/lab/screenshots
  ls -1t | fzf --preview='kitten icat --clear --transfer-mode=memory --stdin=no --place=${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}@65x10 {} > /dev/tty'

  export FZF_DEFAULT_COMMAND=$fzfDefaultCommandBackup

  cd $currentDir 

}

function xtail() {

  local currentDirectory=$(pwd)
  local tailFiles=$(fzfpreview $currentDirectory)

  local tailList=()
  for element in $(echo $tailFiles | tr '\n' ' '); do
    tailList+=("$element")
  done

  if [ ${#tailList[@]} -gt 0 ]; then
    tail -f $tailList
  fi


}

# multiple du command override
function du() {
    if [[ $# -gt 0 ]]; then
        /usr/bin/du "$@"
    else
        /usr/bin/du -sh *
    fi
}

# grep processs command
function psx() {
    pid=$(ps -ef | sed 1d | fzf -m --ansi --color fg:-1,bg:-1,hl:46,fg+:40,bg+:233,hl+:46 --color prompt:166,border:46 --height 75%  --border=sharp --prompt="➤  " --pointer="➤ " --marker="➤ " | awk '{print $2}')

    # check to see if set at all
    if [[ -n $pid ]]; then
      echo "has pid $pid"
      # iterate through loop for multiple pids
      for pIndex in $(echo $pid); do
        sudo kill $pIndex
#        echo "x $pIndex"
      done
#      kill -${1:-9} $pid
    fi
#    ps aux | grep -i "$@"
}

# this is useless
function bindlogs() {
    echo "rndc querylog" | pbcopy
}

# usage find last section of a path string.  Example: arn:aws:elasticloadbalancing:us-west-1:046314659632:loadbalancer/app/Tableau/799361ae3e1ff416
# we want 799... etc (the last section).
# lastBreadcrumb "[PATH STRING]" "[SEARCH]" "[REPLACE]"
# So replace the forslashes with space and echo out the last segment
# lastBreadcrumb "arn:aws:elasticloadbalancing:us-west-1:046314659632:loadbalancer/app/Tableau/799361ae3e1ff416" "\/" " "
function lastBreadcrumb() {

  haystack="$1"
  needleSearch="$2"
  needleReplace="$3"

  product=$(echo "$haystack" | sed "s/$needleSearch/$needleReplace/g")
  #echo "output |$product|"
  lastterm=""
  for term in $(echo $product)
  do
      lastTerm="$term"
  done
  echo "$lastTerm"

}

# rm all files unneeded
function deletemisc() {

  echo "delete .DS_Store, __pycache__ directories / files"
  deletedsstore
  deletepycache
  deletemacfiles

}

# remove dsstore files
function deletedsstore() {

  find . -iname ".DS_STORE" -type f -delete

}

# delete cache content
function deletepycache() {

  find . -iname "__pycache__" -type d -exec rm -rf "{}" \;

}

function deletemacfiles() {

  find . -iname "__MACOSX" -type f -delete

}

# script search in directory
function xscript() {

  local currentPWD=$(pwd)

  cd "$HOME/lab/scripts"
  # query via filenames 
#  filesToEdit=$(find ~/lab/scripts -iname "*.sh" | fzf --multi --preview "bat --style=numbers --color=always --line-range :500 {}")
  local filesToEdit=$(fzf --multi --ansi --disabled --query "$INITIAL_QUERY" \
    --bind "start:reload:$RG_PREFIX {q}" \
    --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
    --delimiter : \
    --preview 'bat --color=always {1} --highlight-line {2}')
#    --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
#    --bind 'enter:become(vim {1} +{2})')
#  echo ">>fileEdit: $filesToEdit"
  filesToEdit=$(echo "$filesToEdit" | awk -F: '{print $1}')
  echo ">>fileEdit: $filesToEdit"
  filesToEdit=($(echo "$filesToEdit" | sed -r 's/\n/ /g'))
  echo ">>fileEdit: $filesToEdit"
  nvim $filesToEdit
  cd $currentPWD

#    command! -bang -nargs=* Rg call fzf#vim#grep("rg --column -i --context 4 --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>) . " " . @r, 1, { "options": '--delimiter : --nth 4..' }, <bang>0) "" new bang command that searches the current file directory or register r.  This allows for us to change the register value to whatever we want

}

# mark delete.  Move to tmp directory
function mdelete() {

    currentDate=$(date +"%y%m%d%H%M")

    while [[ $# -gt 0 ]];
    do

        echo "move \"$1\" to \"/tmp/$1.$currentDate\""
        mv -f "$1" "/tmp/$1.$currentDate"
        shift

    done

}

# mark move.  Move with epoch
function mmove() {

    currentDate=$(date +"%y%m%d%H%M")

    while [[ $# -gt 0 ]];
    do

        echo "move \"$1\" to \"$1.$currentDate\""
        mv -f "$1" "$1.$currentDate"
        shift

    done

}

# mark backup.  Copy directory to epoch directory
function mbackup() {

  currentDate=$(date +"%y%m%d%H%M")
  re='^[0-9]+$'
  while [[ $# -gt 0 ]];
  do

    orgFilename="$1"
    filename=$(basename -- "$orgFilename")
    filename="${filename%.*}"
    extension="${filename##*.}"
    echo "$orgFilename $filename"
    extension="${orgFilename##*.}"
    newFilename="$filename.$currentDate"

    if [[ $filename != "$orgFilename" ]]; then

      # check to see if extension is just a number
      # if not a number, assume it's a date and discard the old extension
      # otherwise add current date to extension
      if ! [[ $extension =~ $re ]]; then

        newFilename="$filename.$currentDate.$extension"

      fi

    fi

    echo "cp -rf \"$orgFilename\" \"$newFilename\""
    cp -rf "$orgFilename" "$newFilename"
    shift

  done

}

#function marktemp() {
#  mv -f $1 /tmp/. 
#}

# script configurations
function cyaml() {
  c -y "$@"
}

function c() {
  
  local scriptDir=~/lab/scripts
  local targetDir="$scriptDir/1first"
  local searchExt=".sh"
  local yamlDir=~/lab/scripts/tmuxp
  local defaultSearch=""
  local searchTerm="$defaultSearch"
  local sFilename="$defaultSearch"
  local shExt=".sh"
  local yamlExt=".yaml"
  local filesToEdit=""

  while [[ $# -gt 0 ]]; do

    key="$1"

    case "$key" in

      '-y' )
        # yaml file.  Assume they want the directory ~/lab/scripts/tmuxp
        searchExt=".yaml"
        targetDir=$yamlDir
        shift
        ;;

      * )
        if [[ "$searchTerm" == "$defaultSearch" ]] ; then
            searchTerm="$key*"
        else
            searchTerm="$searchTerm$key*"
        fi
        shift
        ;;
    esac

  done


  sFilename=$(echo $searchTerm | sed "s/*//g")
  #echo "filename $sFilename"

  if [[ "$sFilename" == "sh" ]] ; then
      sFilename="jumpssh"
      searchTerm="jumpssh"
  elif [[ "$sFilename" == "jump" ]] ; then
      sFilename="jumpscript"
      searchTerm="jumpscript"
  elif [[ "$sFilename" == "s" ]] ; then
      sFilename="settings"
      searchTerm="settings"
  elif [[ "$sFilename" == "c" ]] ; then
      sFilename="confluent"
      searchTerm="confluent"
  elif [[ "$sFilename" == "y" ]] ; then
      sFilename="yabai"
      searchTerm="yabai"
  elif [[ "$sFilename" == "-" ]] ; then

      echo "\n----- $scriptDir -----\n"
      ls $scriptDir
      echo "\n----- $yamlDir -----\n"
      ls $yamlDir
      return
  fi


  local scriptQuery=$searchTerm
  if [[ $searchTerm ]]; then

    filesToEdit=$(find ~/lab/scripts -type f -iname "*$searchTerm$shExt" -o -iname "*$searchTerm$yamlExt")
    echo "Targets $filesToEdit"

    if [[ $filesToEdit ]]; then
      nvim $(echo "$filesToEdit")
      return
    fi

  else

    echo "" > "/tmp/script-query"
    filesToEdit=$(rg --files ~/lab/scripts | fzf --multi --preview 'bat --style=numbers --color=always --line-range :500 {}' --bind 'change:execute(echo {q} > /tmp/script-query)' --bind 'ctrl-r:execute(echo "" > /tmp/script-query)')
    
    local editFiles=()
    for tempFile in $(echo "$filesToEdit"); do
      editFiles+=("$tempFile")
    done

    # if you have files edit them
    if [[ "$editFiles" ]]; then
      nvim $editFiles
      return
    fi

  fi

  scriptQuery=$(cat /tmp/script-query)
  
  sFilename="$scriptQuery"
  # if this file does not exists go digging for it
  if [[ $scriptQuery ]]; then
      #echo "$scriptDir/$sFilename.sh"

      read -qr "ANSWER?Create $targetDir/$sFilename$searchExt?"

      case $ANSWER in
          [yY] )
              echo "|$ANSWER| yes"
              nvim "$targetDir/$sFilename$searchExt"
              break
              ;;
          [nN] )
              echo "|$ANSWER| no"
              break
              ;;
          * )
              echo "Yes or No answers please"
              ;;
      esac

  fi

}

function needleHay() {

  srSearch="$1"
  srReplace="$2"
  srTarget="$3"
  sed -e "s/$srSearch/$srReplace/g" $srTarget > "$srTarget.bak"
  mv "$srTarget.bak" "$srTarget"

}

hscrub() {

  currentLang=$LANG

  export LANG="C"
  echo "sed -ir \"/$1/Id\" ~/.zsh_history"
  sed -ir "/$1/Id" ~/.zsh_history
#  mv ~/.zsh_history.bak ~/.zsh_history

  export LANG=$currentLang

}

function hscrubaws() {

  hscrub 'AWS_ACCESS_KEY_ID'
  hscrub 'AWS_SECRET_ACCESS_KEY'
  hscrub 'AWS_SESSION_TOKEN'

}

# when I need it to work with other programs like mtr we mask it instead of term being xterm-kitty
# Don't need anymore cause doing it in ssh config
function termmask() {

  export TERM=xterm-256color

}

# grep environment variable
function xenv() {
  env | fzf
}

# history backup file
function hbackup() {

    currentTime=$(date +"%y%m%d")
    histLowCount=1260

    locationNote="location ~/lab/scripts/edit.sh. "
    hCount=$(wc -l < ~/.zsh_history)
    hCount=$(echo "$hCount" | xargs)

    # don't perform backup of history if it's low
    if [[ $hCount -lt $histLowCount ]]; then

      histDir=~/.config/zshhistory
      #echo "!History ($hCount) < $histLowCount"
      #/bin/ls -la $histDir | tail -n 1
      histLast=$(/bin/ls -la1 $histDir | tail -n 1)
      #echo "cp $histDir/$histLast ~/.zsh_history"

    else

      # if file does not exists
      if [[ ! -f ~/.config/zshhistory/.zsh_history.${currentTime} ]]; then

        #echo -n "$locationNote Perform backup ~/.config/zshhistory/.zsh_history.${currentTime} $hCount"
        cp ~/.zsh_history ~/.config/zshhistory/.zsh_history.${currentTime}

      #else

        #echo -n "$locationNote"
        #echo "Backup exists $hCount."

      fi

    fi

}

# cat copy via arguement
function catcp() {
  cat $1 | pbcopy
  cat $1
}


# printing functions 

# put echo into file
function pecho() {

  local message=""
  key=''

  while [[ $# -gt 0 ]]; do

    message="$message $1"
    shift
    
  done

  local fname="${funcstack[2]}"
  echo "$fname:$message" >> /tmp/log-gecho

}

# get echo from file.  Then empty
function gecho() {
  
  cat /tmp/log-gecho
  echo "" > /tmp/log-gecho

}

# requires wonderword
function gentitle() {
    
  local wonderwordadjective=($(wonderwords -w -p adjective) $(wonderwords -w -p adjective) $(wonderwords -w -p adjective) $(wonderwords -w -p adjective) $(wonderwords -w -p adjective))

  local wonderwordnoun=($(wonderwords -w -p noun) $(wonderwords -w -p noun) $(wonderwords -w -p noun) $(wonderwords -w -p noun) $(wonderwords -w -p noun))

  export RANDOM_TITLE1=$wonderwordadjective[1]-$wonderwordnoun[1]
  export RANDOM_TITLE2=$wonderwordadjective[2]-$wonderwordnoun[2]
  export RANDOM_TITLE3=$wonderwordadjective[3]-$wonderwordnoun[3]
  export RANDOM_TITLE4=$wonderwordadjective[4]-$wonderwordnoun[4]
  export RANDOM_TITLE5=$wonderwordadjective[5]-$wonderwordnoun[5]

  if [[ $# -gt 0 ]]; then
    echo $RANDOM_TITLE1
  fi

}
