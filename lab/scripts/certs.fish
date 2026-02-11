# figure out when certs expire
function sslcertexpire
  openssl s_client -servername "$argv[1]" -connect "$argv[1]:$argv[2]" | openssl x509 -noout -dates
	echo "Example sslcertexpire google.com 443"
end

# grabbing certs from websites via sslgetcert google.com:443
function sslcert
	/usr/bin/openssl s_client -connect "$argv[1]"
	echo "Example sslcert google.com:443"
end

# 
function sslcertread
	/usr/bin/openssl x509 -in "$argv[1]" -text
end

function sslcertmodulus
  openssl x509 -noout -modulus -in "$argv[1]"
  openssl x509 -noout -modulus -in "$argv[1]" | openssl md5
  echo -e "Find out the modulus of the large rsa number to verify private / public keys are the same."
  echo -e "Used for pem files not RSA keys"
	echo -e "openssl x509 -noout -modulus -in account1.signed.crt"
	echo -e "openssl x509 -noout -modulus -in account1.signed.crt | openssl md5"
end

function sslcertcsr
  openssl req -in "$argv[1]" -noout -text
	echo -e "sslcertcsr "
end

# this means the cert can stand on it's own
function sslverify
  openssl verify "$argv[1]"
  echo "sslverify account1.signed.crt"
end

function sslverifyCAFile
  openssl verify -CAfile "$argv[1]" "$argv[2]"
  echo -e "Verified against a CAFile that you want to custom reference certificate athority"
  echo -e "sslverifyCAFile ca-bundle.pem account1.signed.crt"
  echo -e "If you want to verify against system certificate authority and don't need to provide a CAfile."
	echo -e "try the sslverify command"
end

function sslverifybuildchain

	echo openssl verify -CAfile $argv[1] -untrusted $argv[2] -show_chain $argv[3]
	echo -e "sslverifybuildchain isrgrootx1.pem r12.pem account1.signe.crt"
	echo -e "or openssl verify -CAfile isrgrootx1.pem -untrusted r12.pem -show_chain account1.signe.crt"
	echo -e "openssl verify DOES NOT CHECK the order of the chain. So it could verify but not work properly on a server"
	echo -e "The build order should always be in tree analogy: leaf > branch > trunk"
	echo -e "- pem file"
	echo -e "-- server cert (leaf) test.paciolan.com"
	echo -e "-- intermediate cert (branch) intermediate issuer"
	echo -e "-- root cert (trunk) intermediate issuer"

end

function sslcertlines

  echo -n "subject "
  openssl x509 -in "$argv[1]" -noout -subject

  echo -n "issuer"
  openssl x509 -in "$argv[1]" -noout -issuer

end

