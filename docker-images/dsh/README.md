# DSH Docker

DSH running in a container. The host volume holds only durable user state;
everything else is ephemeral.

## What survives on the host (`~/.config/dsh-docker/dsh/`)

| File | Purpose |
|---|---|
| `.credentials.yaml` | API keys (mode 600) |
| `.anonymous-user-id` | Identity |
| `dsh-ssh.json` | SSH config |
| `pet.json` | UI pet prefs |
| `skin-center-active.json` | UI skin |
| `settings.yaml.imported` | Imported settings |

Total: < 2 KB.

## What is ephemeral (recreated every boot)

`sessions/`, `profiles/`, `logs/`, `storages/`, `.data/`, `.cache/`,
`dsh-usage/`, `dsh-session-archive/`, `remote-workspaces/`, `task-board/`.
These live in the container's overlay FS and are gone when the container is
removed.

**Consequence:** conversation history does not survive a container restart.
The session-persistence corruption bug (EBADF) cannot accumulate across
restarts because the files are gone with the container.

## Getting started

```bash
make bootstrap   # create durable files on a fresh host (idempotent)
make start       # build + start all services
make url         # print the GUI URL
```

## Maintenance

```bash
make restart     # restart the container (ephemeral data is lost)
make wipe-cache  # same as restart, with a clearer name
make clean-all   # remove container, images, and named volumes
```