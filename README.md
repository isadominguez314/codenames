# codenames-green

Codenames Green is an app for playing the cooperative variant of the Codenames board game: Codenames Duet. It tries to implement the game faithfully, following the game's rules exactly.

Two or more players divide amongst the two sides, Side A and Side B. They alternate giving clues for their green words, trying to get the other side to guess the green words. The game is lost when either side chooses one of the black words. Players win when all green words on both sides are revealed.

[Play](https://www.codenamesgreen.com)

![Screenshot of gameplay](https://raw.githubusercontent.com/jbowens/codenamesgreen/master/screenshot.png)

## Implementation

Codenames Green is implemented as an Elm app, backed by a json API provided by a single-process Go daemon.

## Local development

This project is a legacy Elm + Go app, so the environment needs to match its historical toolchain.

1. Use Node 16.20.2:

   ```bash
   nvm install 16.20.2
   nvm use 16.20.2
   ```

2. Install frontend dependencies:

   ```bash
   npm install --ignore-scripts --legacy-peer-deps
   ```

   The `deasync` dependency is a legacy native package and may fail to build under newer Node versions or absent Apple SDK include paths. If you are on macOS and see `fatal error: 'atomic' file not found`, set the SDK include path before rebuilding or running the frontend build:

   ```bash
   export CPLUS_INCLUDE_PATH=/Library/Developer/CommandLineTools/SDKs/MacOSX15.2.sdk/usr/include/c++/v1
   ```

3. Install the Elm compiler version required by the repo:

   ```bash
   curl -L https://github.com/elm/compiler/releases/download/0.19.0/binary-for-mac-64-bit.gz -o /tmp/elm-0.19.0.gz
   gzip -dc /tmp/elm-0.19.0.gz > /tmp/elm-0.19.0
   chmod +x /tmp/elm-0.19.0
   sudo cp /tmp/elm-0.19.0 /usr/local/bin/elm
   ```

4. Build the frontend bundle:

   ```bash
   npx parcel build src/index.html
   ```

5. Run the Go API from the repo root:

   ```bash
   go build ./cmd/greenapid
   ./greenapid
   ```

   The daemon serves on port 8080 and expects the repo's `wordlists/` directory to be present.

## Deploy for live testing

To test the real back-and-forth gameplay from another device, you need a public backend.

The frontend is static, but the game state lives in memory inside the Go daemon. That means the backend must stay alive and be reachable from the internet.

### Recommended free setup

- Frontend: Cloudflare Pages or Netlify
- Backend: Render, Railway, Fly.io, or a small always-on VM
- API host: a public host such as `api.yourdomain.com`

The backend now honors the `PORT` environment variable and will also look for a `wordlists/` directory relative to the app binary if the current working directory is not the repo root.

### Render or Railway

This repo includes a Dockerfile, so the backend can be deployed as a container.

1. Push the repo to GitHub.
2. Create a new service on Render or Railway.
3. Set the build command to the default Docker build.
4. Set the runtime port to `PORT` (Render/Railway usually provide this automatically).
5. Tell the Elm frontend to call your public API URL instead of `localhost`.

For the frontend, the app already defaults to `localhost:8080` when `url.host == "localhost"` and otherwise uses `api.<current host>` in [src/Api.elm](src/Api.elm).

## Free deployment notes

This app is not a pure static site. The game state is kept in memory inside the Go process, so a free static host alone is not enough. The practical free setup is:

- Static frontend on a free host like Cloudflare Pages or Netlify
- Always-on Go backend on a free tier service or a tiny VM
- Browser API requests pointed to the backend host (for example `api.yourdomain.com`)

Because the backend is stateful and in-memory, the process must stay alive to keep active games available. This makes serverless or cold-start-free hosting a poor fit unless you add persistence and a different architecture.
