#!/bin/bash
set -o errexit
cd "$(dirname "${BASH_SOURCE[0]}")"
docker build --tag openssh-bug-reproducer .
docker run -it --rm openssh-bug-reproducer
