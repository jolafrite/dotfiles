#!/usr/bin/env bash
# Create the durable ~/.dsh files on the HOST if absent.
# Individual file bind-mounts fail when the source file is missing, so a
# fresh host must run this before `make start`. Idempotent: never overwrites
# an existing file, so credentials are safe.
set -eu pipefail

DIR="${HOME}/.config/dsh-docker/dsh"
mkdir -p "$DIR"

# mode 600 for the credential file; 644 for the rest
touch "$DIR/.credentials.yaml"
chmod 600 "$DIR/.credentials.yaml"

# JSON files: empty object, not empty file — a plugin that parses these
# would crash on a zero-byte file.
for f in .anonymous-user-id dsh-ssh.json pet.json skin-center-active.json settings.yaml.imported; do
  if [ ! -s "$DIR/$f" ]; then
    case "$f" in
      .anonymous-user-id|settings.yaml.imported)
        # plain text / YAML: empty is fine
        : > "$DIR/$f"
        ;;
      *)
        # JSON: write {} so parsers don't choke
        printf '{}' > "$DIR/$f"
        ;;
    esac
  fi
done

echo "DSH durable files ensured in $DIR"