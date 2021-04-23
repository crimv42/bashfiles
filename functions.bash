# Random Password Generators
randpw(){ < /dev/urandom tr -dc 'a-zA-Z0-9-_@#$%^&*()_+{}:<>=' | head -c${1:-32};echo; }
saferandpw(){ < /dev/urandom tr -dc 'a-zA-Z0-9!@#$' | head -c${1:-32};echo; }
asciirandpw(){ < /dev/urandom tr -dc 'a-zA-Z0-9' | head -c${1:-32};echo; }

# Cert Decoder
decodecert(){ openssl x509 -in $1 -text -noout; }

# Network Functions
kubefwd(){ k port-forward svc/$1 $2:$( if [ ! -z "$3" ]; then echo $3; else echo $2; fi); }
headerchk() { curl -s -D - -o /dev/null $1; }
tlscheck() { nmap --script ssl-enum-ciphers -p 443 $1; }
