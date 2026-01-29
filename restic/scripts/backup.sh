while ! pg_isready -q; do
  echo "Postgres is not ready yet…"
  sleep 1
done

restic backup --tag db --stdin-filename db.dump --stdin-from-command -- pg_dump -Fc
restic backup --tag app /data
