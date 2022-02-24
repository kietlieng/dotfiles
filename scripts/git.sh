alias gadd='git add '
alias gcb='git checkout -b'
alias gco='git checkout '
alias gcom='git commit -m '
alias gdif='git diff '
alias gitfilestatus="git log --name-status --oneline"
alias glog="git log -p"
alias gp="git pull"
alias gpretty="git log --name-only"
alias gst="git status"

function gwarn() {
  git config pull.rebase false  # merge (the default strategy)
  git config pull.rebase true   # rebase
  git config pull.ff only       # fast-forward only
} 

function gusers() {
  #git shortlog --summary --numbered
  git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit $@
  #git log --pretty=format:'%Cred%h%Creset %C(bold blue)<%an>%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)' --abbrev-commit --graph $@
}

function gmaster() {
  git reset --hard
  git pull origin master
  git checkout master
  git pull
}

function greset() {
  git config pull.rebase false  # merge (the default strategy)
  git config pull.rebase true   # rebase
  git config pull.ff only       # fast-forward only
  git reset --hard
  git pull
}

function gpullall() {
# Fast git pull option ignored
#  GITPULL_FAST=''
#  while [[ $# -gt 0 ]];
#  do
#    KEY="$1"
#    case $key in
#    '-f' ) # fast pull
#      GITPULL_FAST='true'
#      shift
#      ;;
#    * )
#      shift
#      ;;
#    esac
#  done

  for d in $(find . -name ".git" -type d) ; do
     pushd $d > /dev/null
     cd ..
     pwd
     gwarn
     /usr/bin/git pull
     popd > /dev/null
     popd > /dev/null
  done
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


function gbambooscript(){
  echo "export test_token=\"{9Pq__kam.{65%GD~647jT0'n26L^1t(\"; git clone -b master https://pacdocker:\${test_token}@bitbucket.org/paciolan/dockerbuild.git --depth 1" | pbcopy
}

# takes all parameters
# 1st parameter ticket name
# n+ parameter description
function gbranch() {
    ticket_url="${1%/}"
    ticket_url="${ticket_url##*/}"
    shift
    description=""
    while [[ $# -gt 0 ]]
    do
        description="${description}_${1}"
        shift
    done
    echo "url ${ticket_url}"
    echo $description
    git checkout -b "${ticket_url}${description}" master
    git branch --set-upstream-to=origin/master
}

function gclone() { 
  echo "$1"
  # removes trailing slashes from parameter
  MUNGED_URL=$(sed "s/https:\/\//git@/g" <<< ${@%/})
  MUNGED_URL=$(sed "s/info\//info:/g" <<< $MUNGED_URL)
  echo "$MUNGED_URL.git"
  git clone "$MUNGED_URL.git"
}

function gpush() {
  GIT_BRANCH=`git rev-parse --abbrev-ref HEAD`
  echo $GIT_BRANCH
  git push origin "${GIT_BRANCH}"

}

function gpr() {
  GIT_ORIGIN=`git config --list | grep -i remote.origin.url`
  GIT_PR="/-/merge_requests"
  GIT_ORIGIN=$(sed "s/:/\//g" <<< $GIT_ORIGIN)
  GIT_ORIGIN=$(sed "s/\.git//g" <<< $GIT_ORIGIN) 
  GIT_ORIGIN=$(sed "s/remote\.origin\.url=git@/https\:\/\//g" <<< $GIT_ORIGIN)
  if [[ $GIT_ORIGIN == *github.com* ]];
  then
      GIT_PR="/pulls"
  fi
  echo "${GIT_ORIGIN}${GIT_PR}"
  open "${GIT_ORIGIN}${GIT_PR}"
}

function glink() {
  GIT_ORIGIN=`git config --list | grep -i remote.origin.url`
  GIT_PR=""
  # find out if it's a pr
  echo "$GIT_ORIGIN"
  # specifically for bitbucket
  GIT_ORIGIN=$(sed "s/org:/org\//g" <<< $GIT_ORIGIN)
  # specifically for paciolan
  GIT_ORIGIN=$(sed "s/info:/info\//g" <<< $GIT_ORIGIN)
  # specifically for github
  GIT_ORIGIN=$(sed "s/com:/com\//g" <<< $GIT_ORIGIN)
  # converting @git and remove it
  GIT_ORIGIN=$(sed "s/\.git//g" <<< $GIT_ORIGIN) 
  GIT_ORIGIN=$(sed "s/remote\.origin\.url=//g" <<< $GIT_ORIGIN)
  GIT_ORIGIN=$(sed "s/git@/https:\/\//g" <<< $GIT_ORIGIN)
  #echo "origin ${GIT_ORIGIN}"
  #echo "${GIT_ORIGIN}${GIT_PR}"
  open "${GIT_ORIGIN}${GIT_PR}"
}
