
# figure out when certs expire
sslgetcertexpire() {
  openssl s_client -servername $1 -connect $1:$2 | openssl x509 -noout -dates
}

# grabbing certs from websites via sslgetcert google.com:433
sslgetcert() {
	/usr/bin/openssl s_client -connect $1
}

sslpem() {
	/usr/bin/openssl x509 -in $1 -text
}

# reading local cert
sslread() {
  /usr/bin/openssl x509 -in $1 -text -noout
}
