# figure out when certs expire
function sslcertexpire() {
  openssl s_client -servername "$1" -connect "$1:$2" | openssl x509 -noout -dates
}

# grabbing certs from websites via sslgetcert google.com:433
function sslcert() {
	/usr/bin/openssl s_client -connect "$1"
}

function sslpem() {
	/usr/bin/openssl x509 -in "$1" -text
}

# reading local cert
function sslread() {
  /usr/bin/openssl x509 -in "$1" -text -noout
}

function sslpublic() {
  echo "openssl x509 -noout -modulus -in $1"
  openssl x509 -noout -modulus -in "$1"
}

function sslprivate() {
  echo "openssl rsa -noout -modulus -in $1"
  openssl rsa -noout -modulus -in "$1"
}

function sslcsr() {
  openssl req -in "$1" -noout -text
}

# this means the cert can stand on it's own
function sslverify() {
  openssl verify "$1"
}

function ssllines() {

  echo -n "subject "
  openssl x509 -in "$1" -noout -subject

  echo -n "issuer "
  openssl x509 -in "$1" -noout -issuer

}
