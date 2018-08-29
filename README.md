### Reproducer for openssh/openssl key loading bug

The reproducer uses docker to ensure clean and stable environment for tests.
Use `run.sh` to perform docker image build (openssl and openssh are compiled
from sources) and run search for key loading failures.

In the end it should look like:

```
$ ./run.sh

<...>

Successfully tagged openssh-bug-reproducer:latest
================================================================================
note: running version OpenSSH_7.7p1, OpenSSL 1.0.2p  14 Aug 2018
[attempt #185] found a broken key (passphrase = 12345678):

+ env DISPLAY= SSH_ASKPASS=/bin/false ssh-keygen -y -f testkey
Load key "testkey": invalid format
+ set +o xtrace

-----BEGIN EC PRIVATE KEY-----
Proc-Type: 4,ENCRYPTED
DEK-Info: AES-128-CBC,8E3B8BDCD15563C5F9FB8F3BFEF19D4F

8pMGtk3NhfXvg4cIqlKN3Lutco26hrm+BQSvYqQmiK5TPsHz0pob2e7u7VT8X/P5
bTw8tJE626FxrMuK98Ow/jPbT2kkwlohOQ1KCK7B27Xn6div8P/9r0YMvvswRZUU
uA3hLVrziDLkz0/T4Nm2+Azq6Rhtl/EoEHO3Kp7G3Sulvzzz2DSnxxSSWL5AzN1Q
3JwijvUQsiORx2O4hQAFhGWz1rSI9T6EV0jbGWIO/egjgqDjcgeOFSk8fY4tUIRx
h3X+MxO0nqdKuz1SmYYm8NGCZMnSfbAd0pMSE6N2RJU=
-----END EC PRIVATE KEY-----
================================================================================
================================================================================
trying the failed key with openssl-1.0.2o

+ ssh -V
OpenSSH_7.7p1, OpenSSL 1.0.2o  27 Mar 2018
+ env DISPLAY= SSH_ASKPASS=/bin/false ssh-keygen -y -f ./unloadable_1.0.2p.key
Load key "./unloadable_1.0.2p.key": incorrect passphrase supplied to decrypt private key
+ :
+ ssh-keygen -p -P 12345678 -N '' -f ./unloadable_1.0.2p.key
Your identification has been saved with the new passphrase.
+ set +o xtrace
================================================================================
================================================================================
note: running version OpenSSH_7.7p1, OpenSSL 1.0.2o  27 Mar 2018
[attempt #56] found misleading message (passphrase = 12345678):

+ ssh-keygen -p -P x -N y -f testkey
Failed to load key testkey: invalid format
+ set +o xtrace

+ ssh-keygen -p -P 12345678 -N '' -f testkey
Your identification has been saved with the new passphrase.
+ set +o xtrace

-----BEGIN EC PRIVATE KEY-----
MIHcAgEBBEIB6AbY5ou0vu0YdW374B9zJcu7DyFMLNj124/voJk1I8ax2GYssbQQ
yCy3qZGSEZP2Hj7soswILwzFVK3M98LZFVSgBwYFK4EEACOhgYkDgYYABAEWmqJ7
gtCBM3BVxjYdZacsmnoAW21fqLodXYW1cyn0zROoAWZbjPatcMPmaEbeNTuMnjKM
cF72y20xboeYIauLAgEfvxYIX81IsVEjChZLKzhxELXnSIMHRE5OcqwwlmFW6P9j
ppEnIGm2Gpv6stij/vbUK2x0SpVDL+Y9kG1rF1FPMQ==
-----END EC PRIVATE KEY-----
================================================================================
```
