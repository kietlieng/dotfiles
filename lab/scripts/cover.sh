function cover() {
  if [ "$1" ]
  then
    #/usr/bin/openssl des3 -in $1 -out "$1.enc"
    #openssl des3 -in $1 -out "$1.enc"
    openssl enc -aes-256-cbc -md sha512 -pbkdf2 -iter 1000000 -salt -in $1 -out "$1.enc"
    /bin/mv "$1.enc" $1
  fi
}

function uncover() {
  if [[ "$1" ]]; then
    #/usr/bin/openssl des3 -d -in $1
    #openssl des3 -d -in $1
    openssl enc -aes-256-cbc -md sha512 -pbkdf2 -iter 1000000 -salt -in $1 -d 
  fi
}
