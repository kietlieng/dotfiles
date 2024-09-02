#alias gp="git pull"
#alias gs="git status"
alias gD="git diff --staged"
alias gP="gpush"
alias ga='git add'
alias gbr="g -branch"
alias gco="git checkout "
alias gd='git diff'
alias gdstaged='git diff --staged'
alias gfetch="git fetch --all"
alias gfiles="git log --name-only --oneline"
alias gl="git log -p"
alias glines="git log -p --unified=0"
alias glogfiles="git log --name-only"
alias gmmaster="git merge master"
alias gprune="g -prune"
alias gpull="git pull --all"
alias grebaseabort='git rebase --abort'
alias grebasedelete='rm -fr ".git/rebase-merge"'
alias gslist="git stash list"
alias gsstack="git log --name-status --oneline"
alias gtrack="git update-index --no-assume-unchanged "
alias guadd='git restore --staged'
alias guntrack="git update-index --assume-unchanged "
alias guntracklist="git ls-files -v | grep \"^[[:lower:]]\""
alias spop="git stash pop"
alias spush="git stash push"

# commit message inline or via editor
function gacom() {
  git add $1
  shift

  gcom $@
}

function gorigin() {

  branchName="master"

  if [[ $# -gt 0 ]]; then
    branchName="$1"
  fi

  git branch --set-upstream-to=origin/$branchName $branchName

}

function gmerge() {
  git merge --no-ff
}

function gcom() {

  if [[ $# -gt 0 ]]; then
    git commit -m "$*"
  else
    git commit
  fi

}

function gwarn() {
  git config pull.rebase false  # merge (the default strategy)
  git config pull.rebase true   # rebase
  git config pull.ff only       # fast-forward only
}

# hard reset
function greset() {
  git config pull.rebase false  # merge (the default strategy)
  git config pull.rebase true   # rebase
  git config pull.ff only       # fast-forward only

  git reset --hard
  #git pull
  if [[ $# -gt 0 ]]; then

    while [[ $# -gt 0 ]]; do
      
      git rebose $1
      shift

    done

  else

    git rebase

  fi
}

function gcommits() {
  #git shortlog --summary --numbered
  git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit $@
  #git log --pretty=format:'%Cred%h%Creset %C(bold blue)<%an>%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)' --abbrev-commit --graph $@
}

# dump everything that's not commited
function gunstage() {
  git restore --staged *
}

# undo last commit
function guncommit() {
  git reset --hard HEAD~1
}

# sleeps after a certain amount of git count
function gwait() {
  gitCount=$(ps aux | grep -i git | wc -l)
  maxConnections=50
  sleepTime=2
  # 100 seems to be the limit
  while [[ $gitCount -gt $maxConnections ]]; do
    gitCount=$(ps aux | grep -i git | wc -l)
    sleep $sleepTime
  done
}

# go to root folder 
function groot() {

  rootFolder=$(gitrootfolder)
  cd $rootFolder
  echo "root folder $rootFolder"

}

# git pull all repos from current
function gp() {
  # need absolute path
  #which git
  currentDirectory=$(pwd)
  cd $currentDirectory
  rootFolder=$(gitrootfolder)

  #echo "folder $rootFolder"
  # this means you deep within a repo
  if [[ $currentDirectory != $rootFolder ]];
  then
    #echo "rootfolder $rootFolder"
    cd "$rootFolder"
    currentBranch=$(git rev-parse --abbrev-ref HEAD)
    originInfo=$(ggetorg $rootFolder $currentBranch)
    #echo "origin is 1 $currentBranch $originInfo"
    if [[ $originInfo != 'master' ]]; then
      #currentFolder=$(pwd)
      #echo "currentFolder $currentFolder: $currentBranch"
      #echo "git pull rebase --rebase origin $originInfo"
      #git pull --rebase origin "$originInfo" &
      git rebase
    else
      #git pull &
      #git pull --rebase origin "$originInfo" &
      git rebase
    fi
    gwait
  fi

  cd $currentDirectory
  for gitFolder in $(find . -name ".git" -type d -exec realpath {} \;) ; do
    #echo "update $gitFolder"
    cd $gitFolder/..
    # do not set to master
    gitFolderDirectory=$(pwd)
    currentBranch=$(git rev-parse --abbrev-ref HEAD)
    originInfo=$(ggetorg $gitFolderDirectory $currentBranch)
    #echo "origin is 2 $originInfo from branch $currentBranch"
    #pwd
    echo "⇣ $gitFolderDirectory" 
    git rebase

#    if [[ $originInfo != 'master' ]]; then
#      #currentFolder=$(pwd)
#      #echo "rebase to $originInfo"
#      #git pull --rebase origin "$originInfo" &
#      git rebase
#    else
#      #echo "pull from master"
#      #git pull &
#      #git pull --rebase origin "$originInfo" &
#      git rebase
#    fi

    #gwarn
    # sleep if it's over a certain amount
    gwait
  done

  cd $currentDirectory
}

function gexp() {
  # https://twitter.com/tomnomnom/status/1133345832688857095?lang=en
  {
    # grep first
    find .git/objects/pack/ -name "*.idx" |
      while read i; do
        git show-index < "$i" | awk '{print $2}';
      done;

        # grep second
        find .git/objects/ -type f | grep -v '/pack/' |
          awk -F'/' '{print $(NF-1)$NF}';
        } | while read o; do
        git cat-file -p $o;
      done | grep -E "$1"
}

# return end of url path for branch naming.
# -f do not trim.  But return the full path. Useful for remote branchs or branch names with / in the name
function useBasename() {
  baseValue=''
  trimPaths='t'
  while [[ $# -gt 0 ]];
  do

    key="$1"
    shift

    case $key in
      '-f' )
        trimPaths='f'
        ;;
      * )

        if [[ $trimPaths = 't' ]]; then
          baseValue=$(basename $key)
        else
          baseValue=$key
        fi
        ;;
    esac
  done
  echo "$baseValue"

}

# git stash then switch branch
function gstashit() {
  git stash push
  sleep 2
  g $@
  git stash pop
}

# you want to use the last branch name
function gblast() {

  local lastBranch=$(cat ~/.gitBranchName)
  g "$lastBranch"

}

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
function g() {

  # quit if not a repo
  if [[ $(isRepo) = "f" ]];
  then
    echo "Not a repo"
    return
  fi

  local currentDirectory=$(pwd)
  local branchFilename=~/.gitBranchName
  local currentBranch=`git rev-parse --abbrev-ref HEAD`
  local descOfTicket=""
  local otherSwitches="f"
  local trackingBranch=$(glbranchdefault)
  local trimPaths=''
  local modeSaveBranchname=''
  local key=''

  while [[ $# -gt 0 ]];
  do
    key="$1"
    shift

    case $key in

      '-f' )

        trimPaths='-f'
        ;;

      '-branchdefault' )

#        echo "refresh"
        gllocalbranchdefault "-unset"
        return
        ;;

      '-branch' ) # last branch

        descOfTicket=$(cat $branchFilename)
        ;;

      '-prune' )

        # delete all merged local branchs
        mergedBranches=$(git branch --merged origin/$trackingBranch | grep -iv "master\|develop\|$currentBranch\|$trackingBranch")
        if [[ $mergedBranches ]]; then
          echo $mergedBranches | xargs git branch -d
        else
          echo "no branches to prune"
        fi

        # clean branch caches
        git fetch -p
        otherSwitches="t"
        ;;

      '-off' )

        trackingBranch="$1"
        shift
        ;;

      '-fdd' ) # delete both remote and local

        trimPaths='-f'
        branchName=$(useBasename $trimPaths $1)
        # local branch
        git branch -D "$branchName"
        # remote branch
        git push origin :$branchName
        otherSwitches="t"
        shift
        ;;

      '-dd' ) # delete both remote and local

        branchName=$(useBasename $trimPaths $1)
        # local branch
        git branch -D "$branchName"
        # remote branch
        git push origin :$branchName
        otherSwitches="t"
        shift
        ;;

      '-D' ) # delete remote

        branchName=$(useBasename $trimPaths $1)
        git push origin :$branchName
        otherSwitches="t"
        shift
        ;;

      '-d' ) # delete local

        branchName=$(useBasename $trimPaths $1)
        git branch -D "$branchName"
        otherSwitches="t"
        shift
        ;;

      '-a' )
        modeSaveBranchname='t'
        
        ;;

      * )

        desc=$(useBasename $trimPaths $key)
        descOfTicket="${descOfTicket}_${desc}"
        descOfTicket=$(echo "$descOfTicket" | sed 's/_*//')
        ;;

    esac
  done

  # iterate through all branches
  if  [[ $descOfTicket ]]; then

    # trim out underscores from the begining
    #echo -n "searching ${descOfTicket}: "
    # check for matching branches at all
    branchFound=$(git branch -a | grep -i "$descOfTicket" | head -n 1)
    if [[ $branchFound ]]; then
      #echo "Found!"
      git checkout $descOfTicket
    else
      echo "New branch"
      # checkout from master
      git checkout -b "${descOfTicket}" $trackingBranch
      # set comparison to master
      git branch --set-upstream-to=origin/$trackingBranch

      if [[ $modeSaveBranchname ]]; then
        echo "$descOfTicket" > "$branchFilename"
      fi

    fi

  elif  [[ $otherSwitches = 'f' ]]; then
    # show all branches local and remote
    branchAll=$(git branch -a)
    #echo "$branchAll\n\n---\n"

    gitFolderDirectory=$(gitrootfolder)
    echo "> $gitFolderDirectory\n"

    #echo $branchAll | grep -i "remotes/origin" | awk '{print $1}'
    for branchIndex in $(echo $branchAll | grep -i "remotes/origin" | awk '{print $1}')
    do
      echo "$branchIndex"
    done

    for branchIndex in $(echo $branchAll | grep -v "remotes/origin")
    do
      branchIndicator=""
      if [[ $branchIndex = $currentBranch ]]; then
        branchIndicator=">> "
      fi
      if [[ $branchIndex != "*" ]]; then
        originInfo=$(ggetorg $gitFolderDirectory $branchIndex)
        if [[ ! -z $originInfo ]]; then
          echo "${branchIndicator}$branchIndex => $originInfo"
        else
          echo "${branchIndicator}$branchIndex"
        fi
      fi
    done
    # awk to remove leading spaces
    echo "---\nUNTRACKED "

    # command only works on relative path.  Need to go to gitroot 
    cd $(gitrootfolder)
    git ls-files --others --exclude-standard | sed 's/^/>>      /g'

    echo "---\nSTATUS "

    cd $currentDirectory
    git status --untracked-files=no

  fi

  if [[ $(glreachable) == "n" ]]; then
    echo "repo: unreachable!!!"
  fi

}

function gcloneurl() {
  # removes trailing slashes from parameter
  mungedURL=$1

  if [[ $# -gt 1 ]]; then
    echo "1 ${mungedURL}.git $2"
    git clone "${mungedURL}.git" $2
  else
    echo "2 ${mungedURL}.git"
    git clone "${mungedURL}.git"
  fi
}

function gpushs() {

  gpush -s

}

function gpush() {

  openLink='t'       # always want to open link
  currentPath=$(pwd) # fall back point
  repoPath=""        # to catch if you want to push from a different directory
  quite='f'          # stay quite first

  if [[ $# -gt 0 ]]; then

    key="$1"
    shift

    case $key in

      '-p' )
        repoPath="$2"
        ;;

      '-s')
        openLink='f'
        ;;

      '-q' )
        quite='t'
        ;;

      * )
        ;;

    esac

  fi

  if [[ $repoPath != "" ]]; then

    echo "cd into repoPath $repoPath"
    cd "$repoPath"

  fi

  gitBranch=$(git rev-parse --abbrev-ref HEAD)
  gBranchOutput=$(git push -f origin "${gitBranch}"  2>&1)
  pullRequestLink=$(echo $gBranchOutput | grep -io "https://.*merge_requests[^ ]\+")

  if [[ "$quite" != "t" ]]; then

    echo "repoPath $repoPath \n$gitBranch $gBranchOutput"

  fi

  if [[ ! -z $pullRequestLink ]]; then
    echo "pull link => $pullRequestLink"
    if [[ $openLink = "t" ]]; then
      open $pullRequestLink
    fi
  fi

  if [[ $repoPath != "" ]]; then

    echo "cd into $currentPath"
    cd "$currentPath"

  fi
}

function gtrack() {
  gitBranch=`git rev-parse --abbrev-ref HEAD`
  git branch --set-upstream-to=origin/$gitBranch $gitBranch
}

# see if you're in a repo by looking for prompt error
function isRepo() {
  gitStatus=$(git status 2>&1)
  #echo "|$gitStatus|"
  if [[ $gitStatus = "fatal: not a git repository (or any of the parent directories): .git" ]]; then
    echo 'f'
  else
    echo 't'
  fi
}

# find root git folder
function gitrootfolder() {
  currentDirectory=$(pwd)
  gitDirectory=$currentDirectory
  gitStatus=$(isRepo)
  #echo "gitStatus $gitStatus"
  while [[ $gitStatus = "t" ]];
  do
    # save current path prior to
    gitDirectory=$(pwd)
    cd ..
    # find out if you get a prompt
    gitStatus=$(isRepo)
  done
  #echo "current git repo root is $gitDirectory"
  echo -n "$gitDirectory"
  cd $currentDirectory
}

# change origin
function ggetorg() {
  gitDirectory="$1"
  targetBranch="$2"
  #grep -A 2 -i "branch \"$targetBranch\"" .git/config | tail -n 1
  currentRef=$(grep -A 2 -i "branch \"$targetBranch\"" "$gitDirectory/.git/config" | tail -n 1 | awk '{print $(NF)}')
  if [[ ! -z $currentRef ]]; then
    currentRef=$(basename $currentRef)
    echo "$currentRef"
  else
    echo "$targetBranch"
  fi

    #gitBranch=`git rev-parse --abbrev-ref HEAD`
    #git branch --set-upstream-to=origin/$remoteBranch $gitBranch
}

# change origin
function gorg() {
  remoteBranch="master"
  if [[ $# -gt 0 ]]; then
    remoteBranch=$1
  fi

  gitBranch=`git rev-parse --abbrev-ref HEAD`
  git branch --set-upstream-to=origin/$remoteBranch $gitBranch
}

# only for ansible server
function gchanges() {
  changeFile=($(git diff --name-only HEAD HEAD~90 ~/lab/repos/nameserver | grep -E "fwd|rev" | awk -F/ '{printf "%s,", $4"/"$5}'))
  #echo $changeFile
  formattedFiles=$(echo "\"changed_files\":${changeFile[@]}" | sed 's/,$//g')
  #echo "$formattedFiles"
  echo "ansible-playbook -i inv/pus nameserver.yml -l primary --extra-vars \"${formattedFiles}\" --tag \"nsupdate\""
}

function gclonebase() {
  cd ~/lab/repos

  gclone $@
}

function gisgitlab() {

  echo "$1"
  # removes trailing slashes from parameter
  mungedURL="${1%/}"

  # if gitlabdev
  if [[ $mungedURL == *"$GIT_URL"* ]]; then
    echo "t"
  else
    echo "f"
  fi

}

function gclone() {
  echo "$1"
  # removes trailing slashes from parameter
  mungedURL="${1%/}"

  if [[ $mungedURL != *"github.com"* ]]; then
    mungedURL="${mungedURL/\/-*/}"
    mungedURL=$(echo "$mungedURL" | sed "s/https:\/\//git@/g")
  else
    # remove everything after blob
    #mungedURL="${mungedURL%/blob*}"
    # remove everything after tree
    mungedURL="${mungedURL%tree*}"
    mungedURL="${mungedURL/\/blob*/}"
  fi
  mungedURL=$(echo "$mungedURL" | sed "s/info\//info:/g")
  echo "$mungedURL"

    #return;

  if [[ $# -gt 1 ]]; then
    echo "1 $mungedURL.git $2"
    git clone "$mungedURL.git" $2
  else
    echo "2 $mungedURL.git"
    git clone "$mungedURL.git"
  fi

}


function gurl() {

  local gitOrigin=`git config --list | grep -i remote.origin.url`
  gitOrigin=$(echo "$gitOrigin" | sed "s/:/\//g")
  gitOrigin=$(echo "$gitOrigin" | sed "s/\.git//g")
  gitOrigin=$(echo "$gitOrigin" | sed "s/remote\.origin\.url=git@/https\:\/\//g")
  echo "${gitOrigin}"

}

function gline() {

  local gitOrigin=$(gurl)
  local gitPipe="/-/pipelines"

  echo "${gitOrigin}${gitPipe}"
  open "${gitOrigin}${gitPipe}"

}

function gbranch() {

  local gitOrigin=$(gurl)
  local gitPR="/-/branches"

  echo "${gitOrigin}${gitPR}"
  open "${gitOrigin}${gitPR}"

}

function gpr() {

  local gitOrigin=$(gurl)
  local gitPR="/-/merge_requests"

  if [[ $gitOrigin == *github.com* ]];
  then
    gitPR="/pulls"
  fi
  echo "${gitOrigin}${gitPR}"
  open "${gitOrigin}${gitPR}"

}
