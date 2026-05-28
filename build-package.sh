#!/usr/bin/env bash
# build-package.sh — Build nginx binary tar.gz package locally using Docker
#
# Output: dist/nginx-1.30.2-linux-amd64.tar.gz
# Deploy:
#   tar -C /usr/local -xzf dist/nginx-1.30.2-linux-amd64.tar.gz
#   sudo /usr/local/nginx/install.sh
#   sudo /usr/local/nginx/sbin/nginx
set -euo pipefail

NGINX_VER="${NGINX_VER:-1.30.2}"
DIST_DIR="$(cd "$(dirname "$0")" && pwd)/dist"
OUTPUT="${DIST_DIR}/nginx-${NGINX_VER}-linux-amd64.tar.gz"

echo "==> Building nginx ${NGINX_VER} binary package (linux/amd64) ..."
echo "    Output: ${OUTPUT}"
echo ""

mkdir -p "${DIST_DIR}"

# Requires Docker with BuildKit enabled (Docker 20.10+)
docker buildx build \
    --platform linux/amd64 \
    -f Dockerfile.package \
    --build-arg NGINX_VER="${NGINX_VER}" \
    --output "type=local,dest=${DIST_DIR}" \
    .

echo ""
echo "==> Done! Package: ${OUTPUT}"
echo ""
echo "Deploy:"
echo "  tar -C /usr/local -xzf ${OUTPUT}"
echo "  sudo /usr/local/nginx/install.sh"
echo "  sudo /usr/local/nginx/sbin/nginx"
