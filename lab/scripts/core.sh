alias ccore="c core"
alias cdo="c todo"
alias ce="c edit"
alias cl="c -"
alias cy="c y"
alias jote="jot -query ''"
alias lint="yamllint "
alias wfood="wonderfood"
alias wtitle="wondertitle"
alias Ed="X -cd"
alias ee="e 2"
alias eee="e 3"
alias e2="ee"
alias e3="e 3"
alias e4="e 4"
alias e5="e 5"

# edit git file
function xgit() {

    currentFolder=$(pwd)
    rootFolder=$(gitrootfolder)
    cd $rootFolder
#    vim -c "/url" ".git/config"
    vim ".git/config"
    echo "$rootFolder"
    cd $currentFolder

}

function xignore() {

    currentFolder=$(pwd)
    rootFolder=$(gitrootfolder)
    cd $rootFolder
    vim ".gitignore"
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

    local currentFolder=$(pwd)
    local rootFolder=$(gitrootfolder)
    local searchExpression="$1"

    local filesToEdit=$(find $rootFolder -iname "$searchExpression")

    pecho "find $rootFolder -iname \"$searchExpression\""
    pecho "$filesToEdit"

    local fileCount=$(echo "$filesToEdit" | wc -l)
    fileCount=$((fileCount))
    local editFiles=''
    local modeNoFiles=''

    if [[ $fileCount -gt 0 ]]; then
      editFiles=($(echo "$filesToEdit" | sed -r 's/\n/ /g'))

#      becho "editFiles: |$editFiles| $fileCount"
      if [[ $editFiles == '' ]]; then
        modeNoFiles='t'
      else 
        vim $editFiles
      fi
    else 
      modeNoFiles='t'
    fi

    if [[ $modeNoFiles ]]; then
       becho "$searchExpression not found"
    fi
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
  echo -n "" > $queryFile

  local filesToEdit=$(rg --files $searchDirectory | fzf --multi --preview "bat --style=numbers --color=always --line-range :500 {}" --bind "change:execute(echo {q} > $queryFile)" --bind "ctrl-r:execute(echo \"\" > $queryFile)" --query "$defaultQuery")

  if [[ ${#filesToEdit[@]} != 0 ]]; then

    editFiles=($(echo "$filesToEdit" | sed -r 's/\n/ /g'))
    echo "$filesToEdit"

  else

    echo "$queryFile"

  fi


}

# search /tmp directory
function xtmp() {

  local tempResults=$(fzfpreview /tmp)
  local editFiles=()
  for element in $(echo $tempResults | tr '\n' ' '); do
    editFiles+=("$element")
  done

  if [ ${#editFiles[@]} -gt 0 ]; then
    vim -f $editFiles
  fi


}

function e() {

  local modeTail=1
  local key=''

  while [[ $# -gt 0 ]]; do
    modeTail="$1"
    shift
  done

  # echo "tail $modeTail"
  local vimToEdit=($(eza --all --sort=modified --long -f | tail -n $modeTail | awk '{print $(NF)}' |  sed -r 's/\n/ /g'))
#  echo "|$vimToEdit|"
  vim $vimToEdit

}

# go into fzf for searching files and edit
function x() {

    local goToDirectory='f'
    local rootDirectory=''
    local currentDirectory=$(pwd)
    local lastOnly='f'
    local searchString=''

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
            shift
            ;;
          *) 
            searchString="${searchString}${key}"
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
          vim $isFile
          break
        fi
      done

    else

      local filesToEdit=$(find . -type f -iname "*$searchString*")
      local fileCount=$(echo "$filesToEdit" | wc -l)
      fileCount=$((fileCount))
      if [[ $fileCount -gt 1 ]]; then
        filesToEdit=$(fzf --multi --query "$searchString")
      fi

      if [[ ${#filesToEdit[@]} != 0 ]]; then

          if [[ $goToDirectory == 't' ]]; then

            cd $(dirname $filesToEdit)

          else

  #          echo "array1 ${filesToEdit[@]}"
            editFiles=($(echo "$filesToEdit" | sed -r 's/\n/ /g'))

            vim $editFiles

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

alias xG="eg '?'"

# open all files that are modified / new / deleted to vim from git 
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
      vim $(git status --porcelain | awk '{ if ($1 == "M" || $1 == "??" )  print $2}')
      echo "files to edit $filesToEdit"
    fi

  else

    # only modified
    filesToEdit=$(git status --porcelain | awk '{ if ($1 == "M") print $2}')

    if [[ $filesToEdit != '' ]]; then 
      vim $(git status --porcelain | awk '{ if ($1 == "M") print $2}')
      echo "files to edit $filesToEdit"
    fi

  fi


}


function hashdir() {

  local hashDir=$(md5 -q -s $(pwd))
  echo "$hashDir"

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
      echo "$currentResults"
      results="$results\n$currentResults"
    else
      echo "$line: missing"
      results="$results\n$line: miss"
    fi

  done <$fileA

  echo "$results" | pbcopy
  echo "$results" > /tmp/ab.txt

}

function replaceall() { # from the target ($1), replace ($2) with value ($3)

  local searchTarget="$1"
  searchTarget=$(echo "$searchTarget" | sed "s/$2/$3/g")
  echo "$searchTarget" 

}


# not working yet
function strjoin() {

  echo "$1" | sed "s/$2/$3/g"

}


function stripends() { # from the target ($1), strip out values from both ends ($2+)

  local searchTarget="$1"
  shift
  
  while [[ $# -gt 0 ]]; do
    searchTarget=$(echo "$searchTarget" | sed "s/$1//g")
    shift
  done
    
  echo "$searchTarget"

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


#    echo "searchExpression $searchExpression"
    if [[ $searchExpression = '.*' ]]; then
        echo "No expression"
    else
        searchExpression=${searchExpression##\.\*}
        searchExpression=${searchExpression%%\.\*}

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
                    echo $nputResults >> $targetFile
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
                    echo "search expression '$searchExpression'"
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

      vim "/tmp/${fileScratch}"

    else

      echo "" > /tmp/fzf-query
      filesToEdit=$(ls -1 /tmp/ | fzf --multi --preview 'bat --style=numbers --color=always --line-range :500 /tmp/{}' --query "$jotQuery"  --bind 'change:execute(echo {q} > /tmp/fzf-query)' --bind 'ctrl-r:execute(echo "" > /tmp/fzf-query)')
      
      editFiles=()
      for tempFile in $(echo "$filesToEdit"); do
        editFiles+=("/tmp/$tempFile")
      done
#      editFiles=($(echo "$filesToEdit" | sed -r 's/nap/\/tmp\/nap/g'))

      local fzfQuery=$(cat /tmp/fzf-query | sed 's/ /-/g')
      if [[ "$editFiles" ]]; then
        vim $editFiles
        echo "|$editFiles|"
      elif [[ "$fzfQuery" ]]; then # if there as a query but it did not create results
        vim "/tmp/$fzfQuery"
      fi

    fi

}

function ximage() {

  local fzfDefaultCommandBackup=$FZF_DEFAULT_COMMAND
#  unset FZF_DEFAULT_COMMAND

  local currentDir=$(pwd)
  local output=$(ls -1t | fzf --preview='kitten icat --clear --transfer-mode=memory --stdin=no --place=${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}@65x10 {} > /dev/tty')
#  ls -1t | fzf --preview='kitten icat --clear --transfer-mode=memory --stdin=no --place=${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}@65x10 {} > /dev/tty'
  ref -f $currentDir/$output 
#  echo "output $output"

#  export FZF_DEFAULT_COMMAND=$fzfDefaultCommandBackup

}

function xshot() {

  local currentDir=$(pwd)

  local fzfDefaultCommandBackup=$FZF_DEFAULT_COMMAND
#  unset FZF_DEFAULT_COMMAND

  cd ~/lab/screenshots
  local screenDir=$(pwd)
  local output=$(ls -1t | fzf --preview='kitten icat --clear --transfer-mode=memory --stdin=no --place=${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}@65x10 {} > /dev/tty')
#  ls -1t | fzf --preview='kitten icat --clear --transfer-mode=memory --stdin=no --place=${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}@65x10 {} > /dev/tty'
  ref -f $screenDir/$output 
  echo "output $output"

#  export FZF_DEFAULT_COMMAND=$fzfDefaultCommandBackup

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

# grep processs command and kill
function p() {
  
  local hashDir=$(md5 -q -s $(pwd))
  local queryFile="/tmp/query-$hashDir"
  
  local defaultQuery=''

  if [[ -f $queryFile ]]; then
    defaultQuery=$(cat $queryFile)
  fi

  if [[ $# -gt 0 ]]; then
    defaultQuery=$1
    shift
  fi

  pid=$(ps -ef | sed 1d | grep -v "$hashDir" | fzf -m --ansi --color fg:-1,bg:-1,hl:46,fg+:40,bg+:233,hl+:46 --color prompt:166,border:46 --height 75%  --border=sharp --prompt="➤  " --pointer="➤ " --marker="➤ " --bind "change:execute(echo {q} > $queryFile)" --query "$defaultQuery" | awk '{print $2}')

  # check to see if set at all
  if [[ -n $pid ]]; then
    echo "has pid $pid"
    # iterate through loop for multiple pids
    for pIndex in $(echo $pid); do
#      sudo kill $pIndex
      kill $pIndex
      echo "x $pIndex"
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
  vim $filesToEdit
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

# mark copy to temp.  Move with epoch
function mtmp() {

    currentDate=$(date +"%y%m%d%H%M")

    while [[ $# -gt 0 ]];
    do

        echo "copy \"$1\" to \"/tmp/$1.$currentDate\""
        cp -rf "$1" "/tmp/$1.$currentDate"
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
  local searchExt='.sh'
  local yamlDir=~/lab/scripts/tmuxp
  local defaultSearch=''
  local searchTerm="$defaultSearch"
  local sFilename="$defaultSearch"
  local shExt='.sh'
  local yamlExt='.yaml'
  local filesToEdit=''
  local modeSearchTerm=''

  while [[ $# -gt 0 ]]; do

    key="$1"

    case "$key" in

      '-y' )
        # yaml file.  Assume they want the directory ~/lab/scripts/tmuxp
        searchExt='.yaml'
        targetDir=$yamlDir
        shift
        ;;

      * )
        if [[ "$searchTerm" == "$defaultSearch" ]] ; then
            searchTerm="$key*"
        else
            searchTerm="$searchTerm$key*"
            modeSearchTerm='t'
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
  elif [[ "$sFilename" == "todo" ]] ; then
      sFilename="todo"
      searchTerm="todo"
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
      vim $(echo "$filesToEdit")
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
      vim $editFiles
      return
    fi

  fi

  becho "searchTerm |$searchTerm|"

  if [[ $searchTerm ]]; then
    scriptQuery=$(echo "$searchTerm" | tr -d '*')

  else
    scriptQuery=$(cat /tmp/script-query)
  fi

  becho "searchTerm |$searchTerm|"
  
  sFilename="$scriptQuery"
  # if this file does not exists go digging for it
  if [[ $scriptQuery ]]; then
      #echo "$scriptDir/$sFilename.sh"

      read -qr "ANSWER?Create $targetDir/$sFilename$searchExt?"

      case $ANSWER in
          [yY] )
              echo "|$ANSWER| yes"
              vim "$targetDir/$sFilename$searchExt"
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

# cat copy via arguement
function catcp() {
  cat $1 | pbcopy
  cat $1
}

function wonderfood() {
#  ~/lab/scripts/python/wonderfood.py | sed 's/ /-/g'
  local foodSent=$(~/lab/scripts/python/wonderfood.py)
  echo "$foodSent"
}

# requires wonderword
function iama() {
    
  local wonderAdjective=$(wonderwords -w -p adjective)
  local wonderNoun=$(wonderwords -w -p noun)
  local wonderSituation=$(wonderwords -w -p noun)
  local wonderVerb=$(wonderwords -w -p verb)

  echo -n "I am your $wonderVerb $wonderAdjective $wonderNoun of a $wonderSituation$1"

}

# requires wonderword
function wondertitle() {
    
  local wonderwordadjective=$(wonderwords -w -p adjective) 
  local wonderwordnoun=$(wonderwords -w -p noun)

  export RANDOM_TITLE1="$wonderwordadjective-$wonderwordnoun"

  if [[ $# -gt 0 ]]; then
    echo $RANDOM_TITLE1
  fi

}

function oo() {

  if [[ $# -gt 0 ]]; then
    open $1
    return
  fi
  open .

}
