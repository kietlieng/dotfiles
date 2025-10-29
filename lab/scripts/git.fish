alias gD='git -c diff.external=difft diff --staged'
alias gHash="git rev-parse HEAD && git rev-parse HEAD | pbcopy"
alias gP='gpush'
alias gbr='g -branch'
# alias gco='git checkout '
alias gd='git -c diff.external=difft diff'
alias gdstaged='git -c diff.external=difft diff --staged'
alias gfetch="git fetch --all"
alias gfiles="git log --name-only --oneline"
alias ghash="git rev-parse HEAD && git rev-parse HEAD | cut -c -8 | pbcopy"
alias gl="git -c diff.external=difft log -p --ext-diff"
alias gL="git diff --cached"
alias glines="git log -p --unified=0"
alias glogfiles="git log --name-only"
alias gm="git merge"
alias gprune="g -prune"
alias gpull="git pull --all"
alias gR='groot' # taken over by grep
alias gabort='git rebase --abort'
alias grebasedelete='rm -fr ".git/rebase-merge"'
alias grebaseskip='git rebase --skip'
alias gslist="git stash list"
alias gspop="git stash pop"
alias gspush="git stash push"
alias gsstack="git log --name-status --oneline"
# alias gtrack="git update-index --no-assume-unchanged "
alias guadd='git restore --staged'
alias guntrack="git update-index --assume-unchanged "
alias guntracklist="git ls-files -v | grep \"^[[:lower:]]\""

set -gx BAT_PREVIEW1 "git diff "
set -gx BAT_PREVIEW2 "--color=always -- {-1}"

function gco

  if test (count $argv) -gt 0

    git checkout $argv

  else

    git status --porcelain | awk '{print $2}' | git diff $argv --name-only | fzf --multi --ansi --preview "$BAT_PREVIEW1 $argv $BAT_PREVIEW2" | while read fileSelected;

      git checkout $fileSelected

    end

  end

end

function ga

  # if we have
  if test (count $argv) -gt 0

    # -f is for force add
    git add -f $argv

  else

    git status --porcelain | awk '{print $2}' | git diff $argv --name-only | fzf --multi --ansi --preview "$BAT_PREVIEW1 $argv $BAT_PREVIEW2" | while read fileSelected; do

      git add -f $fileSelected

    end

  end


end


# commit message inline or via editor
function gacom

  git add $argv[1]
  set argv $argv[2..-1]
  gcom $argv

end

function gorigin

  set branchName "master"

  if test (count $argv) -gt 0
    set branchName "$argv[1]"
  end

  git branch --set-upstream-to=origin/$branchName $branchName

end

function gmerge
  git merge --no-ff
end

function gcom

  if test (count $argv) -gt 0
    git commit -m "$argv"
  else
    git commit
  end

end

function gwarn

  git config pull.rebase false  # merge (the default strategy)
  git config pull.rebase true   # rebase
  git config pull.ff only       # fast-forward only

end

# hard reset
function greset

  git config pull.rebase false  # merge (the default strategy)
  git config pull.rebase true   # rebase
  git config pull.ff only       # fast-forward only

  git reset --hard
  #git pull
  if test (count $argv) -gt 0

    while test (count $argv) -gt 0

      git rebose $argv[1]
      set argv $argv[2..-1]

    end

  else

    git rebase

  end

end

function gcommits

  git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit $argv

end

# dump everything that's not commited
function gunstage
  git restore --staged *
end

# undo last commit
function guncommit
  git reset --hard HEAD~1
end

# sleeps after a certain amount of git count
function gwait

  set gitCount (ps aux | grep -i git | wc -l)
  set maxConnections 50
  set sleepTime 2

  # 100 seems to be the limit
  while test $gitCount -gt $maxConnections

    set gitCount $(ps aux | grep -i git | wc -l)
    sleep $sleepTime

  end
end

# go to root folder
function groot

  set rootFolder $(gitrootfolder)
  cd $rootFolder
  becho "󰌍 $rootFolder"

end

# git pull all repos from current
function gp

  # need absolute path
  #which git
  set currentDirectory $(pwd)
  cd $currentDirectory
  set rootFolder (gitrootfolder)

  #echo "folder $rootFolder"
  # this means you deep within a repo
  if [ "$currentDirectory" != "$rootFolder" ]
    # echo "$currentDirectory != $rootFolder"
    cd "$rootFolder"
    set currentBranch $(git rev-parse --abbrev-ref HEAD)
    set originInfo $(ggetorg $rootFolder $currentBranch)
    # echo "origin is 1 $currentBranch $originInfo"

    # if [ "$originInfo" != 'master' ]
    #   #currentFolder=$(pwd)
    #   #echo "currentFolder $currentFolder: $currentBranch"
    #   #echo "git pull rebase --rebase origin $originInfo"
    #   #git pull --rebase origin "$originInfo" &
    #   # rebosed on origin
    #   echo "git pull --rebase origin \"$originInfo\""
    #
    #   # git rebase
    #   git fetch -p
    #
    # else
    #   #git pull &
    #   #git pull --rebase origin "$originInfo" &
    #   # git rebase
    #   echo "git else"
    #   git fetch -p
    #
    # end

    git fetch -p
    git rebase
    gwait
    return

  end

  cd $currentDirectory

  for gitFolder in $(find . -name ".git" -type d -exec realpath {} \;)

    #echo "update $gitFolder"
    cd $gitFolder/..
    # do not set to master
    set gitFolderDirectory $(pwd)
    set currentBranch $(git rev-parse --abbrev-ref HEAD)
    set originInfo $(ggetorg $gitFolderDirectory $currentBranch)
    #echo "origin is 2 $originInfo from branch $currentBranch"
    #pwd
    echo "⇣ $gitFolderDirectory"
    # git rebase

   # if [ "$originInfo" != 'master' ] 
   #   #currentFolder=$(pwd)
   #   # echo "rebase to $originInfo"
   #   #git pull --rebase origin "$originInfo" &
   #   git fetch -p
   #   git rebase
   #
   # else
   #   # echo "pull from master"
   #   #git pull &
   #   #git pull --rebase origin "$originInfo" &
   #   git fetch -p 
   #   git rebase
   #
   # end

    #gwarn
    # sleep if it's over a certain amount
    git fetch -p 
    git rebase
    gwait
  end

  cd $currentDirectory

end


function gexp

  # https://twitter.com/tomnomnom/status/1133345832688857095?lang=en
  {
    # grep first
    find .git/objects/pack/ -name "*.idx" |
      while read i;
        git show-index < "$i" | awk '{print $2}';
      end

      # grep second
      find .git/objects/ -type f | grep -v '/pack/' | awk -F'/' '{print $(NF-1)$NF}';
    } | while read o; do
      git cat-file -p $o;
    end | grep -E "$1"

end

# return end of url path for branch naming.
# -f do not trim.  But return the full path. Useful for remote branchs or branch names with / in the name
function useBasename

  set baseValue ''
  set key ''
  set trimPaths ''

  while test (count $argv) -gt 0

    set key "$argv[1]"
    set argv $argv[2..-1]

    switch $key

      case '-t'; set trimPaths '-t'
      case '*'

        if [ "$trimPaths" ]

          # check to see if there is a slash or it's a url then get base
          if string match -iq "https://*" $key or string match -iq "/*" $key

            set baseValue $(basename $key)
          else
            set baseValue $key
          end

        else
          set baseValue $key
        end

    end

  end

  echo "$baseValue"

end


# git stash then switch branch
function gstashit
  git stash push
  sleep 2
  g $argv
  git stash pop
end

# you want to use the last branch name
function gblast

  set lastBranch $(cat ~/.gitBranchName)
  g "$lastBranch"

end


# g command is short hand for a number of things
# list branchs and tracking branch
# find the parent repo folder if you're nested within the repository folder
# check out branch (if exists) or create new branch (if not exists) based off master
# -f don't trim path for branch names
# -d delete local branch
# -D delete remote branch
# -dd delete local and remote branch
# -fdd use the full value of the branch name for delete on local and remote
# -prune remove all local merged branches

function g

  # quit if not a repo
  if [ $(isRepo) = "f" ]
    echo "Not a repo"
    return
  end

  set currentDirectory $(pwd)
  set branchFilename ~/.gitBranchName
  set currentBranch $(git rev-parse --abbrev-ref HEAD)
  set descOfTicket ""
  set otherSwitches "f"
  set trackingBranch (glbranchdefault)
  set trimPaths '-t'
  set modeSaveBranchname ''
  set key ''

  while test (count $argv) -gt 0

    set key $argv[1]
    set argv $argv[2..-1]

    # echo "key is |$descOfTicket| |$key|"

    switch $key


      case '-t' 
        set trimPaths ''

      case '-branchdefault'

#        echo "refresh"
        gllocalbranchdefault "-unset"
        return

      case '-branch' # last branch

        set descOfTicket $(cat $branchFilename)

      case '-prune'

        # delete all merged local branchs
        set mergedBranches $(git branch --merged origin/$trackingBranch | grep -iv "master\|develop\|$currentBranch\|$trackingBranch")
        if [ "$mergedBranches" ]
          echo $mergedBranches | xargs git branch -d
        else
          echo "no branches to prune"
        end

        # clean branch caches
        git fetch -p
        set otherSwitches "t"

      case '-off'

        set trackingBranch "$argv[1]"
        set argv $argv[2..-1]

      case '-fdd' # delete both remote and local

        set trimPaths '-t'
        set branchName $(useBasename $trimPaths $argv[1])
        # local branch
        git branch -D "$branchName"
        # remote branch
        git push origin :$branchName
        set otherSwitches "t"
        set argv $argv[2..-1]

      case '-dd' # delete both remote and local

        set branchName $(useBasename $trimPaths $argv[1])
        # local branch
        git branch -D "$branchName"
        # remote branch
        git push origin :$branchName
        set otherSwitches "t"
        set argv $argv[2..-1]


      case '-D' # delete remote

        set branchName $(useBasename $trimPaths $argv[1])
        git push origin :$branchName
        set otherSwitches "t"
        set argv $argv[2..-1]


      case '-d' # delete local

        set branchName $(useBasename $trimPaths $argv[1])
        git branch -D "$branchName"
        set otherSwitches "t"
        set argv $argv[2..-1]

      case '-save'; set modeSaveBranchname 't'

      case '*'

        set desc (useBasename $trimPaths $key)
        # echo "desc is |$descOfTicket| |$desc|"

        if test (string length "$descOfTicket") -gt 1
          set descOfTicket $descOfTicket $desc
        else
          set descOfTicket $desc
        end
        # echo "2desc is |$descOfTicket| |$desc|"

    end

  end

  set descOfTicket (string join "_" $descOfTicket)
  # if test (count $descOfTicket) -gt 2
  #   set descOfTicket (string join "_" $descOfTicket)
  # end

  # echo "2descOfTicket |$descOfTicket|"

  # iterate through all branches
  if [ "$descOfTicket" ]

    # trim out underscores from the begining
    #echo -n "searching ${descOfTicket}: "
    # check for matching branches at all
    set branchFound $(git branch -a | grep -i "$descOfTicket" | head -n 1)

    if [ "$branchFound" ]
      #echo "Found!"
      git checkout $descOfTicket

    else

      echo "New branch"
      # checkout from master
      git checkout -b "$descOfTicket" $trackingBranch
      # set comparison to master
      git branch --set-upstream-to=origin/$trackingBranch

      if [ "$modeSaveBranchname" ]
        echo "$descOfTicket" > "$branchFilename"
      end

    end

  else if  [ $otherSwitches = 'f' ]

    # show all branches local and remote
    set branchAll (git branch -a | string collect)
    #echo "$branchAll\n\n---\n"

    set gitFolderDirectory $(gitrootfolder)
    echo "> $gitFolderDirectory"

    #echo $branchAll | grep -i "remotes/origin" | awk '{print $1}'
    for branchIndex in (echo $branchAll | grep -i "remotes/origin" | awk '{print $1}')
      echo "branches $branchIndex"
    end

    for branchIndex in (echo $branchAll | grep -v "remotes/origin")
      set branchIndicator ""
      if [ "$branchIndex" = "$currentBranch" ]
        set branchIndicator ">> "
      end

      if not string match -iq "*" $branchIndex

        set originInfo $(ggetorg $gitFolderDirectory $branchIndex)

        if [ ! -z $originInfo ]
          echo "$branchIndicator$branchIndex => $originInfo"
        else
          echo "$branchIndicator$branchIndex"
        end
      end
    end
    # awk to remove leading spaces
    echo -e "---\nUNTRACKED "

    # command only works on relative path.  Need to go to gitroot
    cd $(gitrootfolder)
    git ls-files --others --exclude-standard | sed 's/^/>>      /g'

    echo -e "---\nSTATUS "

    cd $currentDirectory
    git status --untracked-files=no

  end

  if [ $(glreachable) = "n" ]
    echo ">>>>> repo: unreachable!!!"
  end

end

function gcloneurl

  # removes trailing slashes from parameter
  set mungedURL $argv[1]

  if test (count $argv) -gt 1
    echo "1 $mungedURL.git $argv[2]"
    git clone "$mungedURL.git" $argv[2]
  else
    echo "2 $mungedURL.git"
    git clone "$mungedURL.git"
  end
end

function gpushs

  gpush -s

end

function gpush

  set openLink 't'       # always want to open link
  set currentPath $(pwd) # fall back point
  set repoPath ""        # to catch if you want to push from a different directory
  set quite 'f'          # stay quite first

  if test (count $argv)

    set key "$argv[1]"
    set argv $argv[2..-1]

    switch $key

      case '-p';
        set repoPath "$argv[1]"
        set argv $argv[2..-1]

      case '-s'; set openLink 'f'
      case '-q'; set quite 't'

    end

  end

  if [ "$repoPath" != "" ]

    echo "cd into repoPath $repoPath"
    cd "$repoPath"

  end

  set gitBranch $(git rev-parse --abbrev-ref HEAD)
  set gBranchOutput $(git push -f origin "$gitBranch"  2>&1)
  set pullRequestLink $(echo $gBranchOutput | grep -io "https://.*merge_requests[^ ]\+")

  if [ "$quite" != "t" ]

    echo -e "repoPath $repoPath \n$gitBranch $gBranchOutput"

  end

  if test -n "$pullRequestLink"

    echo "PR link => |$pullRequestLink|"
    if [ $openLink = "t" ]
      open $pullRequestLink
    end
  end

  if [ $repoPath != "" ]

    echo "cd into $currentPath"
    cd "$currentPath"

  end

end

function gtrack

  set gitBranch $(git rev-parse --abbrev-ref HEAD)
  git branch --set-upstream-to=origin/$gitBranch $gitBranch

end

# see if you're in a repo by looking for prompt error
function isRepo

  set gitStatus $(git status 2>&1)

  #echo "|$gitStatus|"
  if [ "$gitStatus" = "fatal: not a git repository (or any of the parent directories): .git" ]
    echo 'f'
  else
    echo 't'
  end

end

# find root git folder
function gitrootfolder

  set currentDirectory $(pwd)
  set gitDirectory $currentDirectory
  set gitStatus $(isRepo)

  #echo "gitStatus $gitStatus"
  while [ "$gitStatus" = "t" ]
    # save current path prior to
    set gitDirectory $(pwd)
    cd ..
    # find out if you get a prompt
    set gitStatus $(isRepo)
  end

  #echo "current git repo root is $gitDirectory"

  # if you still have an arg.  It's probably how much bepth to go above it
  if test (count $argv) -gt 0

    set levelCount $argv[1]
    set argv $argv[2..-1]

    while test (count $argv) -gt 0

      set levelCount (math "$levelCount - 1")
      cd ..
      set gitDirectory $(pwd)

    end

  end

  echo -n "$gitDirectory"

  cd $currentDirectory

end

# change origin
function ggetorg

  set gitDirectory "$argv[1]"
  set targetBranch "$argv[2]"

  #grep -A 2 -i "branch \"$targetBranch\"" .git/config | tail -n 1
  set currentRef $(grep -A 2 -i "branch \"$targetBranch\"" "$gitDirectory/.git/config" | tail -n 1 | awk '{print $(NF)}')

  if [ ! -z $currentRef ]

    set currentRef $(basename $currentRef)
    echo "$currentRef"

  else
    echo "$targetBranch"
  end

    #gitBranch=`git rev-parse --abbrev-ref HEAD`
    #git branch --set-upstream-to=origin/$remoteBranch $gitBranch
end

# change origin
function gorg

  set remoteBranch "master"
  if test (count $argv) -gt 0
    set remoteBranch $argv[1]
  end

  gitBranch=`git rev-parse --abbrev-ref HEAD`
  git branch --set-upstream-to=origin/$remoteBranch $gitBranch

end

# only for ansible server
function gchanges

  set changeFile $(git diff --name-only HEAD HEAD~90 ~/lab/repos/nameserver | grep -E "fwd|rev" | awk -F/ '{printf "%s,", $4"/"$5}')
  #echo $changeFile
  set formattedFiles $(echo "\"changed_files\":$changeFile" | sed 's/,$//g')
  #echo "$formattedFiles"
  echo "ansible-playbook -i inv/pus nameserver.yml -l primary --extra-vars \"$formattedFiles\" --tag \"nsupdate\""

end

function gclonebase

  cd ~/lab/repos

  gclone $argv

end

function gisgitlab

  echo "$argv[1]"

  # removes trailing slashes from parameter
  set mungedURL (string replace --regex '/+$' '' $argv[1])

  # if gitlabdev
  if string match -iq "*GIT_URL*" $mungedURL
    echo "t"
  else
    echo "f"
  end

end

function gclone

  echo "$argv[1]"
  # removes trailing slashes from parameter
  set mungedURL (string replace --regex '/+$' '' $argv[1])

  echo "1 mungedURL $mungedURL"

  if string match -iq "*github.com*" $mungedURL

    set mungedURL (string replace --regex '/-.*' '' $mungedURL)
    set mungedURL $(echo "$mungedURL" | sed "s/https:\/\/github.com\//git@github.com:/g")
    echo "2 mungedURL $mungedURL"

  else

    # remove everything after blob
    #mungedURL="${mungedURL%/blob*}"
    # remove everything after tree
    set mungedURL (string replace --regex 'tree*' '' $mungedURL)
    set mungedURL (string replace --regex '/blob*' '' $mungedURL)
    set mungedURL (echo "$mungedURL" | sed "s/https:\/\/gitlabdev/git@gitlabdev/g")

  end
  set mungedURL $(echo "$mungedURL" | sed "s/info\//info:/g")
  echo "$mungedURL"

    #return;

  if test (count $argv) -gt 1
    echo "1 $mungedURL.git $argv[2]"
    git clone "$mungedURL.git" $argv[2]
  else
    echo "2 $mungedURL.git"
    git clone "$mungedURL.git"
  end

end


function gurl

  set gitOrigin (git config --list | grep -i remote.origin.url)
  set gitOrigin (string replace ":" "/" $gitOrigin)
  set gitOrigin (string replace ".git" "" $gitOrigin)
  set gitOrigin (string replace "remote.origin.url=git@" "http://" $gitOrigin)
  echo "$gitOrigin"

end

function gline

  set gitOrigin $(gurl)
  set gitPipe "/-/pipelines"

  echo "$gitOrigin$gitPipe"
  open "$gitOrigin$gitPipe"

end

function gbranch

  set gitOrigin $(gurl)
  set gitPR "/-/branches"

  echo "$gitOrigin$gitPR"
  open "$gitOrigin$gitPR"

end

function gpr

  set gitOrigin (gurl)
  set gitPR "/-/merge_requests"
  echo "name is $gitOrigin/$gitPR"

  if string match -iq "*github.com*" $gitOrigin

    set gitPR "/pulls"
  end

  echo "$gitOrigin$gitPR"
  open "$gitOrigin$gitPR"

end
