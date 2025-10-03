alias ccore="c core"
alias ctokens="c tokens"
alias ccop="c cop"
alias cdo="c todo"
alias ce="c edit"
alias cl="c -"
alias cy="c y"
alias jote="jot -query ''"
alias lint="yamllint "
alias wfood="wonderfood"
alias wtitle="wondertitle"
alias Ed="E -cd"
alias ee="e 2"
alias eee="e 3"
alias e2="ee"
alias e3="e 3"
alias eee="e 3"
alias e4="e 4"
alias eeee="e 4"
alias egr="e -g "
alias e5="e 5"
alias eeeee="e 5"
alias ex="e -g"
alias fo="f -o"
alias zclear="yes | rm ~/.zcompdump*"

export COP_FROM_FILE=~/lab/scripts/0zero
export COP_TO_FILE=/tmp

function cover() {

  if [ "$1" ]; then

    openssl enc -aes-256-cbc -md sha512 -pbkdf2 -iter 1000000 -salt -in $1 -out "$1.enc"
    /bin/mv "$1.enc" $1

  fi
}

function uncover() {

  if [[ "$1" ]]; then

    openssl enc -aes-256-cbc -md sha512 -pbkdf2 -iter 1000000 -salt -in $1 -d 

  fi

}



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

# edit git file
function egit() {

    currentFolder=$(pwd)
    rootFolder=$(gitrootfolder)
    cd $rootFolder
#    vim -c "/url" ".git/config"
    vim ".git/config"
    echo "$rootFolder"
    cd $currentFolder

}

function eignore() {

    currentFolder=$(pwd)
    rootFolder=$(gitrootfolder)
    cd $rootFolder
    vim ".gitignore"
    cd $currentFolder

}

# find docker file
function edoc() {
    gfile "Dockerfile"
}

# edit ci yaml file without looking
function ec() {
    gfile ".gitlab-ci.yml"
}

# go up to root folder and find a file
function gfile() {

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
function etmp() {

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
  
  local grepString=''
  local key=''
  local modeTail='1'
  local modeGrep=''
  local modeNoEdit=''
  local searchOutput="/tmp/esearch.txt"
  local searchResults="/tmp/esearch-filter.txt"
  local searchString=''
  local startLoading=''
  local targetFile=''

  while [[ $# -gt 0 ]]; do
    
    key="$1"
    shift

    case "$key" in

      '-e' ) modeNoEdit='t' ;;

      '-g' ) modeGrep='t' ;;

      # check to see if number
      +([0-9]) ) modeTail="$key" ;;
        
      *) 

        searchString="${searchString}.*${key}"

        if [[ $grepString == '' ]]; then
          grepString="${key}"
        else
          grepString="${grepString}*${key}"
        fi

      ;;

    esac

  done

  local vimToEdit=''

  # grep the results
  if [[ $modeGrep ]]; then

    echo "search | $searchString"
    vimToEdit=($(eza --all --sort=modified -1 -f --only-files | grep -i $searchString | tail -n $modeTail | sed -r 's/\n/ /g'))

  else

    echo -n "" > $searchOutput

    # echo "tail $grepString"
    eza --all --sort=modified --reverse -1 -f --only-files > $searchOutput

    totalCount=$(cat $searchOutput | wc -l)
    fileCount=0
    fileFinal=0

    while read currentValue; do
      targetFile=$currentValue
      # echo $currentValue
      if echo "$targetFile" | grep -iq "$searchString"; then

        break

      fi
      ((fileCount=fileCount+1))
    done < $searchOutput

    ((fileFinal=totalCount-fileCount))
    tail -n $fileFinal $searchOutput >  $searchResults    

    # echo "|$targetFile| $grepString"
    vimToEdit=($(cat $searchResults | head -n $modeTail | sed -r 's/\n/ /g'))

  fi

  echo "edit $vimToEdit"

  if [[ $modeNoEdit != 't' ]]; then
    vim $vimToEdit
  fi

}

# go into fzf for searching files and edit
function E() {

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
#        filesToEdit=$(ls -1t modified -sold | fzf --multi --query "$searchString")
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
function eroot() {

    rootFolder=$(gitrootfolder)

    e -d $rootFolder $@

}


function edif() {

  preview="git diff $@ --color=always -- {-1}"
  # git status --porcelain | awk '{print $2}' | fzf --multi | while read fileSelected; do
  git status --porcelain | awk '{print $2}' | git diff $@ --name-only | fzf -m --ansi --preview $preview | while read fileSelected; do

  # git diff $@ --name-only | fzf -m --ansi --preview $preview
  done

}

function er() {

  # ripgrep->fzf->vim [QUERY]
  local RELOAD="reload:rg --column --color=always --smart-case {q} || :"
  local OPENER='if [[ $FZF_SELECT_COUNT -eq 0 ]]; then
            nvim {1} +{2}     # No selection. Open the current line in Vim.
          else
            nvim +cw -q {+f}  # Build quickfix list for the selected items.
          fi'
  fzf --disabled --ansi --multi \
      --bind "start:$RELOAD" --bind "change:$RELOAD" \
      --bind "enter:become:$OPENER" \
      --bind "ctrl-o:execute:$OPENER" \
      --bind 'alt-a:select-all,alt-d:deselect-all,ctrl-/:toggle-preview' \
      --delimiter : \
      --preview 'bat --style=full --color=always --highlight-line {2} {1}' \
      --preview-window '~4,+{2}+4/3,<80(up)' \
      --query "$*"

}

alias eG="eg '?'"

# open all files that are modified / new / deleted to vim from git 
function eg() {

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
function fcp() {

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
    
  local relativePath="$PWD"

  # if it's part of the home directory.  Remove home directory mention (sensitive data)
  if [[ "$PWD" = *$HOME* ]]; then
    relativePath="~${PWD#"$HOME"}"
  fi

  echo "$relativePath/" 
  echo -n "$relativePath/" | pbcopy

}

# grep listing
function grl() {
    gr -l $@
}


# ?? not coded in gr function
function gri() {

    gr -i $@

}

function grcdl() {
    gr -ci -l $@
}

# duplicate of ec
function grcd() {
    gr -ci $@
}

# match all from file a to file b in order
# Meaning: file a: go line by line.  Match to file b.  Output 
function grab() {

  local fileA="$1"
  local fileB="$2"
  local results=""
  local currentResults=""

  while read line; do

    # echo "line: $line"
    currentResults=$(grep -i "$line" $fileB)
    if [[ $currentResults ]]; then
      echo "$currentResults"
      results="$results\n$currentResults"
    else
      # echo "!! Missing $line"
      results="$results\n$line: miss"
    fi

  done <$fileA
  # echo "blah"

  echo "$results" | pbcopy
  echo "$results" > /tmp/ab.txt

}

function srabc() { # from the target ($1), replace ($2) with value ($3)

  local searchTarget="$1"
  local searchFor="${2:= }"
  local replaceFor="${3:=_}"

  searchTarget=$(echo "$searchTarget" | sed "s/$searchFor/$replaceFor/g")
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
# use silver searcher instead
function gr() {

    local searchExpression='.*'
    local shouldList='false'
    local searchCICD='f'
    local targetFile="*"
    local modeFound=''
    local modeAfter='0'
    local modeBefore='0'

    while [[ $# -gt 0 ]]
    do

        key="$1"
        shift

        case $key in

            '-l' )
                shouldList='true'
                ;;
            '-ci' )
                searchCICD='t'
                ;;
            # # check to see if number
            # # context before and after
            # +([0-9]) ) 
            #
            #   if [[ $modeFound ]]; then
            #     modeBefore="$key"
            #   else
            #     modeFound='t'
            #     modeAfter="$key"
            #   fi
            # ;;

            * )
                searchExpression="$searchExpression${key}.*"
                ;;

        esac

    done


#    echo "searchExpression $searchExpression"
    if [[ $searchExpression == '.*' ]]; then
        echo "No expression"
    else
        searchExpression=${searchExpression##\.\*}
        searchExpression=${searchExpression%%\.\*}

        #echo "search term $searchExpression"
        if [[ $searchCICD == 't' ]]; then
            if [[ $shouldList = "true" ]]; then
                find . -iname ".gitlab-ci.yml" -exec grep -il -A $modeAfter -B $modeBefore "$searchExpression" {} \;
            else
                find . -iname ".gitlab-ci.yml" -exec grep -i  -A $modeAfter -B $modeBefore "$searchExpression" {} \;
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
                    # ggrep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox} -irl  -A $modeAfter -B $modeBefore "$searchExpression" $targetFile
                    ag -l -A $modeAfter -B $modeBefore  "$searchExpression" $targetFile
                else
                    # dumping to null cause this will error out on * due to the backtick evaluation
                    # ggrep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox} -irl -A $modeAfter -B $modeBefore "$searchExpression" *
                    ag -l -A $modeAfter -B $modeBefore "$searchExpression" *
                fi
            else
                #echo "ggrep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox} -ir \"$searchExpression\" $targetFile"
                if ! [[ -t 0 ]]; then
                    # ggrep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox} -ir -A $modeAfter -B $modeBefore "$searchExpression" $targetFile
                    ag -ir --nonumbers -A $modeAfter -B $modeBefore "$searchExpression" $targetFile
                else
                    # dumping to null cause this will error out on * due to the backtick evaluation
                    echo "search expression '$searchExpression'"
                    # echo "ggrep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox} -ir -A $modeAfter -B $modeBefore \"$searchExpression\" *"
                    ag -ir --nonumbers -A $modeAfter -B $modeBefore "$searchExpression" *
                fi
            fi
        fi

    fi
}

# find file
function f() {

    searchexpression="*"
    modeOpen=''
    modeRemove=''


    while [[ $# -gt 0 ]]; do
        key="$1"
        shift

        case $key in

            '-o' )
                modeOpen='t'
                ;;

            '-rm' )
                modeRemove='t'
                ;;

            

            * )
                searchexpression="$searchexpression${key}*"
                ;;
        esac

    done


    if [[ $searchExpression != '*' ]]; then

      if [[ $modeRemove == 't' ]]; then

        echo "find . -iname \"$searchexpression\" -exec rm {} \\;"
        find . -iname $searchexpression -exec rm {} \;

      elif [[ $modeOpen == 't' ]]; then

        echo "find . -iname \"$searchexpression\" -exec open {} \\;"
        find . -iname $searchexpression -exec open {} \;

      else

        echo "find . -iname \"$searchexpression\""
        find . -iname $searchexpression

      fi

    else 

      echo "expression?"

    fi

}


# find and grep list
function fgrl() {
    fgr $@ -l

}

# find and grep
function fgr() {
    fileExpression="$1"
    searchExpression="$2"
    listOption='f'
    shift
    shift

    while [[ $# -gt 0 ]];
    do
        key="$1"
        shift 

        case $key in
            '-l' )
                listOption='t'
                ;;
            * )
                ;;
        esac
    done

    if [[ $listOption == 't' ]];
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
        shift

        case $key in
            '-s' )
                searchTerm="$2"
                shift
                ;;
            '-r' )
                replaceTerm="$2"
                shift
                ;;
            '-c' )
                copy='true'
                ;;
            * )
                shortened=$(echo $key | sed "s/$searchTerm/$replaceTerm/g")
                searchExpression="$searchExpression${replaceTerm}${shortened}"
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
function nap() {

    local fileScratch="kin"
    local jotQuery="kin-"

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
    if [[ $fileScratch != "kin" ]]; then

      vim "/tmp/${fileScratch}"

    else

      echo "" > /tmp/fzf-query
      filesToEdit=$(ls -1 /tmp/ | fzf --multi --preview 'bat --style=numbers --color=always --line-range :500 /tmp/{}' --query "$jotQuery"  --bind 'change:execute(echo {q} > /tmp/fzf-query)' --bind 'ctrl-r:execute(echo "" > /tmp/fzf-query)')
      
      editFiles=()
      for tempFile in $(echo "$filesToEdit"); do
        editFiles+=("/tmp/$tempFile")
      done
#      editFiles=($(echo "$filesToEdit" | sed -r 's/kin/\/tmp\/kin/g'))

      local fzfQuery=$(cat /tmp/fzf-query | sed 's/ /-/g')
      if [[ "$editFiles" ]]; then
        vim $editFiles
        echo "|$editFiles|"
      elif [[ "$fzfQuery" ]]; then # if there as a query but it did not create results
        vim "/tmp/$fzfQuery"
      fi

    fi

}

function etail() {

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
function escript() {

  local currentPWD=$(pwd)

  cd "$HOME/lab/scripts"
  # query via filenames 
#  filesToEdit=$(find $HOME/lab/scripts -iname "*.sh" | fzf --multi --preview "bat --style=numbers --color=always --line-range :500 {}")
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
  
  local scriptDir=$HOME/lab/scripts
  local targetDir="$scriptDir/1first"
  local searchExt='.sh'
  local yamlDir=$HOME/lab/scripts/tmuxp
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

  case "$sFilename" in


    "sh" )
      sFilename="jumpssh"
      searchTerm="jumpssh"
      ;;

    "jump" )
      sFilename="jumpscript"
      searchTerm="jumpscript"
      ;;

    "s" )
      sFilename="settings"
      searchTerm="settings"
      ;;

    "c" )
      sFilename="confluent"
      searchTerm="confluent"
      ;;

    "y" )
      sFilename="yabai"
      searchTerm="yabai"
      ;;
    "todo" )
      sFilename="todo"
      searchTerm="todo"
      ;;
    "tokens" )
      sFilename=$(uncoverfile "tokens" -f)
      vim $sFilename 
      return
      ;;
    "cop" )
      sFilename=$(uncoverfile "cop" -f)
      vim $sFilename 
      return
      ;;
    "-" )
      echo "\n----- $scriptDir -----\n"
      ls $scriptDir
      echo "\n----- $yamlDir -----\n"
      ls $yamlDir
      return
      ;;

    * )
      ;;

  esac

  local scriptQuery=$searchTerm

  # if there is no terms 
  if [[ -z $searchTerm ]]; then

    echo "" > "/tmp/script-query"
    filesToEdit=$(rg --files $HOME/lab/scripts | fzf --multi --preview 'bat --style=numbers --color=always --line-range :500 {}' --bind 'change:execute(echo {q} > /tmp/script-query)' --bind 'ctrl-r:execute(echo "" > /tmp/script-query)')
    
    local editFiles=()
    for tempFile in $(echo "$filesToEdit"); do
      editFiles+=("$tempFile")
    done

    # if you have files edit them
    if [[ "$editFiles" ]]; then
      vim $editFiles
      return
    fi

  else

    # if there is terms try to find it 
    filesToEdit=$(find $HOME/lab/scripts -type f -iname "*$searchTerm$shExt" -o -iname "*$searchTerm$yamlExt")
    echo "Targets $filesToEdit"

    # if you have a file to edit edit
    if [[ $filesToEdit ]]; then

      vim $(echo "$filesToEdit")
      return

    fi

  fi

  becho "searchTerm |$searchTerm|"

  if [[ $searchTerm ]]; then

    scriptQuery=$(echo "$searchTerm" | tr -d '*')

  else

    scriptQuery=$(cat /tmp/script-query)

    # if query is a key word
    if [[ $scriptQuery == 'Z' ]]; then

      # ripgrep->fzf->vim [QUERY]
      local RELOAD="reload:rg --column --color=always --smart-case {q} $HOME/lab/scripts || :"
      local OPENER='if [[ $FZF_SELECT_COUNT -eq 0 ]]; then
                nvim {1} +{2}     # No selection. Open the current line in Vim.
              else
                nvim +cw -q {+f}  # Build quickfix list for the selected items.
              fi'

      fzf --disabled --ansi --multi \
          --bind "start:$RELOAD" --bind "change:$RELOAD" \
          --bind "enter:become:$OPENER" \
          --bind "ctrl-o:execute:$OPENER" \
          --bind 'alt-a:select-all,alt-d:deselect-all,ctrl-/:toggle-preview' \
          --delimiter : \
          --preview 'bat --style=full --color=always --highlight-line {2} {1}' \
          --preview-window '~4,+{2}+4/3,<80(up)' \
          --query "$*"

      return
    fi

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
function envx() {
  env | fzf
}

# cat copy via arguement
function catcp() {
  cat $1 | pbcopy
  cat $1
}

function wonderfood() {
#  $HOME/lab/scripts/python/wonderfood.py | sed 's/ /-/g'
  local foodSent=$($HOME/lab/scripts/python/wonderfood.py)
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

function o() {

  if [[ $# -gt 0 ]]; then

    while [[ $# -gt 0 ]]; do

      open $1
      shift

    done

    return

  fi

  open .

}

# search 
function s() {

  local searchString=''

  while [[ $# -gt 0 ]]; do

    searchString="${searchString}+${1}"
    shift

  done

  if [[ $searchString ]]; then
    open -na "Firefox" --args --private-window "https://duckduckgo.com/?q=$searchString"
    yfocuswin Firefox -title Private
  fi

}

# rename function.  
function frename() {

  currentName="$1"
  newName="${currentName// /_}"
  newName="${newName//\(/_}"
  newName="${newName//\)/_}"
  # newName="${newName//'/_}"
  renameCommand="mv '$currentName' $newName"
  echo "$renameCommand"
  echo -n "$renameCommand" | pbcopy

}

function ccat() {
  cat $1 | pbcopy
}

function cep() {
    cop $@ -c -x
}

function cap() {
    cop $@ -c
}

function cop() {

    #echo "cop $1"
    local copyPass=""
    local copCopy="f"
    local copExit="f"
    local copUser=""
    local copWithoutN="f"
    local fromFile="$COP_FROM_FILE/cop"
    local copHash=$(md5 -q $fromFile)
    local toFile="$COP_TO_FILE/$copHash"

    # echo "toFile $toFile"
    if [[ ! -f $toFile ]]; then

      becho "󰯈 ";
      copyPass="Expired ... "
      copWithoutN='t'
      copCopy='t'
      uncover $fromFile > $toFile

      if [[ $? -eq 0 ]]; then
        becho "success!"
        source $toFile
      else
        becho "deleting"
        rm $toFile
      fi

    else

      source $toFile

    fi

    export SSHPASS="$copyPass"
    if [[ "$copUser" ]]; then
        echo $copUser
    fi
    if [[ "$copCopy" = 't' ]]; then
        if [[ "$copWithoutN" = 't' ]]; then
          echo "$copyPass" | pbcopy
        else
          echo -n $copyPass | pbcopy
        fi
    fi

    if [[ "$copExit" = 't' ]]; then
        exit
    fi

}

function coverfile() {

  local tokenFile="$1"
  shift
  local fromTokens="$COP_FROM_FILE/$tokenFile"
  local hashTokens=$(md5 -q $fromTokens)
  local toTokens="$COP_TO_FILE/$hashTokens"

  # copy file over
  if [[ -f $toTokens ]]; then

    yes | cp $fromTokens ${fromTokens}.bak
    yes | cp $toTokens $fromTokens
    cover $fromTokens

  else

    echo "File does not exists $toTokens"

  fi

}

function uncoverfile() {

  local tokenFile="$1"
  shift
  local fromTokens="$COP_FROM_FILE/$tokenFile"
  local hashTokens=$(md5 -q $fromTokens)
  local toTokens="$COP_TO_FILE/$hashTokens"

  local modeFilename=''
  local key=''

  while [[ $# -gt 0 ]]; do

    key="$1"
    shift

    case "$key" in

      '-f') modeFilename='t' ;;
      *) ;;

    esac

  done

  # # echo "$hashToken $hashTokens"
  # if [[ ! -f $toTokens ]]; then
  #
  # fi

  # echo "to token $toTokens"
  if [[ $modeFilename ]]; then

    echo "$toTokens"
    return

  else

    becho "󰯈 ";
    copyPass="Expired ... "
    uncover $fromTokens > $toTokens

    if [[ $? -eq 0 ]]; then

      becho "success!"
      source $toTokens

    else

      becho "deleting"
      rm $toTokens

    fi

  fi
    
}

function uncoverTokens() {
  
  local filename=$(uncoverfile "tokens" -f)
  echo "$filename"

}
