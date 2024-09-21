#alias kdel="k delete"
#alias kdeld="k delete deployment"
#alias kdeli="k delete ing"
#alias kdelp="k delete pod"
#alias kdels="k delete svc"
#alias kpoa="k get pods -o go-template --all-namespaces --template '{{range .items}}{{.metadata.name}}{{\"\n\"}}{{end}}'"
#alias kpoa_name="k get pods -o yaml --all-namespaces | grep -i \"name:\|namespace:\""
alias k="kubectl --insecure-skip-tls-verify"
alias kallns="k get namespaces"
alias kapp="k apply -f "
alias kd="k get deployment"
alias kdo="k get -o yaml deployment"
alias kdp="k describe pod"
alias ke="k get events"
alias kg="k get"
alias kgo="k get -o yaml"
alias ki="k get ing"
alias kinfo="k cluster-info"
alias kio="k get -o yaml ing"
alias kj="k get jobs"
alias klogs="klog -m"
alias kp="k get pods"
alias kpl="k get pods --show-labels"
alias kpo="k get pods -o go-template --template '{{range .items}}{{.metadata.name}}{{\"\n\"}}{{end}}'"
alias kpoa="k get pods -o go-template --all-namespaces --template '{{range .items}}{{.metadata.namespace}}>{{.metadata.name}}{{\"\\n\"}}{{end}}'"
alias kpoav="k get pods -o yaml --all-namespaces"
alias kpov="k get pods -o yaml"
alias ksa="k get serviceaccounts --all-namespaces"

# kps --show-labels --selector app=redis
# list all roles
# to get selector
#alias ksa="k  get clusterrole,rolebindings,clusterrolebindings --all-namespaces -o custom-columns='KIND:kind,NAMESPACE:metadata.namespace,NAME:metadata.name,SERVICE_ACCOUNTS:subjects[?(@.kind=="ServiceAccount")].name'"
#alias ksa="k get rolebindings,clusterrolebindings --all-namespaces -o custom-columns='KIND:kind,NAMESPACE:metadata.namespace,NAME:metadata.name,SERVICE_ACCOUNTS:subjects[?(@.kind==\"ServiceAccount\")].name'"
#alias ksa="k get serviceaccounts --all-namespaces"
alias kcm="k get configmap"
alias kcmo="k get -o yaml configmap"
alias kps="k get pods --show-labels --selector"
alias ks="k get svc"
alias ksa="k get rolebindings,clusterrolebindings,sa --all-namespaces -o custom-columns='KIND:kind,NAMESPACE:metadata.namespace,NAME:metadata.name,SERVICE_ACCOUNTS:subjects.name'"
alias ksecrets="k get secrets"
alias kso="k get -o yaml svc"
alias kv="k get pv,pvc"
alias vikub="nvim ~/.kube/config"

export FILE_KUBE_CONTEXT=~/.kube/.kubecontext

function kgetcontext() {
  cat $FILE_KUBE_CONTEXT
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
    echo -n "$spaceTarget" > $FILE_KUBE_CONTEXT

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

function kpox() { 

  local allValues=$(kpo)
  local filesToEdit=$(echo "$allValues" | /opt/homebrew/bin/fzf --multi --prompt="Podname: ")

  echo "$filesToEdit"

}


function klog() {

  local modeMulti=''
  local key=''

  while [[ $# -gt 0 ]]; do

    key="$1"
    shift

    case "$key" in
      '-m') 
        modeMulti='t' 
       ;;
      *) ;;
    esac

  done

  local optionPods=''

  if [[ $modeMulti ]]; then

    for iPod in $(kpoa | fzf --multi --prompt="Podname: "); do
      iPod=$(echo "$iPod" | awk -F'>' '{print $2}')
      optionPods="$optionPods -p $iPod"
    done

  else

    for iPod in $(kpox); do
      optionPods="$optionPods -p $iPod"
    done

  fi

  if [[ $optionPods ]]; then

    local kailCommand="kail --current-ns $optionPods"
    if [[ $modeMulti ]]; then
      kailCommand="kail $optionPods"
    fi

    echo "$kailCommand"
    eval "$kailCommand"
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



