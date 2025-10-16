# USAGE: this is kube filter using the filter command
# Function kl works in conjuction with kfilter"
# kfilter (kf): tells you what namespaces to filter you want auth / mysql / ... etc.  It can take many"
#

#alias kdel="k delete"
#alias kdeld="k delete deployment"
#alias kdeli="k delete ing"
#alias kdelp="k delete pod"
#alias kdels="k delete svc"
#alias kpoa_name="k get pods -o yaml --all-namespaces | grep -i \"name:\|namespace:\""


#set -gx K_DEFAULTS "catalog>\\|evenue-nextjs\\|graphql-consumer\\|api-orch\\|cdb-manager"
set -gx K_ALL_NAMESPACES "--all-namespaces"
set -gx K_MAX_LOG_REQUEST "--tail 0 --max-log-requests=10000"
set -gx K_TEMPLATE "--template \"\x1b[32m{{.PodName}}\x1b[0m \x1b[36m{{.ContainerName}}\x1b[0m \x1b[31m{{.Message}}\x1b[0m {{\\\"\n\\\"}}\""
set -gx K_TEMPLATE ""
set -gx K_EXCLUDE ""
set -gx K_FILTERCONFIG ~/.kube/.kubefilter

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
alias kf="kfilter"
alias kg="k get"
alias kgo="k get -o yaml"
alias ki="k get ing"
alias kinfo="k cluster-info && klinfo"
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

# getting info
alias klinfo="kl -info"

# disable both environment / defaults
alias klall="kl -nofilter"

# misc
alias klc="kl -c"
alias klf="kl -f"
alias klfc="kl -f -c"

# misc
alias klsc="kl -c"
alias klsf="kl -f"
alias klsfc="kl -f -c"


# kps --show-labels --selector app=redis
# list all roles
# to get selector
#alias ksa="k  get clusterrole,rolebindings,clusterrolebindings --all-namespaces -o custom-columns='KIND:kind,NAMESPACE:metadata.namespace,NAME:metadata.name,SERVICE_ACCOUNTS:subjects[?(@.kind=="ServiceAccount")].name'"
#alias ksa="k get rolebindings,clusterrolebindings --all-namespaces -o custom-columns='KIND:kind,NAMESPACE:metadata.namespace,NAME:metadata.name,SERVICE_ACCOUNTS:subjects[?(@.kind==\"ServiceAccount\")].name'"
#alias ksa="k get serviceaccounts --all-namespaces"


function kgetfilter

  set --local defaults ''
  
  # env / pod / all
  set --local modeTarget ''
  set --local key ''

  while test (count $argv) -gt 0

    set key "$argv[1]"
    set argv $argv[2..-1]

    switch "$key" 

      case '-m' 
        set modeTarget "$argv[1]" 
        set argv $argv[2..-1]
        

    end

  end

  for iDefault in $(cat $K_FILTERCONFIG )


    if string match -iq "*env*" $modeTarget

      if echo "$iDefault" | grep -iqv "dev\|prod\|qfn\|auto"
        continue
      end

    else if string match -iq "*pod*" $modeTarget

      if echo "$iDefault" | grep -iq "dev\|prod\|qfn\|auto"
        continue
      end

    end

    if [ $defaults ]
      set defaults "$defaults|$iDefault"
    else
      set defaults "$iDefault"
    end

  end

  echo -n "$defaults"

end

# set default environments to look after
# do not set default namespace when using this 
function kfilter

  set --local key ''

  while test (count $argv) -gt 0

    set key "$argv[1]"
    set argv $argv[2..-1]

    switch "$key" 

      case '-r' # empty file
        echo -n "" > $K_FILTERCONFIG
        

      case '-d' # delete a setting
        sed  -i "" "/$argv[1]/d" $K_FILTERCONFIG
        set argv $argv[2..-1]
        
      case '*'
        
        # if it's an environment
        if echo "$key" | grep -iq "dev\|prod\|qfn\|auto"
          echo "$key" >> $K_FILTERCONFIG
        else
          echo "$key" | cat - $K_FILTERCONFIG > /tmp/kube
          cp /tmp/kube $K_FILTERCONFIG
        end

    end

  end

  cat $K_FILTERCONFIG

end

# connect to service
function ksforward
  echo "kubectl port-forward service/<service name> 3000:80"
end

# connect to ingress
function kiforward
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
end

# change kubernetes config file aka different clusters
function kcon
  set KUBE_DIRECTORY ~/.kube
  echo "Current context $(kubectl config current-context)"

  if test (count $argv) -lt 1
#    for kConfig in $(ls -l $KUBE_DIRECTORY/config* | awk '{print $NF}')
    for targetConf in $(ls ~/.kube/config.*)
      if cmp -s "$targetConf" ~/.kube/config
        echo "🯁🯂🯃 $targetConf"
      else
        echo "$targetConf"
      end
    end
  else
    set CURRENTTIME $(date +"%y%m%d%H%M")
    ls $KUBE_DIRECTORY/config.$argv[1]
    if [ -f $KUBE_DIRECTORY/config.$argv[1] ]
      echo "Replacing config with config.$argv[1]"
      #cp $KUBE_DIRECTORY/config $KUBE_DIRECTORY/config.$CURRENTTIME
      cp $KUBE_DIRECTORY/config.$argv[1] $KUBE_DIRECTORY/config
    else
      echo "File $KUBE_DIRECTORY/config.$argv[1] does not exists"
    end
  end

end

# change node / or namespace default context
function kns

  set --local findN ""

  set --local modeContext ''

  while test (count $argv) -gt 0

    set key "$argv[1]"
    set argv $argv[2..-1]

    switch  "$key" 

      case '-n' 
        k config use-context $argv[1]
        set argv $argv[2..-1]
        
      case '-c' 
        set modeContext 't'
        
      case '*' 
        set findN "$findN$key.*"
        

    end

  end

  set --local kspaces $(k get namespace --all-namespaces | grep -i "$findN")

  if [ $modeContext ]

    set --local spaceTarget $(echo "$kspaces" | grep -i "$findN" | head -n 1 | awk '{print $(NF-2)}')
    k config set-context --current --namespace=$spaceTarget
#    echo -n "$spaceTarget" > $FILE_KUBE_CONTEXT

  end

  k get namespace --all-namespaces | grep -i "$findN"
  k config get-contexts
end

function knodes
  kubectl get nodes
  if test (count $argv) -gt 0
    if test (count $argv) -gt 1
      kubectl get pods -o wide --field-selector spec.nodeName="$argv[1]" $argv[2..-1]
    else
      echo "second"
      kubectl get pods --all-namespaces -o wide --field-selector spec.nodeName=$argv[1]
    end
  end
end

# list all ip's
function kips
    k get pods -o=jsonpath="{range .items[*]}{.status.podIP}{','}{end}" --all-namespaces
    #k get pod -o wide --all-namespaces
end

function kexec
    kubectl exec -it -n $argv[1] $argv[2] $argv[3]
end

function kssh
    set podsAll $(kpo)
    set podName ""
    set shellType "bash"
    if test (count $argv) -gt 0
        set podName "$argv[1]"
    end
    if test (count $argv) -gt 1
        set shellType "$argv[2]"
    end
    echo "looking for *$podName*\n"
    echo "$podsAll\n"
    set ksshFound "f"
    # replace
    for currentPod in $(echo "$podsAll" | sed 's/:/\n/g')
       if [ "$ksshFound" = "f" ] 
         and string match -iqr "*$podName*" $currentPod
           k exec -it $currentPod -- $shellType
           set ksshFound "t"
       end
    end
end

function kl

  set --local modeCopy ''
  set --local modeConfig ''
  set --local modeFileoutput ''
  set --local modeDefault 't'
  set --local modeGrep ''

  set --local key ''

  while test (count $argv) -gt 0

    set key "$argv[1]"
    set argv $argv[2..-1]

    switch  "$key" 

      case '-help' 
        echo "Function kl works in conjuction with kfilter"
        echo "kfilter: tells you what namespaces to filter you want auth / mysql / ... etc.  It can take many"
        return
        
      case '-a' 
        set modeDefault ''
        
      case '-c'
        set modeCopy 't' 

      case '-kconf' 
        set modeConfig "$argv[1]"
        set argv $argv[2..-1]
        
      case '-f' 
        set modeFileoutput 't' 

      case '-nofilter'
        set modeDefault '' 
      case '-info'

        kcon
        echo "filters:"
        kfilter
        return
        
      case '-g'
        
        set modeGrep "$argv[1]"
        set argv $argv[2..-1]

    end

  end

  set --local optionPods ''
  set --local selectValues ''
  set --local kpSelect ''
  set --local kpSelectAll ''

  # set kpSelect $(kpo)
  set kpSelect (kpoa | string collect)

#  echo "$kpSelect"

  set --local kFilter ''
  set kFilter $(kgetfilter)

#  becho "defaults: $kFilter"

  # filter out by defaults
  if [ $modeDefault ]
    echo "in default"
    # return
    set kFilter (kgetfilter -m 'env')
    set kpSelect (echo -e "$kpSelect" | grep -i "$kFilter" | string collect)
    
    set kFilter (kgetfilter -m 'pod')
    set kpSelect (echo -e "$kpSelect" | grep -i "$kFilter" | string collect)

  end

#  becho "\n$kpSelect"
  if [ $modeConfig ]

    if [ ! -f ~/.kube/config.$modeConfig ]
      becho "Does not exists ~/.kube/config.$modeConfig"
      becho "Rejecting and reverting"
      sleep 1
    end

  end

  set kpSelectAll (echo -e "all\n$kpSelect" | string collect) 

  set --local searchPrompt (kgetfilter)
  set searchPrompt "Filter:($searchPrompt)"


  echo "working?"
  echo -e "$kpSelectAll"
  set selectValues (echo -e "$kpSelectAll" | fzf --multi --prompt="$searchPrompt>" | string collect)
  echo "working?"

  if test $status -eq 0 # pressed enter so do everything

    if [ "all" =  "$selectValues" ] # see if select all is enabled
      set selectValues $kpSelect
    end
  end

  echo -e "selectValues |$selectValues|"
  for iPod in (echo -e "$selectValues")

    echo "setting pod |$iPod|"
    set iPod $(echo "$iPod" | awk -F'>' '{print $2}')
    # echo "setting pod "

    if [ $optionPods ]
      set optionPods "$optionPods|$iPod"
    else
      set optionPods "$iPod"
    end

  end


  set --local copyDir ''
  if [ $optionPods ]

#    set --local logCommand "kail $optionPods"
    set --local logCommand "stern "
    if [ $modeConfig ]

      if [ ! -f ~/.kube/config.$modeConfig ]
        becho "Does not exists ~/.kube/config.$modeConfig"
        becho "Rejecting and reverting"
      end
      set logCommand "$logCommand --kubeconfig ~/.kube/config.$modeConfig"

    end

    set logCommand "$logCommand --all-namespaces \"$optionPods\" $K_TEMPLATE $K_MAX_LOG_REQUEST"


    if [ $modeGrep ]

      set logCommand "$logCommand | grep -i \"$modeGrep\""
      becho "log command $logCommand"

    end

    set --local hashDir ''

    if [ $modeFileoutput ]
      set hashDir $(hashdir)
      set copyDir "/tmp/kail-$hashDir"
      set logCommand "$logCommand > $copyDir"
      
    end


    if [ $modeCopy ]
      echo "tailm $copyDir" | pbcopy
    end

    becho "$logCommand"
    eval "$logCommand"

  end

end

function hlsa

    k config get-contexts
    echo ""
    helm ls --all-namespaces

end

function hls
    k config get-contexts
    echo ""
    helm ls
end
