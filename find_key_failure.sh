#!/bin/bash
set -o errexit

readonly tmp_path=$(mktemp --directory)
function cleanup { [[ ! -z "$tmp_path" ]] && rm -r "$tmp_path"; }
trap cleanup EXIT

cd "${tmp_path}"
for ((i=0;i<2000;++i)); do
    ssh-keygen -t ecdsa -b 521 -N "12345678" -m PEM -f testkey 1>/dev/null
    if env DISPLAY= SSH_ASKPASS=/bin/false ssh-keygen -y -f testkey 0<&- 2>&1 | grep -q invalid; then
        echo -n "note: running version "; ssh -V
        echo "[attempt #$i] found a broken key (passphrase = 12345678):"
        echo "12345678" > passphrase
        echo; set -o xtrace;
        env DISPLAY= SSH_ASKPASS=/bin/false ssh-keygen -y -f testkey 0<&- 2>&1 && :
        openssl ec -noout -text -in testkey -passin "file:./passphrase" && :
        set +o xtrace; echo
        cat testkey
        exit 0
    fi
    rm ./testkey*
done
echo "[!] no unloadable keys in $i tries"
