#alias kdel="k delete"
#alias kdeld="k delete deployment"
#alias kdeli="k delete ing"
#alias kdelp="k delete pod"
#alias kdels="k delete svc"
#alias kpoa_name="k get pods -o yaml --all-namespaces | grep -i \"name:\|namespace:\""


#export K_DEFAULTS="catalog>\\|evenue-nextjs\\|graphql-consumer\\|api-orch\\|cdb-manager"

export K_ALL_NAMESPACES="--all-namespaces"
export K_MAX_LOG_REQUEST="--tail 0 --max-log-requests=10000"
export K_TEMPLATE="--template \"\x1b[32m{{.PodName}}\x1b[0m \x1b[36m{{.ContainerName}}\x1b[0m \x1b[31m{{.Message}}\x1b[0m {{\\\"\n\\\"}}\""
export K_TEMPLATE=""
export K_EXCLUDE=""

alias k="kubectl --insecure-skip-tls-verify"
alias kap="k apply -f "
alias kcm="k get configmap"
alias kcma="k get configmap --all-namespaces"
alias kcmy="k get -o yaml configmap"
alias kd="k get deployment"
alias kda="k get deployment --all-namespaces"
alias kdo="k get -o yaml deployment"
alias kdp="k describe pod"
alias ke="k get events"
alias kg="k get"
alias kgo="k get -o yaml"
alias ki="k get ing"
alias kinfo="k cluster-info"
alias kio="k get -o yaml ing"
alias kis="k get ing --all-namespaces"
alias kj="k get jobs"
alias kp="k get pods"
alias kpl="k get pods --show-labels"
alias kpo="k get pods -o go-template --template '{{range .items}}{{.metadata.namespace}}>{{.metadata.name}}{{\"\\n\"}}{{end}}'"
alias kpoa="k get pods -o go-template --all-namespaces --template '{{range .items}}{{.metadata.namespace}}>{{.metadata.name}}{{\"\\n\"}}{{end}}'"
alias kpoav="k get pods -o yaml --all-namespaces"
alias kpov="k get pods -o yaml"
alias kps="k get pods --show-labels --selector"
alias ksa="k get rolebindings,clusterrolebindings,sa --all-namespaces -o custom-columns='KIND:kind,NAMESPACE:metadata.namespace,NAME:metadata.name,SERVICE_ACCOUNTS:subjects.name'"
alias ksa="k get serviceaccounts --all-namespaces"
alias ksecrets="k get secrets"
alias kserv="k get svc"
alias kso="k get -o yaml svc"
alias kv="k get pv,pvc"
alias vikdefaults="vim ~/.kube/.kubedefaults"
alias vikub="nvim ~/.kube/config"


# disable environment
alias kle="kl -e"
alias klse="kl -s -e"

# disable default
alias kld="kl -d"
alias klsd="kl -s -d"

# disable both environment / defaults
alias kled="kl -e -d"
alias klsed="kl -s -e -d"
alias kla="kl -a"
alias klsa="kl -s -a"

# misc
alias klc="kl -c"
alias klf="kl -f"
alias klfc="kl -f -c"

# enable environment / defaults 
alias kls="kl -s"

# misc
alias klsc="kl -s -c"
alias klsf="kl -s -f"
alias klsfc="kl -s -f -c"


# kps --show-labels --selector app=redis
# list all roles
# to get selector
#alias ksa="k  get clusterrole,rolebindings,clusterrolebindings --all-namespaces -o custom-columns='KIND:kind,NAMESPACE:metadata.namespace,NAME:metadata.name,SERVICE_ACCOUNTS:subjects[?(@.kind=="ServiceAccount")].name'"
#alias ksa="k get rolebindings,clusterrolebindings --all-namespaces -o custom-columns='KIND:kind,NAMESPACE:metadata.namespace,NAME:metadata.name,SERVICE_ACCOUNTS:subjects[?(@.kind==\"ServiceAccount\")].name'"
#alias ksa="k get serviceaccounts --all-namespaces"


function kgetdefaults() {
  local defaults=''

  for iDefault in $(cat ~/.kube/.kubedefaults); do

    if [[ $defaults ]]; then
      defaults="$defaults\\\\|$iDefault"
    else
      defaults="$iDefault"
    fi

  done

  echo -n "$defaults"

}

function kdefaults() {

  local key=''

  while [[ $# -gt 0 ]]; do

    key="$1"
    shift

    case "$key" in
      '-reset')
        echo "$1" > ~/.kube/.kubedefaults
        shift
        ;;
      '-d') 
        sed  -i "" "/$1/d" ~/.kube/.kubedefaults
        shift
        ;;
      *) 
        echo "$key" >> ~/.kube/.kubedefaults
        ;;
    esac

  done

  cat ~/.kube/.kubedefaults

}

function kenv() {

  while [[ $# -gt 0 ]]; do
    echo "$1" > ~/.pacenv
  done

  local env=$(cat ~/.pacenv)
  echo -n "$env"

}

# connect to service
function ksforward() {
  echo "kubectl port-forward service/<service name> 3000:80"
}

# connect to ingress
function kiforward() {
  #kubectl get pods --all-namespaces
  #NAMESPACE   NAME                              READY STATUS
  #kube-system coredns-5644d7b6d9-jn7cq          1/1   Running
  #kube-system etcd-minikube                     1/1   Running
  #kube-system kube-apiserver-minikube           1/1   Running
  #kube-system kube-controller-manager-minikube  1/1   Running
  #kube-system kube-proxy-zvf2h                  1/1   Running
  #kube-system kube-scheduler-minikube           1/1   Running
  #kube-system nginx-ingress-controller-6fc5bcc  1/1   Running
  #echo "kubectl port-forward nginx-ingress-controller-6fc5bcc 3000:80 --namespace kube-system"

  echo "kubectl port-forward nginx-ingress-controller-6fc5bcc 3000:80 --namespace kube-system"
}

# change kubernetes config file aka different clusters
function kcon() {
  KUBE_DIRECTORY=~/.kube
  echo "Current context $(kubectl config current-context)"

  if [ $# -lt 1 ]
  then
    ls -l $KUBE_DIRECTORY/config* | awk '{print $NF}'
  else
    CURRENTTIME=$(date +"%y%m%d%H%M")
    ls $KUBE_DIRECTORY/config.$1
    if [ -f $KUBE_DIRECTORY/config.$1 ]; then
      echo "Replacing config with config.$1"
      #cp $KUBE_DIRECTORY/config $KUBE_DIRECTORY/config.$CURRENTTIME
      cp $KUBE_DIRECTORY/config.$1 $KUBE_DIRECTORY/config
    else
      echo "File $KUBE_DIRECTORY/config.$1 does not exists"
    fi
  fi

  for targetConf in $(ls ~/.kube/config.*); do
    #echo "current $targetConf"
    if cmp -s "$targetConf" ~/.kube/config; then
      echo "\nFile match $targetConf"
    fi
  done
}

# change node / or namespace default context
function kns() {

  local findN=""

  local modeContext=''

  while [[ $# -gt 0 ]]; do

    key="$1"
    shift

    case "$key" in

      '-n') 
        k config use-context $1
        shift
        ;;
      '-c') 
        modeContext='t'
        ;;
      *) 
        findN="${findN}${key}.*"
        ;;

    esac

  done

  local kspaces=$(k get namespace --all-namespaces | grep -i "$findN")

  if [[ $modeContext ]]; then

    local spaceTarget=$(echo "$kspaces" | grep -i "$findN" | head -n 1 | awk '{print $(NF-2)}')
    k config set-context --current --namespace=$spaceTarget
#    echo -n "$spaceTarget" > $FILE_KUBE_CONTEXT

  fi

  k get namespace --all-namespaces | grep -i "$findN"
  k config get-contexts
}

function knodes() {
  kubectl get nodes
  if [ $# -gt 0 ]
  then
    if [ $# -gt 1 ]
    then
      kubectl get pods -o wide --field-selector spec.nodeName="$1" ${@:2}
    else
      echo "second"
      kubectl get pods --all-namespaces -o wide --field-selector spec.nodeName=$1
    fi
  fi
}

# list all ip's
function kips() {
    k get pods -o=jsonpath="{range .items[*]}{.status.podIP}{','}{end}" --all-namespaces
    #k get pod -o wide --all-namespaces
}

function kexec() {
    kubectl exec -it -n $1 $2 $3
}

function kssh() {
    podsAll=$(kpo)
    podName=""
    shellType="bash"
    if [ $# -gt 0 ]
    then
        podName="$1"
    fi
    if [ $# -gt 1 ]
    then
        shellType="$2"
    fi
    echo "looking for *${podName}*\n"
    echo "$podsAll\n"
    ksshFound="f"
    # replace
    for currentPod in $(echo "$podsAll" | sed 's/:/\n/g')
    do
       if [[ "$ksshFound" = "f" && "$currentPod" = *"$podName"* ]]
       then
           k exec -it $currentPod -- $shellType
           ksshFound="t"
       fi
    done
}


function kl() {

  local modeCopy=''
  local modeEnv=''
  modeEnv=$(kenv)
  local modeConfig=''
  local modeFileoutput=''
  local modeDefault='t'
  local modeMulti='t'
  local modeSingle=''

  local key=''

  while [[ $# -gt 0 ]]; do

    key="$1"
    shift

    case "$key" in

     '-a') 
       modeDefault=''
       modeEnv=''
       ;;
     '-c') modeCopy='t' ;;
     '-kconf') 
       modeConfig="$1"
       shift
       ;;
     '-f') modeFileoutput='t' ;;
     '-d') modeDefault='' ;;
     '-s') 
       modeSingle='t' 
       modeMulti=''
       ;;
     '-env')
       kenv "$1"
       shift
       ;;
     '-e')
       modeEnv=''
       ;;
      *) ;;

    esac

  done

  local optionPods=''
  local selectValues=''
  local kpSelect=''
  local kpSelectAll=''

  if [[ $modeSingle ]]; then
    kpSelect=$(kpo)
  elif [[ $modeMulti ]]; then
    kpSelect=$(kpoa)
  fi

#  echo "$kpSelect"

  local kDefaults=''
  kDefaults=$(kgetdefaults)

#  becho "defaults: $kDefaults"

  # filter out by defaults
  if [[ $modeDefault ]]; then
    local kDefaults=$(kgetdefaults)
    kpSelect=$(echo "$kpSelect" | grep -i "$kDefaults")
  fi

  becho "\n$kpSelect"
  becho "\n$kDefaults"
  # filter out by environments
  if [[ $modeEnv ]]; then
    kpSelect=$(echo "$kpSelect" | grep -i "$modeEnv")
  fi

#  becho "\n$kpSelect"
  if [[ $modeConfig ]]; then

    if [[ ! -f ~/.kube/config.$modeConfig ]]; then
      becho "Does not exists ~/.kube/config.$modeConfig"
      becho "Rejecting and reverting"
      sleep 1
    fi 
  fi

  kpSelectAll="all\n$kpSelect"
  selectValues=$(echo "$kpSelectAll" | fzf --multi --prompt="Podname: ");

  if [ $? -eq 0 ]; then # pressed enter so do everything 
    if [[ "all" ==  "$selectValues" ]]; then # see if select all is enabled
      selectValues=$kpSelect
    fi
  fi

  for iPod in $(echo "$selectValues"); do

    iPod=$(echo "$iPod" | awk -F'>' '{print $2}')

    if [[ $optionPods ]]; then
      optionPods="$optionPods|$iPod"
    else
      optionPods="$iPod"
    fi

  done


  local copyDir=''
  if [[ $optionPods ]]; then

#    local logCommand="kail $optionPods"
    local logCommand="stern "
    if [[ $modeConfig ]]; then

      if [[ ! -f ~/.kube/config.$modeConfig ]]; then
        becho "Does not exists ~/.kube/config.$modeConfig"
        becho "Rejecting and reverting"
      fi 
      logCommand="$logCommand --kubeconfig ~/.kube/config.$modeConfig"

    fi

    logCommand="$logCommand --all-namespaces \"$optionPods\" $K_TEMPLATE $K_MAX_LOG_REQUEST"
    local hashDir=''

    if [[ $modeFileoutput ]]; then
      hashDir=$(hashdir)
      copyDir="/tmp/kail-$hashDir"
      logCommand="$logCommand > $copyDir"
      
    fi


    if [[ $modeCopy ]]; then
      echo "tailm $copyDir" | pbcopy
    fi

    becho "$logCommand"
    eval "$logCommand"

  fi

}

function hlsa() {

    k config get-contexts
    echo ""
    helm ls --all-namespaces

}

function hls() {
    k config get-contexts
    echo ""
    helm ls
}
