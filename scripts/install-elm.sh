#!/usr/bin/env bash
set -eu

mkdir -p .elm-bin

if [ -x .elm-bin/elm ]; then
  exit 0
fi

case "$(uname -s)" in
  Darwin)
    url="https://github.com/elm/compiler/releases/download/0.19.0/binary-for-mac-64-bit.gz"
    ;;
  Linux)
    url="https://github.com/elm/compiler/releases/download/0.19.0/binary-for-linux-64-bit.gz"
    ;;
  *)
    echo "Unsupported OS for Elm install: $(uname -s)" >&2
    exit 1
    ;;
esac

curl -fsSL "$url" -o .elm-bin/elm.gz
gzip -dc .elm-bin/elm.gz > .elm-bin/elm
chmod +x .elm-bin/elm

export PATH="$PWD/.elm-bin:$PATH"
