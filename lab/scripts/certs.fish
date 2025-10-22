# figure out when certs expire
function sslcertexpire
  openssl s_client -servername "$1" -connect "$1:$2" | openssl x509 -noout -dates
end

# grabbing certs from websites via sslgetcert google.com:433
function sslcert
	/usr/bin/openssl s_client -connect "$1"
end

function sslpem
	/usr/bin/openssl x509 -in "$1" -text
end

# reading local cert
function sslread
  /usr/bin/openssl x509 -in "$1" -text -noout
end

function sslpublic
  echo "openssl x509 -noout -modulus -in $1"
  openssl x509 -noout -modulus -in "$1"
end

function sslprivate
  echo "openssl rsa -noout -modulus -in $1"
  openssl rsa -noout -modulus -in "$1"
end

function sslcsr
  openssl req -in "$1" -noout -text
end

# this means the cert can stand on it's own
function sslverify
  openssl verify "$1"
end

function ssllines

  echo -n "subject "
  openssl x509 -in "$1" -noout -subject

  echo -n "issuer "
  openssl x509 -in "$1" -noout -issuer

end

