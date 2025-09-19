while ! pg_isready -h postgres -q; do
  sleep 1
done

restic dump --tag db latest dump.sql | psql -h postgres

restic restore --tag app latest --target /app
