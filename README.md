# AngelSkies TV - Roku channel

SceneGraph channel built from Roku's Hello World sample. Each of the 13 AngelSkies nodes is its own row; videos come from `feed/feed.json` (later the Cloudflare node-feed endpoint - edit `source/config.brs`).

## Run it on your Roku
1. On the Roku remote press Home x3, Up x2, Right, Left, Right, Left, Right to enable Developer Mode and set a password.
2. Zip the repo contents (manifest at the zip root, not inside a folder).
3. Open `http://<roku-ip>` in a browser, log in as `rokudev`, upload the zip, click Install.

## Add videos
Add entries under a node's `videos` in `feed/feed.json` (title, description, thumbnail, url, streamFormat: mp4/hls).

## Publish
Create a free Roku developer account at https://developer.roku.com, then submit the zip as a new channel.
