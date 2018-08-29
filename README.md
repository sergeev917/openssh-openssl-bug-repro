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
note: running version OpenSSH_7.8p1, OpenSSL 1.0.2p  14 Aug 2018
[attempt #80] found a broken key (passphrase = 12345678):

+ env DISPLAY= SSH_ASKPASS=/bin/false ssh-keygen -y -f testkey
Load key "testkey": invalid format
+ set +o xtrace

-----BEGIN EC PRIVATE KEY-----
Proc-Type: 4,ENCRYPTED
DEK-Info: AES-128-CBC,D01D93355D0BEE3239F453E226104BB3

+YIWxiT+jyZMZEFNPfPjamywNvUSGhu4xVn2btbFXAoV8+xXF8BLJj8b/ql0QgJS
kMW0uYs43R/iuEF5k6bnnV2KqQYLFzmbKxvyWUbCbbXZ/pv+EwpaWxxGvB7IDone
1DBMfTUx5y/MHB5Qt8UNXCHc/5yhgKMRHju5q6arUKFlEKqvbyuZaYX1FKj8oSun
h8bImImAPWDcc5oWYhZ5vwm/bKJS9O3T6F0gUsmohUcdGauoCtKSe3hTwEY+YFWs
G9wWz1cco4EJlko2uZBSL1olrgO/usdYe0AHvMri0RU=
-----END EC PRIVATE KEY-----
================================================================================
================================================================================
trying failed key with openssl-1.0.2o

+ ssh -V
OpenSSH_7.8p1, OpenSSL 1.0.2o  27 Mar 2018
+ env DISPLAY= SSH_ASKPASS=/bin/false ssh-keygen -y -f ./unloadable_1.0.2p.key
Load key "./unloadable_1.0.2p.key": incorrect passphrase supplied to decrypt private key
+ :
+ ssh-keygen -p -P 12345678 -N '' -f ./unloadable_1.0.2p.key
Your identification has been saved with the new passphrase.
+ set +o xtrace
================================================================================
================================================================================
note: running version OpenSSH_7.8p1, OpenSSL 1.0.2o  27 Mar 2018
[attempt #428] found misleading message (passphrase = 12345678):

+ ssh-keygen -p -P x -N y -f testkey
Failed to load key testkey: invalid format
+ set +o xtrace

+ ssh-keygen -p -P 12345678 -N '' -f testkey
Your identification has been saved with the new passphrase.
+ set +o xtrace

-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAArAAAABNlY2RzYS
1zaGEyLW5pc3RwNTIxAAAACG5pc3RwNTIxAAAAhQQB5FDj6T4ULlq1ecu8akvD2BSPynzV
qVNb21daDGs0nLkLCYFOWN4LdglUYRAea0gQrKDpYKlXKP1xrCWjWHOazYwBTfpkGl8t+d
LelmFc3pA8ERa8yAVcyMdFUD/fmYcPuS/pV9HlIJGgaDCsN8UvjkM4pRFgJTsmAIDbeG7i
9AT88Z8AAAEAEkf9zRJH/c0AAAATZWNkc2Etc2hhMi1uaXN0cDUyMQAAAAhuaXN0cDUyMQ
AAAIUEAeRQ4+k+FC5atXnLvGpLw9gUj8p81alTW9tXWgxrNJy5CwmBTljeC3YJVGEQHmtI
EKyg6WCpVyj9cawlo1hzms2MAU36ZBpfLfnS3pZhXN6QPBEWvMgFXMjHRVA/35mHD7kv6V
fR5SCRoGgwrDfFL45DOKURYCU7JgCA23hu4vQE/PGfAAAAQgD7RyoxpNF/PrVzija/azUO
lF2rtCDKZT4f5R59ULu0eQk9hjw8YXoFh/P1EHGPTv9WErPxti+hr4W0Kf16NiAwowAAAA
ABAg==
-----END OPENSSH PRIVATE KEY-----
================================================================================
```
