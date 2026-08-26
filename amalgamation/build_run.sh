#!/bin/sh
set -e

VERSION="${1:-v4.18.0}"
DIR=$(cd "$(dirname "$0")" && pwd)
OUT="$DIR/out"
IMAGE=sqlcipher-amalg

echo "=== SQLCipher amalgamation: $VERSION ==="

rm -rf "$OUT"
mkdir -p "$OUT"

docker build -t "$IMAGE" --build-arg SQLCIPHER_VERSION="$VERSION" "$DIR"

docker run --rm \
    -v "$OUT:/out" \
    -e HOST_UID="$(id -u)" \
    -e HOST_GID="$(id -g)" \
    -e EXPECT_VERSION="$VERSION" \
    "$IMAGE" \
    sh -c 'set -e
           rm -f sqlite3.c sqlite3.h sqlcipher.VERSION
           ./create_amalgamation.sh
           grep -q "SQLCiper version: $EXPECT_VERSION" sqlcipher.VERSION || {
               echo "ERROR: version mismatch"; cat sqlcipher.VERSION; exit 1; }
           cp sqlite3.c sqlite3.h sqlcipher.VERSION /out/
           chown "$HOST_UID:$HOST_GID" /out/sqlite3.c /out/sqlite3.h /out/sqlcipher.VERSION'

echo
echo "=== done ==="
cat "$OUT/sqlcipher.VERSION"
ls -l "$OUT"