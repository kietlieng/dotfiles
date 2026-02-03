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

set -gx COP_FROM_FILE ~/lab/scripts/0zero
set -gx COP_TO_FILE "/tmp"

# test if tokens is good 
function tok? 

  if test -z $SCREENSHOT_TIME_FILE

    echo "empty"

  else

    echo "good"

  end

end

function cover

  if [ "$argv[1]" ]

    openssl enc -aes-256-cbc -md sha512 -pbkdf2 -iter 1000000 -salt -in $argv[1] -out "$argv[1].enc"
    /bin/mv "$argv[1].enc" $argv[1]

  end

end

function uncover

  if [ $argv[1] ]

    openssl enc -aes-256-cbc -md sha512 -pbkdf2 -iter 1000000 -salt -in $argv[1] -d

  end

end



# Echo family!
# printing functions
function becho # broadcast echo.  Put in file and also output to screen

  # set fname (status stack-trace) $argv
  set fname $argv
  echo "$fname" >> /tmp/log-gecho
  echo "$fname"

end

function pecho # put echo into file

  # set fname (status stack-trace) "$argv"
  # echo "$fname" >> /tmp/log-gecho
  echo $argv >> /tmp/log-gecho

end

function gecho # get echo from file

  cat /tmp/log-gecho

end

function cecho # get echo from file.  Then empty

  cat /tmp/log-gecho
  echo "" > /tmp/log-gecho

end

function techo # get echo from file.  Then empty

  tail -f  /tmp/log-gecho

end

# edit git file
function egit

    set currentFolder $(pwd)
    set rootFolder $(gitrootfolder)
    cd $rootFolder
#    vim -c "/url" ".git/config"
    vim ".git/config"
    echo "$rootFolder"
    cd $currentFolder

end

function eignore

    set currentFolder $(pwd)
    set rootFolder $(gitrootfolder)
    cd $rootFolder
    vim ".gitignore"
    cd $currentFolder

end

# find docker file
function edoc
    gfile "Dockerfile"
end

# edit ci yaml file without looking
function ec
    gfile ".gitlab-ci.yml"
end

function testarg
  
  echo "all at once |$argv|"
  # echo "$argv[1]"
  # echo "$argv[2]"
  echo (count $argv)


  while test (count $argv) -gt 0
    echo $argv[1]
    set argv $argv[2..-1]
  end

end

# go up to root folder and find a file
function gfile

  set currentFolder (pwd)
  set rootFolder (gitrootfolder)
  echo "rootFolder $rootFolder"
  set searchExpression "$argv[1]"

  set filesToEdit (find $rootFolder -iname "$searchExpression" | string collect)

  pecho "find $rootFolder -iname \"$searchExpression\""
  pecho "$filesToEdit"

  set fileCount (echo "$filesToEdit" | wc -l)
  set editFiles ''
  set modeNoFiles ''

  if [ $fileCount -gt 0 ]
    set editFiles (echo "$filesToEdit" | head -n 1 | sed -r 's/\n/ /g')

    # becho "editFiles: |$editFiles| $fileCount"
    if [ $editFiles = '' ]

      set modeNoFiles 't'

    else

      # echo "vim $editFiles"
      vim $editFiles

    end

  else

    set modeNoFiles 't'

  end

  if [ $modeNoFiles ]
     becho "$searchExpression not found"
  end

end


# arg1 directory
# arg2 default value of query
# returns:
# - list of results if there are files
# - the filename of the query value in file /tmp/query-[hash] that way you can retrieve the value that you want and do something with it
function fzfpreview

  set searchDirectory $argv[1]
  set defaultQuery $argv[2]
  set hashDir $(md5 -q -s $searchDirectory)
  set queryFile "/tmp/query-$hashDir"
  echo -n "" > $queryFile

  set filesToEdit $(rg --files $searchDirectory -g "*" | fzf --multi --preview "bat --style=numbers --color=always --line-range :500 {}" --print-query --query "$defaultQuery")

  if [ (count filesToEdit) -ne 0 ]

    set editFiles $(echo "$filesToEdit" | sed -r 's/\n/ /g')
    echo "$filesToEdit"

  else

    echo "$queryFile"

  end

end

# search /tmp directory
function et

  # set tempResults (fzfpreview /tmp)
  set filesToEdit $(/bin/ls -1 /tmp/ | fzf --multi --preview 'bat --style=numbers --color=always --line-range :500 /tmp/{}' --print-query | string collect)

  for element in (echo -e "$filesToEdit")

    if [ "$element" ]
      and test -e "/tmp/$element"
      set filesToEditSanitized $filesToEditSanitized  "/tmp/$element"
    end

  end

  set filesToEditSanitized (string trim -c ' ' $filesToEditSanitized)

  echo "files $filesToEditSanitized"

  # check to see if you have elements
  if test (count $filesToEditSanitized) -gt 0
    echo "edit |$filesToEditSanitized|"
    vim $filesToEditSanitized
  end

end

function e

  set grepString ''
  set key ''
  set modeTail '1'
  set modeGrep ''
  set modeNoEdit ''
  set searchOutput /tmp/esearch.txt
  set searchResults /tmp/esearch-filter.txt
  set searchString ''
  set startLoading ''
  set targetFile ''

  while test (count $argv) -gt 0

    set key "$argv[1]"
    set argv $argv[2..-1]

    switch "$key"

      case '-e' set modeNoEdit 't'

      case '-g' set modeGrep 't'

      # check to see if number
      case 1 2 3 4 5 6 7 8 9
        # echo "key is $key"
        set modeTail "$key"

      case '*'

        set searchString "$searchString.*$key"

        if [ "$grepString" = '' ]

          set grepString "$key"

        else

          set grepString "$grepString*$key"

        end

    end

  end

  set vimToEdit ''

  # grep the results
  if [ $modeGrep ]

    echo "search | $searchString"
    set vimToEdit (eza --all --sort=modified -1 -f --only-files | grep -i $searchString | tail -n $modeTail | sed -r 's/\n/ /g')

  else

    echo -n "" > $searchOutput

    # echo "tail $grepString"
    eza --all --sort=modified --reverse -1 -f --only-files > $searchOutput

    set totalCount (cat $searchOutput | wc -l)
    set fileCount 0
    set fileFinal 0

    while read currentValue

      set targetFile $currentValue
      # echo "currentValue $currentValue searchString $searchString"
      if echo "$targetFile" | grep -iq "$searchString"
        break
      end

      set fileCount (math "$fileCount + 1")

    end < $searchOutput

    # echo "total $totalCount fileCount $fileCount"
    set fileFinal (math "$totalCount - $fileCount")
    tail -n $fileFinal $searchOutput >  $searchResults

    # echo "|$targetFile| $grepString"
    set vimToEdit (cat $searchResults | head -n $modeTail | sed -r 's/\n/ /g')

  end

  echo "edit $vimToEdit"

  if [ $modeNoEdit != 't' ]
    vim $vimToEdit
  end

end

# go into fzf for searching files and edit
function E

  set goToDirectory 'f'
  set rootDirectory ''
  set currentDirectory $PWD
  set lastOnly 'f'
  set searchString ''

  while test (count $argv) -gt 0

    set key "$argv[1]"
    set argv $argv[2..-1]

    switch "$key" 

      case '-l' 

        set lastOnly 't'

      case '-c' 

        set goToDirectory "t"

      case '-d' 

        set rootDirectory "$argv[1]"
        set argv $argv[2..-1]

      case '*'
        set searchString $searchString $key

    end

  end

  if [ $rootDirectory != '' ]
    cd "$rootDirectory"
  end

  if [ $lastOnly = 't' ]

    for isFile in $(ls -1t | awk '{print $1}' )

      echo "file $isFile"

      if [ -f $isFile ]

        vim $isFile
        break

      end

    end

  else

    set filesToEdit (find . -type f -iname "*$searchString*")
    set fileCount (echo "$filesToEdit" | wc -l)

    # test if there is any files then search for it 
    if [ $fileCount ]

       # filesToEdit=$(ls -1t modified -sold | fzf --multi --query "$searchString")
      set filesToEdit $(/bin/ls -1 . | fzf --multi --query "$searchString")
      # echo "|$searchString|$filesToEdit"
      # fzf --multi --query "$searchString"

    end

    echo "fileEdit $filesToEdit"
    if test (count $filesToEdit) -gt 0

      if [ $goToDirectory = 't' ]

        cd $(dirname $filesToEdit)

      else

        set editFiles $filesToEdit

        vim $editFiles

      end

    end
    # echo "current Dir $currentDirectory"
    cd $currentDirectory

  end

end

# same as above function except we go to the root git directory then search
function eroot

  set rootFolder $(gitrootfolder)

  e -d $rootFolder $argv

end

# function edif
#
#   set preview $("git diff $@ --color=always -- {-1})
#   # git status --porcelain | awk '{print $2}' | fzf --multi | while read fileSelected; do
#
#   git status --porcelain | awk '{print $2}' | git diff $@ --name-only | fzf -m --ansi --preview $preview | while read fileSelected;
#
#     git diff $@ --name-only | fzf -m --ansi --preview $preview
#
#   end
#
# end

# function er() {
#
#   # ripgrep->fzf->vim [QUERY]
#   set RELOAD "reload:rg --column --color=always --smart-case {q} || :"
#   set OPENER 'if [ $FZF_SELECT_COUNT -eq 0 ]
#             nvim {1} +{2}     # No selection. Open the current line in Vim.
#           else
#             nvim +cw -q {+f}  # Build quickfix list for the selected items.
#           fi'
#   fzf --disabled --ansi --multi \
#       --bind "start:$RELOAD" --bind "change:$RELOAD" \
#       --bind "enter:become:$OPENER" \
#       --bind "ctrl-o:execute:$OPENER" \
#       --bind 'alt-a:select-all,alt-d:deselect-all,ctrl-/:toggle-preview' \
#       --delimiter : \
#       --preview 'bat --style=full --color=always --highlight-line {2} {1}' \
#       --preview-window '~4,+{2}+4/3,<80(up)' \
#       --query "$*"
#
# }
#
# alias eG="eg '?'"
#
# # open all files that are modified / new / deleted to vim from git
# function eg() {
#
#   key=''
#
#   gitType="M"
#
#   while [ $# -gt 0 ]
#
#     key="$1"
#     shift
#
#     case "$key" in
#
#       '?')
#
#         gitType="M?"
#         
#
#       *)
#
#         echo default
#         
#
#     esac
#
#   done
#
#   filesToEdit=""
#
#   # modified and new
#   if [ $gitType = 'M?' ]
#
#     filesToEdit=$(git status --porcelain | awk '{ if ($1 == "M" || $1 == "??" )  print $2}')
#
#     if [ $filesToEdit != '' ]
#       vim $(git status --porcelain | awk '{ if ($1 == "M" || $1 == "??" )  print $2}')
#       echo "files to edit $filesToEdit"
#     fi
#
#   else
#
#     # only modified
#     filesToEdit=$(git status --porcelain | awk '{ if ($1 == "M") print $2}')
#
#     if [ $filesToEdit != '' ]
#       vim $(git status --porcelain | awk '{ if ($1 == "M") print $2}')
#       echo "files to edit $filesToEdit"
#     fi
#
#   fi
#
#
# }
#

function hashdir

  set hashDir $(md5 -q -s $(pwd))
  echo "$hashDir"

end

# # copy file path
# function fcp() {
#
#     cp $(fzf)
#
# }

# find subdomain on string
function subd

    set subdomain $(echo "$argv[1]" | awk -F/ '{sub(/^www\.?/,"",$3); print $3}')
    echo -n $subdomain | pbcopy
    echo $subdomain

end

# copy current path
function pc

  set relativePath "$PWD"

  # if it's part of the home directory.  Remove home directory mention (sensitive data)
  # if [ "$PWD" = *$HOME* ]
  if string match -iqr "$HOME" -- $PWD

    set relativePath (string replace "$HOME" "" $PWD )
    set relativePath "~$relativePath"

  end

  echo "$relativePath/"
  echo -n "$relativePath/" | pbcopy

end

# grep listing
function grl
  gr -l $argv
end


# ?? not coded in gr function
function gri

    gr -i $argv

end

function grcdl
    gr -ci -l $argv
end

# duplicate of ec
function grcd
    gr -ci $argv
end

# match all from file a to file b in order
# Meaning: file a: go line by line.  Match to file b.  Output
function grab

  set fileA "$argv[1]"
  set fileB "$argv[2]"
  set results ""
  set currentResults ""

  while read line

    # echo "line: $line"
    set currentResults $(grep -i "$line" $fileB)
    if [ $currentResults ]
      echo "$currentResults"
      set results "$results\n$currentResults"
    else
      # echo "!! Missing $line"
      set results "$results\n$line: miss"
    end

  end <$fileA
  # echo "blah"

  echo "$results" | pbcopy
  echo "$results" > /tmp/ab.txt

end


# from the target ($1), replace ($2) with value ($3)
function srabc

  set searchTarget "$argv[1]"
  set searchFor "$argv[2]"
  set replaceFor "$argv[3]"

  set searchTarget $(echo "$searchTarget" | sed "s/$searchFor/$replaceFor/g")
  echo "$searchTarget"

end


# not working yet
function strjoin

  echo "$argv[1]" | sed "s/$argv[2]/$argv[3]/g"

end

# from the target ($argv1), strip out values from both ends ($2+)
function stripends

  set searchTarget "$argv[1]"
  set argv $argv[2..-1]

  while test (count $argv) -gt 0

    set searchTarget $(echo "$searchTarget" | sed "s/$argv[1]//g")
    set argv $argv[2..-1]

  end

  echo "$searchTarget"

end


# grep recursive
# use silver searcher instead

function gr

  set searchExpression '.*'
  set shouldList 'false'
  set searchCICD 'f'
  set targetFile "*"
  set modeFound ''
  set modeAfter 0
  set modeBefore 0

  while test (count $argv) -gt 0

    set key $argv[1]
    set argv $argv[2..-1]

    # echo "key $key"

    switch $key

      case '-l'
        set shouldList 'true'

      case '-ci'
        set searchCICD 't'

      case '*' 

        # if this is a number
        if string match -qr '^[0-9]+$' $key

          if [ "$modeFound" = '' ]
            set modeBefore "$key"
          else
            set modeFound 't'
            set modeAfter "$key"
          end

        else

          # echo "testing expression $key"
          set searchExpression "$searchExpression$key.*"

        end

    end

  end

  # echo "searchExpression $searchExpression"
  if [ $searchExpression = '.*' ]
    echo "No expression"
  else

    set searchExpression (string trim -c '.*' $searchExpression)
    
    #echo "search term $searchExpression"
    if [ $searchCICD = 't' ]
      if [ $shouldList = "true" ]
        find . -iname ".gitlab-ci.yml" -exec grep -il -A $modeAfter -B $modeBefore "$searchExpression" {} \;
      else
        find . -iname ".gitlab-ci.yml" -exec grep -i  -A $modeAfter -B $modeBefore "$searchExpression" {} \;
      end

    else

      #echo "target file $targetFile"
      if [ $shouldList = "true" ]

        # echo "test1"

        # if the function returns false
        if [ -t 0 ]
          # echo "function is good 1"
          rg -il -A $modeAfter -B $modeBefore "$searchExpression" -g "*" -g "!.git"
        else
          echo "last function errored out"
          rg -il -A $modeAfter -B $modeBefore  "$searchExpression" $targetFile -g "*" -g "!.git"
        end

      else

        if [ -t 0 ]
          # echo "function is good 2"
          # echo "search expression '$searchExpression'"
          echo "rg -i -A $modeAfter -B $modeBefore \"$searchExpression\" -g \"*\" -g \"!.git\""
          rg -i -A $modeAfter -B $modeBefore "$searchExpression" -g "*" -g "!.git"
        else
          echo "last function errored out"
          rg -i -A $modeAfter -B $modeBefore "$searchExpression" $targetFile -g "*" -g "!.git"
        end
      end

    end
  end

end

# find file
function f

  set searchexpression "*"
  set modeOpen ''
  set modeRemove ''


  while test (count $argv) -gt 0

    set key "$argv[1]"
    set argv $argv[2..-1]

    switch $key

      case '-o' 
        set modeOpen 't'
      case '-rm' 
        set modeRemove 't'
      case '*'
        set searchexpression "$searchexpression$key*"

    end

  end


  if test "$searchExpression" != '*'

    if test $modeRemove = 't'

      echo "find . -iname \"$searchexpression\" -exec rm {} \\;"
      find . -iname $searchexpression -exec rm {} \;

    else if test $modeOpen = 't'

      echo "find . -iname \"$searchexpression\" -exec open {} \\;"
      find . -iname $searchexpression -exec open {} \;

    else

      echo "find . -iname \"$searchexpression\""
      find . -iname $searchexpression

    end

  else

    echo "expression?"

  end

end


# find and grep list
function fgrl
    fgr $argv -l
end

# find and grep
function fgr

  set fileExpression "$argv[1]"
  set searchExpression "$argv[2]"
  set listOption='f'
  set argv $argv[2..-1]
  set argv $argv[2..-1]

  while test (count $argv) -gt 0

    set key "$argv[1]"
    set argv $argv[2..-1]

    switch $key
      case '-l'
        set listOption 't'
    end
  end

  if [ $listOption = 't' ]
      find . -iname "*$fileExpression*" -exec grep -il "$searchExpression" {} \;
  else
      find . -iname "*$fileExpression*" -exec grep -i "$searchExpression" {} \;
  end

end

# will script out extension
function nameonly

  set results $(strr -c -s " " -r "_" $argv)
  set results $(strr -c -s ".\/" "$results")
  set results $(strr -c -s ".epub" "$results")
  set results $(strr -c -s ".doc" "$results")
  set results $(strr -c -s ".txt" "$results")
  set results $(strr -c -s ".azw3" "$results")
  set results $(strr -c -s ".mobi" "$results")
  set results $(strr -c -s ".pdf" "$results")

end

# no idea  what this does
function strr

  set searchExpression ""
  set copy 'false'
  set searchTerm " "
  set replaceTerm ""

  while test (count $argv) -gt 0

    set key "$argv[1]"
    set argv $argv[2..-1]

    switch $key

      case '-s'
        set searchTerm "$argv[1]"
        set argv $argv[2..-1]

      case '-r'
        set replaceTerm "$argv[1]"
        set argv $argv[2..-1]

      case '-c'

        set copy 'true'
      case '*'

        set shortened $(echo $key | sed "s/$searchTerm/$replaceTerm/g")
        set searchExpression "$searchExpression$replaceTerm$shortened"
    end
  end

  # set searchExpression ${searchExpression#$replaceTerm}
  # set searchExpression ${searchExpression%$replaceTerm}

  if [ "$copy" = "true" ]
      echo -n "$searchExpression" | pbcopy
  end
  echo "$searchExpression"

end

#source ~/lab/scrap/bash/test.fish

# jot down on napkin
# jot will create file in /tmp

function nap
  
  set fileScratch "kin"
  set jotQuery "kin-"

  while test (count $argv) -gt 0

    set key $argv[1]
    set argv $argv[2..-1]

    switch $key

      case '-query'
        set jotQuery "$argv[1]"
        set argv $argv[2..-1]

      case '*'
        set fileScratch "$fileScratch-$key"
    end

  end

  # echo "fileScratch |$fileScratch|"

  # no filename
  if [ $fileScratch != "kin" ]

    vim "/tmp/$fileScratch"

  else

    echo "" > /tmp/fzf-query
    set hashDir (md5 -q -s $(pwd))
    set queryFile "/tmp/query-$hashDir"

    # set filesToEdit (/bin/ls -1 /tmp/ | fzf --multi --preview 'bat --style=numbers --color=always --line-range :500 /tmp/{}' --query "$jotQuery" --print-query | string collect)
    # fzf -m --ansi --color fg:-1,bg:-1,hl:46,fg+:40,bg+:233,hl+:46 --color prompt:166,border:46 --height 75%  --border=sharp --prompt="➤  " --pointer="➤ " --marker="➤ " --bind "change:execute(echo {q} > $queryFile)" --query "$defaultQuery"
    set filesToEdit (/bin/ls -1 /tmp/ | fzf --multi --preview 'bat --style=numbers --color=always --line-range :500 /tmp/{}' --query "$jotQuery" --bind "enter:execute(echo {q} > $queryFile)+accept" | string collect)

    # set query (fzf --print-query)

    # echo "files to edit |$filesToEdit|"
    set elementFound ''

    for element in (echo -e "$filesToEdit")

      # echo "element |$element|"

      # test if not empty 
      if test -n "$element" 
        and [ "$element" != 'kin-' ]
        set filesToEditSanitized $filesToEditSanitized  "/tmp/$element"
        set elementFound 't'
      end

    end

    # if empty and not set
    if [ -z $elementFound ]
      # consider the query from query file
      set queryValue (cat $queryFile)
      if [ "$queryValue" != 'kin-' ]
        # echo "setting queryValue |/tmp/$queryValue| |$filesToEditSanitized|"
        set filesToEditSanitized $filesToEditSanitized  "/tmp/$queryValue"
      end
    end


    set filesToEditSanitized (string trim -c ' ' $filesToEditSanitized)

    set fCount (count $filesToEditSanitized)

    # echo "count $fCount"
    if [ "$filesToEditSanitized" != "" ]
      if [ "$filesToEditSanitized" != '/tmp/' ] 
        vim $filesToEditSanitized
        echo "edit $filesToEditSanitized"
      else
        echo "skipping $filesToEditSanitized"
      end
    end
  end

end


function etail

  set currentDirectory $(pwd)
  set tailFiles $(fzfpreview $currentDirectory)

  set tailList ()

  for element in $(echo $tailFiles | tr '\n' ' ')
    set tailList $tailList "$element"
  end

  if test (count $tailList) -gt 0

    tail -f $tailList

  end

end

# grep processs command and kill
function p

  set hashDir (md5 -q -s (pwd))
  set queryFile "/tmp/query-$hashDir"

  set defaultQuery ''

  if [ -f $queryFile ]
    set defaultQueryi (cat $queryFile)
  end

  if test (count $argv) -gt 0

    set defaultQuery $argv[1]
    set argv $argv[2..-1]

  end

  set pid (ps -ef | sed 1d | grep -v "$hashDir" | fzf -m --ansi --color fg:-1,bg:-1,hl:46,fg+:40,bg+:233,hl+:46 --color prompt:166,border:46 --height 75%  --border=sharp --prompt="➤  " --pointer="➤ " --marker="➤ " --bind "enter:execute(echo {q} > $queryFile)+accept" --query "$defaultQuery" | awk '{print $2}')

  # check to see if set at all
  if [ -n $pid ]
    echo "has pid $pid"
    # iterate through loop for multiple pids
    for pIndex in $(echo $pid)
#      sudo kill $pIndex
      kill $pIndex
      echo "x $pIndex"
    end
#      kill -${1:-9} $pid
  end
#    ps aux | grep -i "$@"
end

# this is useless
function bindlogs
  echo "rndc querylog" | pbcopy
end

# rm all files unneeded
function deletemisc

  echo "delete .DS_Store, __pycache__ directories / files"
  deletedsstore
  deletepycache
  deletemacfiles

end

# remove dsstore files
function deletedsstore

  find . -iname ".DS_STORE" -type f -delete

end

# delete cache content
function deletepycache

  find . -iname "__pycache__" -type d -exec rm -rf "{}" \;

end

function deletemacfiles

  find . -iname "__MACOSX" -type f -delete

end

# script search in directory
# function escript() {
#
#   set currentPWD $(pwd)
#
#   cd "$HOME/lab/scripts"
#   # query via filenames
# #  filesToEdit=$(find $HOME/lab/scripts -iname "*.fish" | fzf --multi --preview "bat --style=numbers --color=always --line-range :500 {}")
#   set filesToEdit $(fzf --multi --ansi --disabled --query "$INITIAL_QUERY" \
#     --bind "start:reload:$RG_PREFIX {q}" \
#     --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
#     --delimiter : \
#     --preview 'bat --color=always {1} --highlight-line {2}')
# #    --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
# #    --bind 'enter:become(vim {1} +{2})')
# #  echo ">>fileEdit: $filesToEdit"
#   filesToEdit=$(echo "$filesToEdit" | awk -F: '{print $1}')
#   echo ">>fileEdit: $filesToEdit"
#   filesToEdit=($(echo "$filesToEdit" | sed -r 's/\n/ /g'))
#   echo ">>fileEdit: $filesToEdit"
#   vim $filesToEdit
#   cd $currentPWD
#
# #    command! -bang -nargs=* Rg call fzf#vim#grep("rg --column -i --context 4 --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>) . " " . @r, 1, { "options": '--delimiter : --nth 4..' }, <bang>0) "" new bang command that searches the current file directory or register r.  This allows for us to change the register value to whatever we want
#
# }
#
# # mark delete.  Move to tmp directory
# function mdelete() {
#
#     currentDate=$(date +"%y%m%d%H%M")
#
#     while [ $# -gt 0 ]
#     do
#
#         echo "move \"$1\" to \"/tmp/$1.$currentDate\""
#         mv -f "$1" "/tmp/$1.$currentDate"
#         shift
#
#     done
#
# }
#
# # mark copy to temp.  Move with epoch
# function mtmp() {
#
#     currentDate=$(date +"%y%m%d%H%M")
#
#     while [ $# -gt 0 ]
#     do
#
#         echo "copy \"$1\" to \"/tmp/$1.$currentDate\""
#         cp -rf "$1" "/tmp/$1.$currentDate"
#         shift
#
#     done
#
# }
#
#
# # mark move.  Move with epoch
# function mmove() {
#
#     currentDate=$(date +"%y%m%d%H%M")
#
#     while [ $# -gt 0 ]
#     do
#
#         echo "move \"$1\" to \"$1.$currentDate\""
#         mv -f "$1" "$1.$currentDate"
#         shift
#
#     done
#
# }
#
# # mark backup.  Copy directory to epoch directory
# function mbackup() {
#
#   currentDate=$(date +"%y%m%d%H%M")
#   re='^[0-9]+$'
#   while [ $# -gt 0 ]
#   do
#
#     orgFilename="$1"
#     filename=$(basename -- "$orgFilename")
#     filename="${filename%.*}"
#     extension="${filename##*.}"
#     echo "$orgFilename $filename"
#     extension="${orgFilename##*.}"
#     newFilename="$filename.$currentDate"
#
#     if [ $filename != "$orgFilename" ]
#
#       # check to see if extension is just a number
#       # if not a number, assume it's a date and discard the old extension
#       # otherwise add current date to extension
#       if ! [ $extension =~ $re ]
#
#         newFilename="$filename.$currentDate.$extension"
#
#       fi
#
#     fi
#
#     echo "cp -rf \"$orgFilename\" \"$newFilename\""
#     cp -rf "$orgFilename" "$newFilename"
#     shift
#
#   done
#
# }
#
# #function marktemp() {
# #  mv -f $1 /tmp/.
# #}
#
# # script configurations
# function cyaml() {
#   c -y "$@"
# }

function c

  set scriptDir $HOME/lab/scripts
  set targetDir "$scriptDir/1first"
  set searchExt '.fish'
  set yamlDir $HOME/lab/scripts/tmuxp
  set defaultSearch ''
  set searchTerm "$defaultSearch"
  set sFilename "$defaultSearch"
  set fileExt '.fish'
  set yamlExt '.yaml'
  set filesToEdit ''
  set modeSearchTerm ''

  while test (count $argv) -gt 0

    set key "$argv[1]"
    set argv $argv[2..-1]

    switch $key

      case '-y'
        # yaml file.  Assume they want the directory ~/lab/scripts/tmuxp
        set searchExt '.yaml'
        set targetDir $yamlDir

      case '*'

        if [ "$searchTerm" = "$defaultSearch" ]
          set searchTerm "$key*"
        else
          set searchTerm "$searchTerm$key*"
          set modeSearchTerm 't'
        end

    end

  end


  set sFilename $(echo $searchTerm | sed "s/*//g")
  #echo "filename $sFilename"

  switch "$sFilename"


    case 'sh'
      set sFilename "jumpssh"
      set searchTerm "jumpssh"

    case 'jump'

      set sFilename "jumpscript"
      set searchTerm "jumpscript"

    case 's'
      set sFilename "settings"
      set searchTerm "settings"

    case 'c'
      set sFilename "confluent"
      set searchTerm "confluent"

    case 'y'
      set sFilename "yabai"
      set searchTerm "yabai"

    case 'todo'
      set sFilename "todo"
      set searchTerm "todo"

    case 'tokens' 'token'

      set sFilename $(uncoverfile "tokens" -f)
      vim $sFilename
      return

    case 'cop'

      set sFilename $(uncoverfile "cop" -f)
      vim $sFilename
      return

    case '-'

      echo "\n----- $scriptDir -----\n"
      ls $scriptDir
      echo "\n----- $yamlDir -----\n"
      ls $yamlDir
      return

  end

  set scriptQuery $searchTerm

  # if there is no terms
  if [ $searchTerm = '' ]

    echo "" > "/tmp/script-query"
    # set filesToEdit $(rg --files $HOME/lab/scripts | fzf --multi --preview 'bat --style=numbers --color=always --line-range :500 {}' --bind 'change:execute(echo {q} > /tmp/script-query)' --bind 'ctrl-r:execute(echo "" > /tmp/script-query)')
    set filesToEdit $(rg --files $HOME/lab/scripts | fzf --multi --preview 'bat --style=numbers --color=always --line-range :500 {}' --bind 'change:execute(echo {q} > /tmp/script-query)')

    set editFiles ()
    for tempFile in $(echo "$filesToEdit")
      set editFiles $editFiles "$tempFile"
    end

    # if you have files edit them
    if [ "$editFiles" ]
      vim $editFiles
      return
    end

  else

    # echo "xsearchterm $searchTerm$fileExt"
    # if there is terms try to find it
    set filesToEdit $(find $HOME/lab/scripts -type f -iname "*$searchTerm$fileExt" -o -iname "*$searchTerm$yamlExt")

    # if you have a file to edit edit
    if test (count $filesToEdit) -gt 0

      vim $filesToEdit
      return

    end

  end

  becho "searchTerm |$searchTerm|"

  if [ $searchTerm ]

    set scriptQuery $(echo "$searchTerm" | tr -d '*')

  else

    set scriptQuery $(cat /tmp/script-query)

    # if query is a key word
    if [ $scriptQuery = 'Z' ]

      # ripgrep->fzf->vim [QUERY]
      set RELOAD "reload:rg --column --color=always --smart-case {q} $HOME/lab/scripts || :"
      set OPENER 'if test (count $FZF_SELECT_COUNT) -eq 0;
                nvim {1} +{2}     # No selection. Open the current line in Vim.
              else
                nvim +cw -q {+f}  # Build quickfix list for the selected items.
              end'

      fzf --disabled --ansi --multi \
          --bind "start:$RELOAD" --bind "change:$RELOAD" \
          --bind "enter:become:$OPENER" \
          --bind "ctrl-o:execute:$OPENER" \
          --bind 'alt-a:select-all,alt-d:deselect-all,ctrl-/:toggle-preview' \
          --delimiter : \
          --preview 'bat --style=full --color=always --highlight-line {2} {1}' \
          --preview-window '~4,+{2}+4/3,<80(up)' \
          --query "$argv"

      return
    end

  end

  echo "searchTerm |$searchTerm|"

  set sFilename "$scriptQuery"
  # if this file does not exists go digging for it
  if [ $scriptQuery ]
    #echo "$scriptDir/$sFilename.fish"

    read -P "Create $targetDir/$sFilename$searchExt?" ANSWER
    echo "answer is $ANSWER"

    switch $ANSWER
      case 'y' 'Y'
        echo "|$ANSWER| yes"
        vim "$targetDir/$sFilename$searchExt"
      case 'n' 'N'
        echo "|$ANSWER| no"
      case '*'
        echo "Yes or No answers please"
    end

  end

end

function needleHay 

  set srSearch "$argv[1]"
  set srReplace "$argv[2]"
  set srTarget "$argv[3]"

  sed -e "s/$srSearch/$srReplace/g" $srTarget > "$srTarget.bak"
  mv "$srTarget.bak" "$srTarget"

end


function hscrubaws

  hscrub 'AWS_ACCESS_KEY_ID'
  hscrub 'AWS_SECRET_ACCESS_KEY'
  hscrub 'AWS_SESSION_TOKEN'

end

# when I need it to work with other programs like mtr we mask it instead of term being xterm-kitty
# Don't need anymore cause doing it in ssh config
function termmask

  set -gx TERM xterm-256color

end

# grep environment variable
function envx

  env | fzf

end

# cat copy via arguement
function catcp

  cat $argv[1] | pbcopy
  cat $argv[1]

end

function wonderfood

  # $HOME/lab/scripts/python/wonderfood.py | sed 's/ /-/g'
  set foodSent $($HOME/lab/scripts/python/wonderfood.py)
  echo "$foodSent"

end

# requires wonderword
function iama

  set wonderAdjective $(wonderwords -w -p adjective)
  set wonderNoun $(wonderwords -w -p noun)
  set wonderSituation $(wonderwords -w -p noun)
  set wonderVerb $(wonderwords -w -p verb)

  echo -n "I am your $wonderVerb $wonderAdjective $wonderNoun of a $wonderSituation$argv[1]"

end

# requires wonderword
function wondertitle

  set wonderwordadjective $(wonderwords -w -p adjective)
  set wonderwordnoun $(wonderwords -w -p noun)

  set -gx RANDOM_TITLE1 "$wonderwordadjective-$wonderwordnoun"

  if [ $argv ]
    echo $RANDOM_TITLE1
  end

end

function o

  if [ "$argv" ]

    while [ "$argv" ]

      open $argv[1]
      set argv $argv[2..-1]

    end

    return

  end

  open .

end

# search
function s

  set searchString ''
  set optionLink ''

  while test (count $argv) -gt 0

    set key $argv[1]
    set argv $argv[2..-1]

    switch $key 

      case '-l' 
        set optionLink $argv[1]
        set argv $argv[2..-1]

      case '*'
        set searchString "$searchString+$key"

    end

  end

  if [ "$optionLink" ]

    # echo "optionLink |$optionLink|"
    open -na "Firefox" --args --private-window "$optionLink"
    return

  end

  if [ "$searchString" ]
    open -na "Firefox" --args --private-window "https://duckduckgo.com/?q=$searchString"
    yfocuswin Firefox -title Private
  end

end

# rename function.
function frename

  set currentName "$argv[1]"
  set newName string replace --end " " "" $currentName
  set newName string replace --end "\(" "_" $newName
  set newName string replace --end "\)" "_" $newName
  set renameCommand "mv '$currentName' $newName"
  echo "$renameCommand"
  echo -n "$renameCommand" | pbcopy

end

function ccat
  cat $argv[1] | pbcopy
end

function cep
  cop $argv -c -x
end

function cap
  cop $argv -c
end

function cop

  #echo "cop $argv[1]"
  set copyPass ""
  set copCopy "f"
  set copExit "f"
  set copUser ""
  set copWithoutN "f"
  set fromFile "$COP_FROM_FILE/cop"
  set copHash $(md5 -q $fromFile)
  set toFile "$COP_TO_FILE/$copHash"
  set uArgv $argv

  # echo "toFile $toFile from file $fromFile"
  if not [ -f $toFile ]

    becho "󰯈 "
    set copyPass "Expired ... "
    set copWithoutN 't'
    set copCopy 't'
    uncover $fromFile > $toFile
    # uncover $fromFile

    if test $status -eq 0
      becho "success!"
      source $toFile
    else
      becho "deleting"
      rm $toFile
    end

  else

    source $toFile

  end

  set -gx SSHPASS "$copyPass"

  if [ "$copUser" ]
    echo $copUser
  end

  # echo "copCopy $copCopy copWithoutN $copWithoutN pass $copyPass"
  if [ "$copCopy" = 't' ]

    if [ "$copWithoutN" = 't' ]

      echo "$copyPass" | pbcopy

    else

      echo -n $copyPass | pbcopy

    end

  end

  if [ "$copExit" = 't' ]

    exit

  end

end


function coverfile

  set tokenFile "$argv[1]"
  set argv $argv[2..-1]
  set fromTokens "$COP_FROM_FILE/$tokenFile"
  set hashTokens $(md5 -q $fromTokens)
  set toTokens "$COP_TO_FILE/$hashTokens"

  # copy file over
  if [ -f $toTokens ]

    yes | cp $fromTokens "$fromTokens.bak"
    yes | cp $toTokens $fromTokens
    cover $fromTokens

  else

    echo "File does not exists $toTokens"

  end

end

function uncoverfile

  set tokenFile "$argv[1]"
  set argv $argv[2..-1]

  set fromTokens "$COP_FROM_FILE/$tokenFile"
  set hashTokens (md5 -q $fromTokens)
  set toTokens "$COP_TO_FILE/$hashTokens"

  set modeFilename ''
  set key ''

  while [ $argv ]

    set key "$argv[1]"
    set argv $argv[2..-1]

    switch $key 

      case '-f' 
        set modeFilename 't'

    end

  end

  # # echo "$hashToken $hashTokens"
  # if [ ! -f $toTokens ]
  #
  # end

  # echo "to token $toTokens"
  if [ "$modeFilename" ]

    echo "$toTokens"
    return

  else

    # if exists then we are done
    if [ -f $toTokens ]
      return
    end

    becho "󰯈 "
    set copyPass "Expired ... "
    uncover $fromTokens > $toTokens

    if test $status -eq 0

      becho "success!"
      source $toTokens

    else

      becho "deleting"
      rm $toTokens

    end

  end

end

function recover

  if test (count $argv) -gt 0
    coverfile $argv[1]
    uncoverfile $argv[1]
  else
    echo "no args were provided"
  end

end

# frequent edits
function vx

  set fileSelection (cat $EDIT_FILE | fzf --multi --print-query --query "$defaultQuery")
  echo $fileSelection

  for currentSelection in $fileSelection
    echo "|$currentSelection|"
    set currentSelection (string replace -a '~' "$HOME" $currentSelection)

    for selection in (string split ' ' $currentSelection) 
      echo "break $selection"
      if test -e $selection 
        echo "select is valid $selection"
        set filesToEdit $filesToEdit $selection
      end
    end
  end

  echo "files To Edit $filesToEdit"
  if test -n "$filesToEdit"
    vim $filesToEdit
  end
  
end
