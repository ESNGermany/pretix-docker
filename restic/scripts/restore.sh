while ! pg_isready -h postgres -q; do
  sleep 1
done

restic dump --tag db latest db.dump | pg_restore
restic restore --tag app latest --target /app
