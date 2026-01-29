docker compose run --rm --entrypoint sh restic /scripts/restore.sh
chown -R 15371:15371 ./app/data/
chown 15371:15371 ./app/pretix.cfg
