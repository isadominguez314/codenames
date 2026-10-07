#!/usr/bin/env bash
set -eu

mkdir -p .elm-bin
rm -f .elm-bin/elm .elm-bin/elm.gz

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
if ! gzip -t .elm-bin/elm.gz; then
  echo "Downloaded Elm archive was corrupt or incomplete" >&2
  exit 1
fi

gzip -dc .elm-bin/elm.gz > .elm-bin/elm
chmod +x .elm-bin/elm

if ! file .elm-bin/elm | grep -Eiq 'ELF|Mach-O'; then
  echo "Downloaded Elm binary is invalid for this platform" >&2
  exit 1
fi

export PATH="$PWD/.elm-bin:$PATH"
