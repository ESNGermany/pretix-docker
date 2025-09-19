chown -R 15371:15371 ./app/data/
chown 15371:15371 ./app/pretix.cfg
docker compose run --rm --entrypoint sh restic -c "restic init"
docker compose run --rm init
docker compose up -d
