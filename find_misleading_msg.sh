#!/bin/bash
set -o errexit

readonly tmp_path=$(mktemp --directory)
function cleanup { [[ ! -z "$tmp_path" ]] && rm -r "$tmp_path"; }
trap cleanup EXIT

cd "${tmp_path}"
for ((i=0;i<2000;++i)); do
    ssh-keygen -t ecdsa -b 521 -N "12345678" -m PEM -f testkey 1>/dev/null
    if ssh-keygen -p -P x -N y -f testkey 0<&- 2>&1 | grep -q invalid; then
        cp testkey testkey.orig
        if ssh-keygen -p -P "12345678" -N "" -f testkey 0<&- 2>&1 | grep -q "saved with the new"; then
            cp testkey.orig testkey
            echo -n "note: running version "; ssh -V
            echo "[attempt #$i] found misleading message (passphrase = 12345678):"
            echo; set -o xtrace; ssh-keygen -p -P x -N y -f testkey 0<&- 2>&1 && :; set +o xtrace
            echo; set -o xtrace; ssh-keygen -p -P "12345678" -N "" -f testkey 0<&- 2>&1 || :; set +o xtrace
            set +o xtrace
            echo; cat testkey
            exit 0
        fi
    fi
    rm ./testkey*
done
echo "[!] no misleading key load messages in $i tries"
