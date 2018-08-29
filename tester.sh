#!/bin/bash
set -o errexit
cd "$(dirname "${BASH_SOURCE[0]}")"
function print_line() { printf '=%.0s' {1..80}; echo; }

print_line
cp -f ./openssh_openssl_1_0_2p/{ssh,ssh-keygen} /usr/local/bin/
cp -f ./openssh_openssl_1_0_2p/libcrypto.so.1.0.0 /usr/local/lib/
./find_key_failure.sh 2>&1 | tee ./key_failure_1.0.2p.log
print_line

cat ./key_failure_1.0.2p.log | \
sed -n '/^-----BEGIN/,/^-----END/p' > ./unloadable_1.0.2p.key
chmod 600 ./unloadable_1.0.2p.key

print_line
echo "trying the failed key with openssl-1.0.2o"
cp -f ./openssh_openssl_1_0_2o/{ssh,ssh-keygen} /usr/local/bin/
cp -f ./openssh_openssl_1_0_2o/libcrypto.so.1.0.0 /usr/local/lib/
echo; set -o xtrace
ssh -V
env DISPLAY= SSH_ASKPASS=/bin/false ssh-keygen -y -f ./unloadable_1.0.2p.key 0<&- 2>&1 || :
ssh-keygen -p -P "12345678" -N "" -f ./unloadable_1.0.2p.key 0<&- 2>&1 || :
set +o xtrace
print_line

print_line
cp -f ./openssh_openssl_1_0_2o/{ssh,ssh-keygen} /usr/local/bin/
cp -f ./openssh_openssl_1_0_2o/libcrypto.so.1.0.0 /usr/local/lib/
./find_misleading_msg.sh 2>&1 | tee ./misleading_msg_1.0.2o.log
print_line
