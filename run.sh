#!/bin/bash
set -o errexit
cd "$(dirname "${BASH_SOURCE[0]}")"

readonly image_id_path=$(mktemp)
function cleanup { [[ ! -z "$image_id_path" ]] && rm "$image_id_path"; }
trap cleanup EXIT

docker build --iidfile="${image_id_path}" .
echo "=== IMAGE ID: ${image_id_path}: $(< "${image_id_path}") ==="
docker run -it --rm $(< "${image_id_path}")
