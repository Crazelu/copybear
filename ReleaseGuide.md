# Releasing a CopyBear Update

CopyBear ships in-app updates with [Sparkle](https://sparkle-project.org). Updates are
authenticated solely by the EdDSA key (the app is ad-hoc signed), so every release zip
must be signed with the private key in your login Keychain (created by `generate_keys`).
If that key is lost, existing installs can never update again — keep a backup
(`generate_keys -x <file>`) somewhere safe and never commit it.

Sparkle's tools live in the package checkout:

```
SPARKLE_BIN="$(find ~/Library/Developer/Xcode/DerivedData -path '*artifacts/sparkle/Sparkle/bin' -maxdepth 6 | head -1)"
```

## Per-release steps

1. **Bump versions** in the CopyBear target:
   - `MARKETING_VERSION` (e.g. `2.2`) — what users see.
   - `CURRENT_PROJECT_VERSION` (build number) — **must strictly increase every release**;
     Sparkle compares this value, not the marketing version.

2. **Archive and zip the app** (Release build):

   ```sh
   xcodebuild -project CopyBear.xcodeproj -scheme CopyBear -configuration Release \
     -archivePath build/CopyBear.xcarchive archive
   ditto -c -k --sequesterRsrc --keepParent \
     build/CopyBear.xcarchive/Products/Applications/CopyBear.app CopyBear-2.2.zip
   ```

3. **Generate the signed appcast entry.** Put the zip in a folder (e.g. `build/releases/`)
   and run:

   ```sh
   mkdir -p build/releases && mv CopyBear-2.2.zip build/releases/
   "$SPARKLE_BIN/generate_appcast" build/releases \
     --download-url-prefix "https://github.com/Crazelu/copybear/releases/download/2.2/" \
     -o appcast.xml
   ```

   This signs the zip with the Keychain key and writes/updates `appcast.xml` in the repo
   root. The `--download-url-prefix` must match the GitHub release tag you're about to
   create. Keeping older zips in `build/releases/` preserves their entries and enables
   delta updates.

4. **Publish — order matters:**
   1. Create the GitHub release with tag `2.2` and upload `CopyBear-2.2.zip` as an asset.
   2. Only after the asset is live, commit and push the updated `appcast.xml` to `main`
      (the app reads `https://raw.githubusercontent.com/Crazelu/copybear/main/appcast.xml`).

## Testing an update end-to-end

1. Build the app with a *lower* `CURRENT_PROJECT_VERSION` than the appcast advertises
   and launch it.
2. Trigger the banner without waiting for the scheduled check: temporarily set
   `defaults write com.devcrazelu.CopyBear SUScheduledCheckInterval 60`, or just
   relaunch — Sparkle checks shortly after launch when a check is due.
3. Verify: banner appears in the popover → Update shows Sparkle's UI → install →
   app relaunches as the new version (check the version in the menu bar right-click menu).
4. Reset test state with `defaults delete com.devcrazelu.CopyBear SUScheduledCheckInterval`.
