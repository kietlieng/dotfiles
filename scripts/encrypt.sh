function encrypt() {
  if [ "$1" ]
  then
    /usr/bin/openssl des3 -in $1 -out "$1.enc"
    /bin/mv "$1.enc" $1
  fi
}

function decrypt() {
  if [ "$1" ]
  then
    /usr/bin/openssl des3 -d -in $1
  fi
}
