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
[attempt #401] found a broken key (passphrase = 12345678):

+ env DISPLAY= SSH_ASKPASS=/bin/false ssh-keygen -y -f testkey
Load key "testkey": invalid format
+ openssl ec -noout -text -in testkey -passin file:./passphrase
read EC key
Private-Key: (521 bit)
priv:
    67:10:72:5d:86:63:a2:21:9f:0c:78:a6:ce:3c:32:
    35:ef:65:46:eb:65:a6:7b:4c:44:fb:d5:73:44:c7:
    c5:d4:3b:32:59:75:8a:28:98:65:c7:05:be:b7:fd:
    f5:bb:a0:0e:cd:2a:86:2c:b3:fe:ce:50:12:72:8a:
    34:1f:25:60:12
pub:
    04:01:b3:97:12:e2:4f:98:5c:00:b3:05:6c:05:f3:
    52:a4:68:49:f6:24:2d:fe:ca:d4:bb:d2:17:89:c3:
    a5:ff:41:e1:32:4b:72:48:da:3b:ea:eb:d8:52:e1:
    01:3d:05:61:bc:cc:63:3a:07:45:bc:4c:85:2f:89:
    80:dc:1b:8c:4f:dd:6b:01:23:d3:cb:0e:61:ef:2c:
    f7:5b:ba:8e:e2:fe:c3:d7:78:0d:01:7c:d7:fb:9b:
    e3:bd:df:2a:32:e9:82:86:a6:3c:0c:0c:be:66:b9:
    7b:86:d3:89:e2:ef:7e:d5:f4:d2:e1:e9:e1:e8:37:
    fc:af:56:dc:9c:88:09:fc:6f:c9:17:36:f7
ASN1 OID: secp521r1
NIST CURVE: P-521
+ :
+ set +o xtrace

-----BEGIN EC PRIVATE KEY-----
Proc-Type: 4,ENCRYPTED
DEK-Info: AES-128-CBC,0883187A99FEF847EC8DBBEB3F3F5FBC

+TUjAkus5ipfi2xI5S88J8DK2ntXnmZNJdQ91MgzquIrQ1AN+ZMHZS0E+GMopsXQ
UAIAbePDbs+Yx+35BAYGp03jXpsFb8zNSLYzmOWE6rB7IapZZj9Z4yVzJQzOUVSL
bPsS2SxrS6BhnHXuPdVfrt7BAyDc8MTcrRx98zsCbjff7zaNKJ4LZ8SK9TVNyOP5
D7ub6trACSYo5sGglLX1i6X+mFVBZhbZb+ObakwVgme4lYhj2nF2vpNOzVu7WuQa
foT5bfg6zilE9alcs2r7R7R/fA9r/TzpWelFLj7tjDU=
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
[!] no misleading key load messages in 2000 tries
================================================================================
```
