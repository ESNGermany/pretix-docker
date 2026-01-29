while ! pg_isready -q; do
  echo "Postgres is not ready yet…"
  sleep 1
done

restic dump --tag db latest db.dump | pg_restore -d "$PGDATABASE"
restic restore --tag app latest --target /app
