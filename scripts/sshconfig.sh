function fconf() {
  export searchExpression=""
  export host_only="false"
  while [ "$1" ]
  do
    if [ "$1" = "-h" ]
    then
      export host_only="true"
    else
      export searchExpression="$searchExpression.*$1"
    fi
    shift
  done
  #export searchExpression="Host.*$searchExpression.*"
  export searchExpression="$searchExpression.*"
  echo "$searchExpression"
  if [ "$host_only" = "true" ]
  then
    grep -i -B 1 -A 5 $searchExpression ~/.ssh/config | grep -i "Host "
  else
    grep -i -B 1 -A 5 $searchExpression ~/.ssh/config
  fi
}

function sshaskpassword() {
  ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no ${@}
}
